Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D5212436
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbgGBNLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:11:34 -0400
Received: from mail-eopbgr70077.outbound.protection.outlook.com ([40.107.7.77]:58262
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729055AbgGBNLd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 09:11:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gi8mHHn5teLaUI45mw4nF5lT3sa2RzBRTbFl9cmKm5IMuT7nxDul6xusCX/l2e0cpWqOvxpZO94uu8LI5o4Srxac+r/g1Lx/6F0eSlBEyODRAO3+P4d7aKm3NEHVtvTC7H/YlTQQtYpZF7CWM5dv2FpoSekEq24i1OWgbWTq6nHFCFHijChIZm23qw3AVLh9DE027CZh4Bq01XSfMjWRJ97QpVcn8Erh8RpnMc8lPa+PVwmE4tNwBrbMacSkqKSMwcrbLphuCO2cXWQVleTt5oWJQrvdO1EXCPipm5pfGMuUXhEw12p10T5vzfDBDWkJJfwCQE1idl96//FpZ5G+aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nboRu0mxatdZXZANZyvIGgWGMcgtnwoYpojAt9AvyYw=;
 b=RwJJ+lhu7YHFofJL8gf1izA33RrLQN/qoBGTCqgJPeZ/xMeODAa6VxSvxrOEHOUGdhVInmfu4JNfbWWs6jO1riB7HTkQ9Dz2Wi2WAPDzZqHlklQZDe86o7bg7GdBqkAbA9cRI3kGZEYEL7l+y00cZEWpj0bpNZgjitPPJ2vDqEZZXU3YPBa8L307yXfuIf68vJav88/g9dJ2bMIa0A1GDi7OAMz8s0fKqDmKYUklHbO7aLJ2IaGx+NHKiR++0dBUomtEqEzhdkr9nkqwZUgqQHwi4SXM/bYuRyLpw6V1nwxSoPT1BLy+Xq7WgUBUy7ZRJwelKlAhbFS3lNSN+Kjlbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nboRu0mxatdZXZANZyvIGgWGMcgtnwoYpojAt9AvyYw=;
 b=OqtmnMNOzpWZJNRwyG98vGKpnl+firI1oXRRCYpjgbdmkkRGAqoAMF1P1PGuIibslSBBEU4Ba9nz5W6vw+XRNeuRxM8Xdumn1hVAOaH0Fjn5BVJCRoGQxv+S+HqoI5eY8ALHozBEkh+MFBn4KOXtKubSheVYCvsxs2bJk0UTr6M=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com (2603:10a6:7:83::17)
 by HE1PR05MB3353.eurprd05.prod.outlook.com (2603:10a6:7:2f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Thu, 2 Jul
 2020 13:11:28 +0000
Received: from HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2]) by HE1PR0502MB3834.eurprd05.prod.outlook.com
 ([fe80::7c6f:47a:35a4:ffa2%5]) with mapi id 15.20.3153.021; Thu, 2 Jul 2020
 13:11:28 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, o.rempel@pengutronix.de, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com, mlxsw@mellanox.com,
        Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool v2 0/3] Add extended link state
Date:   Thu,  2 Jul 2020 16:11:08 +0300
Message-Id: <20200702131111.23105-1-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0117.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::22) To HE1PR0502MB3834.eurprd05.prod.outlook.com
 (2603:10a6:7:83::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR01CA0117.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 13:11:26 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 67a450a1-3cd6-4c2c-99dc-08d81e896e51
X-MS-TrafficTypeDiagnostic: HE1PR05MB3353:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB335315EE4D9983BA6E8368B8D76D0@HE1PR05MB3353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iWj606e1NOTVhkGud17BjM1KCPbCyD5/r2U/t9BFjSbMnK6aJ/MZK7TKvfs1zLcdemFFkr2KGxryYzFw1THnK0T4RjV76rxu+xylkB3IHwm+r1VNDcnfKIwQw7HN/pssNTRIrauK+lmK6MjHYI+ZEvVHHHrHI3oepkTmjm+twPhRzpFW0SY69P+ozim3sFsnTBbLGa7XuE9UtwERuQPLzC+TzdSVp95ALTtxvn66W3OkH3H5Bup6Ss9QlxWSUNxD0mAm92A35YrL+19comK6ob3MVjUKwoDomyPY2t6h6dplMhm8rZr+rwN7e6qxCZc3yhU3zL+tptknchu4CU9Qwg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0502MB3834.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(396003)(376002)(136003)(52116002)(8936002)(66946007)(5660300002)(6486002)(4326008)(478600001)(2616005)(186003)(316002)(6916009)(66556008)(66476007)(16526019)(107886003)(956004)(1076003)(36756003)(6666004)(83380400001)(26005)(6512007)(8676002)(6506007)(86362001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: DRTK+vB3HLj0gqtpi3EA0O5QRm1Tz26sE59xYArq+MLlsFWGi86cxu1nk5B+qFSDOg30H3Z/FkdpHnnHCohecagDO9LSQDm42qXnzJfmyqGawIZLtXcofsYexr60xEYzo70ng2raXVI9WDokwhLaMnMmYRWqjHUqNEQ3ywS7AHRgUfZMc7PTVKLAuTcWzBVGcmPKR1tYOPfCIC8dY5mRuy0kVd/h+wNhcHFhe1gyGgvy7pt/+ywz6NovcNUoxXVegSbdfwmyzCQHZm9McRatoi8eqFTXzN575iSLfQ95Yfb0wjeY1PsH5mDR3UXT9j/UZzirQtebarhiq/OHxc3CEhXgjrwMsH8SB+hSHp6pAB8Ht0sicALRVh2zTrcKOKyMlhAQrqjLOLW78aVakKXFsPO8p3qlDc11b9/A8ZSjxfa8u6aBGOGQQqQtXDt4zH18/f+Ci2fjoBT1YsfROwq5gD1TMNv38/XmqgUNkfDAPA4jhKE8H7NZHgwU13chgvd0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67a450a1-3cd6-4c2c-99dc-08d81e896e51
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0502MB3834.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 13:11:28.5708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XZXksrs/IQqg6XrlDhn2M1J5sq/wleYiM0FLEOAl0EK1omLD+0vnDaLSQvQFD1viEKpxRw47v6GMG4iEalmyqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, device drivers can only indicate to user space if the network
link is up or down, without additional information.

This patch set expand link-state to allow these drivers to expose more
information to user space about the link state. The information can save
users' time when trying to understand why a link is not operationally up,
for example.

The above is achieved by extending the existing ethtool LINKSTATE_GET
command with attributes that carry the extended state.

For example, no link due to missing cable:

$ ethtool ethX
...
Link detected: no (No cable)

Beside the general extended state, drivers can pass additional
information about the link state using the sub-state field. For example:

$ ethtool ethX
...
Link detected: no (Autoneg, No partner detected)

Changes since v1:

* Do not mix uapi header updates with other changes
* Update header files in uapi/ to a net-next snapshot
* Move helper functions from common.c to netlink/settings.c
* Use string tables for enum strings
* Report the numeric value in case of unknown value
* Use banner once, change print concept

Amit Cohen (3):
  uapi: linux: update kernel UAPI header files
  netlink: desc-ethtool.c: Add descriptions of extended state attributes
  netlink: settings: expand linkstate_reply_cb() to support link
    extended state

 netlink/desc-ethtool.c       |   2 +
 netlink/settings.c           | 147 ++++++++++++++++++++++++++++++++++-
 uapi/linux/ethtool.h         |  70 +++++++++++++++++
 uapi/linux/ethtool_netlink.h |   2 +
 4 files changed, 220 insertions(+), 1 deletion(-)

-- 
2.20.1

