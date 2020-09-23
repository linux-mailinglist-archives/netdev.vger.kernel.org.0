Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4F0275FC5
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgIWSZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:25:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgIWSZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:25:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB8920791;
        Wed, 23 Sep 2020 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600885545;
        bh=Z8z/DRRDmasHvJPs+3K/boEYqtRFjClyotoY3e+GUXQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A3NoAIfY60Y9mc6WjPjy2Rq/PB65kSJ/w7ATrHcB2x/Uxxb1IA0dD+9VhKawZyFs3
         RT10cRPZpY9EZAYszRsXF87OYPcSSWS8duEGRdn9nim5eRze4OzROB7UAJend31K7I
         4QvM0Wfwy+hege/E40zcIJZ26yEVe83jrEL/YsuY=
Date:   Wed, 23 Sep 2020 11:25:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v5 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200923112543.4dc12600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600445211-31078-2-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
        <1600445211-31078-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 19:06:37 +0300 Moshe Shemesh wrote:
> Add devlink reload action to allow the user to request a specific reload
> action. The action parameter is optional, if not specified then devlink
> driver re-init action is used (backward compatible).
> Note that when required to do firmware activation some drivers may need
> to reload the driver. On the other hand some drivers may need to reset
> the firmware to reinitialize the driver entities. Therefore, the devlink
> reload command returns the actions which were actually performed.
> Reload actions supported are:
> driver_reinit: driver entities re-initialization, applying devlink-param
>                and devlink-resource values.
> fw_activate: firmware activate.
>=20
> command examples:
> $devlink dev reload pci/0000:82:00.0 action driver_reinit
> reload_actions_performed:
>   driver_reinit
>=20
> $devlink dev reload pci/0000:82:00.0 action fw_activate
> reload_actions_performed:
>   driver_reinit fw_activate
>=20
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

> @@ -3971,15 +3972,19 @@ static int mlx4_devlink_reload_up(struct devlink =
*devlink,
>  	int err;
> =20
>  	err =3D mlx4_restart_one_up(persist->pdev, true, devlink);
> -	if (err)
> +	if (err) {
>  		mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=3D%d\n",
>  			 err);
> +		return err;
> +	}
> +	*actions_performed =3D BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);

FWIW I think drivers should be able to assign this even if they return
an error. On error there is no certainty what actions were actually
performed (e.g. when timeout happened but the device did the reset a
little later) so this argument should not be interpreted in presence of
errors, anyway.

Also consider providing a second enum for the BIT(xyz)s.

> -static bool devlink_reload_supported(const struct devlink *devlink)
> +static bool devlink_reload_supported(const struct devlink_ops *ops)
>  {
> -	return devlink->ops->reload_down && devlink->ops->reload_up;
> +	return ops->reload_down && ops->reload_up;
>  }

Please make the change to devlink_reload_supported() a separate patch.

> -
> +

What is this white space funk? =F0=9F=A4=94

>  static void devlink_reload_failed_set(struct devlink *devlink,
>  				      bool reload_failed)
>  {
> @@ -2969,32 +2975,79 @@ bool devlink_is_reload_failed(const struct devlin=
k *devlink)
>  EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
> =20
>  static int devlink_reload(struct devlink *devlink, struct net *dest_net,
> -			  struct netlink_ext_ack *extack)
> +			  enum devlink_reload_action action, struct netlink_ext_ack *extack,
> +			  unsigned long *actions_performed)
>  {
>  	int err;
> =20
>  	if (!devlink->reload_enabled)
>  		return -EOPNOTSUPP;
> =20
> -	err =3D devlink->ops->reload_down(devlink, !!dest_net, extack);
> +	err =3D devlink->ops->reload_down(devlink, !!dest_net, action, extack);
>  	if (err)
>  		return err;
> =20
>  	if (dest_net && !net_eq(dest_net, devlink_net(devlink)))
>  		devlink_reload_netns_change(devlink, dest_net);
> =20
> -	err =3D devlink->ops->reload_up(devlink, extack);
> +	err =3D devlink->ops->reload_up(devlink, action, extack, actions_perfor=
med);
>  	devlink_reload_failed_set(devlink, !!err);
> -	return err;
> +	if (err)
> +		return err;
> +
> +	WARN_ON(!test_bit(action, actions_performed));
> +	return 0;
> +}
> +
> +static int
> +devlink_nl_reload_actions_performed_fill(struct sk_buff *msg,
> +					 struct devlink *devlink,
> +					 unsigned long actions_performed,
> +					 enum devlink_command cmd, u32 portid,
> +					 u32 seq, int flags)
> +{
> +	struct nlattr *actions_performed_attr;
> +	void *hdr;
> +	int i;
> +
> +	hdr =3D genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
> +	if (!hdr)
> +		return -EMSGSIZE;
> +
> +	if (devlink_nl_put_handle(msg, devlink))
> +		goto genlmsg_cancel;
> +
> +	actions_performed_attr =3D nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTI=
ONS_PERFORMED);
> +	if (!actions_performed_attr)
> +		goto genlmsg_cancel;
> +
> +	for (i =3D 0; i <=3D DEVLINK_RELOAD_ACTION_MAX; i++) {
> +		if (!test_bit(i, &actions_performed))
> +			continue;
> +		if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, i))
> +			goto actions_performed_nest_cancel;

Why not just return a mask? You need a special attribute for the nest,
anyway..

User space would probably actually prefer to have a single attr than an
iteration over a nest...

> +	}
> +	nla_nest_end(msg, actions_performed_attr);
> +	genlmsg_end(msg, hdr);
> +	return 0;
> +
> +actions_performed_nest_cancel:
> +	nla_nest_cancel(msg, actions_performed_attr);
> +genlmsg_cancel:
> +	genlmsg_cancel(msg, hdr);
> +	return -EMSGSIZE;
>  }
> =20
>  static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *=
info)
>  {
>  	struct devlink *devlink =3D info->user_ptr[0];
> +	enum devlink_reload_action action;
> +	unsigned long actions_performed;
>  	struct net *dest_net =3D NULL;
> +	struct sk_buff *msg;
>  	int err;
> =20
> -	if (!devlink_reload_supported(devlink))
> +	if (!devlink_reload_supported(devlink->ops))
>  		return -EOPNOTSUPP;
> =20
>  	err =3D devlink_resources_validate(devlink, NULL, info);
> @@ -3011,12 +3064,43 @@ static int devlink_nl_cmd_reload(struct sk_buff *=
skb, struct genl_info *info)
>  			return PTR_ERR(dest_net);
>  	}
> =20
> -	err =3D devlink_reload(devlink, dest_net, info->extack);
> +	if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> +		action =3D nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
> +	else
> +		action =3D DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
> +
> +	if (action =3D=3D DEVLINK_RELOAD_ACTION_UNSPEC) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
> +		return -EINVAL;
> +	} else if (!devlink_reload_action_is_supported(devlink, action)) {
> +		NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not suppo=
rted by the driver");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	err =3D devlink_reload(devlink, dest_net, action, info->extack, &action=
s_performed);

Perhaps we can pass the requested action to the driver via
actions_performed already, and then all the drivers which=20
only do what they're asked to don't have to touch it?

>  	if (dest_net)
>  		put_net(dest_net);
> =20
> -	return err;
> +	if (err)
> +		return err;
> +	/* For backward compatibility generate reply only if attributes used by=
 user */
> +	if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> +		return 0;
> +
> +	msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	err =3D devlink_nl_reload_actions_performed_fill(msg, devlink, actions_=
performed,
> +						       DEVLINK_CMD_RELOAD, info->snd_portid,
> +						       info->snd_seq, 0);
> +	if (err) {
> +		nlmsg_free(msg);
> +		return err;
> +	}
> +
> +	return genlmsg_reply(msg, info);

Are you using devlink_nl_reload_actions_performed_fill() somewhere else?
I'd move the nlmsg_new() / genlmsg_reply() into the helper.

>  }
> =20
>  static int devlink_nl_flash_update_fill(struct sk_buff *msg,
> @@ -7069,6 +7153,7 @@ static const struct nla_policy devlink_nl_policy[DE=
VLINK_ATTR_MAX + 1] =3D {
>  	[DEVLINK_ATTR_TRAP_POLICER_RATE] =3D { .type =3D NLA_U64 },
>  	[DEVLINK_ATTR_TRAP_POLICER_BURST] =3D { .type =3D NLA_U64 },
>  	[DEVLINK_ATTR_PORT_FUNCTION] =3D { .type =3D NLA_NESTED },
> +	[DEVLINK_ATTR_RELOAD_ACTION] =3D { .type =3D NLA_U8 },

Why not just range validation here?

>  };
> =20
>  static const struct genl_ops devlink_nl_ops[] =3D {
> @@ -7402,6 +7487,20 @@ static struct genl_family devlink_nl_family __ro_a=
fter_init =3D {
>  	.n_mcgrps	=3D ARRAY_SIZE(devlink_nl_mcgrps),
>  };
> =20
> +static bool devlink_reload_actions_valid(const struct devlink_ops *ops)
> +{
> +	if (!devlink_reload_supported(ops)) {
> +		if (WARN_ON(ops->supported_reload_actions))
> +			return false;
> +		return true;
> +	}
> +
> +	if (WARN_ON(ops->supported_reload_actions >=3D BIT(__DEVLINK_RELOAD_ACT=
ION_MAX) ||
> +		    ops->supported_reload_actions <=3D BIT(DEVLINK_RELOAD_ACTION_UNSPE=
C)))

This won't protect you from ACTION_UNSPEC being set..

WARN_ON(ops->supported_reload_actions & ~GENMASK(...))

> +		return false;
> +	return true;
> +}
