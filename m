Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7583F3036
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 17:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241210AbhHTPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 11:54:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238296AbhHTPym (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 11:54:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 382686113B;
        Fri, 20 Aug 2021 15:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629474844;
        bh=XUKHadjj4KLvUi5ahKgSFqzY83/jwoSH1hCUCnHd2Ak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=d0VR0IY+2a03iRbnOQ6dPo7M+P/ii3nM4u7e0HdZyvG8UBBmmh5cUQa0HwA3BOdFm
         gphBHiG6EGwCN9QHi4FpGiY0GvrXl1iNtUbpp5pZFQOm6tBL1s79Oh6jxzKoJoP2/9
         aR88qnSrr/3FVTYj/g+yxxTfTsRX4QfDX+7RMB5jWud87yena01v21hQNotkUmu8Di
         rd5eHoJc0/sGbZqfa5neBUAibKA8Y0wdyVcTm+zIXJwaf3tGRBP9Yu7Dov1FzclI2A
         IkXENrU8Gr78S2bATa4NQr/z2Qvcob8DEJUTsXh01C2JfStxd5U/+N8GOTcMm1mei+
         3pmEUB/iP9NgA==
Date:   Fri, 20 Aug 2021 08:54:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
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
Message-ID: <20210820085402.3dfbd2a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210820115746.3701811-4-vladimir.oltean@nxp.com>
References: <20210820115746.3701811-1-vladimir.oltean@nxp.com>
        <20210820115746.3701811-4-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Aug 2021 14:57:42 +0300 Vladimir Oltean wrote:
> Currently, br_switchdev_fdb_notify() uses call_switchdev_notifiers (and
> br_fdb_replay() open-codes the same thing). This means that drivers
> handle the SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE events on the atomic
> switchdev notifier block.

drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c: In function =E2=
=80=98sparx5_switchdev_fdb_event=E2=80=99:
drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c:453:1: warning: la=
bel =E2=80=98err_addr_alloc=E2=80=99 defined but not used [-Wunused-label]
  453 | err_addr_alloc:
      | ^~~~~~~~~~~~~~
