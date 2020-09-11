Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E702A265B1B
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgIKIGJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Sep 2020 04:06:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:40184 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgIKIGG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 04:06:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 448AE20082;
        Fri, 11 Sep 2020 10:06:03 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YDxr-tDcqUn9; Fri, 11 Sep 2020 10:06:02 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0C69D20512;
        Fri, 11 Sep 2020 10:06:02 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 11 Sep 2020 10:06:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 11 Sep
 2020 10:06:01 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5B18C3184344;
 Fri, 11 Sep 2020 10:06:01 +0200 (CEST)
Date:   Fri, 11 Sep 2020 10:06:01 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Dmitry Vyukov <dvyukov@google.com>
CC:     B K Karthik <bkkarthik@pesu.pes.edu>,
        syzbot <syzbot+72ff2fa98097767b5a27@syzkaller.appspotmail.com>,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Subject: Re: KASAN: use-after-free Read in __xfrm6_tunnel_spi_lookup
Message-ID: <20200911080601.GQ20687@gauss3.secunet.de>
References: <000000000000059b7205aa7f906f@google.com>
 <00000000000026751605aa857914@google.com>
 <CACT4Y+bUK4icp1TMfhWOj=vEXULbiUQ84RXYaKnB=3J_N3wZCQ@mail.gmail.com>
 <CAAhDqq0qcnMKdaoRnaGM6G8H1U7SAmTvX=hgEoor1=_eJff-Vw@mail.gmail.com>
 <CACT4Y+ZktT1S1oi5t+s7rrSH_dLEhyzygXdNUs7pkVPuanPXYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CACT4Y+ZktT1S1oi5t+s7rrSH_dLEhyzygXdNUs7pkVPuanPXYg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 10:09:50AM +0200, Dmitry Vyukov wrote:
> On Thu, Sep 10, 2020 at 10:08 AM B K Karthik <bkkarthik@pesu.pes.edu> wrote:
> >
> > On Thu, Sep 10, 2020 at 1:32 PM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Thu, Sep 10, 2020 at 9:20 AM Anant Thazhemadam
> > > <anant.thazhemadam@gmail.com> wrote:
> > > > Looks like this bug is no longer valid. I'm not sure which commit seems to have fixed it. Can this be marked as invalid or closed yet?
> > >
> > > You can see on the dashboard (or in mailing list archives) that B K
> > > Karthik tested a patch for this bug in July:
> > > https://syzkaller.appspot.com/bug?extid=72ff2fa98097767b5a27
> > >
> > > So perhaps that patch fixes it? Karthik, did you send it? Was it
> > > merged? Did the commit include the syzbot Reported-by tag?
> > >
> >
> > I did send it. I was taking a u32 spi value and casting it to a
> > pointer to an IP address. Steffen Klassert
> > <steffen.klassert@secunet.com> pointed out to me that the approach i
> > was looking at was completely wrong.
> > https://lkml.org/lkml/2020/7/27/361 is the conversation. hope this
> > helps.
> 
> +Steffen, was there any other fix merged for this?

I think that was already fixed before the sysbot report came in by
commit 8b404f46dd6a ("xfrm: interface: not xfrmi_ipv6/ipip_handler twice")
