Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1145D6308BC
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 02:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbiKSBuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 20:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232320AbiKSBuD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 20:50:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FBF8B701E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 17:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 732426280C
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 01:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F8CC433D6;
        Sat, 19 Nov 2022 01:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668821062;
        bh=4Vny4ZVCHPK2AQSCqb7UPi5ry0OPQLk57Tqk91lH4RA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ARUXo8KAXU2+wSdD1usrWDHL9RntiS2uX03HS+3gr5Du1GqfOqSwjxpsg6hDKeIug
         0RzK3EwjcVNWjGAstfQFlLhcggcNDlnwGcZ+KWJYru5qPvTqpswHhbwW6ctv5+rjnq
         ErljXL8XZXag3gkcmGe0IzQVo1yrzElxXH4CSbWhzr2vjjFoc5ap+eVS3QqA66lZy1
         LXu+qVWMgvJSoIj5lfChF9n6RtDDE+UQouqEQ627DxdmIK2jydaU1rU6XYK8qHophv
         tICXKQz3ybF1aLs55gC0mIId2CDmaQ/xuQx//UroWPAPB9a/KSCs8ynoQYdxPi8IUo
         nIzaGfNTPrQag==
Date:   Fri, 18 Nov 2022 17:24:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 1/4] tsnep: Throttle interrupts
Message-ID: <20221118172421.01644d5a@kernel.org>
In-Reply-To: <20221117201440.21183-2-gerhard@engleder-embedded.com>
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
        <20221117201440.21183-2-gerhard@engleder-embedded.com>
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

On Thu, 17 Nov 2022 21:14:37 +0100 Gerhard Engleder wrote:
> Without interrupt throttling, iperf server mode generates a CPU load of
> 100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
> on a 1Gbit/s link. The reason is a high interrupt load with interrupts
> every ~20us.
> 
> Reduce interrupt load by throttling of interrupts. Interrupt delay is
> configured statically to 64us. For iperf server mode the CPU load is
> significantly reduced to ~20% and the throughput reaches the maximum of
> 941MBit/s. Interrupts are generated every ~140us.

User should be able to control these settings, please implement
ethtool::get_coalesce / set_coalesce.
