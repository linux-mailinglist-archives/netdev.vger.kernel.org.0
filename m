Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDD9EB9C4
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 23:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfJaWkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 18:40:04 -0400
Received: from www62.your-server.de ([213.133.104.62]:41146 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfJaWkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 18:40:04 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQJ6m-0003Q3-5I; Thu, 31 Oct 2019 23:40:00 +0100
Received: from [178.197.249.38] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1iQJ6l-0004Nw-QI; Thu, 31 Oct 2019 23:39:59 +0100
Subject: Re: [PATCH nf-next,RFC 5/5] netfilter: Introduce egress hook
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>
References: <cover.1572528496.git.lukas@wunner.de>
 <de461181e53bcec9a75a9630d0d998d555dc8bf5.1572528497.git.lukas@wunner.de>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <d5876ef3-bcee-e0b2-273e-e0405fe17b79@iogearbox.net>
Date:   Thu, 31 Oct 2019 23:39:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <de461181e53bcec9a75a9630d0d998d555dc8bf5.1572528497.git.lukas@wunner.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25619/Thu Oct 31 09:55:29 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/31/19 2:41 PM, Lukas Wunner wrote:
> Commit e687ad60af09 ("netfilter: add netfilter ingress hook after
> handle_ing() under unique static key") introduced the ability to
> classify packets on ingress.
> 
> Allow the same on egress.
> 
> The need for this arose because I had to filter egress packets which do
> not match a specific ethertype.  The most common solution appears to be

This seems like a /very/ weak justification for something that sits in
critical fastpath. NAK.

> to enslave the interface to a bridge and use ebtables, but that's
> cumbersome to configure and comes with a (small) performance penalty.
> An alternative approach is tc, but that doesn't afford equivalent
> matching options as netfilter.
Hmm, have you tried tc BPF on the egress hook (via sch_cls_act -> cls_bpf)?

> people have expressed a desire for egress filtering in the past:
> 
> https://www.spinics.net/lists/netfilter/msg50038.html

Adding another hook to catch misconfigurations of NAT in postrouting ...?

> https://unix.stackexchange.com/questions/512371

This talks about filtering / limiting ARP packets which can be done today
easily with existing means, including writing ARP responders sitting on tc
ingress/egress hook.

> An egress hook therefore seems like an obvious addition.
> 
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
