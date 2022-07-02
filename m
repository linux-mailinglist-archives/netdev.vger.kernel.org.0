Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77F2563EF0
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 09:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbiGBHgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Jul 2022 03:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiGBHgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Jul 2022 03:36:15 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2124.outbound.protection.outlook.com [40.107.94.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001F11C12E
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 00:36:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WNGrz+Qhbuv3Y69ZNCX8V1FQh+yMhEMKOrWWUNqLF6R8Gb+abGQJ3v97jaLacRKbIxtb5VVhtDYymAawMYlZWHN7vc9Gw+cTd3scHUOgBjKzOTdp9cVWUCbp6KDxqGtvIWL8IF6PxDXcj0njtzdNuMct6RsjxWtq3LQoD0DHgAih6EM3i0OlQ8nrPvAyAHHlqBhz5b+b5iMIAcdp+Hn5jQeLyqsPVBKVZCYHO0jkO/RJVI/0408Tv/eSL71/M5XQjf3JtCZEkiWrw75LZSN86008jhqVfCBd2iN4T/frLj7ybGNG09/w+RXwzz9Lq3SpHdI6DgV/hg1VT9/OLKjU/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KlecWKTyYNnUNEihEbx72BkmUqj6RI9hFrETyI01S6E=;
 b=mAVQ0y9LRO3RWOAulG+3XHnQB66IV9dt4+9QlYHfRzDK1QvOF5RXTB4N0JupUtVnlCoMNkGPwbOfxIoYhk8kVtrU8ch5NTiE+Ijd71d9GqWGmbZ0K/OXT5aYfUtlFHlDG5p1mMvCpeF78UtkA1FUgfRoLAV8st54iuDy99uNW5J9a4qSUfDIZdW4vDu6sni4SyJR6Ev65hGGzt0XfBPDkVo3QtMdQBc+4wgquffzvGnKayQmrOpRxPSj0JMo5MblhJUUYfNmsxJO2ZzT2+KzieB6jEtEr0G3K9XHjYSiapuPbfIS1ym6J20PvRGNKcxZUSnVx5c4aPzUmdxbU/8b7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KlecWKTyYNnUNEihEbx72BkmUqj6RI9hFrETyI01S6E=;
 b=A6FLrWxE1LwoUaQXlzZ4T95BuAbM2uAc1CWJXAS6fBNSmBy4EafQ/SG+RiNN30UAHkWOTmigdgALphA/aZP0vRGhxWBN6/Y17HRzMaTVtGR76XfFDavlbT3CO/ElVDPps4UBkzQiD97fOUXRl243fy46zqNSPx4VrUuTylMDAbE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM5PR13MB1068.namprd13.prod.outlook.com (2603:10b6:3:71::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5417.8; Sat, 2 Jul 2022 07:36:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::bd99:64d1:83ec:1b2%7]) with mapi id 15.20.5417.011; Sat, 2 Jul 2022
 07:36:10 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, oss-drivers@corigine.com,
        Diana Wang <na.wang@corigine.com>
Subject: [PATCH net-next 2/2] nfp: support TX VLAN ctag insert
Date:   Sat,  2 Jul 2022 09:35:51 +0200
Message-Id: <20220702073551.610012-3-simon.horman@corigine.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220702073551.610012-1-simon.horman@corigine.com>
References: <20220702073551.610012-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P250CA0017.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:5e3::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bd582de7-c37d-4244-d99f-08da5bfd8874
X-MS-TrafficTypeDiagnostic: DM5PR13MB1068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ga/bgyJD30Rs4wikIz1CnN3mmqy+J9G586UJkwB/6nN0NYnUQYd73R7xejEspC2Vq2Xya9dKxDkzY2lMsAuky3wqHWYiUUDqm405k5b+AHUCXOAmVYtkC2BpWkAbaUpOzdtMpZKQXJf6VLMYQKI808QowC7B18cAikN57mIq1OvaXsaeVXSTGKdhpsO6WU9XWLHYux2tkKgRnV5M19yiwoJXEFWvhmPa8ZmtJnzI0x1C63ilmpZD+wjmwxwlYJMaCnKr3TRZz2dr9jIB4NjkEdAtFHpKncinL16l3N/0yLztJjGmimfjK6s7HFSlBkf2Y7eeqo0JmcUNxV7s1ZKfoezp7YvBzGUYnGd9WmA6J8xBI73NZzD9iobqC8DbdGbwhJBrrkoGgYkyWFtR4WjeJBfM9Z5kU7KwNrZlXauHHLMfdi557SaGs8T8t9SU17QG57O7N5leq+vgpr7ZiWLgJ9LYYaYSldapkGS84v2YAalGdZZd3u5PeDCLywRdLFLr2N/R/2AOz1B6wlqsNy8uD0MZexoQR7BCIpLBpbnITvRIpwBNPaFZat2ZsOnA5DAfkHScCOFsJXL5WlGPKnocdL1ZcViNHjxokm4NoUYiPomiIhoLPaoFS59+0wplYAnOwsaWy4wa5KePD/mMMyawFQxAXBtPwpXD8cF8DuDpKKwE6AA/trAYkb1DcDp22Qgyn9a+LuVkTUmI6gq0ESWo8ONSoN1lcb2BueeXRUwJprVzeOj6vHlYXYO1XNcV83ejvuWE8zV/w9rDbz4qK34rHLeJaOeHCG+OwcgQZuWU6UBjjFQZhZRp81GEXckJM4T1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39830400003)(376002)(366004)(136003)(346002)(38100700002)(478600001)(6506007)(83380400001)(2616005)(186003)(110136005)(1076003)(52116002)(6666004)(6512007)(6486002)(41300700001)(316002)(44832011)(2906002)(8676002)(4326008)(86362001)(107886003)(5660300002)(66476007)(66556008)(8936002)(36756003)(66946007)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?y+SmJhg7coufnUse0CviBnDD6NGvCXX8ocUx3p9W4Nc/snScHOpT7OiCLNHP?=
 =?us-ascii?Q?KsuW0ISQfyj2eZ5sx/0jv4ioeHHZGsbuNJTzlqwpRSDhaCnJF7l7qE8o7q2H?=
 =?us-ascii?Q?lty5NQ3wWRNQ/B6wSWrZJzjP3+suMzwYSuyvLbZUH7WkAGX6GTiLkH4XCC2D?=
 =?us-ascii?Q?08k5ykbE6oUYYo5Zirej2evS0h6lGFYINfTWv/kCG+66mXCdWZBfG8ZDZl1F?=
 =?us-ascii?Q?yjs8MUIFzgW4R6uN/64XWIda3b1YS46iKoIvyxmH+qfxPtLbwIjJRcjf+Cqn?=
 =?us-ascii?Q?eXIHV+kH7oiI0caTLaLf/LT4eYTUEBgpe/JreFGCXcV4sLhqRXwGX8wSm14S?=
 =?us-ascii?Q?FIUBPr6slOFzttPUfPYEeS3iOnFP+b5fyqQfh3pErv+KyX9cKilHdMcC0TG3?=
 =?us-ascii?Q?Vt/y/0Bx06mgs5DUsdfS/8XCPrwtdWL/ifd2miEdIBdGIFqrp0Ih5EQgTZZk?=
 =?us-ascii?Q?qPiaamKjw6q9b+iZzOXusTrF5p+Qs/ORfwFJW0NqplnMLgTb9M+xsqUf9s+n?=
 =?us-ascii?Q?MumO8jCJnx6Y4I+2asLsWtC482FKW5IEUmMbw2Zfj0EhzmUunkDDtgF8QgDJ?=
 =?us-ascii?Q?VGL5HjNsi6w/kR4LuZK2j2kqMtb86N3HiiNftlZU5armGtYKepU2Z41J+xDf?=
 =?us-ascii?Q?9ctSpkBJATVyq5W+47WbpjN5grH/Sbq+ua0l40beHZR0Wu9rwGiQRF31WyFm?=
 =?us-ascii?Q?Gg/LHOsqveXm8OEHnwi6GPNoYI2wrhTt51bJ0fxlVTE4Fvoxs8FPWqoQeFu7?=
 =?us-ascii?Q?JvqBO3axDVCYvdNbGDRV62T7uAfWgGjQWedGo2380aEb7Bn1D5arhdtxn4ki?=
 =?us-ascii?Q?LIwKhhdTtrVGWaVmL+Vvlj2zMKsMR4vyBQlp4mu2tfNC56GhXCSOwhXX/4C9?=
 =?us-ascii?Q?M93ddpD0KWI++5E/KtNCUgp6RvE0ThDKXxySzAi0mjJs5A5lFRLzsz5nyLa/?=
 =?us-ascii?Q?8eEbKa1SwZ4XLSrIoP+Y4R8XcDbIpbGAGMyWAVxh2QcVB3wG0JyaVuamu7k+?=
 =?us-ascii?Q?zw3cmvRg+kxIVaUaNmZKgNDycM6DwtT8vbTg0QGnZ28PntkpHet1CYLdfnlW?=
 =?us-ascii?Q?+5P+2WdYO5tI/NF+uBYS5JbPGG3NWm8Exh42RS4tSsP9fTAqC00xlJbCzGFb?=
 =?us-ascii?Q?EFo+T+auOwqU8Qi2mN0tIkGyZNv42O6gTETGJ1eO2Rj/61mKtJ8PnCCgV7vk?=
 =?us-ascii?Q?0OnyuWEv/4TsNpjypmRbQ+ZeCh3XON9CYE6LhzqngezQ1YztDn4+Ej2QiRPB?=
 =?us-ascii?Q?P6gTi9ej0wFsgVIzme7WC5RDhj2ArI+NCweCoyXtVSouxpS4zbzRjrKtgCU5?=
 =?us-ascii?Q?ULAPPu/G8c7mZF7JuM8J3aB3Nytrx4yc6RuYS/KQ2s0vZfnpaY/eredRL0sp?=
 =?us-ascii?Q?4ElTMoV42q0wcpqPWuSXAvUdQwyZaLCkebVrZFpBTOpVTfHENYc4B3xaVNxa?=
 =?us-ascii?Q?36xsv8gHHetFO89VVgAahSOWHfpITbbOLmmVVttmIHODnoAZ++wlGwrKaiTh?=
 =?us-ascii?Q?ZqLXxGikM33NDsflLkWFd3qii0ix4ARHmBFX/1f/XXVB5oU4Fc/ttakccKmS?=
 =?us-ascii?Q?12wIpFXAhB61CeaNs85PT4lyDjdrZboCAWt4Bql1jgW7S8EROrUtwwUI/n07?=
 =?us-ascii?Q?Ambco5rLAT5a2nXrLaaPw4xfP5PRrHwR8vjLmbC7uvEaisbiUwXpY2BygMXR?=
 =?us-ascii?Q?nx/QfA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bd582de7-c37d-4244-d99f-08da5bfd8874
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2022 07:36:10.3372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FlTHgTh9blL1CLEedqRZJkCMT5Fn966zVwe/ZLcJTGt4euz2TxIJTHPg+4e+FljBasuDuIFK0rntOWOFDrInSrk1xBuuMGw5Hc/xfOCE2Os=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR13MB1068
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Diana Wang <na.wang@corigine.com>

Add support for TX VLAN ctag insert
which may be configured via ethtool.

e.g.
     # ethtool -K $DEV tx-vlan-offload on

The NIC supplies VLAN insert information as packet metadata.
The fields of this VLAN metadata are gotten from sk_buff, including
vlan_proto and vlan tag.

Configuration control bit NFP_NET_CFG_CTRL_TXVLAN_V2 is to
signal availability of ctag-insert features of the firmware.

NFDK is used to communicate via PCIE to NFP-3800 based NICs
while NFD3 is used for other NICs supported by the NFP driver.
The metadata format on tx side of NFD3 is different from NFDK.
This feature is not currently implemented for NFDK.

Signed-off-by: Diana Wang <na.wang@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/net/ethernet/netronome/nfp/nfd3/dp.c  | 41 +++++++++++++------
 .../net/ethernet/netronome/nfp/nfd3/rings.c   |  1 +
 .../ethernet/netronome/nfp/nfp_net_common.c   | 13 +++---
 .../net/ethernet/netronome/nfp/nfp_net_ctrl.h |  7 ++++
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 5 files changed, 45 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
index c207581ed00a..6e5ae72b3161 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/dp.c
@@ -168,30 +168,35 @@ nfp_nfd3_tx_csum(struct nfp_net_dp *dp, struct nfp_net_r_vector *r_vec,
 	u64_stats_update_end(&r_vec->tx_sync);
 }
 
-static int nfp_nfd3_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
+static int nfp_nfd3_prep_tx_meta(struct nfp_net_dp *dp, struct sk_buff *skb, u64 tls_handle)
 {
 	struct metadata_dst *md_dst = skb_metadata_dst(skb);
 	unsigned char *data;
+	bool vlan_insert;
 	u32 meta_id = 0;
 	int md_bytes;
 
-	if (likely(!md_dst && !tls_handle))
-		return 0;
-	if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX)) {
-		if (!tls_handle)
-			return 0;
-		md_dst = NULL;
+	if (unlikely(md_dst || tls_handle)) {
+		if (unlikely(md_dst && md_dst->type != METADATA_HW_PORT_MUX))
+			md_dst = NULL;
 	}
 
-	md_bytes = 4 + !!md_dst * 4 + !!tls_handle * 8;
+	vlan_insert = skb_vlan_tag_present(skb) && (dp->ctrl & NFP_NET_CFG_CTRL_TXVLAN_V2);
+
+	if (!(md_dst || tls_handle || vlan_insert))
+		return 0;
+
+	md_bytes = sizeof(meta_id) +
+		   !!md_dst * NFP_NET_META_PORTID_SIZE +
+		   !!tls_handle * NFP_NET_META_CONN_HANDLE_SIZE +
+		   vlan_insert * NFP_NET_META_VLAN_SIZE;
 
 	if (unlikely(skb_cow_head(skb, md_bytes)))
 		return -ENOMEM;
 
-	meta_id = 0;
 	data = skb_push(skb, md_bytes) + md_bytes;
 	if (md_dst) {
-		data -= 4;
+		data -= NFP_NET_META_PORTID_SIZE;
 		put_unaligned_be32(md_dst->u.port_info.port_id, data);
 		meta_id = NFP_NET_META_PORTID;
 	}
@@ -199,13 +204,23 @@ static int nfp_nfd3_prep_tx_meta(struct sk_buff *skb, u64 tls_handle)
 		/* conn handle is opaque, we just use u64 to be able to quickly
 		 * compare it to zero
 		 */
-		data -= 8;
+		data -= NFP_NET_META_CONN_HANDLE_SIZE;
 		memcpy(data, &tls_handle, sizeof(tls_handle));
 		meta_id <<= NFP_NET_META_FIELD_SIZE;
 		meta_id |= NFP_NET_META_CONN_HANDLE;
 	}
+	if (vlan_insert) {
+		data -= NFP_NET_META_VLAN_SIZE;
+		/* data type of skb->vlan_proto is __be16
+		 * so it fills metadata without calling put_unaligned_be16
+		 */
+		memcpy(data, &skb->vlan_proto, sizeof(skb->vlan_proto));
+		put_unaligned_be16(skb_vlan_tag_get(skb), data + sizeof(skb->vlan_proto));
+		meta_id <<= NFP_NET_META_FIELD_SIZE;
+		meta_id |= NFP_NET_META_VLAN;
+	}
 
-	data -= 4;
+	data -= sizeof(meta_id);
 	put_unaligned_be32(meta_id, data);
 
 	return md_bytes;
@@ -259,7 +274,7 @@ netdev_tx_t nfp_nfd3_tx(struct sk_buff *skb, struct net_device *netdev)
 		return NETDEV_TX_OK;
 	}
 
-	md_bytes = nfp_nfd3_prep_tx_meta(skb, tls_handle);
+	md_bytes = nfp_nfd3_prep_tx_meta(dp, skb, tls_handle);
 	if (unlikely(md_bytes < 0))
 		goto err_flush;
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
index 0390b754a399..a03190c9313c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/rings.c
@@ -248,6 +248,7 @@ nfp_nfd3_print_tx_descs(struct seq_file *file,
 	 NFP_NET_CFG_CTRL_RXCSUM | NFP_NET_CFG_CTRL_TXCSUM |		\
 	 NFP_NET_CFG_CTRL_RXVLAN | NFP_NET_CFG_CTRL_TXVLAN |		\
 	 NFP_NET_CFG_CTRL_RXVLAN_V2 | NFP_NET_CFG_CTRL_RXQINQ |		\
+	 NFP_NET_CFG_CTRL_TXVLAN_V2 |					\
 	 NFP_NET_CFG_CTRL_GATHER | NFP_NET_CFG_CTRL_LSO |		\
 	 NFP_NET_CFG_CTRL_CTAG_FILTER | NFP_NET_CFG_CTRL_CMSG_DATA |	\
 	 NFP_NET_CFG_CTRL_RINGCFG | NFP_NET_CFG_CTRL_RSS |		\
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index a8b877a5e438..6f833aeed75f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1703,9 +1703,10 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_TX) {
 		if (features & NETIF_F_HW_VLAN_CTAG_TX)
-			new_ctrl |= NFP_NET_CFG_CTRL_TXVLAN;
+			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2 ?:
+				    NFP_NET_CFG_CTRL_TXVLAN;
 		else
-			new_ctrl &= ~NFP_NET_CFG_CTRL_TXVLAN;
+			new_ctrl &= ~NFP_NET_CFG_CTRL_TXVLAN_ANY;
 	}
 
 	if (changed & NETIF_F_HW_VLAN_CTAG_FILTER) {
@@ -2093,7 +2094,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->fw_ver.extend, nn->fw_ver.class,
 		nn->fw_ver.major, nn->fw_ver.minor,
 		nn->max_mtu);
-	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
+	nn_info(nn, "CAP: %#x %s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s%s\n",
 		nn->cap,
 		nn->cap & NFP_NET_CFG_CTRL_PROMISC  ? "PROMISC "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_L2BC     ? "L2BCFILT " : "",
@@ -2104,6 +2105,7 @@ void nfp_net_info(struct nfp_net *nn)
 		nn->cap & NFP_NET_CFG_CTRL_TXVLAN   ? "TXVLAN "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_RXQINQ   ? "RXQINQ "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ? "RXVLANv2 "   : "",
+		nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2   ? "TXVLAN2 "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_SCATTER  ? "SCATTER "  : "",
 		nn->cap & NFP_NET_CFG_CTRL_GATHER   ? "GATHER "   : "",
 		nn->cap & NFP_NET_CFG_CTRL_LSO      ? "TSO1 "     : "",
@@ -2396,12 +2398,13 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
 			       NFP_NET_CFG_CTRL_RXVLAN;
 	}
-	if (nn->cap & NFP_NET_CFG_CTRL_TXVLAN) {
+	if (nn->cap & NFP_NET_CFG_CTRL_TXVLAN_ANY) {
 		if (nn->cap & NFP_NET_CFG_CTRL_LSO2) {
 			nn_warn(nn, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		} else {
 			netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX;
-			nn->dp.ctrl |= NFP_NET_CFG_CTRL_TXVLAN;
+			nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2 ?:
+				       NFP_NET_CFG_CTRL_TXVLAN;
 		}
 	}
 	if (nn->cap & NFP_NET_CFG_CTRL_CTAG_FILTER) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
index e03234fc9475..ac05ec34d69e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ctrl.h
@@ -48,6 +48,10 @@
 
 #define NFP_META_PORT_ID_CTRL		~0U
 
+/* Prepend field sizes */
+#define NFP_NET_META_VLAN_SIZE			4
+#define NFP_NET_META_PORTID_SIZE		4
+#define NFP_NET_META_CONN_HANDLE_SIZE		8
 /* Hash type pre-pended when a RSS hash was computed */
 #define NFP_NET_RSS_NONE		0
 #define NFP_NET_RSS_IPV4		1
@@ -103,6 +107,7 @@
 #define   NFP_NET_CFG_CTRL_MSIXAUTO	  (0x1 << 20) /* MSI-X auto-masking */
 #define   NFP_NET_CFG_CTRL_TXRWB	  (0x1 << 21) /* Write-back of TX ring*/
 #define   NFP_NET_CFG_CTRL_VEPA		  (0x1 << 22) /* Enable VEPA mode */
+#define   NFP_NET_CFG_CTRL_TXVLAN_V2	  (0x1 << 23) /* Enable VLAN C-tag insert*/
 #define   NFP_NET_CFG_CTRL_VXLAN	  (0x1 << 24) /* VXLAN tunnel support */
 #define   NFP_NET_CFG_CTRL_NVGRE	  (0x1 << 25) /* NVGRE tunnel support */
 #define   NFP_NET_CFG_CTRL_BPF		  (0x1 << 27) /* BPF offload capable */
@@ -121,6 +126,8 @@
 					 NFP_NET_CFG_CTRL_CSUM_COMPLETE)
 #define NFP_NET_CFG_CTRL_RXVLAN_ANY	(NFP_NET_CFG_CTRL_RXVLAN | \
 					 NFP_NET_CFG_CTRL_RXVLAN_V2)
+#define NFP_NET_CFG_CTRL_TXVLAN_ANY	(NFP_NET_CFG_CTRL_TXVLAN | \
+					 NFP_NET_CFG_CTRL_TXVLAN_V2)
 
 #define NFP_NET_CFG_UPDATE		0x0004
 #define   NFP_NET_CFG_UPDATE_GEN	  (0x1 <<  0) /* General update */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 066cce1db85d..8ea4d8b55750 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -367,7 +367,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 
 	if (repr_cap & NFP_NET_CFG_CTRL_RXVLAN_ANY)
 		netdev->hw_features |= NETIF_F_HW_VLAN_CTAG_RX;
-	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN) {
+	if (repr_cap & NFP_NET_CFG_CTRL_TXVLAN_ANY) {
 		if (repr_cap & NFP_NET_CFG_CTRL_LSO2)
 			netdev_warn(netdev, "Device advertises both TSO2 and TXVLAN. Refusing to enable TXVLAN.\n");
 		else
-- 
2.30.2

