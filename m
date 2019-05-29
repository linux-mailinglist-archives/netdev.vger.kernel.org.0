Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CAB72DAEB
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 12:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfE2Khd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 06:37:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbfE2Khc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 06:37:32 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2E4720B1F;
        Wed, 29 May 2019 10:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559126251;
        bh=SxU7w6Gjg8QT0ZippUNKx1AOfJOqaCKBDZniPh5LqSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X1tF7/xEJxp+DEjeBZ5UhSnuwKkSs9o3uXZQH+65q0K3WUtTevT1EF7YefAVLfCnu
         yzGvfQnyUvhDGeffyB0bypSWSfh7zNmqY5BGM3vtQYV0fDRBeQCc/gi/FGvGUnC8cq
         xQ/sOh3NdsXQeBJ0p2ljLh31pK2HmbOXPi+KIPTA=
Date:   Wed, 29 May 2019 03:37:31 -0700
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stefan Bader <stefan.bader@canonical.com>
Cc:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>
Subject: Re: [PATCH 1/4] ipv4: ipv6: netfilter: Adjust the frag mem limit
 when truesize changes
Message-ID: <20190529103731.GB7383@kroah.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
 <20190529102542.17742-2-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529102542.17742-2-stefan.bader@canonical.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 29, 2019 at 12:25:39PM +0200, Stefan Bader wrote:
> From: Jiri Wiesner <jwiesner@suse.com>
> 
> The *_frag_reasm() functions are susceptible to miscalculating the byte
> count of packet fragments in case the truesize of a head buffer changes.
> The truesize member may be changed by the call to skb_unclone(), leaving
> the fragment memory limit counter unbalanced even if all fragments are
> processed. This miscalculation goes unnoticed as long as the network
> namespace which holds the counter is not destroyed.
> 
> Should an attempt be made to destroy a network namespace that holds an
> unbalanced fragment memory limit counter the cleanup of the namespace
> never finishes. The thread handling the cleanup gets stuck in
> inet_frags_exit_net() waiting for the percpu counter to reach zero. The
> thread is usually in running state with a stacktrace similar to:
> 
>  PID: 1073   TASK: ffff880626711440  CPU: 1   COMMAND: "kworker/u48:4"
>   #5 [ffff880621563d48] _raw_spin_lock at ffffffff815f5480
>   #6 [ffff880621563d48] inet_evict_bucket at ffffffff8158020b
>   #7 [ffff880621563d80] inet_frags_exit_net at ffffffff8158051c
>   #8 [ffff880621563db0] ops_exit_list at ffffffff814f5856
>   #9 [ffff880621563dd8] cleanup_net at ffffffff814f67c0
>  #10 [ffff880621563e38] process_one_work at ffffffff81096f14
> 
> It is not possible to create new network namespaces, and processes
> that call unshare() end up being stuck in uninterruptible sleep state
> waiting to acquire the net_mutex.
> 
> The bug was observed in the IPv6 netfilter code by Per Sundstrom.
> I thank him for his analysis of the problem. The parts of this patch
> that apply to IPv4 and IPv6 fragment reassembly are preemptive measures.
> 
> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
> Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
> Acked-by: Peter Oskolkov <posk@google.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> (backported from commit ebaf39e6032faf77218220707fc3fa22487784e0)
> [smb: context adjustments in net/ipv6/netfilter/nf_conntrack_reasm.c]
> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>

I can't take a patch for 4.4.y that is not in 4.9.y as anyone upgrading
kernel versions would have a regression :(

Can you also provide a backport of the needed patches for 4.9.y for this
issue so I can take these?

thanks,

greg k-h
