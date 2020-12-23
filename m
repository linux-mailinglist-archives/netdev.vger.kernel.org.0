Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E915E2E20FF
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgLWTmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:42:46 -0500
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:26922 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727671AbgLWTmp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 14:42:45 -0500
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BNJbH2Y002567;
        Wed, 23 Dec 2020 13:42:01 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=PA4cRyZlYYZNEQWHtbCTbLykWJbiuhh+e10GXbUmHX0=;
 b=fDoKNKEZ3id2GwKlYztyw+vPUjyXAlaEEcdzV+Gip31tvBe4JqE+366BLf0byNyorWd6
 cR4AnriqptngEDFerAeqwrxTcCSyFfdUMqU+QlD8I9hxd9bYMXXHIvx4seJ4KJNjojq9
 mM7cn0pkde455BI+VKeF1DX8J6/BCazIqGHw2E6KEnFDcgAb4v+Z5xna6S6Ezqc+iBAp
 oqbTtryhqjJWfrluRfin5y+TSOrg/Mfv8W82zVkjzzDMEQEG8d1GJgfUX31wbqeuxwAB
 6mlbXPtt09sCJARQm6zOTkU7oK3LB3jGoHcjeGKJcOoxFe4AdacyqXJqh3ndmU4tCAai hw== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 35k0edtgna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 23 Dec 2020 13:42:01 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Wed, 23 Dec
 2020 19:41:59 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Wed, 23 Dec 2020 19:41:59 +0000
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id E4FB711CB;
        Wed, 23 Dec 2020 19:41:58 +0000 (UTC)
Date:   Wed, 23 Dec 2020 19:41:58 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag on
 Zynq
Message-ID: <20201223194158.GG9673@ediswmail.ad.cirrus.com>
References: <20201223184144.7428-1-ckeepax@opensource.cirrus.com>
 <20201223192441.GH3198262@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201223192441.GH3198262@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 clxscore=1015
 bulkscore=0 priorityscore=1501 suspectscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012230140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 08:24:41PM +0100, Andrew Lunn wrote:
> On Wed, Dec 23, 2020 at 06:41:44PM +0000, Charles Keepax wrote:
> > A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
> > macb_set_tx_clk were gated on the presence of this flag.
> > 
> > if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
> > 
> > However the flag was not added to anything other than the new
> > sama7g5_gem, turning that function call into a no op for all other
> > systems. This breaks the networking on Zynq.
> 
> I'm not sure this is the correct fix. I think the original patch might
> be broken. Look at the commit message wording:
> 
>                                                       The patch adds a new
>     capability so that macb_set_tx_clock() to not be called for IPs having
>     this capability
> 
> So MACB_CAPS_CLK_HW_CHG disables something, not enables it. So i
> suspect this if statement is wrong and needs fixing.

Hmm... good spot, hopefully the original author can comment. The
flag name reads to me as clock rate can change, the commit message
definitely implies the opposite.

So it really depends if this function was intended to be skipped
for the sama7g5 gem or emac.

Thanks,
Charles
