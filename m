Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E785D4AFD81
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 20:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235751AbiBITbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 14:31:17 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:36174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbiBITbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 14:31:09 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E15BDF28AEE
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 11:23:36 -0800 (PST)
X-UUID: 2d8d81d444704484b922c7d9a054aaa8-20220210
X-UUID: 2d8d81d444704484b922c7d9a054aaa8-20220210
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2071314603; Thu, 10 Feb 2022 03:15:30 +0800
Received: from mtkexhb01.mediatek.inc (172.21.101.102) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 10 Feb 2022 03:15:28 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by mtkexhb01.mediatek.inc
 (172.21.101.102) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Feb
 2022 03:15:28 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 10 Feb 2022 03:15:28 +0800
Message-ID: <dab7f18b3f86d598702f9697347c86bfe5cae7f9.camel@mediatek.com>
Subject: Re: [PATCH RFC net-next 0/7] net: dsa: mt7530: updates for phylink
 changes
From:   Landen Chao <landen.chao@mediatek.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
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
Date:   Thu, 10 Feb 2022 03:15:28 +0800
In-Reply-To: <YgP+NBeGL4MzRcYR@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
         <YgO8WMjc77BsOLtD@shell.armlinux.org.uk>
         <48d2d967a625c65308bff7bad03ae49779986549.camel@mediatek.com>
         <YgP+NBeGL4MzRcYR@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-02-10 at 01:47 +0800, Russell King (Oracle) wrote:
> On Thu, Feb 10, 2022 at 01:33:34AM +0800, Landen Chao wrote:
> > On Wed, 2022-02-09 at 21:06 +0800, Russell King (Oracle) wrote:
> > > On Thu, Feb 03, 2022 at 05:30:31PM +0000, Russell King (Oracle)
> > > wrote:
> > > > Hi,
> > > > 
> > > > This series is a partial conversion of the mt7530 DSA driver to
> > > > the
> > > > modern phylink infrastructure. This driver has some exceptional
> > > > cases
> > > > which prevent - at the moment - its full conversion
> > > > (particularly
> > > > with
> > > > the Autoneg bit) to using phylink_generic_validate().
> > > > 
> > > > What stands in the way is this if() condition in
> > > > mt753x_phylink_validate():
> > > > 
> > > > 	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
> > > > 	    !phy_interface_mode_is_8023z(state->interface)) {
> > > > 
> > > > reduces to being always true. I highlight this here for the
> > > > attention
> > > > of the driver maintainers.
> > 
> > Hi Russel,
> > 
> > The above behaviour is really a bug. "&&" should be used to prevent
> > setting MAC_10, MAC_100 and Antoneg capability in particular
> > interface
> > mode in original code. However, these capability depend on the link
> > partner of the MAC, such as Ethernet phy. It's okay to keep setting
> > them.
> 
> Hi Landen,
> 
> Thanks for the response. I think you have a slight misunderstanding
> about these capabilities, both in the old code and the new code.
> 
> You shouldn't care about e.g. the ethernet PHY's capabilities in the
> validate() callback at all - phylink will look at the capabilities
> reported by phylib, and mask out anything that the MAC says shouldn't
> be supported, which has the effect of restricting what the ethernet
> PHY will advertise.
> 
> In the old code, the validate() callback should only be concerned
> with
> what the MAC and PCS can support - e.g. if the MAC isn't capable of
> supportig 1G half-duplex, then the 1G HD capabilities should be
> masked
> out.
> 
> With the new code, PCS gain their own validation function, which
> means
> that the validate() callback then becomes very much just about the
> MAC,
> and with phylink_generic_validate(), we can get away with just
> specifying a bitmap of the supported interface types for the MAC/PCS
> end of the system, and the MAC speeds that are supported.
> 
> Given your feedback, I will re-jig the series to take account of your
> comments - thanks.
> 
Hi Russell,

Thanks for your guidance.

I've been stuck with an unnecessary problem, "should I export
MAC_1000/MAC_100/MAC_10 capability of MAC when PCS is connected with an
Ethernet PHY supports both 2500base-X and SGMII mode?" Now I know the
answer, just export all capability that MAC and PCS can support in the
validate(). phylink will help to find out the final configuration by
coworking with phylib.


