Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2698656B02E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236626AbiGHBUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiGHBUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:20:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D7032EC0;
        Thu,  7 Jul 2022 18:20:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C35660C8B;
        Fri,  8 Jul 2022 01:20:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3826EC3411E;
        Fri,  8 Jul 2022 01:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657243232;
        bh=Z+nodcNxeRhmNRr1WmVvY1m5rqwzpfkY59IPVQ6ZkPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Nz7nlwmDOEdWvMbc6AcXV24Fa4/JJgR82GY+COpiX9OFSH0pBvPIPk7K40yRA2FCF
         eYd5j6XHZsn/1sQ5LyUFp9W3gH1ywcChk+YUraPjaW2DcTV3BAijWciGnWkJUE7/Fd
         fIu2/uXGdRqk8I6SxT8Tv7seyRbOnyWRQ7JMD2lcHThqVZdSrfNisep0A+wgDHCf0I
         TCEAsGMLOxRoIjIrlA15se6I9bynPQi62FoeB1AxFoW0LWaoico/77Wwyn1Tl+oKwG
         iDOfYVb2YXVuURaL96b2whJccVc99FTfkYq7B/Nypt9ONd2JrDe3CvuVcnj3iU/8Nz
         lwbLwQdQpKV+w==
Date:   Thu, 7 Jul 2022 18:20:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <20220707182022.78d750a7@kernel.org>
In-Reply-To: <20220707182950.29348-2-vikas.gupta@broadcom.com>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
        <20220707182950.29348-1-vikas.gupta@broadcom.com>
        <20220707182950.29348-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  7 Jul 2022 23:59:48 +0530 Vikas Gupta wrote:
> +   * - Name
> +     - Description
> +   * - ``DEVLINK_SELFTEST_FLASH``
> +     - Runs a flash test on the device.

A little more info on what "flash test" does would be useful.

> +	DEVLINK_CMD_SELFTESTS_SHOW,

nit: _LIST?

>  /**
>   * enum devlink_trap_action - Packet trap action.
>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
> @@ -576,6 +598,10 @@ enum devlink_attr {
>  	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>  	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>  
> +	DEVLINK_ATTR_SELFTESTS_MASK,		/* u32 */

Can we make the uAPI field 64b just in case we need more bits?
Internally we can keep using u32 doesn't matter.

> +	DEVLINK_ATTR_TEST_RESULT,		/* nested */
> +	DEVLINK_ATTR_TEST_NAME,			/* string */
> +	DEVLINK_ATTR_TEST_RESULT_VAL,		/* u8 */
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index db61f3a341cb..0b7341ab6379 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4794,6 +4794,136 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  	return ret;
>  }
>  
> +static int devlink_selftest_name_put(struct sk_buff *skb, int test)
> +{
> +	const char *name = devlink_selftest_name(test);

empty line

> +	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}

This wrapper feels slightly unnecessary, it's only used once AFAICT.

Of you want to keep it you should compress it to one stmt:

static int devlink_selftest_name_put(struct sk_buff *skb, int test)
{
	return nla_put_string(skb, DEVLINK_ATTR_TEST_NAME,
			      devlink_selftest_name(test)));
}

> +static int devlink_selftest_result_put(struct sk_buff *skb, int test,
> +				       u8 result)
> +{
> +	const char *name = devlink_selftest_name(test);
> +	struct nlattr *result_attr;
> +
> +	result_attr = nla_nest_start_noflag(skb, DEVLINK_ATTR_TEST_RESULT);

I think we can use the normal (non-_noflag) nests in new devlink code.

> +	if (!result_attr)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name) ||
> +	    nla_put_u8(skb, DEVLINK_ATTR_TEST_RESULT_VAL, result))
> +		goto nla_put_failure;
> +
> +	nla_nest_end(skb, result_attr);
> +
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(skb, result_attr);
> +	return -EMSGSIZE;
> +}
> +
> +static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
> +					struct genl_info *info)
> +{
> +	u8 test_results[DEVLINK_SELFTEST_MAX_BIT + 1] = {};
> +	struct devlink *devlink = info->user_ptr[0];
> +	unsigned long tests;
> +	struct sk_buff *msg;
> +	u32 tests_mask;
> +	void *hdr;
> +	int err = 0;

reverse xmas tree, but you probably don't want this init

> +	int test;
> +
> +	if (!devlink->ops->selftests_run)
> +		return -EOPNOTSUPP;
> +
> +	if (!info->attrs[DEVLINK_ATTR_SELFTESTS_MASK])
> +		return -EINVAL;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> +			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_RUN);
> +	if (!hdr)
> +		goto free_msg;

err is not set here

> +	if (devlink_nl_put_handle(msg, devlink))
> +		goto genlmsg_cancel;

or here

> +	tests_mask = nla_get_u32(info->attrs[DEVLINK_ATTR_SELFTESTS_MASK]);
> +
> +	devlink->ops->selftests_run(devlink, tests_mask, test_results,
> +				    info->extack);
> +	tests = tests_mask;
> +
> +	for_each_set_bit(test, &tests, __DEVLINK_SELFTEST_MAX_BIT) {
> +		err = devlink_selftest_result_put(msg, test,
> +						  test_results[test]);
> +		if (err)
> +			goto genlmsg_cancel;
> +	}
> +
> +	genlmsg_end(msg, hdr);
> +
> +	return genlmsg_reply(msg, info);
> +
> +genlmsg_cancel:
> +	genlmsg_cancel(msg, hdr);
> +free_msg:
> +	nlmsg_free(msg);
> +	return err;
> +}
> +
>  static const struct devlink_param devlink_param_generic[] = {
>  	{
>  		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
> @@ -9000,6 +9130,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>  	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
>  	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
> +	[DEVLINK_ATTR_SELFTESTS_MASK] = NLA_POLICY_MASK(NLA_U32,
> +							DEVLINK_SELFTESTS_MASK),
>  };
>  
>  static const struct genl_small_ops devlink_nl_ops[] = {
> @@ -9361,6 +9493,18 @@ static const struct genl_small_ops devlink_nl_ops[] = {
>  		.doit = devlink_nl_cmd_trap_policer_set_doit,
>  		.flags = GENL_ADMIN_PERM,
>  	},
> +	{
> +		.cmd = DEVLINK_CMD_SELFTESTS_SHOW,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,

I think we can validate strict for new commands, so no validation flags
needed.

> +		.doit = devlink_nl_cmd_selftests_show,

What about dump? Listing all tests on all devices?

> +		.flags = GENL_ADMIN_PERM,
> +	},
> +	{
> +		.cmd = DEVLINK_CMD_SELFTESTS_RUN,
> +		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
> +		.doit = devlink_nl_cmd_selftests_run,
> +		.flags = GENL_ADMIN_PERM,
> +	},
>  };
>  
>  static struct genl_family devlink_nl_family __ro_after_init = {

