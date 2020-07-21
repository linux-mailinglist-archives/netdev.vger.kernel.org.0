Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01FF522750A
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgGUB5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:57:23 -0400
Received: from mail-db8eur05on2133.outbound.protection.outlook.com ([40.107.20.133]:32481
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725857AbgGUB5W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 21:57:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM+Yb+4zvROpVB6UcGvrI5O9TArzss6y9jokhBG9pxoFY2wz/zabogaz5Rzsux/PKQaHLucCAYxmexeP1W5H/lBtDZF3IB1nWXNdeVKI493aZOrz3R491N1MKbH9QXbQnYMa6kdp3pgIBoksoO1VdtgLr8NpXDyRgXeOM7tYEi5iR4YVa4llAX4UrY2dITSaq/7TYVmwgpUQRWodInptgz/onu+0PGQTZi7fk8NBw7UeSvyCU2PE5Po0TYLuNp1Uh/Y4NSQNfFlke/myxb3+DVn9e9LyYa+dYEaZkl8gKK4A0wJl8rl9zpSbv/dk2GAERilVnDce3ZaDm0wtDHEZ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZVkpQYHVOZvI/+mAyqU0oJo5+XPTAIGMu/cKnmqxLo=;
 b=RiKfeSNSvL7CXKr806FObuTpG1woH7GpY82ERX16ugM7oryrrBTQcmQMu+u3ZdiZ8Ug55aCbI1R/fV1YFvYofHld6qfzmGIAQ2PcbXsIK66pDEcn2e/Weg48d3tYuQ98KITqY/OnN4R89bM5eQ/Vymfe/a1pFMDziECkVv5pYp8o4Kr+HdVUDJi7zZmTG2teAcgmB66ACg+eFEyHUDztY8n1Naj2Zy0WeZ7jSu5B1OlhvjKjShhzkk0ebxLz8pxJ5j04+jiiZGutaG7rxlL0dI6kFMRWz5Amt2hTXrPhQEKoHJ7L2L6+sNs+uOgV/7N3NpCB/S+N/Yx/voVHR8J67g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZVkpQYHVOZvI/+mAyqU0oJo5+XPTAIGMu/cKnmqxLo=;
 b=uqx9OJXKllqZxPl/Ig+e05xmpfNkFWkw2448SUkXM4TppaoV92XuEQH5xUNPRu14F9DuWgeiaKRf4TvxKGZRDi9mJ6zNMOFmxsI02ww8HR/9/snaKyiJfAIKiAjhxG1jimK6mTVZbx8tcAQbeNw+WNvipzC0IZoLNa2L+JgvGnE=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=dektech.com.au;
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18) by
 DBBPR05MB6284.eurprd05.prod.outlook.com (2603:10a6:10:c7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3195.17; Tue, 21 Jul 2020 01:57:18 +0000
Received: from DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::89e:5249:aa01:62f6]) by DB7PR05MB4315.eurprd05.prod.outlook.com
 ([fe80::89e:5249:aa01:62f6%6]) with mapi id 15.20.3195.025; Tue, 21 Jul 2020
 01:57:18 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [tipc-discussion] [net v1 1/1] tipc: allow to build NACK message in link timeout function
Date:   Tue, 21 Jul 2020 08:57:05 +0700
Message-Id: <20200721015705.2333-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) To
 DB7PR05MB4315.eurprd05.prod.outlook.com (2603:10a6:5:1f::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu.dekvn.internal (14.161.14.188) by SG2P153CA0016.APCP153.PROD.OUTLOOK.COM (2603:1096::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.0 via Frontend Transport; Tue, 21 Jul 2020 01:57:16 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50f50bb5-bfb6-451e-c345-08d82d1965c0
X-MS-TrafficTypeDiagnostic: DBBPR05MB6284:
X-Microsoft-Antispam-PRVS: <DBBPR05MB628486F14C25676DAC85D95188780@DBBPR05MB6284.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQTk2oFStBF21IR432ZKaxtskYK57Xk6PP5AyOcrAa/Xzug1JS/GLdv7rVCoeWX8S1ub0PLddMmgVAMZ41LGOqslnTEOH9ZHmPrnsZqDySK7Gxgf6bHzDFtxCUQAv6bFP/6uw7aGqrFLgvHakDXFwvzchjib+kwmvPYnif9hkYHLtfpixM9LV/C0W9HEkGUuc8Kjyns1JrROLSD0Bu5jQUD4PlI0XHiqQVZnH28DKmpM3wB7WvdJ/WsHZl4i1A9QBJGnuT3eLoHBi8/ADSnX4N64rjNXzgsgXamXUNtdzAY7HWnGdUnOk/gYDpuEEAs0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR05MB4315.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(376002)(366004)(136003)(396003)(39850400004)(6486002)(36756003)(66946007)(52116002)(8936002)(2906002)(66556008)(66476007)(5660300002)(8676002)(26005)(6666004)(6512007)(1076003)(83380400001)(15650500001)(86362001)(2616005)(956004)(6506007)(16526019)(186003)(103116003)(316002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: pu1tTR8JJaTMkbrIv2arLv83vPACPRKOf9/WAjWF3wmkJN7BQAxBzmmS19/wtsrBzzLgjBZJKmTY2RqL60UkfORMS1ia1yJGVBmZgbeCph2Dd3S6H3I3Y7pA0osn32lV/x6/UaNGEtIo2Cfb0BGAMLLkfPxxzWFFM+UgVbQeDoLI5B+QEUBnFls05ZfNbE1TQyn8bPAl3Dcm0GsSIBDHpChYBoLozyUol7pwEBzkhTxmjh/zDUOBwRgZRXJ1yLG0MZWhKOthxKu/fbHX882r3JzV+8CPA5A93LM8dJBWQmDJYFtfkOJTAVyD4BMS2dgNS9SynCdrym5OiIShKgPmPXRfvCxIAgHFJLB9JrFpdjs7ELHQyuG6NQuZ1PzCrbTAV3Q4bAv8RmP6zXqLXOxluH13ZmNoqKw+cgAsKkL+oRyxWdO2uGXddVMEEi1i3qWLHsED6PMV4Q7cj0OX5IYgUe8Kg2r4WeohqxLB/XTc1oY=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 50f50bb5-bfb6-451e-c345-08d82d1965c0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR05MB4315.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 01:57:18.1117
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBzZb191r+7FANZM/yCmg7e3zasGIbH3DGT5wVjtIafcM1LIpbZNufL5CF23HrVsK7FUBYrKkXkEur7ATYWpNuYfjCFw3gfj3tZsYZvxqdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR05MB6284
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")
eliminated sending of the 'gap' indicator in regular ACK messages and
only allowed to build NACK message with enabled probe/probe_reply.
However, necessary correction for building NACK message was missed
in tipc_link_timeout() function. This leads to significant delay and
link reset (due to retransmission failure) in lossy environment.

This commit fixes it by setting the 'probe' flag to 'true' when
the receive deferred queue is not empty. As a result, NACK message
will be built to send back to another peer.

Fixes: commit 02288248b051 ("tipc: eliminate gap indicator from ACK messages")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 263d950e70e9..d40f8e5b7683 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -827,11 +827,11 @@ int tipc_link_timeout(struct tipc_link *l, struct sk_buff_head *xmitq)
 		state |= l->bc_rcvlink->rcv_unacked;
 		state |= l->rcv_unacked;
 		state |= !skb_queue_empty(&l->transmq);
-		state |= !skb_queue_empty(&l->deferdq);
 		probe = mstate->probing;
 		probe |= l->silent_intv_cnt;
 		if (probe || mstate->monitoring)
 			l->silent_intv_cnt++;
+		probe |= !skb_queue_empty(&l->deferdq);
 		if (l->snd_nxt == l->checkpoint) {
 			tipc_link_update_cwin(l, 0, 0);
 			probe = true;
-- 
2.17.1

