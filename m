Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E6E20F183
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 11:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731902AbgF3JYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 05:24:42 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:21154
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbgF3JYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jun 2020 05:24:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3hZpwnxTL+yihq1Sv8HjvvVAaa/dYNTn+ehN+Pb8nbAHq35/BEaAbjWmRHaoEImyhafKyo12IYwR20N9G8Gxa15gO/0iTqhgKEvZ7tupY6Vmd6zqZy05RCGPkpk1Ufoi2hbjzf8ngmyV3tVGSDk9EYKHBjSsIBFpWOPIFUjXdM3uC+dKSInV4mvCSDBkWejBUpwqh/s+HhYATDrgfC3ZfzWdcVa/4q7F8xrE91Bd8iyPJXuebHgtAbjN6KbkmCVCw0oHn6kwwEU8GMNEBu4xvP2B4GPAwcE2PwUsm8RLWVJspU5CwTEzZ3W7Fy+EB2/6MBFYR6fHTcRBnsg6lxeMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hd4UfzDkO8UEgpBon4xguzEYb/6b2h9e4KkQ3mjoefA=;
 b=I7owQaB46guxhWp89L0KjpYwg0JNNQmaNdaPf7uZ3GMmDedSYEtAqIt/OGYKlDoPVAHNNln7jYjMWwbmfJiLD/WuDR4GUyl/cx3DKuVSzqtBmZUBUNpuXmRrv5UheMavIQ/ABi8lLzptWsb3HJvFAOnScEiM+ZY8Kj3dwNTbs5KEW3GIhMrMILXtjk5m1TjxTyUjwnXLccdhc2oSUVQzhq6fONxnquPpmdCM7pq9kX4huwpLgkuG3s0zvGk5NxcHaAAPFxuaPQc4f4yHfy+Eu8v85hWRM2kJW/p/2whWSASNI2dqEgtNrV7zlSsSSpHHJDpg61D8xxqGvGyod/uAKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hd4UfzDkO8UEgpBon4xguzEYb/6b2h9e4KkQ3mjoefA=;
 b=r+yWBqLHXD06w2UmBu+A+CQNIZXJViClk2Ysjhf93vxnoYKJPlXiGP2KkZQpOVYNronqQ9umhveB+XK+Cdfpp6ZaCbrgFXzKXgv+CN6Xy9kA+Q7Xb2JUj6RksXQW8R5Aj2/GMZ9ahZmFwlRRJUIbhhJceQM2qprSc64+6giezsE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR05MB4450.eurprd05.prod.outlook.com
 (2603:10a6:208:61::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Tue, 30 Jun
 2020 09:24:37 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2534:ddc7:1744:fea9%7]) with mapi id 15.20.3131.027; Tue, 30 Jun 2020
 09:24:37 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, davem@davemloft.net, o.rempel@pengutronix.de,
        andrew@lunn.ch, f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mlxsw@mellanox.com, Amit Cohen <amitc@mellanox.com>
Subject: [PATCH ethtool 0/3] Add extended link state
Date:   Tue, 30 Jun 2020 12:24:09 +0300
Message-Id: <20200630092412.11432-1-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21)
 To AM0PR0502MB3826.eurprd05.prod.outlook.com (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR03CA0044.eurprd03.prod.outlook.com (2603:10a6:208::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 30 Jun 2020 09:24:35 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8783b729-0d4b-4bcf-cf4b-08d81cd7685d
X-MS-TrafficTypeDiagnostic: AM0PR05MB4450:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB445097B6D45FB7ABB7C0A6D1D76F0@AM0PR05MB4450.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0450A714CB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVZAnJExzqxcqq1GKMoDmPAtECnOgB8zWrAWw8m2CgoKaptFLhEn0RHPhxIrmKqSikdMwTslV+qJrjSwNaa25hsGYy9bir+bVScH0zzwjcFv4jo6bXNA1RdeHYOPdBXentpxCdhbN39J0bna7m9va4mvNtsm3fU6wPABfhX8CCC9UavByUYpFo/YP4hCHVio+fgPzbaWFqiB1IicoWbpL5m9s/dSfOuG4ZAPdTiVnfboVnulafDlIoA1sh6+AyZN5FXoJOePtrpjAumK6ylA8KnxbaRU3/oF4nGMku3VPEEqmHzlrUqJVwyeaPEB/FiCau3+438/J+2qccIq4YaJMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(52116002)(478600001)(2616005)(956004)(4326008)(2906002)(5660300002)(8936002)(316002)(6512007)(6916009)(66476007)(66556008)(8676002)(66946007)(6666004)(107886003)(86362001)(26005)(6506007)(186003)(83380400001)(36756003)(6486002)(1076003)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: i1g5L1tYZR1P1k8wvY9LxqOUQnfaYiZIaWJO/0YwdH5tjynMHUuDud0K3AOM/YTIaYxpTQ8VZDS8OUPPagYjiXh/DH02cZ5ZBgkLz1hfeOtuIt2SIQsjj3ZR9b+5+7okAyvvVx5G4juOD1G2ME75l3/0t8bRHVE4nUPbrVvo4iv4SPaNDeGavh0vTSGsW/OfWeS6sBF/aowO+TnbeJT4rHcBpZUpVoJ0LRpQzBuywaD6muCPo/Wq/Kqoj7SJjddmi9wV9m6764CYU/JXTMWark4wIHW9/SPjfXLdRoOhDWoVYFCxbNQD7kNGBepswaWCWjQOVW1p8ii7AbxnTg1OA2Fg4C7NzltM1OuBK90f0IXyrR6UFWzrwq7FCRPCmQdNoHqO10fsucfkzkWkDSNo7P2dHI+Tk7zIZDsZv7r4SIlpFIIZG8lDkJaYDrBq7tYbVt6blYbfgAyHNJpbnoFUV84kPlybKrcQMCyLGAdo/S8=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8783b729-0d4b-4bcf-cf4b-08d81cd7685d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR0502MB3826.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2020 09:24:36.9668
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8rmUeLht8K3gzPprTv/lG5kT5TpeeUTXPjmnJnJjIxhPipLWJ5sEnxsiILaw8KHfXYfVoYcnYM4kJV7vVWV7A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4450
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

Amit Cohen (3):
  netlink: expand ETHTOOL_LINKSTATE with extended state attributes
  common: add infrastructure to convert kernel values to userspace
    strings
  netlink: settings: expand linkstate_reply_cb() to support link
    extended state

 common.c                     | 171 +++++++++++++++++++++++++++++++++++
 common.h                     |   2 +
 netlink/desc-ethtool.c       |   2 +
 netlink/settings.c           |  59 +++++++++++-
 uapi/linux/ethtool_netlink.h |   2 +
 5 files changed, 233 insertions(+), 3 deletions(-)

-- 
2.20.1

