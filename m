Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D585522A1F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 04:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241817AbiEKCxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 22:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237773AbiEKCxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 22:53:07 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19EA353E13;
        Tue, 10 May 2022 19:51:29 -0700 (PDT)
Date:   Tue, 10 May 2022 19:51:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652237487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6EZaCYycNo4v1thOOsKX7LyDVmSBgy8fN7c/00WhTOU=;
        b=Y8/hQZ/6e3GqoUyTGMgKv8zpHgfl7UpP52ogzB+dc8QtUdLIo9pf89o+40NUuyD8IIojlR
        eIg3/D0bMirUjmWu3P974MtXHdS7/Ks4kjQE/BY0QuMDbpbeUtd7v377Hga3ZsLqHplrN9
        /yalC9ohO8n+ZoB6rPbUIZ0nKi8Pe2E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Vasily Averin <vvs@openvz.org>
Cc:     Shakeel Butt <shakeelb@google.com>, kernel@openvz.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>,
        Michal Hocko <mhocko@suse.com>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH memcg v2] memcg: accounting for objects allocated for new
 netdevice
Message-ID: <YnskqRzAmtfLRd7U@carbon>
References: <53613f02-75f2-0546-d84c-a5ed989327b6@openvz.org>
 <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <354a0a5f-9ec3-a25c-3215-304eab2157bc@openvz.org>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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

It seems it's a bit too late, but just for the record:

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
