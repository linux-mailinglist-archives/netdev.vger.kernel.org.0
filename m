Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D504B68D440
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:31:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjBGKbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjBGKbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:31:16 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2068.outbound.protection.outlook.com [40.107.241.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A79852B2A2;
        Tue,  7 Feb 2023 02:30:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3vxlteb4LUSYWpb8GpCOgmzfEQBR0RRp+Pw6lyaE+5gwOblUUqdGI/QVAZAvLa1yRNCftob3dhhprLw7F+faxQAMAb299ig9pOQ3fN9Mou7We9B92hviqroWJ/w9EYx4/UO8Qae5fRwquXJTfT1sMiVL2MhW1iOGbBXtYp7bteDkcSd0xy8C5IRIQYPI6/n1VADfDcOivbtB+i3/ZrZa6wKeF6x5hUzxzjMIfuKENcikuGSlzXfFvSOlTxMtb5s6STHGHwzCXjrWPgWac8etahZEJgrMNGR7wizL/wqVF+m7/oeOFGsMf4q3WUM0XBSdvxc8upIWYUfyS2Hx8zMKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4Y4OMC14risVihGyOmksynEVTFRTeMEHgGToHfOtsM4=;
 b=fp9t0J37kDZezmhUkmg5jKBPtCDcVJXmzATq5KI2E91VnPoNzpUwN5Lp2PKsqOAw09VltkPDPlrccVRK+EssHLH6cCiVx07djXgHlKxx3G1ru6jFruUVw72+2GTvEfQzlodXszzqD8qX/mZzFAsG4pypTc9tuW6YrtLevPZXXQ7ydpuWO8qBhnUXNe3VYkFa7UFRbXgCnbg0+Lp3Cxkguw2KIQetJzA7x1Ps/I4pGhAouU7EdhDgWjPXhU/XdTZLplQpUnek/Vc1LC1/krXUkLGApd84XC+gDoyTPxgGTlTiAYi8WSkQME1MQKGpSGIWXPfyJGRoEd2nC8z+cubDbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Y4OMC14risVihGyOmksynEVTFRTeMEHgGToHfOtsM4=;
 b=FQzowdrJvjrsqk4MZc5O1yrPXfb2zYxzO5nNJhhAMI/5dmyGgE6P5gOeV88/22fzff4xNaFf+SpTAM/No4N2i/dm4dY+XQ7y2pIyEzOB1LMNicJzfG4DVdr+yxzD6sqC7V/HHkuO51jXOTYd3zI74fQmtxb7GO14U5y8zhMBrDA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8274.eurprd04.prod.outlook.com (2603:10a6:20b:3e8::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.36; Tue, 7 Feb
 2023 10:30:43 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%5]) with mapi id 15.20.6064.034; Tue, 7 Feb 2023
 10:30:43 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        =?UTF-8?q?Ar=C4=B1n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>
Subject: [PATCH net] net: ethernet: mtk_eth_soc: fix DSA TX tag hwaccel for switch port 0
Date:   Tue,  7 Feb 2023 12:30:27 +0200
Message-Id: <20230207103027.1203344-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AS4P191CA0006.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::17) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8274:EE_
X-MS-Office365-Filtering-Correlation-Id: 09968a17-4ed3-4557-5078-08db08f65de8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZMxrWPusrYCB0sMmJfiiwNmb5utU0+Mtlyu6xC6rf+qx2VuVfAFas5YZJ3y3Y4CWZvuQF3GAxlnsx7g7r0G+Mqsa4OrfgAqRMLQYB1AFesb1KW5dB2oehcEcy86t2IBiCqB44spf++GHgSklfbHhQS3vcglGkuy557lhyEfl/DMPCh9DAsmCoq33ik4fHQfZuwrnXZbB/JldLjTf1fjWAEQSvTEWIaAVSb6kFyxKwhIS6ddPG5uKvq1OxGqD8vmQSG7BvqjFNGYdt0jv8m9lnIe1ZqIpUFT8wm0Gb8Y91ETKdw/G8CUMhfnKK+mJx1L2BoRVWSIqlJUlPPZsfnM4gUquw+5Jsq/iL2FuVI89mBCKz86JXAoyd8DZGjvCmhjLaJ2/Pb6xw3wFa3svD6Pd9SStx3qd+gmJtfi+d5zXqKNycsn1a6IKLXek52gv+dnp4NwJ/9qBKc7suq1DRUk2p0NdNtMTjW9gtCPFHgX+3AVZhIDOqY93BE/rhpQrEPYDw6Ene6j2Y8i75jVr91rEqZ1PEan6057t3s02DPRzjXEaGatcJj9fX+0hC5gAXQSVB6kLXH50g77KTR0y9JCKTFe8M0QUyIQUdAXR663v5QhF813b23EzQ1DabMmTxhFZIH6li7RnKwDMfALFJNtXyV9IaZuIjbIfQsyZpcFtoTqxW1WaBmsbIivXTlVhhCIyvmtnIBaAIqRd937N9hXf1UhPdcEqNXwkgdLx8OJ8Nvk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199018)(54906003)(186003)(6512007)(86362001)(52116002)(66574015)(36756003)(2906002)(44832011)(41300700001)(5660300002)(66556008)(66476007)(8936002)(66946007)(4326008)(8676002)(6916009)(26005)(478600001)(2616005)(1076003)(6666004)(7416002)(6506007)(966005)(6486002)(38100700002)(38350700002)(83380400001)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QXlPVEpGRE5xc2EyaW41TXk4S01CQjBKZnRVZjYyZUUwcmlPZnJtSWRhT2hm?=
 =?utf-8?B?K3VmdmliZE5JSm5JeVVBNytXREpMVm8wU2xyV0lnSDVkODdpT1pBR0FDdmxv?=
 =?utf-8?B?Qnp6cGEwc0JEY0lMQldZVFR0aGxZek43L2dJSUtBTVdBai9GL04yZ0crb1NW?=
 =?utf-8?B?UFNkVC8vcUF1bnhHeFFIbTZBN0Y3aEpDc1N4cmpHT3JhV1BJdjVwcm1nc0JE?=
 =?utf-8?B?U2llQjVNcWk1czU3NGFJQmJLMnBtdFV6bmNGWnBVYThPVG1rTnZQU2cvVEha?=
 =?utf-8?B?TXhxSVBnMnBRaDRXRDdYcE1aK2VaZzR1V1NIdUp6ZDlqNVNCVm9SSWpBVFM5?=
 =?utf-8?B?ck5jWkdiOVhOcFdwWmdnRVZTM0ZEb1ppZXhqN2lWTW5tYkxUL0dqSVl0NU0x?=
 =?utf-8?B?dUg1M2R1aTdTNDdWZk5ycXI3VHg0a0tjVGRaZlNxY3RKNFU3c0RaeWNiR0xK?=
 =?utf-8?B?aWdDUWJDSzdoTFBVM3NpdEV2bXlmWXJtSUd6azEwMVZXejVVQ1pnMlV6YThY?=
 =?utf-8?B?dTJITUU2NytocUNyRzZLbHo1UDhFKzhFdG9vNXBsZUVrOThZNENzWFJJNlMx?=
 =?utf-8?B?RnpzVkVCYTFYcmh0TkFWTnFiRkFiSm5SWE1OUUdYYVhLTW04SURrTjFNRlNa?=
 =?utf-8?B?MWRkQ3JETldRVTFEaWlDTlhzU3hGSUFPRTEyU08rcUd2Nmx6VUZoZmk0bEhI?=
 =?utf-8?B?QVA1L2QvSlFvaCtFS3ZJeUNWRlRRaEVSTTFvbjVXNUtETGR6Qzk2MXhubElm?=
 =?utf-8?B?YkFyWjh6alpYWFlGWE5YYkNSV0EwcHh2T2IxaWRNVHpncjZPcmJwTUlNVklJ?=
 =?utf-8?B?K0Jyd00yS3lDSmpQcmlLNEJHS3QvVHdUT3FzQVZsbkJFT084QzZhRU1IZ0d4?=
 =?utf-8?B?VTJIZTMyQVdhZE5NeERrNTl5OThrQTV2NUpHaWExdnVxQ1RDb2trTWlUdGds?=
 =?utf-8?B?M0lUb3JISGYvbEV5czV4SGtiYWo4Tm5rcHYremFnaUJVd2YxN0pXWjkrdStB?=
 =?utf-8?B?RHI2NGZuWkh1RklVQkxXd2x2VUVPd3k4UmlHdjNaTkJROTRvRmllYUs1U0Zx?=
 =?utf-8?B?VFBsdWs2TE4xMVgxOXE4c1U5anhSQ3ZwSUl4MkVmVVQzUXErRGZWclA2blpP?=
 =?utf-8?B?K0JvZzFhTWl0TU5VdksrcjdpaGNyd20rclRqV255QzVwaElTaC9wbTZWcTNB?=
 =?utf-8?B?K0xPbHlQVXFXWjlDbUczMUw1Rng2dTBGRkpWY0pDbWNaL1hoSkVKZFI1WnNu?=
 =?utf-8?B?ckYxcktCckxmUVV4MFNuZ2pNQ1VFbmRoVk9RM3IxMDU4cVVvTEI0NWJwSlRT?=
 =?utf-8?B?b1BnVktpUWRyMFdUVld5aTJTbnBvSU90RWFZekJkRDlaU09weFh2UkJXVjd0?=
 =?utf-8?B?SnhrZzIvT2RvMzZOWC80dGNpdE9QOWxQUnFpaGF0RUUyblJaQ0VQTE9UaS81?=
 =?utf-8?B?ZDY5RkdLcncxUUI1aG5COVhQc3FVYUVWVXZEUFFGV1M1VUl1VGVPbTZDeGVr?=
 =?utf-8?B?Rk1ubDBuNkRHVTQ4aFI0NG5VREFIeTB0TTFDdksxREgxU0FLQTZLSm8rdW1t?=
 =?utf-8?B?MVkrZDFRVnhrTlU0NFJReUJnNFRsd2tnZGszWi9Xbkx2KzJidGxLQzZkVkZ3?=
 =?utf-8?B?TDJEWUE5UWREYzVmSkdheWp3Nng5U3RTQmwrZjFOTnM4M0V4eTVBZ2RvNXBK?=
 =?utf-8?B?ZWV6cVJkZTN2TWdGeDE1MkFoR0Z5ZEFFNzJNTjYvL3pJY3F4UWlGV2Mvck9u?=
 =?utf-8?B?NHAxNGZpYzk0elRvRzg2U1daamI0eHVDNWVyVUp1OXY4enZLZCtjRlZRUDkx?=
 =?utf-8?B?VVNGNUxraGMwUk96UWtVSm45dmJZVkJYUVJVdlZyTTVTRlNNY0tvb2Q3VjlY?=
 =?utf-8?B?ai9LVVZiNjcvTWRZL2Z1MkhZNWtneEdIQUxLVXlBMmplNEtuS25makNMTk1h?=
 =?utf-8?B?WkYydWdWUWVrNVRwY29CWmlJNWxLcWhXTGcrSnBwSUZZbFRaMzVjTXlueVdi?=
 =?utf-8?B?ZlJBem82YTBmc2VRWXhSN09oa0dDRTZiQ1VJOVdXd0tKTEZscEt5K2RXTnF6?=
 =?utf-8?B?b3RZd08vRlp4WlFEVXRvMTZKVlVNTmplTW9Ydk5kRktRbWgzY2hUd2hHeWhV?=
 =?utf-8?B?amx5OXYvck1ZRkFuaXVzWTN0azd0VXFkZkl3Y3U2Y3QzNXZSWVdCSXFMNGtv?=
 =?utf-8?B?K2c9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09968a17-4ed3-4557-5078-08db08f65de8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 10:30:43.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLBjsKgWoNImZGCiTVYUMcuESKFVrrwK8JoZIQFF+bwkEy084bV6mGuOuw6TLtFf+rGTdvrRZldP6rjHgyNsSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8274
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arınç reports that on his MT7621AT Unielec U7621-06 board and MT7623NI
Bananapi BPI-R2, packets received by the CPU over mt7530 switch port 0
(of which this driver acts as the DSA master) are not processed
correctly by software. More precisely, they arrive without a DSA tag
(in packet or in the hwaccel area - skb_metadata_dst()), so DSA cannot
demux them towards the switch's interface for port 0. Traffic from other
ports receives a skb_metadata_dst() with the correct port and is demuxed
properly.

Looking at mtk_poll_rx(), it becomes apparent that this driver uses the
skb vlan hwaccel area:

	union {
		u32		vlan_all;
		struct {
			__be16	vlan_proto;
			__u16	vlan_tci;
		};
	};

as a temporary storage for the VLAN hwaccel tag, or the DSA hwaccel tag.
If this is a DSA master it's a DSA hwaccel tag, and finally clears up
the skb VLAN hwaccel header.

I'm guessing that the problem is the (mis)use of API.
skb_vlan_tag_present() looks like this:

 #define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)

So if both vlan_proto and vlan_tci are zeroes, skb_vlan_tag_present()
returns precisely false. I don't know for sure what is the format of the
DSA hwaccel tag, but I surely know that lowermost 3 bits of vlan_proto
are 0 when receiving from port 0:

	unsigned int port = vlan_proto & GENMASK(2, 0);

If the RX descriptor has no other bits set to non-zero values in
RX_DMA_VTAG, then the call to __vlan_hwaccel_put_tag() will not, in
fact, make the subsequent skb_vlan_tag_present() return true, because
it's implemented like this:

static inline void __vlan_hwaccel_put_tag(struct sk_buff *skb,
					  __be16 vlan_proto, u16 vlan_tci)
{
	skb->vlan_proto = vlan_proto;
	skb->vlan_tci = vlan_tci;
}

What we need to do to fix this problem (assuming this is the problem) is
to stop using skb->vlan_all as temporary storage for driver affairs, and
just create some local variables that serve the same purpose, but
hopefully better. Instead of calling skb_vlan_tag_present(), let's look
at a boolean has_hwaccel_tag which we set to true when the RX DMA
descriptors have something. Disambiguate based on netdev_uses_dsa()
whether this is a VLAN or DSA hwaccel tag, and only call
__vlan_hwaccel_put_tag() if we're certain it's a VLAN tag.

Arınç confirms that the treatment works, so this validates the
assumption.

Link: https://lore.kernel.org/netdev/704f3a72-fc9e-714a-db54-272e17612637@arinc9.com/
Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 24 ++++++++++++---------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f1cb1efc94cf..64b575fbe317 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1921,7 +1921,9 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 	while (done < budget) {
 		unsigned int pktlen, *rxdcsum;
+		bool has_hwaccel_tag = false;
 		struct net_device *netdev;
+		u16 vlan_proto, vlan_tci;
 		dma_addr_t dma_addr;
 		u32 hash, reason;
 		int mac = 0;
@@ -2061,27 +2063,29 @@ static int mtk_poll_rx(struct napi_struct *napi, int budget,
 
 		if (netdev->features & NETIF_F_HW_VLAN_CTAG_RX) {
 			if (MTK_HAS_CAPS(eth->soc->caps, MTK_NETSYS_V2)) {
-				if (trxd.rxd3 & RX_DMA_VTAG_V2)
-					__vlan_hwaccel_put_tag(skb,
-						htons(RX_DMA_VPID(trxd.rxd4)),
-						RX_DMA_VID(trxd.rxd4));
+				if (trxd.rxd3 & RX_DMA_VTAG_V2) {
+					vlan_proto = RX_DMA_VPID(trxd.rxd4);
+					vlan_tci = RX_DMA_VID(trxd.rxd4);
+					has_hwaccel_tag = true;
+				}
 			} else if (trxd.rxd2 & RX_DMA_VTAG) {
-				__vlan_hwaccel_put_tag(skb, htons(RX_DMA_VPID(trxd.rxd3)),
-						       RX_DMA_VID(trxd.rxd3));
+				vlan_proto = RX_DMA_VPID(trxd.rxd3);
+				vlan_tci = RX_DMA_VID(trxd.rxd3);
+				has_hwaccel_tag = true;
 			}
 		}
 
 		/* When using VLAN untagging in combination with DSA, the
 		 * hardware treats the MTK special tag as a VLAN and untags it.
 		 */
-		if (skb_vlan_tag_present(skb) && netdev_uses_dsa(netdev)) {
-			unsigned int port = ntohs(skb->vlan_proto) & GENMASK(2, 0);
+		if (has_hwaccel_tag && netdev_uses_dsa(netdev)) {
+			unsigned int port = vlan_proto & GENMASK(2, 0);
 
 			if (port < ARRAY_SIZE(eth->dsa_meta) &&
 			    eth->dsa_meta[port])
 				skb_dst_set_noref(skb, &eth->dsa_meta[port]->dst);
-
-			__vlan_hwaccel_clear_tag(skb);
+		} else if (has_hwaccel_tag) {
+			__vlan_hwaccel_put_tag(skb, htons(vlan_proto), vlan_tci);
 		}
 
 		skb_record_rx_queue(skb, 0);
-- 
2.34.1

