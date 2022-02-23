Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A810E4C14F2
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241306AbiBWOBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241305AbiBWOBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:01:37 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140050.outbound.protection.outlook.com [40.107.14.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A65CB0E87
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:01:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1dSb1IRfKEoUhmUIuo3yW/vlWNVLh+vBCKyNXRXJqbdA2stinNBWFytUsfnFffxE6CIkMGOi6ZgSgCBguXqze+YefRV3s2J2Bh/frqeWRYfYgYTfaL5BQAUXw3A4aqrd44a/4VTAgYH1KdZhMn4E+WuxPHllbwzAMm4Sv5v61hp8wbUSj97vzAD0cEvmWw+7lGqVdvY/+wsYacsam57T7sopLGpvtPCHhCqe/jtEUk9Wb+J08f8U/8XFaV/0t1sqAqVSZISsa4NGW1jG1A9UhfCRKz+BsBgOJ5KMKL3YpRY58oa7yWEmLBULp4nYMg03TLa5S5HchPtjufdfMIIog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cICmqpg+mvf0BBm2zWuJNdoCV0n6BLxgtHO4bu/gRIY=;
 b=FsD972WjxRqFOa2bhIogg6/idfkG9Cq0CnyFqOmhWeDWUfwxoSSRxehDTOyvC8lEHWqVeREDEwkl+eyTPrIhwoFAuNZAU+unuDo72oeaCMFScfgsgF+PxLfZvkiuZLe4qpfdnQm1i3lGshzD1+qxqLFwQ0XdR3ErUqsale3NVpIZwNzq+WWhZ4dWcyIQqsAeeg+UWq50MKUTc6cGmYxdqAFB/cwOPWLhhcfD93QxlXFed3Y934Mi5N9BmyAvwFLFC5h1Ooj+t3R6sBS9aYqaOF7nCHoBY6+fhEamDadwWIB+ZxhWdhwJToLUlPvHzS4Gq+ahGcMH1N4Kkmb6TzrwwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cICmqpg+mvf0BBm2zWuJNdoCV0n6BLxgtHO4bu/gRIY=;
 b=No6fyquZeA13OkkTynxbPHVac8pYIAM4Mo+8nKf2sbSFAU4ostr1ahrElBVSEth+pS3Ewl3fOKAXEzpo1+hYP82Xl2t5DLPBNXs+72A1JB9aLn96MwXfwdNGr/Mk1d+O9JCLi6irVjeF60lJsyb5hv5vRPyl6C7nhBEK2yEGnhg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB8701.eurprd04.prod.outlook.com (2603:10a6:102:21c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 14:01:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 14:01:03 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [PATCH v5 net-next 00/11] FDB entries on DSA LAG interfaces
Date:   Wed, 23 Feb 2022 16:00:43 +0200
Message-Id: <20220223140054.3379617-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM3PR05CA0096.eurprd05.prod.outlook.com
 (2603:10a6:207:1::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d04fc91-5e35-4f57-c5b3-08d9f6d4ee05
X-MS-TrafficTypeDiagnostic: PAXPR04MB8701:EE_
X-Microsoft-Antispam-PRVS: <PAXPR04MB870131301A8F7ECEF65E56A6E03C9@PAXPR04MB8701.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j+V60HX2cWNZr/RAEnhYmgrf14IaGBF+v1jxdzxvkgeHKzX4XNofwEnwHWfjyf7FIn55KWTQCnqezgzN6XxH3YcKGG5rXpHo/5y99q3U26/FHoHhVQ0tIATRO9+vNqcIy/+oh2hHQUcHgdI88jBNMrmbmjClmWVcwQxEWFoyBx4B4meglTA3+yDGPOkkZBrGgSrhjcvVf8FWYVjxT8bowXhcKt6ENUvRD+L2lU78kI3hcXRY3oQpSzgl6bKBPILBs6dUZteJhctX3qGZm3eInLvp10qmXeU6wcbOAai8+L0/XZ3dqKRQd/1DjWVFMcTthvKq7oZWKVKWvyjafxB91vUhtgZSdPZIzyFRBIgnOUmSTyKeGdrvrozXIzBUGM/bLN//PShNwjhgh6wkQiu143Mo3mfdH7wCy8YFKkCFCCY7b1inm9bhBd2/1IYD9pEnmE7bKlRpkl0Ma+ZJ8NjMSlNjikxr5ZyFuEt68ppaIN8HjIXtbJ21lWSNVU5xzqbUTlrSBkRQPxakS2g1id+bRMW6e4k5F+WdbxflEDrXXOxT87OeZeBQh06106zRS05ZVLB/dGDEN0xBnScxYh/wN2YVdXlcR5uULLAmM7FRq6ZBV2Xq+iavEUg+aaRp+6J9lesFYjhUui2D49fzwZZTTH6L1p67dZssTo2FE0xss6GXIjhy+rIIoIlGL2S3CPlYhC2GK3psWmmNY9U9IAGPxFLDbzSom+aJFBvYEbxJKcX5BexUw2lCX/Q2CLOTbv6ItuSEQZBLTVFI2Jm2XO6zDRrD4T6QsHo5AzQgsh6gAgc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66574015)(36756003)(83380400001)(38100700002)(38350700002)(6506007)(508600001)(52116002)(6512007)(6666004)(66946007)(6486002)(2616005)(4326008)(7416002)(44832011)(54906003)(66476007)(1076003)(6916009)(2906002)(316002)(66556008)(966005)(8676002)(26005)(5660300002)(86362001)(186003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bFRiOXpKRG16dlMzdXFFSEYwaUw3VG92RU5mdXhFMmdQZHNXMC9ka1ZEbmlN?=
 =?utf-8?B?Ri9GSXB0TEtMSGhwbllSZUkyb2dSRHF6VzZmaXJFQ0RZV3RIOW1KTXVlYlg0?=
 =?utf-8?B?NGxoc0ZCajJ2anBvTDkxWEdDT243TXRMNmxQRUtRWWhuWTZHdytscFlmaW50?=
 =?utf-8?B?MGlITFdubWVSYXk2cUpDeTNSTm4zVklGby81d2lNd3ltdjdDNGRhMDc5Uzdn?=
 =?utf-8?B?Q1lrMm44WU41Tjgrb205V25kUTFIcFdIVWVCUGs1VTBjdFBlaEQxMHZhNEdq?=
 =?utf-8?B?UGFCR3BNdkwvZnlseGZkTURlOUZEM2FKMkFlRmViRjJrT1cxZlErMnZrU3pS?=
 =?utf-8?B?amF6T3ZWTEtqK2NCYmFPS212MVBzSjZFN2xScTdaY3o1eHN6SHhsaUE0WThO?=
 =?utf-8?B?QmhGRlVkbDUwczN6dUhQcVI4V2ZIaGlOVFNnK1BjeithazNRWWc5YU1ibDkx?=
 =?utf-8?B?ZThWMS95aEx0N3Z0OUE2SGltVzVmeTlCV3FQcGdxSzhDSmswOE82OFAySHkw?=
 =?utf-8?B?TUQ3SlBLZGRWWnQrTk13UFRyUllLUitXY0o0amFJMWhNcVlYQkdsUlNnb1ZW?=
 =?utf-8?B?dlVPclNLWnpkc3lNUHBZYmJmYktYMUU1MmFHOWx3ZEpGZXB1eEUwMTNGM0Iz?=
 =?utf-8?B?VzZQME85cndhWjRFT2hwNEJmZURvS0JFRXhxWnc0MFRVeUpZaGUwMnlpZ2dM?=
 =?utf-8?B?L0hUVDNpSU01ci9TUHRTVlFva3JhcUpwRU1lVVFTSThPWElFbitzRXZSSWlh?=
 =?utf-8?B?anVZN2o2QTFMYlJmRE50UVdPQ0U2RVdheXZjdUdSUGFlNUVBZFV6T1AxTldx?=
 =?utf-8?B?UHRtblY5V2FSa2F6VU9ma2hNa0dPVWVIVGRTeURsZjJLMjRienZPR3RmeUlo?=
 =?utf-8?B?aEt0citaK3dhL1o3TmhSR3FFbVFLN2FZZTYvWXpsalFZL1g2VDVobkcrNHo3?=
 =?utf-8?B?Y1JtSHJXVitQYUQ1ZTlOc2hlKytTYlFHSDFCY0VlYllXdDVDWGEwdUNhdGtk?=
 =?utf-8?B?SEpJZklGWmVuWDRLQUhnbFE3NkpMOGJHT0ExTFo4Ui9GdFZGNlJWMG5Bd2FL?=
 =?utf-8?B?R2xzTTl0d1M3ZjVOQ041cGZLcSs0M1lVbFQ3TnlCZUJtNitjd1JzM3laYjl2?=
 =?utf-8?B?UjBYWDhLUFhlTnRNak93d0l4T2s3Q3NSR25MeG1TN1dpQmQ1Ym1TTkx2YjVh?=
 =?utf-8?B?am13dzVJMDhaYVNjaEpmOUZoMExwMk9TeWhreVBVWUxsdkZUS1dUZHA1V2Np?=
 =?utf-8?B?TXlVeDkycnp1K05KTWxCV3VaWTk2Q0dTTnpTdHd5VmJjc29SSEc1QkhaYmwx?=
 =?utf-8?B?eG1EdnFkcytla1lrVFN6djhYcEo5UmNxMlJmenRtMjdQbE9PTkEwYTI5Z2JC?=
 =?utf-8?B?Njh1UXN3SEdud1dJUURiWkVzQzZXWUZUaFZhcG5hWUFyRmN5aTFuVzBweWdS?=
 =?utf-8?B?b05wWGVIc2svVXJlR3JnWGY0UGsvdTlsSmVUemVYT0hySW1lWW9Ca091bk9w?=
 =?utf-8?B?OVR0a3NNaXJtbmQxUWJHNThvaU1PUnZZMUF3OFNmUUczT3NBU1dkQ1dVeUVF?=
 =?utf-8?B?NzFGUnZOQjN1NGxZNXZ4L3I3UUkzQ050WkwvTTdYYlQ3VzFlRDZKK2pWbm9u?=
 =?utf-8?B?MG1OdTVCSkRnaWR5eTJNQWtYY2NtNGN0YWd0NU5aZGlhKy92U1B2YngzNWd1?=
 =?utf-8?B?SEw1OTZ3Z2p0aFJkYkdaTVZMeEJlQWV1aWpOUzNQSW41ZlBXQ3hhc0NGTXJr?=
 =?utf-8?B?TmFMb3hoRVJFbzJpT1MwRW9CbnBlTDhZVTl3bEdhWTdDaFNvcUVjNDgxaW9X?=
 =?utf-8?B?WXRGRUdBaEtPUlBlNkszb0I1QUxKdTZnS09Ca0dOandub3BwNmNPeWNPYnRG?=
 =?utf-8?B?aURBT2VJdUF5bFp2WDVHVzlmTmY3NHpUWUhQdmdtZ2VUdkJTc1duWHRwNnVp?=
 =?utf-8?B?YnJqdVVsWEVKa2pYSEptdS9qQzNKMUxsTGtDTkJSZ2J4Y2tGYTV6N25HTVpo?=
 =?utf-8?B?S2dRdCsySGUvL2dCUDhjOGlZTm42bUYwWlpWQzRWZk1iYlRBL05sdDFBSFFO?=
 =?utf-8?B?N2E0TTZSZUIvZzRjZmYvazVaSlFsNWtiNVlRSExDcW9WK1g3WWt5eC9Gclkw?=
 =?utf-8?B?emVDbThGaEtzeGFNdXR0QmRMZUxJTDhNNXhIUVQxSDh3MFcvZkxNeGd3ZlQ5?=
 =?utf-8?Q?DxilS5cLXMtuzcAgP9RbkxE=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d04fc91-5e35-4f57-c5b3-08d9f6d4ee05
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 14:01:03.8834
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dkm+BeFxib9dxabjtgQuY8gaIO2yUQ3bYwt3r5g38qO8lTzs4fpVK/wVTWybseUvc17FtscBzVmydZKcDyjrsg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8701
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v4->v5:
- resent v4, which was marked as non applicable in patchwork (due to
  other patches getting accepted in the meanwhile, the offsets of some
  hunks changed a little, no other changes)
v3->v4:
- avoid NULL pointer dereference in dsa_port_lag_leave() when the LAG is
  not offloaded (thanks to Alvin Šipraga)
- remove the "void *ctx" left over in struct dsa_switchdev_event_work
- make sure the dp->lag assignment is last in dsa_port_lag_create()
v2->v3:
- Move the complexity of iterating over DSA slave interfaces that are
  members of the LAG bridge port from dsa_slave_fdb_event() to
  switchdev_handle_fdb_event_to_device().

This work permits having static and local FDB entries on LAG interfaces
that are offloaded by DSA ports. New API needs to be introduced in
drivers. To maintain consistency with the bridging offload code, I've
taken the liberty to reorganize the data structures added by Tobias in
the DSA core a little bit.

Tested on NXP LS1028A (felix switch). Would appreciate feedback/testing
on other platforms too. Testing procedure was the one described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210205130240.4072854-1-vladimir.oltean@nxp.com/

with this script:

ip link del bond0
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge && ip link set br0 up
ip link set br0 arp off
ip link set bond0 master br0 && ip link set bond0 up
ip link set swp0 master br0 && ip link set swp0 up
ip link set dev bond0 type bridge_slave flood off learning off
bridge fdb add dev bond0 <mac address of other eno0> master static

I'm noticing a problem in 'bridge fdb dump' with the 'self' entries, and
I didn't solve this. On Ocelot, an entry learned on a LAG is reported as
being on the first member port of it (so instead of saying 'self bond0',
it says 'self swp1'). This is better than not seeing the entry at all,
but when DSA queries for the FDBs on a port via ds->ops->port_fdb_dump,
it never queries for FDBs on a LAG. Not clear what we should do there,
we aren't in control of the ->ndo_fdb_dump of the bonding/team drivers.
Alternatively, we could just consider the 'self' entries reported via
ndo_fdb_dump as "better than nothing", and concentrate on the 'master'
entries that are in sync with the bridge when packets are flooded to
software.

Vladimir Oltean (11):
  net: dsa: rename references to "lag" as "lag_dev"
  net: dsa: mv88e6xxx: rename references to "lag" as "lag_dev"
  net: dsa: qca8k: rename references to "lag" as "lag_dev"
  net: dsa: make LAG IDs one-based
  net: dsa: mv88e6xxx: use dsa_switch_for_each_port in
    mv88e6xxx_lag_sync_masks
  net: dsa: create a dsa_lag structure
  net: switchdev: remove lag_mod_cb from
    switchdev_handle_fdb_event_to_device
  net: dsa: remove "ds" and "port" from struct dsa_switchdev_event_work
  net: dsa: call SWITCHDEV_FDB_OFFLOADED for the orig_dev
  net: dsa: support FDB events on offloaded LAG interfaces
  net: dsa: felix: support FDB entries on offloaded LAG interfaces

 drivers/net/dsa/mv88e6xxx/chip.c              |  46 ++++---
 drivers/net/dsa/ocelot/felix.c                |  26 +++-
 drivers/net/dsa/qca8k.c                       |  32 ++---
 .../microchip/lan966x/lan966x_switchdev.c     |  12 +-
 drivers/net/ethernet/mscc/ocelot.c            | 128 +++++++++++++++++-
 include/net/dsa.h                             |  66 ++++++---
 include/net/switchdev.h                       |  10 +-
 include/soc/mscc/ocelot.h                     |  12 ++
 net/dsa/dsa2.c                                |  45 +++---
 net/dsa/dsa_priv.h                            |  24 +++-
 net/dsa/port.c                                |  97 ++++++++++---
 net/dsa/slave.c                               |  64 +++++----
 net/dsa/switch.c                              | 109 +++++++++++++++
 net/dsa/tag_dsa.c                             |   4 +-
 net/switchdev/switchdev.c                     |  80 ++++-------
 15 files changed, 560 insertions(+), 195 deletions(-)

-- 
2.25.1

