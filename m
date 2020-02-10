Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1889C1578DB
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbgBJNKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:10:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730489AbgBJNKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 08:10:48 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ACxPfg107325
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 08:10:46 -0500
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2y1u9nwt69-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 08:10:46 -0500
Received: from localhost
        by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 10 Feb 2020 13:10:44 -0000
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp04.uk.ibm.com (192.168.101.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 13:10:42 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ADAeNr41943454
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 13:10:40 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8BDDAE059;
        Mon, 10 Feb 2020 13:10:40 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 91CE8AE045;
        Mon, 10 Feb 2020 13:10:40 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 13:10:40 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next] net: vlan: suppress "failed to kill vid" warnings
Date:   Mon, 10 Feb 2020 14:10:38 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20021013-0016-0000-0000-000002E57C13
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021013-0017-0000-0000-000033486D1B
Message-Id: <20200210131038.65344-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 lowpriorityscore=0 suspectscore=0 clxscore=1015 mlxlogscore=999 mlxscore=0
 malwarescore=0 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002100102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a real dev unregisters, vlan_device_event() also unregisters all
of its vlan interfaces. For each VID this ends up in __vlan_vid_del(),
which attempts to remove the VID from the real dev's VLAN filter.

But the unregistering real dev might no longer be able to issue the
required IOs, and return an error. Subsequently we raise a noisy warning
msg that is not appropriate for this situation: the real dev is being
torn down anyway, there shouldn't be any worry about cleanly releasing
all of its HW-internal resources.

So to avoid scaring innocent users, suppress this warning when the
failed deletion happens on an unregistering device.
While at it also convert the raw pr_warn() to a more fitting
netdev_warn().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/8021q/vlan_core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/8021q/vlan_core.c b/net/8021q/vlan_core.c
index a313165e7a67..78ec2e1b14d1 100644
--- a/net/8021q/vlan_core.c
+++ b/net/8021q/vlan_core.c
@@ -359,9 +359,8 @@ static void __vlan_vid_del(struct vlan_info *vlan_info,
 	int err;
 
 	err = vlan_kill_rx_filter_info(dev, proto, vid);
-	if (err)
-		pr_warn("failed to kill vid %04x/%d for device %s\n",
-			proto, vid, dev->name);
+	if (err && dev->reg_state != NETREG_UNREGISTERING)
+		netdev_warn(dev, "failed to kill vid %04x/%d\n", proto, vid);
 
 	list_del(&vid_info->list);
 	kfree(vid_info);
-- 
2.17.1

