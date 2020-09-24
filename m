Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8322E2778E2
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727254AbgIXTB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:01:58 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:7455 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgIXTB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:01:58 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f6ced190001>; Thu, 24 Sep 2020 12:01:45 -0700
Received: from [10.21.180.144] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 24 Sep
 2020 19:01:46 +0000
Subject: Re: [PATCH net-next RFC v5 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
 <1600445211-31078-2-git-send-email-moshe@mellanox.com>
 <20200923112543.4dc12600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@nvidia.com>
Message-ID: <9bdd7d82-aed2-aa0a-f167-eaae237d658c@nvidia.com>
Date:   Thu, 24 Sep 2020 22:01:42 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200923112543.4dc12600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600974105; bh=do5D2NprWplLArzUeeq6EDA2qAmpKNlnWYkzPRf0Eug=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Transfer-Encoding:
         Content-Language:X-Originating-IP:X-ClientProxiedBy;
        b=PImncdeAVQHeqqbe68p4mC94ZglYJBWuvTTpDEQiB9OcPkVHJyj7st+CL65yd3OV2
         QcgiExfow2lmsMGekvAVzJAFgMbdMcuzgVs/s68dcyF6zim0Ni0iz8+EadLYAVCFzu
         6yjI5SCavGfeMSzGbrWZfQX2edwm17cVS7cOiw2gikwVfww1k69Avdhu0hlZokWl0S
         6ef0WLWnRCyiSz1Qz+YHmWhHJsrHWXA0Mf10jAQPG8TlZVFxDk2D0Ilcia9qfC5DuP
         XyYJrGCGwnFafVsQeHZD489wrrdX+llEKumf9U52Z9mLUbaTCs0OcOHgGLCuguG+YK
         I6lOktOoD7ZqQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/23/2020 9:25 PM, Jakub Kicinski wrote:
>
> On Fri, 18 Sep 2020 19:06:37 +0300 Moshe Shemesh wrote:
>> Add devlink reload action to allow the user to request a specific reload
>> action. The action parameter is optional, if not specified then devlink
>> driver re-init action is used (backward compatible).
>> Note that when required to do firmware activation some drivers may need
>> to reload the driver. On the other hand some drivers may need to reset
>> the firmware to reinitialize the driver entities. Therefore, the devlink
>> reload command returns the actions which were actually performed.
>> Reload actions supported are:
>> driver_reinit: driver entities re-initialization, applying devlink-param
>>                 and devlink-resource values.
>> fw_activate: firmware activate.
>>
>> command examples:
>> $devlink dev reload pci/0000:82:00.0 action driver_reinit
>> reload_actions_performed:
>>    driver_reinit
>>
>> $devlink dev reload pci/0000:82:00.0 action fw_activate
>> reload_actions_performed:
>>    driver_reinit fw_activate
>>
>> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
>> @@ -3971,15 +3972,19 @@ static int mlx4_devlink_reload_up(struct devlink=
 *devlink,
>>        int err;
>>
>>        err =3D mlx4_restart_one_up(persist->pdev, true, devlink);
>> -     if (err)
>> +     if (err) {
>>                mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=
=3D%d\n",
>>                         err);
>> +             return err;
>> +     }
>> +     *actions_performed =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> FWIW I think drivers should be able to assign this even if they return
> an error. On error there is no certainty what actions were actually
> performed (e.g. when timeout happened but the device did the reset a
> little later) so this argument should not be interpreted in presence of
> errors, anyway.


Not sure I got it. Do you mean driver can assign it anyway and devlink=20
should ignore in case of failure ?

As I implemented here devlink already ignores actions_performed in case=20
driver returns with error.

> Also consider providing a second enum for the BIT(xyz)s.
OK.
>> -static bool devlink_reload_supported(const struct devlink *devlink)
>> +static bool devlink_reload_supported(const struct devlink_ops *ops)
>>   {
>> -     return devlink->ops->reload_down && devlink->ops->reload_up;
>> +     return ops->reload_down && ops->reload_up;
>>   }
> Please make the change to devlink_reload_supported() a separate patch.


Ack.

>> -
>> +
> What is this white space funk? =F0=9F=A4=94


Missed that.

>>   static void devlink_reload_failed_set(struct devlink *devlink,
>>                                      bool reload_failed)
>>   {
>> @@ -2969,32 +2975,79 @@ bool devlink_is_reload_failed(const struct devli=
nk *devlink)
>>   EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>>
>>   static int devlink_reload(struct devlink *devlink, struct net *dest_ne=
t,
>> -                       struct netlink_ext_ack *extack)
>> +                       enum devlink_reload_action action, struct netlin=
k_ext_ack *extack,
>> +                       unsigned long *actions_performed)
>>   {
>>        int err;
>>
>>        if (!devlink->reload_enabled)
>>                return -EOPNOTSUPP;
>>
>> -     err =3D devlink->ops->reload_down(devlink, !!dest_net, extack);
>> +     err =3D devlink->ops->reload_down(devlink, !!dest_net, action, ext=
ack);
>>        if (err)
>>                return err;
>>
>>        if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>>                devlink_reload_netns_change(devlink, dest_net);
>>
>> -     err =3D devlink->ops->reload_up(devlink, extack);
>> +     err =3D devlink->ops->reload_up(devlink, action, extack, actions_p=
erformed);
>>        devlink_reload_failed_set(devlink, !!err);
>> -     return err;
>> +     if (err)
>> +             return err;
>> +
>> +     WARN_ON(!test_bit(action, actions_performed));
>> +     return 0;
>> +}
>> +
>> +static int
>> +devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
>> +                                      struct devlink *devlink,
>> +                                      unsigned long actions_performed,
>> +                                      enum devlink_command cmd, u32 por=
tid,
>> +                                      u32 seq, int flags)
>> +{
>> +     struct nlattr *actions_performed_attr;
>> +     void *hdr;
>> +     int i;
>> +
>> +     hdr =3D genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, c=
md);
>> +     if (!hdr)
>> +             return -EMSGSIZE;
>> +
>> +     if (devlink_nl_put_handle(msg, devlink))
>> +             goto genlmsg_cancel;
>> +
>> +     actions_performed_attr =3D nla_nest_start(msg, DEVLINK_ATTR_RELOAD=
_ACTIONS_PERFORMED);
>> +     if (!actions_performed_attr)
>> +             goto genlmsg_cancel;
>> +
>> +     for (i =3D 0; i <=3D DEVLINK_RELOAD_ACTION_MAX; i++) {
>> +             if (!test_bit(i, &actions_performed))
>> +                     continue;
>> +             if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
>> +                     goto actions_performed_nest_cancel;
> Why not just return a mask? You need a special attribute for the nest,
> anyway..
>
> User space would probably actually prefer to have a single attr than an
> iteration over a nest...
OK.
>> +     }
>> +     nla_nest_end(msg, actions_performed_attr);
>> +     genlmsg_end(msg, hdr);
>> +     return 0;
>> +
>> +actions_performed_nest_cancel:
>> +     nla_nest_cancel(msg, actions_performed_attr);
>> +genlmsg_cancel:
>> +     genlmsg_cancel(msg, hdr);
>> +     return -EMSGSIZE;
>>   }
>>
>>   static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info=
 *info)
>>   {
>>        struct devlink *devlink =3D info->user_ptr[0];
>> +     enum devlink_reload_action action;
>> +     unsigned long actions_performed;
>>        struct net *dest_net =3D NULL;
>> +     struct sk_buff *msg;
>>        int err;
>>
>> -     if (!devlink_reload_supported(devlink))
>> +     if (!devlink_reload_supported(devlink->ops))
>>                return -EOPNOTSUPP;
>>
>>        err =3D devlink_resources_validate(devlink, NULL, info);
>> @@ -3011,12 +3064,43 @@ static int devlink_nl_cmd_reload(struct sk_buff =
*skb, struct genl_info *info)
>>                        return PTR_ERR(dest_net);
>>        }
>>
>> -     err =3D devlink_reload(devlink, dest_net, info->extack);
>> +     if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> +             action =3D nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTI=
ON]);
>> +     else
>> +             action =3D DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
>> +
>> +     if (action =3D=3D DEVLINK_RELOAD_ACTION_UNSPEC) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
>> +             return -EINVAL;
>> +     } else if (!devlink_reload_action_is_supported(devlink, action)) {
>> +             NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action =
is not supported by the driver");
>> +             return -EOPNOTSUPP;
>> +     }
>> +
>> +     err =3D devlink_reload(devlink, dest_net, action, info->extack, &a=
ctions_performed);
> Perhaps we can pass the requested action to the driver via
> actions_performed already, and then all the drivers which
> only do what they're asked to don't have to touch it?


Not sure about it. Note that in the next patch I add here limit_level=20
and that has only input param, so I think it would be confusing.

>>        if (dest_net)
>>                put_net(dest_net);
>>
>> -     return err;
>> +     if (err)
>> +             return err;
>> +     /* For backward compatibility generate reply only if attributes us=
ed by user */
>> +     if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
>> +             return 0;
>> +
>> +     msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +     if (!msg)
>> +             return -ENOMEM;
>> +
>> +     err =3D devlink_nl_reload_actions_performed_fill(msg, devlink, act=
ions_performed,
>> +                                                    DEVLINK_CMD_RELOAD,=
 info->snd_portid,
>> +                                                    info->snd_seq, 0);
>> +     if (err) {
>> +             nlmsg_free(msg);
>> +             return err;
>> +     }
>> +
>> +     return genlmsg_reply(msg, info);
> Are you using devlink_nl_reload_actions_performed_fill() somewhere else?
No
> I'd move the nlmsg_new() / genlmsg_reply() into the helper.


Can do it, but there are many _fill() functions in devlink.c code to=20
fill the data, none of them include nlmsg_new() and genlmsg_reply()=20
that's always in the calling function, even if the calling function adds=20
only that. So I guess I will leave it for consistency.

>>   }
>>
>>   static int devlink_nl_flash_update_fill(struct sk_buff *msg,
>> @@ -7069,6 +7153,7 @@ static const struct nla_policy devlink_nl_policy[D=
EVLINK_ATTR_MAX + 1] =3D {
>>        [DEVLINK_ATTR_TRAP_POLICER_RATE] =3D { .type =3D NLA_U64 },
>>        [DEVLINK_ATTR_TRAP_POLICER_BURST] =3D { .type =3D NLA_U64 },
>>        [DEVLINK_ATTR_PORT_FUNCTION] =3D { .type =3D NLA_NESTED },
>> +     [DEVLINK_ATTR_RELOAD_ACTION] =3D { .type =3D NLA_U8 },
> Why not just range validation here?


All devlink attributes that pass here go through devlink_nl_poicy this=20
way, including other enums.

I think changing that should be in a different patch for all, not in=20
this patchset.

>>   };
>>
>>   static const struct genl_ops devlink_nl_ops[] =3D {
>> @@ -7402,6 +7487,20 @@ static struct genl_family devlink_nl_family __ro_=
after_init =3D {
>>        .n_mcgrps       =3D ARRAY_SIZE(devlink_nl_mcgrps),
>>   };
>>
>> +static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
>> +{
>> +     if (!devlink_reload_supported(ops)) {
>> +             if (WARN_ON(ops->supported_reload_actions))
>> +                     return false;
>> +             return true;
>> +     }
>> +
>> +     if (WARN_ON(ops->supported_reload_actions >=3D BIT(__DEVLINK_RELOA=
D_ACTION_MAX) ||
>> +                 ops->supported_reload_actions <=3D BIT(DEVLINK_RELOAD_=
ACTION_UNSPEC)))
> This won't protect you from ACTION_UNSPEC being set..
>
> WARN_ON(ops->supported_reload_actions & ~GENMASK(...))


Right, I will fix.

>> +             return false;
>> +     return true;
>> +}
