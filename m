Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EC32C2B17
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 16:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389476AbgKXPTF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 10:19:05 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:5090 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387697AbgKXPTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 10:19:05 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOFE0qS030284;
        Tue, 24 Nov 2020 16:18:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=STMicroelectronics;
 bh=PNHkZVe3AttnbUmeq2ofjE3UKCcL2HVMofSkBnS5Mmg=;
 b=LE3v7C8hAwZzxUZbZ73/ENWPRkfoShYeZbkd5n5lTLdL/LYJrGOIarfn+2EKShYc2qy9
 T7/PC1Te8myqXkiuk6O+DP8dcPm4B7R/iwrq3+GXvsCE6Lp0Y9Wv9Lq9JZRqz5tM4LBE
 OZiS6qKFIdXjdEILVrKJRCNWp5bWq1kn444ZCQDUhuMli3pt1vT/+7nhR7e9bGQBsOdv
 i/7pnt670Doh/b7yKDng7pKwktFGraj8R880eoQuJSlIqD/OcrRIg221lRuSwl8qEqT2
 UkkyyeFH/AhvzMjvU5hM2AG6NOOyVsdb5m/MTYKeVJZQGpDOXZPbujmFXNzLSEbBEkPR 3Q== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34y0hja1rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 16:18:35 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 08E9910002A;
        Tue, 24 Nov 2020 16:18:33 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id E3C822ADA1B;
        Tue, 24 Nov 2020 16:18:32 +0100 (CET)
Received: from [10.129.7.42] (10.75.127.48) by SFHDAG1NODE3.st.com
 (10.75.127.3) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 16:18:31 +0100
Message-ID: <bd83b9c15f6cfed5df90da4f6b50d1a3f479b831.camel@st.com>
Subject: Re: [PATCH] net: phy: fix auto-negotiation in case of 'down-shift'
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        <stable@vger.kernel.org>, <linuxarm@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 24 Nov 2020 16:17:42 +0100
In-Reply-To: <20201124145647.GF1551@shell.armlinux.org.uk>
References: <20201124143848.874894-1-antonio.borneo@st.com>
         <20201124145647.GF1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG4NODE1.st.com (10.75.127.10) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_04:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 14:56 +0000, Russell King - ARM Linux admin wrote:
> On Tue, Nov 24, 2020 at 03:38:48PM +0100, Antonio Borneo wrote:
> > If the auto-negotiation fails to establish a gigabit link, the phy
> > can try to 'down-shift': it resets the bits in MII_CTRL1000 to
> > stop advertising 1Gbps and retries the negotiation at 100Mbps.
> > 
> > From commit 5502b218e001 ("net: phy: use phy_resolve_aneg_linkmode
> > in genphy_read_status") the content of MII_CTRL1000 is not checked
> > anymore at the end of the negotiation, preventing the detection of
> > phy 'down-shift'.
> > In case of 'down-shift' phydev->advertising gets out-of-sync wrt
> > MII_CTRL1000 and still includes modes that the phy have already
> > dropped. The link partner could still advertise higher speeds,
> > while the link is established at one of the common lower speeds.
> > The logic 'and' in phy_resolve_aneg_linkmode() between
> > phydev->advertising and phydev->lp_advertising will report an
> > incorrect mode.
> > 
> > Issue detected with a local phy rtl8211f connected with a gigabit
> > capable router through a two-pairs network cable.
> > 
> > After auto-negotiation, read back MII_CTRL1000 and mask-out from
> > phydev->advertising the modes that have been eventually discarded
> > due to the 'down-shift'.
> 
> Sorry, but no. While your solution will appear to work, in
> introduces unexpected changes to the user visible APIs.
> 
> >  	if (phydev->autoneg == AUTONEG_ENABLE && phydev->autoneg_complete) {
> > +		if (phydev->is_gigabit_capable) {
> > +			adv = phy_read(phydev, MII_CTRL1000);
> > +			if (adv < 0)
> > +				return adv;
> > +			/* update advertising in case of 'down-shift' */
> > +			mii_ctrl1000_mod_linkmode_adv_t(phydev->advertising,
> > +							adv);
> 
> If a down-shift occurs, this will cause the configured advertising
> mask to lose the 1G speed, which will be visible to userspace.

You are right, it gets propagated to user that 1Gbps is not advertised

> Userspace doesn't expect the advertising mask to change beneath it.
> Since updates from userspace are done using a read-modify-write of
> the ksettings, this can have the undesired effect of removing 1G
> from the configured advertising mask.
> 
> We've had other PHYs have this behaviour; the correct solution is for
> the PHY driver to implement reading the resolution from the PHY rather
> than relying on the generic implementation if it can down-shift

If it's already upstream, could you please point to one of the phy driver
that already implements this properly?

Thanks
Antonio

