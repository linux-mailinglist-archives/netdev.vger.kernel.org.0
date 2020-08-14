Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4D5244A3B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 15:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbgHNNQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 09:16:54 -0400
Received: from mail-eopbgr00073.outbound.protection.outlook.com ([40.107.0.73]:30530
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726139AbgHNNQu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Aug 2020 09:16:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBu2V8DhLlwK0qkfaFlm77psjHlGrBK+WxmdNhpDMv1zsRFWVx+a2xN2ieFCVpWF635TEF8Ijr03FMSp0QODdX0ye3tBrl6oJaS69X6+IgDZjZIvGqzMa/T9HUUZBZQLIJOesn355JN1AjODsJX4erkNosF/+k1pk7UChWwl77n9naMwETqF3uieNdjYX1e9+Jes4+HwlagzJjzQifPaM2cVBMvHEoPKTvdAl5nkYeSoVNdAJk04r2iYr6yR6F+ab8S40vLtzhmbUuHv9HEaxFPuq8mV0SVjSvL69pL9znXF7i4Tmd8Bsmc8Emx2BVWXVYTzed+1qF/BKMg9Zcb/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5muxr6tf9lVTO+b4NqYASyK5oPldM8sc401berV73E=;
 b=mVy/kUQjcLWhcScDcopiHbW5/IHJvsyb5Rm0Puz9zQ5nOuTkEeRd6jc6sIJO1SL+H0cQ19WbBgiGUXs2veQFxCl+TvoMov6500jJp3JhTfwfCN67853vi1GBcg4W26jSYy0Y9KmZv7DxOL5kipBHfjM9qJvU6NiZbGupyH7m2zGUi0sU5uNMqqb26VmyBbFn/Lz+JhNJflkFiFB4r4wdYI1n09Bowc8msmDQ/OmDm4CnvrlhczJxEyvrPs+5J4jQkBpYN2LZgx/ov7vDeF9P9lKTf7kA7t26XwecFz9rES5Cl8hlpYpHA+CK7Gy/5LmDNY3nMUE5o3iCqMeBo/Vi+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v5muxr6tf9lVTO+b4NqYASyK5oPldM8sc401berV73E=;
 b=euImF7Y3+AGdhzJdCe3SDBuVhlikLRVRG58yCvopFmcSOlJp48Xid19E1Hl/sAv1JY9dX3igMSuo0Cxg7D1hJGHqSNi7HJw1u1HEux+Fui5Ow+UY0a+++RI3Oq0tL7rtXvz28qsb4Jn6aAOh/sot0Q3/zzJsHH59ztWT58kvf70=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR0502MB3605.eurprd05.prod.outlook.com (2603:10a6:209:7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Fri, 14 Aug
 2020 13:16:40 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.016; Fri, 14 Aug 2020
 13:16:40 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net 2/3] ethtool: Account for hw_features in netlink interface
Date:   Fri, 14 Aug 2020 16:16:26 +0300
Message-Id: <20200814131627.32021-3-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200814131627.32021-1-maximmi@mellanox.com>
References: <20200814131627.32021-1-maximmi@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0121.eurprd04.prod.outlook.com
 (2603:10a6:208:55::26) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0121.eurprd04.prod.outlook.com (2603:10a6:208:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.16 via Frontend Transport; Fri, 14 Aug 2020 13:16:40 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9da5de8a-8746-4c1d-691a-08d840544833
X-MS-TrafficTypeDiagnostic: AM6PR0502MB3605:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0502MB36058DB7544CF9AE3C5E5DE5D1400@AM6PR0502MB3605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rch9nABeEmcYifrjpUHfzukuRKtVBsb/PZtRs+aXel8+Ks5tGzYd46Nsr2gQb259K9BvuIoXIYXO6di7VacHstbjSnnJtVlGVR+PEKHBweB6dnYTjDY8BxXWp8JSslpQsrwDYr+73HirP0ezZhWA5cblWI3G3ppovfJ14+ao30goaYa9Q16lehNG98fTwSFXW8ODTHPDqqT35GgXa26REz4ELhYetRqqPUn8awALv8llz+vb2O58dmZOsDitE9yS4c89+HGU74G5NMbAvX9wBqZ5sHMW9JJXJc8kyndL1CyucQ9DpblDcPc/A8c7la2w2069Ly1MUrSunGj/b4M8Vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(396003)(376002)(346002)(366004)(6512007)(16526019)(8936002)(186003)(6666004)(6506007)(36756003)(83380400001)(1076003)(26005)(107886003)(110136005)(66946007)(316002)(54906003)(66476007)(66556008)(8676002)(956004)(2616005)(2906002)(478600001)(5660300002)(86362001)(52116002)(4326008)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 59vmrne9XREQTYATdCiTzU09cmY+Vf/hzUlCVnxZO5piBouPa2Dd+BBDSMYgqU3f9bZUGqxfoS3P+v1z2EF5jUagH3/XpR/27k5cVG/9nAIK5S1HL0NaOsnFzuNDg3eZ4vroDNoVAj9FDHdeuQP33zipmeDt+IUExrummhak7sd7sFATfw4gt80I1qADHgtcbqGOS3gWHD9wA2L46ii9yslNagVsj/x3v+4dv797CAp5h+oMldsd9D+oiF1UZQfn6X545cJoPNd3jgHReJrh4zTd+TdDVkN9ZJGX4/8am43egQGvKWWWBNv0od95KnYq9iW2X5rH39Q9WDBm7hV+3BnrlW4wPt40J1GMI7okUNh8uqtrsuLHxryCYhZZbofH0gaXSWXCLtym386+BtNH8JlshvqkzI8ex7qt+TuW0WLKHHzn/5UC3rmc+KU3Xcl86cyFbcavA8IwydZevEouqs4ZU7YJ8e/JRFX5GLfomekHe7UemBTv6BhqZh9fSgkCxGE510Qgj4g5iSLVLt4PAEjrleSTp747jtbM+uADCuEs/4rsevpv+lplTPAztWsuqs3p/jhrGXr8GTTRq0vYajf8jg4K1dFkXPPDE5C+GsqndAnmk7vuClhqIb3tAdIXWxe/nY6uZ5SdCIT5NCk3mA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9da5de8a-8746-4c1d-691a-08d840544833
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Aug 2020 13:16:40.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e3qO1CNL8QoYiAIeQjgIXq8RYc39tflfChrZ4NfM17tEX5tLSrFY+rguNMtNvDT50GOg2z4rSJmf40DZuoF4fg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0502MB3605
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
2.21.0

