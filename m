Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76648685EA3
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 05:53:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjBAExd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 23:53:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbjBAExb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 23:53:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825BF3EC55
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 20:53:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1364460A26
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 04:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05E5C433D2;
        Wed,  1 Feb 2023 04:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675227209;
        bh=Ffp6AJW6lr6b17EQleBAP6GYYqIvf1HypElyd7eLhqk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sucRY3Ft2wzoDGuCJrpfdX4D3jNfb1JFRQ8j/e0izepqmmQrhI9C4bo4ZjguXruPf
         WwcMSWfS/Y3r4z2scGJXvcyf3Q6AevOoaB/rxKe3LVTq1A6xIxCzlHU0D93Xdjgvag
         9cmxA1xHRvD2gMNlU2XtqboxZOT1AKlQIG42QPBKTebYS3Fc0mCbYn2iVSVe8zDI1l
         c0hLb9u5cYjovB9q9PYatGIuzliyXB4I+tpEhPdCd/oE0gKgjNkJb2CFrPC58/jvjn
         sqHScOujvWrj0wD7tsdP+YlwyvmeMpL9o4TuanJkrKrYilWd4ydKoa2dBHAV9sUA4A
         1mkzAMuYjoySg==
Date:   Tue, 31 Jan 2023 20:53:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Aurelien Aptel <aaptel@nvidia.com>
Cc:     linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        sagi@grimberg.me, hch@lst.de, kbusch@kernel.org, axboe@fb.com,
        chaitanyak@nvidia.com, davem@davemloft.net,
        aurelien.aptel@gmail.com, smalin@nvidia.com, malin1024@gmail.com,
        ogerlitz@nvidia.com, yorayz@nvidia.com, borisp@nvidia.com
Subject: Re: [PATCH v10 03/25] net/ethtool: add ULP_DDP_{GET,SET} operations
 for caps and stats
Message-ID: <20230131205327.67adfc1f@kernel.org>
In-Reply-To: <20230126162136.13003-4-aaptel@nvidia.com>
References: <20230126162136.13003-1-aaptel@nvidia.com>
        <20230126162136.13003-4-aaptel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Jan 2023 18:21:14 +0200 Aurelien Aptel wrote:
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 14a1858fd106..35805d8d12a3 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -57,6 +57,8 @@ enum {
>  	ETHTOOL_MSG_PLCA_GET_STATUS,
>  	ETHTOOL_MSG_MM_GET,
>  	ETHTOOL_MSG_MM_SET,
> +	ETHTOOL_MSG_ULP_DDP_GET,
> +	ETHTOOL_MSG_ULP_DDP_SET,

Please add the definition of the command to
Documentation/netlink/specs/ethtool.yaml

>  	/* add new constants above here */
>  	__ETHTOOL_MSG_USER_CNT,
> @@ -109,6 +111,8 @@ enum {
>  	ETHTOOL_MSG_PLCA_NTF,
>  	ETHTOOL_MSG_MM_GET_REPLY,
>  	ETHTOOL_MSG_MM_NTF,
> +	ETHTOOL_MSG_ULP_DDP_GET_REPLY,
> +	ETHTOOL_MSG_ULP_DDP_SET_REPLY,

What about notifications?

> +#include "netlink.h"
> +#include "common.h"
> +#include "bitset.h"

alphabetic order?

> +static int ulp_ddp_stats64_size(unsigned int count)
> +{
> +	unsigned int len = 0;
> +	unsigned int i;
> +
> +	for (i = 0; i < count; i++)
> +		len += nla_total_size(sizeof(u64));

len = nla_total_size(sizeof(u64)) * count
?
but it's not correct. You need nla_total_size_64bit() here

> +	/* outermost nest */
> +	return nla_total_size(len);

nla_total_size(0) is more common for nests.

> +}
> +
> +static int ulp_ddp_put_stats64(struct sk_buff *skb, int attrtype, const u64 *val,
> +			       unsigned int count)
> +{
> +	struct nlattr *nest;
> +	unsigned int i;
> +
> +	nest = nla_nest_start(skb, attrtype);
> +	if (!nest)
> +		return -EMSGSIZE;
> +
> +	/* skip attribute 0 (unspec) */
> +	for (i = 0 ; i < count; i++)
> +		if (nla_put_64bit(skb, i+1, sizeof(u64), &val[i], 0))

nla_put_u64_64bit()
And you'll need to add an attr for padding.

> +			goto nla_put_failure;
> +
> +	nla_nest_end(skb, nest);
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, nest);
> +	return -EMSGSIZE;
> +}

> +const struct nla_policy ethnl_ulp_ddp_set_policy[] = {
> +	[ETHTOOL_A_ULP_DDP_HEADER]	=
> +		NLA_POLICY_NESTED(ethnl_header_policy),
> +	[ETHTOOL_A_ULP_DDP_WANTED]	= { .type = NLA_NESTED },
> +};

Let's link the policy here: NLA_POLICY_NESTED(bitset_policy).

> +static int ulp_ddp_send_reply(struct net_device *dev, struct genl_info *info,
> +			      const unsigned long *wanted,
> +			      const unsigned long *wanted_mask,
> +			      const unsigned long *active,
> +			      const unsigned long *active_mask, bool compact)
> +{
> +	struct sk_buff *rskb;
> +	void *reply_payload;
> +	int reply_len = 0;
> +	int ret;
> +
> +	reply_len = ethnl_reply_header_size();
> +	ret = ethnl_bitset_size(wanted, wanted_mask, ULP_DDP_C_COUNT,
> +				ulp_ddp_caps_names, compact);
> +	if (ret < 0)
> +		goto err;
> +	reply_len += ret;
> +	ret = ethnl_bitset_size(active, active_mask, ULP_DDP_C_COUNT,
> +				ulp_ddp_caps_names, compact);
> +	if (ret < 0)
> +		goto err;
> +	reply_len += ret;
> +
> +	ret = -ENOMEM;
> +	rskb = ethnl_reply_init(reply_len, dev, ETHTOOL_MSG_ULP_DDP_SET_REPLY,
> +				ETHTOOL_A_ULP_DDP_HEADER, info,
> +				&reply_payload);
> +	if (!rskb)
> +		goto err;
> +
> +	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_WANTED, wanted,
> +			       wanted_mask, ULP_DDP_C_COUNT,
> +			       ulp_ddp_caps_names, compact);
> +	if (ret < 0)
> +		goto nla_put_failure;
> +	ret = ethnl_put_bitset(rskb, ETHTOOL_A_ULP_DDP_ACTIVE, active,
> +			       active_mask, ULP_DDP_C_COUNT,
> +			       ulp_ddp_caps_names, compact);
> +	if (ret < 0)
> +		goto nla_put_failure;
> +
> +	genlmsg_end(rskb, reply_payload);
> +	ret = genlmsg_reply(rskb, info);
> +	return ret;
> +
> +nla_put_failure:
> +	nlmsg_free(rskb);
> +	WARN_ONCE(1, "calculated message payload length (%d) not sufficient\n",
> +		  reply_len);
> +err:
> +	GENL_SET_ERR_MSG(info, "failed to send reply message");

Don't overwrite the message, the message should be set close to 
the error, if needed.

> +	return ret;
> +}
> +
> +int ethnl_set_ulp_ddp(struct sk_buff *skb, struct genl_info *info)
> +{
> +	DECLARE_BITMAP(old_active, ULP_DDP_C_COUNT);
> +	DECLARE_BITMAP(new_active, ULP_DDP_C_COUNT);
> +	DECLARE_BITMAP(req_wanted, ULP_DDP_C_COUNT);
> +	DECLARE_BITMAP(req_mask, ULP_DDP_C_COUNT);
> +	DECLARE_BITMAP(all_bits, ULP_DDP_C_COUNT);
> +	DECLARE_BITMAP(tmp, ULP_DDP_C_COUNT);
> +	struct ethnl_req_info req_info = {};
> +	const struct ulp_ddp_dev_ops *ops;
> +	struct nlattr **tb = info->attrs;
> +	struct ulp_ddp_netdev_caps *caps;
> +	struct net_device *dev;
> +	int ret;
> +
> +	if (!tb[ETHTOOL_A_ULP_DDP_WANTED])

GENL_REQ_ATTR_CHECK()

> +		return -EINVAL;
> +	ret = ethnl_parse_header_dev_get(&req_info,
> +					 tb[ETHTOOL_A_ULP_DDP_HEADER],
> +					 genl_info_net(info), info->extack,
> +					 true);
> +	if (ret < 0)
> +		return ret;
> +
> +	dev = req_info.dev;
> +	rtnl_lock();
> +	caps = netdev_ulp_ddp_caps(dev);
> +	ops = netdev_ulp_ddp_ops(dev);
> +	if (!caps || !ops || !ops->set_caps) {
> +		ret = -EOPNOTSUPP;
> +		goto out_rtnl;
> +	}
> +
> +	ret = ethnl_parse_bitset(req_wanted, req_mask, ULP_DDP_C_COUNT,
> +				 tb[ETHTOOL_A_ULP_DDP_WANTED],
> +				 ulp_ddp_caps_names, info->extack);
> +	if (ret < 0)
> +		goto out_rtnl;
> +
> +	/* if (req_mask & ~all_bits) */
> +	bitmap_fill(all_bits, ULP_DDP_C_COUNT);
> +	bitmap_andnot(tmp, req_mask, all_bits, ULP_DDP_C_COUNT);
> +	if (!bitmap_empty(tmp, ULP_DDP_C_COUNT)) {
> +		ret = -EINVAL;
> +		goto out_rtnl;
> +	}
> +
> +	/* new_active = (old_active & ~req_mask) | (wanted & req_mask)
> +	 * new_active &= caps_hw
> +	 */
> +	bitmap_copy(old_active, caps->active, ULP_DDP_C_COUNT);
> +	bitmap_and(req_wanted, req_wanted, req_mask, ULP_DDP_C_COUNT);
> +	bitmap_andnot(new_active, old_active, req_mask, ULP_DDP_C_COUNT);
> +	bitmap_or(new_active, new_active, req_wanted, ULP_DDP_C_COUNT);
> +	bitmap_and(new_active, new_active, caps->hw, ULP_DDP_C_COUNT);
> +	if (!bitmap_equal(old_active, new_active, ULP_DDP_C_COUNT)) {
> +		ret = ops->set_caps(dev, new_active);

We should pass extack to the driver, so that the driver can report a
meaningful error

> +		if (ret)
> +			netdev_err(dev, "set_ulp_ddp_capabilities() returned error %d\n", ret);

and drop this

> +		bitmap_copy(new_active, caps->active, ULP_DDP_C_COUNT);
> +	}
> +
> +	ret = 0;
> +	if (!(req_info.flags & ETHTOOL_FLAG_OMIT_REPLY)) {
> +		DECLARE_BITMAP(wanted_diff_mask, ULP_DDP_C_COUNT);
> +		DECLARE_BITMAP(active_diff_mask, ULP_DDP_C_COUNT);
> +		bool compact = req_info.flags & ETHTOOL_FLAG_COMPACT_BITSETS;
> +
> +		/* wanted_diff_mask = req_wanted ^ new_active
> +		 * active_diff_mask = old_active ^ new_active -> mask of bits that have changed
> +		 * wanted_diff_mask &= req_mask    -> mask of bits that have diff value than wanted
> +		 * req_wanted &= wanted_diff_mask  -> bits that have diff value than wanted
> +		 * new_active &= active_diff_mask  -> bits that have changed
> +		 */
> +		bitmap_xor(wanted_diff_mask, req_wanted, new_active, ULP_DDP_C_COUNT);
> +		bitmap_xor(active_diff_mask, old_active, new_active, ULP_DDP_C_COUNT);
> +		bitmap_and(wanted_diff_mask, wanted_diff_mask, req_mask, ULP_DDP_C_COUNT);
> +		bitmap_and(req_wanted, req_wanted, wanted_diff_mask,  ULP_DDP_C_COUNT);
> +		bitmap_and(new_active, new_active, active_diff_mask,  ULP_DDP_C_COUNT);
> +		ret = ulp_ddp_send_reply(dev, info,
> +					 req_wanted, wanted_diff_mask,
> +					 new_active, active_diff_mask,
> +					 compact);
> +	}
> +
> +out_rtnl:
> +	rtnl_unlock();
> +	ethnl_parse_header_dev_put(&req_info);
> +	return ret;
> +}

