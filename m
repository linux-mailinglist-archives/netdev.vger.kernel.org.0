Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8131455F57D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 07:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiF2FGA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 01:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiF2FF7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 01:05:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC6D1DA65;
        Tue, 28 Jun 2022 22:05:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03BA0B82144;
        Wed, 29 Jun 2022 05:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DBEC34114;
        Wed, 29 Jun 2022 05:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656479155;
        bh=gtq/QfNPNwxuwm2P1Xpe9SolRIcPH56rgiW9ZRhAWjg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PeiwY1QO6r5DGatEmk1Pr01uQXpcIeLcVJhZGIP3X/7paiuMApXOtfiHaQ4X/vucA
         ZjRcGSPKPabTB2BASxqGeYcVuE+4n2LpWoEk2jay0UzQtyAieNhOyioP4D0QFTH6cM
         Js+thOADImjPSZbU1EUCziley1FJmMvYI+PDxuL63wVEqIt34Q8rJJAEzZb6FWbBh2
         jNEBACWW0wwQPeoEO4XONsSBWeoFX9e3gka8g974ABRg0TuNXDa2HQpJwDv1rdkuqR
         Yw+TYlIbs5Ja1afxvaikTeVyZ7UXpVUqH6EhAstVxIGQJ2voqbxwADlnHYysB6X7Sr
         53AFOL8XTPFnA==
Date:   Tue, 28 Jun 2022 22:05:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, michael.chan@broadcom.com,
        andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v1 1/3] devlink: introduce framework for
 selftests
Message-ID: <20220628220554.20833bd4@kernel.org>
In-Reply-To: <20220628164241.44360-2-vikas.gupta@broadcom.com>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
        <20220628164241.44360-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 22:12:39 +0530 Vikas Gupta wrote:
> Add a framework for running selftests.
> Framework exposes devlink commands and test suite(s) to the user
> to execute and query the supported tests by the driver.
> 
> To execute tests, users can provide a test mask for executing
> group tests or standalone tests. API devlink_selftest_result_put() helps
> drivers to populate the test results along with their names.
> 
> To query supported tests by device, API devlink_selftest_name_put()
> helps a driver to populate test names.
> 
> Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>
> Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
> ---
>  .../networking/devlink/devlink-selftests.rst  |  39 +++++
>  include/net/devlink.h                         |  40 +++++
>  include/uapi/linux/devlink.h                  |  24 +++
>  net/core/devlink.c                            | 147 ++++++++++++++++++
>  4 files changed, 250 insertions(+)
>  create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
> 
> diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
> new file mode 100644
> index 000000000000..df7c8fcac9bf
> --- /dev/null
> +++ b/Documentation/networking/devlink/devlink-selftests.rst
> @@ -0,0 +1,39 @@
> +.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +
> +.. _devlink_selftests:

Why the label?

> +=================
> +Devlink Selftests
> +=================
> +
> +The ``devlink-selftests`` API allows executing selftests on the device.
> +
> +Tests Mask
> +==========
> +The ``devlink-selftests`` command should be run with a mask indicating
> +the tests to be executed.
> +
> +Tests Description
> +=================
> +The following is a list of tests that drivers may execute.
> +
> +.. list-table:: List of tests
> +   :widths: 5 90
> +
> +   * - Name
> +     - Description
> +   * - ``DEVLINK_SELFTEST_FLASH``
> +     - Runs a flash test on the device which helps to log the health of the flash.
> +       see Documentation/networking/devlink/devlink-health.rst

Quick grep of "flash" in devlink-health.rst shows nothing.
New sentence should be capitalized.

> +example usage
> +-------------
> +
> +.. code:: shell
> +
> +    # Query selftests supported on the device
> +    $ devlink dev selftests show DEV
> +    # Executes selftests on the device
> +    $ devlink dev selftests run DEV test {flash | all}
> +
> +

Spurious nl.

> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 2a2a2a0c93f7..493dab368340 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -1215,6 +1215,19 @@ enum {
>  	DEVLINK_F_RELOAD = 1UL << 0,
>  };
>  
> +/**
> + * struct devlink_selftest_exec_info - Devlink selftest execution info.
> + * @name: Test name.
> + * @result: Test result.

Don't create kdoc if you have nothing to say in it.

> + */
> +struct devlink_selftest_exec_info {
> +	const char *name;
> +	bool result;

"result" doesn't indicate the polarity, better call it passed or failed.
int may be better to indicate pass/fail/skip?

> +};
> +
> +#define DEVLINK_SELFTEST_FLASH_TEST_NAME \
> +	"flash test"

no need to break this line

>  struct devlink_ops {
>  	/**
>  	 * @supported_flash_update_params:
> @@ -1509,6 +1522,28 @@ struct devlink_ops {
>  				    struct devlink_rate *parent,
>  				    void *priv_child, void *priv_parent,
>  				    struct netlink_ext_ack *extack);
> +	/**
> +	 * selftests_show() - Shows selftests supported by device
> +	 * @devlink: Devlink instance
> +	 * @skb: message payload
> +	 * @extack: extack for reporting error messages
> +	 *
> +	 * Return: 0 on success, negative value otherwise.
> +	 */
> +

spurious nl

> +	int (*selftests_show)(struct devlink *devlink, struct sk_buff *skb,
> +			      struct netlink_ext_ack *extack);

Why do we need to pass skb into this? The bits seem predefined so why
not return the mask and let the core do the formatting? 

> +	/**
> +	 * selftests_run() - Runs selftests
> +	 * @devlink: Devlink instance
> +	 * @skb: message payload
> +	 * @tests_mask: tests to be run
> +	 * @extack: extack for reporting error messages
> +	 *
> +	 * Return: 0 on success, negative value otherwise.
> +	 */
> +	int (*selftests_run)(struct devlink *devlink, struct sk_buff *skb,
> +			     u32 tests_mask, struct netlink_ext_ack *extack);

Similarly it may be more convenient for the drivers to pass in an array
in which to record results rather than having to deal with outputting
to an ask.

>  };
>  
>  void *devlink_priv(struct devlink *devlink);
> @@ -1774,6 +1809,11 @@ void
>  devlink_trap_policers_unregister(struct devlink *devlink,
>  				 const struct devlink_trap_policer *policers,
>  				 size_t policers_count);
> +int
> +devlink_selftest_result_put(struct sk_buff *skb,
> +			    struct devlink_selftest_exec_info *test);
> +int
> +devlink_selftest_name_put(struct sk_buff *skb, const char *name);
>  
>  #if IS_ENABLED(CONFIG_NET_DEVLINK)
>  
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index b3d40a5d72ff..58e2ef4010f0 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -136,6 +136,9 @@ enum devlink_command {
>  	DEVLINK_CMD_LINECARD_NEW,
>  	DEVLINK_CMD_LINECARD_DEL,
>  
> +	DEVLINK_CMD_SELFTESTS_SHOW,
> +	DEVLINK_CMD_SELFTESTS_RUN,
> +
>  	/* add new commands above here */
>  	__DEVLINK_CMD_MAX,
>  	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
> @@ -276,6 +279,21 @@ enum {
>  #define DEVLINK_SUPPORTED_FLASH_OVERWRITE_SECTIONS \
>  	(_BITUL(__DEVLINK_FLASH_OVERWRITE_MAX_BIT) - 1)
>  
> +/* Commonly used test cases. Drivers might interpret test bit
> + * in their own way and it may map single to multiple tests.
> + */
> +enum {
> +	DEVLINK_SELFTEST_FLASH_BIT,
> +
> +	__DEVLINK_SELFTEST_MAX_BIT,
> +	DEVLINK_SELFTEST_MAX_BIT = __DEVLINK_SELFTEST_MAX_BIT - 1
> +};
> +
> +#define DEVLINK_SELFTEST_FLASH _BITUL(DEVLINK_SELFTEST_FLASH_BIT)
> +
> +#define DEVLINK_SUPPORTED_SELFTESTS \
> +	(_BITUL(__DEVLINK_SELFTEST_MAX_BIT) - 1)
> +
>  /**
>   * enum devlink_trap_action - Packet trap action.
>   * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy is not
> @@ -576,6 +594,12 @@ enum devlink_attr {
>  	DEVLINK_ATTR_LINECARD_TYPE,		/* string */
>  	DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,	/* nested */
>  
> +	DEVLINK_ATTR_SELFTESTS_MASK,		/* bitfield32 */
> +	DEVLINK_ATTR_TEST_NAMES,		/* nested */
> +	DEVLINK_ATTR_TEST_NAME,			/* string */
> +	DEVLINK_ATTR_TEST_RESULTS,		/* nested */
> +	DEVLINK_ATTR_TEST_RESULT,		/* nested */

So many nests, netlink is much lighter on nesting that say JSON.
All you need is one nest type to wrap name and result, and just
output that multiple times to the message.

> +	DEVLINK_ATTR_TEST_RESULT_VAL,		/* u8 */
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index db61f3a341cb..3c4c27a7dd40 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4794,6 +4794,139 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
>  	return ret;
>  }
>  
> +int devlink_selftest_name_put(struct sk_buff *skb, const char *name)
> +{
> +	if (nla_put_string(skb, DEVLINK_ATTR_TEST_NAME, name))
> +		return -EMSGSIZE;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(devlink_selftest_name_put);
> +
> +static int devlink_nl_cmd_selftests_show(struct sk_buff *skb,
> +					 struct genl_info *info)
> +{
> +	struct devlink *devlink = info->user_ptr[0];
> +	struct nlattr  *names_attr;
> +	struct sk_buff *msg;
> +	void *hdr;
> +	int err;
> +
> +	if (!devlink->ops->selftests_show)
> +		return -EOPNOTSUPP;
> +
> +	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!msg)
> +		return -ENOMEM;
> +
> +	hdr = genlmsg_put(msg, info->snd_portid, info->snd_seq,
> +			  &devlink_nl_family, 0, DEVLINK_CMD_SELFTESTS_SHOW);
> +	if (!hdr)

Leak.

> +		return -EMSGSIZE;
> +
> +	if (devlink_nl_put_handle(msg, devlink))
> +		goto genlmsg_cancel;

err not initialized

> +	names_attr = nla_nest_start_noflag(msg, DEVLINK_ATTR_TEST_NAMES);
> +	if (!names_attr)
> +		goto genlmsg_cancel;
> +
> +	err =  devlink->ops->selftests_show(devlink, msg, info->extack);

double space

> +	if (err)
> +		goto names_nest_cancel;
> +
> +	nla_nest_end(msg, names_attr);
> +	genlmsg_end(msg, hdr);
> +
> +	return genlmsg_reply(msg, info);
> +
> +names_nest_cancel:
> +	nla_nest_cancel(msg, names_attr);
> +genlmsg_cancel:
> +	genlmsg_cancel(msg, hdr);
> +	nlmsg_free(msg);
> +	return err;
> +}

>  static const struct devlink_param devlink_param_generic[] = {
>  	{
>  		.id = DEVLINK_PARAM_GENERIC_ID_INT_ERR_RESET,
> @@ -9000,6 +9133,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>  	[DEVLINK_ATTR_RATE_PARENT_NODE_NAME] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_LINECARD_INDEX] = { .type = NLA_U32 },
>  	[DEVLINK_ATTR_LINECARD_TYPE] = { .type = NLA_NUL_STRING },
> +	[DEVLINK_ATTR_SELFTESTS_MASK] =
> +		NLA_POLICY_BITFIELD32(DEVLINK_SUPPORTED_SELFTESTS),

You don't need a bitfield, use a u32 (u64?) with a mask policy.

