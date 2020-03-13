Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C245183F84
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 04:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgCMDSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 23:18:41 -0400
Received: from mail-eopbgr140110.outbound.protection.outlook.com ([40.107.14.110]:51014
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726775AbgCMDSk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 23:18:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a8f6WgxYasFZjfppNC+c2oKtEbQDMNkWFrxQCO8VDXP4S1ZVJnCrkSCab1ir1an4QCLF46IdyzBN1m+EzhxrmawlCOy8sfYHrT6sBMOQ9NHH1wkytG4ykVLwKLC3Mn8NByHxQcb6GFZ6syuCS5s3UY8FZqONd5US+twNDwZ5tFiAll5TLT5tKj2ygoYGfWoX/XwNU0FhP96af7MzFClM+wxBLxErLJd+3t/h/K9G/+3n6a++SZaT7NdZtfN2tSn+Ips6mNr8AfXh8kd2BuJJPS8pFA/Sng7hFTXhCLTqFu5vqyErUnFoTykyXF6CDGYKDdh89cy+GuhVfRHm7wfqDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuq0vSfmTy+z5cvzSEvWzqlbxjsvVjF3jovHSiDiUUg=;
 b=E0d1G+u58VG19q1gxxNZtJDVwgTylrBrcQRC21jhzYGPhgcMi8/NfiLf8vNJP6HQ+lcvYTkFKZTbfJrCv5epbD6haskXj8yPgO4H6u1zuqQeNf/KYBOorG7V+r3+kv83xFTP+TupfziJVdZnU1jrQ2fA2qjkVJXAqpewDr2GXeD9jcLBCS97dra8Ns92C9D1yhvD+n2Azm5nFy8WRAOaJ6ssBSFhhN0zcJgXK1dOb80nvg57SVLwm8r+BGPvYvoyQ1j0UwgFGPe39ehcdVRpbgbUMjTPI5792EVJP+v2dj1Z16MXXER1Gy9VtGWPzm2aO1aqwz6zI8VhEHQVB5UQtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuq0vSfmTy+z5cvzSEvWzqlbxjsvVjF3jovHSiDiUUg=;
 b=SoqtM43jE6iCicrLrjdoiSv75dvku8kuynSv/hUdO2nxNuVJ+tBCQ2X7HmsqqhQPe4neQNxjZfYSuKhltINgC4ERkpWGZFFmhYo/LsmpB08KZzFuqXYh3gHoFGybf92o3+QjX3wGJXRRCbX1gNKizCpWWQprT9nhxaJhvjrlo4A=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=hoang.h.le@dektech.com.au; 
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com (20.176.4.149) by
 VI1PR05MB4512.eurprd05.prod.outlook.com (52.133.14.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.20; Fri, 13 Mar 2020 03:18:36 +0000
Received: from VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec]) by VI1PR05MB4605.eurprd05.prod.outlook.com
 ([fe80::31c3:5db4:2b4a:fcec%5]) with mapi id 15.20.2793.018; Fri, 13 Mar 2020
 03:18:36 +0000
From:   hoang.h.le@dektech.com.au
To:     ying.xue@windriver.com, netdev@vger.kernel.org
Cc:     jmaloy@redhat.com, maloy@donjonn.com,
        Hoang Le <hoang.h.le@dektech.com.au>
Subject: [net-next 2/2] tipc: add NULL pointer check to prevent kernel oops
Date:   Fri, 13 Mar 2020 10:18:03 +0700
Message-Id: <20200313031803.9588-2-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
References: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY2PR06CA0023.apcprd06.prod.outlook.com
 (2603:1096:404:42::35) To VI1PR05MB4605.eurprd05.prod.outlook.com
 (2603:10a6:802:61::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dektech.com.au (14.161.14.188) by TY2PR06CA0023.apcprd06.prod.outlook.com (2603:1096:404:42::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Fri, 13 Mar 2020 03:18:34 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [14.161.14.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dfe2b34f-d701-448c-568c-08d7c6fd37ce
X-MS-TrafficTypeDiagnostic: VI1PR05MB4512:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4512E935859B225322D63965F1FA0@VI1PR05MB4512.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:389;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(136003)(366004)(346002)(376002)(396003)(39850400004)(199004)(66476007)(186003)(5660300002)(508600001)(26005)(66946007)(6666004)(36756003)(8936002)(81166006)(8676002)(316002)(81156014)(16526019)(55016002)(4326008)(9686003)(956004)(86362001)(52116002)(66556008)(7696005)(107886003)(2906002)(2616005)(103116003)(1076003);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR05MB4512;H:VI1PR05MB4605.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: dektech.com.au does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2tbB5/7AZbztXSomv7NsWf2nsisVbtrc2jJzBYfrJUOIzxmUnEQ/8nws/C62UK3zLJ38ht3K8xGnACabkRo+bBwg6l7Z+8mToMO3QSyUxCM1f+HPyNVYmVPCnsQEgA3kDmNin7KzbkmK+CWnqQ2ELpdSU18OpsJDIArG/SRiYfSM44FrKoT6B+BvkEKwnngcNu7FT4sc6FFnntX9h61O6+pjhwrqfiaypkOMu7z9WnMoWCaqu0YJjvO+EIPTcgMrdpFQ78LkRJpAcsHLl4zi8PKB9poLZHxBfuFuT78sejvVCvtQOtVDUKVjPCtXSKEqqHYQa0uhbdBD3/oFAw17k9WMZm69vK7rFavck0RSrMlpR7VqV4z9CERtsbvR2f+Jq0/y90p7xowZuJ484Wxu0/CdAPV9ZjiRDsrGiq7yu7leyhgUR6pshx1tuuin2AQc
X-MS-Exchange-AntiSpam-MessageData: 1KjdA8rF+8A7TkOryPvRJujD+pjvqb3CgANgHG5Y0e484/qKbPKM5+IIdx9dcK8oltuA91PrYdw7ajHW8uIeq4/W2+W5VSIiR9l2OYfynKvaQ7+K8urf/tMehjCW0AfHzsg6Q7rhGKi/Wn6fBE4CGg==
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe2b34f-d701-448c-568c-08d7c6fd37ce
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 03:18:36.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9iADQ+YBagnlejVnd2LTnoo02oxCpUTXT0Mrnip6WaRDfQV8pPe5MYDoiNCEd9ksIN1bYvVDG26GQ/ikFRRomSE6YJaBOJMGG/GsvXoDw0c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

Calling:
tipc_node_link_down()->
   - tipc_node_write_unlock()->tipc_mon_peer_down()
   - tipc_mon_peer_down()
  just after disabling bearer could be caused kernel oops.

Fix this by adding a sanity check to make sure valid memory
access.

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/monitor.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 58708b4c7719..6dce2abf436e 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -322,9 +322,13 @@ static void mon_assign_roles(struct tipc_monitor *mon, struct tipc_peer *head)
 void tipc_mon_remove_peer(struct net *net, u32 addr, int bearer_id)
 {
 	struct tipc_monitor *mon = tipc_monitor(net, bearer_id);
-	struct tipc_peer *self = get_self(net, bearer_id);
+	struct tipc_peer *self;
 	struct tipc_peer *peer, *prev, *head;
 
+	if (!mon)
+		return;
+
+	self = get_self(net, bearer_id);
 	write_lock_bh(&mon->lock);
 	peer = get_peer(mon, addr);
 	if (!peer)
@@ -407,11 +411,15 @@ void tipc_mon_peer_up(struct net *net, u32 addr, int bearer_id)
 void tipc_mon_peer_down(struct net *net, u32 addr, int bearer_id)
 {
 	struct tipc_monitor *mon = tipc_monitor(net, bearer_id);
-	struct tipc_peer *self = get_self(net, bearer_id);
+	struct tipc_peer *self;
 	struct tipc_peer *peer, *head;
 	struct tipc_mon_domain *dom;
 	int applied;
 
+	if (!mon)
+		return;
+
+	self = get_self(net, bearer_id);
 	write_lock_bh(&mon->lock);
 	peer = get_peer(mon, addr);
 	if (!peer) {
-- 
2.20.1

