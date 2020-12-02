Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85D2CB165
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 01:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726763AbgLBASC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 19:18:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:57826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726258AbgLBASC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 19:18:02 -0500
Date:   Tue, 1 Dec 2020 16:17:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606868241;
        bh=R5TN/F1GnEF40pQtymJNUwECkOKm38HBWCpBT3mjkzQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=D3htoR6Lc+jqGDhEXfxKbDliPRKWVBYgrkkUUTRIscWbHNpMX63ZFl/OtJgUoeKZ5
         WG82HKtKC8zxCr31M9eLNelZXGDdiakiefTL6/k4pApeVcdO8j27ogbYASUuP9HXfl
         WDifG6+xgaxrVDxNK5d5hh+PG3SnIwe9GM36hkHw=
From:   Jakub Kicinski <kuba@kernel.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Dongdong Wang <wangdongdong@bytedance.com>,
        Thomas Graf <tgraf@suug.ch>, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>
Subject: Re: [Patch net] lwt: disable BH too in run_lwt_bpf()
Message-ID: <20201201161720.691c58d5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201201161633.2a3cc879@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201201194438.37402-1-xiyou.wangcong@gmail.com>
        <20201201161633.2a3cc879@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 16:16:33 -0800 Jakub Kicinski wrote:
> On Tue,  1 Dec 2020 11:44:38 -0800 Cong Wang wrote:
> > From: Dongdong Wang <wangdongdong@bytedance.com>
> > 
> > The per-cpu bpf_redirect_info is shared among all skb_do_redirect()
> > and BPF redirect helpers. Callers on RX path are all in BH context,
> > disabling preemption is not sufficient to prevent BH interruption.
> > 
> > In production, we observed strange packet drops because of the race
> > condition between LWT xmit and TC ingress, and we verified this issue
> > is fixed after we disable BH.
> > 
> > Although this bug was technically introduced from the beginning, that
> > is commit 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure"),
> > at that time call_rcu() had to be call_rcu_bh() to match the RCU context.
> > So this patch may not work well before RCU flavor consolidation has been
> > completed around v5.0.
> > 
> > Update the comments above the code too, as call_rcu() is now BH friendly.
> > 
> > Cc: Thomas Graf <tgraf@suug.ch>
> > Cc: bpf@vger.kernel.org
> > Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> > Signed-off-by: Dongdong Wang <wangdongdong@bytedance.com>  
> 
> Fixes?

Ah, should have read the commit message first. Okay.
