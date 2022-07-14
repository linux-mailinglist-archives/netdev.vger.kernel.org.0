Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319C65746BF
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234714AbiGNIaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233386AbiGNIaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:30:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3989C27B26;
        Thu, 14 Jul 2022 01:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 364D5CE25A1;
        Thu, 14 Jul 2022 08:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29BC8C341CD;
        Thu, 14 Jul 2022 08:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657787414;
        bh=sS6goUG5X5JNFA+yAWK6MTCJUV48JL9vbeaQ1ZGiJ3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KKxG1ZyBzXgqc5KYxvrky6BX8aEzCVM5PU/WxKc4JdVgv0Y8lcl/Vz9Yb1DCJfW3Z
         7GyAKpw64BXZA7c7Pj4IwjSpWR6/yXYZo6tFaI30KDqxYVZx1UfosJbeETEYAAcJLQ
         asRVih2jLyAqmhsTMXSam3jPUfPwVfKsE+I5swUdT5teRTmW2OOcdUQ+CYQxXUcJiF
         Gd/xil2gWuK8ZcbN+3mJy2kp4iuFom3SxNDgchixUEMYHQkUSTKYnKx4HAmuUOWg9t
         oveTS+qDThygHFvLfKBbWcp++ktjsF1L8imgaGKPsDdwZcXFHhuS2oySf3C7Glv/Sl
         Vo3O79yUAfZ2A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0775EE45224;
        Thu, 14 Jul 2022 08:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 0/3] seg6: fix skb checksum for SRH encapsulation/insertion 
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165778741402.25423.1210141658823932641.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 08:30:14 +0000
References: <20220712175837.16267-1-andrea.mayer@uniroma2.it>
In-Reply-To: <20220712175837.16267-1-andrea.mayer@uniroma2.it>
To:     Andrea Mayer <andrea.mayer@uniroma2.it>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        david.lebrun@uclouvain.be, m.xhonneux@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stefano.salsano@uniroma2.it,
        paolo.lungaroni@uniroma2.it, ahabdels.dev@gmail.com,
        anton.makarov11235@gmail.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 12 Jul 2022 19:58:34 +0200 you wrote:
> The Linux kernel supports Segment Routing Header (SRH)
> encapsulation/insertion operations by providing the capability to: i)
> encapsulate a packet in an outer IPv6 header with a specified SRH; ii)
> insert a specified SRH directly after the IPv6 header of the packet.
> Note that the insertion operation is also referred to as 'injection'.
> 
> The two operations are respectively supported by seg6_do_srh_encap() and
> seg6_do_srh_inline(), which operate on the skb associated to the packet as
> needed (e.g. adding the necessary headers and initializing them, while
> taking care to recalculate the skb checksum).
> 
> [...]

Here is the summary with links:
  - [net,1/3] seg6: fix skb checksum evaluation in SRH encapsulation/insertion
    https://git.kernel.org/netdev/net/c/df8386d13ea2
  - [net,2/3] seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
    https://git.kernel.org/netdev/net/c/f048880fc770
  - [net,3/3] seg6: bpf: fix skb checksum in bpf_push_seg6_encap()
    https://git.kernel.org/netdev/net/c/4889fbd98dea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


