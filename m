Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A126930580
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 01:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfE3XkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 19:40:11 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33118 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfE3XkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 19:40:10 -0400
Received: by mail-qt1-f196.google.com with SMTP id 14so9287089qtf.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 16:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=u4oTQ1oZhgGGs9Q+tsqa4eji7Du9qZhZdVBFO0uDmTU=;
        b=uoC+sroooPB8unlrKINP1WcBV6DY0LsTnYF/v6vgUNaelq1TgOmyhugW+EBODwp6DS
         O1sylCCjRrKYEOPBX8rr9It04HsfIkt3AwkXcOAXp9gSewenT46BRUAZKWEIegw2p3Y+
         swlf/v7eF3fDCiEGxH0F9a5Yk+fYLTPSQ0XorKRsg1y89dsyvjvn9fZN9Ih+crn/VRAz
         d7o4tNH8ziZ6noBEBsVZezhEOOoToteX3XsdAJHM5CIZCUrrH3ZA0a1KTpRUdhBaoHFM
         jMm2/By1kKdRL6WKJMm6P/YEUnZ1ug7tjWAZUr9Es0JhkCyLL1JqLcyomhvTRZRMGB5M
         ndPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=u4oTQ1oZhgGGs9Q+tsqa4eji7Du9qZhZdVBFO0uDmTU=;
        b=EDUNy54ZhgH21dKYqVvGdL7imzqA8k3MscYazpgLWLsJRplrvWrmUFc3vfxuRiYj21
         /Vk1v/l5D+3EJl3n+bgQOS8kkDRe+uhvgrYLqegGvyMaSyhENojNaS5HVOdigacvSoOM
         1k79ol11d8Zq+JrXV0n3Yuqq/6pvuu6be4Tzzx8TPHgfVcjLIVvkspopJ1iqTIz3fOi2
         DlXhIHTpYTnX80iKNZc2ZDupT/M7PKidBAgRqHWB8kKGXkE6hUBLGAjkPkngb4IwKboG
         O5BVa4zblCu5f3fKOf1/MpaYpEzW71vSA90cssH0dnsCg5M2dONhrSwHCh5B9BMt6G8I
         VUUw==
X-Gm-Message-State: APjAAAV3bKsTeOmCVOt/kc5/lhej6Lpr/FNUgpgpLmOmCI2FOrKFPqb/
        Uv1o+MDjK6L9ztwNrpgrpQROEg==
X-Google-Smtp-Source: APXvYqx+mbQPLDZC+067i1iRTuZ2cUvIvnaH86FPS8W3kiLKJG8dJzFYfJ4/QIEDhtfD8bd6CI6sGA==
X-Received: by 2002:aed:3a25:: with SMTP id n34mr6163356qte.385.1559259609700;
        Thu, 30 May 2019 16:40:09 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 45sm3163469qtn.82.2019.05.30.16.40.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 30 May 2019 16:40:09 -0700 (PDT)
Date:   Thu, 30 May 2019 16:40:01 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        borisp@mellanox.com, alexei.starovoitov@gmail.com,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: Re: [PATCH net 1/3] net/tls: avoid NULL-deref on resync during
 device removal
Message-ID: <20190530164001.35a26331@cakuba.netronome.com>
In-Reply-To: <20190522020202.4792-2-jakub.kicinski@netronome.com>
References: <20190522020202.4792-1-jakub.kicinski@netronome.com>
        <20190522020202.4792-2-jakub.kicinski@netronome.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 May 2019 19:02:00 -0700, Jakub Kicinski wrote:
> When netdev with active kTLS sockets in unregistered
> notifier callback walks the offloaded sockets and
> cleans up offload state.  RX data may still be processed,
> however, and if resync was requested prior to device
> removal we would hit a NULL pointer dereference on
> ctx->netdev use.
> 
> Make sure resync is under the device offload lock
> and NULL-check the netdev pointer.
> 
> This should be safe, because the pointer is set to
> NULL either in the netdev notifier (under said lock)
> or when socket is completely dead and no resync can
> happen.
> 
> The other access to ctx->netdev in tls_validate_xmit_skb()
> does not dereference the pointer, it just checks it against
> other device pointer, so it should be pretty safe (perhaps
> we can add a READ_ONCE/WRITE_ONCE there, if paranoid).
> 
> Fixes: 4799ac81e52a ("tls: Add rx inline crypto offload")
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
> ---
>  net/tls/tls_device.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> index ca54a7c7ec81..aa33e4accc32 100644
> --- a/net/tls/tls_device.c
> +++ b/net/tls/tls_device.c
> @@ -553,8 +553,8 @@ void tls_device_write_space(struct sock *sk, struct tls_context *ctx)
>  void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
>  {
>  	struct tls_context *tls_ctx = tls_get_ctx(sk);
> -	struct net_device *netdev = tls_ctx->netdev;
>  	struct tls_offload_context_rx *rx_ctx;
> +	struct net_device *netdev;
>  	u32 is_req_pending;
>  	s64 resync_req;
>  	u32 req_seq;
> @@ -568,10 +568,15 @@ void handle_device_resync(struct sock *sk, u32 seq, u64 rcd_sn)
>  	is_req_pending = resync_req;
>  
>  	if (unlikely(is_req_pending) && req_seq == seq &&
> -	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0))
> -		netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk,
> -						      seq + TLS_HEADER_SIZE - 1,
> -						      rcd_sn);
> +	    atomic64_try_cmpxchg(&rx_ctx->resync_req, &resync_req, 0)) {
> +		seq += TLS_HEADER_SIZE - 1;
> +		down_read(&device_offload_lock);

Sorry this may actually cause a sleep in atomic, turns out resync may
get called directly from softirq under certain conditions.

Would it be possible to drop this from stable?  I can post a revert +
new fix (probably on a refcount..) or should I post an incremental fix?

> +		netdev = tls_ctx->netdev;
> +		if (netdev)
> +			netdev->tlsdev_ops->tls_dev_resync_rx(netdev, sk, seq,
> +							      rcd_sn);
> +		up_read(&device_offload_lock);
> +	}
>  }
>  
>  static int tls_device_reencrypt(struct sock *sk, struct sk_buff *skb)

