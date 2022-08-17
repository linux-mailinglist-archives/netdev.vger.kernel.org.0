Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB2C5967B9
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 05:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbiHQDWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 23:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbiHQDWO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 23:22:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520EC6CF59
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 20:22:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3758B815DF
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 03:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41340C433D6;
        Wed, 17 Aug 2022 03:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660706530;
        bh=vlAzK2QnwY2QT3K01cM3qSMA+j2jRcxWXvqpNbUz6L8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oNMsnX/wy+XLMskCGst10/LMNDJHR5PJlnvZdPKF23JR6zTpVoqRet/rSAn/5e2+e
         jbsmzwOIrfq1UbsiKEIL+lHM2YW6nTXoC4paZ9eiJ15X4BtT3Qv0EWbS3VUKSxCwPk
         zhHKwb4aYJGnQ+lhX0XkZDCxHhOQok3wpEo42b2bKNEAPgDu0/iissiC5e4oaT+g7n
         AFqtuuwMS3POzU3tMZTDp/prpO48Vk6jogUcjWz6r3efe4XPzCpCWq6LEjB9z8Bpy5
         TIb6pw37LNNfFBXCxUiOoB/9z5XMsGFneHm1Y86XzUkAb0nWQP1SdLZxC1TDKcYlpG
         YQ1VoNA8c6Gxg==
Date:   Tue, 16 Aug 2022 20:22:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Rui Sousa <rui.sousa@nxp.com>,
        Ferenc Fejes <ferenc.fejes@ericsson.com>
Subject: Re: [RFC PATCH net-next 2/7] net: ethtool: add support for Frame
 Preemption and MAC Merge layer
Message-ID: <20220816202209.1d9ae749@kernel.org>
In-Reply-To: <20220816222920.1952936-3-vladimir.oltean@nxp.com>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
        <20220816222920.1952936-3-vladimir.oltean@nxp.com>
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

On Wed, 17 Aug 2022 01:29:15 +0300 Vladimir Oltean wrote:
> +/**
> + * struct ethtool_mm_state - 802.3 MAC merge layer state
> + */
> +struct ethtool_mm_state {
> +	u32 verify_time;
> +	enum ethtool_mm_verify_status verify_status;
> +	bool supported;
> +	bool enabled;
> +	bool active;

The enabled vs active piqued my interest. Is there some handshake /
aneg or such?

> +	nest_table = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_TABLE);
> +	if (!nest_table)
> +		return -EMSGSIZE;

Don't warp tables in nests, let the elements repeat in the parent.
