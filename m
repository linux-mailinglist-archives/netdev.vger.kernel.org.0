Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9B826255C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbgIICt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgIICt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:49:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAC3BC061573
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 19:49:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3F1A11E3E4C3;
        Tue,  8 Sep 2020 19:33:06 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:49:52 -0700 (PDT)
Message-Id: <20200908.194952.784011770473577866.davem@davemloft.net>
To:     dust.li@linux.alibaba.com
Cc:     kuba@kernel.org, edumazet@google.com, satoru.moriya@hds.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: tracepoint: fix print wrong sysctl_mem value
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908020939.7653-1-dust.li@linux.alibaba.com>
References: <20200908020939.7653-1-dust.li@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 08 Sep 2020 19:33:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dust Li <dust.li@linux.alibaba.com>
Date: Tue,  8 Sep 2020 10:09:39 +0800

> @@ -98,7 +98,7 @@ TRACE_EVENT(sock_exceed_buf_limit,
>  
>  	TP_STRUCT__entry(
>  		__array(char, name, 32)
> -		__field(long *, sysctl_mem)
> +		__array(long, sysctl_mem, 3)
>  		__field(long, allocated)
>  		__field(int, sysctl_rmem)
>  		__field(int, rmem_alloc)
> @@ -110,7 +110,9 @@ TRACE_EVENT(sock_exceed_buf_limit,
>  
>  	TP_fast_assign(
>  		strncpy(__entry->name, prot->name, 32);
> -		__entry->sysctl_mem = prot->sysctl_mem;
> +		__entry->sysctl_mem[0] = prot->sysctl_mem[0];
> +		__entry->sysctl_mem[1] = prot->sysctl_mem[1];
> +		__entry->sysctl_mem[2] = prot->sysctl_mem[2];

I can't understand at all why the current code doesn't work.

We assign a pointer to entry->sysctl_mem and then print out the
three words pointed to by that.

It's so wasteful to copy this over every tracepoint entry so
the pointer approach is very desirable.
