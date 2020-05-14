Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C821D2CD3
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 12:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726126AbgENKaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 06:30:14 -0400
Received: from mail-eopbgr20078.outbound.protection.outlook.com ([40.107.2.78]:57542
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726005AbgENKaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 06:30:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QNyVzMCo/RiPwILlVFaOScgpdTwG8ij2IaZ8CmfR7LPFPP5mU2Pcr9s0HvrvzZ7+XtBudtyIzHLDJiYHcGIizeE3CFRx1gRCXIxzXHT2a4wEbtMH2pP6MHBwnMgWwgKyOoXjubf92PZ/5gQsDhNaFxXBvmvVgEylWHa/YvNv4M0tKpBJLPmqml4Aa4XUG7VHwrHIVxV3Bj3rcsN8Wql9bNJ9JdMf+0hDRrgKMTrFiB9BiH4vtVwkV01zEhMmx+GI1k5K+bF1b9joznygkTWhpEQEoa63pGht8DxdWowiu1/cQ/n64ermmX0VQQYO09zZyJzlSDnB0dxkA+87YXatbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1uw28ZVcLAT00xfqoLu7BUwaAfYFdKx7P3K/5H+gB4=;
 b=EaD8ovn5+9W8+slKcX490Iw0q2u5for/lfLgSrf0Rk1zhdw2bKzxwR+bzeeMtyq+Y3D8obTwJsX7/M6qeAq23mGalr1D9GQgq4bZnCaZ2Y2P18JJ5jUPx/RBRnWGpB7wNzgGUS9HADfn951ZfeQl3UD6QKOn855rzNDvkn1ZbF74bJCU9LCpfn4/JnriaPGTcRp4/Qn27skQUVSQJC/P5UqLe1oL01nZcJegEDMpzL3vBRr/RaesE71uSzbk5R5j4HZFjmTUIcWdxBk/+KFCySBMfPh4DUHkYfklK2J1Q4gdGBjc8mY+saI/KLbJLnjGtDsKRLhpzVWQhfWSGfh/xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l1uw28ZVcLAT00xfqoLu7BUwaAfYFdKx7P3K/5H+gB4=;
 b=MY4y7IuFYf4WbkTbMMp7Q/pGJPhiaFhH43K5lv9OmbI5A7lNqDI9v2wigoXxQLiy3Y+jATm35rkoSndUj2TMSJ0MbVIrOqAkLFxkB0SIM2E0U/RCILNGv01/mINWDQix/3EUc3l0AQ72j1PfVGftS+yFLAJE9jlZOtfEuYmiBos=
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=orolia.com;
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com (2603:10a6:802:69::28)
 by VI1PR06MB6752.eurprd06.prod.outlook.com (2603:10a6:800:181::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.26; Thu, 14 May
 2020 10:30:08 +0000
Received: from VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c]) by VI1PR06MB3919.eurprd06.prod.outlook.com
 ([fe80::d0db:5378:505c:873c%4]) with mapi id 15.20.3000.022; Thu, 14 May 2020
 10:30:08 +0000
From:   Olivier Dautricourt <olivier.dautricourt@orolia.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Olivier Dautricourt <olivier.dautricourt@orolia.com>
Subject: [PATCH 3/3] net: stmmac: Support coarse mode through ioctl
Date:   Thu, 14 May 2020 12:28:08 +0200
Message-Id: <20200514102808.31163-4-olivier.dautricourt@orolia.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
References: <20200514102808.31163-1-olivier.dautricourt@orolia.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2PR09CA0022.eurprd09.prod.outlook.com
 (2603:10a6:101:16::34) To VI1PR06MB3919.eurprd06.prod.outlook.com
 (2603:10a6:802:69::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (2a01:e35:1390:8ba0:9b:4371:f8a6:4d92) by PR2PR09CA0022.eurprd09.prod.outlook.com (2603:10a6:101:16::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Thu, 14 May 2020 10:30:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [2a01:e35:1390:8ba0:9b:4371:f8a6:4d92]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea8e7667-e9e4-438a-44cf-08d7f7f1c651
X-MS-TrafficTypeDiagnostic: VI1PR06MB6752:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR06MB6752C2C4E5F0EF54ABD9D8BD8FBC0@VI1PR06MB6752.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:57;
X-Forefront-PRVS: 040359335D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ev6pwxABjS99zFVQzH7ISmpfs/qn03ZiB3rTXztfYLwvhgau27G5DCjJhKWQWDP4TO3MnwcSlITQZSnG5W1En9LIXBhj4Iae72+AW3cgp9QaxwFUcKTj4IggKuKaEWBkI8+ZlXOUiU9cNI8yKqo9RK2CIxKV7TiNxa2sk+wRC/fxQ/nmE8Dcn4eKSB0+U1PiyVJh9/QRqlV3ch/ZDbnxOqzTNi3wB3WSApU0rLPi1eCKXz8HnTBFVypXsbkNGZNLepGPXllogGo9/+4LjPi4AM/jV/u9cuHETdwIS6nJSWiByk7GrEpwvWqEjMR2X3Up/tjDY3+nOfKIvin8Mu2IX/Kb18mYjmwF90P+AJfTzBR8pD/SX4xsowDaY3u9nigtfXSf1C8b3XclOVgx8ZNzN3GfEIRUQdEvlDp5I4JeM7S9Hp3g45ISXzqLsxJBw92bT3CNRmLnQ1p9ci+WI6GkQyRNPgpzf4rTY1QPIlRMU9TQnHSypz0Y5BQyhcX/zNmv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR06MB3919.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(8676002)(44832011)(6486002)(66476007)(66556008)(2616005)(66946007)(110136005)(316002)(107886003)(2906002)(54906003)(4326008)(6512007)(69590400007)(478600001)(8936002)(52116002)(16526019)(5660300002)(1076003)(186003)(36756003)(6506007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bcR+1YQG1c7HAJDDe05b1c7fUESVhjpB4ccRq9U8K5kD8ypXORj4sbjguICQ28TlTLvq5ZEVMbJSw4cw3CSKMHPDGKaz2GbDYcf/pQekEHtuje2DvI+dFT7HR+IF2JSwu8UOI4oWP8EF8BJ0bjd35vBpW1fIWYdt2KZXUdEhT+qc/IsSWxHOCJ0gBV6qdpt8SSozd7TWtlXbXWbPA+7jNzR8VamYeKnqewGW7BwyaaoXxgdiT7fwVJCDcuMiNWm6wZXzd4yIZB+OMccT8tAxGvJ+C1+2vLX9yuYOrRdespN2r4CN1Y3LL0m24SRU9u7jSIVJnCEhioLuU8a2CwQd3W9sDKXPgCrpA6UsWpG4yBrXNtsyzOI4TwGMkWcKC5pVicTYCNEE8DeGWpqcB3ptsI/DDmQF/2pyUtaX1+koXOlnmqO+3HxSGorOrZvQnRqX6ATPAA+iT770taeU4SwfImNS2/57h5q5bgryAgWoz9lLJr721Q4Vo6Emg0gR81qDai4He2c4lXBsvvld9WJb8FBSlcy8mbkjnXbpK22/qDc=
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8e7667-e9e4-438a-44cf-08d7f7f1c651
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2020 10:30:08.4507
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +cokZZCRqWMfSx9CRnOd9Zu5recfbWDVyZ2QcNOgeDkxbo4LArcvalaXOvwikMKevxZ+JjTCL4tqUlqoNIzfMERfmi7fWTeoZLPnlxCSjk0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR06MB6752
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit enables coarse correction mode for stmmac driver.

The coarse mode allows to update the system time in one process.
The required time adjustment is written in the Timestamp Update registers
while the Sub-second increment register is programmed with the period
of the clock, which is the precision of our correction.

The fine adjutment mode is always the default behavior of the driver.
One should use the HWTSAMP_FLAG_ADJ_COARSE flag while calling
SIOCGHWTSTAMP ioctl to enable coarse mode for stmmac driver.

Signed-off-by: Olivier Dautricourt <olivier.dautricourt@orolia.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c   | 17 +++++++++++++----
 .../net/ethernet/stmicro/stmmac/stmmac_ptp.c    |  3 +++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c39fafe69b12..f46503b086f4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -541,9 +541,12 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 	netdev_dbg(priv->dev, "%s config flags:0x%x, tx_type:0x%x, rx_filter:0x%x\n",
 		   __func__, config.flags, config.tx_type, config.rx_filter);
 
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
+	if (config.flags != HWTSTAMP_FLAGS_ADJ_COARSE) {
+		/* Defaulting to fine adjustment for compatibility */
+		netdev_dbg(priv->dev, "%s defaulting to fine adjustment mode\n",
+			   __func__);
+		config.flags = HWTSTAMP_FLAGS_ADJ_FINE;
+	}
 
 	if (config.tx_type != HWTSTAMP_TX_OFF &&
 	    config.tx_type != HWTSTAMP_TX_ON)
@@ -689,10 +692,16 @@ static int stmmac_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 		stmmac_set_hw_tstamping(priv, priv->ptpaddr, 0);
 	else {
 		stmmac_get_hw_tstamping(priv, priv->ptpaddr, &value);
-		value |= (PTP_TCR_TSENA | PTP_TCR_TSCFUPDT | PTP_TCR_TSCTRLSSR |
+		value |= (PTP_TCR_TSENA |  PTP_TCR_TSCTRLSSR |
 			 tstamp_all | ptp_v2 | ptp_over_ethernet |
 			 ptp_over_ipv6_udp | ptp_over_ipv4_udp | ts_event_en |
 			 ts_master_en | snap_type_sel);
+
+		if (config.flags == HWTSTAMP_FLAGS_ADJ_FINE)
+			value |= PTP_TCR_TSCFUPDT;
+		else
+			value &= ~PTP_TCR_TSCFUPDT;
+
 		stmmac_set_hw_tstamping(priv, priv->ptpaddr, value);
 
 		/* program Sub Second Increment reg */
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
index 920f0f3ebbca..7fb318441015 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.c
@@ -27,6 +27,9 @@ static int stmmac_adjust_freq(struct ptp_clock_info *ptp, s32 ppb)
 	int neg_adj = 0;
 	u64 adj;
 
+	if (priv->tstamp_config.flags != HWTSTAMP_FLAGS_ADJ_FINE)
+		return -EPERM;
+
 	if (ppb < 0) {
 		neg_adj = 1;
 		ppb = -ppb;
-- 
2.17.1

