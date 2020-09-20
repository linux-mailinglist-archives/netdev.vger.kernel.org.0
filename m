Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C6462711B1
	for <lists+netdev@lfdr.de>; Sun, 20 Sep 2020 03:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726822AbgITBsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 21:48:08 -0400
Received: from mail-eopbgr80075.outbound.protection.outlook.com ([40.107.8.75]:7847
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726707AbgITBsI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 21:48:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8uAWsvf9d7O15+fa+e+XHx5kD4h8ouiqMnZuUCiGDAiTXQRkp88tuTHeixVH/GqTRkv0IONtI5SpejOs63Z9aI120EOs8dqYB+frDirKAnOcs7avq8rJ53G/YfNtDw7fhZPL74qpMLrcSqq28HiiLp9BaWB0g6frrAfnMPBCtYDGQqGJTp3v1He0HNBrygNNDCy1z8fn00SaJ/MAJMqr2QtMXLMgy1+ruiFVvMsDLI+hMqr/diy11ht8HU2Jqux+1E9xfCbYWT4TsC8pzSB18FVmgdENtda/uCnNRrIKTBC2Fi3egvr9n/j0f4uNFMoletq0LpePomlP7lDe00DZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKA/O7lb7GufkN3F1lERYebzRZaLOKXI0Xmp+1CpfDs=;
 b=Z2b9/B4tqFPn2pI3GYNksnAzZSEbXKhhobTNefum+lPJtEsTNod/Z6UONfnF7K5W+Vhmi7z4Qxs8+QLvDajNEM4CXf05DpDjYRugQzL8b9BWMXiCuIqq8rV3Qim22Jqe4KWIGaPLo8PyMcHOVeLnYDijlY/n/5CCSJ8TJBRF7AFN8y4NSha8yXFi72shA22sBZx24ksWYlyPDke1OZCyVUbqdgXGip9XX3YzrXCax6sJx2W3/jHcGedlK/BdD6eoBrXsnkmZ+U6IspFkXKmX5zskSuYoaJjj3QkmwDum2uK3xCVBt6QVIfu7PHtQjwVQtUQkQ0R1y+gt1hJcwk3x/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKA/O7lb7GufkN3F1lERYebzRZaLOKXI0Xmp+1CpfDs=;
 b=UEMpvKo+7V6m3XN/Vdlkq1oTf3zbtW3uno/esHBpycCZbWJuf0Liq31AJ9lpTTiGwHaoVgQMOnZjg/glueniPF47U/9G34zD+Anz0VYGJ/Yvc6bOv5Idz+JpaiwKmOeEK6W7eFGlYyoBCCQjoZxiSoI5lLDjHi5A/H8kt17yKa8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2686.eurprd04.prod.outlook.com (2603:10a6:800:5b::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.15; Sun, 20 Sep
 2020 01:48:03 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3391.014; Sun, 20 Sep 2020
 01:48:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        idosch@idosch.org, jiri@resnulli.us, kurt.kanzenbach@linutronix.de,
        kuba@kernel.org
Subject: [RFC PATCH 0/9] DSA with VLAN filtering and offloading masters
Date:   Sun, 20 Sep 2020 04:47:18 +0300
Message-Id: <20200920014727.2754928-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4P190CA0014.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::24) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.217.212) by AM4P190CA0014.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11 via Frontend Transport; Sun, 20 Sep 2020 01:48:02 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [188.25.217.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bed338fa-9173-4b40-7b95-08d85d073683
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2686:
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0401MB26866180E3F4EB69003EA0C4E03D0@VI1PR0401MB2686.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UhBOw90yS3Uaa9Qvyjs4ThYV8qlXofNJCAlCndZnQ7Nmx5MbyrTZwaL7O0keZmdPoDurJzA45kGxX2zDT7y2dwedWO9Ra0Iabuhvggcv/bzXB3aL365m9mH1WMP6z1gr543dWukAS1dKMxMR9AMVecWsKBjZvyirtzUWZd7jO0HONAcu9yij7OT4ewg18Y3bT5hI9t3I3KaEsV3ABLy57Ts2SQWK579ugHCmoOPD7iXqTCX8rqVDMVFtGbAqzYO7O2dnw1Y8BKu1f3oJAJLNpelxQeeCj2zszFNyzpDX+Lb+b27Jw4vlaDsl28ZayaPcEIW+I/d7kd9ScnaTBkhx9sj2osLVdz22RAQDkSku6aXSwO+fzX21gPE03ZUu31jN9hCLOnCj+5/DKmTxECBjnpo08zLLDXCz1vCPEifB68gtPeCtTNuoGKIESITU6cIQvnHw6lu0lIS8Zs1vgvpUTg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(136003)(346002)(396003)(4326008)(69590400008)(86362001)(66476007)(66946007)(66556008)(83380400001)(966005)(6506007)(2906002)(478600001)(2616005)(956004)(36756003)(6486002)(52116002)(8676002)(44832011)(186003)(16526019)(6512007)(26005)(1076003)(8936002)(6666004)(5660300002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: R9MFwODfv2wyx5Hk5Dv5rA8guI8o2c7v3ctughE0uaZRzToEAiYBHKcSuRSEq6UNPfew1kgZ7zjN5aQlW0JbRFbSEprKbMisiCriPKzjptlp1gfx+lhNgn9V6CmnS728xOpfzQq8khtHUDZezd7P9rrxLM9T774FSb0PzVZAz2fosId1Yf/qROH7j4EISvIYnko2KwLXLAynARjJLWbgJHthAY8YsK3QK7pNwMAeOYYXCQl1R9IlVZjyA/o9NXK+kxHN3UYEyRXUQqcxwImAPLEzeMoY+DaBcWgWuO/iOLZcckJ92eR8XQY2D5Q5uMrYUz/86T9bNAvOkX9vVkD8k6hsJ1UClOlsx+5d9VvXBthSt4Vl57h7xpUbN09tGhsJNF4fP9TxeTxKSUYWSkdHmUTHY0vBoe7I4lr7Z2iQz5VVP7n4im0pGDr9ZP4/QUeF/Ik0I1vkThtyo88FCuNdiNQL572qzHTAeoEsx4XVCTll91uKOKIVlNI8r71iIsWYtKdER1tLnn5jncZWWwuLx4Tf5s+oQfj6vEDBgtIpcTqK7Ubwe7LzK9qKXVF+w646g6o/IkF6G6BhlbbgzC/fUujO/G2UC9O2WW4WmeCkxIo+0ViGqDil50So+NJU9KRFShMoCiOYDp2684KHmKOK7Q==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bed338fa-9173-4b40-7b95-08d85d073683
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2020 01:48:03.6114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wqc0uKp2RLXnuwaDmHAPbDLcfD3QdNd/ypGK5ktqs61NjlCRfGui2CEZAadZm09Nsw062nLuoH9pinLXqjFctw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2686
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

