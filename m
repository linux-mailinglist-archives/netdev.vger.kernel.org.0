Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1301C2E9413
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbhADL1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:27:50 -0500
Received: from mx0a-001ae601.pphosted.com ([67.231.149.25]:31050 "EHLO
        mx0b-001ae601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726124AbhADL1u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:27:50 -0500
Received: from pps.filterd (m0077473.ppops.net [127.0.0.1])
        by mx0a-001ae601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 104BQgoi009299;
        Mon, 4 Jan 2021 05:27:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cirrus.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=PODMain02222019;
 bh=uG6QcysMT71wZwKjcssKAUcg6gBSTLtZQ3wxFBcrBPw=;
 b=WGufEsWHlg4G32i3qV5WW137bds0/07sT4Wzb2Ovu4NlqebsLOe12y6PdJ8kbu+3/W9M
 jL34YKRiIynkAf09IBarQbhJzHlM5Yxk8oyu05JHdSIe7qLMrJVjYWxB7R61eLDs+sIP
 R0EZxdLLd5kjNBt8Dj4+bJYPUki0Dkd8o61HUjRK/BOh4ZZvzR/uLFQCyIlSCzbJBMj0
 vwkou6xpl1BPRP7q165lAaWwvGH4z9AMGQ7Lek+zPllzvGUZLcdyfMSAzFvl4I7r9m9Q
 gocu2YKaFnEybbCV/mRDb4hud1JL1EbiGP+cMqezstWNLAMY2iJBFzD9wyA9K+VQDlhv Vg== 
Received: from ediex01.ad.cirrus.com ([87.246.76.36])
        by mx0a-001ae601.pphosted.com with ESMTP id 35tq479br8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 04 Jan 2021 05:27:02 -0600
Received: from EDIEX01.ad.cirrus.com (198.61.84.80) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Mon, 4 Jan 2021
 11:27:00 +0000
Received: from ediswmail.ad.cirrus.com (198.61.86.93) by EDIEX01.ad.cirrus.com
 (198.61.84.80) with Microsoft SMTP Server id 15.1.1913.5 via Frontend
 Transport; Mon, 4 Jan 2021 11:27:00 +0000
Received: from ediswmail.ad.cirrus.com (ediswmail.ad.cirrus.com [198.61.86.93])
        by ediswmail.ad.cirrus.com (Postfix) with ESMTP id 63A2711CB;
        Mon,  4 Jan 2021 11:27:00 +0000 (UTC)
Date:   Mon, 4 Jan 2021 11:27:00 +0000
From:   Charles Keepax <ckeepax@opensource.cirrus.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <nicolas.ferre@microchip.com>, <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] net: macb: Correct usage of MACB_CAPS_CLK_HW_CHG flag
Message-ID: <20210104112700.GA106851@ediswmail.ad.cirrus.com>
References: <20201230103309.8956-1-ckeepax@opensource.cirrus.com>
 <X+yueZ4of+Ixr//E@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <X+yueZ4of+Ixr//E@lunn.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101040076
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

Apologies I totally forgot to add your Reviewed-by on the new
version. Too much turkey on the brain after the fattening season.

Thanks,
Charles
