Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA40F2C4AB4
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 23:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732404AbgKYWOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 17:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731403AbgKYWOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 17:14:55 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7154C206D9;
        Wed, 25 Nov 2020 22:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606342494;
        bh=CIIEI1N0OEO62kS72zlu3fHgH6X1ZJ5oaZRnW06r38s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Gvzd97BejmdO/GMpkGwWhybt+R/yYsfmsXbzko7OqFNbMyJTYeJKkvZsQuVH1vqCs
         JAtysf6OD8apv45Y0g9s1KHSWXLzc0yITC+E0j1jCh1l4V9ZK+6TuySAS0gFpbbRNJ
         yjKybazjk4TSn5/QDthtFkhBJEwSsDQdbVo/Bof4=
Message-ID: <1c07586328a66c3fe9bc084e2c45590b854aed9c.camel@kernel.org>
Subject: Re: [PATCH net 1/2] net/tls: Protect from calling tls_dev_del for
 TLS RX twice
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Date:   Wed, 25 Nov 2020 14:14:53 -0800
In-Reply-To: <20201118171300.71db0be3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
References: <20201117203355.389661-1-saeedm@nvidia.com>
         <20201118171300.71db0be3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-18 at 17:13 -0800, Jakub Kicinski wrote:
> On Tue, 17 Nov 2020 12:33:54 -0800 Saeed Mahameed wrote:
> > From: Maxim Mikityanskiy <maximmi@mellanox.com>
> > 
> > tls_device_offload_cleanup_rx doesn't clear tls_ctx->netdev after
> > calling tls_dev_del if TLX TX offload is also enabled. Clearing
> > tls_ctx->netdev gets postponed until tls_device_gc_task. It leaves
> > a
> > time frame when tls_device_down may get called and call tls_dev_del
> > for
> > RX one extra time, confusing the driver, which may lead to a crash.
> > 
> > This patch corrects this racy behavior by adding a flag to prevent
> > tls_device_down from calling tls_dev_del the second time.
> > 
> > Fixes: e8f69799810c ("net/tls: Add generic NIC offload
> > infrastructure")
> > Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> > ---
> > For -stable: 5.3
> > 
> >  include/net/tls.h    | 1 +
> >  net/tls/tls_device.c | 3 ++-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/net/tls.h b/include/net/tls.h
> > index baf1e99d8193..a0deddfde412 100644
> > --- a/include/net/tls.h
> > +++ b/include/net/tls.h
> > @@ -199,6 +199,7 @@ enum tls_context_flags {
> >  	 * to be atomic.
> >  	 */
> >  	TLS_TX_SYNC_SCHED = 1,
> 
> Please add a comment here explaining that this bit is set when device
> state is partially released, and ctx->netdev cannot be cleared but RX
> side was already removed.
> 
> > +	TLS_RX_DEV_RELEASED = 2,
> >  };
> >  
> >  struct cipher_context {
> > diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
> > index cec86229a6a0..b2261caac6be 100644
> > --- a/net/tls/tls_device.c
> > +++ b/net/tls/tls_device.c
> > @@ -1241,6 +1241,7 @@ void tls_device_offload_cleanup_rx(struct
> > sock *sk)
> >  
> >  	netdev->tlsdev_ops->tls_dev_del(netdev, tls_ctx,
> >  					TLS_OFFLOAD_CTX_DIR_RX);
> > +	set_bit(TLS_RX_DEV_RELEASED, &tls_ctx->flags);
> 
> Would the semantics of the bit be clearer if we only set the bit in
> an
> else branch below and renamed it TLS_RX_DEV_CLOSED?
> 
> Otherwise it could be confusing to the reader that his bit is only
> set
> here but not in tls_device_down().
> 

Thanks Jakub, Maxim handled both comments, I will send V2 and drop the
other patch !


