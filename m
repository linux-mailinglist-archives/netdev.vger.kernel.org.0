Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181CB2DCDF2
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 09:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgLQI6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 03:58:21 -0500
Received: from mail-eopbgr30043.outbound.protection.outlook.com ([40.107.3.43]:10627
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726533AbgLQI6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 03:58:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6pVZfNVrQari7KqUwjX7597pezNygIDnOxoAYAFjGjX+o9qz14n+dtZ9ejOr7Yo9rvYs7kdJL3iYEegww7ahagTOmPAp1HIy7fYW7doylJFeRrdgMboHrTxo+bzOzdseq7Wb9Mi719hR9pvADIgddz3w+QzG7umEdnMxbdpjh+a6HfjAVkkSbE9K6sG6PCLUqBjsrzRfq7PXEw5uLUVCr0M6tQ1AsxMSncw3zQaVNU//H6FX0YxDcgt/fNAhz55IVPDGM8GSEo7l4mjm+4vgWjwmO+ogwHnTf/H5aAn9gC4ki3h1Sc7M7cGEg6VzlyeBhbOjZC7h3DxC7wbrfVSow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxyShRYpU78D3Nb6QP9E9XRsyxRC2NzXPE/GHw6dzYU=;
 b=of3K+12qTVjyG5207lftEux1yCRC+aX3fbJUMS90QUrkjKLuFY3MG/ffwJJYUWD/nsVlGxbrher5XTuFja7MnMrYEMMrbPUmnn45UZeyote33RYmhd5zJKyuMJZwPTY5shEOvUjN53JUByVL7KyWlQnBJfjFP1S0UCsOpzLOwhWXKNRs9zzSiz4Oqa2HLC8cdj9KPlT+Z/m1vY6l8reBG5m8DCeABaTGOgvv1KxkwEjn8BmmCWpWcgfa3NlhboYcC4L36+hxl24rTQkBPaV5OkYVuSiCRtCue2j9Amm0CL+iB5agAAHcivrq1vAqY9vHy+aeAZSkGOqXlvq2n6PCgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JxyShRYpU78D3Nb6QP9E9XRsyxRC2NzXPE/GHw6dzYU=;
 b=UfR9WFrSXjqke7v7x3F5oFcrKkeBVDRmpPG74rnRzUMUhEK75nl9MWA03Ou+eiFOnwnHU/njrynioOr170y56oBtlkspwy1CJz3NCxaCagnvgUloQpUKxzufaK5VtnxLpBObwFPnkhOjYyF6GwEeghhKq4RnTZVEPfR9Ykr/RSY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB6674.eurprd05.prod.outlook.com (2603:10a6:20b:151::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.20; Thu, 17 Dec
 2020 08:57:30 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::4d67:7d47:90f1:19be%7]) with mapi id 15.20.3654.021; Thu, 17 Dec 2020
 08:57:30 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        andrew@lunn.ch, f.fainelli@gmail.com, mkubecek@suse.cz,
        mlxsw@nvidia.com, idosch@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH net-next v2 0/7] Support setting lanes via ethtool
Date:   Thu, 17 Dec 2020 10:57:10 +0200
Message-Id: <20201217085717.4081793-1-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR0601CA0024.eurprd06.prod.outlook.com
 (2603:10a6:800:1e::34) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by VI1PR0601CA0024.eurprd06.prod.outlook.com (2603:10a6:800:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 08:57:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91751c37-9e9f-4f2f-7df5-08d8a269c901
X-MS-TrafficTypeDiagnostic: AM0PR05MB6674:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB667405B302EB629798B4DE81D5C40@AM0PR05MB6674.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:418;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfjzJ0px16MLbqdnbE+KQXItisDauaP9jF21u43JMav44ar5M1VSW9TcmYgMvbCmgOe9733qsDZcHwM74CoSGlv3jDCBdBTmukueIrSxi3YhVJtusrEx70gIb95MdQ7vZlS3GYq6qnyQiGNszAa/YgE65WyIdIhveUMuaCWVgaZuHr9bTd4OhfgHEa5wS4lnMEU4kpH1L9j5fMGWyHwquDHnXtUUq6y35AUOjvaTBvUQCH2H2kFQvmZ2SqS5IgCe7IDhvJ4i79SzxFzS+One4csDLyCtVPDnLchdmxc9KggR2xY/ItbmbS4+YIA7DoWwhqGOABfzyIOgmVFBXEEAeg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(6916009)(316002)(86362001)(66476007)(2906002)(8936002)(5660300002)(2616005)(6512007)(6486002)(1076003)(4326008)(7416002)(6666004)(6506007)(36756003)(66556008)(26005)(8676002)(956004)(83380400001)(186003)(16526019)(66946007)(52116002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?V79DQ0rOS5s+X+0i25D8gLEZJgvYDhEJh3obEW1gUsgHaPSCo9gD+NadrsSB?=
 =?us-ascii?Q?O7uT0QeWuFNoc5q0Pypx9K9nY6wFyYPMsObpe4aT9b0HUw1PXE8kng96RzXg?=
 =?us-ascii?Q?v3YuUxS/CqfdtV6cEi6s8NIfWDgdPfQovQ4cWrL01oAsBfEoeq/4GN5t4DKn?=
 =?us-ascii?Q?0BILHiuk/1sgYskLip617mTCLkYUP93OtlyKJg5YTo/cHcUoFIQPOunc9jl/?=
 =?us-ascii?Q?79kRi4XcloA/7aIDI3H7U3gbtMNwQmoOgRrVkvBm2zCVzES0I2X7fN/g1aqL?=
 =?us-ascii?Q?EZXmdzpkYGSbZ0vNu0hh5Sb+Was/ovoj2+j6k+AzJzEPeM/Z4elV4Gk1KU2v?=
 =?us-ascii?Q?JE0l3gBY6FdfVNGbSXgBBrfURmflDrYs2NG5uU/oAnkSoFC7QXFtTi8Wg1XP?=
 =?us-ascii?Q?lKVm149jRSxjU8MHcg9q7FbdpcHZFICWDSv9KUliQhjlNOx11P+39RWKbGj8?=
 =?us-ascii?Q?1Pwbl/BndDdTGPqNStXASPlEYtvJ2TKMvbFyvuOkwMOLYUIF1j7OVRBPM3lr?=
 =?us-ascii?Q?b3Rd4qrFFcDVd7EUjjpVIkByjoOY+5Kw2shS/l97leDKGneEbz70O3dNDDtX?=
 =?us-ascii?Q?Q0CYScA6e3C0pveQrR6qu3jsuD94VygRzFU/ECJD+Nbm4+3wUJ47UUerezNy?=
 =?us-ascii?Q?QLnTAQoFlw2xp0P1DGtaihCjkivB09bTuXVV9KW7jYFmrKKZOxCONJUOqCYS?=
 =?us-ascii?Q?cuhHx19hV7FVp7O5h10qXCJhvu176+jzaMxsd+IVKHOwFqnQpAaj5xsffWuU?=
 =?us-ascii?Q?GIzTFk6wPyzjQUaV8JDWhrr4drLIKkE2X4bB2KDmQbFSKqoXXknEFnmbyW2M?=
 =?us-ascii?Q?5+qSnLs6tg4prw1i5Wufqf6NsTJ4nauX9SPp62J7JGXCwloTs1SJRpeCUswa?=
 =?us-ascii?Q?hckdt0E0TToTTYl9k0s3W0qO7MOzzS6wTWtwxAabhzvbkf5hz/hOFSG+aPXA?=
 =?us-ascii?Q?tLxspr8g4UAgZ8sFBy3pwka/+bnF3SBo1mKZ1q2Gz0Ln49XEUkxNKam9zf5v?=
 =?us-ascii?Q?TrmR?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 08:57:30.0029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 91751c37-9e9f-4f2f-7df5-08d8a269c901
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UPaVBz61i9SLapInVXa3LV1s8lWL94ep6TXQPdVyt09WaZ2QTfkAGbv6CbGOhcweEEUx21dJEj1NBeZaPrOoZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6674
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Some speeds can be achieved with different number of lanes. For example,
100Gbps can be achieved using two lanes of 50Gbps or four lanes of
25Gbps. This patch set adds a new selector that allows ethtool to
advertise link modes according to their number of lanes and also force a
specific number of lanes when autonegotiation is off.

Advertising all link modes with a speed of 100Gbps that use two lanes:

# ethtool -s swp1 speed 100000 lanes 2 autoneg on

Forcing a speed of 100Gbps using four lanes:

# ethtool -s swp1 speed 100000 lanes 4 autoneg off

Patch set overview:

Patch #1 allows user space to configure the desired number of lanes.

Patch #2-#3 adjusts ethtool to dump to user space the number of lanes
currently in use.

Patches #4-#6 add support for lanes configuration in mlxsw.

Patch #7 adds a selftest.

v2:
	* Patch #1:Remove ETHTOOL_LANES defines and simply use a number
	  instead.
	* Patches #2,#6: Pass link mode from driver to ethtool instead of
	  the parameters themselves.
	* Patch #5: Add an actual width field for spectrum-2 link modes
	  in order to set the suitable link mode when lanes parameter is
	  passed.
	* Patch #6: Changed lanes to be unsigned in
	  'struct link_mode_info'.
	* Patch #7: Remove the test for recieving max_width when lanes is
	  not set by user. When not setting lanes, we don't promise
	  anything regarding what number of lanes will be chosen.

Danielle Ratson (7):
  ethtool: Extend link modes settings uAPI with lanes
  ethtool: Get link mode in use instead of speed and duplex parameters
  ethtool: Expose the number of lanes in use
  mlxsw: ethtool: Remove max lanes filtering
  mlxsw: ethtool: Add support for setting lanes when autoneg is off
  mlxsw: ethtool: Pass link mode in use to ethtool
  net: selftests: Add lanes setting test

 Documentation/networking/ethtool-netlink.rst  |  12 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  13 +-
 .../mellanox/mlxsw/spectrum_ethtool.c         | 168 +++++----
 include/linux/ethtool.h                       |   5 +
 include/uapi/linux/ethtool.h                  |   4 +
 include/uapi/linux/ethtool_netlink.h          |   1 +
 net/ethtool/linkmodes.c                       | 321 +++++++++++-------
 net/ethtool/netlink.h                         |   2 +-
 .../selftests/net/forwarding/ethtool_lanes.sh | 186 ++++++++++
 .../selftests/net/forwarding/ethtool_lib.sh   |  34 ++
 tools/testing/selftests/net/forwarding/lib.sh |  28 ++
 11 files changed, 570 insertions(+), 204 deletions(-)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lanes.sh

-- 
2.26.2

