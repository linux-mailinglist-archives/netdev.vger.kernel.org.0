Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52867471999
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 11:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhLLKdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 05:33:25 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:47002 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230057AbhLLKdZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Dec 2021 05:33:25 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 57AEB204E0;
        Sun, 12 Dec 2021 11:33:23 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id zYotWKgpG9eh; Sun, 12 Dec 2021 11:33:22 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C4FF0201E4;
        Sun, 12 Dec 2021 11:33:22 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id B7A7180004A;
        Sun, 12 Dec 2021 11:33:22 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 12 Dec 2021 11:33:22 +0100
Received: from moon.secunet.de (172.18.149.1) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Sun, 12 Dec
 2021 11:33:22 +0100
Date:   Sun, 12 Dec 2021 11:33:20 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <antony.antony@secunet.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/2] xfrm: interface with if_id 0 should return error
Message-ID: <YbXP8Osj1hphoTSO@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <0bfebd4e5f317cbf301750d5dd5cc706d4385d7f.1639064087.git.antony.antony@secunet.com>
 <CAHsH6GstRxgMJsPNh5Jg_ow9fZBULMsCPKc0Y01pNTOD0Pc+4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAHsH6GstRxgMJsPNh5Jg_ow9fZBULMsCPKc0Y01pNTOD0Pc+4g@mail.gmail.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 19:22:35 +0200, Eyal Birger wrote:
> On Thu, Dec 9, 2021 at 5:36 PM Antony Antony <antony.antony@secunet.com> wrote:
> >
> > xfrm interface if_id = 0 would cause xfrm policy lookup errors since
> > commit 9f8550e4bd9d ("xfrm: fix disable_xfrm sysctl when used on xfrm interfaces")
> >
> > Now fail to create an xfrm interface when if_id = 0
> >
> > With this commit:
> >  ip link add ipsec0  type xfrm dev lo  if_id 0
> >  Error: if_id must be non zero.
> >
> > Signed-off-by: Antony Antony <antony.antony@secunet.com>
> > ---
> >  net/xfrm/xfrm_interface.c | 14 ++++++++++++--
> >  1 file changed, 12 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> > index 41de46b5ffa9..57448fc519fc 100644
> > --- a/net/xfrm/xfrm_interface.c
> > +++ b/net/xfrm/xfrm_interface.c
> > @@ -637,11 +637,16 @@ static int xfrmi_newlink(struct net *src_net, struct net_device *dev,
> >                         struct netlink_ext_ack *extack)
> >  {
> >         struct net *net = dev_net(dev);
> > -       struct xfrm_if_parms p;
> > +       struct xfrm_if_parms p = {};
> >         struct xfrm_if *xi;
> >         int err;
> >
> >         xfrmi_netlink_parms(data, &p);
> > +       if (!p.if_id) {
> > +               NL_SET_ERR_MSG(extack, "if_id must be non zero");
> > +               return -EINVAL;
> > +       }
> > +
> >         xi = xfrmi_locate(net, &p);
> >         if (xi)
> >                 return -EEXIST;
> > @@ -666,7 +671,12 @@ static int xfrmi_changelink(struct net_device *dev, struct nlattr *tb[],
> >  {
> >         struct xfrm_if *xi = netdev_priv(dev);
> >         struct net *net = xi->net;
> > -       struct xfrm_if_parms p;
> > +       struct xfrm_if_parms p = {};
> > +
> > +       if (!p.if_id) {
> > +               NL_SET_ERR_MSG(extack, "if_id must be non zero");
> > +               return -EINVAL;
> > +       }
> >
> >         xfrmi_netlink_parms(data, &p);
> >         xi = xfrmi_locate(net, &p);
> 
> Looks good. Maybe this needs a "Fixes:" tag?

I assumed this patch is not ideal for stable releases!
There is a small chance someone was depending old semi broken behavior? And they would find this patch as surprise? So I preferred not add "Fixes: " tag.

Now I notice 9f8550e4bd9d is already in stable/linux-4.19.y. So I think
Fixes tag would be fine.
I will send out a v2 with "Fixes:" tag and let Steffen choose:)

> Reviewed-by: Eyal Birger <eyal.birger@gmail.com>

thanks Eyal.
-antony
