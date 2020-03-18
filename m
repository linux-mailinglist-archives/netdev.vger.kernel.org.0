Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF8318A2AD
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 19:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRSzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 14:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgCRSzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 14:55:50 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEBC720724;
        Wed, 18 Mar 2020 18:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584557750;
        bh=yn7AVOhWkI8kO/bkCr2vDWv6yj3DqKxjnSyUaSFeKlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QtWjV98yRn1InN+/gx/vGYFFstfIslhv/xYBorYpx/1HOEB7CFpA++0irNbt3tRXX
         4R5KrbnPGNAhF1qV0k9gLZtInUdxqdLyPZij1nkP/x1+uaXsoiOnC4ytiHdw77JTcX
         DJUKyRwiuSNTBoPvH4H+5v4HThg79AkpOqewppyc=
Date:   Wed, 18 Mar 2020 11:55:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rohit Maheshwari <rohitm@chelsio.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        netdev@vger.kernel.org, borisp@mellanox.com, secdev@chelsio.com,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: Re: [PATCH net-next] Crypto/chtls: add/delete TLS header in driver
Message-ID: <20200318115548.12ce1e37@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200318133304.16196-1-rohitm@chelsio.com>
References: <20200318133304.16196-1-rohitm@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Mar 2020 19:03:04 +0530 Rohit Maheshwari wrote:
> @@ -1022,15 +1014,20 @@ int chtls_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>  			goto wait_for_sndbuf;
>  
>  		if (is_tls_tx(csk) && !csk->tlshws.txleft) {
> -			struct tls_hdr hdr;
> +			unsigned char record_type = TLS_RECORD_TYPE_DATA;
>  
> -			recordsz = tls_header_read(&hdr, &msg->msg_iter);
> -			size -= TLS_HEADER_LENGTH;
> -			copied += TLS_HEADER_LENGTH;
> +			if (unlikely(msg->msg_controllen)) {
> +				err = tls_proccess_cmsg(sk, msg, &record_type);

This is for the TOE TLS offload, right?

Could you open code this in your driver? This function calls
tls_handle_open_record(), which should be fine with the code as is,
but someone may make an assumption that it's no called for TOE and
break your offload.

Given it's impossible to test the offloads without HW today, I'd 
rather not mix the TOE with the other TLS types..

> +				if (err)
> +					goto out_err;
> +			}
> +
> +			recordsz = size;
>  			csk->tlshws.txleft = recordsz;
> -			csk->tlshws.type = hdr.type;
> +			csk->tlshws.type = record_type;
> +
>  			if (skb)
> -				ULP_SKB_CB(skb)->ulp.tls.type = hdr.type;
> +				ULP_SKB_CB(skb)->ulp.tls.type = record_type;
>  		}
>  
>  		if (!skb || (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_NO_APPEND) ||
