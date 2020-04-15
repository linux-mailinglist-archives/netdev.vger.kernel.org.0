Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 324061AA428
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370783AbgDONSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 09:18:38 -0400
Received: from mail-am6eur05on2107.outbound.protection.outlook.com ([40.107.22.107]:34112
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2897012AbgDOLfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Apr 2020 07:35:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LhzP1uGNnQk6csSdnY0ACZ/q/TWh4j4oGbtaD9G0oi/FoAnkkeqf//DwVhfCpOFlzHIQh2e6KYHrz3R6FG0Hykdfm3DxJYZJvR5u5Q0ulYMXXcet8DMIuM2Hmuu0oMpOf09SwmSCXf8Z69a7CDNveKVZM4GVI3U8mpb+JTGrJaXHy0Q6v8WlClzdSH9+SCBxKZ8xcITgPEa4Oz7gAqeqOd6Bumk/Bix/PXmeBO5+mk15ge58P+6vSY0VB/lalh+7PXrYrO0dfdBq1Aa2utrEnLjqbWWbGRIqWnK/eLwp1dbIl7zfEvDomTbZYIN6+Z4numXd1F8/Buykv8y7vm42KA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gh/2NdgvetxP4k4eQjfDU2laTC+uwc/yg5UlMCp2nk=;
 b=ezYusPOkE7xMbSZy10OsWCI8DTLPjJPhN3mtaJerDaj7ox5ROKgJKNUxb9J9EdO5EiTDu64K9utHKmj5oXujTc1Mtgd7lGo0POSjhlF3jc3Rp/Wg66JMuhJmyGBxSCZuxc02duo5ZPWwumBpEtPBWOLROXL3YV9SvpSsgRVCD/ju8EOl8GYWBYV47J+3y3zj6qsloOqDRFYOa8H6j/j2VWIOldLibsVG0nBmIMiqPJ9sGU6+Ohz5Zl7bsxQMdPnx68rklgj3HLuTEWyTGglKMeAHgAf0kvhkr3MoaYEqRDw6b5h2hFGPExCh/dpBU1seVIHYJOfUwG1y5KDqkxfSKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5gh/2NdgvetxP4k4eQjfDU2laTC+uwc/yg5UlMCp2nk=;
 b=iyG1BWw5nOwepAjVWUr7QkVPVnVgfImZKmHkR0D0IEE56uNlLLZKVmszc63r/KlkSET/+vR+yoFc0SyUCZA99kBgE4k0O2NCAluYfQZQAsOuSsXLxslcPudacZYHXaOqNJq8h/DTZT8BogSS0wzWzGY4eGIU/UmJQeZxGMFa8W4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=tuong.t.lien@dektech.com.au; 
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com (2603:10a6:209:5::28)
 by AM6PR0502MB3991.eurprd05.prod.outlook.com (2603:10a6:209:1e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Wed, 15 Apr
 2020 11:34:58 +0000
Received: from AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::5941:e5bd:759c:dd8c]) by AM6PR0502MB3925.eurprd05.prod.outlook.com
 ([fe80::5941:e5bd:759c:dd8c%6]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 11:34:58 +0000
From:   Tuong Lien <tuong.t.lien@dektech.com.au>
To:     davem@davemloft.net, jmaloy@redhat.com, maloy@donjonn.com,
        ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     tipc-discussion@lists.sourceforge.net
Subject: [net] tipc: fix incorrect increasing of link window
Date:   Wed, 15 Apr 2020 18:34:49 +0700
Message-Id: <20200415113449.7289-1-tuong.t.lien@dektech.com.au>
X-Mailer: git-send-email 2.13.7
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0101.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::27) To AM6PR0502MB3925.eurprd05.prod.outlook.com
 (2603:10a6:209:5::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (113.22.229.239) by SG2PR01CA0101.apcprd01.prod.exchangelabs.com (2603:1096:3:15::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2921.25 via Frontend Transport; Wed, 15 Apr 2020 11:34:56 +0000
X-Mailer: git-send-email 2.13.7
X-Originating-IP: [113.22.229.239]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 86beeef1-20ae-4022-2edf-08d7e13106de
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3991:
X-Microsoft-Antispam-PRVS: <AM6PR0502MB3991FD00AE1EA6DEDD1747ADE2DB0@AM6PR0502MB3991.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-Forefront-PRVS: 0374433C81
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0502MB3925.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(136003)(39840400004)(376002)(346002)(396003)(4326008)(6666004)(316002)(66476007)(66556008)(2616005)(2906002)(8936002)(52116002)(956004)(7696005)(5660300002)(8676002)(55016002)(478600001)(86362001)(103116003)(1076003)(36756003)(16526019)(186003)(81156014)(26005)(66946007);DIR:OUT;SFP:1102;
Received-SPF: None (protection.outlook.com: dektech.com.au does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1bQw7psW8vQPTFWUHKOOmmwAXBiunW6dD+/kB3Tr9EsyAFx+MU6gWWqJCs1giRsXK9G80RsHTv4tEku5j1SgIXgwxhTLyceZddg8zoSmtj8e/8/sPAsrivCS4U+dVqdgorWRbvm82jdJI7OXbfDVOLe+yGB2Z0r0Wk9GEUzLua1W563P5sxRf920PFjkd4UNXrE1yOv5+jR86cz4DWLeKoDXK0PaCtDlDazSsoDLmoyE8Ns9lOIHPF6wf7SZ9l96bIaqQ+vIir4FGMAaB4nafDg9bZGZXMBhYuaTXNF2o2WS0K9QPRVdO1stuCmf2QFQv86AjGpddujEKcj/Yj7WzJMWsoehFLQU1MII1PWKEWtkx3CdTIlPBQzkUoTC0oV2W2oXbS6XmYGzZv7XuhTAOwborbH0CKVPcKD4oMVspFIcPcwVj09OTsOwZVMYQd7y
X-MS-Exchange-AntiSpam-MessageData: L3FpgzSCyUNll8nva/eSmQGZlbsvRTnIqpv/YsW7vXz8wCyIuhJ1Lq6jFKBxkys5Uf0qZqxR7xwFX2Yam9TVu5c8OuMN7zJxUHHlqi/p4GVkBfx+jwn8M0hn9J/zOX4KMuvjB0Ky8URPtDoAgAr4Ig==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 86beeef1-20ae-4022-2edf-08d7e13106de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2020 11:34:58.4344
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KZ8NbuXKeqJSZHQ4DsS6+FgwgN/BvAX6OTnfDw8q8+mEyeybu3FdTmU9YxTBuPlRJnmR4gwOH6/rp98Z2/pRdozv0NX9AAJxOo054q33dWM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3991
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 16ad3f4022bb ("tipc: introduce variable window congestion
control"), we allow link window to change with the congestion avoidance
algorithm. However, there is a bug that during the slow-start if packet
retransmission occurs, the link will enter the fast-recovery phase, set
its window to the 'ssthresh' which is never less than 300, so the link
window suddenly increases to that limit instead of decreasing.

Consequently, two issues have been observed:

- For broadcast-link: it can leave a gap between the link queues that a
new packet will be inserted and sent before the previous ones, i.e. not
in-order.

- For unicast: the algorithm does not work as expected, the link window
jumps to the slow-start threshold whereas packet retransmission occurs.

This commit fixes the issues by avoiding such the link window increase,
but still decreasing if the 'ssthresh' is lowered.

Fixes: 16ad3f4022bb ("tipc: introduce variable window congestion control")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tuong Lien <tuong.t.lien@dektech.com.au>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 467c53a1fb5c..d4675e922a8f 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1065,7 +1065,7 @@ static void tipc_link_update_cwin(struct tipc_link *l, int released,
 	/* Enter fast recovery */
 	if (unlikely(retransmitted)) {
 		l->ssthresh = max_t(u16, l->window / 2, 300);
-		l->window = l->ssthresh;
+		l->window = min_t(u16, l->ssthresh, l->window);
 		return;
 	}
 	/* Enter slow start */
-- 
2.13.7

