Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC75F30C80B
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 18:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbhBBRjW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 12:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbhBBRhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 12:37:16 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe0d::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE231C06178C
        for <netdev@vger.kernel.org>; Tue,  2 Feb 2021 09:36:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J2FbxM2GxST4BenYEy/eK0U6emW/n52sQVspIWPMLEt+E+TwngDfbr5yTZCnKPbmaXABzFCPn66xGqmAf5IHHLtEdpDvk2r9dryGBC1HiGb7BqY420F/hoIZ2pt+9Czusyo2EGB19S4WRetSLuN/hQzZ8xxfTcYsKXlQxpKkNJNX9Zq34RO/YfSb1wSKs/zUQKW0Iiic0gPNPW2JkXTBJepI9X16u+2Esyfnh/g6UYm5etzBlcehPlLVB4bNl9hKYGUDz3Uo7r/PxvT4wKEc+rFxOv59dLlQWGwkZyrNIwcnYun8ELKucBnbXfP1E9gADVh3XitDFbuyz+cIxB4sEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdFHDv+Xoa+V5ZJUbX3xwPbAII33gY4jTVC4ctosGK0=;
 b=BO1HjOOGKA8G6pejv3gLSn7HGUrPV3tRyIh4CPrs10TZwML6QS+9NbfeGStg1932HY7FVzyRCRj3XLBQ92PYDv3kSnITrVX/OWkcYKniJwviUi0DUCFUVXQJS8r09HYJ0d/WZ9CltO2ZYiqfMvKVhYvWNqAN0w61G8mH7lrwA6Qo+VxAMnsZ9IIjB00+6kxg3d4Q0T2jyS0W9i8gCkYIlrRSNA080i0gTEyneua3gAISaTwb05bra4h7xRm2goPYL8iIbrwEbxXtFBmQh8TwVlji8NlEx5Ah0NUZP6FODwAbO3GDE3dpb14mlFajlX43wJziRW48ukVtzXkw4PnSsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cdFHDv+Xoa+V5ZJUbX3xwPbAII33gY4jTVC4ctosGK0=;
 b=rDzGznWtNzw5Rh0V616fC6i4BKlw7J0d9pbaQiF5QUlMTZDb+8SpE/1FnVicB8pPa6C8LvCnIPEgzaZNOiIjPDqUhkBU1wTjzqw18mtcMJTF/cjZPqH68Js+RziCXn630rraRzf8tii6GPA2oP5ch33zgZ9/RS1cQiiInLnG6rc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by VE1PR04MB6462.eurprd04.prod.outlook.com (2603:10a6:803:11c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Tue, 2 Feb
 2021 17:35:38 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::6ccd:7fa9:bada:4%7]) with mapi id 15.20.3805.027; Tue, 2 Feb 2021
 17:35:38 +0000
From:   Camelia Groza <camelia.groza@nxp.com>
To:     kuba@kernel.org, davem@davemloft.net, maciej.fijalkowski@intel.com
Cc:     madalin.bucur@oss.nxp.com, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>
Subject: [PATCH net 3/3] dpaa_eth: try to move the data in place for the A050385 erratum
Date:   Tue,  2 Feb 2021 19:34:44 +0200
Message-Id: <387f3f2efeab12a7cb2b6933e3be10704dac48bf.1612275417.git.camelia.groza@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1612275417.git.camelia.groza@nxp.com>
References: <cover.1612275417.git.camelia.groza@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM3PR07CA0093.eurprd07.prod.outlook.com
 (2603:10a6:207:6::27) To VI1PR04MB5807.eurprd04.prod.outlook.com
 (2603:10a6:803:ec::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15136.swis.ro-buh01.nxp.com (83.217.231.2) by AM3PR07CA0093.eurprd07.prod.outlook.com (2603:10a6:207:6::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Tue, 2 Feb 2021 17:35:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dd271cf6-2ba1-4cca-2c34-08d8c7a0f4a5
X-MS-TrafficTypeDiagnostic: VE1PR04MB6462:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB64628C3F4E94F0E3B9E38A5AF2B59@VE1PR04MB6462.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z0s5fUg2i0fDM95L62e8DmRsLrGY6EgntuyCGQ15hasRlckBOCr6KaOiBHxmDvvNTRrfChWuU0L9cFgZI8f6fe/iGh3Mkgigi189voJ1X0tCniSrJs7WYz6Cnot+XPOD+9hZp3g5pZUe8apQftbpHKOvezq4p8FJOL/AE6d2Wo8Wv19SxC6rD8VdMnxvFx+DS2lFmCnntc1e3nio9s72yef2O5ofugNEnvNj5DovKXBvxBushsn3QyKZMpH6Yv3kxMy0PY+/ZmurF9O5VtlMerx0MUn65ALAvYuso+TjVExvHPk23usOl9P4BpB1+kWnJJqBjTxlCu0KQN+shHtiNdwC7WkJLJCpI37FXuTSO6wFOXP/hdheSgTSZoVaFqNumx0JVsRkRNOf3RSqcgcX/A7M+EX9Lfs1WSwHvbgdAuNSfQjUcQxBGoBm9cUenDCcIFW/PjXz0hRNZ/WLO2N8iIhdwacVw4T0lbpEr1BEceHsKue+UOyxLi2GvEqE9ZUR4IRbNYmWWtm8eP9kkabgpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(5660300002)(26005)(6486002)(52116002)(86362001)(186003)(44832011)(316002)(36756003)(478600001)(8936002)(16526019)(8676002)(66946007)(2906002)(956004)(6666004)(2616005)(83380400001)(7696005)(4326008)(66476007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?0jgoDni4UfW6cFwtKIDvq9eEAD+Lum8K0LPkBf7H4Wqxuc0Zg+Jq28GDTjuJ?=
 =?us-ascii?Q?HisPyio5WV4L0uC6FdtzOuQtk+XCt9+ypCNZVxFSjrGFTck8K7oNZmaNlQu/?=
 =?us-ascii?Q?sHjFki/PedsHkFziyhJQefm/ZrVArA/huwls03kNtGqzgD0ahIeIQ7H6vziE?=
 =?us-ascii?Q?TBDoF38vuIZu258B3sNFmhUenEXq88oo4qr7wp2mhCRk5+Dx1EOs7UoStwCS?=
 =?us-ascii?Q?tUtUMpNpWwoD6rG05BlCytD0DKg3Pxf2LDZmjRoArEUdwCX/Kk2EBpvUIh8g?=
 =?us-ascii?Q?2W/8zPkCtzy7Nd3pLsMek/RvVzq1wmgp+LBhbkexpMPzqOTfzoOsLeKDIEoP?=
 =?us-ascii?Q?kwYfoVphtbcsDGldiE+Z50sgNSdNh5uDQD/um2Zf641fZGHLmD5qUrxreIwZ?=
 =?us-ascii?Q?bEr1SfpUPjGUtAHwzXWqal4SwBEB2ove5m/tdWlZbYmH2tgyKUXev0YLQNgD?=
 =?us-ascii?Q?VrqDapg2UDTb05+NcKf6DNLmQi1FCAZJ8ZqFdUsjS3JsREffcg27zl9oSVLU?=
 =?us-ascii?Q?xPu+Nn79W4zN2n7yQJCBk2iufOiI25B7G+Wdtp06NNZEkIhrYEtL8aGzOcv1?=
 =?us-ascii?Q?48eMIrgcEa8y9BIyqWwiy2RNhOTxdoHP11uy6Mmj31mJYTdv+CsBDazOy8h7?=
 =?us-ascii?Q?6zDxTfGt2KWNcaHA5BEH5a4HnO9pORk7EOTqGiwvJE/ErD2DQrtTv6pMHGLJ?=
 =?us-ascii?Q?Qyr18dwACDUvyGuWWKVONYvJew4OaPUMsawvS1Oz/bQyzBBjCpZz2fDlYsxG?=
 =?us-ascii?Q?sPp/taJ0PR5VuAcAdIxe+856FVHIsyoa6dKMb0LbNvIzZEShGHqM6qZIzf7E?=
 =?us-ascii?Q?lm+J1m73rGlRK4q5AjHZeVQYsYkdCr5Pro4t8kAKVQpcwds4JjEnnjbJAUH4?=
 =?us-ascii?Q?ou8qtLci++YcdxvWrxHUWnSMBucS9PL9GuRV8uL3PHdWCLGd72GRt3Fcoei2?=
 =?us-ascii?Q?4nFGcfl0xCG+vd7hOIU1d0wFfhLhlLDx5pHiyP2cVR2jDUgyvdEXkDKzkJyR?=
 =?us-ascii?Q?6D3XkUR2yoHwZrXInU0LXBJnpV4PtU2pdh9qm/36Oz/GJE09iO/PHpVY5aD2?=
 =?us-ascii?Q?Ds7E9AtMfG5OhShaqF6yfueSfJyF1AhhHqQcJ0cz2jOOHaaXQJpYBjbIkYyE?=
 =?us-ascii?Q?BqEnfxZjFRYV4jBIqhh/mzIApOIyqOxaz8fWjX+rYtkzuYON9w5I/Veh4VVR?=
 =?us-ascii?Q?Io0NlAT6WGqu6hCNRlfOt8SZWoXVRN7/nqumlikKpwK1RT86DmyzSJu/kEon?=
 =?us-ascii?Q?85EDuqyuehiThlbi+MeeL2VKj4XrKIXvKaw97UtZWzD/Gb4NEsX3x/NIGCrg?=
 =?us-ascii?Q?t3bOTrBRv/rNTi3rDOrCzW1K?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd271cf6-2ba1-4cca-2c34-08d8c7a0f4a5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2021 17:35:38.7954
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7uD3cO8jmCaUI21LAu5/kC9pBX3YUdIEZe0pom79peWnYmyOk7upeAzq8hhvE787ELng4cCCHcLIeE/HQNe12Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6462
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The XDP frame's headroom might be large enough to accommodate the
xdpf backpointer as well as shifting the data to an aligned address.

Try this first before resorting to allocating a new buffer and copying
the data.

Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Camelia Groza <camelia.groza@nxp.com>
---
 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 20 ++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 78dfa05f6d55..d093b56dc30f 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2180,8 +2180,9 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 				struct xdp_frame **init_xdpf)
 {
 	struct xdp_frame *new_xdpf, *xdpf = *init_xdpf;
-	void *new_buff;
+	void *new_buff, *aligned_data;
 	struct page *p;
+	u32 data_shift;
 	int headroom;
 
 	/* Check the data alignment and make sure the headroom is large
@@ -2198,6 +2199,23 @@ static int dpaa_a050385_wa_xdpf(struct dpaa_priv *priv,
 		return 0;
 	}
 
+	/* Try to move the data inside the buffer just enough to align it and
+	 * store the xdpf backpointer. If the available headroom isn't large
+	 * enough, resort to allocating a new buffer and copying the data.
+	 */
+	aligned_data = PTR_ALIGN_DOWN(xdpf->data, DPAA_FD_DATA_ALIGNMENT);
+	data_shift = xdpf->data - aligned_data;
+
+	/* The XDP frame's headroom needs to be large enough to accommodate
+	 * shifting the data as well as storing the xdpf backpointer.
+	 */
+	if (xdpf->headroom  >= data_shift + priv->tx_headroom) {
+		memmove(aligned_data, xdpf->data, xdpf->len);
+		xdpf->data = aligned_data;
+		xdpf->headroom = priv->tx_headroom;
+		return 0;
+	}
+
 	/* The new xdp_frame is stored in the new buffer. Reserve enough space
 	 * in the headroom for storing it along with the driver's private
 	 * info. The headroom needs to be aligned to DPAA_FD_DATA_ALIGNMENT to
-- 
2.17.1

