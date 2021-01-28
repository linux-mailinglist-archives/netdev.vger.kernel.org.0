Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 080D1307508
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 12:43:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhA1Lm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 06:42:26 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:26712 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231468AbhA1Ll7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 06:41:59 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10SBWbst193829;
        Thu, 28 Jan 2021 06:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=9r618lJb1xTA+p6kWIB8lNUMYLvAPdpPAvUHjd3QEh4=;
 b=EA3Q5EpFIhcPbQpdKcVr+4e3Q9c4p5ZzJjrLi0AYIIqqcj5s/k6YpvgVKvygXbNg+QHr
 SyRdUKXeM/b0VusZY/ayAw5DXT+EFCxSVA3DI90y7Y8wfswbC8eGukjjrG1+Bm0L0lXd
 nS9lE8qKvTXEo9pnO1gKlCVKyFnSYLKi09NtDm/bOj5cfxIsSninB5xcZBrDuPWllFwd
 eZyXzm0BcPMPJC7YQkVwiIM5lWo9wrQwNcIPIRBWbt57L/9AkRfHmfrpPfLRc96UcueX
 M7kyYZWZ3MIg4z/Ib1h/+e3VHInfWhQiZ0qzrH0LHJ/nB021wZReNEoUFPT+gLtEHTlm fg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 36bkuxdvt0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 06:41:15 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10SBcnMp024255;
        Thu, 28 Jan 2021 11:41:14 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 368be8cruy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jan 2021 11:41:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10SBfBYY44564746
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 11:41:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F211A4C046;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 995834C040;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 28 Jan 2021 11:41:10 +0000 (GMT)
From:   Julian Wiedmann <jwi@linux.ibm.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexander Egorenkov <egorenar@linux.ibm.com>
Subject: [PATCH net-next 1/5] net/af_iucv: remove WARN_ONCE on malformed RX packets
Date:   Thu, 28 Jan 2021 12:41:04 +0100
Message-Id: <20210128114108.39409-2-jwi@linux.ibm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
References: <20210128114108.39409-1-jwi@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-28_05:2021-01-27,2021-01-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 suspectscore=0 adultscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 mlxlogscore=999
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280055
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Egorenkov <egorenar@linux.ibm.com>

syzbot reported the following finding:

AF_IUCV failed to receive skb, len=0
WARNING: CPU: 0 PID: 522 at net/iucv/af_iucv.c:2039 afiucv_hs_rcv+0x174/0x190 net/iucv/af_iucv.c:2039
CPU: 0 PID: 522 Comm: syz-executor091 Not tainted 5.10.0-rc1-syzkaller-07082-g55027a88ec9f #0
Hardware name: IBM 3906 M04 701 (KVM/Linux)
Call Trace:
 [<00000000b87ea538>] afiucv_hs_rcv+0x178/0x190 net/iucv/af_iucv.c:2039
([<00000000b87ea534>] afiucv_hs_rcv+0x174/0x190 net/iucv/af_iucv.c:2039)
 [<00000000b796533e>] __netif_receive_skb_one_core+0x13e/0x188 net/core/dev.c:5315
 [<00000000b79653ce>] __netif_receive_skb+0x46/0x1c0 net/core/dev.c:5429
 [<00000000b79655fe>] netif_receive_skb_internal+0xb6/0x220 net/core/dev.c:5534
 [<00000000b796ac3a>] netif_receive_skb+0x42/0x318 net/core/dev.c:5593
 [<00000000b6fd45f4>] tun_rx_batched.isra.0+0x6fc/0x860 drivers/net/tun.c:1485
 [<00000000b6fddc4e>] tun_get_user+0x1c26/0x27f0 drivers/net/tun.c:1939
 [<00000000b6fe0f00>] tun_chr_write_iter+0x158/0x248 drivers/net/tun.c:1968
 [<00000000b4f22bfa>] call_write_iter include/linux/fs.h:1887 [inline]
 [<00000000b4f22bfa>] new_sync_write+0x442/0x648 fs/read_write.c:518
 [<00000000b4f238fe>] vfs_write.part.0+0x36e/0x5d8 fs/read_write.c:605
 [<00000000b4f2984e>] vfs_write+0x10e/0x148 fs/read_write.c:615
 [<00000000b4f29d0e>] ksys_write+0x166/0x290 fs/read_write.c:658
 [<00000000b8dc4ab4>] system_call+0xe0/0x28c arch/s390/kernel/entry.S:415
Last Breaking-Event-Address:
 [<00000000b8dc64d4>] __s390_indirect_jump_r14+0x0/0xc

Malformed RX packets shouldn't generate any warnings because
debugging info already flows to dropmon via the kfree_skb().

Signed-off-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Reviewed-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
---
 net/iucv/af_iucv.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index 882f028992c3..427a1abce0a8 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -2036,7 +2036,6 @@ static int afiucv_hs_rcv(struct sk_buff *skb, struct net_device *dev,
 	char nullstring[8];
 
 	if (!pskb_may_pull(skb, sizeof(*trans_hdr))) {
-		WARN_ONCE(1, "AF_IUCV failed to receive skb, len=%u", skb->len);
 		kfree_skb(skb);
 		return NET_RX_SUCCESS;
 	}
-- 
2.17.1

