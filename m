Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F67B6662F9
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjAKSqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:46:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235697AbjAKSqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:46:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262063C71C
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:46:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2FBFB81C0F
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 18:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31658C433EF;
        Wed, 11 Jan 2023 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673462779;
        bh=uyWoCOG87dg+gAuT0KEe4d6+Z9NasEQiTVCpuzsGMvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sf1VBVenABK6qEZ79OU5FkLUixmrHb5F45yXHnQor5N28kSbJTFTE/TagxxK++S6s
         p2Ppo6wmaD1RFHTTfOTMCUpT4n4+zAGVWR5w8Rp1r/Nld+fk65XsRwRmNYwP/NHAqC
         jdmzPsqExogtbbYZsJlAt2UIUB0yCF6wpA+ZiBJ+g0tHOlhy0RyGDSup7h1hTYETzc
         iL6yoJFmvYMjbaDzziIcHMiui4iGiZvPgx9CB5jBhRiAecF7moprtkjxmAqlQ5gWyA
         /t87a5nbQC7Cr3q3hIv2mLdPWEwniGeZFCQbkVpaltpP8UYlQlbUH0vzSP9ZGnjVst
         JrneBNOf8ct2g==
Date:   Wed, 11 Jan 2023 10:46:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     jgh@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
Message-ID: <20230111104618.74022e83@kernel.org>
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
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

On Wed, 11 Jan 2023 14:34:20 +0000 jgh@redhat.com wrote:
> Stats counters are incremented in ipv4 and ipv6 input processing,
> with results:
> 
>  $ nstat -sz *Congest*
>  #kernel
>  Ip6InCongestionPkts             0                  0.0
>  IpExtInCongestionPkts           148454             0.0
>  $ 

Do you have any reason to believe that it actually helps anything?
NAPI with typical budget of 64 is easily exhausted (you just need 
two TSO frames arriving at once with 1500 MTU).

Host level congestion is better detected using time / latency signals.
Timestamp the packet at the NIC and compare the Rx time to current time
when processing by the driver. 

Google search "Google Swift congestion control".
