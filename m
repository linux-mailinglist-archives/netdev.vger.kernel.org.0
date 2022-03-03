Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2503E4CBF5E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiCCOCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:02:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233891AbiCCOCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:02:37 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80058.outbound.protection.outlook.com [40.107.8.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 516A664BC9
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:01:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuFZZVnOEOqbz8Cm/3ZvSYBw69xYAmBPLwVrRCJpQ7ljqfjNVkQrvK1ejpUFP1kShtPEsy0SJ/W6LAwWKsfL8TyfHjHn+IbSWJ4gcQR5kTuTaCmrnSYgm4XbNHm90VqriZbZEfpamnwHw2cTlmSh481VYCvAnWtxECGQf8hEy2voEkooMUTRxNcQ8gqrNnPEyTnGLHyAE6Fa1elgcMH6gbunf53r2XiVr+1jDNsO9HrcnbuAbsB2QurXrmZm3Cd6Wr3rs9aIS1Cb+tO5NTUJrcP9bdJLi0DwqUvd7BlS8re2xEzMyr09lpwB8nfyzOCk/NUJSpOVSAcDBnSnXVm9FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0HQNPtWDFPA8jds+Azjz4PiQOrkZrz3dphIVvykbM4=;
 b=Dq0Toa9fHyDNLxcWStFrO5P4lRstN2yua71PJc+wjfj7rUCsVO0cyvsBmrd0TI1tkNywMzNWb5io7ctaIDQBRYfdSB60DaVRFqVa5wlxmhrHRvlhDAhLFAxoiL1hyMsfmnf1SMXt/a/zHZv2EyDzMj4BziDxh6pHB+M90dvl4CDMzgKa769QuP7GhMmpXSl/YgoT1yeTzISmv2DdKfd0eCveJVgfM/4zG6FyY/Ozz4pkps0odIIrWVSw/5GYX4FM3NliC8AE44fko4CzYE9Wm5Ap0pTZ9uU3IwlMa2crmsJtlPFI+nW+KbOXcbYbUDROBFYiXPYLUzukCbpOEaEdww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0HQNPtWDFPA8jds+Azjz4PiQOrkZrz3dphIVvykbM4=;
 b=HKbkc+FGx54IbGVYzDiBfoCiDfCJVgW/vHKAu/JNH5ou2DBfqYKgGWUCD4bVkEWawM9xmZaX5a9pDwCJgZvSzncVbAB02/mkEOV6NzHkxeQazZGfxxuEPF+BN/GI9pSHz69ZD9TdTqv4FHafc9oKpLN26T2ExKtmpOyHY7B+y/U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8879.eurprd04.prod.outlook.com (2603:10a6:102:20e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Thu, 3 Mar
 2022 14:01:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::ac0c:d5d:aaa9:36%4]) with mapi id 15.20.5017.027; Thu, 3 Mar 2022
 14:01:44 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 3/7] net: dsa: felix: remove ocelot->npi assignment from felix_8021q_cpu_port_init
Date:   Thu,  3 Mar 2022 16:01:22 +0200
Message-Id: <20220303140126.1815356-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
References: <20220303140126.1815356-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0108.eurprd04.prod.outlook.com
 (2603:10a6:803:64::43) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5072585-4793-43d3-c677-08d9fd1e599d
X-MS-TrafficTypeDiagnostic: PAXPR04MB8879:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB887983F62AF2D6CF1DF4D221E0049@PAXPR04MB8879.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AtG6JQUhoBkeq2cKU3g0jYrccOr/UxL/opgwXZil6n34tYOtOA0LzhAmkJYcwWoRVP8MEHwXvUNHGaG18iiDcNWruwk2p8rsgmq5Buizx2f01yeIQuLJoTCKxgidXNRstNXohYYEF7okPoX80+EIhPEbbItH1LZe6plt3Y510AtPCPMCyFYjDCU31QXRzr1T/RKi+fG4Qb+VWHcMl8uQSfgs4rXI8VmQSOfGqZW1DFFPusRIiSmuQdB/9IoKcAoNXFE1kI9+V1pCKunKsgxHm2xpL3WvswSyPWuUQPNSuURuuCmvSZgEPH0KJdHRdc3TqnkmS4BFrg+Rr9iiTY+IRTW3D9Qa72oWA7ux/AF3N8i5priVyYl4neE3LdgcsJ2+u9/xK6IvqaVdVlRU9l2AOUcSuY1DICFu17CljkJIhFsZA+Om0k6EaRDvhedAkrxk+H/MasnhO+sCe762gBNz8MFZStcvs+LQg0FkAF47Jk+guQ6/oaJ4ybofi4EmwUHypDhyCumJCMdfpQsWktSuYej+23vzwAaysI+0xwRBKW1AEfp8cBKc3twd3eivly+Zj+2iJ1WE2sszNxzImRvzNDA7toZsx9htocL9xIyeV/9+n1NCwiUs6vBf04KcZYvkYsM8tgN8z3n9bhqdBvOtzwF3M7s6BDTaliX0F8stbtmt7rbCz3eud74MLpWUZkXYhV1d7mGGZsla7U5Jtp8iRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4744005)(7416002)(186003)(26005)(6916009)(316002)(54906003)(8936002)(2616005)(66556008)(52116002)(6666004)(6512007)(66946007)(66476007)(5660300002)(44832011)(4326008)(6506007)(8676002)(1076003)(508600001)(86362001)(6486002)(83380400001)(2906002)(38100700002)(38350700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jG96l2KfCIJPMf52440xsAoLLms7gYtpm2Da6G4WJPxbRs9uuQJLxVLkqiuN?=
 =?us-ascii?Q?zip6PHmEBVOJHmf4L7hTuR4pf0WmpdZPO7vu219KW7fHjxMB8V+p6w4YeJKh?=
 =?us-ascii?Q?JL9Z4pAh4wvNdrRHIpH3xL3JTRbcIov7Hhd4l3zhIOxyCBTzV5OXc4FcoKMT?=
 =?us-ascii?Q?d+zg+p1wYgpFtodAl6vkP1XstlmhQBFhVWy3dbv5DJ5FEbAsA8HdildHV5II?=
 =?us-ascii?Q?pG6OrPrsNmMT/wwZKBP5vPkYF8IGKlz9r1D8htDNZtsJiJdypqY0JRi8D2dU?=
 =?us-ascii?Q?ThiHipos2HWNVeGiaXYQvMpNI4E2yje68aO0YLkxtfi7WTPI17y3CWb58XO7?=
 =?us-ascii?Q?qvC1P5oeD8F8LiXRCYA7eHE2VRubMNKgoA0zH1Wwecf06K6lIl2Uq2+tZS5N?=
 =?us-ascii?Q?HVFsbXyvTHni6+BocPC/ljF7CXK3OCK8QC97Vi/qVViGYeX5KXVZrQ3IiGZB?=
 =?us-ascii?Q?jqzhPbzaZlLUNL7qvJRs4VVJeZ9xHiRWM9B0C7kehNPvAGttSL2ebTBy1vtf?=
 =?us-ascii?Q?A5Wy6vuQdM1HNc4v5YqdXvzSQtD7vXuqMe5LrbXnwcFASBc/Cfi1abSp4DG4?=
 =?us-ascii?Q?cFx95joOYodTlujhZmutxYmX/7QhXcXqUQ09Gg1NOVx+giOWmyBzJFewRC8C?=
 =?us-ascii?Q?T3fzhysmLXe/6v3512535ppbdH0vIYmRUX+5vE5IHu4RFV6mMA8114u3D2F3?=
 =?us-ascii?Q?knErL6xyiBj2X4pVUaoERU187Dl0KFJA7YdemVna4Qgd4KZhJXb6cwpb19/o?=
 =?us-ascii?Q?YkZNGC6hyHg7FV9xcVtlxvwYzK8QQVA/c2WmDpoQ3y/i6tLg7nTQKWAwC9Q6?=
 =?us-ascii?Q?804YAI2cn+bXb+nUTp7dPDktdwD/5QK7sSvwOdFykxcG7IaUeewLLhNa0FrU?=
 =?us-ascii?Q?FQcjO8ct5Bs9FT8+v31KnXTjCWqilq2bK9pjDJ6dIkurmlYLbvx6nOxbci5m?=
 =?us-ascii?Q?58+evcYiTng08K5xl38CY6GpvZ4AVmQkOpjxOLixISJGN+3pgRTd+dd9mFdP?=
 =?us-ascii?Q?nB5+liRNx39YX1NJwtWjGtB0K2SjBepGx0V3V4JELK304hNYMkI4x3sXM8Rw?=
 =?us-ascii?Q?jFBIO8cD8RK83ekgWvkwlDA+W0BGzXSUtk8wLoOzFxUylR91HyGKkxWbp3uT?=
 =?us-ascii?Q?j/AzYVXiILCEBniCEUCcfX7vkp1AwmZ5x0eozm3dcTQOT93s4tTrqz6oaXYw?=
 =?us-ascii?Q?5Jwp6DaE6uw7G//+V/pweBZfX5Qi4pArllOomK/rbUOrO9RnUgWqqOWAkOV5?=
 =?us-ascii?Q?4k10me7fhP66712eyML6SDb03FK++rB4PHgcMiuk/peZgS07KmT0AwxmEMhf?=
 =?us-ascii?Q?viCsWVG65n7JU4LPowd9t1uoSMZ61p4hrM94aZkvQ+YsGTNnkuW5Hkv+ERQV?=
 =?us-ascii?Q?STFbp1//GG6k6zGtleBHBR3QDoCyqRkyPoSIg+4JZYfcRjTir+NaVVDbnnoT?=
 =?us-ascii?Q?kYn3/xp8fo87062YGksmyWcu0V+ronFF6bJlXrtaovh3xDcZJOuhU+Bp3PmI?=
 =?us-ascii?Q?YYYjkV+ojjtHro9JdcjUq3vPcTs6JVBaD8T2XnK6LTQir3IdmjoglynQnAc7?=
 =?us-ascii?Q?E7Nk6Re8clu3kjFvDB+zuQSLBQGyLMqFGIdJhAj1KLU4Ree5aMbgkomCn9jq?=
 =?us-ascii?Q?8s+wEr3GHpDXU/dlmfySias=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5072585-4793-43d3-c677-08d9fd1e599d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 14:01:44.5556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EJePJiLSJD5aiR629hRsDhJZMG5Bh8mQtXXGjiK8aA+r52gU0bUBk/0vPAjemY4KlHc0/g3TxMtJNU24kj8M7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8879
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This assignment is redundant, since ocelot->npi has already been set to
-1 by felix_npi_port_deinit(). Call path:

felix_change_tag_protocol
-> felix_del_tag_protocol(DSA_TAG_PROTO_OCELOT)
   -> felix_teardown_tag_npi
      -> felix_npi_port_deinit
-> felix_set_tag_protocol(DSA_TAG_PROTO_OCELOT_8021Q)
   -> felix_setup_tag_8021q
      -> felix_8021q_cpu_port_init

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index badb5b9ba790..6ddfe6fb43c0 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -235,7 +235,6 @@ static void felix_8021q_cpu_port_init(struct ocelot *ocelot, int port)
 	mutex_lock(&ocelot->fwd_domain_lock);
 
 	ocelot_port_set_dsa_8021q_cpu(ocelot, port);
-	ocelot->npi = -1;
 
 	/* Overwrite PGID_CPU with the non-tagging port */
 	ocelot_write_rix(ocelot, BIT(port), ANA_PGID_PGID, PGID_CPU);
-- 
2.25.1

