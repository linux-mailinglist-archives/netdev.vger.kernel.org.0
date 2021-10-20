Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080AC434764
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 10:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhJTIzs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 20 Oct 2021 04:55:48 -0400
Received: from relay11.mail.gandi.net ([217.70.178.231]:41621 "EHLO
        relay11.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhJTIzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 04:55:46 -0400
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by relay11.mail.gandi.net (Postfix) with ESMTPSA id EA6EA100013;
        Wed, 20 Oct 2021 08:53:28 +0000 (UTC)
Date:   Wed, 20 Oct 2021 10:53:28 +0200
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
Message-ID: <20211020105328.411a712f@kmaincent-XPS-13-7390>
In-Reply-To: <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
        <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
        <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
        <YW7nPfzjstmeoMbf@lunn.ch>
        <20211019175746.11b388ce@windsurf>
        <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Geert, Thomas

On Tue, 19 Oct 2021 22:05:41 +0200
Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Hi Thomas,
> 
> On Tue, Oct 19, 2021 at 5:57 PM Thomas Petazzoni
> <thomas.petazzoni@bootlin.com> wrote:
> > On Tue, 19 Oct 2021 17:41:49 +0200
> > Andrew Lunn <andrew@lunn.ch> wrote:  
> > > > When people update the kernel version don't they update also the
> > > > devicetree?  
> > >
> > > DT is ABI. Driver writers should not break old blobs running on new
> > > kernels. Often the DT blob is updated with the kernel, but it is not
> > > required. It could be stored in a hard to reach place, shared with
> > > u-boot etc.  
> >
> > Right, but conversely if someone reads the DT bindings that exists
> > today, specifies phy-mode = "rgmii-rxid" or phy-mmode = "rmgii-txid",  
> 
> Today == v5.10-rc1 and later?
> 
> > this person will get incorrect behavior. Sure a behavior that is
> > backward compatible with older DTs, but a terribly wrong one when you
> > write a new DT and read the DT binding documentation. This is exactly
> > the problem that happened to us.  
> 
> If you write a new DT, you read the DT binding documentation, and
> "make dtbs_check" will inform you politely if you use the legacy/wrong
> DT (i.e. lacking "[rt]x-internal-delay-ps")?

Indeed this command will inform the missing required "[rt]x-internal-delay-ps".
I am not use to that command, as it seems to check all the devicetree each time
where I want only to check one.

> 
> The current driver is backwards-compatible with the legacy/wrong DTB.
> The current DT bindings (as of v5.10-rc1), using "[rt]x-internal-delay-ps"
> are correct.
> Or am I missing something here?

You are correct.

> 
> BTW, it's still not clear to me why the inversion would be needed.
> Cfr. Andrew's comment:
> 
> | So with rgmii-rxid, what is actually passed to the PHY? Is your
> | problem you get twice the delay in one direction, and no delay in the
> | other?

Yes, it was the problem I got.
The PHY I use have RX delay enabled by default, currently the PHY driver does
not support delay configuration, therefore I let the MAC handle TX delay. I
have stumbling over that legacy/wrong DTS on the old Kernel.

Regards,
Köry
