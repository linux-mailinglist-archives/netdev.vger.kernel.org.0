Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDF41E7B7E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 13:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726161AbgE2LR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 07:17:27 -0400
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:13233
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgE2LR0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 07:17:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bUvJxEVgg7BTtwCOVeAqvQvsfF/r5ExeRii4AhvrbbYzzjRJVklXiQsinsASqvjMUx3RG7ORTgy4cKMTRbmcTb571J+4Mz94JlDl8P0HJnho0p4KK0+PIdblnQDxXa43i99MSN6wdGpeOPY5yPVTIv39wB1j3K7J/shICxGYtfrCAOuF5wD0IMTO0iSUgSMeiEJm45o4arArUaQW2PJLlq9JFm+4iCun4AZb0JZhTKcy8STGgKTMgojeoLQODZLTI2tamzRT4wCJzA1lJOjEvZ1UdwiH3rkHB2sw565/2c7IQ8pzVyGx6Ejzia4WfHE2CKKEP/0hF2LBEkOA/F+9Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rekagn4twffY1KBvt24hw2WBqPxsIROokYJCTOGpHD4=;
 b=niW6tkFh/Za8V780ue1tHJS6lUM9ENG1y+b+Fx07jfPF2VcNrGz+5D5yQ9IJXptBeQP/AyLXviKACOwCzyDiydY9qY/2TnftL3iQyMZu8OPqmU2Vjd9Foi9dEMnracj4oLBtk+OxB0yUHGUgY7Gym6n6g9MxyDm/A+w6ONj2kAvN5MJ8EG6DndUKelBas+/UHxuKn6y9DLZFmoIECHYu3bfnErIRV8feyTwokqvjXOCj33nqAARmUmqt0RUVdm9zrkYlzjkOe14nHqIZgk4jlg17rXMldjrsyjH9ttPBrGIjBL/HnLlHprRpveW/LdlR7gVdoIeEAr0FDpgwiUHYgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Rekagn4twffY1KBvt24hw2WBqPxsIROokYJCTOGpHD4=;
 b=lX4LFtInjGponQ4NpoBESqmRrncMd3e7dKUBzHo1iD6nA8FSwsgnoJNmgXozkxlNvIBJ19Ci3tQmXtqN+XsShwdIDQmjLlKYP7rynH0gcuVED3yRh79gRBTIudbrDULHGJof+iNkg1oMrOo8L/7boFVknW0xdKMHGypkV9/89ec=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3468.eurprd05.prod.outlook.com (2603:10a6:7:32::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3021.27; Fri, 29 May 2020 11:17:18 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::9de2:ec4b:e521:eece%5]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 11:17:18 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petr Machata <petrm@mellanox.com>
Subject: [PATCH net-next 2/2] selftests: forwarding: pedit_dsfield: Check counter value
Date:   Fri, 29 May 2020 14:16:54 +0300
Message-Id: <a7054fcbfb8b5a2ca5dc7938d727a71d219867ad.1590749356.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1590749356.git.petrm@mellanox.com>
References: <cover.1590749356.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::12) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0032.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17 via Frontend Transport; Fri, 29 May 2020 11:17:17 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1167e488-714c-48c0-7a88-08d803c1d922
X-MS-TrafficTypeDiagnostic: HE1PR05MB3468:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3468FA1E13B9D7E097CEF6EFDB8F0@HE1PR05MB3468.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04180B6720
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: D7eh5EgGpCEHn6YeLmhujKlvHrp88l/5JQZrYmVl+o52I5ntxXPRK60oAxjjlvZjGIcqHc3jlUnbLgcTd2NzaK0QI+aTf2MVY4Z0nBhpg0JyOFg1J0XMRX4xp4kcyQLOeFnetdCXqFNLhbcvTRHs3yCTqrGjgItW+gpjqI7dsqsDx6MCc2VK5lrzdEryNub9WJ+ZG/SJ+jX9rR4KLO4g4dan2wrpGnzjrl/ZhfqY+d0zWLhS0SIVCZAi5tJkHu3u7ozccjHtFITdEvOKd+ImmEPnSMLkb97v2SfO5OAJ+57ApudqJ7gMdV+4dD8XrnnB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(396003)(136003)(6916009)(8676002)(316002)(83380400001)(86362001)(8936002)(186003)(107886003)(16526019)(54906003)(6512007)(6486002)(478600001)(4326008)(6666004)(6506007)(36756003)(66476007)(66556008)(66946007)(26005)(2906002)(5660300002)(2616005)(956004)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: CgEEpCzag/p/XDd9+sWxim3D2szapKgYLgz5w7XYZ1EXWpFEic2vHBuf2lU55YjuPounOptn76f+hXUxt5KyA6C6z92mUuIXqLCBEySk9V9KzaRHRJg6c7FPgiswDpbYWJp6YctIyOXctXwwmBApR/AZ4pl2LJy76vH28Y4dzGLNNsnLWUhIVdM6DUKpnPcoSXNqtYq1y1ZBce7LEsYrLkggTdhCVJG/R28EGGEMQIjppf46btjvMZdMqYfo9qBREbCvB0ZOiUt+mVOrsjZK7/VQyJ88mAFvQY9M5w0G9acnOzUYaoKSCXQKH3ahJUdWt3+9ue8LwNchMqGJP5/v4jKVxHhknn0Lz6CpTinX0nS9jJHXdxAf+DmIPH2wTFtwIMIV+8nh+WjI/eU28oi3A07iJ6XkPbRoAQzkeHBqw/QhuHprl0TH9VVfuja8v1y5MJM0hVdflCQn7rMOsU0xYKcpF2jJ3Di55t45BkpKQao=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1167e488-714c-48c0-7a88-08d803c1d922
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 May 2020 11:17:18.1860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xebsjnVHGQwx8DJfkb4XBtU5Y+VUZ3efnKYM01Mhpr16pVHMGyclFeHG4EInXJj1RgcuHHpjgF/ibaxXNlIGhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3468
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A missing stats_update callback was recently added to act_pedit. Now that
iproute2 supports JSON dumping for pedit, extend the pedit_dsfield selftest
with a check that would have caught the fact that the callback was missing.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 tools/testing/selftests/net/forwarding/pedit_dsfield.sh | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
index 1181d647f6a7..55eeacf59241 100755
--- a/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
+++ b/tools/testing/selftests/net/forwarding/pedit_dsfield.sh
@@ -132,7 +132,12 @@ do_test_pedit_dsfield_common()
 	local pkts
 	pkts=$(busywait "$TC_HIT_TIMEOUT" until_counter_is ">= 10" \
 			tc_rule_handle_stats_get "dev $h2 ingress" 101)
-	check_err $? "Expected to get 10 packets, but got $pkts."
+	check_err $? "Expected to get 10 packets on test probe, but got $pkts."
+
+	pkts=$(tc_rule_handle_stats_get "$pedit_locus" 101)
+	((pkts >= 10))
+	check_err $? "Expected to get 10 packets on pedit rule, but got $pkts."
+
 	log_test "$pedit_locus pedit $pedit_action"
 }
 
-- 
2.20.1

