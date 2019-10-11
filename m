Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9B49D35BD
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 02:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727523AbfJKAYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 20:24:48 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:1764 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfJKAYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 20:24:48 -0400
Received: from pps.filterd (m0050096.ppops.net [127.0.0.1])
        by m0050096.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x9B0C57E001355;
        Fri, 11 Oct 2019 01:24:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=UwuDjo9NhfggdU4lrFCRMh8ub8Sz7aotcSie1LBSXV0=;
 b=AXtasmK7P36u08bp+P2XZi4Te+lncez/U08SmPxBFRU1b6SChVYnrE/CZci2B44PC3QY
 TVM+VB3xgkiN13HGNjsHq55wdSlmkH1tZUp9PddRZRFBdaByDL/0O+QqmYh1iLr9fV2J
 s8XzS3ogg5Z5SJahD4Ea3cRT0P82wJPH67aSejh9lKFx2W3kyn7Nvu3D5/fWhDDriZLm
 nfTJVdwOuJecW9xA5kkQ03GdOrlKfpdabJv4Un0JWmyIL/cv4mHmYPUAsdyg3wVW/7/h
 8t8C1MUtSvHsXo7jvobilVsyXhABx/Ul/2XVA89sqREggpY+xgmy6hLNukLwGbPSC8se zw== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by m0050096.ppops.net-00190b01. with ESMTP id 2vekk93u1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 01:24:36 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9B0Gc97020808;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2veph46f1c-1;
        Thu, 10 Oct 2019 20:24:35 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 7689781453;
        Fri, 11 Oct 2019 00:24:35 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1iIijw-0001b1-LZ; Thu, 10 Oct 2019 20:25:04 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        jeffrey.t.kirsher@intel.com
Cc:     willemb@google.com, sridhar.samudrala@intel.com,
        aaron.f.brown@intel.com, alexander.h.duyck@linux.intel.com,
        Josh Hunt <johunt@akamai.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: [PATCH v2 3/3] i40e: Add UDP segmentation offload support
Date:   Thu, 10 Oct 2019 20:25:02 -0400
Message-Id: <1570753502-6014-4-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570753502-6014-1-git-send-email-johunt@akamai.com>
References: <1570753502-6014-1-git-send-email-johunt@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-10_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=947
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910110000
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-10_09:2019-10-10,2019-10-10 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015 mlxscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 phishscore=0 mlxlogscore=971 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910110000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on a series from Alexander Duyck this change adds UDP segmentation
offload support to the i40e driver.

CC: Alexander Duyck <alexander.h.duyck@intel.com>
CC: Willem de Bruijn <willemb@google.com>
Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c |  1 +
 drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 +++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6031223eafab..56f8c52cbba1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12911,6 +12911,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
 			  NETIF_F_GSO_IPXIP6		|
 			  NETIF_F_GSO_UDP_TUNNEL	|
 			  NETIF_F_GSO_UDP_TUNNEL_CSUM	|
+			  NETIF_F_GSO_UDP_L4		|
 			  NETIF_F_SCTP_CRC		|
 			  NETIF_F_RXHASH		|
 			  NETIF_F_RXCSUM		|
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index e3f29dc8b290..2250284e27fd 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -2960,10 +2960,16 @@ static int i40e_tso(struct i40e_tx_buffer *first, u8 *hdr_len,
 
 	/* remove payload length from inner checksum */
 	paylen = skb->len - l4_offset;
-	csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
 
-	/* compute length of segmentation header */
-	*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)) {
+		csum_replace_by_diff(&l4.tcp->check, (__force __wsum)htonl(paylen));
+		/* compute length of segmentation header */
+		*hdr_len = (l4.tcp->doff * 4) + l4_offset;
+	} else {
+		csum_replace_by_diff(&l4.udp->check, (__force __wsum)htonl(paylen));
+		/* compute length of segmentation header */
+		*hdr_len = sizeof(*l4.udp) + l4_offset;
+	}
 
 	/* pull values out of skb_shinfo */
 	gso_size = skb_shinfo(skb)->gso_size;
-- 
2.7.4

