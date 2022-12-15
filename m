Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7056664E3C7
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 23:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiLOWcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 17:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLOWcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 17:32:13 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF88657B58;
        Thu, 15 Dec 2022 14:32:11 -0800 (PST)
Received: from sslproxy04.your-server.de ([78.46.152.42])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5wld-000Kma-NB; Thu, 15 Dec 2022 23:31:53 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy04.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1p5wld-000BfT-AM; Thu, 15 Dec 2022 23:31:53 +0100
Subject: Re: [PATCH bpf-next 3/6] bpf, net, frags: Add bpf_ip_check_defrag()
 kfunc
To:     Daniel Xu <dxu@dxuuu.xyz>, "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     ppenkov@aviatrix.com, dbird@aviatrix.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1671049840.git.dxu@dxuuu.xyz>
 <1f48a340a898c4d22d65e0e445dbf15f72081b9a.1671049840.git.dxu@dxuuu.xyz>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <451b291a-7798-cfe2-84da-815937b54f70@iogearbox.net>
Date:   Thu, 15 Dec 2022 23:31:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1f48a340a898c4d22d65e0e445dbf15f72081b9a.1671049840.git.dxu@dxuuu.xyz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.7/26751/Thu Dec 15 09:20:56 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

Thanks for working on this!

On 12/15/22 12:25 AM, Daniel Xu wrote:
[...]
> +#include <linux/bpf.h>
> +#include <linux/btf_ids.h>
> +#include <linux/ip.h>
> +#include <linux/filter.h>
> +#include <linux/netdevice.h>
> +#include <net/ip.h>
> +#include <net/sock.h>
> +
> +__diag_push();
> +__diag_ignore_all("-Wmissing-prototypes",
> +		  "Global functions as their definitions will be in ip_fragment BTF");
> +
> +/* bpf_ip_check_defrag - Defragment an ipv4 packet
> + *
> + * This helper takes an skb as input. If this skb successfully reassembles
> + * the original packet, the skb is updated to contain the original, reassembled
> + * packet.
> + *
> + * Otherwise (on error or incomplete reassembly), the input skb remains
> + * unmodified.
> + *
> + * Parameters:
> + * @ctx		- Pointer to program context (skb)
> + * @netns	- Child network namespace id. If value is a negative signed
> + *		  32-bit integer, the netns of the device in the skb is used.
> + *
> + * Return:
> + * 0 on successfully reassembly or non-fragmented packet. Negative value on
> + * error or incomplete reassembly.
> + */
> +int bpf_ip_check_defrag(struct __sk_buff *ctx, u64 netns)

small nit: for sk lookup helper we've used u32 netns_id, would be nice to have
this consistent here as well.

> +{
> +	struct sk_buff *skb = (struct sk_buff *)ctx;
> +	struct sk_buff *skb_cpy, *skb_out;
> +	struct net *caller_net;
> +	struct net *net;
> +	int mac_len;
> +	void *mac;
> +
> +	if (unlikely(!((s32)netns < 0 || netns <= S32_MAX)))
> +		return -EINVAL;
> +
> +	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
> +	if ((s32)netns < 0) {
> +		net = caller_net;
> +	} else {
> +		net = get_net_ns_by_id(caller_net, netns);
> +		if (unlikely(!net))
> +			return -EINVAL;
> +	}
> +
> +	mac_len = skb->mac_len;
> +	skb_cpy = skb_copy(skb, GFP_ATOMIC);
> +	if (!skb_cpy)
> +		return -ENOMEM;

Given slow path, this idea is expensive but okay. Maybe in future it could be lifted
which might be a bigger lift to teach verifier that input ctx cannot be accessed
anymore.. but then frags are very much discouraged either way and bpf_ip_check_defrag()
might only apply in corner case situations (like DNS, etc).

> +	skb_out = ip_check_defrag(net, skb_cpy, IP_DEFRAG_BPF);
> +	if (IS_ERR(skb_out))
> +		return PTR_ERR(skb_out);

Looks like ip_check_defrag() can gracefully handle IPv6 packet. It will just return back
skb_cpy pointer in that case. However, this brings me to my main complaint.. I don't
think we should merge anything IPv4-related without also having IPv6 equivalent support,
otherwise we're building up tech debt, so pls also add support for the latter.

> +	skb_morph(skb, skb_out);
> +	kfree_skb(skb_out);
> +
> +	/* ip_check_defrag() does not maintain mac header, so push empty header
> +	 * in so prog sees the correct layout. The empty mac header will be
> +	 * later pulled from cls_bpf.
> +	 */
> +	mac = skb_push(skb, mac_len);
> +	memset(mac, 0, mac_len);
> +	bpf_compute_data_pointers(skb);
> +
> +	return 0;
> +}
> +

Thanks,
Daniel
