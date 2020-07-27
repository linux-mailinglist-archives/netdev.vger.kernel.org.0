Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995D922E975
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 11:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgG0Jur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 05:50:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44132 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726196AbgG0Juq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 05:50:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 64AA420561;
        Mon, 27 Jul 2020 11:50:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ufs28DryHkk0; Mon, 27 Jul 2020 11:50:44 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 01B4920482;
        Mon, 27 Jul 2020 11:50:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:50:43 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 27 Jul
 2020 11:50:43 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 671043184651; Mon, 27 Jul 2020 11:50:43 +0200 (CEST)
Date:   Mon, 27 Jul 2020 11:50:43 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     B K Karthik <bkkarthik@pesu.pes.edu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        <skhan@linuxfoundation.org>,
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH v2] net: ipv6: fix use-after-free Read in
 __xfrm6_tunnel_spi_lookup
Message-ID: <20200727095043.GA20687@gauss3.secunet.de>
References: <20200726030855.q6dfjekazfzl5usw@pesu.pes.edu>
 <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAM_iQpUFL7VdCKSgUa6N3pg7ijjZRu6-6UAs2oNosM-EzgXbaQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 10:35:12PM -0700, Cong Wang wrote:
> On Sat, Jul 25, 2020 at 8:09 PM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> > @@ -103,10 +103,10 @@ static int __xfrm6_tunnel_spi_check(struct net *net, u32 spi)
> >  {
> >         struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
> >         struct xfrm6_tunnel_spi *x6spi;
> > -       int index = xfrm6_tunnel_spi_hash_byspi(spi);
> > +       int index = xfrm6_tunnel_spi_hash_byaddr((const xfrm_address_t *)spi);
> >
> >         hlist_for_each_entry(x6spi,
> > -                            &xfrm6_tn->spi_byspi[index],
> > +                            &xfrm6_tn->spi_byaddr[index],
> >                              list_byspi) {
> >                 if (x6spi->spi == spi)
> 
> How did you convince yourself this is correct? This lookup is still
> using spi. :)

This can not be correct, it takes a u32 spi value and casts it to a
pointer to an IP address.
