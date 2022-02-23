Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC8B4C14FA
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241325AbiBWOCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:02:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241327AbiBWOCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:02:00 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30086.outbound.protection.outlook.com [40.107.3.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805A6B0EBD
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ofrnzlLUutaq2NkKg7Fp32fhhke251SsVl4/XNLW35o2vWxxSD24SR/sbUK64ez2qi5wNpgaKuu0GV8b7oazCd69AqTi8Tz8q/54M7m977EwfXU853tT+tX0va4S4sbl1J+KOhNDUvPOSjKMWyfDadT2L4k/RN9NHZfSTOiKSjCDrhVu/HGaeYDoZPYE2kxAcwl8FQbwETvN1uIi7X5EH3xR5av9NG/sVteQKNO7QIXNtTcaBVjfIBmRLVTSn3gkZl92AzknSfMnBuWJh9vftum5jPGffR/QE7pahlCriWeiMkYL1XgUazSZA8/L1QZE96lPWThUI6TAUE5uTQ/GGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EwAuDKQO2VRfyGLNTSKd7wYTR7h16JY0EMFC1oY7Ao4=;
 b=JF/9aiZY17WduY/ZTdP7K8v35kluAPDAxnTJxM2x+yjMf7WsJF434vnc7s27gUZdm+sNH98bb/t0tO0BYvYzxDIIAJbORYo7ePo4G/2WtGodLYKlzUARX2p+68B+I9ioJhrAyFbFJsvUyqlm4Edtr1kVIdrMqWCN34NHRwSJr2MtZgEzDCc+z0wTLfKcL8w/xXU8dn00dW3uI8/CetDTf/ssxTSh+au2TrsTv3/PCFsa7O3o+8mmrcXDjSDUWiyIhlZXOmL1PEtJIRHaAZBG316YWclumjFeR/jBukKSe4DmYhdUjF9y+An89bnQfsiXk0zzfCxKJSYRqqtim/WdYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EwAuDKQO2VRfyGLNTSKd7wYTR7h16JY0EMFC1oY7Ao4=;
 b=kZ45JJCAWD6xtTHauGfAsoJiyUgoGQYBI5vkbkm6eqeITHgK8oqZ6c5gjGyqy8T0+fhauFrN3w4S4bB9wl1gJo6ScsXLdTGhnoWuke+kzqBF4p/aJp6HAL0KhtvJIl6y6b2CkfVtvQLTwBmJqH/JJGh/0jjBYcyIj15Xx86CZTQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB7PR04MB5164.eurprd04.prod.outlook.com (2603:10a6:10:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:18 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:18 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 09/11] net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
Date:   Wed, 23 Feb 2022 16:00:52 +0200
Message-Id: <20220223140054.3379617-10-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
References: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b842bc8d-71f1-4157-c54f-08d9f6d4f669
X-MS-TrafficTypeDiagnostic: DB7PR04MB5164:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB516474F0A60968474107AD04E03C9@DB7PR04MB5164.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GAEXalbaZwQ0YEnR12/qaLCo/E/mD4B4xhXanbiPj0yQovm0t3DOVNacw6IRaQ2zxgQObJvHz/29C7HIsDxq32UOCI5yx+z9ULhpQ8PassP8sUk+zcfGmZC5i4ttJCO5LwQKexdrrwdzLD1geBCjVveaPUDqRQ/YG0mbt2TlpG+B+SY9xdp5ryG9EIkerJVSTlLUorHJg8AGX2N17qTZ5t7FWyIy0ebQ0Adp3gL32vShY6QfsgwOfLd/Cu/rO4TQyTnAAjg8fuIh4FKFGnfMx15XRrh9ZeRwHnaLYnqx8f/W0hk+K02IFpD+Zw5Y34LuyzPHGX5Ne0fCeF2tBm4ajyzJODqHJ0fbn82NqNYsGoufRGuETVK60FhM9HZsU4XLCNMzB+sw5oKAN08kVuEaO2vGHrPyVMrIS2ak1UQQB/Fbyevuox22TmIWulEt3JGlQeT8v6QZ74dAsE9PV2EEziTQojWSUTBKei3F04XSXs3+BWYAayVbM65ZiC4AvuBHwPHLiY1jW5KunOtzexbroCyY5qFw76ZAklA70B3l6l/sEyCpyXn+KpeBkVKngqWr0jso1MIq1Q3ecdU+YTRaB5eLgPtr0hSz/oOkfFhI2/aEmoteXead1Ze+tXZzpxooaxbC+QOKhQxi3Qi35i2iQQM4YRex12L002I/P2kzMP6ITV82KD7lMKVMRYm3drMTbpaxS04Je138Y9CfEO6nJg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(38100700002)(66556008)(316002)(6916009)(66946007)(66476007)(508600001)(54906003)(6486002)(36756003)(86362001)(38350700002)(4326008)(1076003)(186003)(26005)(83380400001)(6666004)(7416002)(6512007)(6506007)(2616005)(44832011)(5660300002)(8936002)(52116002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OWGnti8dX8zF7Ng7MjPQLLgJpYWIa/b08xdDzZCIhrBIMxqUdIRStiWSS9J5?=
 =?us-ascii?Q?VQ/Wcqa/Z218G8psligrTRBz6LVrWRXQtUcRYFQlWIfYz2KTtr/7g6RFKUtK?=
 =?us-ascii?Q?f/JRmiJvnPwwNKlW5oKN9kNw6tfIa7NJ7a0nnRPhs8CuhbWzLFiSLdkisj/a?=
 =?us-ascii?Q?BoMqajUIwGorvGO6A3GlL18phJLAj5DkRgtTQNgeMUvXRV2mE7rPTdepN+Zu?=
 =?us-ascii?Q?Ze9kr/C+qzhR+9ENkJqFP0hH3iCCLGTsjjfulwZtm5FuZaoXbk2VUVmQ4Ig1?=
 =?us-ascii?Q?Kti55ifpqCGqSgohS9z9zdAFOIDHrv3usWBXBMSkDKBgT/bS+8iLPAVn43St?=
 =?us-ascii?Q?5Qhs3/FBKxcZ5VSsiL3rqcR0SEntM2QbzyKDEFlb+fTAaL6xIi8g6jIKR9f9?=
 =?us-ascii?Q?ObScCtRzgf0O4xMXyCBH20n2vvgNOMKv/Kq+tPyPy17NgcSqkRvl9Cbvc1u0?=
 =?us-ascii?Q?U7DfuhqQ7VXyAK3bxUiYQ4RiohdG7YqHB6Y7dGyqNV3lD+ZsWUuGSpOjavqp?=
 =?us-ascii?Q?zeJfaUAqrXQTybcnLiMVsH6Erf9mNMuMS59rf9Ti1dyqzHT+JGm0M4VSOQKQ?=
 =?us-ascii?Q?f152pDWp0wGha5QToqpf2ZyJPAlSiT2M+zCF8czJ3E6IBULA29epGFMoYKeZ?=
 =?us-ascii?Q?o4fHclH2bW5ZkV8Kn892X1c+r8AwxD4yOsrhLOY1MZKzvhw2Gq7JXq5ZYEYn?=
 =?us-ascii?Q?t2aDw4fPD7Fjg19O/+1Rj4XjU/ys1qKQqReGh0EbC8+5NhaiOg3zWZ08XxA9?=
 =?us-ascii?Q?pSC2eqjG1Aasa7akMSPQZZhHPgfiyv9Yh6nnbSU96wO5/bOFsK757m2mgB+i?=
 =?us-ascii?Q?tIP78FN6WEpM20ynLNglQSL8okyVO1ycpRY6T5TS0Z8+611JfxvZgHaaYPO4?=
 =?us-ascii?Q?Cxs/cQD8soUlCMkoN8GJLzCrgnQpLNgb5+pDC8GcbyciN8bpbTatg50oL9Qg?=
 =?us-ascii?Q?usY37f+NAw1CYmbr/xnW5AxQV7pmNmo9plbh0Tm3UBS9lKdm8bc6Kt0MKBU9?=
 =?us-ascii?Q?uZsQ0WuB3F9GPDE6TDnt56NSC2swNjLSajpJcQ32o6zcsnVE6cPed663wSxc?=
 =?us-ascii?Q?CXIwcFIv8FfCCX+pJKTPEbmmRC/sGVS9XGqIj0utqB6qXoc3/3PVMQoOZo+H?=
 =?us-ascii?Q?bu7WZc1oWXiZbac7pMJAJSbhZ6Z9hZmJ0Em/yz+DbnZZvtkPdcN7ALj+JtPV?=
 =?us-ascii?Q?5y/iW62Lb2TAEw6B7k51GKUdSYSwM0cS/1t5jMwnwl05kgbyCo8aZqFFvelz?=
 =?us-ascii?Q?s63wdI0lWeLBXaUQuxh/DDZfNiKRCisNs1MlaqXf3rWhGSis84ahcYR23Dzt?=
 =?us-ascii?Q?WjybmtpiWq4PDYrulYzXuT/J+xzJhCbGgRI8oMGpof5NsuCocOZqxACpOINr?=
 =?us-ascii?Q?dRlM6QgQvf1fPoZZysFEFLw/5wDbWrV18+D+M+PROfQ5FaPEfis+ldxCyCCz?=
 =?us-ascii?Q?plv5dkvBBomhBFMoQgaF9+Hh1QMhXbp6nPCO8SXHZTB4USyJUU3D6umCmx8D?=
 =?us-ascii?Q?NPd0kZnlEDsMIEi/wBYEOWMrzIXtcMGNAM9zQpe0MKy/10fRRyvPpuJ7LjV4?=
 =?us-ascii?Q?mh28QvxOxl3dU3LjM/gGiGwo2sVT2modjBHdsKCDY+CHR+0oFOHRi9T7X343?=
 =?us-ascii?Q?SMexz6nCroT9fA1A5Uy6r8M=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b842bc8d-71f1-4157-c54f-08d9f6d4f669
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:17.8981
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wYeGI96UIQ0CFC1jwBNEyyjt/qnPFLhyiwNDjPg6QArIjJneCAi75RbqHkgLy3rRZmcVaq5vj3Xx6HiHWcvjLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When switchdev_handle_fdb_event_to_device() replicates a FDB event
emitted for the bridge or for a LAG port and DSA offloads that, we
should notify back to switchdev that the FDB entry on the original
device is what was offloaded, not on the DSA slave devices that the
event is replicated on.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v5: none

 net/dsa/dsa_priv.h | 1 +
 net/dsa/slave.c    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index f35b7a1496e1..f2364c5adc04 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -120,6 +120,7 @@ struct dsa_notifier_master_state_info {
 
 struct dsa_switchdev_event_work {
 	struct net_device *dev;
+	struct net_device *orig_dev;
 	struct work_struct work;
 	unsigned long event;
 	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 7eb972691ce9..4aeb3e092dd6 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2378,7 +2378,7 @@ dsa_fdb_offload_notify(struct dsa_switchdev_event_work *switchdev_work)
 	info.vid = switchdev_work->vid;
 	info.offloaded = true;
 	call_switchdev_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				 switchdev_work->dev, &info.info, NULL);
+				 switchdev_work->orig_dev, &info.info, NULL);
 }
 
 static void dsa_slave_switchdev_event_work(struct work_struct *work)
@@ -2495,6 +2495,7 @@ static int dsa_slave_fdb_event(struct net_device *dev,
 	INIT_WORK(&switchdev_work->work, dsa_slave_switchdev_event_work);
 	switchdev_work->event = event;
 	switchdev_work->dev = dev;
+	switchdev_work->orig_dev = orig_dev;
 
 	ether_addr_copy(switchdev_work->addr, fdb_info->addr);
 	switchdev_work->vid = fdb_info->vid;
-- 
2.25.1

