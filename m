Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D56246765
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgHQNeH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 09:34:07 -0400
Received: from mail-eopbgr50060.outbound.protection.outlook.com ([40.107.5.60]:61358
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728349AbgHQNeA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 09:34:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DhHhHSfoxNmiaKISiS2MetWYhch3Fa5COpwDs7wygOrcU3SwgIKq2rMHFI0OXdUbf/y/apqpE3iAIDaZCSns1vTT37U+RALnw6sIVV1ecSddKzywrL/pJ2rCcscmxHYMyWZdW706PucI1XMPB5fwzUsD0HF4aLNBOM6A7FcPHrOCtWEXTVH0mOzCQ9LT2utCJcYMWmQMSL2iKmvZIELq+d/5E9cT32onGABsPVWFbAZElzVZw86vaS5LW811J5LtApX9jD5iHRoQvuIUJ3npKJFzYvWS+JiVx1KbYRtMc+kVHm6qJzXNVy8TuXuv7qEasPT/DmXekcaXNL3oQBRKeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZZ5iMjxn6dU5LEo8VAvDcpAUJTMiXUaBkjmwYAqT/8=;
 b=VC603qqLoqBl2H/wzzPGHZrqI3xjwMLXoxlqgPkBTrCY/3lTCB9kDtpitIjJHTxsLq96UW9/B6PTv/bJ6HYfP689mOQ2ne8yQCKflOO/7sM++e1cffY+YFNC8msiJRcwj2xm4RPg7evl79Wg7LL9l9DHoYHl2PTdt4HY+BVBgl1EZ5y/lAY5syEPTNg5N6+fBYaim/7O7t5bsCDD3dxoAXncrApELviHInBIEtXUu1lN/3yyZ55qcX+tlWH8e5VJLr7dS7UrdDEQG459udSlQGX9loJoetvlVXsgaNVgl/igaFPr4spMmhFkcyBn9sBLXf5zAYqc1mFeNM1Gb9J6xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZZ5iMjxn6dU5LEo8VAvDcpAUJTMiXUaBkjmwYAqT/8=;
 b=jnfZIRD9GSEdzC15jS91EXYE/49hV1DrnPAUBH00+AfR4AJsesJztyf0geoTB1oxwfiO8xzGSYeZ+HQtV7nre0O4Y1Hqe0DbNjcJN7+n6T4+d5BasAnonmR16bMjXuBoPHvpqnFz+TMv/NbNNfap02G0wu94qKio4vWHcXKYgII=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com (2603:10a6:20b:a7::12)
 by AM6PR05MB5640.eurprd05.prod.outlook.com (2603:10a6:20b:94::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.18; Mon, 17 Aug
 2020 13:33:58 +0000
Received: from AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71]) by AM6PR05MB5974.eurprd05.prod.outlook.com
 ([fe80::69be:d8:5dcd:cd71%3]) with mapi id 15.20.3283.028; Mon, 17 Aug 2020
 13:33:57 +0000
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>
Subject: [PATCH net v2 0/3] ethtool-netlink bug fixes
Date:   Mon, 17 Aug 2020 16:34:04 +0300
Message-Id: <20200817133407.22687-1-maximmi@mellanox.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR04CA0069.eurprd04.prod.outlook.com
 (2603:10a6:208:1::46) To AM6PR05MB5974.eurprd05.prod.outlook.com
 (2603:10a6:20b:a7::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-l-vrt-208.mtl.labs.mlnx (94.188.199.18) by AM0PR04CA0069.eurprd04.prod.outlook.com (2603:10a6:208:1::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Mon, 17 Aug 2020 13:33:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1fa0b3d3-1a3b-4bba-6d9e-08d842b23160
X-MS-TrafficTypeDiagnostic: AM6PR05MB5640:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5640FDC90F7055D231AE770FD15F0@AM6PR05MB5640.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/3yL4LFS4qOrIuZ7M3l7MYaQLEgK4ETi1eXoXzaTOZ0Ah1myPOB2hohkF6OITCz0L2KIa/jB2hgEOuit7LAHyrRWDd6183p27rBZK+B/EKCAp4dPxVad49DI5XyzTYdWt5o+IbPiaD5pDeRx2pn22+BmlSIw78yjHBHqB5m4C660M/TdTNBFmGSfrXR1S/AVOJqJra+oYnCLcuKgPfw5O0m1F1W8pOcIq/HesESe9b3OjdEBEYl9eoZ8e5k4iBYLE57yLYWlPTBIaA4qS5TglXpOuM2fndVyghBYRCgPheth5aSZz56wYUVR/CzdRSr
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5974.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(346002)(39860400002)(136003)(376002)(107886003)(66476007)(66556008)(66946007)(6666004)(8676002)(8936002)(52116002)(478600001)(956004)(2616005)(4744005)(26005)(110136005)(6506007)(86362001)(316002)(6486002)(186003)(36756003)(83380400001)(6512007)(2906002)(4326008)(1076003)(16526019)(5660300002)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aYutPGqu+kx902BDH3NIgsP1Zu7VRW1rNKWAct+Id3guR2eG29zdM4dKDLrb7FvpjbQSIOBVXoVydHS75xtaUq1mqiDmbNdRzK6HqfT5bdza3Zai+7cU6WH8QTJG5quc/FdIiJFAuS0ALLVl4DrxsHRTgYS10sAmVZUaC5OL7RKhGRSR+NIov7/dOMcKMWmYx5wTXptW744ffjcK73Css8y+zgooWoHoYwpUlM307kJvGCu+gr8pzpeMPvOskXlO9Z17AXkIQN+HXbsBhwtY/9i0KQwxLNiIP+BAttfEC3cRALA3XpOVKS4tekP83eaUaUAhMQubBxctJRlxSbx95ci721ugG9AJTR2bXFXtc8LaCIEtNewYkn+ukAwKVFgf2ikB/MGaP8XQhXq/PVrpOUmaxDtdPntEIulL0O2WkLXMUPVzt1cjo3VpN92yIExe8Y3DR4SwS/laTRcRsmVur/m5uowZr9mabJnikTeqlyxfrKBRSGelarTOmF9ySlfnf0jQdOLob84U3Ghw97BgsfxjUqs2OSLBta2/kQ4pK/Q8pkkV5eKWE1fH7EEhmHh/OBa7HfIvMRzpi5pY/FGfppaS1FCaEOW2a/okuFNr3WSTQm5YN1Y/qjB3GJuNK24SjCmjFSDkep2SU+QJrN95gA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fa0b3d3-1a3b-4bba-6d9e-08d842b23160
X-MS-Exchange-CrossTenant-AuthSource: AM6PR05MB5974.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2020 13:33:57.6518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nc2uHb+8ysVnUYviXlg+6MAhvQ0Y5J5beH7pghsMJMpySgUvF2yHBZvb/M3+VNmSnQxCzBdj5rv4AzZjkgvBMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5640
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series contains a few bug fixes for ethtool-netlink. These bugs are
specific for the netlink interface, and the legacy ioctl interface is
not affected. These patches aim to have the same behavior in
ethtool-netlink as in the legacy ethtool.

Please also see the sibling series for the userspace tool.

v2 changes: Added Fixes tags.

Maxim Mikityanskiy (3):
  ethtool: Fix preserving of wanted feature bits in netlink interface
  ethtool: Account for hw_features in netlink interface
  ethtool: Don't omit the netlink reply if no features were changed

 net/ethtool/features.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

-- 
2.25.1

