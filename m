Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D56412A34B
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 17:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbfLXQ62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 11:58:28 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:32972 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbfLXQ61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 11:58:27 -0500
Received: by mail-io1-f66.google.com with SMTP id z8so19579776ioh.0
        for <netdev@vger.kernel.org>; Tue, 24 Dec 2019 08:58:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sYNcm/uxU9U7nW2JBvPuWv4lssHkDBHTkmoGEX7TILo=;
        b=H9jl1xIykl9XiyCTShihRhegQJheWjHaOKMVKTQboO+6ZoC3cH98tSV8Vc/5BmLJJf
         3oTX2KeFA2AymOWwCvPqM4HvEAFMBcEkpAr42hDY5OGrbumsG1aHH+qdPtrYZOZCqS+h
         PX60OC8dWYdnFsucEL+QGQSa7zW0OpbiAx713H4xnOWwbDdjCnU8KId399E6YrjdXfnp
         iEc+iqqvMD2ihhvOZYKODWlNABDb8prtwSkSQuYQG1WAJHFjO1A2/ZP18MGp2zRQl5/2
         EAKka3gHNWCh5vedqtkuM5ySO6gUbl8k85sT9eljVELIuLht0Ez3swcr/zN3YYxWiSHS
         dsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sYNcm/uxU9U7nW2JBvPuWv4lssHkDBHTkmoGEX7TILo=;
        b=n9MXtt3mAnetjzcPY73bGvnEaFtYNwEQb/fyA2W+61vQElpLHNB1m5ZPCz0otM/eR5
         aJeahPmbhQz/VDJ8MNrkQNbvNscONgEyBBP/zvAGSb1tpOjCoxJ2EODgCkG7Na6/dpuG
         Tr6KkpU4JiQGZuxMgEopsifM5wYh8aQMUYrDSFGbflIgfQmrqmdgiA1BCqTtxOr/YVM4
         oegwSkMO7YVS+FoRdLaDyQ3zkSAh+tZLl0sccg4PCsE/4QEAIvLS/w/fqVTztio+dYL4
         6Dr7yoQOIC2rwtHT8rT0AnQCoDz4p6j6LDGS0PgYEZul6BwErxr8gr3+6Xt+a4IloNmK
         6Svw==
X-Gm-Message-State: APjAAAWFB1fMrMczENacSD7E9l2J/rq1tBNNZV3+7mgbJHihll1e2fFQ
        Lj9MNDtx+23snsQAwiHYiIA=
X-Google-Smtp-Source: APXvYqx5320FoHIqRde4KKOz2npc5lN40UnFBB+trsbZ5sCVdHTDNY9mBKoX+FWF21ssZAOxNvUXnA==
X-Received: by 2002:a5d:9249:: with SMTP id e9mr25011523iol.242.1577206707297;
        Tue, 24 Dec 2019 08:58:27 -0800 (PST)
Received: from ?IPv6:2601:284:8202:10b0:859d:710a:f117:8322? ([2601:284:8202:10b0:859d:710a:f117:8322])
        by smtp.googlemail.com with ESMTPSA id y131sm7217804iof.56.2019.12.24.08.58.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2019 08:58:26 -0800 (PST)
Subject: Re: [PATCH net-next 5/9] ipv6: Only Replay routes of interest to new
 listeners
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        jakub.kicinski@netronome.com, jiri@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20191223132820.888247-1-idosch@idosch.org>
 <20191223132820.888247-6-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <238ef338-2582-0e10-0e70-1d1e6deb6934@gmail.com>
Date:   Tue, 24 Dec 2019 09:58:25 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <20191223132820.888247-6-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/23/19 6:28 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> When a new listener is registered to the FIB notification chain it
> receives a dump of all the available routes in the system. Instead, make
> sure to only replay the IPv6 routes that are actually used in the data
> path and are of any interest to the new listener.
> 
> This is done by iterating over all the routing tables in the given
> namespace, but from each traversed node only the first route ('leaf') is
> notified. Multipath routes are notified in a single notification instead
> of one for each nexthop.
> 
> Add fib6_rt_dump_tmp() to do that. Later on in the patch set it will be
> renamed to fib6_rt_dump() instead of the existing one.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  net/ipv6/ip6_fib.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


