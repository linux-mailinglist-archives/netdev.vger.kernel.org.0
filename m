Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284EB1EB4AF
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 06:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgFBEq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 00:46:58 -0400
Received: from mail-eopbgr70127.outbound.protection.outlook.com ([40.107.7.127]:6279
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725937AbgFBEq5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jun 2020 00:46:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AFqmzJXiJ0FMPDBWsW9+AFac9KmnatcO5Y4y6d19C0oM3pYigQXT4AZJP9D5jSxcL0ivfWArWzwy3jvIfH7uacXIBApptdWzqQtdggl6EGY8zVnnYOLqizyVuiWi9gIVZ+HnRFdpDeuTPIVsTbAdXfJ8Um894LPVdH03OXV1WBcZvFzh+ANGMMIWyidMF7h3Ccnz7khSOK5yYqwChOO6kO0kT/Mh/HII67IPZvzGvDSOELFkSemZHWAKmiGRtxHIwOf9Et7F5w5BymUmWSPItGgL0IX2GT2Zpcq01BPGGauIzF50M4SEpWlX1wbMA0Wuj/ZBDZmJjrjNkSF1vfON6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/IX3YAu4nw1cJ8Qg01THC5lwvUWmZhvz+Oox0M4+ZE=;
 b=fvbUgqtc0D707sPCg3NLEg3ctKsClHowvbv2ozcin7c7RtTCveLOk7+nMERYonUCBnzGexJzqLSSb+CzrfV4fhobJntCwnTUFRQAjZx8SdlPvW3KHeju7cFby5e4KAQzPQcFf1V/Yp2J5yzALaol2W0Ryu18HehiPliW1M1AZ1P2RQddnOp3sPJXd6IFpE0DkCDx5X/Qd/ROpEqsC6HTqQebqNuIo6g9fSKaVwcX2B7VPMRYxv1methLL+JJXdDJqFE5dra+6Wt8PWEMUulHeSdrnBeCiehrRuRytwRj3oOIXtCfDKhMK0TcjiSmKDknG7un04z8CJBJ0dveyNhcZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X/IX3YAu4nw1cJ8Qg01THC5lwvUWmZhvz+Oox0M4+ZE=;
 b=gtnAN9Ea1mSGTl8ytr1hiBZl64pzxEkFvIet6CZhgplUo45n+6u/5Q7zP2E+wiIVGazRTUl8OlZ3XdZhjT20IvuZMP2GvKfAWXw0x4ZuJmIqK6SkJ9o2PAL/dqFzWt0xcr50GyIij76G0Ig30xkzrfQoBMmH9QYbfoSgrtNDD2o=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6SPR01MB0038.eurprd05.prod.outlook.com (2603:10a6:20b:3b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Tue, 2 Jun
 2020 04:46:52 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::4d5f:2ab:5a66:deaf%7]) with mapi id 15.20.3045.024; Tue, 2 Jun 2020
 04:46:52 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net 1/2] Revert "tipc: Fix potential tipc_node refcnt leak in tipc_rcv"
Date:   Tue,  2 Jun 2020 11:46:40 +0700
Message-Id: <20200602044641.10535-2-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
In-Reply-To: <20200602044641.10535-1-tuong.t.lien@dektech.com.au>
References: <20200602044641.10535-1-tuong.t.lien@dektech.com.au>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19)
 To AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by SGBP274CA0007.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.17 via Frontend Transport; Tue, 2 Jun 2020 04:46:50 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 99e1ea4b-dec2-4a4c-124e-08d806aff7c8
X-MS-TrafficTypeDiagnostic: AM6SPR01MB0038:
X-Microsoft-Antispam-PRVS: <AM6SPR01MB0038FAB3E4867498E8BFD638E28B0@AM6SPR01MB0038.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0422860ED4
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ze5QFqoDn/qwFZaWiF6WK+SkSlsmvRjSOV/QOvSilYx2Bg9xJspus8CkZtG53lkZQQhvnZNxfCUnXD9oMggV4EKixuq6EZU83uUZFUHX/rZ9Pwl29G5sB7us9cOEx+lZZ9E/k1TjTweEMM/BkwlPVQnGEFwbZ67NMJ9nslkNUF5GWdVmK3qcfUkvury3oeGydE3kQJ3WjXGLb3aC3+UUBUIeQD2LpSJ4RjMHVdQHTjVgLAMQyUChoEf6o70dwnw2BEqlBEThdgufzo+2MAFG8zwLqf+G94UEwpQOuJu4V/Z4PrH0nULtvbhexogFXn0/RC7DMtFB/B8zZY9fM3K8vQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(136003)(346002)(396003)(39850400004)(376002)(478600001)(86362001)(66476007)(66556008)(5660300002)(36756003)(83380400001)(8936002)(55016002)(103116003)(66946007)(1076003)(26005)(2616005)(16526019)(7696005)(52116002)(956004)(6666004)(4326008)(186003)(2906002)(316002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: wsT5ATHqfg6+g3ZjE3a/NQYbBmF7RLzeE5G+0/94H/ILj8kjyEbwfXiyQIWF/Wkl7jKukI2A1ZwY7jZ82ShZLgVvF1CSs3WpNLP2nStGS0zDz89zicSzzcizmMXFF61vte4u3sCUViVb8sS28+ivHq8MnAtZVGTSsb0Tl/Z9D3OAmluFfhqxnhCcTQ4/U1n0UdLr3LWugJkdtoGio6hqMt/hKe5Zfva4QW+tdyupkxoqR2asXzh8X1asPAgLjJ7C4UAANtOaAQNeM8tmul/sW6kwtSDSEk+/2d0tg3ppYYs1SiWZsvaNHdDim/HY6hl+yf9HB/iQnW70lLD/p6CYVMp6vIO8yYb4a5xpS8Bmku/jiihcGzUQuGX+D3FMWqSIJj5/ss9TF1m1thuWkJ/caZVngDi3QR3umRSxDKVBNK2CDhIOiQ3Fux8fZ98JL1qEtbrU+eijEHrrYckZYGpyMuaEaJjKjvlUA2SEinnXE9I=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e1ea4b-dec2-4a4c-124e-08d806aff7c8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2020 04:46:52.2041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VX5hmR9EnyN7O/i6jnA8wWR9P5aVm/xzFMVUjFprA0s9FzsUdtVVVEn+DF4W/QnkppgykNz2/A7Eeh5KeMgiLvZFksa6Cp2N/VINZV3HA7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6SPR01MB0038
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit de058420767df21e2b6b0f3bb36d1616fb962032.

There is no actual tipc_node refcnt leak as stated in the above commit.
The refcnt is hold carefully for the case of an asynchronous decryption
(i.e. -EINPROGRESS/-EBUSY and skb = NULL is returned), so that the node
object cannot be freed in the meantime. The counter will be re-balanced
when the operation's callback arrives with the decrypted buffer if any.
In other cases, e.g. a synchronous crypto the counter will be decreased
immediately when it is done.

Now with that commit, a kernel panic will occur when there is no node
found (i.e. n = NULL) in the 'tipc_rcv()' or a premature release of the
node object.

This commit solves the issues by reverting the said commit, but keeping
one valid case that the 'skb_linearize()' is failed.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index 0312fb181d94..a4c2816c3746 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2038,7 +2038,6 @@ void tipc_rcv(struct net *net, struct sk_buff *skb, struct tipc_bearer *b)
 		n = tipc_node_find_by_id(net, ehdr->id);
 	}
 	tipc_crypto_rcv(net, (n) ? n->crypto_rx : NULL, &skb, b);
-	tipc_node_put(n);
 	if (!skb)
 		return;
 
-- 
2.13.7

