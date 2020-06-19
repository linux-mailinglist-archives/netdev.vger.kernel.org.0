Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47B2A2000CC
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbgFSDdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:33:31 -0400
Received: from mail-eopbgr80088.outbound.protection.outlook.com ([40.107.8.88]:57212
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730905AbgFSDd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 23:33:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ShaHU0Tlvv8WeF2+lDG+u03rm8/wHf5eWpOHowTvy7FcpUhg/E/kD+XOMki7qiQjfAovjbhcXkk6RfBU6ABUAqJlYMo+/M5bva+Mu78ckUJtoskvVQih810DlHJhtKtiGmB0Hkx1yM64w5XiDgfoK6mdxpoF9xkZSNyBnhwTLOwItRLMobe4Gg3UX7WUmlUphFpDMC1Rvz2JBzWn2+wF4UYN6DSqSR1dUc4tRC5d0TvTD6OaKSVxjKyVsNChRZHiqN/cZ8GgYE22Kop95oLRaPdipT7NKNSv6Do8WrS8x0dB73OUJMclGeGx9RQajgJJ+4V/AwBZpeGlX+ZxNCeTrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHLQPzTyD+cZmKyLaZ5Avr/jBiOkowffvIoqlR02Kt8=;
 b=EJO4QZEAAnRzW1ZCuvsm1AVkj4mpEWfB0FFAewuZrhGoULgtq32ObZiFXjRefSPfxMOCmlaRc0om0Ggf3HsF9cAJ5RMc9hGPzuQQVZj8XjY4wuW48EzXnJU+VG7bvO3wcI6aYgIJxBjvKN/vN3C948EFU3Dag1NWNMvI7uEDVkignuYWuhySWKZrqG5C4eh7nQWVCFKwfAot3sDACdb/oJg+xTKgPwYDuNRhMIuQ7pVEs0tyB3t0xWQECt1BrIFuByN/p2VfVmfHjcrj8u1CZE/3TVFoSzJ6jDCI5TIqapVXEP5s00XO6XbRV9lpERR/UmK1PPukXEGgZX2CtIDuhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QHLQPzTyD+cZmKyLaZ5Avr/jBiOkowffvIoqlR02Kt8=;
 b=IFL3LpotsMV7y4QVg8uD8liCPYDf0GW2Sz3HrTpc7zmMYfHCsIugH9SV/4NSL8UsoVFdLtP0g24agc49hrMWUlV1923GL8Y87t427cMBVDMkANQnc1mIYMLyxDViVmQes8MA8GqL7MnMBktdDpXzxM9GUWE7jZ/f8WGfdde9/YY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB6804.eurprd05.prod.outlook.com (2603:10a6:20b:146::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Fri, 19 Jun
 2020 03:33:21 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::d44d:a804:c730:d2b7%2]) with mapi id 15.20.3109.021; Fri, 19 Jun 2020
 03:33:21 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     saeedm@mellanox.com, davem@davemloft.net, kuba@kernel.org,
        jiri@mellanox.com, Parav Pandit <parav@mellanox.com>
Subject: [PATCH net-next 1/9] net/devlink: Prepare devlink port functions to fill extack
Date:   Fri, 19 Jun 2020 03:32:47 +0000
Message-Id: <20200619033255.163-2-parav@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200619033255.163-1-parav@mellanox.com>
References: <20200619033255.163-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0019.namprd04.prod.outlook.com
 (2603:10b6:803:21::29) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN4PR0401CA0019.namprd04.prod.outlook.com (2603:10b6:803:21::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Fri, 19 Jun 2020 03:33:20 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 101a585d-5559-4863-4935-08d81401840a
X-MS-TrafficTypeDiagnostic: AM0PR05MB6804:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB6804A2F65722333BAAD6888ED1980@AM0PR05MB6804.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0439571D1D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f+j0W2T6ERI9PKOT9uqnfuGE2njDPRncWavoPXEF8cji67JaEBz/IygwrxL71ZU8Fgw5DldNSyIYsuZNF0zLWbkEDw0C5Bdo2tBYaPjA5GRGxuFa3FFLz0Pe6sUUVDngLvxCYq7v3YUg72Zn+QBQdOnlhciTjXvb+vqho8hec2do0SBSBeF0EHUPh95fuD9hZmfCylTZlkYxU1UC5W6h9BGuiY13mXIYnjutLVznvTRTe+QLjEymzRtHCbrP7KFGGl2pMLHwrPtipYOk8zV9580+FC/t3B8r2WGE/ba6ro0m4bHAdVgVEPjZVNx/L9sbTuKw3DHCT+MP542Pd34bcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(8676002)(2616005)(2906002)(4326008)(107886003)(6486002)(478600001)(8936002)(6512007)(5660300002)(6916009)(956004)(6666004)(26005)(66476007)(16526019)(186003)(66556008)(66946007)(83380400001)(316002)(6506007)(86362001)(52116002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: jOR3zmZxctRvBfSTcKPuk7llCqPauMW5ydeiCQ9ZxGwL+8r/avDHovzhlfW+DWYc3LYy26YiXBwIzVCn9AjvdZjfK9302dld9M2VhmrsHYXkj5pbPErtxSUj4fSsvY6u5o6vDRlwmCgTYC/MZ3cJSiXz9S3B0X2eFhUu9ZTctds1ZJB8cscN4FXcw/edWy6KcnG6tUASPfAruvM1zEl4Frq3hgIh4ylBn1AkudeRHJi2X/Ilms0QdWtoyH9xttQa7tk34KYy3uh43mqCRTSNWmdbK3w53qE+nKhiyCfBm8pWFXDAbO4wO9RjtlPp6BHAf65BszTKM7RhWycVha2RYedV5CEfgQJIED6Ob+wPonuW8xPmIkt67r+SxHdCIeKFrJMlQokHdpHiUYCOwPemaS+pYT/BYmjmR6CrlTzSEApziKAEl9QO6g4TZqYbsJlIeIDHCjvp+UhTuZwkZ9fHUR1cw7oqxLqrrYMp5gDTokhVZu+Cw7+93M0KlL509j2N
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 101a585d-5559-4863-4935-08d81401840a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2020 03:33:21.7353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l4HpgLt8Th9MaNsmUyRqWiPHnQgyp2Q68z7bHPtXz3X1tiFhVFC9AcaZ0n7GV60x6c8fH+GcdPRjb2SYk9AEnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6804
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare devlink port related functions to optionally fill up
the extack information which will be used in subsequent patch by port
function attribute(s).

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 net/core/devlink.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2cafbc808b09..05197631d52a 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -566,7 +566,8 @@ static int devlink_nl_port_attrs_put(struct sk_buff *msg,
 static int devlink_nl_port_fill(struct sk_buff *msg, struct devlink *devlink,
 				struct devlink_port *devlink_port,
 				enum devlink_command cmd, u32 portid,
-				u32 seq, int flags)
+				u32 seq, int flags,
+				struct netlink_ext_ack *extack)
 {
 	void *hdr;
 
@@ -634,7 +635,8 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 	if (!msg)
 		return;
 
-	err = devlink_nl_port_fill(msg, devlink, devlink_port, cmd, 0, 0, 0);
+	err = devlink_nl_port_fill(msg, devlink, devlink_port, cmd, 0, 0, 0,
+				   NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -708,7 +710,8 @@ static int devlink_nl_cmd_port_get_doit(struct sk_buff *skb,
 
 	err = devlink_nl_port_fill(msg, devlink, devlink_port,
 				   DEVLINK_CMD_PORT_NEW,
-				   info->snd_portid, info->snd_seq, 0);
+				   info->snd_portid, info->snd_seq, 0,
+				   info->extack);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -740,7 +743,8 @@ static int devlink_nl_cmd_port_get_dumpit(struct sk_buff *msg,
 						   DEVLINK_CMD_NEW,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI);
+						   NLM_F_MULTI,
+						   cb->extack);
 			if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
-- 
2.19.2

