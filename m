Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB682718BB
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 02:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbgIUAKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Sep 2020 20:10:54 -0400
Received: from mail-eopbgr10078.outbound.protection.outlook.com ([40.107.1.78]:51024
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726156AbgIUAKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Sep 2020 20:10:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mr07jEWsf8Z9EYZxaXi2+pAfkC8D/s4KeGoN13UrG1Zj4UafqsJ8Cpw/tHbxi4W4chs+vw+oVUVJqvqRqAF4vOefjB8MqhpT97s30bfb5IuH8lhk9UEleCcel9baD6RZd04BpASAlyXemvP6UkUdMKNDah/bk7/CGRKW3qX5fMzqP2j9q7mTIPzytY5yRT+8lDX6qmnU50D5FlxTfl3pwqCHdN3eytQXk6zblxA7ZZ1zowPBIkaN+/ndIVXZxBPybj8CcoD4pZSsEkW8tSWCXYwxIOAZ+D9wSwxcmJHsKrhxiWAgYn/FHQfWzpd11nXrRWGXWTvMIi/MJ80GJwyYwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chhmS/cyyQwX1ovl9ooZPwewBD8bci4n1+NzwAcOi1Q=;
 b=ETjT1c7zjjFXr5JS/rKNcLeGqt/9YHd+Hc3u1jRS5+Ia2f2t7VBEeFglbhza7Mo3yZ94K/rTCipQx10LBxfF5Fk1qnxYmKjf07KaQOnIp77ZlZlh2agqylId7suFmInyQA17nYJwMK+INWhDIFNFAitjTL3LeDE86AlunTxFHyGK/g/T4hPls55fbm44YGAIKniwPyLg3MacS7L5hcvSEarRb8fLAZOp+TYmzDeS9bNfgrZjgUsUFtnLsPXTQQV7c7kIDw/ijT7nCWGvhE4y04McdjNQWUMSAVzbmmYgOaaBgC8JugCBq3ogCDUoANiyTkESKHfJZKg6e8aa6ow6IA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chhmS/cyyQwX1ovl9ooZPwewBD8bci4n1+NzwAcOi1Q=;
 b=Gy+9niANpWgHEFWl9AdWR3vZTVraQVhhsX83SXYzZm3hluEiTg2nZ4RtRanr++AO9HXeOWA27biGYIdacBW4pvn4qQRzfcz6fpJ4o6NvwMJR7Etr9PbgQs20i0IZrszxoLZyH9bAvLIS+q/OZmUjImzoK41I/SU/xdVtlIeAXbY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5501.eurprd04.prod.outlook.com (2603:10a6:803:d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Mon, 21 Sep
 2020 00:10:48 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Mon, 21 Sep 2020
 00:10:47 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [PATCH v2 net-next 0/9] DSA with VLAN filtering and offloading masters
Date:   Mon, 21 Sep 2020 03:10:22 +0300
Message-Id: <20200921001031.3650456-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P195CA0048.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:5a::37) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by VI1P195CA0048.EURP195.PROD.OUTLOOK.COM (2603:10a6:802:5a::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14 via Frontend Transport; Mon, 21 Sep 2020 00:10:47 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cb97a529-0afa-4f0e-c12a-08d85dc2ca98
X-MS-TrafficTypeDiagnostic: VI1PR04MB5501:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR04MB5501E420B5B9E538A393A7E4E03A0@VI1PR04MB5501.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEMiuGPQlFwTwynRv+DJHHYKihMunbj966MBVREmjmtvSKxWec4bxSk6g2LAn8h2dVeQvmFp18Wo06B6cxFR64ZsxGXBsUCQBk0551JytIMimc4RPY1UEzu0kqcXnCxH0xbjoX6LTjo8dbDblLJtbfB8BMdq+OwnX1iBpzXYJftFtT6VMZ/VfNcqkcp+gVUHRTgOO6AsuE3EJr+4K1Lb+V4c1ytqbyi5ja+9XPE2SGAmn5S3a8fFYqIJgo9S41wl8xuKSDJRDp7SEMy8hIwS9UKtJ17wFZNItHKWuhQMjsz+UDSuDhMBB2umcCECpkZuLZTMVhlk8rbWyLabu24atIPVIfwlrPn276KCRmCEx1T2ibm0hEUz8SDS/6AtnwjXtGGe0hqJrSJz14C1icCop5IwJmsRGamm4FFdBR7RhNMW4qQYR2FgzvvOdjQZs1s+kTKbKORYErvYnvz6DSW0bg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(16526019)(26005)(6666004)(186003)(44832011)(316002)(8676002)(5660300002)(8936002)(1076003)(6512007)(83380400001)(66556008)(66476007)(66946007)(86362001)(4326008)(956004)(52116002)(6486002)(36756003)(2616005)(966005)(2906002)(6506007)(69590400008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /6xPRox9lOygIIDStoeJBZpFY6QblA2kZEB0ASueMjNbbkSWAOJxnVKWXLDI4JqsS2xnfx97i+rfjxKaQRIsb9kfNGnn0COaTokV/kNKWs8uFCQi1bDZK6BSICj3OAJveLuIBbO7ANsBv3K1M8SWOG3VTYieyEzwAGXyrqUOEeRVbb02xDlfALd/3sDCz8qKL10AzM7/784sHbMwoQfxz8Q+Ob4GODW10LfuOUgSlRmDhNDzlYHxyKHvuu8QkSgdnkoIqswvKuLaSby48RKqY3wIM0H9dyDoQyDzOm7Gd/yUnF+cboRMdyBxOqaGZat9vwdT3IpuKzxRr8zeB07F6awiZ6EtEcdK2bqMMsyDXn5a7gh+nRhypJqV3r3QYTs+rHuRRk016IXi6gdbDljx8RI2JuuAd5+CKX3c8+XHdN5Spc5PVHABf7r0pJig0AGf41Zd8+owHemEZX/ZYEz7lcEUoThsSGADAwFPkqsntana3WXV23iPJkxWv2jvY3e73GbarYZ+Ty+CjrrVRdiwjrKF0oxeUETGdjMvvF626+mQeLu1EQYDL0KD/0NJwIrUukvHVOS0bKI5DszaSo2+hVsAerX5p9td6fY4hE4JGL5OPrlM0jexEQ3kx1v5YJTcCrCSCwS5f9kZdomN9/bmEw==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb97a529-0afa-4f0e-c12a-08d85dc2ca98
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2020 00:10:47.9201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Tb6pAY9R5mB2FYaPCGdY8LbOZssLA+b029Rkcw/wYeqkf+cxABNn5pa171XFBHG1IdAdfvsFXFttSJVmXxXHBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5501
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series attempts to make DSA VLANs work in the presence of a master
interface that is:
- filtering, so it drops VLANs that aren't explicitly added to its
  filter list
- offloading, so the old assumptions in the tagging code about there
  being a VLAN tag in the skb are not necessarily true anymore.

For more context:
https://lore.kernel.org/netdev/20200910150738.mwhh2i6j2qgacqev@skbuf/

This probably marks the beginning of a series of patches in which DSA
starts paying much more attention to its upper interfaces, not only for
VLAN purposes but also for address filtering and for management of the
CPU flooding domain. There was a comment from Florian on whether we
could factor some of the mlxsw logic into some common functionality, but
it doesn't look so. This seems bound to be open-coded, but frankly there
isn't a lot to it.

Changes in v2:
Applied Florian's cosmetic suggestion in patch 4/9.

Vladimir Oltean (9):
  net: dsa: deny enslaving 802.1Q upper to VLAN-aware bridge from
    PRECHANGEUPPER
  net: dsa: rename dsa_slave_upper_vlan_check to something more
    suggestive
  net: dsa: convert check for 802.1Q upper when bridged into
    PRECHANGEUPPER
  net: dsa: convert denying bridge VLAN with existing 8021q upper to
    PRECHANGEUPPER
  net: dsa: refuse configuration in prepare phase of
    dsa_port_vlan_filtering()
  net: dsa: allow 8021q uppers while the bridge has vlan_filtering=0
  net: dsa: install VLANs into the master's RX filter too
  net: dsa: tag_8021q: add VLANs to the master interface too
  net: dsa: tag_sja1105: add compatibility with hwaccel VLAN tags

 drivers/net/dsa/sja1105/sja1105_main.c |   7 +-
 include/linux/dsa/8021q.h              |   2 +
 net/dsa/port.c                         |  58 +++++++--
 net/dsa/slave.c                        | 156 ++++++++++++++++++-------
 net/dsa/switch.c                       |  41 -------
 net/dsa/tag_8021q.c                    |  20 +++-
 net/dsa/tag_sja1105.c                  |  21 +++-
 7 files changed, 206 insertions(+), 99 deletions(-)

-- 
2.25.1

