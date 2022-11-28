Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A7063A46A
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiK1JNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:13:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiK1JM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:12:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6DB4396
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:12:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669626720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xaihUNFjjdViszdzpo3KfUQfCEd5xwVAxJ5Xws7glKU=;
        b=MgqSQWyY21Gxrlzki5XvhCAKGaIAdxRNBGHaA8e5kBJnPIoyS7SRktC9KsUGU89himoqEi
        rGh/A+RTMY/690H2+wpF/qrS7pTeJ5MlPsslzvDkVb/dF6cvaCCohaw61ZeQayOgzToj+W
        4L4tyP9G17NvvOu7WoKfFS82BkF7doU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-251-YFRNo8rQN7q3tvE5dEsgIw-1; Mon, 28 Nov 2022 04:11:58 -0500
X-MC-Unique: YFRNo8rQN7q3tvE5dEsgIw-1
Received: by mail-ed1-f71.google.com with SMTP id g14-20020a056402090e00b0046790cd9082so6306045edz.21
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:11:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xaihUNFjjdViszdzpo3KfUQfCEd5xwVAxJ5Xws7glKU=;
        b=GyO/RrhwgLeH4UihXCrAUNyDFMwzmpu4ckB/0/jrAbT3DOHKshVcmJ83S6ec6cK/Yz
         nkDJvtKUDlUHQoXrqayK81mqO1Zmfd/EQpi15ZzI70yBKIXbngote9GLYKmMtLNMFC+8
         i/bVJfGqw7T0gNrjJB+HsZ1VSXfuBjsK8o8iQwhgeRomlcHmbsow+Q0spyotHZ3y/yfO
         LJ1ugunCDA0rFF1oTfq7kT1Y2GCgrPXAa8nFMDpIttqEntdKCSQcfoU3NPQpeAvDOqDx
         cvlmsGRmE117TJK+2svSYFCsify6BurfQzssk6aHntFHm32CzqA6pjlG9LfnTWfbEkBo
         AGWQ==
X-Gm-Message-State: ANoB5plMEB+GGjbC0+OzvShOQW03KKJu4YcyhQ1ohB53fSN9cvaXR7fw
        6VUDOMfp/CVX+8IYk2/O8xRRClaD5aJ5V6NZTn+2bxxx8kyKzHlW8zpFOHppX1cPoetWxfVWRGW
        w4PyLWQwZqqe8FoZh
X-Received: by 2002:a17:907:b686:b0:78d:f796:c00d with SMTP id vm6-20020a170907b68600b0078df796c00dmr27114682ejc.251.1669626717240;
        Mon, 28 Nov 2022 01:11:57 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4B+Gik0db45GoUzBeNplK4I4ElprnZnXC0/XG713vZsK1Yk6IOojcrd5kKr2uJa6bZ6KJ7nA==
X-Received: by 2002:a17:907:b686:b0:78d:f796:c00d with SMTP id vm6-20020a170907b68600b0078df796c00dmr27114650ejc.251.1669626716931;
        Mon, 28 Nov 2022 01:11:56 -0800 (PST)
Received: from [10.39.192.178] (5920ab7b.static.cust.trined.nl. [89.32.171.123])
        by smtp.gmail.com with ESMTPSA id hw20-20020a170907a0d400b007b790c18264sm4692998ejc.159.2022.11.28.01.11.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Nov 2022 01:11:55 -0800 (PST)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     Tianyu Yuan <tianyu.yuan@corigine.com>
Cc:     Marcelo Leitner <mleitner@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Edward Cree <edward.cree@amd.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>,
        Ziyang Chen <ziyang.chen@corigine.com>
Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact with PIPE
 when offloading
Date:   Mon, 28 Nov 2022 10:11:54 +0100
X-Mailer: MailMate (1.14r5928)
Message-ID: <B5D3E5CF-133C-4972-8932-B13633CB6514@redhat.com>
In-Reply-To: <PH0PR13MB47936891023E497D61FE3AF494139@PH0PR13MB4793.namprd13.prod.outlook.com>
References: <20221122112020.922691-1-simon.horman@corigine.com>
 <CAM0EoMk0OLf-uXkt48Pk2SNjti=ttsBRk=JG51-J9m0H-Wcr-A@mail.gmail.com>
 <PH0PR13MB47934A5BC51DB0D0C1BD8778940E9@PH0PR13MB4793.namprd13.prod.outlook.com>
 <CALnP8ZZ0iEsMKuDqdyEV6noeM=dtp9Qqkh6RUp9LzMYtXKcT2A@mail.gmail.com>
 <062D20F4-34FD-47BA-AF56-7C806EC61070@redhat.com>
 <PH0PR13MB47936891023E497D61FE3AF494139@PH0PR13MB4793.namprd13.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28 Nov 2022, at 8:18, Tianyu Yuan wrote:

>> -----Original Message-----
>> From: Eelco Chaudron <echaudro@redhat.com>
>> Sent: Friday, November 25, 2022 10:33 PM
>> To: Marcelo Leitner <mleitner@redhat.com>
>> Cc: Tianyu Yuan <tianyu.yuan@corigine.com>; Jamal Hadi Salim
>> <jhs@mojatatu.com>; Simon Horman <simon.horman@corigine.com>;
>> netdev@vger.kernel.org; Cong Wang <xiyou.wangcong@gmail.com>; Davide
>> Caratti <dcaratti@redhat.com>; Edward Cree <edward.cree@amd.com>; Ilya=

>> Maximets <i.maximets@ovn.org>; Oz Shlomo <ozsh@nvidia.com>; Paul
>> Blakey <paulb@nvidia.com>; Vlad Buslov <vladbu@nvidia.com>;
>> dev@openvswitch.org; oss-drivers <oss-drivers@corigine.com>; Ziyang Ch=
en
>> <ziyang.chen@corigine.com>
>> Subject: Re: [PATCH/RFC net-next] tc: allow drivers to accept gact wit=
h PIPE
>> when offloading
>>
>>
>>
>> On 25 Nov 2022, at 15:19, Marcelo Leitner wrote:
>>
>>> On Fri, Nov 25, 2022 at 03:10:37AM +0000, Tianyu Yuan wrote:
>>>> On Fri, Nov 25, 2022 at 10:21 AM  Jamal Hadi Salim <jhs@mojatatu.com=
>
>> wrote:
>>>>
>>>>>
>>>>> I am not sure if the mlx5 changes will work since  they both seem t=
o
>>>>> be calling
>>>>> mlx5e_tc_act_get() which expects the act->id to exist in tc_acts_xx=
x
>>>>> tables, meaning mlx5e_tc_act_get() will always return you NULL  and=

>>>>> that check is hit before you check for ACT_PIPE.
>>>>>
>>>>> Something not obvious to me:
>>>>> Would all these drivers now be able to handle ACT_PIPE transparentl=
y
>>>>> as if no action is specified? Cant see the obvious connection to
>>>>> POLICE by just staring at the patch - is there and ACT_PIPE first t=
hen a
>> POLICE?
>>>>>  Another question:
>>>>> If the ACT_PIPE count is not being updated in s/w - is there a h/w
>>>>> equivalent stat being updated?
>>>>>
>>>>> cheers,
>>>>> jamal
>>>>>
>>>> Thanks Jamal for your review.
>>>>
>>>> About mlx5e_tc_act_get(), I'll later add PIPE action in tc_acts_nic
>>>> so that mlx5e_tc_act_get() will return the right act_id.
>>>>
>>>> In driver we choose just ignore this gact with ACT_PIPE, so after
>>>> parsing the filter(rule) from kernel, the remaining actions are just=
 like
>> what they used to be without changes in this patch. So the flow could =
be
>> processed as before.
>>>>
>>>> The connection between POLICE and ACT_PIPE may exist in userspace
>>>> (e.g. ovs), we could put a gact (PIPE) at the beginning place in eac=
h tc filter.
>> We will also have an OVS patch for this propose.
>>>>
>>>> I'm not very clear with your last case, but in expectation, the once=

>>>> the traffic is offloaded in h/w tc datapath, the stats will be
>>>> updated by the flower stats from hardware. And when the traffic is u=
sing
>> s/w tc datapath, the stats are from software.
>>>
>>> I'm still confused here. Take, for example cxgb4 driver below. It wil=
l
>>> simply ignore this action AFAICT. This is good because it will still
>>> offload whatever vswitchd would be offloading but then, I don't see
>>> how the stats will be right in the end. I think the hw stats will be
>>> zeroed, no? (this is already considering the per action stats change
>>> that Oz is working on, see [ RFC  net-next v2 0/2] net: flow_offload:=

>>> add support for per action hw stats)
>>>
>>> I think the drivers have to reject the action if they don't support
>>> it, and vswitchd will have to probe for proper support when starting.=

>>
>> I guess OVS userspace needs a simple way to determine which approach t=
o
>> use, i.e. if the kernel has this patch series applied. Or else it woul=
d not be
>> easy to migrate userspace to use this approach.
>
> Yes, we could modify OVS' acinclude.m4 to check if the current has appl=
ied such a patch
> series. If so, it will use this approach, otherwise, put actions in tc =
flower as before. So that
> we could ensure the traffic will offloaded correctly.

This needs to be a runtime check, we can=E2=80=99t assume the kernel capa=
bilities at build time.

>>> Other than this, patch seems good.
>>>
>>> Thanks,
>>> Marcelo
>>>
>>>>
>>>> B.R.
>>>> Tianyu
>>>>
>>>>>
>>>>> On Tue, Nov 22, 2022 at 6:21 AM Simon Horman
>>>>> <simon.horman@corigine.com> wrote:
>>>>>>
>>>>>> From: Tianyu Yuan <tianyu.yuan@corigine.com>
>>>>>>
>>>>>> Support gact with PIPE action when setting up gact in TC.
>>>>>> This PIPE gact could come first in each tc filter to update the
>>>>>> filter(flow) stats.
>>>>>>
>>>>>> The stats for each actons in a filter are updated by the flower
>>>>>> stats from HW(via netdev drivers) in kernel TC rather than drivers=
=2E
>>>>>>
>>>>>> In each netdev driver, we don't have to process this gact, but onl=
y
>>>>>> to ignore it to make sure the whole rule can be offloaded.
>>>>>>
>>>>>> Background:
>>>>>>
>>>>>> This is a proposed solution to a problem with a miss-match between=

>>>>>> TC police action instances - which may be shared between flows -
>>>>>> and OpenFlow meter actions - the action is per flow, while the
>>>>>> underlying meter may be shared. The key problem being that the
>>>>>> police action statistics are shared between flows, and this does
>>>>>> not match the requirement of OpenFlow for per-flow statistics.
>>>>>>
>>>>>> Ref: [ovs-dev] [PATCH] tests: fix reference output for meter
>>>>>> offload stats
>>>>>>
>>>>>> https://mail.openvswitch.org/pipermail/ovs-dev/2022-
>>>>> October/398363.htm
>>>>>> l
>>>>>>
>>>>>> Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
>>>>>> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>>>>>> ---
>>>>>>  drivers/net/dsa/ocelot/felix_vsc9959.c                     | 5 ++=
+++
>>>>>>  drivers/net/dsa/sja1105/sja1105_flower.c                   | 5 ++=
+++
>>>>>>  drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c       | 5 ++=
+++
>>>>>>  drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c | 6
>> ++++++
>>>>>>  drivers/net/ethernet/intel/ice/ice_tc_lib.c                | 5 ++=
+++
>>>>>>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c       | 5 ++=
+++
>>>>>>  drivers/net/ethernet/marvell/prestera/prestera_flower.c    | 5 ++=
+++
>>>>>>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c            | 5 ++=
+++
>>>>>>  drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c        | 6 ++=
++++
>>>>>>  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c            | 5 ++=
+++
>>>>>>  drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c      | 5
>> +++++
>>>>>>  drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c   | 4 ++=
++
>>>>>>  drivers/net/ethernet/mscc/ocelot_flower.c                  | 5 ++=
+++
>>>>>>  drivers/net/ethernet/netronome/nfp/flower/action.c         | 5 ++=
+++
>>>>>>  drivers/net/ethernet/qlogic/qede/qede_filter.c             | 5 ++=
+++
>>>>>>
>>>>>                               | 5 +++++
>>>>>>  drivers/net/ethernet/ti/cpsw_priv.c                        | 5 ++=
+++
>>>>>>  net/sched/act_gact.c                                       | 7 ++=
++---
>>>>>>  18 files changed, 90 insertions(+), 3 deletions(-)
>>>>>>
>>>>>>
>>>>>> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c
>>>>>> b/drivers/net/dsa/ocelot/felix_vsc9959.c
>>>>>> index b0ae8d6156f6..e54eb8e28386 100644
>>>>>> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
>>>>>> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
>>>>>> @@ -2217,6 +2217,11 @@ static int vsc9959_psfp_filter_add(struct
>>>>>> ocelot
>>>>> *ocelot, int port,
>>>>>>                         sfi.fmid =3D index;
>>>>>>                         sfi.maxsdu =3D a->police.mtu;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         mutex_unlock(&psfp->lock);
>>>>>>                         return -EOPNOTSUPP; diff --git
>>>>>> a/drivers/net/dsa/sja1105/sja1105_flower.c
>>>>>> b/drivers/net/dsa/sja1105/sja1105_flower.c
>>>>>> index fad5afe3819c..d3eeeeea152a 100644
>>>>>> --- a/drivers/net/dsa/sja1105/sja1105_flower.c
>>>>>> +++ b/drivers/net/dsa/sja1105/sja1105_flower.c
>>>>>> @@ -426,6 +426,11 @@ int sja1105_cls_flower_add(struct dsa_switch
>>>>>> *ds,
>>>>> int port,
>>>>>>                         if (rc)
>>>>>>                                 goto out;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(extack,
>>>>>>                                            "Action not supported")=
;
>>>>>> diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>>>>>> b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>>>>>> index dd9be229819a..443f405c0ed4 100644
>>>>>> --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>>>>>> +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_flower.c
>>>>>> @@ -770,6 +770,11 @@ int cxgb4_validate_flow_actions(struct
>>>>>> net_device
>>>>> *dev,
>>>>>>                 case FLOW_ACTION_QUEUE:
>>>>>>                         /* Do nothing. cxgb4_set_filter will valid=
ate */
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         netdev_err(dev, "%s: Unsupported action\n"=
, __func__);
>>>>>>                         return -EOPNOTSUPP; diff --git
>>>>>> a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>>>>>> b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>>>>>> index cacd454ac696..cfbf2f76e83a 100644
>>>>>> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>>>>>> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch-flower.c
>>>>>> @@ -378,6 +378,11 @@ static int
>>>>>> dpaa2_switch_tc_parse_action_acl(struct
>>>>> ethsw_core *ethsw,
>>>>>>         case FLOW_ACTION_DROP:
>>>>>>                 dpsw_act->action =3D DPSW_ACL_ACTION_DROP;
>>>>>>                 break;
>>>>>> +       /* Just ignore GACT with pipe action to let this action
>>>>>> + count the
>>>>> packets.
>>>>>> +        * The NIC doesn't have to process this action
>>>>>> +        */
>>>>>> +       case FLOW_ACTION_PIPE:
>>>>>> +               break;
>>>>>>         default:
>>>>>>                 NL_SET_ERR_MSG_MOD(extack,
>>>>>>                                    "Action not supported"); @@
>>>>>> -651,6
>>>>>> +656,7 @@ int dpaa2_switch_cls_flower_replace(struct
>>>>> dpaa2_switch_filter_block *block,
>>>>>>         case FLOW_ACTION_REDIRECT:
>>>>>>         case FLOW_ACTION_TRAP:
>>>>>>         case FLOW_ACTION_DROP:
>>>>>> +       case FLOW_ACTION_PIPE:
>>>>>>                 return dpaa2_switch_cls_flower_replace_acl(block, =
cls);
>>>>>>         case FLOW_ACTION_MIRRED:
>>>>>>                 return
>>>>>> dpaa2_switch_cls_flower_replace_mirror(block,
>>>>>> cls); diff --git a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>>>>>> b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>>>>>> index faba0f857cd9..5908ad4d0170 100644
>>>>>> --- a/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>>>>>> +++ b/drivers/net/ethernet/intel/ice/ice_tc_lib.c
>>>>>> @@ -642,6 +642,11 @@ ice_eswitch_tc_parse_action(struct
>>>>>> ice_tc_flower_fltr *fltr,
>>>>>>
>>>>>>                 break;
>>>>>>
>>>>>> +       /* Just ignore GACT with pipe action to let this action
>>>>>> + count the
>>>>> packets.
>>>>>> +        * The NIC doesn't have to process this action
>>>>>> +        */
>>>>>> +       case FLOW_ACTION_PIPE:
>>>>>> +               break;
>>>>>>         default:
>>>>>>                 NL_SET_ERR_MSG_MOD(fltr->extack, "Unsupported
>>>>>> action in
>>>>> switchdev mode");
>>>>>>                 return -EINVAL;
>>>>>> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>>>>>> b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>>>>>> index e64318c110fd..fc05897adb70 100644
>>>>>> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>>>>>> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
>>>>>> @@ -450,6 +450,11 @@ static int otx2_tc_parse_actions(struct
>>>>>> otx2_nic
>>>>> *nic,
>>>>>>                 case FLOW_ACTION_MARK:
>>>>>>                         mark =3D act->mark;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         return -EOPNOTSUPP;
>>>>>>                 }
>>>>>> diff --git
>>>>>> a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>>>>>> b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>>>>>> index 91a478b75cbf..9686ed086e35 100644
>>>>>> --- a/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>>>>>> +++ b/drivers/net/ethernet/marvell/prestera/prestera_flower.c
>>>>>> @@ -126,6 +126,11 @@ static int
>>>>>> prestera_flower_parse_actions(struct
>>>>> prestera_flow_block *block,
>>>>>>                         if (err)
>>>>>>                                 return err;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported ac=
tion");
>>>>>>                         pr_err("Unsupported action\n"); diff --git=

>>>>>> a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>>>>>> b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>>>>>> index 81afd5ee3fbf..91e4d3fcc756 100644
>>>>>> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>>>>>> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
>>>>>> @@ -344,6 +344,11 @@ mtk_flow_offload_replace(struct mtk_eth
>> *eth,
>>>>> struct flow_cls_offload *f)
>>>>>>                         data.pppoe.sid =3D act->pppoe.sid;
>>>>>>                         data.pppoe.num++;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         return -EOPNOTSUPP;
>>>>>>                 }
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>>>>>> index b08339d986d5..231660cb1daf 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
>>>>>> @@ -544,6 +544,12 @@ mlx5e_rep_indr_replace_act(struct
>>>>> mlx5e_rep_priv *rpriv,
>>>>>>                 if (!act->offload_action)
>>>>>>                         continue;
>>>>>>
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               if (action->id =3D=3D FLOW_ACTION_PIPE)
>>>>>> +                       continue;
>>>>>> +
>>>>>>                 if (!act->offload_action(priv, fl_act, action))
>>>>>>                         add =3D true;
>>>>>>         }
>>>>>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> index 3782f0097292..adac2ce9b24f 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
>>>>>> @@ -3853,6 +3853,11 @@ parse_tc_actions(struct
>>>>>> mlx5e_tc_act_parse_state *parse_state,
>>>>>>
>>>>>>         flow_action_for_each(i, _act, &flow_action_reorder) {
>>>>>>                 act =3D *_act;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               if (act->id =3D=3D FLOW_ACTION_PIPE)
>>>>>> +                       continue;
>>>>>>                 tc_act =3D mlx5e_tc_act_get(act->id, ns_type);
>>>>>>                 if (!tc_act) {
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Not implemente=
d
>>>>>> offload action"); diff --git
>>>>>> a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>>>>>> b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>>>>>> index e91fb205e0b4..9270bf9581c7 100644
>>>>>> --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>>>>>> +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
>>>>>> @@ -266,6 +266,11 @@ static int
>>>>>> mlxsw_sp_flower_parse_actions(struct
>>>>> mlxsw_sp *mlxsw_sp,
>>>>>>                                 return err;
>>>>>>                         break;
>>>>>>                         }
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported ac=
tion");
>>>>>>                         dev_err(mlxsw_sp->bus_info->dev,
>>>>>> "Unsupported action\n"); diff --git
>>>>>> a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>>>>>> b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>>>>>> index bd6bd380ba34..e32f5b5d1e95 100644
>>>>>> --- a/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>>>>>> +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_tc_flower.c
>>>>>> @@ -692,6 +692,10 @@ static int sparx5_tc_flower_replace(struct
>>>>> net_device *ndev,
>>>>>>                         break;
>>>>>>                 case FLOW_ACTION_GOTO:
>>>>>>                         /* Links between VCAPs will be added later=

>>>>>> */
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>>                         break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(fco->common.extack,
>>>>>> diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c
>>>>>> b/drivers/net/ethernet/mscc/ocelot_flower.c
>>>>>> index 7c0897e779dc..b8e01af0fb48 100644
>>>>>> --- a/drivers/net/ethernet/mscc/ocelot_flower.c
>>>>>> +++ b/drivers/net/ethernet/mscc/ocelot_flower.c
>>>>>> @@ -492,6 +492,11 @@ static int ocelot_flower_parse_action(struct
>>>>>> ocelot
>>>>> *ocelot, int port,
>>>>>>                         }
>>>>>>                         filter->type =3D OCELOT_PSFP_FILTER_OFFLOA=
D;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Cannot offload=
 action");
>>>>>>                         return -EOPNOTSUPP; diff --git
>>>>>> a/drivers/net/ethernet/netronome/nfp/flower/action.c
>>>>>> b/drivers/net/ethernet/netronome/nfp/flower/action.c
>>>>>> index 2b383d92d7f5..57fd83b8e54a 100644
>>>>>> --- a/drivers/net/ethernet/netronome/nfp/flower/action.c
>>>>>> +++ b/drivers/net/ethernet/netronome/nfp/flower/action.c
>>>>>> @@ -1209,6 +1209,11 @@ nfp_flower_loop_action(struct nfp_app
>> *app,
>>>>> const struct flow_action_entry *act,
>>>>>>                 if (err)
>>>>>>                         return err;
>>>>>>                 break;
>>>>>> +       /* Just ignore GACT with pipe action to let this action
>>>>>> + count the
>>>>> packets.
>>>>>> +        * The NIC doesn't have to process this action
>>>>>> +        */
>>>>>> +       case FLOW_ACTION_PIPE:
>>>>>> +               break;
>>>>>>         default:
>>>>>>                 /* Currently we do not handle any other actions. *=
/
>>>>>>                 NL_SET_ERR_MSG_MOD(extack, "unsupported offload:
>>>>>> unsupported action in action list"); diff --git
>>>>>> a/drivers/net/ethernet/qlogic/qede/qede_filter.c
>>>>>> b/drivers/net/ethernet/qlogic/qede/qede_filter.c
>>>>>> index 3010833ddde3..69110d5978d8 100644
>>>>>> --- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
>>>>>> +++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
>>>>>> @@ -1691,6 +1691,11 @@ static int qede_parse_actions(struct
>>>>>> qede_dev
>>>>> *edev,
>>>>>>                                 return -EINVAL;
>>>>>>                         }
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         return -EINVAL;
>>>>>>                 }
>>>>>> diff --git a/drivers/net/ethernet/sfc/tc.c
>>>>>> b/drivers/net/ethernet/sfc/tc.c index deeaab9ee761..7256bbcdcc59
>>>>>> 100644
>>>>>> --- a/drivers/net/ethernet/sfc/tc.c
>>>>>> +++ b/drivers/net/ethernet/sfc/tc.c
>>>>>> @@ -494,6 +494,11 @@ static int efx_tc_flower_replace(struct
>>>>>> efx_nic
>>>>> *efx,
>>>>>>                         }
>>>>>>                         *act =3D save;
>>>>>>                         break;
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_FMT_MOD(extack, "Unhandled
>> action %u",
>>>>>>                                                fa->id); diff --git=

>>>>>> a/drivers/net/ethernet/ti/cpsw_priv.c
>>>>>> b/drivers/net/ethernet/ti/cpsw_priv.c
>>>>>> index 758295c898ac..c0ac58db64d4 100644
>>>>>> --- a/drivers/net/ethernet/ti/cpsw_priv.c
>>>>>> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
>>>>>> @@ -1492,6 +1492,11 @@ static int
>>>>>> cpsw_qos_configure_clsflower(struct
>>>>>> cpsw_priv *priv, struct flow_cls_
>>>>>>
>>>>>>                         return cpsw_qos_clsflower_add_policer(priv=
,
>>>>>> extack, cls,
>>>>>>
>>>>>> act->police.rate_pkt_ps);
>>>>>> +               /* Just ignore GACT with pipe action to let this
>>>>>> + action count the
>>>>> packets.
>>>>>> +                * The NIC doesn't have to process this action
>>>>>> +                */
>>>>>> +               case FLOW_ACTION_PIPE:
>>>>>> +                       break;
>>>>>>                 default:
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Action not sup=
ported");
>>>>>>                         return -EOPNOTSUPP; diff --git
>>>>>> a/net/sched/act_gact.c b/net/sched/act_gact.c index
>>>>>> 62d682b96b88..82d1371e251e 100644
>>>>>> --- a/net/sched/act_gact.c
>>>>>> +++ b/net/sched/act_gact.c
>>>>>> @@ -250,15 +250,14 @@ static int tcf_gact_offload_act_setup(struct=

>>>>> tc_action *act, void *entry_data,
>>>>>>                 } else if (is_tcf_gact_goto_chain(act)) {
>>>>>>                         entry->id =3D FLOW_ACTION_GOTO;
>>>>>>                         entry->chain_index =3D
>>>>>> tcf_gact_goto_chain_index(act);
>>>>>> +               } else if (is_tcf_gact_pipe(act)) {
>>>>>> +                       entry->id =3D FLOW_ACTION_PIPE;
>>>>>>                 } else if (is_tcf_gact_continue(act)) {
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"c=
ontinue\"
>>>>> action is not supported");
>>>>>>                         return -EOPNOTSUPP;
>>>>>>                 } else if (is_tcf_gact_reclassify(act)) {
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Offload of \"r=
eclassify\"
>>>>> action is not supported");
>>>>>>                         return -EOPNOTSUPP;
>>>>>> -               } else if (is_tcf_gact_pipe(act)) {
>>>>>> -                       NL_SET_ERR_MSG_MOD(extack, "Offload of \"p=
ipe\"
>> action is
>>>>> not supported");
>>>>>> -                       return -EOPNOTSUPP;
>>>>>>                 } else {
>>>>>>                         NL_SET_ERR_MSG_MOD(extack, "Unsupported
>>>>>> generic action
>>>>> offload");
>>>>>>                         return -EOPNOTSUPP; @@ -275,6 +274,8 @@
>>>>>> static int tcf_gact_offload_act_setup(struct tc_action *act, void
>> *entry_data,
>>>>>>                         fl_action->id =3D FLOW_ACTION_TRAP;
>>>>>>                 else if (is_tcf_gact_goto_chain(act))
>>>>>>                         fl_action->id =3D FLOW_ACTION_GOTO;
>>>>>> +               else if (is_tcf_gact_pipe(act))
>>>>>> +                       fl_action->id =3D FLOW_ACTION_PIPE;
>>>>>>                 else
>>>>>>                         return -EOPNOTSUPP;
>>>>>>         }
>>>>>> --
>>>>>> 2.30.2
>>>>>>

