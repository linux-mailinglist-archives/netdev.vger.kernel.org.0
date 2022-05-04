Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B48F51AFC2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357336AbiEDUyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 16:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237697AbiEDUyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 16:54:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803D11A386;
        Wed,  4 May 2022 13:50:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=LUcWUXDVgRzdq1jJHmWhPb5IAqTKtI0mu9qnJVWCZic=; b=rp3tULafgJwVBqrzXLuxhcy/Cp
        Wr2a2vR1oJIDTyhyFZkUrOdOCxirZ2u/G22uY4Av/ItDlm8otE7VnKe2fXojanNUlEyWaoabC/Dwf
        J00DWqbXLn8bndSSTnYoI7TYITG2H1IuBQTQDwOBB2xkJ54dCtWZaJdGf7tPVNYb2Vv/DytdhX/9G
        mkkKPJFcyJNGSDSfFKs5+TawT4xG+qSCMyicGkYx7J42cZLKgWN8TXYzigWCjfDrJU+N1CBm8rp3Q
        9Nhb3PnTxJBMO3I7UEL15fBIw8+A+jwvNz2yOFgwpv22O76MwcP35joAhD4t8jR+dnFu06TC+1DRI
        1otRHafw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nmLxJ-00CgNR-Mt; Wed, 04 May 2022 20:50:41 +0000
Date:   Wed, 4 May 2022 13:50:41 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
Message-ID: <YnLnIXmamiEuQAo3@bombadil.infradead.org>
References: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
 <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 02, 2022 at 03:15:51PM +0300, Vasily Averin wrote:
> Creating a new netdevice allocates at least ~50Kb of memory for various
> kernel objects, but only ~5Kb of them are accounted to memcg. As a result,
> creating an unlimited number of netdevice inside a memcg-limited container
> does not fall within memcg restrictions, consumes a significant part
> of the host's memory, can cause global OOM and lead to random kills of
> host processes.
> 
> The main consumers of non-accounted memory are:
>  ~10Kb   80+ kernfs nodes
>  ~6Kb    ipv6_add_dev() allocations
>   6Kb    __register_sysctl_table() allocations
>   4Kb    neigh_sysctl_register() allocations
>   4Kb    __devinet_sysctl_register() allocations
>   4Kb    __addrconf_sysctl_register() allocations
> 
> Accounting of these objects allows to increase the share of memcg-related
> memory up to 60-70% (~38Kb accounted vs ~54Kb total for dummy netdevice
> on typical VM with default Fedora 35 kernel) and this should be enough
> to somehow protect the host from misuse inside container.
> 
> Other related objects are quite small and may not be taken into account
> to minimize the expected performance degradation.
> 
> It should be separately mentonied ~300 bytes of percpu allocation
> of struct ipstats_mib in snmp6_alloc_dev(), on huge multi-cpu nodes
> it can become the main consumer of memory.
> 
> This patch does not enables kernfs accounting as it affects
> other parts of the kernel and should be discussed separately.
> However, even without kernfs, this patch significantly improves the
> current situation and allows to take into account more than half
> of all netdevice allocations.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
> v2: 1) kernfs accounting moved into separate patch, suggested by
>     Shakeel and mkoutny@.
>     2) in ipv6_add_dev() changed original "sizeof(struct inet6_dev)"
>     to "sizeof(*ndev)", according to checkpath.pl recommendation:
>       CHECK: Prefer kzalloc(sizeof(*ndev)...) over kzalloc(sizeof
>         (struct inet6_dev)...)
> ---
>  fs/proc/proc_sysctl.c | 2 +-

for proc_sysctl:

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
