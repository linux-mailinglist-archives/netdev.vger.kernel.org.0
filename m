Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FC259C3DF
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 18:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbiHVQRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234679AbiHVQRm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 12:17:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D8633E2C;
        Mon, 22 Aug 2022 09:17:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BD58B80923;
        Mon, 22 Aug 2022 16:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493EBC433C1;
        Mon, 22 Aug 2022 16:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661185058;
        bh=mKS9e/kUYTrQTIQVgSXGZbMEtY2mtpS4FDMVJ2G5hmw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZuPN6YaDp+AifescPV/BBlN9l96wSPcRJdLmXU63iV5LnFAkTCd+nXj7PjXTcsQtm
         j3sgomT7DIp0q9A6++5Y1dSF4BbCd2eSFuKaS4tU8HqRePQhb3jNj1EfUpobyymgV4
         /f0EWQrNtfyT8dJvQ8zNPgcqPqtztx5uvS73KAFgSyRqCAxeRCA7NnxRkSCWIgzdYW
         n/PrTj9+NVVAKruizvGHiKE0iJlCwN3zolHSZ4VLvBdp+0WDXn4asPaQTc6p1+xLfg
         it/EwvWeFUEVCYdRuwMBTe4OJKrJdAc0LO6zlPtq2xfevP7kcM0jZaNnEijMPkP/Hc
         ogNv6/PHyenKA==
Date:   Mon, 22 Aug 2022 09:17:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Peilin Ye <peilin.ye@bytedance.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Dave Taht <dave.taht@gmail.com>
Subject: Re: [PATCH RFC v2 net-next 0/5] net: Qdisc backpressure
 infrastructure
Message-ID: <20220822091737.4b870dbb@kernel.org>
In-Reply-To: <cover.1661158173.git.peilin.ye@bytedance.com>
References: <cover.1651800598.git.peilin.ye@bytedance.com>
        <cover.1661158173.git.peilin.ye@bytedance.com>
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

On Mon, 22 Aug 2022 02:10:17 -0700 Peilin Ye wrote:
> Currently sockets (especially UDP ones) can drop a lot of packets at TC
> egress when rate limited by shaper Qdiscs like HTB.  This patchset series
> tries to solve this by introducing a Qdisc backpressure mechanism.
> 
> RFC v1 [1] used a throttle & unthrottle approach, which introduced several
> issues, including a thundering herd problem and a socket reference count
> issue [2].  This RFC v2 uses a different approach to avoid those issues:
> 
>   1. When a shaper Qdisc drops a packet that belongs to a local socket due
>      to TC egress congestion, we make part of the socket's sndbuf
>      temporarily unavailable, so it sends slower.
>   
>   2. Later, when TC egress becomes idle again, we gradually recover the
>      socket's sndbuf back to normal.  Patch 2 implements this step using a
>      timer for UDP sockets.
> 
> The thundering herd problem is avoided, since we no longer wake up all
> throttled sockets at the same time in qdisc_watchdog().  The socket
> reference count issue is also avoided, since we no longer maintain socket
> list on Qdisc.
> 
> Performance is better than RFC v1.  There is one concern about fairness
> between flows for TBF Qdisc, which could be solved by using a SFQ inner
> Qdisc.
> 
> Please see the individual patches for details and numbers.  Any comments,
> suggestions would be much appreciated.  Thanks!
> 
> [1] https://lore.kernel.org/netdev/cover.1651800598.git.peilin.ye@bytedance.com/
> [2] https://lore.kernel.org/netdev/20220506133111.1d4bebf3@hermes.local/

Similarly to Eric's comments on v1 I'm not seeing the clear motivation
here. Modern high speed UDP users will have a CC in user space, back
off and set transmission time on the packets. Could you describe your
_actual_ use case / application in more detail?
