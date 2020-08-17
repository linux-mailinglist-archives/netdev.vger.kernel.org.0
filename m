Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC40246767
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728646AbgHQNeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:34:18 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:61358
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728349AbgHQNeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 09:34:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=farkBwXVZI0SDFO/rKF74lmDK0Xs/mRLwEs1OrWnIAF/lNLi7PrsWdlKFYIlIjPWow6eBmo+HoPB8y2fIdo94Nye066b44VdZMrKrJ/CFijDcNUU4Blct55N8FalzZhCvKeaQ2qdhhkW61fjj7530JETquAirTVfsfuV0/aHjnwet2j43kMIay+DrxEkLB61EQQAhBH1reGRxYyYoUBifZ8QR6KsPUxHFLh7S/RhJ/BSB9NHKqS1eumwpetcCdN55lhGUXL7+JFoipfZ8y3h5sKfpZ1qLpicIYRFuuzmGqjk5YyDH/03ioyBg1Qm0R9kfYwNRGZ0XLpYqcloPsNlzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AF/dMtSImOnlPDtvtQ50rEoaiXGpb8YM6NP6PqPMtoQ=;
 b=n5h4bminGpwtEPjjj+K9NUBdeRvYIGDLqxsp6GgeNcm8O2f2E+eE7T/gAldJw3WgtNB30ztT8MV4h7OxnAwGndlEtM53L1mTOJwHUNxcmLCGnNwgsPY7W2qac49I2RzyzdzM/kos7qekafShat0Lc6TPiKj0MbaAxWLr7kJuz8kuhQaUPPi+sSZP8SV8Wv4hk5b/YGABemADlDvwApJmicq4Wht+2oqYtBgbb56eafE7gtZ8Uc+PGghoskGPEBuxN1L1KKa7u5Qk1oGCHh05TY3DDFQxzyTvTVDwb3QweIiZEsEZm7VOWDWvpR3GYuaKYJf+LjtfpJ8T15niZkwCwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AF/dMtSImOnlPDtvtQ50rEoaiXGpb8YM6NP6PqPMtoQ=;
 b=W4QkMvso34zfDoMZXN9zFztxY9wqpW2tu7UUTSv5+3mKVxa7KgtkMrR0EsSYNDDGqcnqP19Y/ROnmGekikeEeTZQXjcmZ2tV4xYaa0GfgPQi+2BAQQoHEbxmY9a/zynM0VF+vy1EgD/yG7y/hZFMQMrUYUOaY9xhgsQk9jiRYYs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5640.eurprd05.prod.outlook.com (2603:10a6:20b:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 13:34:00 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.028; Mon, 17 Aug 2020
 13:34:00 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2 2/3] ethtool: Account for hw_features in netlink interface
Date:   Mon, 17 Aug 2020 16:34:06 +0300
Message-Id: <20200817133407.22687-3-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200817133407.22687-1-maximmi@mellanox.com>
References: <20200817133407.22687-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0069.eurprd04.prod.outlook.com (2603:10a6:208:1::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 13:33:59 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 548b75f3-0be9-4b20-a094-08d842b232ec
X-MS-TrafficTypeDiagnostic: AM6PR05MB5640:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5640896BE35F64801699C354D15F0@AM6PR05MB5640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZztlVQ4frtMNn/EdSQLTzcPymuchqdIvyMSeX5/33xt+9Ytj4m2iGHKDK1Rj9tZP2Ge4KFEM2vsOa4KxRSqXAFWOSIulppnOm8KWXTmSBZW6bTzfLGPK2B7yM0Lr/rk8V3aeGV13kwTaFD8Ov2TwjC02Ei1G+k9qcwJUcNRTMpcA1S9b33NWg6tP36V308Kxn8sMRRwkNbCMtONRcdoCXt/zUkdiREwQ4xJkVUPKJp+z+eEsDCocGnnS5O9Ycpe1+IuPVib7ditipscg/HDPZBGwBbAKnfqlsvz5g3P3bihboNQGQbByEuaIqXJ6qVb4X+wn436UhX4ZAnFYg6r7ng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(107886003)(66476007)(66556008)(66946007)(6666004)(8676002)(8936002)(52116002)(478600001)(956004)(2616005)(26005)(110136005)(6506007)(86362001)(316002)(6486002)(186003)(36756003)(83380400001)(6512007)(2906002)(4326008)(1076003)(16526019)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aSy1TCyagDASCFMYM7dpx32g1Xro6JZjUqPZBaHgjL7B6tLxYz2vgJczfMfDT63IkKR3y1o92KDwPe5XIDIcvhUcNgYygUW8qrCcGAOdaD71/EIjn6sDlzzvlvP7GUnbh4D8FxZPyQ67dl82RHqoHt4Oz9uHiNremKDet1cCcZLuv5boOT0AXoWxE0D3++M3fEy6b0oe45jIds3PuszHZvUC9vK5MM4IBp/ZNPQtXhTOJusQ6etJp9/bvQZfHN61p7I+RM85lGhbiov385ecKrfJejvI81dcO+QVdiLvbEpMhoounRiUm6BX3AXmf0aLEqDitT93yz0WZphhNZqSIMAOKLD21HMRF/YoIaMBLiTjJcpLsUEG9o0D7HqcnGdjBsbBcuBf4KY6aelEd9sOWeSd5Z63/i1Db5w9sI8DsQnCYcDLbKRj6QZQQMBug/JZvCPWr6WHL1ZoCyv2l90FGlttdtT8d4gaiTsLDz+bqQxZXxywPp4NupySuwlmqdxG9afHCspAcyQJZTbyMviJbpizgHxYknuFNv34/aQ2/Yp7PR0FR32bmt1qw7yJvgytQyWUWwJ1SD3N3nvBZSiMIDkmOdPakmhipdP1swWjP1zK5eR4EZ8nC9L8JAx22ulHdx4yFg7ycnwDd2QNp9heug==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 548b75f3-0be9-4b20-a094-08d842b232ec
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 13:34:00.1064
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1XvcvKA3v6x20SPHBVLg/6MbqfVK6Xi+9ruPHT51hd1e7AzcL2qe5lbSD0cNuPvooFAW+ZJz64s8N/i2dBP9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ethtool-netlink ignores dev->hw_features and may confuse the drivers by
asking them to enable features not in the hw_features bitmask. For
example:

1. ethtool -k eth0
   tls-hw-tx-offload: off [fixed]
2. ethtool -K eth0 tls-hw-tx-offload on
   tls-hw-tx-offload: on
3. ethtool -k eth0
   tls-hw-tx-offload: on [fixed]

Fitler out dev->hw_features from req_wanted to fix it and to resemble
the legacy ethtool behavior.

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/ethtool/features.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index ec196f0fddc9..6b288bfd7678 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -273,7 +273,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 		goto out_rtnl;
 	}
 
-	dev->wanted_features = ethnl_bitmap_to_features(req_wanted);
+	dev->wanted_features &= ~dev->hw_features;
+	dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 	__netdev_update_features(dev);
 	ethnl_features_to_bitmap(new_active, dev->features);
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
-- 
2.25.1

