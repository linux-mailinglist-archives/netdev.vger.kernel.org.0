Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9036A2C3413
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgKXWfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:35:06 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:8064 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730078AbgKXWfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 17:35:05 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0AOMVtLB007251;
        Tue, 24 Nov 2020 23:34:34 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=STMicroelectronics;
 bh=z+RTPtSVNcxm52qSEaB20QzEW+8sFDwTaiAR30QmwZ8=;
 b=u3zOv/bCiuXkAeYVnEgs2a4DcVsrdHIIGNQAgMp4RYL6nMthY6yXKWYxoUEhmpYOs+ev
 R42t4zooAKQj+2KkL/jDdAFX9oD0UN603j9At08vkGGCbAEnkxVrQlX8nvrfpUljeoAS
 SR5kPqInJuREQtUuXxNQktyi9+8bakg3VDxSt55QwOTWxsbENffXx/pNkD1NZK5N1LB0
 98WHGIIYpJHWsDjdb17Jjfko2ZXZ7HBG3lZNzcIrFxO2U48suOFLt3SukE4zDbTRuK7A
 PsvPHl9NAOIHaAkt0HahNKWQkLk7QKy09FNjnRQdYWQBJRmMVCy+C+UphF/83bWepNTs Bw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 34y0hjc2ey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 24 Nov 2020 23:34:34 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id A10EC100034;
        Tue, 24 Nov 2020 23:34:33 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag1node3.st.com [10.75.127.3])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 8787620754A;
        Tue, 24 Nov 2020 23:34:33 +0100 (CET)
Received: from [10.129.7.42] (10.75.127.48) by SFHDAG1NODE3.st.com
 (10.75.127.3) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 24 Nov
 2020 23:34:32 +0100
Message-ID: <57457fcd335e7d6bfd543187de02608bcccf812f.camel@st.com>
Subject: Re: [PATCH v2] net: phy: realtek: read actual speed on rtl8211f to
 detect downshift
From:   Antonio Borneo <antonio.borneo@st.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Yonglong Liu <liuyonglong@huawei.com>,
        Willy Liu <willy.liu@realtek.com>
CC:     <linuxarm@huawei.com>, Salil Mehta <salil.mehta@huawei.com>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-kernel@vger.kernel.org>
Date:   Tue, 24 Nov 2020 23:33:42 +0100
In-Reply-To: <7d8bf728-7d73-fa8c-d63d-49e9e6c872fd@gmail.com>
References: <20201124143848.874894-1-antonio.borneo@st.com>
         <20201124215932.885306-1-antonio.borneo@st.com>
         <7d8bf728-7d73-fa8c-d63d-49e9e6c872fd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.75.127.48]
X-ClientProxiedBy: SFHDAG4NODE3.st.com (10.75.127.12) To SFHDAG1NODE3.st.com
 (10.75.127.3)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_09:2020-11-24,2020-11-24 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2020-11-24 at 23:22 +0100, Heiner Kallweit wrote:
> Am 24.11.2020 um 22:59 schrieb Antonio Borneo:
> > The rtl8211f supports downshift and before commit 5502b218e001
> > ("net: phy: use phy_resolve_aneg_linkmode in genphy_read_status")
> > the read-back of register MII_CTRL1000 was used to detect the
> > negotiated link speed.
> > The code added in commit d445dff2df60 ("net: phy: realtek: read
> > actual speed to detect downshift") is working fine also for this
> > phy and it's trivial re-using it to restore the downshift
> > detection on rtl8211f.
> > 
> > Add the phy specific read_status() pointing to the existing
> > function rtlgen_read_status().
> > 
> > Signed-off-by: Antonio Borneo <antonio.borneo@st.com>
> > Link: https://lore.kernel.org/r/478f871a-583d-01f1-9cc5-2eea56d8c2a7@huawei.com
> > ---
> > To: Andrew Lunn <andrew@lunn.ch>
> > To: Heiner Kallweit <hkallweit1@gmail.com>
> > To: Russell King <linux@armlinux.org.uk>
> > To: "David S. Miller" <davem@davemloft.net>
> > To: Jakub Kicinski <kuba@kernel.org>
> > To: netdev@vger.kernel.org
> > To: Yonglong Liu <liuyonglong@huawei.com>
> > To: Willy Liu <willy.liu@realtek.com>
> > Cc: linuxarm@huawei.com
> > Cc: Salil Mehta <salil.mehta@huawei.com>
> > Cc: linux-stm32@st-md-mailman.stormreply.com
> > Cc: linux-kernel@vger.kernel.org
> > In-Reply-To: <20201124143848.874894-1-antonio.borneo@st.com>
> > 
> > V1 => V2
> > 	move from a generic implementation affecting every phy
> > 	to a rtl8211f specific implementation
> > ---
> >  drivers/net/phy/realtek.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index 575580d3ffe0..8ff8a4edc173 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -621,6 +621,7 @@ static struct phy_driver realtek_drvs[] = {
> >  		PHY_ID_MATCH_EXACT(0x001cc916),
> >  		.name		= "RTL8211F Gigabit Ethernet",
> >  		.config_init	= &rtl8211f_config_init,
> > +		.read_status	= rtlgen_read_status,
> >  		.ack_interrupt	= &rtl8211f_ack_interrupt,
> >  		.config_intr	= &rtl8211f_config_intr,
> >  		.suspend	= genphy_suspend,
> > 
> > base-commit: 9bd2702d292cb7b565b09e949d30288ab7a26d51
> > 
> 
> Pefect would be to make this a fix for 5502b218e001,
> but rtlgen_read_status() was added one year after this change.
> Marking the change that added rtlgen_read_status() as "Fixes"
> would be technically ok, but as it's not actually broken not
> everybody may be happy with this.
> Having said that I'd be fine with treating this as an improvement,
> downshift should be a rare case.

Correct! Being the commit that adds rtlgen_read_status() an improvement,
should not be backported, so this patch is not marked anymore as a fix!
Plus, this does not fix 5502b218e001 in the general case, but limited to
one specific phy, making the 'fixes' label less relevant.
Anyway, the commit message reports all the ingredients for a backport.

By the way, I have incorrectly sent this based on netdev, but it's not a
fix anymore! Should I rebase it on netdev-next and resend?

Antonio

