Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC71E0887
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731046AbgEYIOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:14:19 -0400
Received: from mail-eopbgr30046.outbound.protection.outlook.com ([40.107.3.46]:24489
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730769AbgEYIOT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 04:14:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4PJIvc72in6wPu+7eY6HbY7Alwv2U+W+VTkUMAAXTHn6mXw+v1ta+OQvlq9rYuruEgDRNUM+U9w7WdtlaN9vj+Ixofn0NRtVppRpMwHdpl1G3cAnvZmoERPBuFVVYnS55zItnQwAVCW5C/61qDMAxINpQ27vEJn7nB4Mtzys519tUTU4T7fkSRDEBqS1YwxPXUN1mVL5XTVfrKMzpt/VlYY+ELBfrDlTmuNokEtpUTsD3OAYa3wgw0vmymqs+G7tobE8/QbyEJWLVVWBphwNTmQb4XxbyD5sdKjgaLD69hFqSOU5+kXKosQ6PowSruO9Dp+uTWUPono6/4mVh8qpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMjqADPXcr7gZ911ODQ9t2r94LjENwwbABkPzilulFs=;
 b=bYnlIWLA4sehHinmErzs03VV35mzylNJtCCMDR2XWqdqrB4/bUpwoCYFrhbAkUit+93vyBpCk6nkwW0RwrG5tYbHzWm4NrMgDP5z/V/vGSXlxrM7ONZYppNFouxeVguKmrksfN+gkg0NDOAZTCN0To9ok6qBQZnEnkgTWlEPgh+vzKlH66l5c2DNORPpn0Ic1TXjxH5FtRLgLMdxq+FSnriEWC+6FTuGZMJn9U2FI1y1Q7ttEOtaaSJVxbrVOV9zqEETXNT9TFMyIhJh+gmmASf8noWMWUti4J+7q2+F5qksz55BEBf2iUdVsuE+UEN+Dd+7y88zECZweMD2imK5MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMjqADPXcr7gZ911ODQ9t2r94LjENwwbABkPzilulFs=;
 b=mJO1/5CDHCHJ972PUhIQQKR4kxCoKa4APBOhqaY9OJbBCjuXJ9gU9AJmIddb4buGIps4ZepzlKzT5VjKmyDdwtNqZf1I2fw7N5BhUOHm9aZQRTQlKkRIePkvU0yzgPtuVLGWQm6SP++tRBeRgRvb0M4hpbyUDxg2Kkv7xWfj6T4=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3896.eurprd04.prod.outlook.com
 (2603:10a6:209:1b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 08:14:15 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 08:14:15 +0000
From:   Fugang Duan <fugang.duan@nxp.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, kuba@kernel.org, davem@davemloft.net
Cc:     netdev@vger.kernel.org, mcoquelin.stm32@gmail.com,
        p.zabel@pengutronix.de, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, fugang.duan@nxp.com
Subject: [PATCH net 1/1] net: stmmac: enable timestamp snapshot for required PTP packets in dwmac v5.10a
Date:   Mon, 25 May 2020 16:09:30 +0800
Message-Id: <1590394170-5363-1-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR0302CA0017.apcprd03.prod.outlook.com
 (2603:1096:3:2::27) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR0302CA0017.apcprd03.prod.outlook.com (2603:1096:3:2::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3045.9 via Frontend Transport; Mon, 25 May 2020 08:14:12 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b567133b-179e-4dc6-e804-08d800839d49
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3896:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3896180B2F01DB93F9AD1E23FFB30@AM6PR0402MB3896.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/yH2RBgA9AiIYAe484IN7UG6m7kZ5QxYbzdZkN0A9qHbZX+DJ8PHCUb3uHrJAM5Z6VDcN27Mqmy28fRGfFXjCZhi9oTbGSBzM4CqLKDePFptUQMvo3RuN4IPpMxYH0XXW+N1dWac8fafkkOYIL/DTQkQavJPdcFYnbey7/GZBSWzixAcGMBD/D98U5h7mbcF6R+kinGRer80QrcemlCW9MnCAIO12KOI2+EEqc2+Cjr0x3F9bvX9hDmwoA60G+hfCtPsu2cHxx1fj6XspEVyKnrKg+tVfFzRTQ6ULHXP5EecM4UvMegcvKzp9iES8Cg
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(346002)(39860400002)(136003)(396003)(6666004)(478600001)(52116002)(6486002)(86362001)(6512007)(316002)(4326008)(2906002)(186003)(8936002)(16526019)(2616005)(26005)(5660300002)(8676002)(44832011)(66556008)(66476007)(66946007)(6506007)(7416002)(956004)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: suI/oZQbS9BXxBmpbQiKgIPjPtyM+Pm9FSTX8zVbflbDk3kbXXH9W9cUpwLm7enyOcCerPet4fFo3W0bBJLKy7e+5aAN+va7AZExw/Vy7hazD3zkuOov01dnbeHxonrP8rEmDH3YJBh51CApvYtJN2gdtDQiJDEXhWVT2TP9kAK0IWkpQdgWTZzeGLCbMmYbI9FtWUrviFoLHJ2xUuqP3hCULI+C5DfaOBOzhxSHTK6LzZxg+tbRDjQDv/42PEPCbqrO7EsSm+d4QyLheztWTWjoD6mhDonQ5V5FBnOT62MYcRtDTNpGoQhwD+qCVAbVFl8MQ1Kaqzz7i0xl1iUF1uNmoidQ6wanw5uKoDbgjAlmAu5psgACavXELHw9jCOFIEU5yhMLGZ6HNxToXOmtkz1R4P55h/VaZWiXoO4glGVNXoM1bzZTrQfaONhbv5DY+esk9ZejexDq7t4BDVSf/ZK99xUBFVg4gPD97yiHtcYkAHHtZM72wx/2eH91uobW
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b567133b-179e-4dc6-e804-08d800839d49
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 08:14:15.5505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RYCJG6PbxKFNhJ21XWhiKYpTHEuogLk0IzTtMIXqKxnV5+BKvvB7JJSd9cV9Y1vEK6hykjXQ6BYAxGaG50knqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3896
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

