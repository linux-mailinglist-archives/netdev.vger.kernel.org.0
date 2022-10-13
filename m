Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C152E5FDD31
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 17:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiJMP3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 11:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbiJMP3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 11:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4692A244
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 08:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25F0A61802
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 15:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DD6C433D7;
        Thu, 13 Oct 2022 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665674954;
        bh=eTlKZa1oMpGEVw8lWFawfpKxAo/Iql9AGB0ofySWt4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOwJZk++2zuvAO74jFzaBuWhpOf5avowOrTZ+l9Mtqe6DYW1gxsffYW2zq+e/GuMG
         uTvba7zvJPPAY8531afG6/nQVakClhHbP5aqjqztSZ4skV4Ydv8JOFqJUV45UcJDB4
         KqR3SmRHiM8O6eTm41Z2n6q06s2p4KNk4QOgVdoGFe6y1emPqDJ52O8oLMWJ2SvhUs
         A2kBewLPI02eQ7e+fmYIWbVFwngQ2ZIFoh6f04dpNtC9yL75VsOdNBNLC5DowqUQUB
         C/28dNuFY+capG83uqvzp0+Gt0V5v0L+z3cRQPIipHF+7DkGZGYOGg04eY+/4YloTU
         CpgdCB/xaxjKg==
Date:   Thu, 13 Oct 2022 08:29:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <habetsm.xilinx@gmail.com>, <johannes@sipsolutions.net>,
        <marcelo.leitner@gmail.com>, Edward Cree <ecree.xilinx@gmail.com>
Subject: Re: [RFC PATCH v2 net-next 1/3] netlink: add support for formatted
 extack messages
Message-ID: <20221013082913.0719721e@kernel.org>
In-Reply-To: <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
References: <cover.1665567166.git.ecree.xilinx@gmail.com>
        <26c2cf2e699de83905e2c21491b71af0e34d00d8.1665567166.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Oct 2022 10:23:00 +0100 edward.cree@amd.com wrote:
> +	if (snprintf(__extack->_msg_buf, NETLINK_MAX_FMTMSG_LEN,	\
> +		     (fmt), ##args) >= NETLINK_MAX_FMTMSG_LEN)		\
> +		net_warn_ratelimited("truncated extack: " fmt "\n",	\
> +				     ##args);				\
> +									\

Some "take it or leave it" comments:
 - Jiri's idea of always printing may be worth exploring
 - my preference would also be to produce a warning on overflow,
   rather than the exact print, because I always worry about people
   starting to depend on the print.

   And WARN_ON() is really heavy and may trigger remediations even
   tho truncated extack is just a minor nuisance.

   I'd do:

   pr(extack formatting overflow $__FILE__:$__func__:$__LINE__ $needed_len)
   
   (I think splicing the "trunced extack:" with fmt will result
    in the format string getting stored in .ro twice?)
