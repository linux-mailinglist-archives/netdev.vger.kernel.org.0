Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7456C334C
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 14:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjCUNuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 09:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjCUNuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 09:50:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD68A37577;
        Tue, 21 Mar 2023 06:50:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VtCi26BuqyPJrE1CXCK+csn9x2kqW1v80ItdMtuV0AHEzUsEqreIFwTAR3VDRDp5BXLpULoqngYUOZ8pygFU35Uk8eQxHFC9j4jVEO3TnPaSu4wQaVNB1+Ay1nwGPcH+iax0dZd6GlN7Dp0c0+OSmMl6xGy65prwmHxfriM9FMDA7GXUH7nAG3E1eCaIJbAW7uZrfD56N72iH/gf1qlP6GJe/L5gu6O62ZsLh+9aI6AH9y2LOTznfZZhzH9Mr2H+qYUOvBlOy/noJifksE1vi0rbowFCRgtlPtBLhB4gqR/qkdLbCkob898Lq0b3DPQ+7A7GYZc/GCt57LS2kSRuLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F2snrFClXrxEYMywJIQ4YJxrvd/RLdw+MmG5M5Iz+1M=;
 b=dWDzMj51xzOFGW2w1h6im1R0KgdSTAL7vlMqDhXz6TcN+AWR8O3hou86K1H2oEUbD1vO81C7rKhdATxcHQYJ3xzUGnni4c/lhePNSUbSrqLR9gtXAlbWdiqDV2JrmCoN88J+qYqR2+v1FHAqsyv9RTfT48rJJjJvOgADOUn7BRDc0+siqZD6eZ5okkk/jYooKHya26MBGAUq1rOySgel0efAEMMhEIxmxr4ZLUXz15iKH+RT6ZvhVLhF8bDtNx7yBr2YQbyRwmmBYpT7aQHBQjKgdLA3RZBEXJNk8fe7KAixBqqs10Ok+nZ0r5QJFSNuvd2Ypn7OuY3mkXjSzBLl9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F2snrFClXrxEYMywJIQ4YJxrvd/RLdw+MmG5M5Iz+1M=;
 b=nzPcB5dlTwdKXkxkJXoJIstsJuWkexZOGksvEaXojiU5l2C/wzwD+MqDgYtxWVM3NKsIIpz2H8ZOH5BveJuv/H479UPs8yjJ+i/SMuGikGD21Gbl1tk30Imp/f9JYKOtVP3DO0pA8I7AeyoE8znfLGah7b2DVjyGn7S3wyiNFzvPQUgN0vwbLhRlrIZau+KxT/jG6qyk/IZ/xXLQJA0IGqN8Cu8vzWFhI21CbKdxgtKIVBOi3Ilaf9TPy+ccd70waGUjWLESfQsevwiwGtJ/b5DLLpDhvdOhlNhw3M5Hra2HEvGB/2hl/GNRuQHs7jNeiaY2hJfTY5qZkRVFb3s1yA==
Received: from DM6PR07CA0082.namprd07.prod.outlook.com (2603:10b6:5:337::15)
 by SA1PR12MB7271.namprd12.prod.outlook.com (2603:10b6:806:2b8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 13:50:30 +0000
Received: from DS1PEPF0000E639.namprd02.prod.outlook.com
 (2603:10b6:5:337:cafe::86) by DM6PR07CA0082.outlook.office365.com
 (2603:10b6:5:337::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 13:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E639.mail.protection.outlook.com (10.167.17.71) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Tue, 21 Mar 2023 13:50:30 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 06:50:20 -0700
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 06:50:19 -0700
Received: from c-237-173-140-141.mtl.labs.mlnx (10.127.8.12) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.5 via
 Frontend Transport; Tue, 21 Mar 2023 06:50:15 -0700
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <linux-kernel@vger.kernel.org>
CC:     Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next 1/1] netfilter: ctnetlink: Support offloaded conntrack entry deletion
Date:   Tue, 21 Mar 2023 15:50:04 +0200
Message-ID: <1679406604-133128-1-git-send-email-paulb@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E639:EE_|SA1PR12MB7271:EE_
X-MS-Office365-Filtering-Correlation-Id: 6d33b647-e18e-4246-c037-08db2a133c0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2zUNAqkhFiEIWxtRZYcT3RZTa+2DnxSMWoZuvORQbFqxNLp5IQJi4J0n0kteFQ0kwdBe1pknBtzDI46TtWKgtj89LTZdlAMoNbmmXVAkUMpYXkmWl2bPtBSPfpdJw1ObGIw9FGTPBqAu3CXDzL7MxyFgQarVlCUKMGkwrwokrXL2Kvu7Y98n3orFIxaCtZo/N/aVnROW3uRMkjYQ7lcXEngiyYqfV/hI10R1w6ZkjM6UcS2Iq9DaT1Drms4GmM1QsXLz5T/cjnWwHI7UkLVsidaDmpdClw2/O+v2bytMIZz3Hwuznkok5LXqwvIeoYZjLiSZCaBwiaDODgwBh173f+Q688n/Zxv2zJmMqLDFjQwPApVrTnXghLcWkhg9YvuqpJ0kQFXYfoXolm4ysC+ycvIXfN+OqZjNNand6oAFxwM0FB5G9xzAIF4C5cGOiV8cspUz1KQdz6FW4sJhLlY3g3Qslp9BD30ssg4ERLb2TwQ+WX11vwMuxFdDs05zokyc5rE9+1xMQk8y3PkJ4Tj1kkwahIz8YkBraQVYAN6ub6SrbbyaDEb7CO43Y56M+Y+8MzTiX0cJJEYHX2KSTl0IqAzZuvDthknPRph4gVaoAIkirx4tPHvxKIOG+fPRCmMhNXX3GPJ+FWTGtfudPkcewwnE43bgk2K30cEK95b+UMbs/pysNXHbRLZcX1QIN0y9ckCaajVBYi5/3jMSazto4oSh4bgzowUkGD/EOtR0K1VoIkzizjWF/KmX/YhyxKUhaE5EtJzIfdCHDpF3D1q6Pg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199018)(40470700004)(36840700001)(46966006)(86362001)(82310400005)(40460700003)(36756003)(40480700001)(70206006)(83380400001)(316002)(4326008)(478600001)(70586007)(8676002)(186003)(54906003)(26005)(336012)(110136005)(2616005)(107886003)(6666004)(426003)(47076005)(921005)(356005)(8936002)(5660300002)(7416002)(36860700001)(41300700001)(2906002)(82740400003)(7636003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 13:50:30.1864
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d33b647-e18e-4246-c037-08db2a133c0c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E639.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7271
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, offloaded conntrack entries (flows) can only be deleted
after they are removed from offload, which is either by timeout,
tcp state change or tc ct rule deletion. This can cause issues for
users wishing to manually delete or flush existing entries.

Support deletion of offloaded conntrack entries.

Example usage:
 # Delete all offloaded (and non offloaded) conntrack entries
 # whose source address is 1.2.3.4
 $ conntrack -D -s 1.2.3.4
 # Delete all entries
 $ conntrack -F

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 net/netfilter/nf_conntrack_netlink.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bfc3aaa2c872..fbc47e4b7bc3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1554,9 +1554,6 @@ static const struct nla_policy ct_nla_policy[CTA_MAX+1] = {
 
 static int ctnetlink_flush_iterate(struct nf_conn *ct, void *data)
 {
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status))
-		return 0;
-
 	return ctnetlink_filter_match(ct, data);
 }
 
@@ -1626,11 +1623,6 @@ static int ctnetlink_del_conntrack(struct sk_buff *skb,
 
 	ct = nf_ct_tuplehash_to_ctrack(h);
 
-	if (test_bit(IPS_OFFLOAD_BIT, &ct->status)) {
-		nf_ct_put(ct);
-		return -EBUSY;
-	}
-
 	if (cda[CTA_ID]) {
 		__be32 id = nla_get_be32(cda[CTA_ID]);
 
-- 
2.26.3

