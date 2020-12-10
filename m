Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2412D58EC
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387507AbgLJLHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:07:55 -0500
Received: from mail-vi1eur05on2138.outbound.protection.outlook.com ([40.107.21.138]:54688
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1733284AbgLJLHv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Dec 2020 06:07:51 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tqib0yKudbKH9vZa8TsXgfDMPqbUURqF2688PEp86TZBTfqtzW5tgNVa/8N/ZUBk3vIZQcjGciq7V4ylIiNDmfaF8vj+ftWy5VUMinwAdEi7QvGRjZ93vor6wbWVP4lg42GUpHBhRJbyW8ADh5ND03ZfZuO9oSaTdXShuVm2wQb8zR4L+axSq97TRrs+Tn9Hw8QangVrsdEMZTbtOJmXrIcpfOQN7tLiGqWLwIV/o7ESAFv4KLxUp7EJArTi/DWytm2qtzTRFLa0kyaZrNPBwuuJlUWh52k69SP02dMDSUJJxqYxt/uRXm/pJ9x1r+CM9/TwOfRBytvxZZaaZidDkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/wGg4bjatUjl5oS9hmq7WKiFMxgcquPR+LxO05BkE4=;
 b=l/z4wf5YMclY3d1RbRQ14TPPBlR8we2UcnvyGUy2Vd8pP0RdtmX3Vi3Pp86NhKi8vxVkLK1lOSSEKsWyJ+iXGhVyFEpxxircqxXdQQYL+ji011LrQyCaG4wn0CnIqYtHE9mMV4uMiGDD6RRTUHOxiyAb/2xVn+t6WzOamUbb8nrk/e5TiRBzGsgpSzLbZXP4IZDIUbArBg0TMlE77poyQSmwxWNzMmTfEVjeD4BiAiPwLbI91UI5HlTuZJtK0XEhBrWt0jPzT/IGYIXJIpvXAyvhE0mwpDBlc1TuAAqC6FIOTBsrlx3SqdYkV9EEUQFz2Fu0TKcpXEZRCaBLo+lbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/wGg4bjatUjl5oS9hmq7WKiFMxgcquPR+LxO05BkE4=;
 b=BPqECKVwe2hFc5vDyqXGSCTBFKqHWfRvgEy9RwXLPpLZuiIJ6WE1YqytAnSJ7iwKSYLgGtLzZ1sTedxkeAN3vRWfCuCpOEOtVYMZiCRoaj7Ov4eVMtBffH+OQVRBWsVpkPPRh7R5VZvOoJ/fJvA5WavtAbAwZCqSJ5Vmh5R6NrE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2964.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.20; Thu, 10 Dec
 2020 11:07:00 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3632.026; Thu, 10 Dec 2020
 11:07:00 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: dsa: mv88e6xxx: don't set non-existing learn2all bit for 6220/6250
Date:   Thu, 10 Dec 2020 12:06:44 +0100
Message-Id: <20201210110645.27765-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
References: <20201208090109.363-1-rasmus.villemoes@prevas.dk>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: HE1PR0402CA0034.eurprd04.prod.outlook.com
 (2603:10a6:7:7c::23) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by HE1PR0402CA0034.eurprd04.prod.outlook.com (2603:10a6:7:7c::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 11:06:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30c99aab-f7a8-4038-d6c3-08d89cfbb7d9
X-MS-TrafficTypeDiagnostic: AM0PR10MB2964:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB29646245A649C985B383739D93CB0@AM0PR10MB2964.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cYGOyNzUpm2KHmGVFkFADOIu0x4idSkWN9JcQzyIsehBGn0uIgDl69uX26vtOWinhoQP8uTNshWtl8ai2PfyzCY3bJCFBRhqM1ngcD43BEymBQlIFRHv+r35SD+R96h93n6QXydyvGKqoem1AwRws/drGTDdtpIgxQfVYQB6zAOvbaSopTuHq11eEezZulmpC3VRctKr/5LyqRE39l3DnV9BV7KgMlj1lnxPe6in/NFSacDN9mH8ZLeUg0H0cCaSr4tb6Ob8kFQUP0v9yW+eAM+cwABAjqp29NkJkfn5/tls6myH7HhkG/xkL+QU2b5uUUtS6VmhuI+B33REIUQekQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(136003)(366004)(396003)(346002)(39840400004)(376002)(44832011)(4326008)(110136005)(2906002)(8976002)(186003)(478600001)(316002)(36756003)(16526019)(26005)(6512007)(1076003)(8676002)(2616005)(956004)(83380400001)(6666004)(66476007)(5660300002)(6506007)(86362001)(52116002)(6486002)(8936002)(66556008)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qedOgQQrnUg3O69VkWEcrEf9dyREVUn9Ad3SQD6Tk3wWeb+uUTy+lYofjuvt?=
 =?us-ascii?Q?/lpvhqLEIq34/fdwB/ydJM7ju5uN86otgV1/9SgIJiNtD9Wiz6SD1HUt+Rir?=
 =?us-ascii?Q?QKkzaZH6wtdOVMqBa42je8SS0RQ54iCdFQvamKdUY9ApAZ9JoFd0iYz8zrso?=
 =?us-ascii?Q?HHr7sVzMaGFlPiCcT+1Pnf4T2B1rlmQzhexlJod81IDk/fsaSozzZo1GSyDA?=
 =?us-ascii?Q?eKkwvorVTHA+7/QdjWyalUTvjRgXPnnWFOlgwCF+O1e6IYY6NmpnW8tTnDoA?=
 =?us-ascii?Q?zH8OiVltrgsnfjeuLO/yGCUl7D0jfpZ98fEvTBQMPwu01LPEzDN+qoJ4qLri?=
 =?us-ascii?Q?lLJdsx1p/QrRz/LH2hFyM0x9e2bVzLK6vtROqJi5B3LlaSpjVUPKYeNLVY9r?=
 =?us-ascii?Q?mfzAw0JZaWlc0S15MW0gu9WOa8MyhdjW3a5I7122pjyAGZKv9S142g4CdxuE?=
 =?us-ascii?Q?dt8LZ6iMITdhNBg+ixbKxpMRk+pDLVOA5cUZn+LipqkybqYUQLOmAXfPtc3R?=
 =?us-ascii?Q?uCfQ+wVJ+IoEOIEDn9vaAVdQSL0KDkefhcVKy7dElagT8mXtGgyphy5pFWT0?=
 =?us-ascii?Q?cLpKlB37pJFqp/MhZtp/VgFzumQUloICdf0st7aNmVKfuf5b/MnnenNQZ64n?=
 =?us-ascii?Q?DjjvmQAeCSTTMH4CwFV4uCn+WpdLMXNGfGIbMtIIdNOpjjp8FGUbVEkiH9ro?=
 =?us-ascii?Q?LQZRz1BMwJttE/IFO/GQ35NncYtpCWFDMn2/HPB2mox/JRBE2W/b5b2rADRn?=
 =?us-ascii?Q?jnVV3D318mDMZhRPqVgEN8hyB1hJ6go9OD7TjsuXiN77wqvV7vFP1CMC5oTy?=
 =?us-ascii?Q?d/lKKtNeDIhjP4I3t7z/SkTmoIGEWyXyKVM4DcFshG6B19AfI0GS+SKqUJxg?=
 =?us-ascii?Q?9Sy18UyIomk9f2uWXtxwOhALJC9XY5jzwG+xvriIMMRDkaRpoIbDiJDyl2A8?=
 =?us-ascii?Q?XGWYTAIMD27zi4f+WPQxQyB+QRZqiS2n8eZLsfxP5y0j+WpivCNFjlNkJDKo?=
 =?us-ascii?Q?5eP+?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 11:07:00.7786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c99aab-f7a8-4038-d6c3-08d89cfbb7d9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ge1H458oUAYQisWyPPPQgsyDoz9QaczTeQmiPzNOTuxB7iid3AZ3NtY5Ll/Kd9/LTn2G0ZhuwZ35+YIzdxC1Z77AZ5dAXOSy9mgOxIaExls=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2964
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 6220 and 6250 switches do not have a learn2all bit in global1, ATU
control register; bit 3 is reserverd.

On the switches that do have that bit, it is used to control whether
learning frames are sent out the ports that have the message_port bit
set. So rather than adding yet another chip method, use the existence
of the ->port_setup_message_port method as a proxy for determining
whether the learn2all bit exists (and should be set).

Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
---
v2: add comment explaining why ->port_setup_message_port is being used.

This doesn't fix anything from what I can tell, in particular not the
VLAN problems I'm having, so just tagging for net-next. But I do think
it's worth it on the general principle of not poking around in
undocumented/reserved bits.


 drivers/net/dsa/mv88e6xxx/chip.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d68074a2f240..2068f2759fc9 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -1346,9 +1346,16 @@ static int mv88e6xxx_atu_setup(struct mv88e6xxx_chip *chip)
 	if (err)
 		return err;
 
-	err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
-	if (err)
-		return err;
+	/* The chips that have a "learn2all" bit in Global1, ATU
+	 * Control are precisely those whose port registers have a
+	 * Message Port bit in Port Control 1 and hence implement
+	 * ->port_setup_message_port.
+	 */
+	if (chip->info->ops->port_setup_message_port) {
+		err = mv88e6xxx_g1_atu_set_learn2all(chip, true);
+		if (err)
+			return err;
+	}
 
 	return mv88e6xxx_g1_atu_set_age_time(chip, 300000);
 }
-- 
2.23.0

