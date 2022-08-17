Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151555975CD
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240940AbiHQSfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238536AbiHQSfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:35:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456BE9C1D0
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 11:35:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0B5761403
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 18:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA19AC433C1;
        Wed, 17 Aug 2022 18:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660761320;
        bh=xjsFQbQAtClGrGPaBlT9s7gPtJcBGvmCCtFcz9EZAtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kFcDssznhMZ6qVrDNCddClh5ZhQBvG81hVKOzK5TYcRWrT/IAq5KflsI+0VgnH6/f
         aZHaxx/33TYX+J/ydHi636JrP+qc3nAoGlUOoill2Wf4fg1W56VvHxl+nsvsiXcB76
         qmWYS4ZiU8ZX6yoBAI5ks2KzHthytYDyR+K2p0b5t3ygL7Etek4CBCSsKRZc6v61M+
         SS+LQak+bSBMGxrSmdZkYu3TEQmpGCB2UjioE40UlAae574QyiPNCGT69e9uGGi/It
         khN6Pgv7115di5WqCce0kA8NYOUrSdax5nKdSMNdg4A6ALrJz9HAIA0YC96ifv6SPu
         uYIFrOMfgFMnQ==
Date:   Wed, 17 Aug 2022 11:35:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20220817113518.0ea567d6@kernel.org>
In-Reply-To: <20220817114100.7pu6y4lpnedyc3fg@skbuf>
References: <20220816222920.1952936-1-vladimir.oltean@nxp.com>
        <20220816222920.1952936-3-vladimir.oltean@nxp.com>
        <20220816202209.1d9ae749@kernel.org>
        <20220817114100.7pu6y4lpnedyc3fg@skbuf>
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

On Wed, 17 Aug 2022 11:41:01 +0000 Vladimir Oltean wrote:
> > > +	nest_table = nla_nest_start(skb, ETHTOOL_A_FP_PARAM_TABLE);
> > > +	if (!nest_table)
> > > +		return -EMSGSIZE;  
> > 
> > Don't warp tables in nests, let the elements repeat in the parent.  
> 
> Ok, can do. I did this because 802.1Q actually specifies in the
> IEEE8021-Preemption-MIB that there is a ieee8021PreemptionParameterTable
> structure containing pairs of ieee8021PreemptionPriority and
> ieee8021FramePreemptionAdminStatus.

Yeah, netlink is a bit special in array definition. I need to document
it well in my YAML netlink patches..

> Do you have actual issues with the structuring of the FP parameters
> though? They look like this currently

IDK how to put it best, I shared my largely uninformed thoughts, you
know much more about the spec and HW so whatever you think is most
appropriate is fine by me.
