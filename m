Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255061DA7A1
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 04:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbgETCBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 22:01:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726348AbgETCBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 22:01:42 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FCE0C061A0E;
        Tue, 19 May 2020 19:01:42 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so799626pfn.11;
        Tue, 19 May 2020 19:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X8iFYlvRVspF0fTaZYyW17RP+fQGYQbAsWDbBbqHnWo=;
        b=ZLrnr3GxQADcslYwMJ5xjJu4YHw5KBIXyc7DcjCxJuiJl0E7u2+9oL43607pAzjR2n
         nA/QI6q5W6XGyranfcLDlRhwm/fqRlewB9FHY2WuHX7VXSIRvJoMV3z5UZLZMT63waeo
         xZ60yzunX0TFl+b1sl1zSBUo77gMEiedwcszNqwIfSr4BlXu4a8KxRdZMZzgn6QUGYgq
         hD1o8dYjA0ufQwNMyBoYC4m+Ygvmh+Urz44+fyiaZZ+KHiVJTmhcBIf84kOTfUeDyP2l
         NSiQK4fbXts1vS7N/Z/VKIy1uP2GobJG88JlGhO5aX5oOTgyVQovhja6QKYwWtZv/9P/
         sBhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X8iFYlvRVspF0fTaZYyW17RP+fQGYQbAsWDbBbqHnWo=;
        b=pvIzcEk2kh9GfSZY4cs7Qcj2A6BowZdkzI4lP5BEyaxQYa7TROQ3HaV6rtyXwB8pgJ
         /rbw5c9Ze+KiSGDC07q3DAV3GjhWbTj7u0z6lIIIO4cJ50+2kpfqMeJk2Otc9+qqAdZQ
         pyxTiSmZqmrDPoi7ez+xL9gryAdDUHRFeCa2L9psclsYGtZQqiz9jdmxhO6badxAsl2J
         eXUrQSDcfJEEFPN3v9p54DUE/q+/uhlNlAA5ehZnMp8Rt5hFKVp1oEa7TXFrLRhff7jg
         fcd7dgNEhuLkITtFImediwEMsJ81ViZHCn1kB4/kRy3QLRZz4utSY/B+Kn1R5sFdeuAY
         HeRg==
X-Gm-Message-State: AOAM5328XoA5Zz4iRBS9QhLB82C4ZoxQpmhWediroaIoVphyixet1pm8
        FoFuJNipZPWJwGR5NG00sN1xwio3
X-Google-Smtp-Source: ABdhPJwQaGPZrkib57z4BxetcWjXu8ZE9JkxFAR1HLPi/tVLMdIzQJFoFlaeQKJ2BZCPJTVYK8LhJw==
X-Received: by 2002:a62:4e88:: with SMTP id c130mr2018424pfb.122.1589940101860;
        Tue, 19 May 2020 19:01:41 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n10sm608834pfd.192.2020.05.19.19.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 19:01:41 -0700 (PDT)
Subject: Re: [PATCH v1 01/25] net: core: device_rename: Use rwsem instead of a
 seqcount
To:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200519214547.352050-1-a.darwish@linutronix.de>
 <20200519214547.352050-2-a.darwish@linutronix.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <33cec6a9-2f6e-3d3c-99ac-9b2a3304ec26@gmail.com>
Date:   Tue, 19 May 2020 19:01:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200519214547.352050-2-a.darwish@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/19/20 2:45 PM, Ahmed S. Darwish wrote:
> Sequence counters write paths are critical sections that must never be
> preempted, and blocking, even for CONFIG_PREEMPTION=n, is not allowed.
> 
> Commit 5dbe7c178d3f ("net: fix kernel deadlock with interface rename and
> netdev name retrieval.") handled a deadlock, observed with
> CONFIG_PREEMPTION=n, where the devnet_rename seqcount read side was
> infinitely spinning: it got scheduled after the seqcount write side
> blocked inside its own critical section.
> 
> To fix that deadlock, among other issues, the commit added a
> cond_resched() inside the read side section. While this will get the
> non-preemptible kernel eventually unstuck, the seqcount reader is fully
> exhausting its slice just spinning -- until TIF_NEED_RESCHED is set.
> 
> The fix is also still broken: if the seqcount reader belongs to a
> real-time scheduling policy, it can spin forever and the kernel will
> livelock.
> 
> Disabling preemption over the seqcount write side critical section will
> not work: inside it are a number of GFP_KERNEL allocations and mutex
> locking through the drivers/base/ :: device_rename() call chain.
> 
> From all the above, replace the seqcount with a rwsem.
> 
> Fixes: 5dbe7c178d3f (net: fix kernel deadlock with interface rename and netdev name retrieval.)
> Fixes: 30e6c9fa93cf (net: devnet_rename_seq should be a seqcount)
> Fixes: c91f6df2db49 (sockopt: Change getsockopt() of SO_BINDTODEVICE to return an interface name)
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
> Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/core/dev.c | 30 ++++++++++++------------------
>  1 file changed, 12 insertions(+), 18 deletions(-)
>

Seems fine to me, assuming rwsem prevent starvation of the writer.

(Presumably this could be a per ndevice rwsem, or per netns, to provide some isolation)

Alternative would be to convert ndev->name from char array to a pointer (rcu protected),
but this looks quite invasive change, certainly not for stable branches.

Reviewed-by: Eric Dumazet <edumazet@google.com>


