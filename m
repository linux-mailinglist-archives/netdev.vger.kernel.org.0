Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1054C4CC14C
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 16:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiCCPb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 10:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234448AbiCCPbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 10:31:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 816EA18645D
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 07:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1CA48B82610
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 15:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F240C340F3;
        Thu,  3 Mar 2022 15:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646321465;
        bh=6Rhjapl3Sp4lyeFVGQWAc2cItYX2bIMzkAGlTQeBX4E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gvQalPGGmG3HoHHb0LSzTsHv0vF4g5200OHN6a3s6udVYQgoI0jUT64wMC4zNQAL5
         eenTsC1L8EiwBPqACvEU1ftXeEPLA/ZQxqAKVuwDP10phAqWipFjbVkeAJllUOGLTj
         cfJDdkPxkU8vK5CHNbqkwpuZSKGtHLCRtswM00hCPIwSnGCINhJyaF0qTGET8v6BHz
         F4ghxaj5cBRUHBKiiWOI1e9AUTwh2s7AH7seskoP8BpAI7ycI4W6XyK6SKj+QQtuC3
         F3pipoPSmXpqJaymdwpqazKM8LukRPe78kRksHBHihZLSQaJdbaFtRkvNZtFVUd6Pk
         PywqITPvfYgEA==
Date:   Thu, 3 Mar 2022 07:31:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Eric Dumazet <edumazet@google.com>,
        Paul Blakey <paulb@nvidia.com>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        zhang kai <zhangkaiheb@126.com>,
        Juhee Kang <claudiajkang@gmail.com>,
        Andreas Oetken <ennoerlangen@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        netdev@vger.kernel.org,
        Anthony Harivel <anthony.harivel@linutronix.de>
Subject: Re: [PATCH net-next v1] flow_dissector: Add support for HSR
Message-ID: <20220303073103.6fb2e995@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <87ilsva264.fsf@kurt>
References: <20220228195856.88187-1-kurt@linutronix.de>
        <20220302224425.410e1f15@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <87ilsva264.fsf@kurt>
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

On Thu, 03 Mar 2022 09:08:35 +0100 Kurt Kanzenbach wrote:
> It's this statement here:
> 
>  https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/include/linux/skbuff.h#n2483
> 
> I tried to look up, why is this a BUG_ON() in Thomas' history tree
> [1]. Couldn't find an explanation. It's been introduced by this commit:

I meant fix the caller to discard a frame if it doesn't have enough
data - call pskb_may_pull() first, then skb_pull().

> |commit 1a0153507ffae9cf3350e76c12d441788c0191e1 (HEAD)
> |Author: Linus Torvalds <torvalds@athlon.transmeta.com>
> |Date:   Mon Feb 4 18:11:38 2002 -0800
> |
> |    v2.4.3.2 -> v2.4.3.3
> |    
> |      - Hui-Fen Hsu: sis900 driver update
> |      - NIIBE Yutaka: Super-H update
> |      - Alan Cox: more resyncs (ARM down, but more to go)
> |      - David Miller: network zerocopy, Sparc sync, qlogic,FC fix, etc.
> |      - David Miller/me: get rid of various drivers hacks to do mmap
> |      alignment behind the back of the VM layer. Create a real
> |      protocol for it.
> 
> It seems like BUG/BUG_ON() is the error handling practice in case of
> unavailable memory. Even though most functions such as skb_push() or
> skb_put() use asserts or skb_over_panic() which also result in BUG() at
> the end.
