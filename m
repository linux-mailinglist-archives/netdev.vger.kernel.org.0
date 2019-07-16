Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69AE6B1C7
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 00:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387762AbfGPWZe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 18:25:34 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:17838 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728434AbfGPWZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 18:25:34 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6GMCFfk118974
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 18:25:32 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tspehhrv6-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 18:25:32 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <tlfalcon@linux.ibm.com>;
        Tue, 16 Jul 2019 23:25:31 +0100
Received: from b01cxnp23033.gho.pok.ibm.com (9.57.198.28)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 16 Jul 2019 23:25:28 +0100
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6GMPRkG39387528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Jul 2019 22:25:27 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29284124054;
        Tue, 16 Jul 2019 22:25:27 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D233124053;
        Tue, 16 Jul 2019 22:25:26 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.183.21])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 16 Jul 2019 22:25:26 +0000 (GMT)
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
To:     netdev@vger.kernel.org
Cc:     bjking1@us.ibm.com, pradeep@us.ibm.com,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Jarod Wilson <jarod@redhat.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: [PATCH net] bonding: Force slave speed check after link state recovery for 802.3ad
Date:   Tue, 16 Jul 2019 17:25:10 -0500
X-Mailer: git-send-email 1.8.3.1
X-TM-AS-GCONF: 00
x-cbid: 19071622-0064-0000-0000-000003FC991D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011441; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01233183; UDB=6.00649764; IPR=6.01014494;
 MB=3.00027750; MTD=3.00000008; XFM=3.00000015; UTC=2019-07-16 22:25:29
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071622-0065-0000-0000-00003E4A1110
Message-Id: <1563315910-25634-1-git-send-email-tlfalcon@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following scenario was encountered during testing of logical
partition mobility on pseries partitions with bonded ibmvnic
adapters in LACP mode.

1. Driver receives a signal that the device has been
   swapped, and it needs to reset to initialize the new
   device.

2. Driver reports loss of carrier and begins initialization.

3. Bonding driver receives NETDEV_CHANGE notifier and checks
   the slave's current speed and duplex settings. Because these
   are unknown at the time, the bond sets its link state to
   BOND_LINK_FAIL and handles the speed update, clearing
   AD_PORT_LACP_ENABLE.

4. Driver finishes recovery and reports that the carrier is on.

5. Bond receives a new notification and checks the speed again.
   The speeds are valid but miimon has not altered the link
   state yet.  AD_PORT_LACP_ENABLE remains off.

Because the slave's link state is still BOND_LINK_FAIL,
no further port checks are made when it recovers. Though
the slave devices are operational and have valid speed
and duplex settings, the bond will not send LACPDU's. The
simplest fix I can see is to force another speed check
in bond_miimon_commit. This way the bond will update
AD_PORT_LACP_ENABLE if needed when transitioning from
BOND_LINK_FAIL to BOND_LINK_UP.

CC: Jarod Wilson <jarod@redhat.com>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
---
 drivers/net/bonding/bond_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 9b7016a..02fd782 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2196,6 +2196,15 @@ static void bond_miimon_commit(struct bonding *bond)
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->new_link) {
 		case BOND_LINK_NOCHANGE:
+			/* For 802.3ad mode, check current slave speed and
+			 * duplex again in case its port was disabled after
+			 * invalid speed/duplex reporting but recovered before
+			 * link monitoring could make a decision on the actual
+			 * link status
+			 */
+			if (BOND_MODE(bond) == BOND_MODE_8023AD &&
+			    slave->link == BOND_LINK_UP)
+				bond_3ad_adapter_speed_duplex_changed(slave);
 			continue;
 
 		case BOND_LINK_UP:
-- 
1.8.3.1

