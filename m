Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD601E08AD
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730368AbgEYIXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:23:07 -0400
Received: from mail-eopbgr10079.outbound.protection.outlook.com ([40.107.1.79]:46723
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725849AbgEYIXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 04:23:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gub2bRJTiLGZVdeybT1xheSoQFX7CFdX8kw78PCpCqvscl14CaFphsFDblxXn++OkW2I9V1NXAcrlkaGLumxaD0hVtf8ooIDBVr9FOhL+HdIZ2lVXEnYk0mFk27xjMxslGarTVgRW5YVGLGNivCh3RJFtHEG2cEFAjGLbbeFyPongtrr6i8VrljKiKThlokhaDUxq5fPyx+H0q0nDpYbbqDm/Fm1PkCM6UoWsX7coDb8TV85lhBtNJoLFKBNHpVAVzJuFjPzPr1/osLqsfsrVFobT9/qaKAazxg17kmyxgY8QWqJe2PxE1Q8n+cCTvyUO7ekkujsAfQA8a/zNORNjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMjqADPXcr7gZ911ODQ9t2r94LjENwwbABkPzilulFs=;
 b=g3X4vOq3j41zbSMe3GPmGG8edV3XMCe/oxnINaHQB86idPDfKPVSURsSRo2W6nv43V5uKBrw6nK5b2Et3nxH26algOLN1feNNaoyW92uBMutsTev5zJq/sT0hT3sK/zRZWeYYpI4c3jrc9B1JQWdDGqY0k92Ic73cPSUfloRo+tFgeW96GjrPS/AANi1PhhvG+3sj5bFZmPxvfVGsyO4SzmUw/lfsMzJ3C8XzxLK4njyZpRP4TW+AZhEaA6ZwCkeFJNY+HvF/B+U9+6tZ6XeBbwG82g/2bV6DxHDDq6MbFrFR8dh9OCp5pJgTUyRzJ67R5UJYEEnvF3ngYwDqAS9dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMjqADPXcr7gZ911ODQ9t2r94LjENwwbABkPzilulFs=;
 b=lXVPzHScFlCmgGi7cpm/rJksWCgsFeaGqn7B1bam6lgGhPIOQ/KjSxg5k+/ZCttoXPIMP636yeuF01Iq4JwPB1Uv+5lbQs1nANp7/FAhjBT9WN0CquJ5Yx6Tr823Q0iRMqCnxq6d9TaBp9Su4Bx6h3sKz+28YpaHkoDEg6Kn1n8=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3717.eurprd04.prod.outlook.com
 (2603:10a6:209:25::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24; Mon, 25 May
 2020 08:23:00 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 08:23:00 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, fugang.duan@nxp.com
Subject: [PATCH net 1/1] net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a
Date:   Mon, 25 May 2020 16:18:14 +0800
Message-Id: <1590394694-5505-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0222.apcprd06.prod.outlook.com
 (2603:1096:4:68::30) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0222.apcprd06.prod.outlook.com (2603:1096:4:68::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.26 via Frontend Transport; Mon, 25 May 2020 08:22:57 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: acd30223-2c72-4985-4f5b-08d80084d637
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB37178487311C1EEA739EC3CBFFB30@AM6PR0402MB3717.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1O0gNFqrjVOtvHxMKEqo+ocXtffqiOXe5cemxPEW4lGv5K5wIiMcHYYrwrwXVLlF69X8qImlFKqu05w0cHTlzxGmN9WV7X4qyS2oLfMXkpqraduj/D0JcNjVJzEfwPnbofysQxqW/oC0ls5XSAHzEnmfkDSUiwmqjF8EO0UzlhJHOVbkHN+pJPtPLdmGRN6LlpWvA3JJJHJc0SbIXhLTY458yfZ5APwlo9r6nZ2dYL4enZNeJrIGmLEVnRRsOZ5x6AXzg3P22C/fHFmtqWohk6nGf5jRa1QIvwXXY1uedhn/8B8ydJK5kbELWFsZqBrI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(346002)(366004)(39860400002)(136003)(2616005)(44832011)(956004)(66946007)(66556008)(66476007)(36756003)(4326008)(316002)(8936002)(52116002)(478600001)(8676002)(186003)(16526019)(2906002)(86362001)(6506007)(7416002)(6512007)(26005)(6486002)(5660300002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Fcy6VjNhsQmcNvtat6vkGEDOnNrVOlFMJqd6qv4vKbxDSKdQrC8BLilhYj8GntNgYQvPnPplfBRNCRD6/7jfeJXaiF4GXGeson7eQL+Pdk8Tg9UfFK9Qh1fvS3A6lpZEpA9wCf8OVXyt5lbrIHgMMGm7rCWxbvEdkDVAchSczZ+0qQIAvqjCwMn/A57fG9muX++urxkzpmLnGaf3oXscXeoi74tB2giNMsiwnnmTghAFSFvqacymXF2AEYelwN8KKqlzvomyV0suxAclqzmYz+lK4Ri0aDpbdWc5+7T1mI+jvEeOdarqfCdFr88iL8Hv5NqfVXhog8UgGApTNGRMIu+6E6tTaEi93ft/73jU6hagZ/LkXELvxe172HtpWRtTWlWOqO4a0f8pSsYMVXP87ji34MZpdq4uLtsQ4OHf9Cf0j9jVZz5zRrXuoztd21nqq2qR0gqjiMFMwriLPYOP/EykDhV9gTpDktM7fphFkEPfIn3U7bAIFoBp4GBpw87V
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: acd30223-2c72-4985-4f5b-08d80084d637
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 08:23:00.5845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTIsOyFDtdJKLqbQWUvXf6lwJ0v8YB8kLBbLR6JzV6uEmyFcERZf/JWXGuCIOWIqc//OVqbruL6j951dCv6ZCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3717
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For rx filter 'HWTSTAMP_FILTER_PTP_V2_EVENT', it should be
PTP v2/802.AS1, any layer, any kind of event packet, but HW only
take timestamp snapshot for below PTP message: sync, Pdelay_req,
Pdelay_resp.

Then it causes below issue when test E2E case:
ptp4l[2479.534]: port 1: received DELAY_REQ without timestamp
ptp4l[2481.423]: port 1: received DELAY_REQ without timestamp
ptp4l[2481.758]: port 1: received DELAY_REQ without timestamp
ptp4l[2483.524]: port 1: received DELAY_REQ without timestamp
ptp4l[2484.233]: port 1: received DELAY_REQ without timestamp
ptp4l[2485.750]: port 1: received DELAY_REQ without timestamp
ptp4l[2486.888]: port 1: received DELAY_REQ without timestamp
ptp4l[2487.265]: port 1: received DELAY_REQ without timestamp
ptp4l[2487.316]: port 1: received DELAY_REQ without timestamp

Timestamp snapshot dependency on register bits in received path:
SNAPTYPSEL TSMSTRENA TSEVNTENA 	PTP_Messages
01         x         0          SYNC, Follow_Up, Delay_Req,
                                Delay_Resp, Pdelay_Req, Pdelay_Resp,
                                Pdelay_Resp_Follow_Up
01         0         1          SYNC, Pdelay_Req, Pdelay_Resp

For dwmac v5.10a, enabling all events by setting register
DWC_EQOS_TIME_STAMPING[SNAPTYPSEL] to 2’b01, clearing bit [TSEVNTENA]
to 0’b0, which can support all required events.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index b6f92c7..73677c3 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -630,7 +630,8 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 			config.rx_filter = HWTSTAMP_FILTER_PTP_V2_EVENT;
 			ptp_v2 = PTP_TCR_TSVER2ENA;
 			snap_type_sel = PTP_TCR_SNAPTYPSEL_1;
-			ts_event_en = PTP_TCR_TSEVNTENA;
+			if (priv->synopsys_id != DWMAC_CORE_5_10)
+				ts_event_en = PTP_TCR_TSEVNTENA;
 			ptp_over_ipv4_udp = PTP_TCR_TSIPV4ENA;
 			ptp_over_ipv6_udp = PTP_TCR_TSIPV6ENA;
 			ptp_over_ethernet = PTP_TCR_TSIPENA;
-- 
2.7.4

