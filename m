Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEA0438054
	for <lists+netdev@lfdr.de>; Sat, 23 Oct 2021 00:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhJVWnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 18:43:39 -0400
Received: from mail-db8eur05on2074.outbound.protection.outlook.com ([40.107.20.74]:32992
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231730AbhJVWni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 18:43:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qcn5jjMe3jVQ83j5lfcwZmOfiD96TFycsg5l1hqeC8gH3e8znBclzbaJHRnNdYsVIGw4qgW8SvvygqiRpnVN4egPsZCSit+CIxLRp6WNj8kc2CJb0frV89kNDi0IpO94gUPmOQ2+wGvjM/PUvN9L6YCzBH0L7CDFe3IfCaH+psAZCiX8UpfjTR7wjVivK+MsVQsOpBUQ+inOMCDg7cBMrdKqgtSD1j8M6BKOfLnWtOlUMVbKVew7QiHOP5lKF7o+hiEqavVnNm/VLVbqYJoi8M4pToD4aTIPyXn3PzbnjWMqtNhgjwUaDZ+96FS1fVbq/EeVoKZvNrvWYSHIJTOJcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O0voikrgDQbVIkRyjfiUV74I6cb8Hat6wuOHa3lkh50=;
 b=VjfMqHNKMI49+99uUrK1WmP61M1R2uhfo06Pb/+S52FpnSTHRn9Ej0YWiQoKfJoq5yinNBzmypp89puNy8YSqMz/K8rRi/2J+s742Gi6Mcv9KYjvEJeu+A4qmIphjwBgy1lPGm3hGmJ0eGCLw+57xEIQcjMSAmjMCXuNXmsLizoNTAlFzX9BzZu0amPviBhgIuWt9CWBJfAquSDhgbKz9ClAzjeB1JiDg0dGzd89GN7bLEsk4veZNVxy/0B95l0HcIerh3W/YiCYhcx+XHqAmwvlNXqRmynh7J1FLtXz6kuhk8ytTh3ofq8Ob7jXquG54A1Iwv/P2VuhoJIsmeCLFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=secospa.onmicrosoft.com; s=selector2-secospa-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O0voikrgDQbVIkRyjfiUV74I6cb8Hat6wuOHa3lkh50=;
 b=iNN1rOXvKUlTRxBRnVIBl/6+VTmKkckEnErIhVifYa7kPowKfjGCTUgpMKdqdcAVKIr6yIdzMdX8x+WuFzdL/vjc7eEhOfXpJcH20eVATsdfMTwhVyw2MNnPtn6vp8H4jtIclycPY7XfaOIcSU8ejRd2hDhr7mCweAzgaBnukTM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com (2603:10a6:10:19::27)
 by DB8PR03MB5673.eurprd03.prod.outlook.com (2603:10a6:10:105::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16; Fri, 22 Oct
 2021 22:41:15 +0000
Received: from DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf]) by DB7PR03MB4523.eurprd03.prod.outlook.com
 ([fe80::a9aa:f363:66e:fadf%6]) with mapi id 15.20.4628.018; Fri, 22 Oct 2021
 22:41:15 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-rdma@vger.kernel.org, Sean Anderson <sean.anderson@seco.com>
Subject: [net-next PATCH] net: convert users of bitmap_foo() to linkmode_foo()
Date:   Fri, 22 Oct 2021 18:41:04 -0400
Message-Id: <20211022224104.3541725-1-sean.anderson@seco.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAPR03CA0120.namprd03.prod.outlook.com
 (2603:10b6:208:32a::35) To DB7PR03MB4523.eurprd03.prod.outlook.com
 (2603:10a6:10:19::27)
MIME-Version: 1.0
Received: from plantagenet.inhand.com (50.195.82.171) by BLAPR03CA0120.namprd03.prod.outlook.com (2603:10b6:208:32a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 22:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23cb986c-62f9-4111-03e2-08d995ad0e58
X-MS-TrafficTypeDiagnostic: DB8PR03MB5673:
X-Microsoft-Antispam-PRVS: <DB8PR03MB5673151E3F976E956C2CA59596809@DB8PR03MB5673.eurprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3173;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkAWxw5sndWeMpfnJbIDVk3wUODQp8E4YST24klw4oPrj+PViK2lykW0PnB82O9c7PX4385N+HceNn4KvV6JBABssUI/tzJ2NAUrGYYSpZRLk6NFb6H/UonfaBFTTMegrAQL6im8hMYRLE1ljuMPKsW/8kjpwhgnM439W+gnPfzdj2W2ylpO+dPFuvCsVUVh5+cdsyWr2YVj5WyjQ42ArRbuPRTHNthewBr8tbk+xfHukZfRlQDu8ieFVjlIRIR09/aQ0+mfn3FrwqABSS4dzpezbycq9p8SVB8I+15u34Ty8L5bCyM9BxFRz7DHg5KpxxEX8bP3b33wvf56lwSY8OpPQM+HR8INxalESCw6sXp7vXi0Nr5JXCnyJkaVmweAiu0pSIOyH4ysT1L5egvFSsf6HF/rAp46OUAmen1azupfr6Cd+vVzNGrPNMaoQ4O2SRGC9F3ESuxg//XFB/F4HI7MRlMyjHEJvHciKQqMTg5o4dLCWwq6R8k289ND1R0juFBflXB/VrNi7KyoWy4PfIh887ytuJntAexLz/DcmW0qiM5MnMbE8kBdH2LTYJyY2m/Kg3MQa0WJhpWdkl+CckW0Am5AJEdyTSSYgwPuLh9X6ruS03zuHAKClACbDBx70s7T+Ab7LKGTjy4V/WjFbX7QrejOGVijS8xrHqaKGcnRB+SylIRekXgd+3XYJGGlSKoZGYaW+9YDcITQMj7laQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4523.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(6666004)(186003)(6506007)(6916009)(1076003)(66476007)(36756003)(107886003)(38350700002)(6512007)(30864003)(6486002)(8936002)(66556008)(8676002)(54906003)(52116002)(316002)(2906002)(38100700002)(86362001)(26005)(508600001)(66946007)(956004)(4326008)(2616005)(83380400001)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3uOYDCf7GAEhXYsGOzkddRREqRxNL800E4VPTlWlLMZiMjHrUvx0l41Ah0FQ?=
 =?us-ascii?Q?mdcrx3PtRVxmtZfOhNTmu/Dloh4ji0sk5nh6GeP5fWv8hdaZUu9WMtVl482H?=
 =?us-ascii?Q?+QdzuwLZuNgCoSwOzpAaIOLOVLF0GydPn+JO5L1Lp/91pIL/k3yqpBqvJ8s/?=
 =?us-ascii?Q?DAqRRXarutJV0mTXhefQE1OF1ZK1U2YsWv1NA0q1TBpEb/BZzqtCn1lMEqAO?=
 =?us-ascii?Q?32IfT3OhXQvhyhcDEHrGXPA0+vpbh5QbGECLBX47QCRIpmcMG++m/aEn/YNH?=
 =?us-ascii?Q?Z1vlQ61iOMhndRvHB+aSnDFhMajZSSz0L3JTsaCP4EU2EaPv42y0cApr5YBB?=
 =?us-ascii?Q?OZDzqL8STZC3ptb9GfEmezxy2zsWV8Umcf8ExCKev8atP9dn6rkGV+8Giq96?=
 =?us-ascii?Q?iHcDuK5xyJpri3mznbgSUbFXAHWR7j4Txm3skLzEq8lmnhJG/tyzOwOZ7MRo?=
 =?us-ascii?Q?BYSqL6ZmaecfcId2eKHxRduAH6ppp6hhm4N8r4+pPC2zB8tWj1dZdUu9nkRH?=
 =?us-ascii?Q?D/P12MSkHKXLFKA+GlAOCBEtyorQVW9uX/mJ9y6hRKvheDfbbICq+G92OthD?=
 =?us-ascii?Q?RkBnJ3GiTJgZyo3OyGW978Otq6s30JYwlUwbVklXF7NESyx/Q/HAIhvfKLeq?=
 =?us-ascii?Q?OMs1gg7dj5PdhU2f4QqgPjZT3beZNWSJcCj34QSKIj+WyRHx6CdCNVrQh7R5?=
 =?us-ascii?Q?RAUKC/le+jNjITcp7NzHYdu61Ya12helwOmx7bmHIMo+7jWxLn7Ru8ihuNeN?=
 =?us-ascii?Q?IXuD+lzHKOLJ1qixccnRhZTvAxXg4lYNGfFdmRjB5fONQxhX78vfNRTgbcDS?=
 =?us-ascii?Q?oIzR01qCrn+xgWZLVU5EoNkpcuhzoJeIMwc9qTbhYIdGRrOCmcdYcqPn3RyV?=
 =?us-ascii?Q?RM4kxD9+Wd1Hr/glSYxJ+hrMEZMolp5KemO/MSsjXWbeltj/TCrFSZyrix96?=
 =?us-ascii?Q?0zVunVdbNNFB4NzR/TADW7CNt2nFwf+f/g8SDS/MPCkyEYrdqwxVAOA0L1Ks?=
 =?us-ascii?Q?yCo28GwtbYQWLHHUDoXn0gt1pCJt2NCORN5yeKB8qWbPVzyIjlX1nZTC4Fdy?=
 =?us-ascii?Q?YSfSJZa6Rcvh2xgEzKwUsRTaVROPM7O3VX3i/533VLevwMSc7Kn0aiUyUlmQ?=
 =?us-ascii?Q?HR4P0s8dRcD7Yzxth9S7lA+aW4q9ka9IpV1W5trSRiaFz0BkVwg7kc5/Db6w?=
 =?us-ascii?Q?YO5s7YuwMEELvkjUuT2npwAZuUE+qn7UPCMx2aJVpcunomhROEgtYFZw+PVX?=
 =?us-ascii?Q?YqQLahpG6ubs66NS413tptX0ra8kYK7zSNfpbJ/UoPaGT0kQTA1S4rox18F+?=
 =?us-ascii?Q?YJrH4mCjc/q9uEbEEe6taub3rjpT7Nng6hOYI8SVbGcvsma3CJiWpj3ATw1I?=
 =?us-ascii?Q?uSrl8VvrepLw1OlHgn+z4qPkzKIO8MRQd3Er8TLAbmMLcVCvTQEUWqEDwc0q?=
 =?us-ascii?Q?EuBFOAL7mznr7AGuwcdpLXA/9oH0JtWu?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23cb986c-62f9-4111-03e2-08d995ad0e58
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4523.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 22:41:15.5134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sean.anderson@seco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR03MB5673
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts instances of
	bitmap_foo(args..., __ETHTOOL_LINK_MODE_MASK_NBITS)
to
	linkmode_foo(args...)

I manually fixed up some lines to prevent them from being excessively
long. Otherwise, this change was generated with the following semantic
patch:

// Generated with
// echo linux/linkmode.h > includes
// git grep -Flf includes include/ | cut -f 2- -d / | cat includes - \
// | sort | uniq | tee new_includes | wc -l && mv new_includes includes
// and repeating until the number stopped going up
@i@
@@

(
 #include <linux/acpi_mdio.h>
|
 #include <linux/brcmphy.h>
|
 #include <linux/dsa/loop.h>
|
 #include <linux/dsa/sja1105.h>
|
 #include <linux/ethtool.h>
|
 #include <linux/ethtool_netlink.h>
|
 #include <linux/fec.h>
|
 #include <linux/fs_enet_pd.h>
|
 #include <linux/fsl/enetc_mdio.h>
|
 #include <linux/fwnode_mdio.h>
|
 #include <linux/linkmode.h>
|
 #include <linux/lsm_audit.h>
|
 #include <linux/mdio-bitbang.h>
|
 #include <linux/mdio.h>
|
 #include <linux/mdio-mux.h>
|
 #include <linux/mii.h>
|
 #include <linux/mii_timestamper.h>
|
 #include <linux/mlx5/accel.h>
|
 #include <linux/mlx5/cq.h>
|
 #include <linux/mlx5/device.h>
|
 #include <linux/mlx5/driver.h>
|
 #include <linux/mlx5/eswitch.h>
|
 #include <linux/mlx5/fs.h>
|
 #include <linux/mlx5/port.h>
|
 #include <linux/mlx5/qp.h>
|
 #include <linux/mlx5/rsc_dump.h>
|
 #include <linux/mlx5/transobj.h>
|
 #include <linux/mlx5/vport.h>
|
 #include <linux/of_mdio.h>
|
 #include <linux/of_net.h>
|
 #include <linux/pcs-lynx.h>
|
 #include <linux/pcs/pcs-xpcs.h>
|
 #include <linux/phy.h>
|
 #include <linux/phy_led_triggers.h>
|
 #include <linux/phylink.h>
|
 #include <linux/platform_data/bcmgenet.h>
|
 #include <linux/platform_data/xilinx-ll-temac.h>
|
 #include <linux/pxa168_eth.h>
|
 #include <linux/qed/qed_eth_if.h>
|
 #include <linux/qed/qed_fcoe_if.h>
|
 #include <linux/qed/qed_if.h>
|
 #include <linux/qed/qed_iov_if.h>
|
 #include <linux/qed/qed_iscsi_if.h>
|
 #include <linux/qed/qed_ll2_if.h>
|
 #include <linux/qed/qed_nvmetcp_if.h>
|
 #include <linux/qed/qed_rdma_if.h>
|
 #include <linux/sfp.h>
|
 #include <linux/sh_eth.h>
|
 #include <linux/smsc911x.h>
|
 #include <linux/soc/nxp/lpc32xx-misc.h>
|
 #include <linux/stmmac.h>
|
 #include <linux/sunrpc/svc_rdma.h>
|
 #include <linux/sxgbe_platform.h>
|
 #include <net/cfg80211.h>
|
 #include <net/dsa.h>
|
 #include <net/mac80211.h>
|
 #include <net/selftests.h>
|
 #include <rdma/ib_addr.h>
|
 #include <rdma/ib_cache.h>
|
 #include <rdma/ib_cm.h>
|
 #include <rdma/ib_hdrs.h>
|
 #include <rdma/ib_mad.h>
|
 #include <rdma/ib_marshall.h>
|
 #include <rdma/ib_pack.h>
|
 #include <rdma/ib_pma.h>
|
 #include <rdma/ib_sa.h>
|
 #include <rdma/ib_smi.h>
|
 #include <rdma/ib_umem.h>
|
 #include <rdma/ib_umem_odp.h>
|
 #include <rdma/ib_verbs.h>
|
 #include <rdma/iw_cm.h>
|
 #include <rdma/mr_pool.h>
|
 #include <rdma/opa_addr.h>
|
 #include <rdma/opa_port_info.h>
|
 #include <rdma/opa_smi.h>
|
 #include <rdma/opa_vnic.h>
|
 #include <rdma/rdma_cm.h>
|
 #include <rdma/rdma_cm_ib.h>
|
 #include <rdma/rdmavt_cq.h>
|
 #include <rdma/rdma_vt.h>
|
 #include <rdma/rdmavt_qp.h>
|
 #include <rdma/rw.h>
|
 #include <rdma/tid_rdma_defs.h>
|
 #include <rdma/uverbs_ioctl.h>
|
 #include <rdma/uverbs_named_ioctl.h>
|
 #include <rdma/uverbs_std_types.h>
|
 #include <rdma/uverbs_types.h>
|
 #include <soc/mscc/ocelot.h>
|
 #include <soc/mscc/ocelot_ptp.h>
|
 #include <soc/mscc/ocelot_vcap.h>
|
 #include <trace/events/ib_mad.h>
|
 #include <trace/events/rdma_core.h>
|
 #include <trace/events/rdma.h>
|
 #include <trace/events/rpcrdma.h>
|
 #include <uapi/linux/ethtool.h>
|
 #include <uapi/linux/ethtool_netlink.h>
|
 #include <uapi/linux/mdio.h>
|
 #include <uapi/linux/mii.h>
)

@depends on i@
expression list args;
@@

(
- bitmap_zero(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_zero(args)
|
- bitmap_copy(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_copy(args)
|
- bitmap_and(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_and(args)
|
- bitmap_or(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_or(args)
|
- bitmap_empty(args, ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_empty(args)
|
- bitmap_andnot(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_andnot(args)
|
- bitmap_equal(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_equal(args)
|
- bitmap_intersects(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_intersects(args)
|
- bitmap_subset(args, __ETHTOOL_LINK_MODE_MASK_NBITS)
+ linkmode_subset(args)
)

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---
Because this touches so many files in the net tree, you may want to
generate a new diff using the semantic patch above when you apply this.
To apply the semantic patch, create a file containing

        #define __ETHTOOL_DECLARE_LINK_MODE_MASK(name)
                unsigned long name[8]

and pass it spatch with --macro-file.

 drivers/net/dsa/b53/b53_common.c              |  6 ++----
 drivers/net/dsa/bcm_sf2.c                     |  8 +++-----
 drivers/net/dsa/hirschmann/hellcreek.c        |  6 ++----
 drivers/net/dsa/lantiq_gswip.c                | 14 ++++++-------
 drivers/net/dsa/microchip/ksz8795.c           |  8 +++-----
 drivers/net/dsa/mv88e6xxx/chip.c              |  5 ++---
 drivers/net/dsa/ocelot/felix_vsc9959.c        |  8 +++-----
 drivers/net/dsa/ocelot/seville_vsc9953.c      |  8 +++-----
 drivers/net/dsa/qca/ar9331.c                  | 10 ++++------
 drivers/net/dsa/sja1105/sja1105_main.c        |  7 +++----
 drivers/net/dsa/xrs700x/xrs700x.c             |  8 +++-----
 drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c  |  8 +++-----
 drivers/net/ethernet/atheros/ag71xx.c         |  8 +++-----
 drivers/net/ethernet/cadence/macb_main.c      | 11 +++++-----
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  8 +++-----
 .../net/ethernet/huawei/hinic/hinic_ethtool.c | 10 ++++------
 .../net/ethernet/intel/ixgbe/ixgbe_ethtool.c  |  5 ++---
 drivers/net/ethernet/marvell/mvneta.c         | 10 ++++------
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  7 +++----
 .../marvell/octeontx2/nic/otx2_ethtool.c      |  5 ++---
 drivers/net/ethernet/marvell/pxa168_eth.c     |  3 +--
 .../net/ethernet/mellanox/mlx4/en_ethtool.c   | 20 +++++++------------
 .../microchip/sparx5/sparx5_phylink.c         |  7 +++----
 drivers/net/ethernet/mscc/ocelot_net.c        |  7 +++----
 .../ethernet/pensando/ionic/ionic_ethtool.c   |  3 +--
 .../net/ethernet/xilinx/xilinx_axienet_main.c |  8 +++-----
 drivers/net/pcs/pcs-xpcs.c                    |  2 +-
 drivers/net/phy/sfp-bus.c                     |  2 +-
 net/ethtool/ioctl.c                           |  7 +++----
 29 files changed, 86 insertions(+), 133 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06279ba64cc8..51dfaf817a40 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1343,10 +1343,8 @@ void b53_phylink_validate(struct dsa_switch *ds, int port,
 		phylink_set(mask, 100baseT_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	phylink_helper_basex_speed(state);
 }
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index a86ddc4bb897..13aa43b5cffd 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -685,7 +685,7 @@ static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
 	    state->interface != PHY_INTERFACE_MODE_GMII &&
 	    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
 	    state->interface != PHY_INTERFACE_MODE_MOCA) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		if (port != core_readl(priv, CORE_IMP0_PRT_ID))
 			dev_err(ds->dev,
 				"Unsupported interface: %d for port %d\n",
@@ -713,10 +713,8 @@ static void bcm_sf2_sw_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void bcm_sf2_sw_mac_config(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 354655f9ed00..4e0b53d94b52 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -1403,10 +1403,8 @@ static void hellcreek_phylink_validate(struct dsa_switch *ds, int port,
 	else
 		phylink_set(mask, 1000baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static int
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173f..a3e937a371ef 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -1447,10 +1447,8 @@ static void gswip_phylink_set_capab(unsigned long *supported,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
@@ -1478,7 +1476,7 @@ static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
 			goto unsupported;
 		break;
 	default:
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		dev_err(ds->dev, "Unsupported port: %i\n", port);
 		return;
 	}
@@ -1488,7 +1486,7 @@ static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
 	return;
 
 unsupported:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
 		phy_modes(state->interface), port);
 }
@@ -1518,7 +1516,7 @@ static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
 			goto unsupported;
 		break;
 	default:
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		dev_err(ds->dev, "Unsupported port: %i\n", port);
 		return;
 	}
@@ -1528,7 +1526,7 @@ static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
 	return;
 
 unsupported:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
 		phy_modes(state->interface), port);
 }
diff --git a/drivers/net/dsa/microchip/ksz8795.c b/drivers/net/dsa/microchip/ksz8795.c
index c5142f86a3c7..43fc3087aeb3 100644
--- a/drivers/net/dsa/microchip/ksz8795.c
+++ b/drivers/net/dsa/microchip/ksz8795.c
@@ -1542,15 +1542,13 @@ static void ksz8_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	return;
 
 unsupported:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 	dev_err(ds->dev, "Unsupported interface: %s, port: %d\n",
 		phy_modes(state->interface), port);
 }
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 8dadcae93c9b..14c678a9e41b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -674,9 +674,8 @@ static void mv88e6xxx_validate(struct dsa_switch *ds, int port,
 	if (chip->info->ops->phylink_validate)
 		chip->info->ops->phylink_validate(chip, port, mask, state);
 
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
 	 * to advertise both, only report advertising at 2500BaseX.
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 11b42fd812e4..45c5ec7a83ea 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -943,7 +943,7 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != ocelot_port->phy_mode) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -965,10 +965,8 @@ static void vsc9959_phylink_validate(struct ocelot *ocelot, int port,
 		phylink_set(mask, 2500baseX_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index de1d34a1f1e4..92eae63150ea 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -999,7 +999,7 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != ocelot_port->phy_mode) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -1018,10 +1018,8 @@ static void vsc9953_phylink_validate(struct ocelot *ocelot, int port,
 		phylink_set(mask, 2500baseX_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static int vsc9953_prevalidate_phy_mode(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/qca/ar9331.c b/drivers/net/dsa/qca/ar9331.c
index a6bfb6abc51a..da0d7e68643a 100644
--- a/drivers/net/dsa/qca/ar9331.c
+++ b/drivers/net/dsa/qca/ar9331.c
@@ -522,7 +522,7 @@ static void ar9331_sw_phylink_validate(struct dsa_switch *ds, int port,
 			goto unsupported;
 		break;
 	default:
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		dev_err(ds->dev, "Unsupported port: %i\n", port);
 		return;
 	}
@@ -536,15 +536,13 @@ static void ar9331_sw_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 100baseT_Half);
 	phylink_set(mask, 100baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	return;
 
 unsupported:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 	dev_err(ds->dev, "Unsupported interface: %d, port: %d\n",
 		state->interface, port);
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1832d4bd3440..e69fdf225c21 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1429,7 +1429,7 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 	 */
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    sja1105_phy_mode_mismatch(priv, port, state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -1449,9 +1449,8 @@ static void sja1105_phylink_validate(struct dsa_switch *ds, int port,
 		phylink_set(mask, 2500baseX_Full);
 	}
 
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static int
diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index 469420941054..910fcb3b252b 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -456,7 +456,7 @@ static void xrs700x_phylink_validate(struct dsa_switch *ds, int port,
 		phylink_set(mask, 1000baseT_Full);
 		break;
 	default:
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		dev_err(ds->dev, "Unsupported port: %i\n", port);
 		return;
 	}
@@ -467,10 +467,8 @@ static void xrs700x_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 10baseT_Full);
 	phylink_set(mask, 100baseT_Full);
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void xrs700x_mac_link_up(struct dsa_switch *ds, int port,
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
index bafc51c34e0b..94879cf8b420 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-ethtool.c
@@ -369,9 +369,8 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
 		  __ETHTOOL_LINK_MODE_MASK_NBITS, cmd->link_modes.advertising,
 		  __ETHTOOL_LINK_MODE_MASK_NBITS, lks->link_modes.supported);
 
-	bitmap_and(advertising,
-		   cmd->link_modes.advertising, lks->link_modes.supported,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(advertising, cmd->link_modes.advertising,
+		     lks->link_modes.supported);
 
 	if ((cmd->base.autoneg == AUTONEG_ENABLE) &&
 	    bitmap_empty(advertising, __ETHTOOL_LINK_MODE_MASK_NBITS)) {
@@ -384,8 +383,7 @@ static int xgbe_set_link_ksettings(struct net_device *netdev,
 	pdata->phy.autoneg = cmd->base.autoneg;
 	pdata->phy.speed = speed;
 	pdata->phy.duplex = cmd->base.duplex;
-	bitmap_copy(lks->link_modes.advertising, advertising,
-		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_copy(lks->link_modes.advertising, advertising);
 
 	if (cmd->base.autoneg == AUTONEG_ENABLE)
 		XGBE_SET_ADV(lks, Autoneg);
diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index ada3a9f0c8c8..88d2ab748399 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1082,14 +1082,12 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 		phylink_set(mask, 1000baseX_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	return;
 unsupported:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 }
 
 static void ag71xx_mac_pcs_get_state(struct phylink_config *config,
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 029dea2873e3..0b9d2b2679da 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -522,21 +522,21 @@ static void macb_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_SGMII &&
 	    state->interface != PHY_INTERFACE_MODE_10GBASER &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
 	if (!macb_is_gem(bp) &&
 	    (state->interface == PHY_INTERFACE_MODE_GMII ||
 	     phy_interface_mode_is_rgmii(state->interface))) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
 	if (state->interface == PHY_INTERFACE_MODE_10GBASER &&
 	    !(bp->caps & MACB_CAPS_HIGH_SPEED &&
 	      bp->caps & MACB_CAPS_PCS)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -570,9 +570,8 @@ static void macb_validate(struct phylink_config *config,
 			phylink_set(mask, 1000baseT_Half);
 	}
 out:
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void macb_usx_pcs_link_up(struct phylink_pcs *pcs, unsigned int mode,
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 64f92770691f..0e87c7043b77 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -942,7 +942,7 @@ static void enetc_pl_mac_validate(struct phylink_config *config,
 	    state->interface != PHY_INTERFACE_MODE_2500BASEX &&
 	    state->interface != PHY_INTERFACE_MODE_USXGMII &&
 	    !phy_interface_mode_is_rgmii(state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -965,10 +965,8 @@ static void enetc_pl_mac_validate(struct phylink_config *config,
 		phylink_set(mask, 2500baseX_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void enetc_pl_mac_config(struct phylink_config *config,
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
index b431c300ef1b..a85667078b72 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_ethtool.c
@@ -322,12 +322,10 @@ static int hinic_get_link_ksettings(struct net_device *netdev,
 		}
 	}
 
-	bitmap_copy(link_ksettings->link_modes.supported,
-		    (unsigned long *)&settings.supported,
-		    __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_copy(link_ksettings->link_modes.advertising,
-		    (unsigned long *)&settings.advertising,
-		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_copy(link_ksettings->link_modes.supported,
+		      (unsigned long *)&settings.supported);
+	linkmode_copy(link_ksettings->link_modes.advertising,
+		      (unsigned long *)&settings.advertising);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
index beda8e0ef7d4..8362822316a9 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ethtool.c
@@ -467,9 +467,8 @@ static int ixgbe_set_link_ksettings(struct net_device *netdev,
 		 * this function does not support duplex forcing, but can
 		 * limit the advertising of the adapter to the specified speed
 		 */
-		if (!bitmap_subset(cmd->link_modes.advertising,
-				   cmd->link_modes.supported,
-				   __ETHTOOL_LINK_MODE_MASK_NBITS))
+		if (!linkmode_subset(cmd->link_modes.advertising,
+				     cmd->link_modes.supported))
 			return -EINVAL;
 
 		/* only allow one speed at a time if no autoneg */
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 98f276c617fb..b6c636592dfa 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3834,14 +3834,14 @@ static void mvneta_validate(struct phylink_config *config,
 	 */
 	if (phy_interface_mode_is_8023z(state->interface)) {
 		if (!phylink_test(state->advertising, Autoneg)) {
-			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			linkmode_zero(supported);
 			return;
 		}
 	} else if (state->interface != PHY_INTERFACE_MODE_NA &&
 		   state->interface != PHY_INTERFACE_MODE_QSGMII &&
 		   state->interface != PHY_INTERFACE_MODE_SGMII &&
 		   !phy_interface_mode_is_rgmii(state->interface)) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -3870,10 +3870,8 @@ static void mvneta_validate(struct phylink_config *config,
 		phylink_set(mask, 100baseT_Full);
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
 	 * to advertise both, only report advertising at 2500BaseX.
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index ad3be55cce68..8ddf58f379ac 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6338,15 +6338,14 @@ static void mvpp2_phylink_validate(struct phylink_config *config,
 		goto empty_set;
 	}
 
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 
 	phylink_helper_basex_speed(state);
 	return;
 
 empty_set:
-	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(supported);
 }
 
 static void mvpp2_xlg_config(struct mvpp2_port *port, unsigned int mode,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index b0f57bda7e27..80d4ce61f442 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -1175,9 +1175,8 @@ static int otx2_set_link_ksettings(struct net_device *netdev,
 	otx2_get_link_ksettings(netdev, &cur_ks);
 
 	/* Check requested modes against supported modes by hardware */
-	if (!bitmap_subset(cmd->link_modes.advertising,
-			   cur_ks.link_modes.supported,
-			   __ETHTOOL_LINK_MODE_MASK_NBITS))
+	if (!linkmode_subset(cmd->link_modes.advertising,
+			     cur_ks.link_modes.supported))
 		return -EINVAL;
 
 	mutex_lock(&mbox->lock);
diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 6c02e1740609..1d607bc6b59e 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -977,8 +977,7 @@ static int pxa168_init_phy(struct net_device *dev)
 	cmd.base.phy_address = pep->phy_addr;
 	cmd.base.speed = pep->phy_speed;
 	cmd.base.duplex = pep->phy_duplex;
-	bitmap_copy(cmd.link_modes.advertising, PHY_BASIC_FEATURES,
-		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_copy(cmd.link_modes.advertising, PHY_BASIC_FEATURES);
 	cmd.base.autoneg = AUTONEG_ENABLE;
 
 	if (cmd.base.speed != 0)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index 66c8ae29bc7a..023df19cee71 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -651,10 +651,8 @@ static unsigned long *ptys2ethtool_link_mode(struct ptys2ethtool_config *cfg,
 		unsigned int i;						\
 		cfg = &ptys2ethtool_map[reg_];				\
 		cfg->speed = speed_;					\
-		bitmap_zero(cfg->supported,				\
-			    __ETHTOOL_LINK_MODE_MASK_NBITS);		\
-		bitmap_zero(cfg->advertised,				\
-			    __ETHTOOL_LINK_MODE_MASK_NBITS);		\
+		linkmode_zero(cfg->supported);				\
+		linkmode_zero(cfg->advertised);				\
 		for (i = 0 ; i < ARRAY_SIZE(modes) ; ++i) {		\
 			__set_bit(modes[i], cfg->supported);		\
 			__set_bit(modes[i], cfg->advertised);		\
@@ -710,10 +708,8 @@ static void ptys2ethtool_update_link_modes(unsigned long *link_modes,
 	int i;
 	for (i = 0; i < MLX4_LINK_MODES_SZ; i++) {
 		if (eth_proto & MLX4_PROT_MASK(i))
-			bitmap_or(link_modes, link_modes,
-				  ptys2ethtool_link_mode(&ptys2ethtool_map[i],
-							 report),
-				  __ETHTOOL_LINK_MODE_MASK_NBITS);
+			linkmode_or(link_modes, link_modes,
+				    ptys2ethtool_link_mode(&ptys2ethtool_map[i], report));
 	}
 }
 
@@ -724,11 +720,9 @@ static u32 ethtool2ptys_link_modes(const unsigned long *link_modes,
 	u32 ptys_modes = 0;
 
 	for (i = 0; i < MLX4_LINK_MODES_SZ; i++) {
-		if (bitmap_intersects(
-			    ptys2ethtool_link_mode(&ptys2ethtool_map[i],
-						   report),
-			    link_modes,
-			    __ETHTOOL_LINK_MODE_MASK_NBITS))
+		ulong *map_mode = ptys2ethtool_link_mode(&ptys2ethtool_map[i],
+							 report);
+		if (linkmode_intersects(map_mode, link_modes))
 			ptys_modes |= 1 << i;
 	}
 	return ptys_modes;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
index af70e2795125..fb74752de0ca 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
@@ -92,12 +92,11 @@ static void sparx5_phylink_validate(struct phylink_config *config,
 		}
 		break;
 	default:
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void sparx5_phylink_mac_config(struct phylink_config *config,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index e3fc4548f642..eaeba60b1bba 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -1509,7 +1509,7 @@ static void vsc7514_phylink_validate(struct phylink_config *config,
 
 	if (state->interface != PHY_INTERFACE_MODE_NA &&
 	    state->interface != ocelot_port->phy_mode) {
-		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(supported);
 		return;
 	}
 
@@ -1528,9 +1528,8 @@ static void vsc7514_phylink_validate(struct phylink_config *config,
 	phylink_set(mask, 2500baseT_Full);
 	phylink_set(mask, 2500baseX_Full);
 
-	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void vsc7514_phylink_mac_config(struct phylink_config *config,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 6b45cae39a20..c54d735b9e2e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -214,8 +214,7 @@ static int ionic_get_link_ksettings(struct net_device *netdev,
 		break;
 	}
 
-	bitmap_copy(ks->link_modes.advertising, ks->link_modes.supported,
-		    __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_copy(ks->link_modes.advertising, ks->link_modes.supported);
 
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_BASER);
 	ethtool_link_ksettings_add_link_mode(ks, supported, FEC_RS);
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0b7606987c1e..9b068b81ae09 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1525,7 +1525,7 @@ static void axienet_validate(struct phylink_config *config,
 			netdev_warn(ndev, "Cannot use PHY mode %s, supported: %s\n",
 				    phy_modes(state->interface),
 				    phy_modes(lp->phy_mode));
-			bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+			linkmode_zero(supported);
 			return;
 		}
 	}
@@ -1558,10 +1558,8 @@ static void axienet_validate(struct phylink_config *config,
 		break;
 	}
 
-	bitmap_and(supported, supported, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
-	bitmap_and(state->advertising, state->advertising, mask,
-		   __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_and(supported, supported, mask);
+	linkmode_and(state->advertising, state->advertising, mask);
 }
 
 static void axienet_mac_pcs_get_state(struct phylink_config *config,
diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 7de631f5356f..cd6742e6ba8b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -646,7 +646,7 @@ void xpcs_validate(struct dw_xpcs *xpcs, unsigned long *supported,
 	if (state->interface == PHY_INTERFACE_MODE_NA)
 		return;
 
-	bitmap_zero(xpcs_supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(xpcs_supported);
 
 	compat = xpcs_find_compat(xpcs->id, state->interface);
 
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index 7362f8c3271c..0c6c0d1843bc 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -373,7 +373,7 @@ void sfp_parse_support(struct sfp_bus *bus, const struct sfp_eeprom_id *id,
 	if (bus->sfp_quirk)
 		bus->sfp_quirk->modes(id, modes);
 
-	bitmap_or(support, support, modes, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_or(support, support, modes);
 
 	phylink_set(support, Autoneg);
 	phylink_set(support, Pause);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index bf6e8c2f9bf7..44430b6ab843 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -336,7 +336,7 @@ EXPORT_SYMBOL(ethtool_intersect_link_masks);
 void ethtool_convert_legacy_u32_to_link_mode(unsigned long *dst,
 					     u32 legacy_u32)
 {
-	bitmap_zero(dst, __ETHTOOL_LINK_MODE_MASK_NBITS);
+	linkmode_zero(dst);
 	dst[0] = legacy_u32;
 }
 EXPORT_SYMBOL(ethtool_convert_legacy_u32_to_link_mode);
@@ -351,11 +351,10 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	if (__ETHTOOL_LINK_MODE_MASK_NBITS > 32) {
 		__ETHTOOL_DECLARE_LINK_MODE_MASK(ext);
 
-		bitmap_zero(ext, __ETHTOOL_LINK_MODE_MASK_NBITS);
+		linkmode_zero(ext);
 		bitmap_fill(ext, 32);
 		bitmap_complement(ext, ext, __ETHTOOL_LINK_MODE_MASK_NBITS);
-		if (bitmap_intersects(ext, src,
-				      __ETHTOOL_LINK_MODE_MASK_NBITS)) {
+		if (linkmode_intersects(ext, src)) {
 			/* src mask goes beyond bit 31 */
 			retval = false;
 		}
-- 
2.25.1

