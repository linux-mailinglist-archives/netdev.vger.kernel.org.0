Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F233E4E3F
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 23:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhHIVF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 17:05:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229516AbhHIVF2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 17:05:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8A6360231;
        Mon,  9 Aug 2021 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628543107;
        bh=M6dWNSR4WeAvv65gHUnFmzu3fgz1ckYhpeTjPCONyks=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gT8O63BZzZZnHgl3RM1ZRwjx8bs2lBi/GdB0Ioyz0SKxzPy8KQ2qG37YSl7FrTYep
         PIiOTFa9vjbb3o5TO2TvlVAD6GdG7/aUDyyh0N+OYtCYbxOokcvA0QgtY95Q9Vl05P
         uRUVk1oOpFXdizU3XvpGBvhTbIYPFM/kWagIcsokhMC2zLYAdzQZwZoGUnbqSFNOlR
         ueoUZcQbHAZeoIIj26hNg8H2laqsW6V6ra3qbGGbJGgEW4iRXqnKlzi4nfQpfzb0bO
         g8r+goI+2pD/DL3CzuwWkxIDC7rtukfrV9x8vMiiGILEHVR5zJXvzyLdzRrO5po2Sw
         IcUB/K8Jv7U9A==
Date:   Mon, 9 Aug 2021 14:05:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nicholas Richardson <richardsonnick@google.com>
Cc:     davem@davemloft.net, nrrichar@ncsu.edu, arunkaly@google.com,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Yejune Deng <yejune.deng@gmail.com>,
        Di Zhu <zhudi21@huawei.com>, Ye Bin <yebin10@huawei.com>,
        Leesoo Ahn <dev@ooseel.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] pktgen: Parse internet mix (imix) input
Message-ID: <20210809140505.30388445@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210809172207.3890697-2-richardsonnick@google.com>
References: <20210809172207.3890697-1-richardsonnick@google.com>
        <20210809172207.3890697-2-richardsonnick@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Aug 2021 17:22:02 +0000 Nicholas Richardson wrote:
> From: Nick Richardson <richardsonnick@google.com>
> 
> Adds "imix_weights" command for specifying internet mix distribution.
> 
> The command is in this format:
> "imix_weights size_1,weight_1 size_2,weight_2 ... size_n,weight_n"
> where the probability that packet size_i is picked is:
> weight_i / (weight_1 + weight_2 + .. + weight_n)
> 
> The user may provide up to 20 imix entries (size_i,weight_i) in this
> command.
> 
> The user specified imix entries will be displayed in the "Params"
> section of the interface output.
> 
> Values for clone_skb > 0 is not supported in IMIX mode.
> 
> Summary of changes:
> Add flag for enabling internet mix mode.
> Add command (imix_weights) for internet mix input.
> Return -ENOTSUPP when clone_skb > 0 in IMIX mode.
> Display imix_weights in Params.
> Create data structures to store imix entries and distribution.
> 
> Signed-off-by: Nick Richardson <richardsonnick@google.com>
> ---
>  net/core/pktgen.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 95 insertions(+)
> 
> diff --git a/net/core/pktgen.c b/net/core/pktgen.c
> index 7e258d255e90..83c83e1b5f28 100644
> --- a/net/core/pktgen.c
> +++ b/net/core/pktgen.c
> @@ -175,6 +175,8 @@
>  #define IP_NAME_SZ 32
>  #define MAX_MPLS_LABELS 16 /* This is the max label stack depth */
>  #define MPLS_STACK_BOTTOM htonl(0x00000100)
> +/* Max number of internet mix entries that can be specified in imix_weights. */
> +#define MAX_IMIX_ENTRIES 20
>  
>  #define func_enter() pr_debug("entering %s\n", __func__);
>  
> @@ -242,6 +244,12 @@ static char *pkt_flag_names[] = {
>  #define VLAN_TAG_SIZE(x) ((x)->vlan_id == 0xffff ? 0 : 4)
>  #define SVLAN_TAG_SIZE(x) ((x)->svlan_id == 0xffff ? 0 : 4)
>  
> +struct imix_pkt {
> +	__u64 size;
> +	__u64 weight;
> +	__u64 count_so_far;

no need for the __ prefix outside of uAPI.

> +};
> +
>  struct flow_state {
>  	__be32 cur_daddr;
>  	int count;
> @@ -343,6 +351,10 @@ struct pktgen_dev {
>  	__u8 traffic_class;  /* ditto for the (former) Traffic Class in IPv6
>  				(see RFC 3260, sec. 4) */
>  
> +	/* IMIX */
> +	unsigned int n_imix_entries;
> +	struct imix_pkt imix_entries[MAX_IMIX_ENTRIES];
> +
>  	/* MPLS */
>  	unsigned int nr_labels;	/* Depth of stack, 0 = no MPLS */
>  	__be32 labels[MAX_MPLS_LABELS];
> @@ -552,6 +564,16 @@ static int pktgen_if_show(struct seq_file *seq, void *v)
>  		   (unsigned long long)pkt_dev->count, pkt_dev->min_pkt_size,
>  		   pkt_dev->max_pkt_size);
>  
> +	if (pkt_dev->n_imix_entries > 0) {
> +		seq_printf(seq, "     imix_weights: ");
> +		for (i = 0; i < pkt_dev->n_imix_entries; i++) {
> +			seq_printf(seq, "%llu,%llu ",
> +				   pkt_dev->imix_entries[i].size,
> +				   pkt_dev->imix_entries[i].weight);
> +		}
> +		seq_printf(seq, "\n");

seq_puts()

> +	}
> +
>  	seq_printf(seq,
>  		   "     frags: %d  delay: %llu  clone_skb: %d  ifname: %s\n",
>  		   pkt_dev->nfrags, (unsigned long long) pkt_dev->delay,
> @@ -792,6 +814,61 @@ static int strn_len(const char __user * user_buffer, unsigned int maxlen)
>  	return i;
>  }
>  
> +static ssize_t get_imix_entries(const char __user *buffer,
> +				struct pktgen_dev *pkt_dev)
> +{
> +	/* Parses imix entries from user buffer.
> +	 * The user buffer should consist of imix entries separated by spaces
> +	 * where each entry consists of size and weight delimited by commas.
> +	 * "size1,weight_1 size2,weight_2 ... size_n,weight_n" for example.
> +	 */

This comments belongs before the function.

> +	long len;
> +	char c;
> +	int i = 0;
> +	const int max_digits = 10;

Please order these lines longest to shortest (reverse xmas tree).

> +	pkt_dev->n_imix_entries = 0;
> +
> +	do {
> +		unsigned long size;
> +		unsigned long weight;

same

> +
> +		len = num_arg(&buffer[i], max_digits, &size);
> +		if (len < 0)
> +			return len;
> +		i += len;
> +		if (get_user(c, &buffer[i]))
> +			return -EFAULT;
> +		/* Check for comma between size_i and weight_i */
> +		if (c != ',')
> +			return -EINVAL;
> +		i++;
> +
> +		if (size < 14 + 20 + 8)
> +			size = 14 + 20 + 8;

Why overwrite instead of rejecting?

> +		len = num_arg(&buffer[i], max_digits, &weight);
> +		if (len < 0)
> +			return len;
> +		if (weight <= 0)
> +			return -EINVAL;
> +
> +		pkt_dev->imix_entries[pkt_dev->n_imix_entries].size = size;
> +		pkt_dev->imix_entries[pkt_dev->n_imix_entries].weight = weight;
> +
> +		i += len;
> +		if (get_user(c, &buffer[i]))
> +			return -EFAULT;

What if this is the last entry?

> +		i++;
> +		pkt_dev->n_imix_entries++;
> +
> +		if (pkt_dev->n_imix_entries > MAX_IMIX_ENTRIES)
> +			return -E2BIG;
> +	} while (c == ' ');

empty line here

> +	return i;
> +}
> +
>  static ssize_t get_labels(const char __user *buffer, struct pktgen_dev *pkt_dev)
>  {
>  	unsigned int n = 0;
> @@ -960,6 +1037,18 @@ static ssize_t pktgen_if_write(struct file *file,
>  		return count;
>  	}
>  
> +	if (!strcmp(name, "imix_weights")) {
> +		if (pkt_dev->clone_skb > 0)
> +			return -ENOTSUPP;

ENOTSUPP should not be returned to user space, please use a different
one.

> +		len = get_imix_entries(&user_buffer[i], pkt_dev);
> +		if (len < 0)
> +			return len;
> +
> +		i += len;
> +		return count;
> +	}
> +
>  	if (!strcmp(name, "debug")) {
>  		len = num_arg(&user_buffer[i], 10, &value);
>  		if (len < 0)
> @@ -1082,10 +1171,16 @@ static ssize_t pktgen_if_write(struct file *file,
>  		len = num_arg(&user_buffer[i], 10, &value);
>  		if (len < 0)
>  			return len;
> +		/* clone_skb is not supported for netif_receive xmit_mode and
> +		 * IMIX mode.
> +		 */
>  		if ((value > 0) &&
>  		    ((pkt_dev->xmit_mode == M_NETIF_RECEIVE) ||
>  		     !(pkt_dev->odev->priv_flags & IFF_TX_SKB_SHARING)))
>  			return -ENOTSUPP;
> +		if (value > 0 && pkt_dev->n_imix_entries > 0)
> +			return -ENOTSUPP;

ditto

>  		i += len;
>  		pkt_dev->clone_skb = value;
>  

