Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8574C6D8C96
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234461AbjDFBNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjDFBNi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:13:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBA598699;
        Wed,  5 Apr 2023 18:13:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA1A162B08;
        Thu,  6 Apr 2023 01:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FE9C433D2;
        Thu,  6 Apr 2023 01:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680743556;
        bh=dP8/jMHNzL9KeQJlhwq07VX3j1IKkLRUF9JRQAZlzw8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AihnE643wEKX8L/vYQsqAiX/gazUXOQ9EGr5jKrE9AVzL9OhaB0PDqiTlt0clJwPi
         1T+spMWJPK6MlsIOa/ZmMHxwyge6QKva2ob0Sdo20aac2NZder2kqlVc0HzOHY/C0M
         ZtLS3ijpQ62YS7CYkdFPMP/W6jb8zzEW5Do+JkpurmRHc3G7kyLLlfqRh1q1VUQYze
         WG54zuaGOOWbD/Y4szLrAHAmYFEffg/C5IWMg+GFrgjkUTrX++w1N8YgHn6qHKY954
         66fkn4rIWW+sW8PrgeGaXnd4ifaGbVQUVkciENwf0tnZGLWoUXawe0OldYM23gNXfa
         xvDEA0XmkFT6Q==
Date:   Wed, 5 Apr 2023 18:12:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Gerhard Engleder <gerhard@engleder-embedded.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roger Quadros <rogerq@kernel.org>,
        Pranavi Somisetty <pranavi.somisetty@amd.com>,
        Harini Katakam <harini.katakam@amd.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        linux-kernel@vger.kernel.org, Ferenc Fejes <fejes@inf.elte.hu>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v4 net-next 6/9] net/sched: mqprio: allow per-TC user
 input of FP adminStatus
Message-ID: <20230405181234.35dbd2f9@kernel.org>
In-Reply-To: <20230403103440.2895683-7-vladimir.oltean@nxp.com>
References: <20230403103440.2895683-1-vladimir.oltean@nxp.com>
        <20230403103440.2895683-7-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Apr 2023 13:34:37 +0300 Vladimir Oltean wrote:
> +static int mqprio_parse_tc_entry(u32 fp[TC_QOPT_MAX_QUEUE],
> +				 struct nlattr *opt,
> +				 unsigned long *seen_tcs,
> +				 struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[TCA_MQPRIO_TC_ENTRY_MAX + 1] = { };

nit: no need to clear it nla_parse*() zeros the memory

> +	int err, tc;
> +
> +	err = nla_parse_nested(tb, TCA_MQPRIO_TC_ENTRY_MAX, opt,
> +			       mqprio_tc_entry_policy, extack);
> +	if (err < 0)
> +		return err;
> +
> +	if (!tb[TCA_MQPRIO_TC_ENTRY_INDEX]) {
> +		NL_SET_ERR_MSG(extack, "TC entry index missing");

Are you not using NL_REQ_ATTR_CHECK() because iproute can't actually
parse the result? :(

> +		return -EINVAL;
> +	}
> +
> +	tc = nla_get_u32(tb[TCA_MQPRIO_TC_ENTRY_INDEX]);
> +	if (*seen_tcs & BIT(tc)) {
> +		NL_SET_ERR_MSG(extack, "Duplicate tc entry");

set attr in extack?


minor heads up - I'll take the trivial cleanup patch from Pedro
so make sure you rebase:
https://lore.kernel.org/all/20230404203449.1627033-1-pctammela@mojatatu.com/
