Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7733A6C30E8
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 12:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbjCULxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 07:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjCULxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 07:53:13 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2046.outbound.protection.outlook.com [40.107.243.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1812D59
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 04:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZmCHwUZHNrxqf+v5mYG+8KNEyfsVnOSrfk7eGsgRT7AD4hKAxHP7SLMyHzi1zGaa0OjMqB2CIe7O8IwA6tBBNWLh/CpdR+gYoOUaQLKJn9KS9nHkYKYxrVdpbSh++wd19BLbNAiGW+jAsif5ceB0jJ5w8MUOprgPbSFHN0MTb9ZOhjNTS/KI4L2qC0vK26FFisGzKb269KOQSFti7EfDNWKGPPYuNltOWlcSu1gech5I7yFF5DSwJvBX43F3h/6EgcGVGancKBiv+7rA0rt7XDBDjErr47yz8mX9wpdicqdzHf4YRC9NhKAQiO3srqWc+fd+lpjgEjc1zkJiYjNUfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pf8MmxHcMECnOxWRPIIkJf0R7GBx26Ac5A3cb3RYuLo=;
 b=BYABVBIedNoNagIfeG1Wq4XhIbVbWloZ0uIOVjDMCKRM3qwuMaz6MIKszoHYYiUt+0Tk9sGrN3LCtt5VgOWzpYhHr6q+B0kn+p0Zen+4TljJwkNhyO5qj6NQFNuTcK9dEyIrYWOhEzIGcni2rvkgqe8wOKq+gzaTequbCJ2V3s9xtk07vGNqcJ6y6sUxXdINM28b2dgv14PDpTOlUIRtNkIyLCJUWZq2BPGGI7aXV1fXylXzP8G/SbrLkdNxRkmHP4hmwBWqCX7Ey956zUlDx7hV5vATpTMKcIPkI21NNH327ONK4AQhZNTknKsOwEOXnIMGw1yJUV3xp4XmBweAYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pf8MmxHcMECnOxWRPIIkJf0R7GBx26Ac5A3cb3RYuLo=;
 b=HD9YhUCZlYD7aa6NfB+h92S1d151UkUAtyLPv8eMm2GUH5s0WDB83gJ+sP5noz5mWKnAvoDDQ3gyhSkn+GTZUHo5apMb+dN75FhSw80NIdXvPLlcC0AU6E0l18FSWKCxCbSXcoOzY9rmH3e4fUF+SYmFS1sCI/qA7EFwa60VwzLnnZWIxbwkm6u1/Yo6qayJhvwqsMa54ipkU//cluaIIy/H1ULRX+EoIAVqzME4i8XyjCzReTvR7AHClAIcUMvSy/0wBoJBw5G+fZwsrWF57lM1psluQypJ3VxgBcq6Nc6I8qgfjguCtZDnlMwD8bJNW+bjgyyUIZbm4mh6/7qh+g==
Received: from MW4P221CA0011.NAMP221.PROD.OUTLOOK.COM (2603:10b6:303:8b::16)
 by CH2PR12MB4151.namprd12.prod.outlook.com (2603:10b6:610:78::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Tue, 21 Mar
 2023 11:53:09 +0000
Received: from CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8b:cafe::c) by MW4P221CA0011.outlook.office365.com
 (2603:10b6:303:8b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Tue, 21 Mar 2023 11:53:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT022.mail.protection.outlook.com (10.13.175.199) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6222.16 via Frontend Transport; Tue, 21 Mar 2023 11:53:09 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Tue, 21 Mar 2023
 04:52:56 -0700
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Tue, 21 Mar
 2023 04:52:53 -0700
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@kernel.org>, Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>,
        Jacques de Laval <Jacques.De.Laval@westermo.com>,
        Petr Machata <petrm@nvidia.com>
Subject: [PATCH net-next 1/3] net: ipv4: Allow changing IPv4 address protocol
Date:   Tue, 21 Mar 2023 12:51:59 +0100
Message-ID: <6ffecb0f77dc6e444e3a130a09b4fd5d717e6504.1679399108.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1679399108.git.petrm@nvidia.com>
References: <cover.1679399108.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT022:EE_|CH2PR12MB4151:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a978eff-0771-4ab5-f6dd-08db2a02d76e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ifn+Wt9M2L1Rc+QovPKYHNfKn/HfT1rdOsI+ZogVdSUDZphswwyxkSFOeV0/KtWxdYZ/2cu07nMi60uZo2K6Gwc57TvNv9fYEWI/y+XrfpQyLACiu1a6f83fz6DIknqOfbjccFhAQnkCYQcdPVZ5e0auk2y9NqlEO3Z5RqFgXedGu+h+NgGr/qXFkfUpjUausKmQw/u04eY1PY1Fpsm+NwG9K/YZeNKUcpwySbE2MoNdOzetuqSFd2RDBEvUP+PZu5r/AMhblpBni8V/fdSWsLdagBe///SiJBbkqNpuTdoygTO0CIMRPbiJdBmVeFhtv4xleJupHOI7vRuqXqKnS+NNWUJ02RBsCM4PmJMJjQUDvQqFvy179cjK+a0TBGcmEXIgYOpwkLht8V0GLbCaLVjgMsMGWHRUZ1RMQoKhlI9nQqn0LehhT0M2K1/UNetxUF3P3eAEqRiv/QAwlGKOSnp7AQsz0OfmIK6iF9aQGZq5IsAiNTQGwsryu0XoIcahWW+gb6wU30OnA0TOn30zfC0ZRJCYRZXyDS0CBQf2gHkvVTpouXM3R6xCmy/ciimTZk34PN5B/QTiWkgT+LTBrTE7eUuh/JiW59WvcLiTHsgtYRiMGBKZPlB8m2PPikIhslp+fbPuDlslyJpY3BqqZpnWdgsGaklVDHnGa+nBOy6dkY8Q1mz1+N/z7b/7Q3iSOZRxDeIclWMGoqW0epy0bD/WxskYPYGH+JYBkFJif8a5AqlbfV0VeqUA6QYd+4LA
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199018)(46966006)(36840700001)(40470700004)(86362001)(82310400005)(40460700003)(36756003)(40480700001)(83380400001)(8676002)(4326008)(316002)(70586007)(70206006)(478600001)(54906003)(186003)(16526019)(26005)(2616005)(336012)(110136005)(107886003)(426003)(47076005)(356005)(5660300002)(8936002)(41300700001)(82740400003)(7636003)(2906002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:53:09.4169
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a978eff-0771-4ab5-f6dd-08db2a02d76e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When IP address protocol field was added in commit 47f0bd503210 ("net: Add
new protocol attribute to IP addresses"), the semantics included the
ability to change the protocol for IPv6 addresses, but not for IPv4
addresses. It seems this was not deliberate, but rather by accident.

A userspace that wants to change the protocol of an address might drop and
recreate the address, but that disrupts routing and is just impractical.

So in this patch, when an IPv4 address is replaced (through RTM_NEWADDR
request with NLM_F_REPLACE flag), update the proto at the address to the
one given in the request, or zero if none is given. This matches the
behavior of IPv6. Previously, any new value given was simply ignored.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/devinet.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index b0acf6e19aed..5deac0517ef7 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -962,6 +962,7 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 					 extack);
 	} else {
 		u32 new_metric = ifa->ifa_rt_priority;
+		u8 new_proto = ifa->ifa_proto;
 
 		inet_free_ifa(ifa);
 
@@ -975,6 +976,8 @@ static int inet_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 			ifa->ifa_rt_priority = new_metric;
 		}
 
+		ifa->ifa_proto = new_proto;
+
 		set_ifa_lifetime(ifa, valid_lft, prefered_lft);
 		cancel_delayed_work(&check_lifetime_work);
 		queue_delayed_work(system_power_efficient_wq,
-- 
2.39.0

