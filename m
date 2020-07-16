Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 423C7222E12
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 23:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgGPVe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 17:34:27 -0400
Received: from mail-eopbgr150051.outbound.protection.outlook.com ([40.107.15.51]:32841
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbgGPVeX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 17:34:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrZJW84v0FUFGuOhCt57gVPGD2r1XB+IdImUywCGZ+cZucsVXdtPNXDLJ+dTbKi2QlxmNpLq/ss7foB7wEIRa6GnBybnOEEumbokNoz0pETPxB22OvpgE1+avhyIMY/LLL3afCrl9MByF+a6QculW6FyUtIZDzwmPoxMssAThAH92pXeYw07sYFEO/UO0CX2FsgaN+8QkD1MODMxbv0aaIJzsB9xj9SJdZPRkeGQhrLJvvYcOIKiA/CuxTdLtdz/QWt6RC7EP0MpzQeTIwsAgXpBTrbpSnI9hTZhxVVJ+BziBxNZYhTpYcxOqpxy5eFReOsjF0V5mz0GM/DhuuEobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1VhY46Dg1ahQlXuYGKa0jcFizfKEfDlt5Z+hTRirYQ=;
 b=Uw0noKET3G0+5T6dIwyWrEh+ajyFwWvmJBvIYblokNiZfd5KqRKI344cEUI7UXP9RwHNv6rgnlQ1Un9oruezxijQLdl1XEJWt3ba6+tM01oBoWfxEEknpBIEhxR706AdDQn+cnr8FBRKLQJBlIwO88bjOrwCGmM9+Dfh/KpL6gRP/HmVy7QKLhlNNzhUvMLxD4TnUuz74L8m8l9aVTe/vHeVIkwKVIAWlVrvrsqt+rAwqlQNuTk+iKu9YjOaXLobIoOpmiFTiVLMcBjy7ZZuTQyEAmQNu/478KfgaynzFAxH6622Qs5bZJQT8n3atUE8+DhM7PVXm4omnVScWFhiyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P1VhY46Dg1ahQlXuYGKa0jcFizfKEfDlt5Z+hTRirYQ=;
 b=leM0rMTjstdCD1tRBbngN/50kyMz7st4dY3YlPBkvJEhMFZmeMN1VmUuJNq1wwoCfQkQ/I+/JxJurNWwSZ2OR6P99ej2lngUEy7vSm1+qnxFezHUPCCFUs0kqRo31JuBR0ZmKTN1I0IElzOUqgy06XW9YG6lch8kT6KnbvcgqOg=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB2992.eurprd05.prod.outlook.com (2603:10a6:800:b0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Thu, 16 Jul
 2020 21:34:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 21:34:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/15] net/mlx5e: RX, Avoid indirect call in representor CQE handling
Date:   Thu, 16 Jul 2020 14:33:19 -0700
Message-Id: <20200716213321.29468-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200716213321.29468-1-saeedm@mellanox.com>
References: <20200716213321.29468-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0028.namprd21.prod.outlook.com
 (2603:10b6:a03:114::38) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR21CA0028.namprd21.prod.outlook.com (2603:10b6:a03:114::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.7 via Frontend Transport; Thu, 16 Jul 2020 21:34:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d442797-2407-4f02-fd7f-08d829cffa34
X-MS-TrafficTypeDiagnostic: VI1PR0502MB2992:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0502MB2992F0D45E6CAD171F08E64DBE7F0@VI1PR0502MB2992.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RKyHiaTKardZtF4LADBjGGrrWQ1wVguZ955hV24sMtT+kuN4NBaPlkHTU8mFnCSZB+eNVxJTy0Mxq4Jfwa1Y209oPwC5+HRNtY3xVUVEPH0XUFR5YREEd66UEiUq5sGvdAL5SaGUqwrPfOW4YvPI18O8G7P+JnFzEKW/23wE7pdlFh+CUtI2TST1qaaGE3EkiFasJlaVgIOCkwFdnGBdTaUJYoY/vOQ++DzsdFDGhbu+2qatdyv5fjnC62SwT/uBiD8SRk09eHvcubgn8cxePyhIVz36arcQ3SriUIEaKOzuJnh/DEHA55mkV1T4bcRZgDWylCVME3I6yKAZBtzHAb0z9oU2rwqFpfkmlx79zg9EOcRhAQn8dm3S7cCdCmDw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(86362001)(66556008)(66946007)(66476007)(478600001)(8936002)(107886003)(186003)(6512007)(16526019)(956004)(52116002)(2616005)(4326008)(8676002)(6486002)(6666004)(36756003)(1076003)(6506007)(26005)(5660300002)(54906003)(316002)(83380400001)(110136005)(2906002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m8a1PSsNzIWBnN4OdM233qeSKMcQILgbXipk2BYPB5urPSqAqVmfEjLs2q6KjRYzt69brojHkyrpPgi38n6AjThjyLHfVjABi5rW956zD/RO7qUT7Osi4yfq34jLhenrQs3RlMNidk19RI8/xfG6NPaA+0G+6jfFPafbFm9L4W6FNi2+6oZySBPcTrADGm2EF5+bSdS0FITQhaMmI2onClsFlCYn2MuO5hM2iQ8enPaTd6+WKZdKl6O7CvTJm37H7EcYywbGAxqcjVnckchzIW9nTnjHhb71XLGyfMeVEWDBcRzL1d+08FCYJjFquS2G2s2pFHBzlPS0eXUKDo/rTUt3wr2no0eRCtoRdqIqoaP/eJnMfutwLhDpyvjuEAvaQ4gSS8YI+R18hwOHxEL5Nap9QQPdUl1wuVJZMdaRjdPcIN23O+z3IKPwbnzhJLpN+ENyEXDh0eFRdVo8IrWaKzT7DIDlu5PRKtG5QXFjKjo=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d442797-2407-4f02-fd7f-08d829cffa34
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 21:34:10.9528
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q55/E31xu2JmqbHWD0cG0SUBtbPjbwGJaX/e5mqIkWL39QpdY02yXGBgiyhGylIpG/BtFzHGObZNhxJoV4GW5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB2992
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

Use INDIRECT_CALL_2() helper to avoid the cost of the indirect call
when/if CONFIG_RETPOLINE=y.

Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 8b24e44f860a8..74860f3827b1a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1266,7 +1266,10 @@ void mlx5e_handle_rx_cqe_rep(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe)
 		goto free_wqe;
 	}
 
-	skb = rq->wqe.skb_from_cqe(rq, cqe, wi, cqe_bcnt);
+	skb = INDIRECT_CALL_2(rq->wqe.skb_from_cqe,
+			      mlx5e_skb_from_cqe_linear,
+			      mlx5e_skb_from_cqe_nonlinear,
+			      rq, cqe, wi, cqe_bcnt);
 	if (!skb) {
 		/* probably for XDP */
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)) {
-- 
2.26.2

