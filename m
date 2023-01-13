Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C36668E2E
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 07:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236408AbjAMGlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 01:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbjAMGjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:39:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469727148A;
        Thu, 12 Jan 2023 22:27:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61449B820A9;
        Fri, 13 Jan 2023 06:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFB5C433D2;
        Fri, 13 Jan 2023 06:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673591226;
        bh=IeUz2fnyufh9GUmOeskPjyWSFNtAZdrby2IXLGfRrao=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hnKvK6Bw4oAvI0nEEiJGzRcLALgs35TR+7i33xDlU847N9cGnI3LTqEonQPIfAcsa
         zQroluYkUFBUGlKnbyKS4bHubMrC9CIO0Js7f9dBrqF0K9ndju09geQuDRHx/0qPqP
         SJmQoXGT4naPRO7elPHUO4Iys/R4T19bHETgpTF/ifgoWY9XYhKURpQU8VqoUqWJxo
         Q2VjXxw5RqsfULqQmFutxMbGQxi50SuhyjRcSx97FItdkPEkSG/HQjeo3pMXOO3zRy
         hIXKL5XoC4m2adSHKeLnMYl8hpPobXcp8GeLO00/hNlUGPDhdvxLLRKmeocveexW8C
         hYMtHIWEmK0QQ==
Date:   Thu, 12 Jan 2023 22:27:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH v2 net-next 02/12] net: ethtool: add support for MAC
 Merge layer
Message-ID: <20230112222704.1928f7e0@kernel.org>
In-Reply-To: <20230111161706.1465242-3-vladimir.oltean@nxp.com>
References: <20230111161706.1465242-1-vladimir.oltean@nxp.com>
        <20230111161706.1465242-3-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 18:16:56 +0200 Vladimir Oltean wrote:
> +/**
> + * enum ethtool_mm_verify_status - status of MAC Merge Verify function
> + * @ETHTOOL_MM_VERIFY_STATUS_UNKNOWN:
> + *	verification status is unknown=EF=80=A0
> + * @ETHTOOL_MM_VERIFY_STATUS_INITIAL:
> + *	the 802.3 Verify State diagram is in the state INIT_VERIFICATION
> + * @ETHTOOL_MM_VERIFY_STATUS_VERIFYING:
> + *	the Verify State diagram is in the state VERIFICATION_IDLE,=EF=80=A0

funky characters here

> + *	SEND_VERIFY or WAIT_FOR_RESPONSE
> + * @ETHTOOL_MM_VERIFY_STATUS_SUCCEEDED:
> + *	indicates that the Verify State diagram is in the state VERIFIED
> + * @ETHTOOL_MM_VERIFY_STATUS_FAILED:
> + *	the Verify State diagram is in the state VERIFY_FAIL
> + * @ETHTOOL_MM_VERIFY_STATUS_DISABLED:
> + *	verification of preemption operation is disabled
> + */

> +static int mm_prepare_data(const struct ethnl_req_info *req_base,
> +			   struct ethnl_reply_data *reply_base,
> +			   struct genl_info *info)
> +{
> +	struct mm_reply_data *data =3D MM_REPDATA(reply_base);
> +	struct net_device *dev =3D reply_base->dev;
> +	const struct ethtool_ops *ops;
> +	int ret;
> +
> +	ops =3D dev->ethtool_ops;
> +
> +	if (!ops->get_mm)
> +		return -EOPNOTSUPP;
> +
> +	ethtool_stats_init((u64 *)&data->stats,
> +			   sizeof(data->stats) / sizeof(u64));
> +
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret < 0)

nit: in set you do if (ret) after begin

> +		return ret;
> +
> +	ops->get_mm(dev, &data->state);
> +
> +	if (ops->get_mm_stats && (req_base->flags & ETHTOOL_FLAG_STATS))
> +		ops->get_mm_stats(dev, &data->stats);
> +
> +	ethnl_ops_complete(dev);
> +
> +	return 0;
> +}

> +int ethnl_set_mm(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct netlink_ext_ack *extack =3D info->extack;
> +	struct ethnl_req_info req_info =3D {};
> +	struct ethtool_mm_state state =3D {};
> +	struct nlattr **tb =3D info->attrs;
> +	struct ethtool_mm_cfg cfg =3D {};
> +	const struct ethtool_ops *ops;
> +	struct net_device *dev;
> +	bool mod =3D false;
> +	int ret;
> +
> +	ret =3D ethnl_parse_header_dev_get(&req_info, tb[ETHTOOL_A_MM_HEADER],
> +					 genl_info_net(info), extack, true);
> +	if (ret)
> +		return ret;
> +
> +	dev =3D req_info.dev;
> +	ops =3D dev->ethtool_ops;
> +
> +	if (!ops->get_mm || !ops->set_mm) {
> +		ret =3D -EOPNOTSUPP;
> +		goto out_dev;
> +	}
> +
> +	rtnl_lock();
> +	ret =3D ethnl_ops_begin(dev);
> +	if (ret)
> +		goto out_rtnl;
> +
> +	ops->get_mm(dev, &state);
> +
> +	mm_state_to_cfg(&state, &cfg);
> +
> +	if (cfg.verify_time > state.max_verify_time) {
> +		NL_SET_ERR_MSG_MOD(extack, "verifyTime exceeds device maximum");

Drop the _MOD() add _ATTR()

> +		return -ERANGE;

goto out_ops;

> +	}
> +
> +	ethnl_update_bool(&cfg.verify_enabled, tb[ETHTOOL_A_MM_VERIFY_ENABLED],
> +			  &mod);
> +	ethnl_update_u32(&cfg.verify_time, tb[ETHTOOL_A_MM_VERIFY_TIME], &mod);
> +	ethnl_update_bool(&cfg.tx_enabled, tb[ETHTOOL_A_MM_TX_ENABLED], &mod);
> +	ethnl_update_bool(&cfg.pmac_enabled, tb[ETHTOOL_A_MM_PMAC_ENABLED],
> +			  &mod);
> +	ethnl_update_u32(&cfg.add_frag_size, tb[ETHTOOL_A_MM_ADD_FRAG_SIZE],
> +			 &mod);

you never use the @mod?

> +	ret =3D ops->set_mm(dev, &cfg, extack);
> +	if (ret) {
> +		if (!extack->_msg)
> +			NL_SET_ERR_MSG(extack,
> +				       "Failed to update MAC merge configuration");

Why add this extack? It's it evident that the config wasn't updated
from the fact the netlink ACK carries a non-zero error?

> +		goto out_ops;
> +	}
> +
> +	ethtool_notify(dev, ETHTOOL_MSG_MM_NTF, NULL);
> +
> +out_ops:
> +	ethnl_ops_complete(dev);
> +out_rtnl:
> +	rtnl_unlock();
> +out_dev:
> +	dev_put(dev);

ethnl_parse_header_dev_put()

> +	return ret;
> +}

I'm out of time for the day, feel free to send v3, or I'll just pick up
here tomorrow.
