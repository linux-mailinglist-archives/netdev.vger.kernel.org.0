Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4935A4CD40D
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239702AbiCDMLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 07:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239688AbiCDMLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 07:11:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8011F1A6F83;
        Fri,  4 Mar 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC5C8B82809;
        Fri,  4 Mar 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B12EC340F0;
        Fri,  4 Mar 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646395810;
        bh=LqlkAseTI/VVBq3bh8hjHCdv78FzBYV3JQU9XX5kx+Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MT7QECO3wQpsJESYXFxomvbCchNHagT1ALOrZwIfpMKayVrU9iAVvrVtzZ+h/owvW
         +ibmqy8usUOmemE5X2pD9vRdBA/BPXVzpwDFCN300Y218xaobBSr6Hu1ed5t0IByAQ
         qH+gATHsDgOQQG6G8RlWmx/Y9MxFh1WHMoQ4wMQ+ZxnD+/SJezCSSFhaG/+DWVvn3n
         wFZj/87gz0gvUftiPnuegAMQcqBOTaQ++9g+aZhdLYP7neIf4wigqqEoQJpDo2qsDK
         NsW5rJOj9GLuoqWDAFNOaeoKrvzDbBVlu5IkQpTlAOr1BIUuFsiIb2EE9eOlfA6VyK
         eE6j97bluZgng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7F4BCE6D4BB;
        Fri,  4 Mar 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: macb: Fix lost RX packet wakeup race in NAPI
 receive
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164639581051.6905.901376862020393638.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 12:10:10 +0000
References: <20220303181027.168204-1-robert.hancock@calian.com>
In-Reply-To: <20220303181027.168204-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net, kuba@kernel.org,
        soren.brinkmann@xilinx.com, scott.mcnutt@siriusxm.com,
        stable@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  3 Mar 2022 12:10:27 -0600 you wrote:
> There is an oddity in the way the RSR register flags propagate to the
> ISR register (and the actual interrupt output) on this hardware: it
> appears that RSR register bits only result in ISR being asserted if the
> interrupt was actually enabled at the time, so enabling interrupts with
> RSR bits already set doesn't trigger an interrupt to be raised. There
> was already a partial fix for this race in the macb_poll function where
> it checked for RSR bits being set and re-triggered NAPI receive.
> However, there was a still a race window between checking RSR and
> actually enabling interrupts, where a lost wakeup could happen. It's
> necessary to check again after enabling interrupts to see if RSR was set
> just prior to the interrupt being enabled, and re-trigger receive in that
> case.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: macb: Fix lost RX packet wakeup race in NAPI receive
    https://git.kernel.org/netdev/net/c/0bf476fc3624

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


