Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6809A1F8D96
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 08:17:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgFOGRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 02:17:10 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:14111 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgFOGRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jun 2020 02:17:10 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 49lh1m3ggJzB09ZG;
        Mon, 15 Jun 2020 08:17:00 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id us_QWEWQjgUN; Mon, 15 Jun 2020 08:17:00 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 49lh1m2qF8zB09ZD;
        Mon, 15 Jun 2020 08:17:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 767258B782;
        Mon, 15 Jun 2020 08:17:06 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Js7BPOCxpUQT; Mon, 15 Jun 2020 08:17:06 +0200 (CEST)
Received: from [172.25.230.104] (unknown [172.25.230.104])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3BB0B8B77C;
        Mon, 15 Jun 2020 08:17:06 +0200 (CEST)
Subject: Re: [PATCH] SUNRPC: Add missing asm/cacheflush.h
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     Bruce Fields <bfields@fieldses.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev@vger.kernel.org
References: <a356625c9aa1b5d711e320c39779e0c713f204cb.1592154127.git.christophe.leroy@csgroup.eu>
 <854D2842-6940-42BA-A48C-AE9DB48E6071@oracle.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <35ca33b7-4b9d-d70f-efcc-c1eb72483b2b@csgroup.eu>
Date:   Mon, 15 Jun 2020 08:16:55 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <854D2842-6940-42BA-A48C-AE9DB48E6071@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Le 14/06/2020 à 20:57, Chuck Lever a écrit :
> Hi Christophe -
> 
>> On Jun 14, 2020, at 1:07 PM, Christophe Leroy <christophe.leroy@csgroup.eu> wrote:
>>
>> Even if that's only a warning, not including asm/cacheflush.h
>> leads to svc_flush_bvec() being empty allthough powerpc defines
>> ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE.
>>
>>   CC      net/sunrpc/svcsock.o
>> net/sunrpc/svcsock.c:227:5: warning: "ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE" is not defined [-Wundef]
>> #if ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE
>>      ^
>>
>> Fixes: ca07eda33e01 ("SUNRPC: Refactor svc_recvfrom()")
>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>> ---
>> I detected this on linux-next on June 4th and warned Chuck. Seems like it went into mainline anyway.
> 
> Thanks for your patch. I've searched my mailbox. It appears I never
> received your June 4th e-mail.

It is there: 
https://lore.kernel.org/linuxppc-dev/868915eb-8fed-0600-ea5d-31ae874457b1@csgroup.eu/

> 
> Does your patch also address:
> 
>     https://marc.info/?l=linux-kernel&m=159194369128024&w=2 ?

I guess it does, yes.

> 
> If so, then
> 
>     Reported-by: kernel test robot <lkp@intel.com>
> 
> should be added to the patch description.
> 
> Ideally, compilation on x86_64 should have thrown the same warning,
> but it didn't. Why would the x86_64 build behave differently than
> ppc64 or i386?

I think it depends whether you have selected CONFIG_BLOCK or not.
In my embedded config, CONFIG_BLOCK isn't selected.

When CONFIG_BLOCK is selected, there is the following inclusion chain:

   CC      net/sunrpc/svcsock.o
In file included from ./include/linux/highmem.h:12:0,
                  from ./include/linux/pagemap.h:11,
                  from ./include/linux/blkdev.h:16,
                  from ./include/linux/blk-cgroup.h:23,
                  from ./include/linux/writeback.h:14,
                  from ./include/linux/memcontrol.h:22,
                  from ./include/net/sock.h:53,
                  from ./include/net/inet_sock.h:22,
                  from ./include/linux/udp.h:16,
                  from net/sunrpc/svcsock.c:31:
./arch/powerpc/include/asm/cacheflush.h:26:2: warning: #warning Coucous 
[-Wcpp]
  #warning test

But linux/blkdev.h includes linux/pagemap.h only when CONFIG_BLOCK is 
defined.

> 
> 
>> net/sunrpc/svcsock.c | 1 +
>> 1 file changed, 1 insertion(+)
>>
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index 5c4ec9386f81..d9e99cb09aab 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -45,6 +45,7 @@
>> #include <net/tcp_states.h>
>> #include <linux/uaccess.h>
>> #include <asm/ioctls.h>
>> +#include <asm/cacheflush.h>
> 
> Nit: Let's include <linux/highmem.h> in net/sunrpc/svcsock.h instead
> of <asm/cacheflush.h> directly.

Ok, I'll post v2.

> 
> 
>> #include <linux/sunrpc/types.h>
>> #include <linux/sunrpc/clnt.h>
>> -- 
>> 2.25.0
>>
> 
> --
> Chuck Lever
> 
> 
> 

Christophe
