Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E490C2914C9
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439783AbgJQVhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 17:37:09 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:7653
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2439570AbgJQVgz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 17:36:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGfcUIhyB1RzL2REQG/S59j3eOxIs1M5PtXqoGCfSXDSArwDZzI0mmwFEU7VV+OlHncnLFuRdTsnP4HWX2JeRBrUTKte4xHMVJ4FMNBnned8pppk4hl9CDZH5Q+pBBpj4+0LJTASE8nb1kF0bHibTK2FLoR1u6i+3AXVYpyX5LitVxwW1ECyMK/aPvK+HSlh4OgE4U2EpwDMvieMK4dP+Gimxr2d80LikBSoaLwMqRKgPwozv1F3nVUjdmal/tsKKn39vCUZJ24p8EQKgPJpvppCiRw1vGUkdCb9fljQg73gGzEeZR2MLDYictuIB/XU/vOL4AEFDlTNWaJqKd57JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmttdPZdkPUTtwhpiRnG0Wxe6PIv8ueZiYyeqBANk9k=;
 b=Rgsqxl5WsDcjTix7OfJrmV9Uh1NimL2f9IbjEwqG3KY648yNMz1A/4xpsTouj2+kx73DsJvGlrZs04W1uNJMoqjnqNziil5oE4VQBT4Tk27Ynkp3BFkbbvd96a2NahA/r5ISPXvdzKiWwilaq44t9gdsDsjXFjjGS9xJXYDCinxYKT0NxA+HSYwLACHHob53AZtxXmIjvgPPAwiTEhsFyq9pxcnV5c5dVV2DyXNEHpF3QsB+sQwW3z/HydEOF9jM1XI30piLw0Ltd87xDJP5dfDm+u9qUNDzX893FmZCm49bYZEcwvC2b8W38RmSD/a9M/AImiDEQkaH31DRFzPXlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xmttdPZdkPUTtwhpiRnG0Wxe6PIv8ueZiYyeqBANk9k=;
 b=nUrWVjv77VgY62ES0QLICMS32Shedq0rK5pKHLC4+fU3vuslkZG48E0THMDPJno13Yi0RT2ZJNpjPpSJftoL1HFjg+uvfRxiq5dbf24ctpf7IhYGHR5GWlZGGr8GPNylRgN67ZiGe8o5gjmRShuaOqU7pXt87Rw9Ixz3Y41bN4M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5854.eurprd04.prod.outlook.com (2603:10a6:803:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20; Sat, 17 Oct
 2020 21:36:41 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sat, 17 Oct 2020
 21:36:41 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org, Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH 11/13] net: dsa: tag_dsa: let DSA core deal with TX reallocation
Date:   Sun, 18 Oct 2020 00:36:09 +0300
Message-Id: <20201017213611.2557565-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: VI1P195CA0091.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::44) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by VI1P195CA0091.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:59::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Sat, 17 Oct 2020 21:36:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: df20c0fe-5a61-4e57-e2bc-08d872e4bc7f
X-MS-TrafficTypeDiagnostic: VI1PR04MB5854:
X-Microsoft-Antispam-PRVS: <VI1PR04MB58544E87247F28F60E31B22EE0000@VI1PR04MB5854.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hfryUi8pSmEs6kFyCDK4u5oZbCBOS04QDuvGMLkmE3oqODlnJq50a4PfX2qxxBsxAgXqbK7oohXXRG74uJtZWnz0EmsXXndoKTbytWvzaRo6si1EIpchAdpZnUElYg6tq7SA8A8aPKIb8M0pzBhdaREwl3Bb9q6DZhukNIcEL7AGvlr9FRYu7rNmATRrS4P7//872/DSr51onEeWyHOyLTgrmqCfBzSQ77zbM6dJ7kp4ecFVlKfZhsJ5EBSQl3yHHtEtgzhlqARhVgJOgi5VvPT7vbBQztCqzT/IFRN+LL4G1cIC/K2K+dhfdCWW3IPxD4ZCLRJhpcze9E1FHnrGTWz1pqTRzDFRPG8NMxcecJOwu+yAraNxAJyecdRJ3qhP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(396003)(136003)(39850400004)(376002)(86362001)(2906002)(6506007)(66556008)(26005)(6666004)(16526019)(186003)(66946007)(1076003)(8936002)(66476007)(69590400008)(36756003)(5660300002)(316002)(4326008)(2616005)(54906003)(6916009)(52116002)(8676002)(478600001)(956004)(44832011)(6486002)(83380400001)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Ltv1mYgpHgCGSAITNq6InsiDQdlm8dYjeHjvbb3Ky1JA4w78WIsnQspnUZ1Hp9uW/ptLpbiFKTeCqUTV7FyQ0cSwheFpJCSUiiOZ9SgCmWL0qkrSQxVrdrz7Iu1K3dKWbodq1gryZf06eb+AkdOBtSzNzKF5GGQ/EPff7yg4YK92grdVr4RzsGqNFtmVY+awwKJrBK7FWMrjU77lHnc4s5xwg5ebVmO7U6L0OvYoeNDQ/C714/FNeTh8vq9ULh7PtN2YMAO6b0NNJ07mz4IafB7QqhTuHwTPzmtyRXLtuTaCZ3MKlGlZTvrXvaBvT275dwQ0LsLaQJOj/BguAya8a+8zmRE8mcDmaky67tOyQdvLLyYSiYtVjk36YUYt+zkEAqp9cIlHRdQ+/VHZrFvCBgWiQUUJ465YpkqXWixFEqGi/W8LOHFN1sjN9t4NSGSPSLCHaEPRmNlgL/1Sl8nTS/5pUXqkgVVn732PdwRa1aDjDVCziArlVCnj+KuwdWFdd7Y4LJTQYQpQJpIsMjTfFCh+ZGmNy+E8UlTH230tZH7143SrVrUBKbcc8BXRRYG/55wIZj3WEmYY8Ad8+ZbKIn0pp1xRH5YKmv0KVBryI/rzroHGLKpwe14iJbWkuJ2G+pwIU06i0Yz/nB0dt+WPig==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df20c0fe-5a61-4e57-e2bc-08d872e4bc7f
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2020 21:36:41.5951
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t8Pjf9uWy9QhRaGTpT+FVfzhQ0FJadkcr2FxUgpbhxvgAZ2SdaZa3MWLYHoR5GI7qMtKmMFsKuwj0CDJB0CujQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5854
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a central TX reallocation procedure that accounts for
the tagger's needed headroom in a generic way, we can remove the
skb_cow_head call.

Similar to the EtherType DSA tagger, the old Marvell tagger can
transform an 802.1Q header if present into a DSA tag, so there is no
headroom required in that case. But we are ensuring that it exists,
regardless (practically speaking, the headroom must be 4 bytes larger
than it needs to be).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_dsa.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/net/dsa/tag_dsa.c b/net/dsa/tag_dsa.c
index 0b756fae68a5..63d690a0fca6 100644
--- a/net/dsa/tag_dsa.c
+++ b/net/dsa/tag_dsa.c
@@ -23,9 +23,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * the ethertype field for untagged packets.
 	 */
 	if (skb->protocol == htons(ETH_P_8021Q)) {
-		if (skb_cow_head(skb, 0) < 0)
-			return NULL;
-
 		/*
 		 * Construct tagged FROM_CPU DSA tag from 802.1q tag.
 		 */
@@ -41,8 +38,6 @@ static struct sk_buff *dsa_xmit(struct sk_buff *skb, struct net_device *dev)
 			dsa_header[2] &= ~0x10;
 		}
 	} else {
-		if (skb_cow_head(skb, DSA_HLEN) < 0)
-			return NULL;
 		skb_push(skb, DSA_HLEN);
 
 		memmove(skb->data, skb->data + DSA_HLEN, 2 * ETH_ALEN);
-- 
2.25.1

