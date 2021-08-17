Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8FA3EEB83
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 13:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236808AbhHQLUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 07:20:25 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:47580 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231515AbhHQLUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 07:20:25 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4113B2053D;
        Tue, 17 Aug 2021 13:19:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oykrflPFXWJg; Tue, 17 Aug 2021 13:19:47 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1ED46200A2;
        Tue, 17 Aug 2021 13:19:47 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 0FF2780004A;
        Tue, 17 Aug 2021 13:19:47 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 13:19:46 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 17 Aug
 2021 13:19:46 +0200
Date:   Tue, 17 Aug 2021 13:19:40 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Christian Langrock <christian.langrock@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 ipsec-next] xfrm: Add possibility to set the default
 to block if we have no policy
Message-ID: <20210817111940.GA7430@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20210331144843.GA25749@moon.secunet.de>
 <fc1364604051d6be5c4c14817817a004aba539eb.1626592022.git.antony.antony@secunet.com>
 <e0c347a0-f7d4-e1ef-51a8-2d8b65bccbbc@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e0c347a0-f7d4-e1ef-51a8-2d8b65bccbbc@6wind.com>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 11, 2021 at 18:14:08 +0200, Nicolas Dichtel wrote:
> Le 18/07/2021 à 09:11, Antony Antony a écrit :
> > From: Steffen Klassert <steffen.klassert@secunet.com>
> Sorry for my late reply, I was off.
> 
> > 
> > As the default we assume the traffic to pass, if we have no
> > matching IPsec policy. With this patch, we have a possibility to
> > change this default from allow to block. It can be configured
> > via netlink. Each direction (input/output/forward) can be
> > configured separately. With the default to block configuered,
> > we need allow policies for all packet flows we accept.
> > We do not use default policy lookup for the loopback device.
> > 
> 
> [snip]
> 
> > diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
> > index e946366e8ba5..88c647302977 100644
> > --- a/include/net/netns/xfrm.h
> > +++ b/include/net/netns/xfrm.h
> > @@ -65,6 +65,13 @@ struct netns_xfrm {
> >  	u32			sysctl_aevent_rseqth;
> >  	int			sysctl_larval_drop;
> >  	u32			sysctl_acq_expires;
> > +
> > +	u8			policy_default;
> > +#define XFRM_POL_DEFAULT_IN	1
> > +#define XFRM_POL_DEFAULT_OUT	2
> > +#define XFRM_POL_DEFAULT_FWD	4
> > +#define XFRM_POL_DEFAULT_MASK	7
> > +
> 
> [snip]
> 
> > diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
> > index ffc6a5391bb7..6e8095106192 100644
> > --- a/include/uapi/linux/xfrm.h
> > +++ b/include/uapi/linux/xfrm.h
> > @@ -213,6 +213,11 @@ enum {
> >  	XFRM_MSG_GETSPDINFO,
> >  #define XFRM_MSG_GETSPDINFO XFRM_MSG_GETSPDINFO
> > 
> > +	XFRM_MSG_SETDEFAULT,
> > +#define XFRM_MSG_SETDEFAULT XFRM_MSG_SETDEFAULT
> > +	XFRM_MSG_GETDEFAULT,
> > +#define XFRM_MSG_GETDEFAULT XFRM_MSG_GETDEFAULT
> > +
> >  	XFRM_MSG_MAPPING,
> >  #define XFRM_MSG_MAPPING XFRM_MSG_MAPPING
> >  	__XFRM_MSG_MAX
> > @@ -508,6 +513,11 @@ struct xfrm_user_offload {
> >  #define XFRM_OFFLOAD_IPV6	1
> >  #define XFRM_OFFLOAD_INBOUND	2
> > 
> > +struct xfrm_userpolicy_default {
> > +	__u8				dirmask;
> > +	__u8				action;
> > +};
> > +
> Should XFRM_POL_DEFAULT_* be moved in the uapi?

It is good point. Thanks for the feedback.

> How can a user knows what value is expected in dirmask?
> 
> Same question for action. We should avoid magic values. 0 means drop or accept?

I have an iproute2 patch I want to sent out, moving to uapi would avoid using
hardcoded magic values there.


> Maybe renaming this field to 'drop' is enough.

action is a bitwise flag, one direction it may drop and ther other might
be allow.
