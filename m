Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6213F3525A
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfFDVzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:55:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53052 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDVzX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:55:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD94615024F2C;
        Tue,  4 Jun 2019 14:55:22 -0700 (PDT)
Date:   Tue, 04 Jun 2019 14:55:22 -0700 (PDT)
Message-Id: <20190604.145522.1019698960837846036.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next] ipv6: Always allocate pcpu memory in a fib6_nh
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190604013703.2043-1-dsahern@kernel.org>
References: <20190604013703.2043-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Jun 2019 14:55:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon,  3 Jun 2019 18:37:03 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> A recent commit had an unintended side effect with reject routes:
> rt6i_pcpu is expected to always be initialized for all fib6_info except
> the null entry. The commit mentioned below skips it for reject routes
> and ends up leaking references to the loopback device. For example,
> 
>     ip netns add foo
>     ip -netns foo li set lo up
>     ip -netns foo -6 ro add blackhole 2001:db8:1::1
>     ip netns exec foo ping6 2001:db8:1::1
>     ip netns del foo
> 
> ends up spewing:
>     unregister_netdevice: waiting for lo to become free. Usage count = 3
> 
> The fib_nh_common_init is not needed for reject routes (no ipv4 caching
> or encaps), so move the alloc_percpu_gfp after it and adjust the goto label.
> 
> Fixes: f40b6ae2b612 ("ipv6: Move pcpu cached routes to fib6_nh")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
