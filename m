Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 510866290F1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 04:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbiKODr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 22:47:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232381AbiKODrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 22:47:24 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3CD18B24;
        Mon, 14 Nov 2022 19:47:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k0sjyF+p8q0UMPVj2gbLkAOzThvYBOY/BgHFd9EYDikPn58yzVm3LIzhoHacWgQkIqIqCuBOkqvyp6FdDFjuQVwa6yj4UIO1PVZx7p29dVZvAiv48stsVpL3buUguseKpRv/QvmD/IzMJozsT9AqJ8ErBKnpadhqNItJ5TzXS6JgQVGwbwl46mrSbpvjlR9Wi4EkomJeT1NpAHqomGecwXhL1eQNseO8L9AutNDWVt7MhH2NlSP8da4tvy+D/Bp6oGBiXkqb6BSZXv1JKGDASuEiV3crEYNbHPV5tFj0XotiaZ1JDIAo9YL7G36KzNWJLcy0TDgKei4gmgsIDuPmfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qScraEu/2JO0TOKctttc1i0M+JPqFc5kq2Vbh6ZSJ40=;
 b=W3mgoZpfWIuduTOxhumIJEuJt5KWhYUoFZL4e42NEz1loBgkfSZ+VWefOY386T24dAcjNzTAmFjxokjmXGvUhFKyXQJ5Z/n2J17RbihqOiY+z5v4MkQjRrYqPVJTR9u1tNcISLzkjoSQdM2ffOBPowjiCbyCmLym8cG1ku8qrf3BffDFlA7NdZfLFtq8JzOentiTosKmELFkjLqcGJ1vMmraLdtvUnL5JjX5soCq4zsWOCjQcTwUi76d2a72M6T+LU+rvMQ113/7xRkib/YIMxHdtgkza9Mn9tvrR6JjNij6xXp1TVaB1iFmJwN5ns8boSdo7lyuMqZKxs9Bra5Dew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qScraEu/2JO0TOKctttc1i0M+JPqFc5kq2Vbh6ZSJ40=;
 b=aeMs2zbGnVGjRmLSqPkrxMwt0bxZr93XuH3soMINiS1TORi6rbqHRXWsHJvghjSnx1mMAjyNN0MNAnJAnv5eF/qowiQyW+5ScJDUWDqJJxyB3gg0MFH5M8tQsP5YKeKcvtdKtBzNsIPmQiIiMnCHVbfn4kGA3moEpz+FrvSt+LI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SJ0PR10MB5549.namprd10.prod.outlook.com
 (2603:10b6:a03:3d8::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Tue, 15 Nov
 2022 03:47:20 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5813.016; Tue, 15 Nov 2022
 03:47:19 +0000
Date:   Mon, 14 Nov 2022 19:47:16 -0800
From:   Colin Foster <colin.foster@in-advantage.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH v1 net-next 2/2] net: mscc: ocelot: remove unnecessary
 exposure of stats structures
Message-ID: <Y3MLxNIQBiZKmtNs@euler>
References: <20221111204924.1442282-1-colin.foster@in-advantage.com>
 <20221111204924.1442282-3-colin.foster@in-advantage.com>
 <20221114151925.p35ynwi7ejmr6zhc@skbuf>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114151925.p35ynwi7ejmr6zhc@skbuf>
X-ClientProxiedBy: BY5PR03CA0011.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::21) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SJ0PR10MB5549:EE_
X-MS-Office365-Filtering-Correlation-Id: c50cc3e7-e2c2-4f85-9f31-08dac6bc1881
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DMLv8XiMUN3pcWU5q29Cyqzs4t+ln5K8axCcSm2qmOrBFSVRVtmkVDFlMEhGUFWiPmGIc7wCKgjgiKAOMdN0BeZB+DsdZERxYY96+g7rVk6K9DAaZY/IR3z/tlXt0iDYBwE1gYSM73yWKNxV2YX/as/PVzPwDeqbVemdRjRbq2G18amKFX/8L5n7pyX8eEo/uE4JmzqxXcqnEMZd/FxkfFnLIPfCtCi9rZtkyCBdp/33qkzQuBLGLHQo2wvxUOKduLx7NLXPWpeTMFIKkQ98aPAAaGanIQ99RpgRw+DQsIlF1ZnQjyP9Pwqk6I9txjnbod1cYJBP+0u2ee8OErEwd6oMLQlKDROiPTk/tSYosD65IF2iunSRMj2d2L73/UdvbaTuafOcBiiAN9YzwuR5RV26imG4AkQgygIi6cVOG8V7wD3ymRv8NgBsNll5VdL3ASDOX3yf8+/EFgCGXxqmwRBV/HELDawiQ00iXbo208hKqoqCjOdTmASuMy+4wT906sJOk+h4sNcYzD5bIUQ34xmyXZUsf7VxNEywHOIeHkIIwxv6W5VWvwjxnR1aE8wPSz9qzz7eMGi6A+tbs5WmnTbwgPHVZtajz9IrmG0GwK3odwCHBS+aukZDj2Wugnd3jweRv16rGr9oPwXCD5+l0bhihw3c5M9toC4NcWXwJbli6C1PSOJFtqQH8GXhRz0BssnrJsrM30w92r6oj9LEEA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(376002)(39840400004)(136003)(396003)(366004)(451199015)(478600001)(83380400001)(6486002)(38100700002)(6512007)(6506007)(2906002)(26005)(316002)(6916009)(9686003)(7416002)(6666004)(4326008)(66476007)(33716001)(54906003)(66556008)(8676002)(44832011)(66946007)(41300700001)(86362001)(186003)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kiYIwxF8OIoHazMCj4jVU5+1EArRr4ciDhIwbKLR8KoXMnwcoK2LghdPw2AM?=
 =?us-ascii?Q?5dTuldhCzKfU8DVuN9HSk5o6NgJQ+pRXJdDZIuDyIWf/79Oc/O9+/POhTi7Z?=
 =?us-ascii?Q?OHJ+AYqn9c02SjUtCKOr2LWejHcrcQN6RR58bSUz7l2+0cuTZMV34lXEFPqH?=
 =?us-ascii?Q?zMnzevAFJh/hF/C8f84ZJV8D5RbrWr1AxhPUlddkKA8G1sorDaNvgsMcd2lY?=
 =?us-ascii?Q?poh7TOJEY814e9bhTUHmvBhMH6WbTSYdIKVG6xPQKob0nwnRpqEbcH/CxQe5?=
 =?us-ascii?Q?OBoXIaNtMegpR8EywIGGFA6uxBJWneJCrIM9pYHPbF0bL5bRVvEGbymlRdTV?=
 =?us-ascii?Q?jB/rD/5J2bzMOiEoNS9+yqlGOxLOUzcphBSd32gTRpMcGEFPPF4Re0QqJfZ2?=
 =?us-ascii?Q?Er7JvjadJJJNSlVi7vrDborFXV7Xd31vyqKJdZpZXr31HJBbn2a7XWJL1/u+?=
 =?us-ascii?Q?8SnCjHPvif6JPd5CLpzupL1Cv4hBZkUPiHH6Tn08OWWOZe7PaNEZqknPgdfn?=
 =?us-ascii?Q?q9HpU4cnopC2nMf92tuv0s6UXE++yVsP38F5nowpBs3VRnKgJEfBggL3FKgs?=
 =?us-ascii?Q?MHbfNKavdQ3etPiNzbZogp8Hr2Hc0WlT46uFmur/Yh6LxMBx4Ce4rprt8I4a?=
 =?us-ascii?Q?sf9POGA648yTPHWt4l+u5Wu1DYBuk6fKehlO65khLvJeNj6oWPB9q+p1OjVM?=
 =?us-ascii?Q?+jJKML/4ln6/KM/sAIeKqBLTaAVdDdvnLCkU+iP3fw4saBGG5dGXDdTmHQ9c?=
 =?us-ascii?Q?9+IsZ1f+qN6nYokJ5NIFhM1+6ZBtLibVgxe1vzKiKWUWS9Gui7HwJhFv1vFm?=
 =?us-ascii?Q?j2H5zQEyz4uldzzLJHeTv6njBmcgQAF6/3DBhU5D9Zd4nPV/K7znTG0A1GwF?=
 =?us-ascii?Q?CEmQqZW/ydfTCKEMj9ypUhASOQPeWjeBGzfm7PGSyIZG9kQNbzNJYIuTxq9A?=
 =?us-ascii?Q?CaqpcKoFmxZ2Ra7RrdViCWUAwkTSFvFPIZu66TYw0kt3NCpwgC7tYLe88ivW?=
 =?us-ascii?Q?V9SiybrOlWioew2gDabfZBOIVQCJjZvm4h3rgqHS52OGoFds6dCEHZ4fnpGJ?=
 =?us-ascii?Q?H/MBgd18YkrE9VAQY0ea3+xbTseVFM9G0ayXprvsXD/Xau9zK5sX3xIJXle5?=
 =?us-ascii?Q?5wSuFavuHE4oB+iT0Jp0aAmKF10bTeI6JmU/mYAp39oAilX/RZU3cvPmV/3b?=
 =?us-ascii?Q?DMjaCSMFb/oM5vDqDdEwra0CvN6T+xsOMUdHGIniMG1n1yF3qH5/I8zDx+j7?=
 =?us-ascii?Q?pvB3jo2AYzG6sKlTEKwh43dXcb3yWZHsbgDp29wwBjU/V9tp6asbQHYruWG6?=
 =?us-ascii?Q?Nlydy5g39MIAtDCrkPL+P5cfbsQsANe+AEkadgk9S7WtLM2mdQcJH6zv8HJd?=
 =?us-ascii?Q?vqMaiumbuwvI7F9erI19kCVFIh+zQ58UPCkh4kSOF5e3NNUEmPHDTES70Mr7?=
 =?us-ascii?Q?O0Jp9QzHpKQ/QqEhCsAKOpS/HLUdKHHh9/hGjzmY/xRTIKgtyM1sG1BeGvjd?=
 =?us-ascii?Q?4p131ods1PufAuH2LLDIACGbKagJvW5J0yKKBN4t0W5SoCm8YxzkujK+LbBW?=
 =?us-ascii?Q?WzJoC4HT3kvU/D2h+8QFnyy6q3jyUCZDrmL3rMzAa+xMhlSr9TAoEICgMwBo?=
 =?us-ascii?Q?Sw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c50cc3e7-e2c2-4f85-9f31-08dac6bc1881
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 03:47:19.5520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KDH6PsEEXFUvimdlPKAf3CUQkraz6Pra6qF5Iw7HLCqq8pNCwkHGT8CnZ6ZPYM9j6LoBhbRBc+PDv8LdERZZci2Zde7Qcrmko+pftgXrMWk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5549
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UPPERCASE_50_75 autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 14, 2022 at 03:19:26PM +0000, Vladimir Oltean wrote:
> On Fri, Nov 11, 2022 at 12:49:24PM -0800, Colin Foster wrote:
> > +#define OCELOT_COMMON_STATS \
> > +	OCELOT_STAT_ETHTOOL(RX_OCTETS, "rx_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_UNICAST, "rx_unicast"), \
> > +	OCELOT_STAT_ETHTOOL(RX_MULTICAST, "rx_multicast"), \
> > +	OCELOT_STAT_ETHTOOL(RX_BROADCAST, "rx_broadcast"), \
> > +	OCELOT_STAT_ETHTOOL(RX_SHORTS, "rx_shorts"), \
> > +	OCELOT_STAT_ETHTOOL(RX_FRAGMENTS, "rx_fragments"), \
> > +	OCELOT_STAT_ETHTOOL(RX_JABBERS, "rx_jabbers"), \
> > +	OCELOT_STAT_ETHTOOL(RX_CRC_ALIGN_ERRS, "rx_crc_align_errs"), \
> > +	OCELOT_STAT_ETHTOOL(RX_SYM_ERRS, "rx_sym_errs"), \
> > +	OCELOT_STAT_ETHTOOL(RX_64, "rx_frames_below_65_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_65_127, "rx_frames_65_to_127_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_128_255, "rx_frames_128_to_255_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_256_511, "rx_frames_256_to_511_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_512_1023, "rx_frames_512_to_1023_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_1024_1526, "rx_frames_1024_to_1526_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_1527_MAX, "rx_frames_over_1526_octets"), \
> > +	OCELOT_STAT_ETHTOOL(RX_PAUSE, "rx_pause"), \
> > +	OCELOT_STAT_ETHTOOL(RX_CONTROL, "rx_control"), \
> > +	OCELOT_STAT_ETHTOOL(RX_LONGS, "rx_longs"), \
> > +	OCELOT_STAT_ETHTOOL(RX_CLASSIFIED_DROPS, "rx_classified_drops"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_0, "rx_red_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_1, "rx_red_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_2, "rx_red_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_3, "rx_red_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_4, "rx_red_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_5, "rx_red_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_6, "rx_red_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(RX_RED_PRIO_7, "rx_red_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_0, "rx_yellow_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_1, "rx_yellow_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_2, "rx_yellow_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_3, "rx_yellow_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_4, "rx_yellow_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_5, "rx_yellow_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_6, "rx_yellow_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(RX_YELLOW_PRIO_7, "rx_yellow_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_0, "rx_green_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_1, "rx_green_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_2, "rx_green_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_3, "rx_green_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_4, "rx_green_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_5, "rx_green_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_6, "rx_green_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(RX_GREEN_PRIO_7, "rx_green_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(TX_OCTETS, "tx_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_UNICAST, "tx_unicast"), \
> > +	OCELOT_STAT_ETHTOOL(TX_MULTICAST, "tx_multicast"), \
> > +	OCELOT_STAT_ETHTOOL(TX_BROADCAST, "tx_broadcast"), \
> > +	OCELOT_STAT_ETHTOOL(TX_COLLISION, "tx_collision"), \
> > +	OCELOT_STAT_ETHTOOL(TX_DROPS, "tx_drops"), \
> > +	OCELOT_STAT_ETHTOOL(TX_PAUSE, "tx_pause"), \
> > +	OCELOT_STAT_ETHTOOL(TX_64, "tx_frames_below_65_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_65_127, "tx_frames_65_to_127_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_128_255, "tx_frames_128_255_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_256_511, "tx_frames_256_511_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_512_1023, "tx_frames_512_1023_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_1024_1526, "tx_frames_1024_1526_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_1527_MAX, "tx_frames_over_1526_octets"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_0, "tx_yellow_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_1, "tx_yellow_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_2, "tx_yellow_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_3, "tx_yellow_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_4, "tx_yellow_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_5, "tx_yellow_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_6, "tx_yellow_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(TX_YELLOW_PRIO_7, "tx_yellow_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_0, "tx_green_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_1, "tx_green_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_2, "tx_green_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_3, "tx_green_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_4, "tx_green_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_5, "tx_green_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_6, "tx_green_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(TX_GREEN_PRIO_7, "tx_green_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(TX_AGED, "tx_aged"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_LOCAL, "drop_local"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_TAIL, "drop_tail"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_0, "drop_yellow_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_1, "drop_yellow_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_2, "drop_yellow_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_3, "drop_yellow_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_4, "drop_yellow_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_5, "drop_yellow_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_6, "drop_yellow_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_YELLOW_PRIO_7, "drop_yellow_prio_7"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_0, "drop_green_prio_0"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_1, "drop_green_prio_1"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_2, "drop_green_prio_2"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_3, "drop_green_prio_3"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_4, "drop_green_prio_4"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_5, "drop_green_prio_5"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_6, "drop_green_prio_6"), \
> > +	OCELOT_STAT_ETHTOOL(DROP_GREEN_PRIO_7, "drop_green_prio_7")
> 
> If we're moving these anyway, and stopping providing anything *but*
> common stats, we could as well move them to ocelot_stats_layout and
> delete the OCELOT_COMMON_STATS macro?

I noticed that as well. Depending on which way is best (if the v2 patch
looks anything like this patch), I'll remove this macro.

