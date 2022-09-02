Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D795AA640
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 05:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbiIBDWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 23:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIBDWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 23:22:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21549564C8;
        Thu,  1 Sep 2022 20:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B09CC61EA4;
        Fri,  2 Sep 2022 03:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8643EC433C1;
        Fri,  2 Sep 2022 03:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662088921;
        bh=vgggjnwSi12Tj/VroAR1dh/1zC4HRD7ys9U3EW00yBs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=B4ju/ZJAY/x9d5wubi8BI/qiyIH6e1/H/3vvbuUnU1OuMy5g2ND5CFLnvITdI7Ino
         2RgSzAxcV9/lpoJQiQU29BgdPN/sNXt4mfKJX3Nhe++rJ5AWXenrQ+FW3awuA/TDwL
         DxjLhC2Qe0XaaglRgq/smKHuWOKzZNjMyRR5Y0bDHXO0jjJiMpv5krSe2Of3NAB+mv
         JCdADVEtY83uoAW4PROkd2fS54gpbg8mytaGbbqpmJS2jFYjrUOgwlry7b2dOFl+st
         uYICNyPJUDSHMgBW6Z3BKnjUVcaKJvZ2FO5fEfpSVVeUdt4pO0td0zCwlQslfQib8P
         pH8qr2BfOmxmQ==
Date:   Thu, 1 Sep 2022 20:21:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 5/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220901202159.2a600c70@kernel.org>
In-Reply-To: <20220831133240.3236779-6-o.rempel@pengutronix.de>
References: <20220831133240.3236779-1-o.rempel@pengutronix.de>
        <20220831133240.3236779-6-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 31 Aug 2022 15:32:38 +0200 Oleksij Rempel wrote:
> +/**
> + * pse_ethtool_get_status - get status of PSE control
> + * @psec: PSE control pointer
> + * @extack: extack for reporting useful error messages
> + * @status: struct to store PSE status
> + */
> +int pse_ethtool_get_status(struct pse_control *psec,
> +			   struct netlink_ext_ack *extack,
> +			   struct pse_control_status *status)
> +{
> +	const struct pse_controller_ops *ops;
> +	int err;
> +
> +	if (!psec)
> +		return 0;

Defensive programming?

> +	if (WARN_ON(IS_ERR(psec)))
> +		return -EINVAL;
> +
> +	ops = psec->pcdev->ops;
> +
> +	if (!ops->ethtool_get_status) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PSE driver does not support status report");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	mutex_lock(&psec->pcdev->lock);
> +	err = ops->ethtool_get_status(psec->pcdev, psec->id, extack, status);
> +	mutex_unlock(&psec->pcdev->lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(pse_ethtool_get_status);
> +
> +/**
> + * pse_ethtool_set_config - set PSE control configuration
> + * @psec: PSE control pointer
> + * @extack: extack for reporting useful error messages
> + * @config: Configuration of the test to run
> + */
> +int pse_ethtool_set_config(struct pse_control *psec,
> +			   struct netlink_ext_ack *extack,
> +			   const struct pse_control_config *config)
> +{
> +	const struct pse_controller_ops *ops;
> +	int err;
> +
> +	if (!psec)
> +		return 0;
> +
> +	if (WARN_ON(IS_ERR(psec)))
> +		return -EINVAL;

ditto

> +	ops = psec->pcdev->ops;
> +
> +	if (!ops->ethtool_set_config) {
> +		NL_SET_ERR_MSG(extack,
> +			       "PSE driver does not configuration");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	mutex_lock(&psec->pcdev->lock);
> +	err = ops->ethtool_set_config(psec->pcdev, psec->id, extack, config);
> +	mutex_unlock(&psec->pcdev->lock);
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(pse_ethtool_set_config);

> +int pse_ethtool_get_status(struct pse_control *psec,
> +			   struct netlink_ext_ack *extack,
> +			   struct pse_control_status *status)
> +{
> +	return -ENOTSUPP;

EOPNOTSUPP, please run checkpatch --strict on this patch.
All of the complaints look legit at a glance.


> +	ETHTOOL_MSG_PSE_NTF,

I don't see you calling the ethtool_notify() function, does this ever

> +static int pse_prepare_data(const struct ethnl_req_info *req_base,
> +			       struct ethnl_reply_data *reply_base,
> +			       struct genl_info *info)
> +{
> +	struct pse_reply_data *data = PSE_REPDATA(reply_base);
> +	struct net_device *dev = reply_base->dev;
> +	int ret;
> +
> +	ret = ethnl_ops_begin(dev);
> +	if (ret < 0)
> +		return 0;

humpf, return ret;?

> +	ret = pse_get_pse_attributs(dev, info->extack, data);
> +
> +	ethnl_ops_complete(dev);
> +
> +	return ret;
> +}
> +
> +static int pse_reply_size(const struct ethnl_req_info *req_base,
> +			  const struct ethnl_reply_data *reply_base)
> +{
> +	const struct pse_reply_data *data = PSE_REPDATA(reply_base);
> +	const struct pse_control_status *st = &data->status;
> +	int len = 0;
> +
> +	if (st->podl_admin_state >= 0)

UNKNOWN is now 1, should be > 0 ?

> +		len += nla_total_size(sizeof(u32)); /* _PODL_PSE_ADMIN_STATE */
> +	if (st->podl_pw_status >= 0)
> +		len += nla_total_size(sizeof(u32)); /* _PODL_PSE_PW_D_STATUS */
> +
> +	return len;
> +}

> +	if (!phydev)
> +		return -EOPNOTSUPP;
> +
> +	if (!phydev->psec)
> +		ret = -EOPNOTSUPP;

Would be good to slap an extack msg on the two errors here.

> +	else
> +		ret = pse_ethtool_set_config(phydev->psec, extack, &config);

And avoid indenting the success path. So the !phydev->psec should
contain a return.

> +	return ret;
> +}
