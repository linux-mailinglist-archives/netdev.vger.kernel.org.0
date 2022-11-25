Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2220B638A48
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:39:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiKYMjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:39:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiKYMit (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:38:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2041.outbound.protection.outlook.com [40.107.244.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3E15217C
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 04:37:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kBUXsAB4SBWeUWQNQqyjNO8Rrr1T9L8xQYQ0tk+tCvzMA80wyRG07yaMMi3SgucMY/9nP9exjC0asGmuOFyNjE0R8JZkgTvSPbI7JoA5X0pTkdf5dmenbt7KheaxHlYWv35olEDGhGOSeDK+uIgtNy3+TkkDpofzB7VMEcPbci0Yt/bb+YEqqiAWkQAdobfOqQIviDxFPoQ+Sl014f4rq6widvCPCslJMVpvkTK9hbVyBPVqEYmXDHdIo8kAMbHwUh8ufgnxjdyXAqL+4X53SrMffgbRB4NLzHbVqoZS0NjaU4TbTFV2Ult32qZDaoHgqNXBJEIX8tA/FDQiag9hKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vYTyXLjXwbkjU3ZLJAidWt9aafEvEW2vJje5bjq6u1U=;
 b=PrNFN2QZhE049/+AA+EaSFQXiCgyL+Zwjbn7GHGHNwpolybldEB7GuGiE/W3TJO6SjP/YuOz708lUNVkav57KaDex00axHYnqGnncXQtik8fojlPQBCGgnV1j8+OTDgNMMdYagX6vwdDZhj7xaShflPnVLVCyaP6klpeRNbAE4OQgosNzSRbNG7w1b0ZXfkC5j8J/tFYnXPN5KqzKnmCY+JqZazzNCVHzxZx2+5C3XMg5EZA+7CWtRsjlcj3L/3ypYHuP2HFzlyH/OcTGUI4OnWz9hpnzyeBUZ9dnTA81j8H8AU7k0CQ+mM/HSTAfW5KMGC2jcE1/OJ25SYcrRp8aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vYTyXLjXwbkjU3ZLJAidWt9aafEvEW2vJje5bjq6u1U=;
 b=OTGxz/r6X2cfTjNciliz+jaUDr5vW8kTN/T7gqU9VQkHGXy/O5cGU0L+iDcmmN/bj1wCOf2Ds8ru2goYIRVznZbcBq3mpcNEFK68p8t7LciDsJ6p2ED6IxuZCJItifFQIa5DSPUZ0LY0immQk9q7mjkeNxX4zbPcOY0DLOH/eWKbJURxNA5sKpr7Lm2vVWXVcSv3aWcN+EkO9jLlstMP9PyXHgvfbgA+4kcV2PqFaE+UH9kZDNsAmfJx62KyyPwmQZKSb3sEDn1hNCaidTp/7n/PGAzmi4bzpzwiLr+em8MFy+kA33g6f5nA8Fw3Q4zR8/G7L6MdC0b45oWQaexhdg==
Received: from CY5PR19CA0002.namprd19.prod.outlook.com (2603:10b6:930:15::8)
 by PH8PR12MB6700.namprd12.prod.outlook.com (2603:10b6:510:1cf::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 12:37:24 +0000
Received: from CY4PEPF0000B8EC.namprd05.prod.outlook.com
 (2603:10b6:930:15:cafe::f3) by CY5PR19CA0002.outlook.office365.com
 (2603:10b6:930:15::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Fri, 25 Nov 2022 12:37:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CY4PEPF0000B8EC.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.11 via Frontend Transport; Fri, 25 Nov 2022 12:37:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 04:37:11 -0800
Received: from fedora.nvidia.com (10.126.230.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 25 Nov
 2022 04:37:07 -0800
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Tianyu Yuan <tianyu.yuan@corigine.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Davide Caratti" <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        "Eelco Chaudron" <echaudro@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        "Marcelo Leitner" <mleitner@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>,
        Roi Dayan <roid@nvidia.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Date:   Fri, 25 Nov 2022 14:31:35 +0200
In-Reply-To: <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
Message-ID: <87y1rzqkgf.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000B8EC:EE_|PH8PR12MB6700:EE_
X-MS-Office365-Filtering-Correlation-Id: 753e1f66-3689-4bff-378f-08dacee1cd1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pPCVpFz80QefuuJqy/m4fskH9Jm627nIJ28GxhzIE5QQRJ25y71i3X51kX9zURQHFScj5zILnyDqvIMAEscGeliFj6QMPtatWRxltRBpue3mThOKDiVIkwkyI6IPiqsr0qzeZrHpf/3CGgxFbEt6qYbXtttJwLuKWFbmvnm508xd/AK/Yu5NYPGE1rzOKqPK92WUyJc6HbCm0zqRCVwcmsVCRUXRRvO1nI6gp7JEbrZo/UfW6XG1AXHV/m6yGQweuIZYcsH8s9k/2ES1CAcaQD+dJAMKiGowwStD1SStAcopAXE+pXB6Ni36qUdyWXzLL8bPS4jZkPCTW7Xiisver5JObIH+KOp0BGp19vHoc8rlUeVvPYIP49/UWd6E8trxX/Adk92k8GvDxc58qbg838Qq0ld3CNPlfnv/6lb1ckRE2rjfRiGWZ1smtohLmgY5peDeFo2mAkYod5MzNM0fpzv/pgCylhKY0zwlIWS/DqTQ2Ebv4Dx5nOhy5wbVpjXaOiC/gRs4KuiyAgeYHxc4ZhXmp/dHVIw306rle49+JvYfagF2uN6VpYY2nkXCT0Q5AbobUwqYTgsO8a+CPtNd4TOoMnl4vAMUza4wHfM5f73QqDOYAasKM4M0wFnNyW/mSL/wqKhoW7DqnymlblGixUAAxmkkPcyiLu3sGYv9jBGX5FNbZagGyzhnS5ckGTYhZP8/EqhAFOa2pOmMlTHkMjTtCLx0G01ivUPnVGpviIIdfIlFSeIZxGNAFvPQ26gnxi7cEocCWVMtC53PwZ9Aedcg5VSU3E9wFQuz3Rv1yvv7nLNVVU4/OXkiSmcF0xtt
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(346002)(376002)(396003)(451199015)(40470700004)(36840700001)(46966006)(7636003)(356005)(40480700001)(36756003)(40460700003)(86362001)(966005)(54906003)(107886003)(7696005)(6916009)(6666004)(53546011)(26005)(478600001)(5660300002)(30864003)(8936002)(41300700001)(4326008)(8676002)(70586007)(70206006)(2906002)(7416002)(316002)(82310400005)(82740400003)(36860700001)(16526019)(186003)(2616005)(336012)(426003)(83380400001)(47076005)(21314003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 12:37:22.8925
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 753e1f66-3689-4bff-378f-08dacee1cd1c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000B8EC.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6700
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri 25 Nov 2022 at 03:10, Tianyu Yuan <tianyu.yuan@corigine.com> wrote:
> On Fri, Nov 25, 2022 at 10:21 AM  Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>> 
>> I am not sure if the mlx5 changes will work since  they both seem to be calling
>> mlx5e_tc_act_get() which expects the act->id to exist in tc_acts_xxx tables,
>> meaning mlx5e_tc_act_get() will always return you NULL  and that check is
>> hit before you check for ACT_PIPE.
>> 
>> Something not obvious to me:
>> Would all these drivers now be able to handle ACT_PIPE transparently as if
>> no action is specified? Cant see the obvious connection to POLICE by just
>> staring at the patch - is there and ACT_PIPE first then a POLICE?
>>  Another question:
>> If the ACT_PIPE count is not being updated in s/w - is there a h/w equivalent
>> stat being updated?
>> 
>> cheers,
>> jamal
>> 
> Thanks Jamal for your review.
>
> About mlx5e_tc_act_get(), I'll later add PIPE action in tc_acts_nic so that mlx5e_tc_act_get() will return the right
> act_id.

Sorry for the late response. Jamal is correct and ACT_PIPE should indeed
be properly handled in mlx5 by extending action array with correct type.
You also need to extend tc_acts_fdb besides tc_acts_nic since "fdb" is
responsible for actions in switchdev mode. I'll followup with a PoC
patch that works on our hardware.

>
> In driver we choose just ignore this gact with ACT_PIPE, so after parsing the filter(rule) from kernel, the remaining
> actions are just like what they used to be without changes in this patch. So the flow could be processed as before.
>
> The connection between POLICE and ACT_PIPE may exist in userspace (e.g. ovs), we could put a gact (PIPE) at the
> beginning place in each tc filter. We will also have an OVS patch for this propose.
>
> I'm not very clear with your last case, but in expectation, the once the traffic is offloaded in h/w tc datapath, the
> stats will be updated by the flower stats from hardware. And when the traffic is using s/w tc datapath, the stats are
> from software.
>
> B.R.
> Tianyu
>
>> 
>> On Tue, Nov 22, 2022 at 6:21 AM Simon Horman
>> <simon.horman@corigine.com> wrote:
>> >
>> > From: Tianyu Yuan <tianyu.yuan@corigine.com>
>> >
>> > Support gact with PIPE action when setting up gact in TC.
>> > This PIPE gact could come first in each tc filter to update the
>> > filter(flow) stats.
>> >
>> > The stats for each actons in a filter are updated by the flower stats
>> > from HW(via netdev drivers) in kernel TC rather than drivers.
>> >
>> > In each netdev driver, we don't have to process this gact, but only to
>> > ignore it to make sure the whole rule can be offloaded.
>> >
>> > Background:
>> >
>> > This is a proposed solution to a problem with a miss-match between TC
>> > police action instances - which may be shared between flows - and
>> > OpenFlow meter actions - the action is per flow, while the underlying
>> > meter may be shared. The key problem being that the police action
>> > statistics are shared between flows, and this does not match the
>> > requirement of OpenFlow for per-flow statistics.
>> >
>> > Ref: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
>> >
>> > https://mail.openvswitch.org/pipermail/ovs-dev/2022-
>> October/398363.htm
>> > l
>> >
>> > Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
>> > Signed-off-by: Simon Horman <simon.horman@corigine.com>
>> > ---
>> >  drivers/net/dsa/ocelot/felix_vsc9959.c                     | 5 +++++
>> >  drivers/net/dsa/sja1105/sja1105_flower.c                   | 5 +++++
>> >  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c       | 5 +++++
>> >  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 6 ++++++
>> >  drivers/net/ethernet/intel/ice/ice_tc_lib.c                | 5 +++++
>> >  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 5 +++++
>> >  drivers/net/ethernet/marvell/prestera/prestera_flower.c    | 5 +++++
>> >  drivers/net/ethernet/mediatek/mtk_ppe_offload.c            | 5 +++++
>> >  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        | 6 ++++++
>> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 5 +++++
>> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      | 5 +++++
>> >  drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c   | 4 ++++
>> >  drivers/net/ethernet/mscc/ocelot_flower.c                  | 5 +++++
>> >  drivers/net/ethernet/netronome/nfp/flower/action.c         | 5 +++++
>> >  drivers/net/ethernet/qlogic/qede/qede_filter.c             | 5 +++++
>> >
>>                               | 5 +++++
>> >  drivers/net/ethernet/ti/cpsw_priv.c                        | 5 +++++
>> >  net/sched/act_gact.c                                       | 7 ++++---
>> >  18 files changed, 90 insertions(+), 3 deletions(-)
>> >
>> >
>> > diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > index b0ae8d6156f6..e54eb8e28386 100644
>> > --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>> > @@ -2217,6 +2217,11 @@ static int vsc9959_psfp_filter_add(struct ocelot
>> *ocelot, int port,
>> >                         sfi.fmid = index;
>> >                         sfi.maxsdu = a->police.mtu;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         mutex_unlock(&psfp->lock);
>> >                         return -EOPNOTSUPP; diff --git
>> > a/drivers/net/dsa/sja1105/sja1105_flower.c
>> > b/drivers/net/dsa/sja1105/sja1105_flower.c
>> > index fad5afe3819c..d3eeeeea152a 100644
>> > --- a/drivers/net/dsa/sja1105/sja1105_flower.c
>> > +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
>> > @@ -426,6 +426,11 @@ int sja1105_cls_flower_add(struct dsa_switch *ds,
>> int port,
>> >                         if (rc)
>> >                                 goto out;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(extack,
>> >                                            "Action not supported");
>> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>> > b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>> > index dd9be229819a..443f405c0ed4 100644
>> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>> > @@ -770,6 +770,11 @@ int cxgb4_validate_flow_actions(struct net_device
>> *dev,
>> >                 case FLOW_ACTION_QUEUE:
>> >                         /* Do nothing. cxgb4_set_filter will validate */
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         netdev_err(dev, "%s: Unsupported action\n", __func__);
>> >                         return -EOPNOTSUPP; diff --git
>> > a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> > b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> > index cacd454ac696..cfbf2f76e83a 100644
>> > --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> > +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>> > @@ -378,6 +378,11 @@ static int dpaa2_switch_tc_parse_action_acl(struct
>> ethsw_core *ethsw,
>> >         case FLOW_ACTION_DROP:
>> >                 dpsw_act->action = DPSW_ACL_ACTION_DROP;
>> >                 break;
>> > +       /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +        * The NIC doesn't have to process this action
>> > +        */
>> > +       case FLOW_ACTION_PIPE:
>> > +               break;
>> >         default:
>> >                 NL_SET_ERR_MSG_MOD(extack,
>> >                                    "Action not supported"); @@ -651,6
>> > +656,7 @@ int dpaa2_switch_cls_flower_replace(struct
>> dpaa2_switch_filter_block *block,
>> >         case FLOW_ACTION_REDIRECT:
>> >         case FLOW_ACTION_TRAP:
>> >         case FLOW_ACTION_DROP:
>> > +       case FLOW_ACTION_PIPE:
>> >                 return dpaa2_switch_cls_flower_replace_acl(block, cls);
>> >         case FLOW_ACTION_MIRRED:
>> >                 return dpaa2_switch_cls_flower_replace_mirror(block,
>> > cls); diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>> > b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>> > index faba0f857cd9..5908ad4d0170 100644
>> > --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>> > +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>> > @@ -642,6 +642,11 @@ ice_eswitch_tc_parse_action(struct
>> > ice_tc_flower_fltr *fltr,
>> >
>> >                 break;
>> >
>> > +       /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +        * The NIC doesn't have to process this action
>> > +        */
>> > +       case FLOW_ACTION_PIPE:
>> > +               break;
>> >         default:
>> >                 NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported action in
>> switchdev mode");
>> >                 return -EINVAL;
>> > diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> > b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> > index e64318c110fd..fc05897adb70 100644
>> > --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> > +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>> > @@ -450,6 +450,11 @@ static int otx2_tc_parse_actions(struct otx2_nic
>> *nic,
>> >                 case FLOW_ACTION_MARK:
>> >                         mark = act->mark;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         return -EOPNOTSUPP;
>> >                 }
>> > diff --git a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>> > b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>> > index 91a478b75cbf..9686ed086e35 100644
>> > --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>> > @@ -126,6 +126,11 @@ static int prestera_flower_parse_actions(struct
>> prestera_flow_block *block,
>> >                         if (err)
>> >                                 return err;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
>> >                         pr_err("Unsupported action\n"); diff --git
>> > a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> > b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> > index 81afd5ee3fbf..91e4d3fcc756 100644
>> > --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> > +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>> > @@ -344,6 +344,11 @@ mtk_flow_offload_replace(struct mtk_eth *eth,
>> struct flow_cls_offload *f)
>> >                         data.pppoe.sid = act->pppoe.sid;
>> >                         data.pppoe.num++;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         return -EOPNOTSUPP;
>> >                 }
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> > b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> > index b08339d986d5..231660cb1daf 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>> > @@ -544,6 +544,12 @@ mlx5e_rep_indr_replace_act(struct
>> mlx5e_rep_priv *rpriv,
>> >                 if (!act->offload_action)
>> >                         continue;
>> >
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               if (action->id == FLOW_ACTION_PIPE)
>> > +                       continue;
>> > +
>> >                 if (!act->offload_action(priv, fl_act, action))
>> >                         add = true;
>> >         }
>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> > index 3782f0097292..adac2ce9b24f 100644
>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>> > @@ -3853,6 +3853,11 @@ parse_tc_actions(struct
>> > mlx5e_tc_act_parse_state *parse_state,
>> >
>> >         flow_action_for_each(i, _act, &flow_action_reorder) {
>> >                 act = *_act;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               if (act->id == FLOW_ACTION_PIPE)
>> > +                       continue;
>> >                 tc_act = mlx5e_tc_act_get(act->id, ns_type);
>> >                 if (!tc_act) {
>> >                         NL_SET_ERR_MSG_MOD(extack, "Not implemented
>> > offload action"); diff --git
>> > a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> > b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> > index e91fb205e0b4..9270bf9581c7 100644
>> > --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> > +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>> > @@ -266,6 +266,11 @@ static int mlxsw_sp_flower_parse_actions(struct
>> mlxsw_sp *mlxsw_sp,
>> >                                 return err;
>> >                         break;
>> >                         }
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
>> >                         dev_err(mlxsw_sp->bus_info->dev, "Unsupported
>> > action\n"); diff --git
>> > a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>> > b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>> > index bd6bd380ba34..e32f5b5d1e95 100644
>> > --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>> > @@ -692,6 +692,10 @@ static int sparx5_tc_flower_replace(struct
>> net_device *ndev,
>> >                         break;
>> >                 case FLOW_ACTION_GOTO:
>> >                         /* Links between VCAPs will be added later */
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> >                         break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(fco->common.extack,
>> > diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c
>> > b/drivers/net/ethernet/mscc/ocelot_flower.c
>> > index 7c0897e779dc..b8e01af0fb48 100644
>> > --- a/drivers/net/ethernet/mscc/ocelot_flower.c
>> > +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>> > @@ -492,6 +492,11 @@ static int ocelot_flower_parse_action(struct ocelot
>> *ocelot, int port,
>> >                         }
>> >                         filter->type = OCELOT_PSFP_FILTER_OFFLOAD;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(extack, "Cannot offload action");
>> >                         return -EOPNOTSUPP; diff --git
>> > a/drivers/net/ethernet/netronome/nfp/flower/action.c
>> > b/drivers/net/ethernet/netronome/nfp/flower/action.c
>> > index 2b383d92d7f5..57fd83b8e54a 100644
>> > --- a/drivers/net/ethernet/netronome/nfp/flower/action.c
>> > +++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
>> > @@ -1209,6 +1209,11 @@ nfp_flower_loop_action(struct nfp_app *app,
>> const struct flow_action_entry *act,
>> >                 if (err)
>> >                         return err;
>> >                 break;
>> > +       /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +        * The NIC doesn't have to process this action
>> > +        */
>> > +       case FLOW_ACTION_PIPE:
>> > +               break;
>> >         default:
>> >                 /* Currently we do not handle any other actions. */
>> >                 NL_SET_ERR_MSG_MOD(extack, "unsupported offload:
>> > unsupported action in action list"); diff --git
>> > a/drivers/net/ethernet/qlogic/qede/qede_filter.c
>> > b/drivers/net/ethernet/qlogic/qede/qede_filter.c
>> > index 3010833ddde3..69110d5978d8 100644
>> > --- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
>> > +++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
>> > @@ -1691,6 +1691,11 @@ static int qede_parse_actions(struct qede_dev
>> *edev,
>> >                                 return -EINVAL;
>> >                         }
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         return -EINVAL;
>> >                 }
>> > diff --git a/drivers/net/ethernet/sfc/tc.c
>> > b/drivers/net/ethernet/sfc/tc.c index deeaab9ee761..7256bbcdcc59
>> > 100644
>> > --- a/drivers/net/ethernet/sfc/tc.c
>> > +++ b/drivers/net/ethernet/sfc/tc.c
>> > @@ -494,6 +494,11 @@ static int efx_tc_flower_replace(struct efx_nic
>> *efx,
>> >                         }
>> >                         *act = save;
>> >                         break;
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled action %u",
>> >                                                fa->id); diff --git
>> > a/drivers/net/ethernet/ti/cpsw_priv.c
>> > b/drivers/net/ethernet/ti/cpsw_priv.c
>> > index 758295c898ac..c0ac58db64d4 100644
>> > --- a/drivers/net/ethernet/ti/cpsw_priv.c
>> > +++ b/drivers/net/ethernet/ti/cpsw_priv.c
>> > @@ -1492,6 +1492,11 @@ static int cpsw_qos_configure_clsflower(struct
>> > cpsw_priv *priv, struct flow_cls_
>> >
>> >                         return cpsw_qos_clsflower_add_policer(priv, extack, cls,
>> >
>> > act->police.rate_pkt_ps);
>> > +               /* Just ignore GACT with pipe action to let this action count the
>> packets.
>> > +                * The NIC doesn't have to process this action
>> > +                */
>> > +               case FLOW_ACTION_PIPE:
>> > +                       break;
>> >                 default:
>> >                         NL_SET_ERR_MSG_MOD(extack, "Action not supported");
>> >                         return -EOPNOTSUPP; diff --git
>> > a/net/sched/act_gact.c b/net/sched/act_gact.c index
>> > 62d682b96b88..82d1371e251e 100644
>> > --- a/net/sched/act_gact.c
>> > +++ b/net/sched/act_gact.c
>> > @@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct
>> tc_action *act, void *entry_data,
>> >                 } else if (is_tcf_gact_goto_chain(act)) {
>> >                         entry->id = FLOW_ACTION_GOTO;
>> >                         entry->chain_index =
>> > tcf_gact_goto_chain_index(act);
>> > +               } else if (is_tcf_gact_pipe(act)) {
>> > +                       entry->id = FLOW_ACTION_PIPE;
>> >                 } else if (is_tcf_gact_continue(act)) {
>> >                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"continue\"
>> action is not supported");
>> >                         return -EOPNOTSUPP;
>> >                 } else if (is_tcf_gact_reclassify(act)) {
>> >                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"reclassify\"
>> action is not supported");
>> >                         return -EOPNOTSUPP;
>> > -               } else if (is_tcf_gact_pipe(act)) {
>> > -                       NL_SET_ERR_MSG_MOD(extack, "Offload of \"pipe\" action is
>> not supported");
>> > -                       return -EOPNOTSUPP;
>> >                 } else {
>> >                         NL_SET_ERR_MSG_MOD(extack, "Unsupported generic action
>> offload");
>> >                         return -EOPNOTSUPP; @@ -275,6 +274,8 @@ static
>> > int tcf_gact_offload_act_setup(struct tc_action *act, void *entry_data,
>> >                         fl_action->id = FLOW_ACTION_TRAP;
>> >                 else if (is_tcf_gact_goto_chain(act))
>> >                         fl_action->id = FLOW_ACTION_GOTO;
>> > +               else if (is_tcf_gact_pipe(act))
>> > +                       fl_action->id = FLOW_ACTION_PIPE;
>> >                 else
>> >                         return -EOPNOTSUPP;
>> >         }
>> > --
>> > 2.30.2
>> >

