Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA26849C20A
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237101AbiAZDZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiAZDZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:25:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170ECC06161C;
        Tue, 25 Jan 2022 19:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 690776176A;
        Wed, 26 Jan 2022 03:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4E93C340E3;
        Wed, 26 Jan 2022 03:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643167517;
        bh=0BjzTHHKcILB1tEzLNRvq3NXKLbeWRgT3LE54UUOtzQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Sqe4iNZtHtdEiYd2+af8Zo1ZG9GQDBFUBXzubiErCxje8PuDKI5h7oMBYhZ7SubOX
         THo6rz1h4uwKp8uCyqJ+TxG46veDQ13UlDQK+LNsZSmnNiBpACcOM8pi5SLlif6QUg
         qK+A0qnYGS5FgzpRdWjipO1353QSIzyxUllv9FwtV4+M55zebpcN2eLS4WMO5Mto2C
         29mJ7k3FddAlevDnNnQ8YI9fT8FZ+chBSt47JsWYUAG9P01ZKoDoIz1MVPwaUjtnSU
         LB+j4yS4tCS2z8WCRhe1df0lny+hharuB8t++KOb/8E0RCn6tgUbiIKLLt/mkfnQbQ
         HlIlDNsW7QVTw==
Date:   Tue, 25 Jan 2022 19:25:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Menglong Dong <menglong8.dong@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, mingo@redhat.com,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, pablo@netfilter.org,
        kadlec@netfilter.org, Florian Westphal <fw@strlen.de>,
        Menglong Dong <imagedong@tencent.com>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me,
        paulb@nvidia.com, Paolo Abeni <pabeni@redhat.com>,
        talalahmad@google.com, haokexin@gmail.com,
        Kees Cook <keescook@chromium.org>, memxor@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH net-next 5/6] net: udp: use kfree_skb_reason() in
 udp_queue_rcv_one_skb()
Message-ID: <20220125192515.627cdaa5@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <00b8e410-7162-2386-4ce9-d6a619474c30@gmail.com>
References: <20220124131538.1453657-1-imagedong@tencent.com>
        <20220124131538.1453657-6-imagedong@tencent.com>
        <308b88bf-7874-4b04-47f7-51203fef4128@gmail.com>
        <CADxym3aFJcsz=fckaFx9SJh8B7=0Xv-EPz79bbUFW1wG_zNYbw@mail.gmail.com>
        <00b8e410-7162-2386-4ce9-d6a619474c30@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 20:04:39 -0700 David Ahern wrote:
> > I realized it, but SKB_DROP_REASON_TCP_FILTER was already
> > introduced before. Besides, I think maybe  
> 
> SKB_DROP_REASON_TCP_FILTER is not in a released kernel yet. If
> Dave/Jakub are ok you can change SKB_DROP_REASON_TCP_FILTER to
> SKB_DROP_REASON_SOCKET_FILTER in 'net' repository to make it usable in
> both code paths.

SGTM, FWIW. 

What was the reason we went with separate CSUM values for TCP and UDP?
Should we coalesce those as well?
