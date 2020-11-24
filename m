Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A93A42C33A4
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388722AbgKXWBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:01:12 -0500
Received: from mail-eopbgr30040.outbound.protection.outlook.com ([40.107.3.40]:23736
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388715AbgKXWBM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:01:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Elv0DbP2PsNnFIojz5IHsLvXSgxyKU6rpNGsnCdwKvu6vvKk91omVMbc8QawZiW/KhaD9HMjBKBhlf0ijo/QwR8sYsigljjiX3WxtLkKTXcNP3iUSRUoeakP+kLHgGUVZWyPE75qUY3qPYG6I1xmrDetmhm6I1Qa6aJjNAudkmpkT8pMK/aagmDTxreWPtHXIMuKt0xl3Z+IeLe8337NCIp2jO51S4gNCLOkYWJZJbABSTTtMlT90SPTVlT0HH9OyRYzffpqSzVvb3Zuafr+EVie3XG7y6T4X2tkbQq71xSUisFM1Tt08STcywTs4Cyud5lzPNY8gu6zuy2qPcQVjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxfIW42aOl9x9X5uC5F1DAqgCKha0GRbXAIy8GfcWno=;
 b=BdC1mQTFf0MA5jne7Wo31wEMZqTpia75GioMWk6Jw14GYN5IavzfgFO5/zk2s28nIpgcOdVQnmgX7bGmmrF0EADOeYQXIGfirR22keuRfXaEvbMMkVg2tsNZ2RjYaX2WCSyy96OBz3/T7y2iUnyex5rBS4lJLpkdE/3sVoIZx39emP+BW4SElNjC6KosnVojNYhT5ER+YC6Nxz0jMJ/Pb1VbD2qaUxHFMFOlF+yEemTTpN7ic+dgYvvz2BmbaonbjjwYRPKW4l+ouNsovIeG3ILlkHa9dVKqoEOQpQXIS3v5hqzcPawvRTcgOb8wNMo5eWZbnDyYikDKTixDxZsfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hxfIW42aOl9x9X5uC5F1DAqgCKha0GRbXAIy8GfcWno=;
 b=DtRyiPS17HVilRpaNOwtl+EJowE3pLiDMrpS3+t+q+lIPZvlMkf/VprkUYca+CfrSMVOUHXlDb/lM7OiRLatAmJjVcA9jSRUIqBtw3zl86T7E4q8HFapH2uxm58I4O+sftGi6HTWmCN2V5g7b3kaavsPRMmX7nT2bb5BFmj7PvY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 22:01:08 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 22:01:08 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v2 net] enetc: Let the hardware auto-advance the taprio base-time of 0
Date:   Wed, 25 Nov 2020 00:00:52 +0200
Message-Id: <20201124220052.3027090-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM0P190CA0020.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::30) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM0P190CA0020.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 22:01:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb7ceb86-2484-44bf-a999-08d890c472b5
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB7343B92110B0EFAECD679AAAE0FB0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMUxl+oVj+qP6bMBWbf3pra4V4mXDpqT2vfEkEJpDL512rMi3c30GxvQFUp6GrpHUTSaU7lYNg80whw6UgmXGQeZ4wrh1wVrW5Ac/i/9+hR4ISXSHRGmPl99jZ5lliHR28+2isEkRk3Z7Fzv6zcEH6AIvNuCzqfI3zjrEmh898tKfGweHlNCIv9BN7JKQs5f1gds1pgki/UbobCmW6ebxWGOczOFdwWdrRYg/Aeauvn9kW2vzFFoM1SEjrINOps7HQMGeCNs1HLG7FriLAEGSnP4QEsiMxr+LgOlnAHctUlvJE8fBBF0CGFhe/bk2UeN/jv5mVVxaNT2tKzjiqY9qYBwajF+V2AHeukoh6iW/5IcB7V+pyV2DU6ArFR2Q6Xp
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39850400004)(66476007)(6666004)(1076003)(44832011)(26005)(6486002)(2906002)(16526019)(6512007)(316002)(52116002)(6506007)(478600001)(186003)(36756003)(110136005)(69590400008)(8936002)(2616005)(4326008)(6636002)(86362001)(8676002)(83380400001)(5660300002)(66946007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PvzmOJQlO8cafbnjrCgKnquUshThTnfl2qcVIW670mnkpcvDbe6XvgaXhjOFoMslo7fk1IDf3I5u7ewzHju1fw5ggVkowpjZeCTqvVoMZ5jfTGPdJnO0tFm8992zkVm9/LGBW7gPkB68JJ0EfmDY336b1vYT8GRhapDpuQjqpB+B8qOkxPwKmHcmZFOom5Q8c/pX8+xxvDbOt027csr2vYVlP6wKGyK9A+X13NIxNJvHK7aP2k4L3lUTAGvpNj3kZTM+QPJm6dFbC+19nC6CVmEk+LILH1LUOWieaoP0Q1aboLzwYI1YUV/RNzuRFqZ0frvIeGC56KQ6a+r3OsarFS/ynhFZeqVmltrs6ZN5ibKIPGwFBis4RJVN2hi6DkB4nKlCh5771DavGMpbIr/IBJOmoT1j9j5RPKKMUvyFupGgWLEI+3ZxFApdXvuwhnMUA4L0Z9J1IyQMMrji7Q9Pyz1lIvsZ23chAlewbAYxxsUFyXl+UysrBB/JFNmuE9sI9IHg/+aaPUFGkNWs6inVYJnr7bH4qqZvgtP0KPOW5hS2CcKo3TF4e3fLkJUzjMqNoJts0Jc9HbT2ziu7MTn+EF9qaT/ALRoAEWXBl7wDUzIynV3zMf25uOA3maoW5zIhAhebkizPWC9BjgYM14aQmEmsWbJQy+TAywyQnv78trLgRxtBWpdxd+iRaC/b38bxfzShIuno/fTyVfFAgPStoL5CgbT39LUCixWsWuJoorilt//lXuAF/96ZxW5Wk/5NQL8pY1BZPn5iG+b5weaJltY+KA78lhR7WfDvVB7//Z0UX66y02X8MMNb8D8KpnQ+mwvpUP7wKbvfr+MhyOVnnkUN+VhKUMENu9AXl09xEiRNlqdzGiA4e8d8EVHbbwNNuwUdz+kS+OPP0WTLGb3IVQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7ceb86-2484-44bf-a999-08d890c472b5
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 22:01:08.7581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5zlA4mXr4ARwYsG/XAAqYtoPg6400utpogGyy9ZwssNLyPUg59xpiKUN28XnfrVKAryVpGQrYVjMlNYJImYwtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc-taprio base time indicates the beginning of the tc-taprio
schedule, which is cyclic by definition (where the length of the cycle
in nanoseconds is called the cycle time). The base time is a 64-bit PTP
time in the TAI domain.

Logically, the base-time should be a future time. But that imposes some
restrictions to user space, which has to retrieve the current PTP time
from the NIC first, then calculate a base time that will still be larger
than the base time by the time the kernel driver programs this value
into the hardware. Actually ensuring that the programmed base time is in
the future is still a problem even if the kernel alone deals with this -
what the proposed patch does is to "reserve" 100 ms for potential
delays, but otherwise this is an unsolved problem in the general case.

Luckily, the enetc hardware already advances a base-time that is in the
past into a congruent time in the immediate future, according to the
same formula that can be found in the software implementation of taprio
(in taprio_get_start_time):

	/* Schedule the start time for the beginning of the next
	 * cycle.
	 */
	n = div64_s64(ktime_sub_ns(now, base), cycle);
	*start = ktime_add_ns(base, (n + 1) * cycle);

There's only one problem: the driver doesn't let the hardware do that.
It interferes with the base-time passed from user space, by special-casing
the situation when the base-time is zero, and replaces that with the
current PTP time. This changes the intended effective base-time of the
schedule, which will in the end have a different phase offset than if
the base-time of 0.000000000 was to be advanced by an integer multiple
of the cycle-time.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
- Now letting the hardware completely deal with advancing base times in
  the past.

 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index aeb21dc48099..a9aee219fb58 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -92,18 +92,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config->atc = 0xff;
 	gcl_config->acl_len = cpu_to_le16(gcl_len);
 
-	if (!admin_conf->base_time) {
-		gcl_data->btl =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
-		gcl_data->bth =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
-	} else {
-		gcl_data->btl =
-			cpu_to_le32(lower_32_bits(admin_conf->base_time));
-		gcl_data->bth =
-			cpu_to_le32(upper_32_bits(admin_conf->base_time));
-	}
-
+	gcl_data->btl = cpu_to_le32(lower_32_bits(admin_conf->base_time));
+	gcl_data->bth = cpu_to_le32(upper_32_bits(admin_conf->base_time));
 	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
 	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
 
-- 
2.25.1

