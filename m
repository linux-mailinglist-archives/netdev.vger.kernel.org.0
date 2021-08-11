Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8F3E8D31
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 11:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbhHKJWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 05:22:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44268 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbhHKJWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 05:22:32 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 4370560066;
        Wed, 11 Aug 2021 11:21:25 +0200 (CEST)
Date:   Wed, 11 Aug 2021 11:22:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+649e339fa6658ee623d3@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] netfilter: protect nft_ct_pcpu_template_refcnt with
 mutex
Message-ID: <20210811092201.GA23996@salvia>
References: <20210810125523.15312-1-paskripkin@gmail.com>
 <20210810125920.23187-1-paskripkin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210810125920.23187-1-paskripkin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 03:59:20PM +0300, Pavel Skripkin wrote:
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

Applied to nf.git, thanks
