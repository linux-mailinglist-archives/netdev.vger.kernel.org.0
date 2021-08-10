Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE0D3E5B35
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241271AbhHJNXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239580AbhHJNX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 09:23:28 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF30C0613D3;
        Tue, 10 Aug 2021 06:23:04 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mDRiS-0008GT-E0; Tue, 10 Aug 2021 15:22:48 +0200
Date:   Tue, 10 Aug 2021 15:22:48 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] netfilter: protect nft_ct_pcpu_template_refcnt with
 mutex
Message-ID: <20210810132248.GS607@breakpoint.cc>
References: <20210810125523.15312-1-paskripkin@gmail.com>
 <20210810125920.23187-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810125920.23187-1-paskripkin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> wrote:
> Syzbot hit use-after-free in nf_tables_dump_sets. The problem was in
> missing lock protection for nft_ct_pcpu_template_refcnt.
> 
> Before commit f102d66b335a ("netfilter: nf_tables: use dedicated
> mutex to guard transactions") all transactions were serialized by global
> mutex, but then global mutex was changed to local per netnamespace
> commit_mutex.
> 
> This change causes use-after-free bug, when 2 netnamespaces concurently
> changing nft_ct_pcpu_template_refcnt without proper locking. Fix it by
> adding nft_ct_pcpu_mutex and protect all nft_ct_pcpu_template_refcnt
> changes with it.
> 
> Fixes: f102d66b335a ("netfilter: nf_tables: use dedicated mutex to guard transactions")
> Reported-and-tested-by: syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Acked-by: Florian Westphal <fw@strlen.de>
