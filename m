Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8A042E92A6
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 10:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbhADJeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 04:34:37 -0500
Received: from mx0b-001ae601.pphosted.com ([67.231.152.168]:51894 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725468AbhADJeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 04:34:37 -0500
Received: from pps.filterd (m0077474.ppops.net [127.0.0.1])
        by mx0b-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1049VT9T022442;
        Mon, 4 Jan 2021 03:33:46 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=x5nlcZ8ESXAQAog5Zt2q0TU4/sxoun3EJYkVUSeIwAU=;
 b=MQ1+aySOzmNBh2TLHsW0mHAdf81pbNp97hZ84FkF9cRJSgZo/JLiTqZqFI6S4ROVx0Jo
 AHpjVcHvAb2S7zMUKGh3SF3d8iiVkC5D9DznwgMoJuCA4TuYiz2pXxT3TS58JOX1mXOh
 IGDOcO1y3JfAyLocqTtSL11D4bsawJgvJanNTXUCTQbadRKWER7uUbJhOyoMVhcXJMBO
 MMb8SWkXl7MQPl2+qnibgh4PH9PSb+QvXLIC/ZdQRNPJB3eMCjtx8FJDCJPLBqzQEBZn
 8yvyYz9ro4m5hH3tUaSudjTbQOl4HrhDUMl6Y45QB4E0x8PcmpM2ihwNDT9lFdBWxZWM +A== 
Received: from ediex02.ad.cirrus.com ([87.246.76.36])
        by mx0b-001ae601.pphosted.com with ESMTP id 35tp4tha4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 03:33:46 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX02.ad.cirrus.com
 (198.61.84.81) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 4 Jan 2021
 09:18:42 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Mon, 4 Jan 2021 09:18:42 +0000
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 45E7E11CB;
        Mon,  4 Jan 2021 09:18:42 +0000 (UTC)
Date:   Mon, 4 Jan 2021 09:18:42 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
Message-ID: <20210104091842.GQ9673@ediswmail.ad.cirrus.com>
References: <20201230103309.8956-1-ckeepax@opensource.cirrus.com>
 <X+yueZ4of+Ixr//E@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <X+yueZ4of+Ixr//E@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=897
 adultscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0
 mlxscore=0 bulkscore=0 impostorscore=0 clxscore=1015 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 05:44:41PM +0100, Andrew Lunn wrote:
> On Wed, Dec 30, 2020 at 10:33:09AM +0000, Charles Keepax wrote:
> > A new flag MACB_CAPS_CLK_HW_CHG was added and all callers of
> > macb_set_tx_clk were gated on the presence of this flag.
> > 
> > -   if (!clk)
> > + if (!bp->tx_clk || !(bp->caps & MACB_CAPS_CLK_HW_CHG))
> > 
> > However the flag was not added to anything other than the new
> > sama7g5_gem, turning that function call into a no op for all other
> > systems. This breaks the networking on Zynq.
> > 
> > The commit message adding this states: a new capability so that
> > macb_set_tx_clock() to not be called for IPs having this
> > capability
> > 
> > This strongly implies that present of the flag was intended to skip
> > the function not absence of the flag. Update the if statement to
> > this effect, which repairs the existing users.
> > 
> > Fixes: daafa1d33cc9 ("net: macb: add capability to not set the clock rate")
> > Suggested-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Charles
> 
> Since this is a fix, this should be based on the net tree. And you
> indicate this in the subject line with [PATCH net]. If this applies
> cleanly to net, Dave will probably just accept it, but please keep
> this in mind for any more submissions you make to netdev.
> 

Is already based on the net tree, sorry wasn't aware I needed to add
that into the subject line. Will do a respin today.

Thanks,
Charles
