Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF13028CF73
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387423AbgJMNtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:10 -0400
Received: from mail-eopbgr140045.outbound.protection.outlook.com ([40.107.14.45]:35766
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727936AbgJMNtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j4pICTaaUbVeE2oJJQ//ETH6vZy681WWExaOuQnTPRowaa7aRa10c7+Pj0U5ak2v+ZIHt7x9eWsNrVpqVXWElGVpTkOImJpmNw89tBgjXLqO8KFLCdPyen0Xo3cK3DeUX0wwLrnGUyfdg3mbWZ8Ocs9oEMSKKtqj0hLJhbGNbq5Ftv0fdZZRSjNbzjK7kB/wvRLQdAzSD5YodgP7DtdCuiMBovEmN/CWyc7////C4GJteWGfNtjlW+CGGnSRmQsT8Jx5Jc6Z1ZvfUDypSLkYNn6+4qLQA2ldHnxZlvO/Zgc4r05gQ7WT8sDtprkTSHRNLYzBGqlB/3ZcXBa9eWgtnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRAjwRdcR75CMhRKz6wcWAXErJVsEFrPYVgV9ZD0g+c=;
 b=cJIELN0XnGVOvJNyXTspUZZAyx9X5ssDANOHLbNmRnZwZsYasS3qizc8VogFnhZaKF72ck2V+XiAe4A89qEB+9X2s/LdiPt5wRaI2YP9b5u5dd2U2ibF82JP9L/PGBLWMToOn5QLwggnKaJ+1i3AZXBqv7l2ESToFVwwX+wN97BUOtGBlUOxQ9Myw+5U3AvUvB/vLcNzMuSoulVu4xXLhLvDh8UKmMEwr3GmpOSHpdXJTLsJVb6JL14uPm90q1LDvi26q7U0rmsTxr83uExqO7toxHKr9YV6B1sp48GOEiXCJGKq3Nv+eIY3sTtVZfcAMSPMjU6GSN3TsQP/c/SaJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zRAjwRdcR75CMhRKz6wcWAXErJVsEFrPYVgV9ZD0g+c=;
 b=EbQmEY4zkMMLgKBVrtYQDvEraCnM6/cBo9QtxsgFKYziExSh/4WLGqdFYiUxYoORY3rGW/PMc1rEIIRwMfkKlh0GtwnES3XBi9h9ywd48hpQWWoulsiIhkLzrHp7E/GMVecD04ObzwCBkhQjOGtI7uWRKwZy4/uvIdAd+eViED0=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB7104.eurprd04.prod.outlook.com (2603:10a6:800:126::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.22; Tue, 13 Oct
 2020 13:49:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:07 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 00/10] Configuring congestion watermarks on ocelot switch using devlink-sb
Date:   Tue, 13 Oct 2020 16:48:39 +0300
Message-Id: <20201013134849.395986-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6204de31-2242-4ffc-27ef-08d86f7ec114
X-MS-TrafficTypeDiagnostic: VI1PR04MB7104:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB7104FFD416C728D8853B2B4DE0040@VI1PR04MB7104.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /b+xq6NUsaxVx7wSUoggb/7eiC3y96FoTazxwcppPVL7CuAaQi/TtuoDwtkANTTe7nWFthnSO/aE143gGu2qRDDKD+1nxYIvt5XcAoXeYWJU2FHBFP2dClck9kmwPJ6J7BnoArEaXroo9U8/LvgARFplmv05Dh1PqHLQlgt9bJDd9HMMcuOscIZjtyIwK3U8EjJ8gt6Bzn4i0QUjxRsAgZQ9qCv9rCoO24BBkcZZ4MU+PzuNTVQH5wH73XvsRNN5hBXdesyAXgk5veNiYyKYyCdkO2HLf4K5PvpHI1eysQMvoJ8Kqz4f7VZGGnZKDmZZZEAFE02QscO99pN6ddjVWes67e7b7bVTW01pCpgbvcayxxXcFjZO+1YzErQIVsw0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(39850400004)(376002)(396003)(478600001)(83380400001)(6506007)(8936002)(69590400008)(6486002)(66556008)(66476007)(6666004)(66946007)(5660300002)(1076003)(316002)(4326008)(36756003)(956004)(8676002)(86362001)(2616005)(186003)(6916009)(16526019)(26005)(52116002)(44832011)(2906002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: OdaJUR0em+QKlLFqWzEfo6UBrHJLHD+mwJqHYegoNbzSasQyGTGX+l164ES57RecGjPxSaKV+jQprBlr9GxZ62XXNPCtBduie35Sqgw0z/5Wjzty632yjQC1uygr/d/PPCgc3aBMobazTHfaKggHPB8NoSS0/kV6JkTKiPy31fp5Ay1MYnWO5IIh+4rAG19dAtR7HQN0r/OTEo4MW5Z65qqDjLBepLnLm5AVrtgDkcAylUudjpmHMVuvS9y0Xs2ERkByeVB+J57LlwQxcErX7uJHNWGLjcgyOoEtgooKVd/LyD1HHPrSXE3ZtHpQQUJqmxTuuNRutIvjmgJDBfIjqFHkSudrmUL2ECWSEo/2ZXO8WNkQQmKqx2W0LE9XsI1zrMTymonvcBRA3k/0lZP0XnqWSQ7teznreytt87B9EKwCcSx8QHAUwlqBOaDQ5r//pxjCszCGq30KK47WMs8L/jVhcvZtWgFNi6XMR6aWC/uqr6N8vrnZyOHGYKoSU8PxicLgQldzGsAwXzjkymjOHSlijWP++oGmPA8aVp9McY023jhLkxmZw7u22scztfSHT4+misq4aZeD4Q/BduQ3NPw6jNeOfOgvKW+iaTo/3t1vfyjaYiC7iMCbFvRhXLs/XmEnPyqCF/7vJOSK751jfg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6204de31-2242-4ffc-27ef-08d86f7ec114
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:07.2169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: riVrtPunEtCAxygNYWbB0RbVLudLd43/0cx2x2uyGXxVGnn3QFQxyPLVolC23UaGljdZjgO4ppkS5shtsvV5bg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7104
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some applications, it is important to create resource reservations in
the Ethernet switches, to prevent background traffic, or deliberate
attacks, from inducing denial of service into the high-priority traffic.

These patches give the user some knobs to turn. The ocelot switches
support per-port and per-port-tc reservations, on ingress and on egress.
The resources that are monitored are packet buffers (in cells of 60
bytes each) and frame references.

The frames that exceed the reservations can optionally consume from
sharing watermarks which are not per-port but global across the switch.
There are 10 sharing watermarks, 8 of them are per traffic class and 2
are per drop priority.

I am configuring the hardware using the best of my knowledge, and mostly
through trial and error. Same goes for devlink-sb integration. Feedback
is welcome.

Vladimir Oltean (10):
  net: mscc: ocelot: auto-detect packet buffer size and number of frame
    references
  net: mscc: ocelot: add ops for decoding watermark threshold and
    occupancy
  net: dsa: add ops for devlink-sb
  net: dsa: felix: reindent struct dsa_switch_ops
  net: dsa: felix: perform teardown in reverse order of setup
  net: mscc: ocelot: export NUM_TC constant from felix to common switch
    lib
  net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
  net: mscc: ocelot: register devlink ports
  net: mscc: ocelot: initialize watermarks to sane defaults
  net: mscc: ocelot: configure watermarks using devlink-sb

 drivers/net/dsa/ocelot/felix.c             | 212 +++--
 drivers/net/dsa/ocelot/felix.h             |   2 -
 drivers/net/dsa/ocelot/felix_vsc9959.c     |  21 +-
 drivers/net/dsa/ocelot/seville_vsc9953.c   |  20 +-
 drivers/net/ethernet/mscc/Makefile         |   3 +-
 drivers/net/ethernet/mscc/ocelot.c         |  23 +-
 drivers/net/ethernet/mscc/ocelot.h         |   9 +-
 drivers/net/ethernet/mscc/ocelot_devlink.c | 901 +++++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_net.c     | 235 ++++++
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  47 +-
 include/net/dsa.h                          |  34 +
 include/soc/mscc/ocelot.h                  |  54 +-
 include/soc/mscc/ocelot_qsys.h             |   7 +-
 net/dsa/dsa2.c                             | 174 +++-
 14 files changed, 1675 insertions(+), 67 deletions(-)
 create mode 100644 drivers/net/ethernet/mscc/ocelot_devlink.c

-- 
2.25.1

