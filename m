Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D48A57779D
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 10:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbfG0IcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 04:32:04 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56232 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727466AbfG0IcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jul 2019 04:32:03 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 776282019C;
        Sat, 27 Jul 2019 10:32:01 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fdzAf7cXfU0y; Sat, 27 Jul 2019 10:32:01 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 125E42018D;
        Sat, 27 Jul 2019 10:32:01 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.468.0; Sat, 27 Jul 2019
 10:32:00 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id ADF4D31803E0;
 Sat, 27 Jul 2019 10:32:00 +0200 (CEST)
Date:   Sat, 27 Jul 2019 10:32:00 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Jeremy Sowden <jeremy@azazel.net>
CC:     Jia-Ju Bai <baijiaju1990@gmail.com>, <herbert@gondor.apana.org.au>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: key: af_key: Fix possible null-pointer dereferences
 in pfkey_send_policy_notify()
Message-ID: <20190727083200.GE14601@gauss3.secunet.de>
References: <20190724093509.1676-1-baijiaju1990@gmail.com>
 <20190726094514.GD14601@gauss3.secunet.de>
 <20190726201555.GA4745@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190726201555.GA4745@azazel.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 09:15:55PM +0100, Jeremy Sowden wrote:
> On 2019-07-26, at 11:45:14 +0200, Steffen Klassert wrote:
> > On Wed, Jul 24, 2019 at 05:35:09PM +0800, Jia-Ju Bai wrote:
> > >
> > > diff --git a/net/key/af_key.c b/net/key/af_key.c
> > > index b67ed3a8486c..ced54144d5fd 100644
> > > --- a/net/key/af_key.c
> > > +++ b/net/key/af_key.c
> > > @@ -3087,6 +3087,8 @@ static int pfkey_send_policy_notify(struct xfrm_policy *xp, int dir, const struc
> > >  	case XFRM_MSG_DELPOLICY:
> > >  	case XFRM_MSG_NEWPOLICY:
> > >  	case XFRM_MSG_UPDPOLICY:
> > > +		if (!xp)
> > > +			break;
> >
> > I think this can not happen. Who sends one of these notifications
> > without a pointer to the policy?
> 
> I had a quick grep and found two places where km_policy_notify is passed
> NULL as the policy:
> 
>   $ grep -rn '\<km_policy_notify(NULL,' net/
>   net/xfrm/xfrm_user.c:2154:      km_policy_notify(NULL, 0, &c);
>   net/key/af_key.c:2788:  km_policy_notify(NULL, 0, &c);
> 
> They occur in xfrm_flush_policy() and pfkey_spdflush() respectively.

Yes, but these two send a XFRM_MSG_FLUSHPOLICY notify.
This does not trigger the code that is changed here.
