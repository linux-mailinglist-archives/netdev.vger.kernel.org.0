Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A255A3DFD35
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 10:44:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236689AbhHDIoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 04:44:21 -0400
Received: from mail.netfilter.org ([217.70.188.207]:55332 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236697AbhHDIoT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 04:44:19 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8E16D60043;
        Wed,  4 Aug 2021 10:43:29 +0200 (CEST)
Date:   Wed, 4 Aug 2021 10:43:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] netfilter: ipset: Fix maximal range check in
 hash_ipportnet4_uadt()
Message-ID: <20210804084355.GA1483@salvia>
References: <20210803191813.282980-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210803191813.282980-1-nathan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 12:18:13PM -0700, Nathan Chancellor wrote:
> Clang warns:
> 
> net/netfilter/ipset/ip_set_hash_ipportnet.c:249:29: warning: variable
> 'port_to' is uninitialized when used here [-Wuninitialized]
>         if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
>                                    ^~~~~~~
> net/netfilter/ipset/ip_set_hash_ipportnet.c:167:45: note: initialize the
> variable 'port_to' to silence this warning
>         u32 ip = 0, ip_to = 0, p = 0, port, port_to;
>                                                    ^
>                                                     = 0
> net/netfilter/ipset/ip_set_hash_ipportnet.c:249:39: warning: variable
> 'port' is uninitialized when used here [-Wuninitialized]
>         if (((u64)ip_to - ip + 1)*(port_to - port + 1) > IPSET_MAX_RANGE)
>                                              ^~~~
> net/netfilter/ipset/ip_set_hash_ipportnet.c:167:36: note: initialize the
> variable 'port' to silence this warning
>         u32 ip = 0, ip_to = 0, p = 0, port, port_to;
>                                           ^
>                                            = 0
> 2 warnings generated.
> 
> The range check was added before port and port_to are initialized.
> Shuffle the check after the initialization so that the check works
> properly.

For the record: I have squashed this fix into the original patch in
nf.git to make it easier to pass it on to -stable.

Thanks.
