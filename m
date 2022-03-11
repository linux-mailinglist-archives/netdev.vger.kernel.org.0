Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664BD4D5A2A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 06:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbiCKFC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 00:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiCKFC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 00:02:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DFDA10CF0C
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 21:01:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD65AB82996
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:01:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DA80C340EC;
        Fri, 11 Mar 2022 05:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646974881;
        bh=N7eFwJZBTtr84pDDUZZywgCWr7DzujQE3CwJUtLUnqo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SA/iedDuYesBT4Bc+ja1t8QhZRoxta5LuYioD0/yz68kVth1/EdhuYsGwqnXDdfqo
         VNoqQsOV2cEo1yp/sFtmz39RCs3m/xJd/IoGdTYISLw1NHf5H/HzXb3MY5pguMgE2C
         EMQRBdlGt1o2REudU/K/OqCk3ciBinXvNA6k+L4Q/52XJybR5Yo+sksEkpeezSeAts
         fciWr4pU3u/RpajQguKBl/4MDa4a5X3GpkVgcAv4CxP2RMFVb4QDNeKJoF33eY3wvs
         Uf5BWSyPN0t5ZSh4qN4V+fC1KczalL65d6rihYNjxxJg163VWbRap0RC9gAz92zhqk
         okZV86YkYFhLQ==
Date:   Thu, 10 Mar 2022 21:01:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v3 net-next] net: add per-cpu storage and
 net->core_stats
Message-ID: <20220310210120.3f068bf2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310165243.981383-1-eric.dumazet@gmail.com>
References: <20220310165243.981383-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 08:52:43 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before adding yet another possibly contended atomic_long_t,
> it is time to add per-cpu storage for existing ones:
>  dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler
> 
> Because many devices do not have to increment such counters,
> allocate the per-cpu storage on demand, so that dev_get_stats()
> does not have to spend considerable time folding zero counters.
> 
> Note that some drivers have abused these counters which
> were supposed to be only used by core networking stack.
> 
> v3: added a READ_ONCE() in netdev_core_stats_alloc() (Paolo)
> 
> v2: add a missing include (reported by kernel test robot <lkp@intel.com>)
>     Change in netdev_core_stats_alloc() (Jakub)
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: jeffreyji <jeffreyji@google.com>
> Reviewed-by: Brian Vazquez <brianvv@google.com>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

> +		for_each_possible_cpu(i) {
> +			core_stats = per_cpu(p, i);

IDK if this is just sparse being silly or an actual problem but
apparently the right incantation is:

			core_stats = &per_cpu(*p, i);
