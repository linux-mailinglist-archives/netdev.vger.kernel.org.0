Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 169066D962
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 05:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbfGSDe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 23:34:57 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGSDe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 23:34:57 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA29714051852;
        Thu, 18 Jul 2019 20:34:56 -0700 (PDT)
Date:   Thu, 18 Jul 2019 20:34:56 -0700 (PDT)
Message-Id: <20190718.203456.202734701056640827.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, brakmo@fb.com,
        ncardwell@google.com
Subject: Re: [PATCH net] tcp: fix tcp_set_congestion_control() use from bpf
 hook
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190719022814.233056-1-edumazet@google.com>
References: <20190719022814.233056-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 20:34:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 18 Jul 2019 19:28:14 -0700

> Neal reported incorrect use of ns_capable() from bpf hook.
> 
> bpf_setsockopt(...TCP_CONGESTION...)
>   -> tcp_set_congestion_control()
>    -> ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN)
>     -> ns_capable_common()
>      -> current_cred()
>       -> rcu_dereference_protected(current->cred, 1)
> 
> Accessing 'current' in bpf context makes no sense, since packets
> are processed from softirq context.
> 
> As Neal stated : The capability check in tcp_set_congestion_control()
> was written assuming a system call context, and then was reused from
> a BPF call site.
> 
> The fix is to add a new parameter to tcp_set_congestion_control(),
> so that the ns_capable() call is only performed under the right
> context.
> 
> Fixes: 91b5b21c7c16 ("bpf: Add support for changing congestion control")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Lawrence Brakmo <brakmo@fb.com>
> Reported-by: Neal Cardwell <ncardwell@google.com>

Applied and queued up for -stable.
