Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3437F4AF891
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:33:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238322AbiBIRdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238268AbiBIRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:33:41 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E10E7C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 09:33:40 -0800 (PST)
X-UUID: 5d1b7913d96543eaabca3ee1513c5ec8-20220210
X-UUID: 5d1b7913d96543eaabca3ee1513c5ec8-20220210
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2130511471; Thu, 10 Feb 2022 01:33:36 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 10 Feb 2022 01:33:34 +0800
Received: from mtkcas11.mediatek.inc (172.21.101.40) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Feb
 2022 01:33:34 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas11.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 01:33:34 +0800
Message-ID: <48d2d967a625c65308bff7bad03ae49779986549.camel@mediatek.com>
Subject: Re: [PATCH RFC net-next 0/7] net: dsa: mt7530: updates for phylink
 changes
From:   Landen Chao <landen.chao@mediatek.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Date:   Thu, 10 Feb 2022 01:33:34 +0800
In-Reply-To: <YgO8WMjc77BsOLtD@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
         <YgO8WMjc77BsOLtD@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-02-09 at 21:06 +0800, Russell King (Oracle) wrote:
> On Thu, Feb 03, 2022 at 05:30:31PM +0000, Russell King (Oracle)
> wrote:
> > Hi,
> > 
> > This series is a partial conversion of the mt7530 DSA driver to the
> > modern phylink infrastructure. This driver has some exceptional
> > cases
> > which prevent - at the moment - its full conversion (particularly
> > with
> > the Autoneg bit) to using phylink_generic_validate().
> > 
> > What stands in the way is this if() condition in
> > mt753x_phylink_validate():
> > 
> > 	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
> > 	    !phy_interface_mode_is_8023z(state->interface)) {
> > 
> > reduces to being always true. I highlight this here for the
> > attention
> > of the driver maintainers.
Hi Russel,

The above behaviour is really a bug. "&&" should be used to prevent
setting MAC_10, MAC_100 and Antoneg capability in particular interface
mode in original code. However, these capability depend on the link
partner of the MAC, such as Ethernet phy. It's okay to keep setting
them.

Thanks for this series.

> 
> I'm intending to submit this series later today, preserving the above
> behaviour, as I like to keep drivers bug-for-bug compatible, with the
> assumption that they've been tested as working, even if the code
> looks
> wrong. However, it would be good if this point could be addressed.
> Thanks.
> 

