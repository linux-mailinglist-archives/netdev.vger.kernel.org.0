Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B28F61F8762
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgFNHLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:11:36 -0400
Received: from mail-eopbgr60129.outbound.protection.outlook.com ([40.107.6.129]:58414
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725265AbgFNHLg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:11:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxuDyei6JS1eej1qSQleG4lgrxCOfX3v68g4qYU3u0LNRivmLqD7aJhryNnlI9W42A0DIxfgen9wT3rf49VBjwZANMJYCTyAtuj89imX1qR39Gfcsc6gRLYxb0hTx52BBOxpxoiJseCIqV8d6VuvqJgBQ5Y7iNrq3x0tcKyCVNGQSQ6bBAlH9gVbh2Wz5dxGdah/3JGSVjCisiXtVlRG4cM7ftAHBdFDH4md7X11GNNzetsvrqmThRjw1BF0r7MbI4Q6ik/N+1kqn+xK37fazFlenqZRZfjVSlpaIIFOJ5IwPXaFyOkXyDqIg4r80408lf4IELsl0qE9M705kfvQgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEoXbJ+jrueIoJVZxQ2Kb/wtL0P84dtVDbslLIaP9iM=;
 b=BglwqrWlxQLtAiWnWb4dhyZBrLxo9VMA1iuy7fSD+4itiAb39WnX+09H5jYunSefwPXWQ3qOJbeuhADR/CQ0gxeJBSlUAK6zBEkcUyI2N7j+rQIEVXqO8FkHyEeipPv56n8hQ1U4OJ2nnEqfg6qKckYjh2ObdnaldHFO96xZcw3SRujDt6tKqsBC2GdmVVUYPJEgf9RYD0pE6hExwOkYzlmluvVcBUCnUNn/ITejNj8OBjQ3tFT8wnSR54+RoxO4b9d4XjKjkXXayFoTr9wwimAGHQHrwv+EKpAJHMCXibrN+sLSo1ONyFewmGwN1kQlbOvms10E7oP10GvRWypROQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cEoXbJ+jrueIoJVZxQ2Kb/wtL0P84dtVDbslLIaP9iM=;
 b=El2f5uf0EMOdCH5WoBbH8qRdVLqvfo0ueyWV/nZe4fcrMcX0ziSm3zgy4dBosuL71odeXMK7/Z3rE5bs/1l5lw7Hn0pMrcoGe5MLSEV9ISGXelt0OdsE9U295YY8R0ocd3IuEUI03wYzTj1bU9apSWbyqe40bqXMcPzki6I8wos=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13) by VI1PR0501MB2303.eurprd05.prod.outlook.com
 (2603:10a6:800:2d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18; Sun, 14 Jun
 2020 07:11:30 +0000
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5]) by VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5%6]) with mapi id 15.20.3088.025; Sun, 14 Jun 2020
 07:11:30 +0000
Date:   Sun, 14 Jun 2020 09:11:28 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     thomas.petazzoni@bootlin.com, brouer@redhat.com, lorenzo@kernel.org
Subject: [PATCH 1/1] mvneta: fix prefetch location
Message-ID: <20200614071128.4ezfcyhjesot4vvr@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM4P190CA0024.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::34) To VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (149.172.153.214) by AM4P190CA0024.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Sun, 14 Jun 2020 07:11:30 +0000
X-Originating-IP: [149.172.153.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f2dfd3a-7cee-4196-e0d1-08d81032299d
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2303:
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2303230A9E74EE6DABE46E67EF9F0@VI1PR0501MB2303.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-Forefront-PRVS: 04347F8039
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gkp0KeqBHo8xQlmXSmjBwzVRO3Z8I4TYVoZg/7UnlrR4KeZlGp93UamL+XWKuel3/JW4SAiszpzucRDKCmlwiSnEPLT0CvrANSEKi5juW0w5YL5H63UQqNK4SJ66UkDzHNcqrbi2dKDvocsmZNKLzl40bbIUmNLwDipKM9qurM6FzO4yU3ObU5ZqLd5zx2zbzl5KfsI9CM+2dv2WhRqiLqDyVxlv6rZWLwXWzYe/PKOrzVhSKgP/aSafsMjwmwZ8S6qkU5Akv6vad2bzZnQXJLsqRjQHsKJVunK0AeKJFbhPCc/+MmUq6+z1TplKpsR7EZP5H6cJ5gm4x8QZYAspmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2800.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(39830400003)(376002)(346002)(136003)(5660300002)(8676002)(186003)(508600001)(16526019)(26005)(956004)(83380400001)(2906002)(8936002)(4326008)(55016002)(1076003)(9686003)(44832011)(6506007)(66946007)(6916009)(66476007)(66556008)(4744005)(86362001)(316002)(7696005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: iOOrkYVsCYKOR5BlUZgN7jq0E7E+NiQSYkTTN2vMf9weNTC+HIS/TKcTi3XRDTrlW0FWvQGTgzGZ9VxjCeKJPM6WuIG0ivaRa/tNbCqBDWBIH37zPtY24CLfiyi1m4FdgWm70rS30rnLEmcfa99CX3fm8W4LM+LKwv4VdoVZ6VNR4WEybhw+8gzkGaV++eJaOSMl7mX6T3CiN3JaX6ZyR4z1R3zcr8aI0trIf6FRwiKUkHst0URhwOd1Cf0Q6CEPTQZwYEGPTzAf0HlRQOO8FqSPgITi3ZMWgRbSgSqZvWndEH6K5WRcFAx0EvJdfzTFpGIPVtMHyaug/k9xgDeKnf0nlL0AR9YmmRyEE88DOh1a3r9BYHPDQcDdmeRxpZD3ostPDFZOw5cgR5JlnPDbIyf12UxuqWwWZCgKbf6nvux5LXYE7J5QQiZ1X0Wu+W+adSRd+yTzg9vuWyo6DCe5QVQYrHdEysglV0ifzgAi4s8ux8sA56ES/BNXC8IJv/z4
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f2dfd3a-7cee-4196-e0d1-08d81032299d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2020 07:11:30.6726
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CWX5w3CaWUueGryr1lZ1YZyLYi+Ap194ozU+1YmKli9sjaf3ZUydwY4eJslmKn1SlQzIz4d/RKODw5B2CPLhiOd+6aaLu+kGEfzja5rHMYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2303
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet header prefetch is at an offset
now. Correct the prefetch address.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 51889770958d..344fc5f649b4 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -2229,7 +2229,7 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
 				len, dma_dir);
 
 	/* Prefetch header */
-	prefetch(data);
+	prefetch(data + pp->rx_offset_correction + MVNETA_MH_SIZE);
 
 	xdp->data_hard_start = data;
 	xdp->data = data + pp->rx_offset_correction + MVNETA_MH_SIZE;
-- 
2.20.1

