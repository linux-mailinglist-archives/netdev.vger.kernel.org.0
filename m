Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86014E807
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 05:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgAaE5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 23:57:19 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40738 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727933AbgAaE5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 23:57:19 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4t9S2169776;
        Fri, 31 Jan 2020 04:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=vhZBZHYwVQzRkRLs8F0bVp2acAD00tQ4dSXfaT080og=;
 b=qDrw86Zex1TwokPNvN+0PXezdzAZPyaWWLNKVuV+PRjFRyVEQYqwBnZgJ76oyV1TKxSK
 m4KmMs+1nhgiXbuOp3yAlkHnVAkZ3Z8b6WRMSs7POX4L4+5LPCwTd8ON360Zde6jHoVj
 zkB2erApNm2mKH6PNSaDTzuOT3/+BExbBJ35RhxorPpi5kzPFkN2A41XwtmRD+Q+aCTM
 2AyHX3EdGNBIW+lvkjYdSdQ2Fa/Pq1eOdYYn81JlGJdPZPBnJmnDsh0YwnstoAnF0ety
 Jq4f3L2DZJYBg4XVNAoHAaod48FAmYEk3vGACbjtIAX2CNA2CmfOZpqy7wkTE0GrCqId Tg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2xrearqyj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 04:57:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00V4sPgm071523;
        Fri, 31 Jan 2020 04:57:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xva6pnhee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jan 2020 04:57:09 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00V4v8VD009079;
        Fri, 31 Jan 2020 04:57:08 GMT
Received: from kili.mountain (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 Jan 2020 20:57:07 -0800
Date:   Fri, 31 Jan 2020 07:56:59 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Henry Tieman <henry.w.tieman@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] ice: Fix a couple off by one bugs
Message-ID: <20200131045658.ahliv7jvubpwoeru@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: NeoMutt/20170113 (1.7.2)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001310042
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9516 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001310042
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hw->blk[blk]->es.ref_count[] array has hw->blk[blk].es.count
elements.  It gets allocated in ice_init_hw_tbls().  So the > should be
>= to prevent accessing one element beyond the end of the array.

Fixes: 2c61054c5fda ("ice: Optimize table usage")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/intel/ice/ice_flex_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
index 99208946224c..38a7041fe774 100644
--- a/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
+++ b/drivers/net/ethernet/intel/ice/ice_flex_pipe.c
@@ -1950,7 +1950,7 @@ ice_free_prof_id(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
 static enum ice_status
 ice_prof_inc_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
 {
-	if (prof_id > hw->blk[blk].es.count)
+	if (prof_id >= hw->blk[blk].es.count)
 		return ICE_ERR_PARAM;
 
 	hw->blk[blk].es.ref_count[prof_id]++;
@@ -1991,7 +1991,7 @@ ice_write_es(struct ice_hw *hw, enum ice_block blk, u8 prof_id,
 static enum ice_status
 ice_prof_dec_ref(struct ice_hw *hw, enum ice_block blk, u8 prof_id)
 {
-	if (prof_id > hw->blk[blk].es.count)
+	if (prof_id >= hw->blk[blk].es.count)
 		return ICE_ERR_PARAM;
 
 	if (hw->blk[blk].es.ref_count[prof_id] > 0) {
-- 
2.11.0

