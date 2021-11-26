Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A30D45F534
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 20:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235046AbhKZTeN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 14:34:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38948 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236494AbhKZTcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 14:32:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE32CB82871;
        Fri, 26 Nov 2021 19:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204EDC9305B;
        Fri, 26 Nov 2021 19:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637954937;
        bh=LgkRBRvv+cKs3pwJC0Uy+xjgGeVp/1fHAIN7Q3a58e0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P9DTuNO9O9qNPxFLy1XUgwKWkBIe/w+yTJu3JexwnPJP0zLEUU/l62hcycRErZBpG
         fxnxsp0YjWV28H579uyygI4GHsjf1RX/WOm1l9WpPI4M9ja21QDMLmz9h8VL00rX16
         0+lnC8kbvp51nwHyxrkLY9XI/g6DcyGiZPm0bNM5ZG2Dz6AK0AnEke80P05sW89dwz
         //ae9DKEoOxS/FxUaZSoYjXugWp/RxkqCWUDh48ZU3md/zJDX2aJj+kGvP2AGs31XU
         J2eEi0A7l0MevhbOgvZjPWOdees3HHlrLu6i9Gf44qJCDY70Q/7XiO6U5GhVO70giI
         GiFMqh7/bbr+w==
Date:   Fri, 26 Nov 2021 11:28:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: Clear memory when release and reuse buffer
Message-ID: <20211126112855.37274cb7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125122858.90726-1-tonylu@linux.alibaba.com>
References: <20211125122858.90726-1-tonylu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 20:28:59 +0800 Tony Lu wrote:
> Currently, buffers are clear when smc create connections and reuse
> buffer. It will slow down the speed of establishing new connection. In
> most cases, the applications hope to establish connections as quickly as
> possible.
> 
> This patch moves memset() from connection creation path to release and
> buffer unuse path, this trades off between speed of establishing and
> release.
> 
> Test environments:
> - CPU Intel Xeon Platinum 8 core, mem 32 GiB, nic Mellanox CX4
> - socket sndbuf / rcvbuf: 16384 / 131072 bytes
> - w/o first round, 5 rounds, avg, 100 conns batch per round
> - smc_buf_create() use bpftrace kprobe, introduces extra latency
> 
> Latency benchmarks for smc_buf_create():
>   w/o patch : 19040.0 ns
>   w/  patch :  1932.6 ns
>   ratio :        10.2% (-89.8%)
> 
> Latency benchmarks for socket create and connect:
>   w/o patch :   143.3 us
>   w/  patch :   102.2 us
>   ratio :        71.3% (-28.7%)
> 
> The latency of establishing connections is reduced by 28.7%.
> 
> Signed-off-by: Tony Lu <tonylu@linux.alibaba.com>
> Reviewed-by: Wen Gu <guwen@linux.alibaba.com>

The tag in the subject seems incorrect, we tag things as [PATCH net] 
if they are fixes, and as [PATCH net-next] if they are new features,
code refactoring or performance improvements.

Is this a fix for a regression? In which case we need a Fixes tag to
indicate where it was introduced. Otherwise it needs to be tagged as
[PATCH net-next].

I'm assuming Karsten will take it via his tree, otherwise you'll need
to repost.
