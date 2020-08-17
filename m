Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14793246769
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbgHQNe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:34:27 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:61358
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728537AbgHQNeU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 09:34:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1UPYOPcULgf3CrNSDJhMWQ44JZs4aUTiJXRsku2uaEV5PaqZjuJ8BDy7eJxLkJZqj9hOIks+cKPIEP8HxZbOXwlkfRG7eSQfHHiKAIV2JrnTpBmh9kmQNd8vL3ZQQXeyM54LXgTorPK2CgpJcvrrRr9KZefBe/boNlo9FhCMZIqodJXlk4IA37oTbX2XZaYqaqJHve8bL9SPCiXEVak+9dxDOFpNeEwIG4hKvdpQkjYVpFFEWxqM0PsVTHdSwqdZKzF19RPRNbgebmfEwZF1MSSxKRybteKzJadzW1i15Fa3g5n2Wv3GtmuForTskp3totNdzE9gCOxAZ+8L3pr0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7VI6IwJE5xjOhwc9O++mPGxUV5s8bTk628Ahdid5SQ=;
 b=h+qCPIQg7omvr3h/gJaImOlASWHLx02s80YXqOCQdsoXa2xDIdITxYu69o/yGV55xD+FbOOLYHdeRG3QHX5kN1PXmxssl59qFGjvpeq7ySHyCkrzUi2yCkM/QH04dLkQ1NyFRNV6wh0HlQYLVHc7VMHbl/YKa+0Yh7bbZCuV/LYrFTr53k3A5kqlbLqBA4/BgXLNmG0/frNMcavLpcax5BXoOcgkgokRwuVkdvAmr/MSO+G4U5SbtPqP6RvsV5Mw3gXizwzb/32ZbhP3IoCw7M692tuYJVEPvhKQBUDZhPk+qJKszvWNRgHO5L5Bm7Th/fwJpLzm/ETV+j4qVpZEFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A7VI6IwJE5xjOhwc9O++mPGxUV5s8bTk628Ahdid5SQ=;
 b=GJPC2TEO4CpKhLchNa7b2H1bg4OlbAS9qvloklt6D+lHs1UDR0elspvAnnrohUJj9Tb/68wf3r8AEc/jx0yPV/w/E7kh6DtRlneDZR3rDNLR1Ag/XB9eNZAVkj0Nl85yU/qcGJcmIRtQdpg4lAKamy7CPVmd7jY/xuRtgfJyVg8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5640.eurprd05.prod.outlook.com (2603:10a6:20b:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 13:34:01 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.028; Mon, 17 Aug 2020
 13:34:01 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2 3/3] ethtool: Don't omit the netlink reply if no features were changed
Date:   Mon, 17 Aug 2020 16:34:07 +0300
Message-Id: <20200817133407.22687-4-maximmi@mellanox.com>
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
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0069.eurprd04.prod.outlook.com (2603:10a6:208:1::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 13:34:00 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7129759d-70d4-42f9-7077-08d842b233b0
X-MS-TrafficTypeDiagnostic: AM6PR05MB5640:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5640EE87E74B34CFDDFB3A4ED15F0@AM6PR05MB5640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vhm9vq5A/Haz2xoi2aINTI6uP9NIpg4BGyLa9cAZZ2XA5zKplaTIrL7aNUseANW4yNxUWZrCJRvNn5/Ng847EOF3uSyntXd13y7B2FwxdSQ012ogOOU3aqhPDTrYxVOXYufUsW+ztwDyALxXh9D/SMxxxtBBM0ww0F0gqAne49vaS4U751H1o28GqBjP3Bn3uQiFo5ZphcqLNoAyLiSq3R29x+WYiwumxSgpHAV7lR0O3105dwhYlyVwyH9BDpnAsfa9SlZwxmLKW14R6BuZfofX7bx9TZiuOkpLRtQcknOeDDWi+AsFOpWIZaNjvRNb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(107886003)(66476007)(66556008)(66946007)(8676002)(8936002)(52116002)(478600001)(956004)(2616005)(26005)(110136005)(6506007)(86362001)(316002)(6486002)(186003)(36756003)(83380400001)(6512007)(2906002)(4326008)(1076003)(16526019)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: WY3FCWdOYt6DlvVkfcvIY+s/PeOfBE6xJqvjSrfSxsEcrd62h9gSng0rl+RE6BSPQ9I4x4+oAWmlFZMV4ATpMENmslDheDuQBW2+D7fudNQCd26FBweCnligl2/ZWhGN3V9eHJBU+ve2JgytQRXBT4LPdOsbJOsyxB6pZ63q8eb0IGNjm+VV5jiUe9d/2BTyCACG/IekdaOq0H9pmBz95DXsh0VY60G9+BIhkVehON9MnRCI9kl97/j7CSppv0g8DngTT+d2EWQx5fI6shgmBFwFyjGSdFfvy9Ce4o2lV/8bBVgMFfxTES9Q1ax7IbUuMoLAAxJtCzv+rkxXSptQVyZkc0oitj3A6NaGbQhKjKntjRFa/A9GPGC+dlJaXKPO7Mieb/NAVQ9EoNuf6RCzzrIPAw7T8TwBK7/6BuTT7LPFfx+Aj1nQCcmRAdEJlEN1xgfHG2CgF3tL6tEhVLE7AyPS3tIJ5AXU/v/csLdh8cP7FlepPJ//0aU78ps9HiUMNoQJhMuAAQDV2Lo82vanOXaT+h2IKI1gEcUQymJn8Tvl2jtjiRtE4XfVLvVea406vZEV0BXvjX8AarBBuY21gY2tYxeTjPi+d3EmjHgtc38mEuAef6A6fkq6WQqT7OwmQ9D+J2wUVHtAo6+uJXQVUA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7129759d-70d4-42f9-7077-08d842b233b0
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 13:34:01.3667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Gd95sN5YdzgHaENCO7XNjPliKOKfJ0rIpOsUNB/Pt+rFZOY7qf7WVWkOmMRmj+ZpTQLDL2dokJHOQpLQOGdsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The legacy ethtool userspace tool shows an error when no features could
be changed. It's useful to have a netlink reply to be able to show this
error when __netdev_update_features wasn't called, for example:

1. ethtool -k eth0
   large-receive-offload: off
2. ethtool -K eth0 rx-fcs on
3. ethtool -K eth0 lro on
   Could not change any device features
   rx-lro: off [requested on]
4. ethtool -K eth0 lro on
   # The output should be the same, but without this patch the kernel
   # doesn't send the reply, and ethtool is unable to detect the error.

This commit makes ethtool-netlink always return a reply when requested,
and it still avoids unnecessary calls to __netdev_update_features if the
wanted features haven't changed.

Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
---
 net/ethtool/features.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 6b288bfd7678..495635f152ba 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -268,14 +268,11 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_and(req_wanted, req_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
-	if (bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		ret = 0;
-		goto out_rtnl;
+	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
+		dev->wanted_features &= ~dev->hw_features;
+		dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		__netdev_update_features(dev);
 	}
-
-	dev->wanted_features &= ~dev->hw_features;
-	dev->wanted_features |= ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
-	__netdev_update_features(dev);
 	ethnl_features_to_bitmap(new_active, dev->features);
 	mod = !bitmap_equal(old_active, new_active, NETDEV_FEATURE_COUNT);
 
-- 
2.25.1

