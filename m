Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5351F29A6
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbgFIACn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:02:43 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:1956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730905AbgFIACl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 20:02:41 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05901htg017242;
        Mon, 8 Jun 2020 20:02:36 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31huupe3fr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jun 2020 20:02:36 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0590103a013959;
        Tue, 9 Jun 2020 00:02:35 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 31hygxr0yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 09 Jun 2020 00:02:35 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 05901Z4Z54722880
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Jun 2020 00:01:35 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F21D5B2064;
        Tue,  9 Jun 2020 00:01:34 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9C8D1B205F;
        Tue,  9 Jun 2020 00:01:33 +0000 (GMT)
Received: from oc8377887825.ibm.com.com (unknown [9.160.94.32])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Jun 2020 00:01:33 +0000 (GMT)
From:   David Wilder <dwilder@us.ibm.com>
To:     netdev@vger.kernel.org
Cc:     wilder@us.ibm.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com
Subject: [(RFC) PATCH ] be2net: Allow a VF to use physical link state.
Date:   Mon,  8 Jun 2020 17:00:59 -0700
Message-Id: <20200609000059.12924-1-dwilder@us.ibm.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-08_18:2020-06-08,2020-06-08 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=1 mlxscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 phishscore=0 clxscore=1011 spamscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006080163
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hyper-visors owning a PF are allowed by Emulex specification to provide
a VF with separate physical and/or logical link states. However, on
linux, a VF driver must chose one or the other.

My scenario is a proprietary driver controlling the PF, be2net is the VF.
When I do a physical cable pull test the PF sends a link event
notification to the VF with the "physical" link status but this is
ignored in be2net (see be_async_link_state_process() ).

The PF is reporting the adapter type as:
0xe228   /* Device id for VF in Lancer */

I added a module parameter "use_pf_link_state". When set the VF should
ignore logical link state and use the physical link state.

However I have an issue making this work.  When the cable is pulled I
see two link statuses reported:
[1706100.767718] be2net 8002:01:00.0 eth1: Link is Down
[1706101.189298] be2net 8002:01:00.0 eth1: Link is Up

be_link_status_update() is called twice, the first with the physical link
status called from be_async_link_state_process(), and the second with the
logical link status from be_get_link_ksettings().

I am unsure why be_async_link_state_process() is called from
be_get_link_ksettings(), it results in multiple link state changes
(even in the un-patched case). If I eliminate this call then it works.
But I am un-sure of this change.

Signed-off-by: David Wilder <dwilder@us.ibm.com>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c    | 9 ++++++++-
 drivers/net/ethernet/emulex/benet/be_ethtool.c | 2 --
 drivers/net/ethernet/emulex/benet/be_main.c    | 4 ++++
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 701c12c..52934b2 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -278,6 +278,8 @@ static int be_mcc_compl_process(struct be_adapter *adapter,
 	return compl->status;
 }
 
+extern int use_pf_link_state;
+
 /* Link state evt is a string of bytes; no need for endian swapping */
 static void be_async_link_state_process(struct be_adapter *adapter,
 					struct be_mcc_compl *compl)
@@ -288,13 +290,18 @@ static void be_async_link_state_process(struct be_adapter *adapter,
 	/* When link status changes, link speed must be re-queried from FW */
 	adapter->phy.link_speed = -1;
 
+	if (use_pf_link_state &&
+	    evt->port_link_status & LOGICAL_LINK_STATUS_MASK)
+		return;
+
 	/* On BEx the FW does not send a separate link status
 	 * notification for physical and logical link.
 	 * On other chips just process the logical link
 	 * status notification
 	 */
 	if (!BEx_chip(adapter) &&
-	    !(evt->port_link_status & LOGICAL_LINK_STATUS_MASK))
+	    !(evt->port_link_status & LOGICAL_LINK_STATUS_MASK) &&
+	    !use_pf_link_state)
 		return;
 
 	/* For the initial link status do not rely on the ASYNC event as
diff --git a/drivers/net/ethernet/emulex/benet/be_ethtool.c b/drivers/net/ethernet/emulex/benet/be_ethtool.c
index d6ed1d9..fd91d63 100644
--- a/drivers/net/ethernet/emulex/benet/be_ethtool.c
+++ b/drivers/net/ethernet/emulex/benet/be_ethtool.c
@@ -618,8 +618,6 @@ static int be_get_link_ksettings(struct net_device *netdev,
 	if (adapter->phy.link_speed < 0) {
 		status = be_cmd_link_status_query(adapter, &link_speed,
 						  &link_status, 0);
-		if (!status)
-			be_link_status_update(adapter, link_status);
 		cmd->base.speed = link_speed;
 
 		status = be_cmd_get_phy_info(adapter);
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index a7ac23a..1020be6 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -36,6 +36,10 @@
 module_param(rx_frag_size, ushort, 0444);
 MODULE_PARM_DESC(rx_frag_size, "Size of a fragment that holds rcvd data.");
 
+unsigned int use_pf_link_state;
+module_param(use_pf_link_state, uint, 0444);
+MODULE_PARM_DESC(use_pf_link_state, "Use physical link state");
+
 /* Per-module error detection/recovery workq shared across all functions.
  * Each function schedules its own work request on this shared workq.
  */
-- 
1.8.3.1

