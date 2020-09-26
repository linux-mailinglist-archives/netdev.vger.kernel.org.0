Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91607279B6B
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 19:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730008AbgIZRb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 13:31:58 -0400
Received: from mail-eopbgr60063.outbound.protection.outlook.com ([40.107.6.63]:61761
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729870AbgIZRbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 13:31:52 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXBLzt+VnBfyniiuyjn9VEL9iuzrzS5B/TgYNCzKftLeVOiQHyjWd6jVBagFNPvQYbRltvIEIZ3LsTI/uFCbXPfR/tAocdTuCzeHNhM3dgwFplFjrfnVhRaB/+ViqdR5PoLR1NIXGLt5orjXSXNzHjqHz3Kd8gLJrT6IA1QLYFAUB3ZNLPrQrX6IKzLc1qcgS6TeQe6K0VVII/vxS2jkcIU2Bkp9WEvfzUxVqcrHt6eqysjQCCFWRwh1CV6b8+n5Y3QBs2KV4tnXkhzlHzXpWLWCz6Bek2fciqCgzfnVx83r0+utmq75J3mgzndW4vyuSvWLo6ZJ3wLMqP/vsXnNlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IbZxs+9yyS54YX5rrGVau93/229sQ2vdkxLHye/Mq0=;
 b=n0fxpMyXZGiqrnYzZXHsQx4Z+g+rIKoxJNBJJuranZsX7CSuPMpLl2lxB7VWC0H7l1L+RQwY+wA30xBu4ewidSUueYgW/oLooJc/B4xXm6uyV3AJM2egFBjaIWQSMlPE8kSxvCDPxEnm284a8A4tSaM3WSBvxQ3EAO38weaNULkjtQHwTdSB7LHX6l2wiQZtOh9T5Fel0AGa7TMJKxzYeoWybyBC5QjNeT+TzCyqM569iI3osd7E5t5D2G8T+PF9MaD83eShfoQ4yXFeRaTyoB9dlQLFHufFqoUL9hEIBdbAncYhyneWMGll7wXw1HM4xM/gVTy7V/27SOrAOZmacA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+IbZxs+9yyS54YX5rrGVau93/229sQ2vdkxLHye/Mq0=;
 b=TsvXIu+u+VCeAVZMpTHIUAz48IBBBlkz3MfK/GdlruNeRN3g5floKgaBB8dfKYBOMk+jVeXobjoF+/aksE25fYcOiLAmtO5u7PD6LofdFoeqLwpYt5Xn9/YSuExQloQjTaqEZMtW+F6pbJaEzjrdWUZUw1m2/cxojDLUDTonBkU=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB4813.eurprd04.prod.outlook.com (2603:10a6:803:51::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.20; Sat, 26 Sep
 2020 17:31:34 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3412.024; Sat, 26 Sep 2020
 17:31:34 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        kuba@kernel.org
Subject: [PATCH v2 net-next 14/16] net: dsa: tag_qca: use the generic flow dissector procedure
Date:   Sat, 26 Sep 2020 20:31:06 +0300
Message-Id: <20200926173108.1230014-15-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
References: <20200926173108.1230014-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0095.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::36) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM0PR01CA0095.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22 via Frontend Transport; Sat, 26 Sep 2020 17:31:33 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e955d4b-8203-4c26-1746-08d8624203ac
X-MS-TrafficTypeDiagnostic: VI1PR04MB4813:
X-Microsoft-Antispam-PRVS: <VI1PR04MB48130EE494E95EC622E97E58E0370@VI1PR04MB4813.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ak0Kr4LtbcJ+C6Uv9HIC7G0FDzw/MXZy3FzIMQXf3M5r4pc8pCQmY9xFBC0jhUtQxJxaSYCpn67Od3M8U1xbODpos4K+7cOvWCJo7uuJho5tWdUtuyiCMvkfXL3xtFkXIPGKKIEApYSObzXiTFFXXTydH8xjpoEFoMCectvempLLdwJI1lYwF0gWjiV1c9E0mcAM4j/CQBizCgE1/urfvFcW+VsfWcZeP/ixJx849UuPaW5D9JICbfZAvQ2x4f/K3D+qEwwbBw/j9tLfPqw+x5j7YOKKVfzpo2YhAvlSA4LNz1Xslxf1fkIEv6pMoppxenq1oTBzHrVKDF7Jce96NZEcI//M2RajYn1/cVbE6L8cGdTWQN21SN9Hr5WUoi7BLj2DU/ctIUhFpdfK5/ONGD89jOgEdTcRX82LU55w7BCTMf5R2Ds4zxjXvf7rRDUf2V3w03lQCe+qobeWub5B8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(136003)(39860400002)(396003)(366004)(6666004)(316002)(2906002)(6512007)(956004)(26005)(6486002)(2616005)(478600001)(8676002)(52116002)(83380400001)(8936002)(5660300002)(4326008)(86362001)(44832011)(6506007)(69590400008)(66476007)(66946007)(66556008)(1076003)(16526019)(36756003)(186003)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: NMW6KsOtQZfK0aKU+nKbo0Nsjv8FDT77sZYOL6nH1zcRbr2gGcMrO5aV28xGVT8WZmd31T44rYL4e7qp9sYovMkSpB4wKPpfkwM/kTNsbnkmdwLN+yW8yDjOVje/ICzP/utyre5I0KVhmH14SVDv5R00pXN/leftSkW6NfI65Jjat0WqdkkXY46DcC3461Br8uMrobzFR/OB8KOhfSPsjhD6VgPHRw47Hd4wLIncVLnDOvRU3YWWAl9+QBv9cnxjFXS5/vAVyI2CYcp4VSYlXTqNtiKGaHjN/pB2EVC0yFtel6sCCkiSBhbBn9LBeAkJvs1quSgu6j6FFfVWYnpPzjRC6Oit3tP4wTbuptilSJSWp2eaV8VAda2t3ugzI27pEIRovCoHYHanynuQ4nkQsmeqwfOGGysdQXbITGRQ6rTMFKcflU6CIdzKtlVQtG7BUj0nNzuXD2jkfwWzBil6bDRIz1ygZU/JqDamRg/2YuG1sijjXQdJoj3MvDu6P4VndLGTVWX/RNPKpploPtklXoPAgZucZq+2u/fQlMkYOZewFqKvPZZrggoFkttIp7H3slC4/NqmwYA8I5C+cPdwvgEWMk4vPlA8K+5h6zRNwiDnDW4e5NChLuhQPDNXCC4DOLii6j6fjvmcxZJz4YHkaA==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e955d4b-8203-4c26-1746-08d8624203ac
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2020 17:31:34.3977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ypJebhLFmwFhkudXv6ZcLUIzLHNJ/UK3AH5lymv0/rr5CFABktbIrWyM9hDX1Rk1EW5ieZ3qsyVwjlLvyWTHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refactor the .flow_dissect procedure to call the common helper instead
of open-coding the header displacement.

Cc: John Crispin <john@phrozen.org>
Cc: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/tag_qca.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/net/dsa/tag_qca.c b/net/dsa/tag_qca.c
index a75c6b20c215..bb929b8092cb 100644
--- a/net/dsa/tag_qca.c
+++ b/net/dsa/tag_qca.c
@@ -89,19 +89,12 @@ static struct sk_buff *qca_tag_rcv(struct sk_buff *skb, struct net_device *dev,
 	return skb;
 }
 
-static void qca_tag_flow_dissect(const struct sk_buff *skb, __be16 *proto,
-				 int *offset)
-{
-	*offset = QCA_HDR_LEN;
-	*proto = ((__be16 *)skb->data)[0];
-}
-
 static const struct dsa_device_ops qca_netdev_ops = {
 	.name	= "qca",
 	.proto	= DSA_TAG_PROTO_QCA,
 	.xmit	= qca_tag_xmit,
 	.rcv	= qca_tag_rcv,
-	.flow_dissect = qca_tag_flow_dissect,
+	.flow_dissect = dsa_tag_generic_flow_dissect,
 	.overhead = QCA_HDR_LEN,
 };
 
-- 
2.25.1

