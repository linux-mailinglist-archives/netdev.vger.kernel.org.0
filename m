Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2CFE163055
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRTkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRTkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 14:40:11 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C801521D56;
        Tue, 18 Feb 2020 19:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582054810;
        bh=r4XwTaeQFHYHzOA8/W9ZRakcbgmZDV841fFPNmq2HPA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mb6jy9iTyzp3mO0pBTg6ANxDudH1Lbtvx3Q9hIljQtS73lq9bfbwyw9pEsGILOdiv
         VkicjJG0ahqQmM8v0DoFwOarR3t/s5UdIjKq9atj15f9QBI9TNYmU+5XzMNcoEi9KD
         sIEs/VcilZ46O7ifyBuPJn6fvffuU2arI0zoQeg4=
Date:   Tue, 18 Feb 2020 11:40:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, borisp@mellanox.com,
        aviadye@mellanox.com, john.fastabend@gmail.com,
        daniel@iogearbox.net, manojmalviya@chelsio.com
Subject: Re: [PATCH net v3] net/tls: Fix to avoid gettig invalid tls record
Message-ID: <20200218114007.0d53d9cc@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20200216103108.14034-1-rohitm@chelsio.com>
References: <20200216103108.14034-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 16 Feb 2020 16:01:08 +0530 Rohit Maheshwari wrote:
> Current code doesn't check if tcp sequence number is starting from (/after)
> 1st record's start sequnce number. It only checks if seq number is before
> 1st record's end sequnce number. This problem will always be a possibility
> in re-transmit case. If a record which belongs to a requested seq number is
> already deleted, tls_get_record will start looking into list and as per the
> check it will look if seq number is before the end seq of 1st record, which
> will always be true and will return 1st record always, it should in fact
> return NULL.
> As part of the fix, start looking each record only if the sequence number
> lies in the list else return NULL.
> There is one more check added, driver look for the start marker record to
> handle tcp packets which are before the tls offload start sequence number,
> hence return 1st record if the record is tls start marker and seq number is
> before the 1st record's starting sequence number.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> ---
>  net/tls/tls_device.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index cd91ad812291..00a26e66d361 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -592,7 +592,7 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  				       u32 seq, u64 *p_record_sn)
>  {
>  	u64 record_sn = context->hint_record_sn;
> -	struct tls_record_info *info;
> +	struct tls_record_info *info, *last;
>  
>  	info = context->retransmit_hint;
>  	if (!info ||
> @@ -604,6 +604,25 @@ struct tls_record_info *tls_get_record(struct tls_offload_context_tx *context,
>  						struct tls_record_info, list);
>  		if (!info)
>  			return NULL;
> +		/* send the start_marker record if seq number is before the
> +		 * tls offload start marker sequence number. This record is
> +		 * required to handle TCP packets which are before TLS offload
> +		 * started.
> +		 *  And if it's not start marker, look if this seq number
> +		 * belongs to the list.
> +		 */
> +		if (likely(!tls_record_is_start_marker(info))) {
> +			/* we have the first record, get the last record to see
> +			 * if this seq number belongs to the list.
> +			 */
> +			last = list_last_entry(&context->records_list,
> +					       struct tls_record_info, list);
> +			WARN_ON(!last);

The logic looks good, but this WARN_ON() does not make much sense.
list_last_entry() never returns NULL. 

I think you can just drop  this check, if list had a first entry, it
must have last, the caller is supposed to hold the lock which prevents
removal.

> +			if (!between(seq, tls_record_start_seq(info),
> +				     last->end_seq))
> +				return NULL;
> +		}
>  		record_sn = context->unacked_record_sn;
>  	}
>  
