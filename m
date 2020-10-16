Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AF58290E41
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 01:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409666AbgJPXpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 19:45:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392392AbgJPXpV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 19:45:21 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 327F1221FD;
        Fri, 16 Oct 2020 23:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602891969;
        bh=Dnv8ptGKZA37R38BIVdH4VBeUuevLU0PNBY/75vdbwQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xiAjw70t6VN/+8UBFS/SI0uqvLZIZL1m9/OVa6fhhghfduFdcx2/9PIf2wOZFBPsz
         RzpL90WBx7HSuNs8Q/6SLU0mpn2dgeDNtHKsbIZN8NtDZo0Q8GUMkLazPTV/s427zW
         2yLW+N8MRQXbazNOX6Gxx5wbzPkomzzpt4nwEW/c=
Date:   Fri, 16 Oct 2020 16:46:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org, jlelli@redhat.com,
        bigeasy@linutronix.de, i.maximets@ovn.org
Subject: Re: [PATCH net v3] net: openvswitch: fix to make sure flow_lookup()
 is not preempted
Message-ID: <20201016164607.4244ca24@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <160278168341.905188.913081997609088316.stgit@ebuild>
References: <160278168341.905188.913081997609088316.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 19:09:33 +0200 Eelco Chaudron wrote:
> The flow_lookup() function uses per CPU variables, which must be called
> with BH disabled. However, this is fine in the general NAPI use case
> where the local BH is disabled. But, it's also called from the netlink
> context. The below patch makes sure that even in the netlink path, the
> BH is disabled.
> 
> In addition, u64_stats_update_begin() requires a lock to ensure one writer
> which is not ensured here. Making it per-CPU and disabling NAPI (softirq)
> ensures that there is always only one writer.
> 
> Fixes: eac87c413bf9 ("net: openvswitch: reorder masks array based on usage")
> Reported-by: Juri Lelli <jlelli@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Hi Eelco, looks like this doesn't apply after the 5.10 merges.

Please respin on top of the current net.
