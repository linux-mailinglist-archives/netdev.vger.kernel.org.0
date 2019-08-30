Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB61AA3340
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 10:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728145AbfH3I4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 04:56:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14391 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727043AbfH3I4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 04:56:03 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id F2B8AC057E16;
        Fri, 30 Aug 2019 08:56:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A0565C1D6;
        Fri, 30 Aug 2019 08:56:00 +0000 (UTC)
Message-ID: <1b5232649421d2061274a891ad6a857081215b17.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] net: tls: export protocol version,
 cipher, tx_conf/rx_conf to socket diag
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     borisp@mellanox.com, Eric Dumazet <eric.dumazet@gmail.com>,
        aviadye@mellanox.com, davejwatson@fb.com, davem@davemloft.net,
        john.fastabend@gmail.com,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org
In-Reply-To: <20190829145642.3f3de3ae@cakuba.netronome.com>
References: <cover.1567095873.git.dcaratti@redhat.com>
         <22da29aa0d0c683afeba7549cabc64c5e073d308.1567095873.git.dcaratti@redhat.com>
         <20190829145642.3f3de3ae@cakuba.netronome.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 30 Aug 2019 10:56:00 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Fri, 30 Aug 2019 08:56:03 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-08-29 at 14:56 -0700, Jakub Kicinski wrote:
> On Thu, 29 Aug 2019 18:48:04 +0200, Davide Caratti wrote:

[...]
> > @@ -431,6 +431,25 @@ static inline bool is_tx_ready(struct tls_sw_context_tx *ctx)
> >  	return READ_ONCE(rec->tx_ready);
> >  }
> >  
> > +static inline u16 tls_user_config(struct tls_context *ctx, bool tx)
> > +{
> > +	u16 config = tx ? ctx->tx_conf : ctx->rx_conf;
> > +
> > +	switch (config) {
> > +	case TLS_BASE:
> > +		return TLS_CONF_BASE;
> > +	case TLS_SW:
> > +		return TLS_CONF_SW;
> > +#ifdef CONFIG_TLS_DEVICE
> 
> Recently the TLS_HW define was taken out of the ifdef, so the ifdef
> around this is no longer necessary.

since the value of 'ctx->tx_conf' is always assigned/compared to 'TLS_HW'
under #ifdef CONFIG_TLS_DEVICE, the diag code will never reach that label 
when CONFIG_TLS_DEVICE is unset.
On the other hand, I'm ok for avoiding the #ifdefs unless they are really 
needed _ and probably IS_ENABLED() won't improve anything here, so I will 
just remove the #ifdef in series v3.

[...]

> > @@ -835,6 +836,67 @@ static void tls_update(struct sock *sk, struct proto *p)
> >  	}
> >  }
> >  
> > +static int tls_get_info(const struct sock *sk, struct sk_buff *skb)
> > +{
> > +	struct tls_context *ctx;
> > +	u16 version, cipher_type;
> 
> Unfortunately revere christmas tree will be needed :(

that's due :) I will fix in series v3.

thanks!
-- 
davide


