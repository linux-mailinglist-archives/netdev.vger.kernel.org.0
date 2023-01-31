Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CE72682872
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjAaJOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbjAaJNt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:13:49 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20607.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::607])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CD2B3C2AF
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 01:11:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9FBsKNv4cIccjX26xFgHLWf9GniPUHe20rBX6BWU/iy61gvDlJl1DCmAqau7r6x73u8WMT83dmLSYk6pX1LLDrQgmuvccYOS5DCf0+w1jxDRz5W95m7HNTXkpjUqkDAIoLz4q1OhOiMc9I48cQtWQlKSO8BgxyiDP03YSLV461y4yhS2JTjHPibAxL+melTuKygsPgyV8G+EB38tMaeIMb2B2Vubg1t2dKSvOyK9xmEXAPjs60XSF3fBqvZMhMc9gwyl3Tv2yTAFgWSeQqxozwtaEWYG20dj9KZHopSmhnbqRKgkJWp3RjuQZ5Qn1VYt58QxJ6lUR9jhgo3krV75w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=62blDj6gscfyyZ7Dt1HF8PX61uufi0dzfMhHtZT9ksQ=;
 b=Jp7OaShTCNfLaJylXS/bN+yIK7nwB37bOAUVDYBNKQsJSGmeqdj9tcHu92K9GxVu9dVcVSd6UQilE9amMlvqsTngqoWpOLevtH6DQ6e6rd7U+Y0D3JiP9q+3cXOmxO1sU2Z5cu6l6qSw35pMbtTNskUrV+nOR/n9V3cLNpFi+DlE/AqWy/S/LXyPBkEiryOyKgJLZpuFSjmnt9W1zhB3jbmXwXZvsK+H4mVEjZyItB0d2aVMFZZL52Wg5bytSk2ZtoKRYwqzNi5F2lDhXxHFvIHxtJhX1xW58iSpoY6ODQ7iLkfsjA+Pj+3D5ANEs96qg9v6LED6bKxDx4pwP+JCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62blDj6gscfyyZ7Dt1HF8PX61uufi0dzfMhHtZT9ksQ=;
 b=kVVG/wnOCM434boAAuocFiGENUm0ZEVkUCq0rC1B6q7Rb2wIA2MDMd0Qj/udHfcGHG10l4U61TTr8ywZICEf24pQJ1+try9iMsS9lfTeERbRpSPj9z68pWi8jrODI9604Y5eQoM6X1EgUVTUhcjuIuhbbM1ODSEAp6LYTyjd9AJS8MPP2aupE4nDvOwSd7z0TddNCzLMAeqlv1EzV0GeonR+25WzgPyAv/ATyhdoShydJBtF7TkdcCMXFRSx4TjOb5mtWWJN7XXZPljk94gx7CFTMEMGGs8B8V9lIz/Q9j4pgksWKZHwNcUj/pJhnHO6JNvy4OhZ0wbw0rM2w6Md8w==
Received: from BN1PR14CA0030.namprd14.prod.outlook.com (2603:10b6:408:e3::35)
 by DM6PR12MB4465.namprd12.prod.outlook.com (2603:10b6:5:28f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Tue, 31 Jan
 2023 09:11:01 +0000
Received: from BL02EPF000108E8.namprd05.prod.outlook.com
 (2603:10b6:408:e3:cafe::eb) by BN1PR14CA0030.outlook.office365.com
 (2603:10b6:408:e3::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 09:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BL02EPF000108E8.mail.protection.outlook.com (10.167.241.201) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.17 via Frontend Transport; Tue, 31 Jan 2023 09:11:00 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 31 Jan
 2023 01:10:41 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Tue, 31 Jan 2023 01:10:38 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v7 0/6] net/sched: cls_api: Support hardware miss to tc action
Date:   Tue, 31 Jan 2023 11:10:21 +0200
Message-ID: <20230131091027.8093-1-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000108E8:EE_|DM6PR12MB4465:EE_
X-MS-Office365-Filtering-Correlation-Id: c8b17664-5fff-419d-c820-08db036b127c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gsxPICzM2O3WvvTngLsMu4Kf/KNi7pJmFNAc/nw1tc5NuFCrlx+X/9fNjjdZv1ejpEMm3BSC0pyQFruEuRCo5xeMGGo93f2zbJdhVln3JeiQma5daAT4heK1aCG0QhQbHLGdK4i/kyTvfzfXw5JqJ8MB1T6PJUqBd7uiWYD2CroElCdlDHEl/sdLR60WE1qVdH0EBFDWt9gDuglCTs8Hvd1u2UHaET1kbBZol4nqHkekntFVjOXnRHfIdbaIHzn1Ba4RbxPZcdf4Rc8EQv+n6L6Q9rgQiaeadTaVFdAOjEx+RAWWjgU5OrVYNcLNTAADgOrDW4nQaCQXcOa4uBaGzbnVRVOt09rRHBsXFiXpo8empCVbg8Q/nlWkYkFw/IcPxDqa2JLAw79tz3phMibPaePfCREpoBA5AQufmFu4DhHwiRse7wYjghm/KB1hvwVqfeGCq/sk/Tix1eb5/VyfQEujVS5wwqocFsblZYKdIxMc5Dw3cjmnO5sGuMc58nd5nl8kbDG5hWCu3u6+RNOUn3XtiUkvWc/VqWDJ3pWk1SqTjQ4Ea5zyCtpEpKD/PKj8iLCkB9IPhj/QHrq9YC5elXno/YuJVpu5R/5jvqKkqjAU+RRAXcSI+Nb8DDkfmECKeINbh9RIzF4dOGbzM7uf2cEs5GRZaUyvn/CY0q0ihvfe4PSxnRUYgyZ+mujJwLmZstt5zqfMI5Jvikai7PLpxg==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199018)(40470700004)(46966006)(36840700001)(8676002)(70586007)(70206006)(336012)(2616005)(83380400001)(47076005)(316002)(426003)(110136005)(40460700003)(54906003)(478600001)(107886003)(6666004)(36756003)(186003)(1076003)(26005)(86362001)(7636003)(356005)(2906002)(4326008)(82310400005)(40480700001)(5660300002)(82740400003)(8936002)(41300700001)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 09:11:00.7577
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c8b17664-5fff-419d-c820-08db036b127c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000108E8.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4465
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds support for hardware miss to instruct tc to continue execution
in a specific tc action instance on a filter's action list. The mlx5 driver patch
(besides the refactors) shows its usage instead of using just chain restore.

Currently a filter's action list must be executed all together or
not at all as driver are only able to tell tc to continue executing from a
specific tc chain, and not a specific filter/action.

This is troublesome with regards to action CT, where new connections should
be sent to software (via tc chain restore), and established connections can
be handled in hardware.

Checking for new connections is done when executing the ct action in hardware
(by checking the packet's tuple against known established tuples).
But if there is a packet modification (pedit) action before action CT and the
checked tuple is a new connection, hardware will need to revert the previous
packet modifications before sending it back to software so it can
re-match the same tc filter in software and re-execute its CT action.

The following is an example configuration of stateless nat
on mlx5 driver that isn't supported before this patchet:

 #Setup corrosponding mlx5 VFs in namespaces
 $ ip netns add ns0
 $ ip netns add ns1
 $ ip link set dev enp8s0f0v0 netns ns0
 $ ip netns exec ns0 ifconfig enp8s0f0v0 1.1.1.1/24 up
 $ ip link set dev enp8s0f0v1 netns ns1
 $ ip netns exec ns1 ifconfig enp8s0f0v1 1.1.1.2/24 up

 #Setup tc arp and ct rules on mxl5 VF representors
 $ tc qdisc add dev enp8s0f0_0 ingress
 $ tc qdisc add dev enp8s0f0_1 ingress
 $ ifconfig enp8s0f0_0 up
 $ ifconfig enp8s0f0_1 up

 #Original side
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp dst_port 8888 \
      action pedit ex munge tcp dport set 5001 pipe \
      action csum ip tcp pipe \
      action ct pipe \
      action goto chain 1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+est \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 1 proto ip flower \
    ct_state +trk+new \
      action ct commit pipe \
      action mirred egress redirect dev enp8s0f0_1
 $ tc filter add dev enp8s0f0_0 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_1

 #Reply side
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto arp flower \
      action mirred egress redirect dev enp8s0f0_0
 $ tc filter add dev enp8s0f0_1 ingress chain 0 proto ip flower \
    ct_state -trk ip_proto tcp \ 
      action ct pipe \
      action pedit ex munge tcp sport set 8888 pipe \
      action csum ip tcp pipe \
      action mirred egress redirect dev enp8s0f0_0

 #Run traffic
 $ ip netns exec ns1 iperf -s -p 5001&
 $ sleep 2 #wait for iperf to fully open
 $ ip netns exec ns0 iperf -c 1.1.1.2 -p 8888

 #dump tc filter stats on enp8s0f0_0 chain 0 rule and see hardware packets:
 $ tc -s filter show dev enp8s0f0_0 ingress chain 0 proto ip | grep "hardware.*pkt"
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt
        Sent hardware 9310116832 bytes 6149672 pkt

A new connection executing the first filter in hardware will first rewrite
the dst port to the new port, and then the ct action is executed,
because this is a new connection, hardware will need to be send this back
to software, on chain 0, to execute the first filter again in software.
The dst port needs to be reverted otherwise it won't re-match the old
dst port in the first filter. Because of that, currently mlx5 driver will
reject offloading the above action ct rule.

This series adds supports partial offload of a filter's action list,
and letting tc software continue processing in the specific action instance
where hardware left off (in the above case after the "action pedit ex munge tcp
dport... of the first rule") allowing support for scenarios such as the above.

Changelog:
	v1->v2:
	Fixed compilation without CONFIG_NET_CLS
	Cover letter re-write

	v2->v3:
	Unlock spin_lock on error in cls flower filter handle refactor
	Cover letter

	v3->v4:
	Silence warning by clang

	v4->v5:
	Cover letter example
	Removed ifdef as much as possible by using inline stubs

	v5->v6:
	Removed new inlines in cls_api.c (bot complained in patchwork)
	Added reviewed-by/ack - Thanks!

	v6->v7:
	Removed WARN_ON from pkt path (leon)
	Removed unnecessary return in void func

Paul Blakey (6):
  net/sched: cls_api: Support hardware miss to tc action
  net/sched: flower: Move filter handle initialization earlier
  net/sched: flower: Support hardware miss to tc action
  net/mlx5: Refactor tc miss handling to a single function
  net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
  net/mlx5e: TC, Set CT miss to the specific ct action instance

 .../ethernet/mellanox/mlx5/core/en/rep/tc.c   | 224 ++------------
 .../mellanox/mlx5/core/en/tc/sample.c         |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.c    |  32 +-
 .../ethernet/mellanox/mlx5/core/en/tc_ct.h    |   2 +
 .../net/ethernet/mellanox/mlx5/core/en_rx.c   |   4 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 276 ++++++++++++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.h   |  21 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   2 +
 .../mellanox/mlx5/core/lib/fs_chains.c        |  14 +-
 include/linux/skbuff.h                        |   6 +-
 include/net/flow_offload.h                    |   1 +
 include/net/pkt_cls.h                         |  34 ++-
 include/net/sch_generic.h                     |   2 +
 net/openvswitch/flow.c                        |   3 +-
 net/sched/act_api.c                           |   2 +-
 net/sched/cls_api.c                           | 213 +++++++++++++-
 net/sched/cls_flower.c                        |  73 +++--
 17 files changed, 597 insertions(+), 314 deletions(-)

-- 
2.30.1

