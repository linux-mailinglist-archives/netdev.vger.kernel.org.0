Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B85157B9D
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 14:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731517AbgBJNbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 08:31:14 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36910 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728230AbgBJMgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 07:36:04 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01ACVDFA040963
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 07:36:03 -0500
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2y1tn4n5kv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 10 Feb 2020 07:36:03 -0500
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Mon, 10 Feb 2020 12:36:01 -0000
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Mon, 10 Feb 2020 12:35:58 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 01ACZu2k50462960
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Feb 2020 12:35:57 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6275AE05A;
        Mon, 10 Feb 2020 12:35:56 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD892AE053;
        Mon, 10 Feb 2020 12:35:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Feb 2020 12:35:56 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>
Cc:     <netdev@vger.kernel.org>, Julian Wiedmann <jwi@linux.ibm.com>
Subject: [PATCH net-next] net: vlan: suppress "failed to kill vid" warnings
Date:   Mon, 10 Feb 2020 13:35:53 +0100
X-Mailer: git-send-email 2.17.1
X-TM-AS-GCONF: 00
x-cbid: 20021012-0008-0000-0000-0000035183C3
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20021012-0009-0000-0000-00004A7220A0
Message-Id: <20200210123553.89842-1-jwi@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-10_02:2020-02-10,2020-02-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002100098
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

