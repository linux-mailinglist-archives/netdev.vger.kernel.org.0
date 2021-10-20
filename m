Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB83434B06
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 14:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbhJTMTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 08:19:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48550 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230205AbhJTMTQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 08:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=32GYkFGawk1EHwubKe3VWlQKW04GyjW6olYclX1Tk34=; b=RtVOIeZ3PSCRdaK6EFw6Mufldc
        FCR2wMQvAml1Qlq2OYjJgctYcQ5iMmh7GJmitlPzROfHxV7aBjd2hV9GNCMR/KxBQjSp8DlhClDvf
        +zi4IBK2/Lm4fk0gkMzLfzztsOGGqA+xRx/ioUUkN7cB284Gh0EsuFEEADsUCUpI7oNM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mdAWd-00BBMp-US; Wed, 20 Oct 2021 14:16:55 +0200
Date:   Wed, 20 Oct 2021 14:16:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev <netdev@vger.kernel.org>,
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
Message-ID: <YXAIt3TOaCiEuHSt@lunn.ch>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
 <CAMuHMdWghZ7HM5RRFRsZu8P_ikna0QWoRfCKeym61N-Lv-v4Xw@mail.gmail.com>
 <20211019173520.0154a8cb@kmaincent-XPS-13-7390>
 <YW7nPfzjstmeoMbf@lunn.ch>
 <20211019175746.11b388ce@windsurf>
 <CAMuHMdXiMhpU0vDV3KaOg4DY59cszAtoG1sDOgnTRY6C6cyitQ@mail.gmail.com>
 <20211020105328.411a712f@kmaincent-XPS-13-7390>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211020105328.411a712f@kmaincent-XPS-13-7390>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > BTW, it's still not clear to me why the inversion would be needed.
> > Cfr. Andrew's comment:
> > 
> > | So with rgmii-rxid, what is actually passed to the PHY? Is your
> > | problem you get twice the delay in one direction, and no delay in the
> > | other?
> 
> Yes, it was the problem I got.
> The PHY I use have RX delay enabled by default, currently the PHY driver does
> not support delay configuration, therefore I let the MAC handle TX delay. I
> have stumbling over that legacy/wrong DTS on the old Kernel.

This is where we get into the horrible mess of RGMII delays.

The real solution is to fix the PHY driver. If it is asked to do
rgmii, but is actually doing rgmii-id, the PHY driver is broken. It
either should do what it is told, or return -EINVAL/-EOPNOTSUPP etc to
indicate it does not support what it is asked to do.

But fixing things like this often breaks working systems, because the
DT says rgmii, the PHY actually does rgmii-id, the board works, until
the PHY is fixed to do what it is told, and all the bugs in the DT
suddenly come to light.

Now, you said you are using an old kernel. So it could be we have
already fixed this, and had the pain of fixing broken DT. Please look
at the current kernel PHY driver, and see if all you need to do is
back port some PHY fixes, or better still, throw away your old kernel
and use a modern one.

       Andrew
