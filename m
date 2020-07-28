Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E958923063A
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgG1JLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:11:30 -0400
Received: from mail-eopbgr10068.outbound.protection.outlook.com ([40.107.1.68]:63277
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727957AbgG1JL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:11:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=biUPfKjcpC2moNBLumB2CZpBb5ZsIYvv0J0DjFLM8M67jyU+bWDyjJcw/WRkOY4Ol4d9OoFAh5jnI9dXr7km+uNqKTpoGDR3LaFrfSljixRW/5QH0/K7G7AzclLRDvg9XvjozhnftAj9b2gnmwym7S2IQKzhaQcB7VN4caMgY/cYaPFtC6bIyg9TLTy5y29atbsA1ERASEmMAF+eLh3CNTSX683cKyPAwpNDZyJsm/zazLpxJlmAfIpoN/de7UfcFb6BxCc2aXttDOJ7u8GT4o/o2rpT74H2Fg/QCDa3U5HKq8RdQqPoK+CApVKgRT1Cl6PnDiIR6IAEEFf665zbzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh/WC1RGHuRNGr4ByxZYexAoCoMyD3n91nbAh5l8XQA=;
 b=T68kbznRfILYN2TILp1DsZIbrXsCc+zxpsAea7vlMCzn5+kNddbNcxn+l9yQbLnPyAYq+GC5uKiPot30AIVq98lp2U+bvK/2XJKla+YUMDLYy3biBksb9m6SWvuu1+U+LkZAYZgnL2PVUXnQZmzA9k9xMLObtstRrAGKIas6OlT/p1kyPxmNcLZRe7b3LVj2BO+uT2YcBUFFO+K/mwqRajvM37Vntveo2H//zmgrOrtYBYsMiTVSq/HGmmuzvRWoJjDWZGSpGl57cAUrBrIw9lg8MMkVbky/tMlHObl6lcaVuqVwH4fKNEs1QZWNQv9dIZunG590B9TnYn+/sSS7Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yh/WC1RGHuRNGr4ByxZYexAoCoMyD3n91nbAh5l8XQA=;
 b=pCVEgkZAn8j9FNKiiXRVN5HA0Q39Fj1Dh+qzFpCiHw1J5m6rEhwufw97NBZH7JpZ96Snayl/Dicm/jTGGb17r/Oi9Tyzq82Qr9dQtA1567IO1RMpqd47yLxuZkfDX4KcmfmMFkfHUtYqPLxIcBth0tXF8RJ3l7i5C+cgpMm0VAo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4638.eurprd05.prod.outlook.com (2603:10a6:802:67::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Tue, 28 Jul
 2020 09:11:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:11:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/12] net/mlx5: Verify Hardware supports requested ptp function on a given pin
Date:   Tue, 28 Jul 2020 02:10:31 -0700
Message-Id: <20200728091035.112067-9-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200728091035.112067-1-saeedm@mellanox.com>
References: <20200728091035.112067-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0022.namprd05.prod.outlook.com
 (2603:10b6:a03:254::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR05CA0022.namprd05.prod.outlook.com (2603:10b6:a03:254::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.9 via Frontend Transport; Tue, 28 Jul 2020 09:11:22 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 789e4c8f-23da-423f-f905-08d832d63368
X-MS-TrafficTypeDiagnostic: VI1PR05MB4638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB463804221A7A0CFB3AE582AABE730@VI1PR05MB4638.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTnsr5fZtLWG+7ZrAIo5K0lYF+X63wJUjPWkdqfIZYc7ujP/ZU1KC12kU+ZXbu5mWUwhXBKj0QTJP4xrMYwxrSQ3pE9HlNwB9RNhaWVebatriFnlYFM4Kbm2vdq0NXxy/Ca3aqeyB2uXQFKoD+XKNduq8BQ9pQGWN0CIJcZEySTxDa8PogxHuE2VYmdBxu6+XlE63NHUrlW2OPKMu5KUlgakX57eqpgHxveBSiy8R/VeVkhSN3Rw8HokbZozFZOQSsFlDv5ZbTOGZ140tADJqAk+V37YXvOfSBCG/0DIH9RdJq4k6MLTPl8Z5yE+3DETVued4g8ljDJbk/Y9/2yWzGjKVMaEiB4sgvP9Tk+P0xSvAmJ5v9ZaLKGmiYXnGkmo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(110136005)(52116002)(478600001)(956004)(54906003)(4326008)(8936002)(16526019)(107886003)(2616005)(186003)(6486002)(316002)(8676002)(15650500001)(83380400001)(6506007)(6512007)(86362001)(1076003)(5660300002)(26005)(66946007)(66476007)(66556008)(2906002)(36756003)(6666004)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WXNHoUe2hHLls027BO09STNQyIQNTJBiRdQmjgtAkUfL+p9kEhu/pKGmI1HMLVa1csprvA0iUxyPvt4/P+OqImwosWxcMNiYB2BZD5PbBn6cgJVPi4bAzhtjjRy7T0qCAesFs7y4c5NQYQPx/b0vMI813CKn7lx+PsHIMHAYR1ZfsDpMZ6BmdMmM9MKXpxKVOVFPOhPP+YqU1Nu66cH298kckPglPo52Kc5kx/GuaMqQnmnuaCjCBvPH1sUt1a9OQo5kxhTDtsnVDmD/S17yF157GDseUHZQtqx8iU6VaDVCVVWdeA4LBQT/IMiAUmgulw5ellg6GkU6mC4Sar6Gdq5swn7OB4lBoU4DkL94hshSme6+j/GeX6NW96XP1SFZFl+R/7XUrVUf1+yztUfB097lOoeCbTwLdqJ3E4faCoZ2KByJy42eCIE+RPtp6N/VhXcF/gXcpfHRV4qpcGK6nP1wOZVOdSwzY4i1ZbqkAmQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 789e4c8f-23da-423f-f905-08d832d63368
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:11:24.2827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yNbajUm/k19dIcbRjN6VxxHLHh6TRimTV709sM4MyGAVeUO2O1DbWvyz+yu8Ca4QLz59kVsJyrCD2VJ+14VtVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

Fix a bug where driver did not verify Hardware pin capabilities for
PTP functions.

Fixes: ee7f12205abc ("net/mlx5e: Implement 1PPS support")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/lib/clock.c   | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index c6967e1a560b7..284806e331bd8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -408,10 +408,31 @@ static int mlx5_ptp_enable(struct ptp_clock_info *ptp,
 	return 0;
 }
 
+enum {
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN = BIT(0),
+	MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT = BIT(1),
+};
+
 static int mlx5_ptp_verify(struct ptp_clock_info *ptp, unsigned int pin,
 			   enum ptp_pin_function func, unsigned int chan)
 {
-	return (func == PTP_PF_PHYSYNC) ? -EOPNOTSUPP : 0;
+	struct mlx5_clock *clock = container_of(ptp, struct mlx5_clock,
+						ptp_info);
+
+	switch (func) {
+	case PTP_PF_NONE:
+		return 0;
+	case PTP_PF_EXTTS:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_IN);
+	case PTP_PF_PEROUT:
+		return !(clock->pps_info.pin_caps[pin] &
+			 MLX5_MTPPS_REG_CAP_PIN_X_MODE_SUPPORT_PPS_OUT);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	return -EOPNOTSUPP;
 }
 
 static const struct ptp_clock_info mlx5_ptp_clock_info = {
-- 
2.26.2

