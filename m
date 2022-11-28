Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1DC763A1E2
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiK1HS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiK1HS2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:18:28 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2125.outbound.protection.outlook.com [40.107.237.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4C5656E
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 23:18:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kkDcGhiGnu38UKa7njjUqD1sQ7aiXFFRZLEknohTsTqkoPLDrxffHTCKN3hDzTQo8+gAa/OI93E2BS0QmSxYwI/BYCEVJZKyTy24e+Kx3d+ELZ2nWCWlOBYRvQ8f4HHuUBEvGvuEPgorqWoLIUsdMcjouYZ+7eiptIdiiC/yHydkWV2glsFAE06WCU9VLDE2ynzJ1HD/pEKOZGwDSOI96vOGVPgLeU1kNyA3FyAAYP3deYLgeU3B6R4jM5tYBAxIy423afoS3eZkhYSU/xfGNEOY0EkWcZl89lrrOItuPTFvSomQ5WSOzcs5jixtfitra2tjjLQMVZOAVrcikM4xog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aWuobTcIhX6WqUs2o1LogdNAu1RD0EpspLQIY5G/QcA=;
 b=jMyqVOz8pDN0V639jx3LUWteP+rQx6I/0y8mJ1P7QMxxJhmmCd1csh5baL9AMfzu/+ZSq6WrjJm1N6jMqQdEE81GESS1LOS8+2PQ4wS3UrtV7quwZP2E9wuOohCSKRb/bNmp88phpH6h7fKY1d2hOI+BWanM+uX4S76FSydRZc69zcFxoKzmwvS7hTD298AS46Vd17EGtqAPkVEQ0Hl31ORcVsXzhfrJ/Q0Z2C+UuOFKN5/RtVXzgfAvPZqnPZtXU2jy+vxfFFNTpm7t3sQRcRblOwHirrc3TKDCAh00wj6vMipGoQbKgVt8Mjevck6QLik0huJIQCzRBt30qEu3ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aWuobTcIhX6WqUs2o1LogdNAu1RD0EpspLQIY5G/QcA=;
 b=CxxdXHihPMfVZwSo4x8Iktp7W/i/tznPb1xCZFExpz9RJzq4/jfbHdO0gn0U44iswVbuowDhZnMRZ/rzzJzNHJAaQkPHW40o8rNIu/d91XZuMsBKv2xsDzhlvOFjoNPPqLy+oey3HxMPcM6Dh+lEH99WkzMQ3mkBJHDnpOEGZ3A=
Received: from PH0PR13MB4793.namprd13.prod.outlook.com (2603:10b6:510:7a::12)
 by DS7PR13MB4719.namprd13.prod.outlook.com (2603:10b6:5:3a8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 07:18:22 +0000
Received: from PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489]) by PH0PR13MB4793.namprd13.prod.outlook.com
 ([fe80::1acb:77a9:9010:2489%4]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 07:18:22 +0000
From:   Tianyu Yuan <tianyu.yuan@corigine.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        Marcelo Leitner <mleitner@redhat.com>
CC:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: RE: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Topic: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Thread-Index: AQHY/mSdmThOr7A34UyDPeUsz+fSLa5OwOIAgAAoYjCAAMvsAIAAA4gAgAQ8kRA=
Date:   Mon, 28 Nov 2022 07:18:22 +0000
Message-ID: <PH0PR13MB47936891023E497D61FE3AF494139@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <062D20F4-34FD-47BA-AF56-7C806EC61070@redhat.com>
In-Reply-To: <062D20F4-34FD-47BA-AF56-7C806EC61070@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR13MB4793:EE_|DS7PR13MB4719:EE_
x-ms-office365-filtering-correlation-id: 8cbbb4f6-f886-4c90-9d30-08dad110bb6b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lWj5vYgCCc8phxrgvYYzAbDo73A5ShNg3HpI1I2GATFM38b5KXUFQmj8njSC4yO13GejhbzyK+1a+ly5IVDBe0CX61CXdscAg23MUU4y+9jz/onlJSQGJq4SbNNpark2lce9VUXYkV+s4nHBKilous2896T0JRDc+xVRGi5SRQz6fn072kbhNc3MLwXqoLCZx9cUFifzB/Lwwma4coO6zATuFME/4o/eMjYnGJ/AZ2pV1Vz7jUwR0PcU3uFdZyjJmT+mvIMhgFY0P3MJ7M1pzP+6cKdp0sBvpmYiQHKx5CqpTccOKMx3UY9TTzY9NrdkV1Q+L6fws6sWMEIO0u+rpSbtjDJSKL/8jJuhGs9H/wlO3c+a9lIRu0LUWfIDvAUCq7IDKDUC7ioAZDkHVQCYQh6Q+BRI+OFeIbhWj7OqAklgO80fqmyrk1j/rvcSilCyjAM4IqqLw9cKLUXNc92B40RLnroNt5VMToa5bHJTZ0xlffGBIvS36WyhXQRx4JP7HlEa/5nO4ggV2igIBRBfcfTZxrBdy0mGt8nW+1b1fqJj+gmz2nrK69JFcGEOV4ZV9htw7pYFJiS7+7I6ydZEdwOBhd6FKoJJG5xhTE/h7Mi/jQ1O8t5T18Yag093YUBLZ0WjgJ2jDFQdXRhqas87hzg0KwN6dAPU851KUEBi0XrI9iDFfzUodJuVrlpnjyS8DQJhjpzNAX/+N1Ko8lsWI7EzUna+y5qouq4PSZdswRc82/XNeemGAWDa/sxeXBoU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4793.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39830400003)(366004)(346002)(451199015)(83380400001)(86362001)(122000001)(38100700002)(2906002)(38070700005)(55016003)(7416002)(30864003)(44832011)(8936002)(5660300002)(66446008)(41300700001)(52536014)(7696005)(6506007)(53546011)(107886003)(26005)(9686003)(316002)(71200400001)(186003)(4326008)(64756008)(54906003)(110136005)(8676002)(66476007)(66556008)(76116006)(966005)(478600001)(66946007)(33656002)(21314003)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?iKpd1iy9dopLlzif0V9SeG0HVcqci2OTt/dexecauLuL4oER2gvuDpMS+iVH?=
 =?us-ascii?Q?jzz4TcWHbBb/7zstBll6xZYDFLLMDWf/2Y+MuWFza2AsmTf+CNA+1tkSi/5Q?=
 =?us-ascii?Q?lWEZDDdoGkEP8hs7fu4mehwJ8jSoLsFUtglUdRqpvZdBAk7D2asVJO8Nn6iZ?=
 =?us-ascii?Q?bwP1WJpUzvdv3MmtmiESp8WK+3IujR+e1TfaMhgoGQ2dSYvqMoL8tZn4vM6c?=
 =?us-ascii?Q?f/QLgq5Qbpl3/UCZX8INSdTd5KF11QbypXPloZcEX8FhRnNvEjSR1UscI4bO?=
 =?us-ascii?Q?5Dx6Vi4qJ1plEbRpsHc075aAcqxG5mtwCBktmSviTnv+FoE6X1a2qhBysmMX?=
 =?us-ascii?Q?3nGoV8U73FQ0qNDRhhvPo86K9at5o4L34IKSNmt3EC9HeKwro3FLEFTuApxU?=
 =?us-ascii?Q?+71itHydC4w1y5MS13z7QJYOgZ3iMOcjBlgG/15aIkDEWWMwfKlN0+H/nK+c?=
 =?us-ascii?Q?J8MsrrA/1NlqkqPZTSrmva4c+xpwJnKWC5mHqNTSv2PD+OydY8OM7UwpeX/r?=
 =?us-ascii?Q?xUSeqmc/XjgpVwJ/MGPo5gSGh9/snbmfHI17Yqc08B59e+9EtXT7ebJMeWc7?=
 =?us-ascii?Q?tg0wdvntNjVfZOUa/Vv8XMfd3NrAOoOCXmIVVtpVExoh8KMSIEZGTApmYRsR?=
 =?us-ascii?Q?o160onvnyZM6YOJEegweAdlxNCvty6pSGfl5WecE144G9qz5V7AwHO3L1Xem?=
 =?us-ascii?Q?fBNIP3AsP6iJDhdaHzcOdLeYAj8sCmA97O3qF/uRCawzGiCTLEXDPuaqBWdi?=
 =?us-ascii?Q?a5+HxTZzRjJcULS7p9NZ+eZdWEvoHm38zdQjANCfQ8ZUxydedrpO8d8Md9GT?=
 =?us-ascii?Q?6hBOldxcvcliiYGHML1QIoY1Jm3t6/c92MuBLZe9g9/Vnugb9zmuU3fT63CK?=
 =?us-ascii?Q?2dkJ/xGi2Er+KkUdBfI8IBIW5YSl0GnC84TvYbGRE6jxKFjCfOZN+nsdkszy?=
 =?us-ascii?Q?xwQUhyqfBJwj/nKm01g2Y4isEcxH7DClclvt6nPzkmB9AxERJo7aboQ2Soa1?=
 =?us-ascii?Q?lVymvJaKecUW6d0sWCW5vwlRMXMhJjOaAXlewrMmJBawaNEURBEH2fTBgWyh?=
 =?us-ascii?Q?9ae0nKVZXXkZwA6TBQNuL2x+bCnMVLVVAOzTh23zah89c2fQRkyUAZjOsDPS?=
 =?us-ascii?Q?pmYzD2xXi0lSL+toeXobYhBeftSi6HZKt9pFUjTk8Nh+4HXiv6q0qMok+xhb?=
 =?us-ascii?Q?u+4O1dcH+5bR62vSQzzVhhtlLFsZRqOr8+RgIYgtmS8vaJvE/u76H+c65s8o?=
 =?us-ascii?Q?WliRDHsKsH+O73fNMir8+/It1ZOAuJfJASU+7akIVL9lY8Ob2I3w+9KTEqJ/?=
 =?us-ascii?Q?yPII8h8ObPXV0f1Cc9AO+GmPjY1GcjuBoI9aBwOWDcYkBJPMZRIEf+ozvm9I?=
 =?us-ascii?Q?o/5PEbHMvRupbXhRBy5D3FDduw7iAsQdDFcRbuxCNgusGdP7nhagJZy/mP6G?=
 =?us-ascii?Q?Wlh8wmPAKpB84EOhktkkYRxtM0GGhYey5ELbBG1Y9Stb24oLTdJWtQdppAdB?=
 =?us-ascii?Q?n79H8slLNy03TKMaVFi++AqiS93zsenlLy/i0d+yjSQJVsscnxLRpm0+lzIY?=
 =?us-ascii?Q?G38jx0CijniES8vvpzBB1NkKcI3HrBrDtSOsS98g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4793.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cbbb4f6-f886-4c90-9d30-08dad110bb6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Nov 2022 07:18:22.0264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m7MnL0pL/Kqsd8XtEUS6b/n9Ne8TMX06cdyBmjanBgFyuJiotesW0QedrhjItPRvhrRe4DeiCx1lCeTx2NbVkXu5BFlveUSE8WFkrBHTSzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4719
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Eelco Chaudron <echaudro@redhat.com>
> Sent: Friday, November 25, 2022 10:33 PM
> To: Marcelo Leitner <mleitner@redhat.com>
> Cc: Tianyu Yuan <tianyu.yuan@corigine.com>; Jamal Hadi Salim
> <jhs@mojatatu.com>; Simon Horman <simon.horman@corigine.com>;
> netdev@vger.kernel.org; Cong Wang <xiyou.wangcong@gmail.com>; Davide
> Caratti <dcaratti@redhat.com>; Edward Cree <edward.cree@amd.com>; Ilya
> Maximets <i.maximets@ovn.org>; Oz Shlomo <ozsh@nvidia.com>; Paul
> Blakey <paulb@nvidia.com>; Vlad Buslov <vladbu@nvidia.com>;
> dev@openvswitch.org; oss-drivers <oss-drivers@corigine.com>; Ziyang Chen
> <ziyang.chen@corigine.com>
> Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with P=
IPE
> when offloading
>=20
>=20
>=20
> On 25 Nov 2022, at 15:19, Marcelo Leitner wrote:
>=20
> > On Fri, Nov 25, 2022 at 03:10:37AM +0000, Tianyu Yuan wrote:
> >> On Fri, Nov 25, 2022 at 10:21 AM  Jamal Hadi Salim <jhs@mojatatu.com>
> wrote:
> >>
> >>>
> >>> I am not sure if the mlx5 changes will work since  they both seem to
> >>> be calling
> >>> mlx5e_tc_act_get() which expects the act->id to exist in tc_acts_xxx
> >>> tables, meaning mlx5e_tc_act_get() will always return you NULL  and
> >>> that check is hit before you check for ACT_PIPE.
> >>>
> >>> Something not obvious to me:
> >>> Would all these drivers now be able to handle ACT_PIPE transparently
> >>> as if no action is specified? Cant see the obvious connection to
> >>> POLICE by just staring at the patch - is there and ACT_PIPE first the=
n a
> POLICE?
> >>>  Another question:
> >>> If the ACT_PIPE count is not being updated in s/w - is there a h/w
> >>> equivalent stat being updated?
> >>>
> >>> cheers,
> >>> jamal
> >>>
> >> Thanks Jamal for your review.
> >>
> >> About mlx5e_tc_act_get(), I'll later add PIPE action in tc_acts_nic
> >> so that mlx5e_tc_act_get() will return the right act_id.
> >>
> >> In driver we choose just ignore this gact with ACT_PIPE, so after
> >> parsing the filter(rule) from kernel, the remaining actions are just l=
ike
> what they used to be without changes in this patch. So the flow could be
> processed as before.
> >>
> >> The connection between POLICE and ACT_PIPE may exist in userspace
> >> (e.g. ovs), we could put a gact (PIPE) at the beginning place in each =
tc filter.
> We will also have an OVS patch for this propose.
> >>
> >> I'm not very clear with your last case, but in expectation, the once
> >> the traffic is offloaded in h/w tc datapath, the stats will be
> >> updated by the flower stats from hardware. And when the traffic is usi=
ng
> s/w tc datapath, the stats are from software.
> >
> > I'm still confused here. Take, for example cxgb4 driver below. It will
> > simply ignore this action AFAICT. This is good because it will still
> > offload whatever vswitchd would be offloading but then, I don't see
> > how the stats will be right in the end. I think the hw stats will be
> > zeroed, no? (this is already considering the per action stats change
> > that Oz is working on, see [ RFC  net-next v2 0/2] net: flow_offload:
> > add support for per action hw stats)
> >
> > I think the drivers have to reject the action if they don't support
> > it, and vswitchd will have to probe for proper support when starting.
>=20
> I guess OVS userspace needs a simple way to determine which approach to
> use, i.e. if the kernel has this patch series applied. Or else it would n=
ot be
> easy to migrate userspace to use this approach.

Yes, we could modify OVS' acinclude.m4 to check if the current has applied =
such a patch
series. If so, it will use this approach, otherwise, put actions in tc flow=
er as before. So that
we could ensure the traffic will offloaded correctly.
>=20
> > Other than this, patch seems good.
> >
> > Thanks,
> > Marcelo
> >
> >>
> >> B.R.
> >> Tianyu
> >>
> >>>
> >>> On Tue, Nov 22, 2022 at 6:21 AM Simon Horman
> >>> <simon.horman@corigine.com> wrote:
> >>>>
> >>>> From: Tianyu Yuan <tianyu.yuan@corigine.com>
> >>>>
> >>>> Support gact with PIPE action when setting up gact in TC.
> >>>> This PIPE gact could come first in each tc filter to update the
> >>>> filter(flow) stats.
> >>>>
> >>>> The stats for each actons in a filter are updated by the flower
> >>>> stats from HW(via netdev drivers) in kernel TC rather than drivers.
> >>>>
> >>>> In each netdev driver, we don't have to process this gact, but only
> >>>> to ignore it to make sure the whole rule can be offloaded.
> >>>>
> >>>> Background:
> >>>>
> >>>> This is a proposed solution to a problem with a miss-match between
> >>>> TC police action instances - which may be shared between flows -
> >>>> and OpenFlow meter actions - the action is per flow, while the
> >>>> underlying meter may be shared. The key problem being that the
> >>>> police action statistics are shared between flows, and this does
> >>>> not match the requirement of OpenFlow for per-flow statistics.
> >>>>
> >>>> Ref: [ovs-dev] [PATCH] tests: fix reference output for meter
> >>>> offload stats
> >>>>
> >>>> https://mail.openvswitch.org/pipermail/ovs-dev/2022-
> >>> October/398363.htm
> >>>> l
> >>>>
> >>>> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
> >>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> >>>> ---
> >>>>  drivers/net/dsa/ocelot/felix_vsc9959.c                     | 5 ++++=
+
> >>>>  drivers/net/dsa/sja1105/sja1105_flower.c                   | 5 ++++=
+
> >>>>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c       | 5 ++++=
+
> >>>>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 6
> ++++++
> >>>>  drivers/net/ethernet/intel/ice/ice_tc_lib.c                | 5 ++++=
+
> >>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 5 ++++=
+
> >>>>  drivers/net/ethernet/marvell/prestera/prestera_flower.c    | 5 ++++=
+
> >>>>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c            | 5 ++++=
+
> >>>>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        | 6 ++++=
++
> >>>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 5 ++++=
+
> >>>>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      | 5
> +++++
> >>>>  drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c   | 4 ++++
> >>>>  drivers/net/ethernet/mscc/ocelot_flower.c                  | 5 ++++=
+
> >>>>  drivers/net/ethernet/netronome/nfp/flower/action.c         | 5 ++++=
+
> >>>>  drivers/net/ethernet/qlogic/qede/qede_filter.c             | 5 ++++=
+
> >>>>
> >>>                               | 5 +++++
> >>>>  drivers/net/ethernet/ti/cpsw_priv.c                        | 5 ++++=
+
> >>>>  net/sched/act_gact.c                                       | 7 ++++=
---
> >>>>  18 files changed, 90 insertions(+), 3 deletions(-)
> >>>>
> >>>>
> >>>> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c
> >>>> b/drivers/net/dsa/ocelot/felix_vsc9959.c
> >>>> index b0ae8d6156f6..e54eb8e28386 100644
> >>>> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> >>>> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> >>>> @@ -2217,6 +2217,11 @@ static int vsc9959_psfp_filter_add(struct
> >>>> ocelot
> >>> *ocelot, int port,
> >>>>                         sfi.fmid =3D index;
> >>>>                         sfi.maxsdu =3D a->police.mtu;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         mutex_unlock(&psfp->lock);
> >>>>                         return -EOPNOTSUPP; diff --git
> >>>> a/drivers/net/dsa/sja1105/sja1105_flower.c
> >>>> b/drivers/net/dsa/sja1105/sja1105_flower.c
> >>>> index fad5afe3819c..d3eeeeea152a 100644
> >>>> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
> >>>> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
> >>>> @@ -426,6 +426,11 @@ int sja1105_cls_flower_add(struct dsa_switch
> >>>> *ds,
> >>> int port,
> >>>>                         if (rc)
> >>>>                                 goto out;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(extack,
> >>>>                                            "Action not supported");
> >>>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> >>>> b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> >>>> index dd9be229819a..443f405c0ed4 100644
> >>>> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> >>>> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
> >>>> @@ -770,6 +770,11 @@ int cxgb4_validate_flow_actions(struct
> >>>> net_device
> >>> *dev,
> >>>>                 case FLOW_ACTION_QUEUE:
> >>>>                         /* Do nothing. cxgb4_set_filter will validat=
e */
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         netdev_err(dev, "%s: Unsupported action\n", =
__func__);
> >>>>                         return -EOPNOTSUPP; diff --git
> >>>> a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> >>>> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> >>>> index cacd454ac696..cfbf2f76e83a 100644
> >>>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> >>>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
> >>>> @@ -378,6 +378,11 @@ static int
> >>>> dpaa2_switch_tc_parse_action_acl(struct
> >>> ethsw_core *ethsw,
> >>>>         case FLOW_ACTION_DROP:
> >>>>                 dpsw_act->action =3D DPSW_ACL_ACTION_DROP;
> >>>>                 break;
> >>>> +       /* Just ignore GACT with pipe action to let this action
> >>>> + count the
> >>> packets.
> >>>> +        * The NIC doesn't have to process this action
> >>>> +        */
> >>>> +       case FLOW_ACTION_PIPE:
> >>>> +               break;
> >>>>         default:
> >>>>                 NL_SET_ERR_MSG_MOD(extack,
> >>>>                                    "Action not supported"); @@
> >>>> -651,6
> >>>> +656,7 @@ int dpaa2_switch_cls_flower_replace(struct
> >>> dpaa2_switch_filter_block *block,
> >>>>         case FLOW_ACTION_REDIRECT:
> >>>>         case FLOW_ACTION_TRAP:
> >>>>         case FLOW_ACTION_DROP:
> >>>> +       case FLOW_ACTION_PIPE:
> >>>>                 return dpaa2_switch_cls_flower_replace_acl(block, cl=
s);
> >>>>         case FLOW_ACTION_MIRRED:
> >>>>                 return
> >>>> dpaa2_switch_cls_flower_replace_mirror(block,
> >>>> cls); diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> >>>> b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> >>>> index faba0f857cd9..5908ad4d0170 100644
> >>>> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> >>>> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
> >>>> @@ -642,6 +642,11 @@ ice_eswitch_tc_parse_action(struct
> >>>> ice_tc_flower_fltr *fltr,
> >>>>
> >>>>                 break;
> >>>>
> >>>> +       /* Just ignore GACT with pipe action to let this action
> >>>> + count the
> >>> packets.
> >>>> +        * The NIC doesn't have to process this action
> >>>> +        */
> >>>> +       case FLOW_ACTION_PIPE:
> >>>> +               break;
> >>>>         default:
> >>>>                 NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported
> >>>> action in
> >>> switchdev mode");
> >>>>                 return -EINVAL;
> >>>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >>>> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >>>> index e64318c110fd..fc05897adb70 100644
> >>>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >>>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >>>> @@ -450,6 +450,11 @@ static int otx2_tc_parse_actions(struct
> >>>> otx2_nic
> >>> *nic,
> >>>>                 case FLOW_ACTION_MARK:
> >>>>                         mark =3D act->mark;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         return -EOPNOTSUPP;
> >>>>                 }
> >>>> diff --git
> >>>> a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> >>>> b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> >>>> index 91a478b75cbf..9686ed086e35 100644
> >>>> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> >>>> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
> >>>> @@ -126,6 +126,11 @@ static int
> >>>> prestera_flower_parse_actions(struct
> >>> prestera_flow_block *block,
> >>>>                         if (err)
> >>>>                                 return err;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported acti=
on");
> >>>>                         pr_err("Unsupported action\n"); diff --git
> >>>> a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >>>> b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >>>> index 81afd5ee3fbf..91e4d3fcc756 100644
> >>>> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >>>> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> >>>> @@ -344,6 +344,11 @@ mtk_flow_offload_replace(struct mtk_eth
> *eth,
> >>> struct flow_cls_offload *f)
> >>>>                         data.pppoe.sid =3D act->pppoe.sid;
> >>>>                         data.pppoe.num++;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         return -EOPNOTSUPP;
> >>>>                 }
> >>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >>>> b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >>>> index b08339d986d5..231660cb1daf 100644
> >>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
> >>>> @@ -544,6 +544,12 @@ mlx5e_rep_indr_replace_act(struct
> >>> mlx5e_rep_priv *rpriv,
> >>>>                 if (!act->offload_action)
> >>>>                         continue;
> >>>>
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               if (action->id =3D=3D FLOW_ACTION_PIPE)
> >>>> +                       continue;
> >>>> +
> >>>>                 if (!act->offload_action(priv, fl_act, action))
> >>>>                         add =3D true;
> >>>>         }
> >>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>>> index 3782f0097292..adac2ce9b24f 100644
> >>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> >>>> @@ -3853,6 +3853,11 @@ parse_tc_actions(struct
> >>>> mlx5e_tc_act_parse_state *parse_state,
> >>>>
> >>>>         flow_action_for_each(i, _act, &flow_action_reorder) {
> >>>>                 act =3D *_act;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               if (act->id =3D=3D FLOW_ACTION_PIPE)
> >>>> +                       continue;
> >>>>                 tc_act =3D mlx5e_tc_act_get(act->id, ns_type);
> >>>>                 if (!tc_act) {
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Not implemented
> >>>> offload action"); diff --git
> >>>> a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> >>>> b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> >>>> index e91fb205e0b4..9270bf9581c7 100644
> >>>> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> >>>> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
> >>>> @@ -266,6 +266,11 @@ static int
> >>>> mlxsw_sp_flower_parse_actions(struct
> >>> mlxsw_sp *mlxsw_sp,
> >>>>                                 return err;
> >>>>                         break;
> >>>>                         }
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported acti=
on");
> >>>>                         dev_err(mlxsw_sp->bus_info->dev,
> >>>> "Unsupported action\n"); diff --git
> >>>> a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> >>>> b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> >>>> index bd6bd380ba34..e32f5b5d1e95 100644
> >>>> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> >>>> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
> >>>> @@ -692,6 +692,10 @@ static int sparx5_tc_flower_replace(struct
> >>> net_device *ndev,
> >>>>                         break;
> >>>>                 case FLOW_ACTION_GOTO:
> >>>>                         /* Links between VCAPs will be added later
> >>>> */
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>>                         break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(fco->common.extack,
> >>>> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c
> >>>> b/drivers/net/ethernet/mscc/ocelot_flower.c
> >>>> index 7c0897e779dc..b8e01af0fb48 100644
> >>>> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
> >>>> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
> >>>> @@ -492,6 +492,11 @@ static int ocelot_flower_parse_action(struct
> >>>> ocelot
> >>> *ocelot, int port,
> >>>>                         }
> >>>>                         filter->type =3D OCELOT_PSFP_FILTER_OFFLOAD;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Cannot offload a=
ction");
> >>>>                         return -EOPNOTSUPP; diff --git
> >>>> a/drivers/net/ethernet/netronome/nfp/flower/action.c
> >>>> b/drivers/net/ethernet/netronome/nfp/flower/action.c
> >>>> index 2b383d92d7f5..57fd83b8e54a 100644
> >>>> --- a/drivers/net/ethernet/netronome/nfp/flower/action.c
> >>>> +++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
> >>>> @@ -1209,6 +1209,11 @@ nfp_flower_loop_action(struct nfp_app
> *app,
> >>> const struct flow_action_entry *act,
> >>>>                 if (err)
> >>>>                         return err;
> >>>>                 break;
> >>>> +       /* Just ignore GACT with pipe action to let this action
> >>>> + count the
> >>> packets.
> >>>> +        * The NIC doesn't have to process this action
> >>>> +        */
> >>>> +       case FLOW_ACTION_PIPE:
> >>>> +               break;
> >>>>         default:
> >>>>                 /* Currently we do not handle any other actions. */
> >>>>                 NL_SET_ERR_MSG_MOD(extack, "unsupported offload:
> >>>> unsupported action in action list"); diff --git
> >>>> a/drivers/net/ethernet/qlogic/qede/qede_filter.c
> >>>> b/drivers/net/ethernet/qlogic/qede/qede_filter.c
> >>>> index 3010833ddde3..69110d5978d8 100644
> >>>> --- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
> >>>> +++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
> >>>> @@ -1691,6 +1691,11 @@ static int qede_parse_actions(struct
> >>>> qede_dev
> >>> *edev,
> >>>>                                 return -EINVAL;
> >>>>                         }
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         return -EINVAL;
> >>>>                 }
> >>>> diff --git a/drivers/net/ethernet/sfc/tc.c
> >>>> b/drivers/net/ethernet/sfc/tc.c index deeaab9ee761..7256bbcdcc59
> >>>> 100644
> >>>> --- a/drivers/net/ethernet/sfc/tc.c
> >>>> +++ b/drivers/net/ethernet/sfc/tc.c
> >>>> @@ -494,6 +494,11 @@ static int efx_tc_flower_replace(struct
> >>>> efx_nic
> >>> *efx,
> >>>>                         }
> >>>>                         *act =3D save;
> >>>>                         break;
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled
> action %u",
> >>>>                                                fa->id); diff --git
> >>>> a/drivers/net/ethernet/ti/cpsw_priv.c
> >>>> b/drivers/net/ethernet/ti/cpsw_priv.c
> >>>> index 758295c898ac..c0ac58db64d4 100644
> >>>> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> >>>> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> >>>> @@ -1492,6 +1492,11 @@ static int
> >>>> cpsw_qos_configure_clsflower(struct
> >>>> cpsw_priv *priv, struct flow_cls_
> >>>>
> >>>>                         return cpsw_qos_clsflower_add_policer(priv,
> >>>> extack, cls,
> >>>>
> >>>> act->police.rate_pkt_ps);
> >>>> +               /* Just ignore GACT with pipe action to let this
> >>>> + action count the
> >>> packets.
> >>>> +                * The NIC doesn't have to process this action
> >>>> +                */
> >>>> +               case FLOW_ACTION_PIPE:
> >>>> +                       break;
> >>>>                 default:
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Action not suppo=
rted");
> >>>>                         return -EOPNOTSUPP; diff --git
> >>>> a/net/sched/act_gact.c b/net/sched/act_gact.c index
> >>>> 62d682b96b88..82d1371e251e 100644
> >>>> --- a/net/sched/act_gact.c
> >>>> +++ b/net/sched/act_gact.c
> >>>> @@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct
> >>> tc_action *act, void *entry_data,
> >>>>                 } else if (is_tcf_gact_goto_chain(act)) {
> >>>>                         entry->id =3D FLOW_ACTION_GOTO;
> >>>>                         entry->chain_index =3D
> >>>> tcf_gact_goto_chain_index(act);
> >>>> +               } else if (is_tcf_gact_pipe(act)) {
> >>>> +                       entry->id =3D FLOW_ACTION_PIPE;
> >>>>                 } else if (is_tcf_gact_continue(act)) {
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"con=
tinue\"
> >>> action is not supported");
> >>>>                         return -EOPNOTSUPP;
> >>>>                 } else if (is_tcf_gact_reclassify(act)) {
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"rec=
lassify\"
> >>> action is not supported");
> >>>>                         return -EOPNOTSUPP;
> >>>> -               } else if (is_tcf_gact_pipe(act)) {
> >>>> -                       NL_SET_ERR_MSG_MOD(extack, "Offload of \"pip=
e\"
> action is
> >>> not supported");
> >>>> -                       return -EOPNOTSUPP;
> >>>>                 } else {
> >>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported
> >>>> generic action
> >>> offload");
> >>>>                         return -EOPNOTSUPP; @@ -275,6 +274,8 @@
> >>>> static int tcf_gact_offload_act_setup(struct tc_action *act, void
> *entry_data,
> >>>>                         fl_action->id =3D FLOW_ACTION_TRAP;
> >>>>                 else if (is_tcf_gact_goto_chain(act))
> >>>>                         fl_action->id =3D FLOW_ACTION_GOTO;
> >>>> +               else if (is_tcf_gact_pipe(act))
> >>>> +                       fl_action->id =3D FLOW_ACTION_PIPE;
> >>>>                 else
> >>>>                         return -EOPNOTSUPP;
> >>>>         }
> >>>> --
> >>>> 2.30.2
> >>>>

