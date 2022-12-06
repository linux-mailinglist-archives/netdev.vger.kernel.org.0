Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE989644BDB
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiLFSgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:36:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiLFSg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:36:28 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B404DD65;
        Tue,  6 Dec 2022 10:36:26 -0800 (PST)
Message-ID: <deb77161-3091-a134-4b82-78fef06efe85@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1670351785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vVTQ+Ap4e/KZs2xYUNBsyqF85aC6jCpJzIZ0LtrQ85k=;
        b=glcRjbZtMXKskaTlgnihbci7XEeagGKW4gAqUbiZx/A22Q9dduxcNX3r9oZe563RaXN7zP
        +rSMcc9XOIjJ7+Y9PEBekdgpwjzC/SZSfRlkBIhLrX2H6ax3iLTeYIEhVvDV5FGoN7CJ+n
        rPDMlG4x+XxRJfJYErvZusj5Toa0bks=
Date:   Tue, 6 Dec 2022 10:36:20 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf-next v2] bpf: Upgrade bpf_{g,s}etsockopt return values
Content-Language: en-US
To:     Ji Rongfeng <SikoJobs@outlook.com>
Cc:     daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        andrii@kernel.org, song@kernel.org, yhs@fb.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <DU0P192MB1547FE6F35CC1A3EEA1AFDECD6179@DU0P192MB1547.EURP192.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/22 9:39 AM, Ji Rongfeng wrote:
> Returning -EINVAL almost all the time when error occurs is not very
> helpful for the bpf prog to figure out what is wrong. This patch
> upgrades some return values so that they will be much more helpful.
> 
> * return -ENOPROTOOPT when optname is unsupported
> 
>    The same as {g,s}etsockopt() syscall does. Before this patch,
>    bpf_setsockopt(TCP_SAVED_SYN) already returns -ENOPROTOOPT, which
>    may confuse the user, as -EINVAL is returned on other unsupported
>    optnames. This patch also rejects TCP_SAVED_SYN right in
>    sol_tcp_sockopt() when getopt is false, since do_tcp_setsockopt()
>    is just the executor and it's not its duty to discover such error
>    in bpf. We should maintain a precise allowlist to control whether
>    an optname is supported and allowed to enter the executor or not.
>    Functions like do_tcp_setsockopt(), their behaviour are not fully
>    controllable by bpf. Imagine we let an optname pass, expecting
>    -ENOPROTOOPT will be returned, but someday that optname is
>    actually processed and unfortunately causes deadlock when calling
>    from bpf. Thus, precise access control is essential.

Please leave the current -EINVAL to distinguish between optnames rejected by bpf 
and optnames rejected by the do_*_{get,set}sockopt().

> 
> * return -EOPNOTSUPP on level-related errors
> 
>    In do_ip_getsockopt(), -EOPNOTSUPP will be returned if level !=
>    SOL_IP. In ipv6_getsockopt(), -ENOPROTOOPT will be returned if
>    level != SOL_IPV6. To be distinguishable, the former is chosen.

I would leave this one as is also.  Are you sure the do_ip_*sockopt cannot 
handle sk_family == AF_INET6?  afaict, bpf is rejecting those optnames instead.

> 
> * return -EBADFD when sk is not a full socket
> 
>    -EPERM or -EBUSY was an option, but in many cases one of them
>    will be returned, especially under level SOL_TCP. -EBADFD is the
>    better choice, since it is hardly returned in all cases. The bpf
>    prog will be able to recognize it and decide what to do next.

This one makes sense and is useful.

