Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F33819CD26
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 00:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390157AbgDBWwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 18:52:22 -0400
Received: from www62.your-server.de ([213.133.104.62]:35178 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387919AbgDBWwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 18:52:21 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8h9-0004Ra-NB; Fri, 03 Apr 2020 00:52:19 +0200
Received: from [178.195.186.98] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1jK8h9-000331-Dn; Fri, 03 Apr 2020 00:52:19 +0200
Subject: Re: [PATCH bpf] net, sk_msg: Don't use RCU_INIT_POINTER on
 sk_user_data
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        kbuild test robot <lkp@intel.com>
References: <20200402125524.851439-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <3dd151ce-01cf-7267-af13-c509e617e022@iogearbox.net>
Date:   Fri, 3 Apr 2020 00:52:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200402125524.851439-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.2/25770/Thu Apr  2 14:58:54 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/2/20 2:55 PM, Jakub Sitnicki wrote:
> sparse reports an error due to use of RCU_INIT_POINTER helper to assign to
> sk_user_data pointer, which is not tagged with __rcu:
> 
> net/core/sock.c:1875:25: error: incompatible types in comparison expression (different address spaces):
> net/core/sock.c:1875:25:    void [noderef] <asn:4> *
> net/core/sock.c:1875:25:    void *
> 
> ... and rightfully so. sk_user_data is not always treated as a pointer to
> an RCU-protected data. When it is used to point at an RCU-protected object,
> we access it with __sk_user_data to inform sparse about it.
> 
> In this case, when the child socket does not inherit sk_user_data from the
> parent, there is no reason to treat it as an RCU-protected pointer.
> 
> Use a regular assignment to clear the pointer value.
> 
> Fixes: f1ff5ce2cd5e ("net, sk_msg: Clear sk_user_data pointer on clone if tagged")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

LGTM, applied, thanks!
