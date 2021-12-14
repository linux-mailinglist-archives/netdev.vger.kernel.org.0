Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AAA473A61
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 02:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhLNBpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 20:45:54 -0500
Received: from mail-eopbgr130043.outbound.protection.outlook.com ([40.107.13.43]:7390
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229593AbhLNBpx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 20:45:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QXwnkQJLMmh5gUSTFpmGMpheNdy5H9nF300rDTje8gZO6XFBfyfrdKHH53QhcycsZNYCvgCrc/4dgY9H63bujh6gCDpy7XLORmekqlOiAaVAgT6W1HLIy4mx/R0KR21MII1kQupNXdmACmpa2vA9o/L+r1zf7bIg9S/FrZQCl1QmC6FEuT4Ebqlda848ROKOIjcVgRh82SdJhUiI/JDdFjnPdoXwBR3wL6llu5tXfw4x0kGjwqNq9tYXAGDiT+tiIHfIbhdxVvDb3CUsbWN4aZ0dcFU8cuXxVhACnWUtd2xIXTEWTRyuhNtpriWltKPtmHSErOo49OyfrlTf4+ziBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AduPcbPUR54GZ9368J4zip0+/RfR8CWlaX9W6rbGQBQ=;
 b=fabPSfKvGCrv1P2RCE7VXAJB8AQi6jUnU5zk6mhZT/S89b3JKXul/qea4yWu+8lobxI7FJk/+IeAUf8o4Pb0wy0M3emqMPTi3j25G/lgY11A1/gmNLK35n7pNL5HylatT50LLpPPm3uaQgAAPqdbO9+GdvqvjqfytVlmx9rDHWtI5dHoblRkB/zakhEeXq2xOQ+AZDK/Qxt+UbVs7PSZ1RRG+HCEb/ZWQon1OkHk+onCSajhBKW/6FrvVa6DMkliJmRUsWvYwFAOGMAj/IYGnkX6SS4Vu/EMJXHU6THKUGz2k2NxnpL8tKz44XfKYoFVi2Zyya/KHz97oAHel9OriA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AduPcbPUR54GZ9368J4zip0+/RfR8CWlaX9W6rbGQBQ=;
 b=l/A5EUFmum4Smm8bH3brfQCxpzZR6G6YaB9uLRYkxaNYqDkOQ8dWTV9xh3CZVx+TAfe5JfHvkzNDHgcIQMAonsck62s59zJQho5CWLJVAk9cw+it0lDPYA5vFrYDOEII5SK9lRLlRoLY5SXbDjIW2jLl0VoxUUXuSsSbzAjQFzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2800.eurprd04.prod.outlook.com (2603:10a6:800:b8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.18; Tue, 14 Dec
 2021 01:45:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.028; Tue, 14 Dec 2021
 01:45:49 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [PATCH net-next 2/3] net: dsa: sja1105: fix broken connection with the sja1110 tagger
Date:   Tue, 14 Dec 2021 03:45:35 +0200
Message-Id: <20211214014536.2715578-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
References: <20211214014536.2715578-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1c::14) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by FR3P281CA0027.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1c::14) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 14 Dec 2021 01:45:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 12c348a5-39ce-474b-465c-08d9bea3745d
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2800:EE_
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2800CDC6F6804A3EA235D554E0759@VI1PR0402MB2800.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xh0p/gR8fKa3R2Ja8kmBjgVtsHmhx7V+2tCRUDe/XYukRFawBRddDACYUZy/NbgGHQ4tiQGdbDgwaxc4QH0twwGjX3VXduC3fLzsS5j+JyticYikHF6EyumI+j6OyyJ/7SNme/09Lbv/T2Jrg2Pfbvqvf9cJIGcOi4+td1I/dt7QFi8kfAsW5I6ZHLt0qGGfcefyQqjO4bRxnbH5TC5V1xAGCoUYAP3DZ/7SdeyCA+4ecKlHI83rP/QtQ9QBeF38fp72R6Hhs1+DnqyPkej9tDoznv64rokMQkEasMZTUEuEOwCxL9ztIblFL82uqDaJi+azuYVoZWTn4f3Iran+6q+md5il08IvbgWOK5RUgzRJYMwCEhmX0s4Vic0HmFnovDgUsx64/Y19EIq98Traqi92KL90++bjSgArLB9PhAFLTpaZKMGSKSWhWB/k80upWhqzKYnEn/S+5g3LJy/iPQzfH0UqJu+a1vNNB1Z0rKpXq3dModwpsFhCC1QipMS/MxE1vP6vTSj910hq0Qm/kywHAyBJFn8TzFvlFzKNipfddBn6KShW9j+gGPRTUYZ9+m3XvEs5q+MXsrfFKpwha/hbfC1ovXHBJPzwzot9CvGqVNJ5geCyxRc3SPSv9PUbOwTpqwCUVAiozYeIX8YbQ3nvtiHGLYEdlUti2zz2gLbql+HS5o3b3vKVl0zgAxJqBGaikeAKvEyOYMLxDj6yUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(52116002)(26005)(36756003)(956004)(2616005)(4326008)(508600001)(44832011)(186003)(6916009)(54906003)(83380400001)(86362001)(1076003)(8936002)(6666004)(2906002)(6512007)(38100700002)(38350700002)(5660300002)(316002)(66946007)(6486002)(66476007)(8676002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8soaomTEp0FdMwDFW2mT2cPywDsLGj04k+ii+53FxPFJDukpMC27Os27S4oH?=
 =?us-ascii?Q?sg2tidR0KVK1EjxxEmlMW137g5CFa9MUzEGkWJmPR+NRE0+ZefpTUB2OJ8JY?=
 =?us-ascii?Q?3AP5QYyNAeAVSXphrVR5ClogT+yPQY3W7iOAk3xGRrt/dacNjmkF7bANpAua?=
 =?us-ascii?Q?Ewl/8SmLeatq2QJSxK6Rj4zVA+aEUGghJ1tnDMT/lsL520sqDJtMQEU4lKb9?=
 =?us-ascii?Q?RGc1msczjFsFV+QTwvXHrVfvTVb07icIEbRvdfCEp6GYwhRsn0KA/vjkxhQu?=
 =?us-ascii?Q?mvjp3SzjK6JOIjLMIOFKL47hLE5vhvSCK5DCC6yhpZBl6cZnuPTTxOkGJZhh?=
 =?us-ascii?Q?pdZkPH/TR8kNaFOuyMSKnjR1XrLKkYbx4z7A0dA6noncdqkVFgkSKgADpj+s?=
 =?us-ascii?Q?mpk0efGhweqb56/3TbpOnIF4ZSZ9H/bbYanEGC620+dgD+5oMeEpcyn9NqHk?=
 =?us-ascii?Q?WRUbbJp/6wiha3G/+irZxY2XJ64h8yCB0w1ll82xd06JzSa/TiAzCOOqIr0q?=
 =?us-ascii?Q?233T3MbZg0876G1JrmMLevQyAoPkesC/b08y5FQ0JDmH6FzfDaLwostrfQUM?=
 =?us-ascii?Q?FoC88p7L7Rc7mKRszp56RLtG7uCAUkttCliqem46wceQwaHdjBuHEZhY6b5Z?=
 =?us-ascii?Q?KyCvWD9vbRdry4ND/Atp1QTWTkCZ3l8Cci7G2t1eUyxgTA/wY+faSCUDmKLW?=
 =?us-ascii?Q?ZQT0ojrN997IChzctBCxUOqz4b10MSo0aUuDEpdPG2xkDvnTxA+r3VGrSKFu?=
 =?us-ascii?Q?XByWYi2kCArEc6qX8yb6D8mraFxVR9I0dnxF2vXLgoJxbSTMleLkw43SG1Dt?=
 =?us-ascii?Q?v+9aZcMyAJNiuqAmPQfAf29L4d6kOjBoTLQ9cdxf21KW3da4VPYWXfV0iUeo?=
 =?us-ascii?Q?6sM/3Wx2/lnNFhTjyKvK82cIJSMeZqPDXlZWvFeleFEMDI4YMewwAbxaPoYK?=
 =?us-ascii?Q?MRVhfgrBLlx7DWJey0SeYSBxXV3+3CkEYRglrf7xWmtXY3BvO/6iUSh1eYtp?=
 =?us-ascii?Q?HtCav9w1uc3JQ4iORKCIWaCylkj32uQBIILcfS61/Rq5nYGdTUOf81Ma+lVR?=
 =?us-ascii?Q?8GpzZ+JEtU2HawAiwJ5FPd2h8uODT+hNUYwMJQDV/h06oLtNF6WW3yZf3PrL?=
 =?us-ascii?Q?w2UdmTfTo+YuXA441r9/v9HJ3mLZ1zaHb+xfBk2qOC0173JlcY/v+FHwPz3o?=
 =?us-ascii?Q?rxt1hU+3okboox6lvVQIkjqs++Ir+u9OEAO+iyytOFbHtGvuWgiGMIyRjmYR?=
 =?us-ascii?Q?Sh+00tE+PmZzZjN8oKw8eF+rS9p5yGHZ8EiU4SDWx4v4MEqso1oEGOVwvw3N?=
 =?us-ascii?Q?lhsDKbrqwHOiny08dB/Cjosqq9hJUQGFAR27YaIw1oDP1H+uys/g/Ey9kykm?=
 =?us-ascii?Q?0vhTKVfm+j2Ve8KVYWXyAeu12yH0gMIseipXZ6iGDmBz3dMcIr0jjOUXoE3D?=
 =?us-ascii?Q?5oR8XOC+GodrkG+G4VKsdTMTcAo9QZerMOvExZskZSSg5XHM2Lr9ZmjIUXLU?=
 =?us-ascii?Q?ixMmWdW1MpH9+qedYvHWfTScDDq1aGINQ+u8F3oh7fcuNUDGv7KC8+PAjHhI?=
 =?us-ascii?Q?qeBfCpgNvRc01CK7tJxw/CcIFJzFakIi2hcADMoDfqDD4/ztjuzvei/Gr6eg?=
 =?us-ascii?Q?jIPPdIay5fBySLEGFEhY0i4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12c348a5-39ce-474b-465c-08d9bea3745d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 01:45:49.2102
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tqpBETGjm/VaCGCxXMvzW8izhkTcOKAhprN/wkZThWremIKUvykq3Ts2fEYCMhrrHizt/TPYTI4VU1sNyRZL3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2800
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver was incorrectly converted assuming that "sja1105" is the only
tagger supported by this driver. This results in SJA1110 switches
failing to probe:

sja1105 spi1.0: Unable to connect to tag protocol "sja1110": -EPROTONOSUPPORT
sja1105: probe of spi1.2 failed with error -93

Add DSA_TAG_PROTO_SJA1110 to the list of supported taggers by the
sja1105 driver. The sja1105_tagger_data structure format is common for
the two tagging protocols.

Fixes: c79e84866d2a ("net: dsa: tag_sja1105: convert to tagger-owned data")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 16 ++++++++--------
 include/linux/dsa/sja1105.h            |  3 ++-
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 9171fbea588c..b513713be610 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2708,17 +2708,17 @@ static void sja1105_port_deferred_xmit(struct kthread_work *work)
 static int sja1105_connect_tag_protocol(struct dsa_switch *ds,
 					enum dsa_tag_protocol proto)
 {
+	struct sja1105_private *priv = ds->priv;
 	struct sja1105_tagger_data *tagger_data;
 
-	switch (proto) {
-	case DSA_TAG_PROTO_SJA1105:
-		tagger_data = sja1105_tagger_data(ds);
-		tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
-		tagger_data->meta_tstamp_handler = sja1110_process_meta_tstamp;
-		return 0;
-	default:
+	if (proto != priv->info->tag_proto)
 		return -EPROTONOSUPPORT;
-	}
+
+	tagger_data = sja1105_tagger_data(ds);
+	tagger_data->xmit_work_fn = sja1105_port_deferred_xmit;
+	tagger_data->meta_tstamp_handler = sja1110_process_meta_tstamp;
+
+	return 0;
 }
 
 /* The MAXAGE setting belongs to the L2 Forwarding Parameters table,
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index e9cb1ae6d742..159e43171ccc 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -70,7 +70,8 @@ struct sja1105_skb_cb {
 static inline struct sja1105_tagger_data *
 sja1105_tagger_data(struct dsa_switch *ds)
 {
-	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_SJA1105);
+	BUG_ON(ds->dst->tag_ops->proto != DSA_TAG_PROTO_SJA1105 &&
+	       ds->dst->tag_ops->proto != DSA_TAG_PROTO_SJA1110);
 
 	return ds->tagger_data;
 }
-- 
2.25.1

