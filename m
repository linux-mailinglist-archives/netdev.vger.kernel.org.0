Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE8122E662
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 09:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgG0HTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 03:19:04 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:43332
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726171AbgG0HTD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 03:19:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AwZUmQQAqoQGdj/q9pagEo9DTwAOXtx3HShcyG0oeL7+OhMBse3kPncsy1wdVtqeVLHXzNxuYn8v06BpSxrqq/TGe9TowU5vLtvVF4GK7oTMQKvMFvk4OUoy+c/s/vGhaNNc8ifRDiQt+Gm8A0nqjD6jXFhBOajYfIsjv6ccYY9Dv3nTbr6JTPHbIrnDjFOJNbuxBbtI2vUcK9YMl4IOxsbveTbtvilMFn3F7MqFvbEE9zJZkSgp37jN+re2mpx/CC1mXHYCb3SxM8qvc0DUU3EWqJ4tKrPoP+X68QzXXSUTmgBU4yHyn/8QFQ5lN6szUCJ8F2GrMHaK62SsB1GkUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5Kw3pXS3XBSQcV5M1IZFk/PExfdq2PMA6Xc0YEv5B0=;
 b=h2enWwzPw3Vt4xRmwCR73TiHwxSYUm6IVrZ4XW/SIbKAb3eP8uI2jfZs9ecX5YelhSecylFm8N5JDvw4d96oAjVDSNKfeWy44ydPqJNePM285TDT3w5501Hn90dOuxbP8yhpqBGPlOv7T3GBkQpX75Zf6xetfGGmA2sHKmTPPcTzad0KbhT3+E0CsZNtcPgn5Mmyhue1Zr6A05A4dAeGZLnec1tMM3frT1adXaGku7K+3ue0elhl1H1gP1x/naXE3qIcLweg/nTVIJF1dI4MMG0RuLo0dVDFzD5lYecQjTULQSBG7UQktP2iNClCJfje955/anxLGG7Gt477hSAMMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5Kw3pXS3XBSQcV5M1IZFk/PExfdq2PMA6Xc0YEv5B0=;
 b=ECgKlsiN+hVzejqZ6a0IrkIyTy30/B2Qn8RS4b8DrpMam9HywrJEk8/Df3ZNWUxR+EHkNTgGVCNlcBtRzBdICL1ZI0UTb4z9nvfGosSVUooJwHXpKLBg2uG4lU+7jd7xdPKkpnHmb2PKRUcnaMXhFfCV4bUyEIkDhmf1P8p7M7M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com (2603:10a6:20b:15a::7)
 by AM4PR0501MB2675.eurprd05.prod.outlook.com (2603:10a6:200:66::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Mon, 27 Jul
 2020 07:18:59 +0000
Received: from AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::4985:1285:c162:725c]) by AM0PR05MB6754.eurprd05.prod.outlook.com
 ([fe80::4985:1285:c162:725c%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 07:18:59 +0000
From:   Ido Schimmel <idosch@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, hch@lst.de,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next] ipmr: Copy option to correct variable
Date:   Mon, 27 Jul 2020 10:18:34 +0300
Message-Id: <20200727071834.1651232-1-idosch@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0101.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::42) To AM0PR05MB6754.eurprd05.prod.outlook.com
 (2603:10a6:20b:15a::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from shredder.mtl.com (193.47.165.251) by AM0PR01CA0101.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 07:18:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5b8310e-2ab2-4936-11e2-08d831fd54f7
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2675:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2675DE1345242E9162C72536BF720@AM4PR0501MB2675.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:248;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yoyKVVCasSxiwizDuLSGfDbCY1/FRFN4/Ge7fjnzO+lqCsumSrE6mDFHScO3FGxYDxuAldVxFdM7/zyJ2HTudDN0KiY8TcZQuqcz7jfuOpyf76LYd3BbyuUiQCsW9ODeq9w4mM0jEkkBYheGqb6BcNs8zM6LDWds9mkKP9uje9487aIATnHQPbAwqE20eBzuq5ao/qTV2u8FtSb86GTPvfrBgBHFxZpeJ/j90ZcTLZplOXa/XEIQinpLDDJIxaHwwUIdFovQ+oSsKGj7SY+MmP6wHUE9/ku/40lP5FbL3VyUI/at97iaH9rQ3WS9fLcu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB6754.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(366004)(136003)(396003)(39860400002)(1076003)(2906002)(83380400001)(66946007)(66476007)(66556008)(107886003)(26005)(52116002)(16526019)(6512007)(8936002)(8676002)(186003)(478600001)(36756003)(316002)(2616005)(6486002)(6506007)(956004)(6666004)(66574015)(5660300002)(6916009)(4326008)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qIBRWWbjXT4IBt07dRdVA9v373wODQY6rTKIyUUACYgFv03EcxRq+m4KjwotKM+T4dIjqIQRVWceibE/RoogpTWehJaOurttlhhm1lpbJ6JkF48d3lqhAKWAWtW/TdKGvFtkXj/Pu1Ff1Pqcx6imPbhSja4faBdmS3P3KohnmZhiYvGwzXzDtfrw33yktm4cT/ogZt7dBTySLcYmtKI9NjilvUGMRqHeGmcYaHvKcZC4XRGqMa6DdeU8jxbhApo155WhNH9tXCtFQp+m//z+h012upU14PE1n4wL/96RSsZOf+OiVL8HtWO/qr1abm6Rt4k0bKPtOv/wgQHrFGnaYgCecHba+rrIGkO2VpjyW1s8N+1nCQLP8caSwRtRMrn/BR9U2zZL5Bh6UU+pNuwH3MLIGY3NjC9g77Q3WY3hlb5pwq//UzN7/oP//gwigI//n3uHYoBW3NbQHnHd5AtdIS7npt45EGM5RB0kAYBb0HFnMYkiTDSdVSimTWNGYQDh
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5b8310e-2ab2-4936-11e2-08d831fd54f7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB6754.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 07:18:59.6682
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/XrUAP7oUva4sz7Y5Jia/BmiTpHkp/DINMCvLjyKXSApbKUYcMnD/w0EBZ+sATo8jLntzayinVgXrcUg+oy9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2675
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cited commit mistakenly copied provided option to 'val' instead of to
'mfc':

```
-               if (copy_from_user(&mfc, optval, sizeof(mfc))) {
+               if (copy_from_sockptr(&val, optval, sizeof(val))) {
```

Fix this by copying the option to 'mfc'.

selftest router_multicast.sh before:

$ ./router_multicast.sh
smcroutectl: Unknown or malformed IPC message 'a' from client.
smcroutectl: failed removing multicast route, does not exist.
TEST: mcast IPv4                                                    [FAIL]
        Multicast not received on first host
TEST: mcast IPv6                                                    [ OK ]
smcroutectl: Unknown or malformed IPC message 'a' from client.
smcroutectl: failed removing multicast route, does not exist.
TEST: RPF IPv4                                                      [FAIL]
        Multicast not received on first host
TEST: RPF IPv6                                                      [ OK ]

selftest router_multicast.sh after:

$ ./router_multicast.sh
TEST: mcast IPv4                                                    [ OK ]
TEST: mcast IPv6                                                    [ OK ]
TEST: RPF IPv4                                                      [ OK ]
TEST: RPF IPv6                                                      [ OK ]

Fixes: 01ccb5b48f08 ("net/ipv4: switch ip_mroute_setsockopt to sockptr_t")
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 net/ipv4/ipmr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index cdf3a40f9ff5..876fd6ff1ff9 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1441,7 +1441,7 @@ int ip_mroute_setsockopt(struct sock *sk, int optname, sockptr_t optval,
 			ret = -EINVAL;
 			break;
 		}
-		if (copy_from_sockptr(&val, optval, sizeof(val))) {
+		if (copy_from_sockptr(&mfc, optval, sizeof(mfc))) {
 			ret = -EFAULT;
 			break;
 		}
-- 
2.26.2

