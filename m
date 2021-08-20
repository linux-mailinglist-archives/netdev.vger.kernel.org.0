Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14893F31C8
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhHTQzx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:55:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhHTQzw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 12:55:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E1F60FBF;
        Fri, 20 Aug 2021 16:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629478514;
        bh=lMsuh5RCkeRR45XxEhlnxXGE8a7WQ2X4FFIoKXfsNuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jxFBNwiCRjv9qga0Y2W7cazwU+EJZvy4HSzxzLwx/b6uKVRTEnNd/WnYaxOLmlR/b
         7whH98nRjk1bcLRzx/P1O3/5QCJVbN+2EuyaHdgpemFAlAznM7d4qcG5XMMLZEGnTl
         +tiS5QHF/qcP0Xyl6D7B/fJuI2neZ9dkyLCUOzi308i4lbEJ8kyMxK1mM3oL1rlme5
         ZkIeD1on42yP/iaHXbA3O6QfBQv34laPRptHVFCcAWegVxAYKVoyXOoyitlXavXqbk
         pE6rp25gre3U30IT+LCG74GkVXqJ6tXFTg5K1dmp8yGaQcHGUycRh81gsxOsRBBKQz
         0JwAjxLPBKqcA==
Date:   Fri, 20 Aug 2021 09:55:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        UNGLinuxDriver@microchip.com,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Marek Behun <kabel@blackhole.sk>,
        DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Jianbo Liu <jianbol@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 net-next 3/7] net: switchdev: move
 SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE to the blocking notifier chain
Message-ID: <20210820095511.60892163@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820155749.ufb6wxgb7ujmihql@skbuf>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
        <20210820115746.3701811-4-vladimir.oltean@nxp.com>
        <20210820085402.3dfbd2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210820155749.ufb6wxgb7ujmihql@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 18:57:49 +0300 Vladimir Oltean wrote:
> On Fri, Aug 20, 2021 at 08:54:02AM -0700, Jakub Kicinski wrote:
> > On Fri, 20 Aug 2021 14:57:42 +0300 Vladimir Oltean wrote: =20
> > > Currently, br_switchdev_fdb_notify() uses call_switchdev_notifiers (a=
nd
> > > br_fdb_replay() open-codes the same thing). This means that drivers
> > > handle the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events on the atomic
> > > switchdev notifier block. =20
> >=20
> > drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c: In function =
=E2=80=98sparx5_switchdev_fdb_event=E2=80=99:
> > drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c:453:1: warning=
: label =E2=80=98err_addr_alloc=E2=80=99 defined but not used [-Wunused-lab=
el]
> >   453 | err_addr_alloc:
> >       | ^~~~~~~~~~~~~~ =20
>=20
> Yeah, I noticed (too late sadly). Other than a bit of dead code it does
> not impact functionality, so that's why I didn't jump to resend until I
> got some feedback first (thanks Vlad). Do you think it's time to resend?

No really, I just don't want to drop things from patchwork without
making a note of what the reason was. You can reply to your own posting
saying that you noticed an error but want it reviewed anyway, or wait
for me to complain and quietly stick to your plan.. No real preference.
