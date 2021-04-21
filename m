Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B8366D55
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 15:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243054AbhDUN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 09:57:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:9462 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243036AbhDUN46 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 09:56:58 -0400
X-Greylist: delayed 1925 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2021 09:56:58 EDT
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13LDM5v9024165;
        Wed, 21 Apr 2021 13:23:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2020-01-29;
 bh=TNSaEpFWAP3byXDTGeCVcql+u1LPJQ67fY0dZbPZ+3U=;
 b=pCaRlRtos22T09/Q5LwqvQZF6WxEZPJeC8dcj1TKceMV6NaRukW2BfLwtNHpYo96slQ+
 hyDp/Xr7Y2+4RnevKoDUmG5KJA/3hgzq2esycxB9qnV4v4+S7n54yqXKyZNDkZCdK28X
 0lyMrUN+gaY5o0M+FQRKz6SShzyOekidPhbtfD7Re6S58xmQq34mIWPxeaTVIpkAFTQw
 Jk0iclJpXLtHO+ENIvIbQibZ1tETFpW9ZQW4QQtuqYZ6+afauRWUT/9RffFmR5RqBYVp
 crNYVOeMUKSeYWmmoBVFYSjLvSUQP7ozuFkT7JpdN1U1+TNC/jW/Q04MdQYyhhPcIsyW kg== 
Received: from oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3818whgqum-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:23:04 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 13LDN3hO188471;
        Wed, 21 Apr 2021 13:23:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 3809eu908r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:23:03 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 13LDMHMI186187;
        Wed, 21 Apr 2021 13:23:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 3809eu9080-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 13:23:02 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 13LDMxwB025688;
        Wed, 21 Apr 2021 13:22:59 GMT
Received: from mwanda (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 21 Apr 2021 06:22:58 -0700
Date:   Wed, 21 Apr 2021 16:22:50 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] stmmac: intel: unlock on error path in
 intel_crosststamp()
Message-ID: <YIAnKtpJa/K+0efq@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Proofpoint-ORIG-GUID: mNzPN1m0GniGNETV8bAzsQ4x43P4ytO0
X-Proofpoint-GUID: mNzPN1m0GniGNETV8bAzsQ4x43P4ytO0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We recently added some new locking to this function but one error path
was overlooked.  We need to drop the lock before returning.

Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index ec140fc4a0f5..bd662aaf664a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -320,6 +320,7 @@ static int intel_crosststamp(ktime_t *device,
 		acr_value |= PTP_ACR_ATSEN3;
 		break;
 	default:
+		mutex_unlock(&priv->aux_ts_lock);
 		return -EINVAL;
 	}
 	writel(acr_value, ptpaddr + PTP_ACR);
-- 
2.30.2

