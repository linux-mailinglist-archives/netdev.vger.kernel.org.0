Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CE91E27FF
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 19:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388061AbgEZRKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 13:10:45 -0400
Received: from mail-eopbgr40061.outbound.protection.outlook.com ([40.107.4.61]:58964
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728339AbgEZRKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 13:10:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BFEY73RNz77P/Fkp+yFdx5ixIc6w1Yucbb0dqVBFhblkWF6XuTcUGM3kqS0i7I256beo8LmEepe9GMph6ftJ2DefFbrUrk5M/KMNA+NYPtFxpGBKkEh32nji35lCgGqY1LZanFay4brVPh4JuBYKnAbhs1qgT0XdneBSwXvHxgPeZUKfW+59iInj6RjZAxBEecNlwf1g4WGNM3USXi8+qiScywQg2me79lbvpYva081sm1az6FPQOeStLAsjyfZcSu6gXhZMfTNG83QrbG++lxo1wdEu51eTQbLVxVgNmhO5gmlnbyuM1wDrCr8fmgsWepAm/Cfhl+Am4ocVuVtQzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpJ6OItV4Be4W+lnnv60DCs9G8TRjZUA7ZkzI5FtPjU=;
 b=Sh/8q5GKkxdmnfbh8gtXdJXabO8ehlqnOmofyPsx12oUXy1id9PcLM06xu9kLs9sDJ/V7jIZ5c/UyoNv8VavwgIPNYn88YuPT4m33uMpEhY+QNni8Et1CYn+3r6AGhFDAqS/2I35S/Fbqci4gqHsVEXyK6FTwjgOm9oCMG33ikiqLPWCnKsKp8dPLPzTNns+rWnuHUQWeLYirkDIahaIo6QKsNiJhmx/lyY1Hha68JNcoXdmr9cSxNoY8VquiY3ZAJenaB7+pOHVFNUyHb6fguXdMfItVamAq522eFqiwS7eY/qNHYKtMBWQDmlnpWWCe5aZk7/+5BeelsGoCCLpZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpJ6OItV4Be4W+lnnv60DCs9G8TRjZUA7ZkzI5FtPjU=;
 b=j3Tvt0OugQqnIFQ8vN5zunFulrSJ4oGQpOCedN7fb7ayKsA8ZNcJ75gyPt99CqTLFqGX7te8KbJ2+Q9d4l1N0rLIbbRtowkQ2ENJW5w8kot7nYfL/m6mTi7y0DdQGqlRlLQWS9xRSvKsZNzEHS8bUd7/daRjW/Jmxgmy2zdgZl8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3225.eurprd05.prod.outlook.com (2603:10a6:7:37::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Tue, 26 May 2020 17:10:36 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::454c:b7ed:6a9c:21f5%7]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 17:10:36 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, jhs@mojatatu.com,
        jiri@mellanox.com, idosch@mellanox.com,
        Petr Machata <petrm@mellanox.com>
Subject: [RFC PATCH iproute2-next 1/4] uapi: pkt_sched: Add two new RED attributes
Date:   Tue, 26 May 2020 20:10:08 +0300
Message-Id: <b4fb87c7d38ab9b8ed4d67bec0a22dd602a11fbf.1590512905.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590512901.git.petrm@mellanox.com>
References: <cover.1590512901.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0034.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::47) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR02CA0034.eurprd02.prod.outlook.com (2603:10a6:208:3e::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 17:10:34 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 16940c0f-ce68-4795-d79b-08d80197b4d6
X-MS-TrafficTypeDiagnostic: HE1PR05MB3225:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB322508A1FA8AEC38245FB55EDBB00@HE1PR05MB3225.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FOrka8Et4Fx3ysJUH7NsVhqTRtNBAOdlc8UAOxodaUUKGEgFDV1KmR9L3wlx6GNchnVM6RUjLB565QYSYmt2anUZetc0sKQ20KzwK2UDNBvPSNjbgGoMCwCJHS/62Q0lygv0gQ1NbFjiZjn/jk8MSfKkzgKKn7Nje1mRd7GXSfqQynn8Mmj32meaU0zsiuC89mLpzNJ0RLPacTRe98Iv7kf3y9xKQaZG8WzSNcdy5VaDZ0N15gRfJP93yYNe+kq6v2F5o4609a3OvrISPwpvirdRPJfzgGJEXre6U2DhLGJr7PNbu8XNY2u4ku6cTvkyIJHXnoWtpRQeFDU8quS5cQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(136003)(396003)(39840400004)(366004)(956004)(6486002)(2616005)(26005)(186003)(52116002)(6506007)(86362001)(2906002)(8676002)(8936002)(16526019)(5660300002)(6666004)(36756003)(6512007)(54906003)(6916009)(66556008)(107886003)(4326008)(4744005)(478600001)(66946007)(66476007)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: fMDpYmdJaspnbSSbTETJ900Qsb7k19EdedrGCXVfwbRbR2sPTy+hS4oHhSzsHCwFNOzPg0ql80tnzP0Ko0UcgqYf3oa58KSbbUgqytPtit/o0XJALqE0vm4IMv2IFz3UZSsv0zpXmlkyJwYkrAn+Qq2uzLgkRHJgp4R4ikTNgAsc+yDF2/+9NMBNTomYz4/ipV/9VIURUecSAXfpw1I55qOb2HAK2pyq/dLMflwWoPKe33akjavwyK57dRKiZBF8SnQGFqq2/UBGEl/iBoZz7Bj/uATw0/8ZZ2KwBOD9UJtODZ4+ti1PHrSHyVAIiS8bNlVOef14APZFdQPKclR+kBuzLu87mULESKdE68fXrGJdEvmYHX6V1xzshocTZsZ6VWVxnl7ioc7nBQFCMQ7RsQYM9WK5DITtbXh5y7xUzQ+ZGIcuDO7bz7gzKXnqY0o/uKYbERA7ofCEZ+nnd3ywqb2lb9iCrzl2PrwcilK2P/F4yT9K36cR2RZSfh+E9VEc
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16940c0f-ce68-4795-d79b-08d80197b4d6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 17:10:36.1931
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Wgnbwi1BgdZgPVwdp1lfNY6KO4utbYnTBklBWIf7JGzcK15unLMj6wDwfgf2kLNMELA/UC4IjaDI6Wl0OeVoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3225
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index 0c02737c..203272df 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -257,6 +257,8 @@ enum {
 	TCA_RED_STAB,
 	TCA_RED_MAX_P,
 	TCA_RED_FLAGS,		/* bitfield32 */
+	TCA_RED_EARLY_BLOCK,	/* u32 */
+	TCA_RED_MARK_BLOCK,	/* u32 */
 	__TCA_RED_MAX,
 };
 
-- 
2.20.1

