Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D77192DEF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 17:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgCYQN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 12:13:56 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:46524 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCYQNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 12:13:55 -0400
Received: by mail-pg1-f193.google.com with SMTP id k191so1345276pgc.13;
        Wed, 25 Mar 2020 09:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UJoycXzncq++KEmoEraf9FwjqsaFOTyD4pmVFX86bs=;
        b=CbJa9fNUZr5nhJpO6iOqTWnVRkFWnvGFHEoJKM1CQL5adb6SFygnKr3AYrS4cug/qu
         3bVhlztD1yorcyIk4/aDWzdqRLRoGxGxBpMwAh0FTfNM/hfOCLnnyWVNTH+F+vkrU4ei
         3NXN0II/QWCC+98WNfrKieGHch8uvuU8bFcaz1vTIuBcLSc/bem0F+5J+whKEN3B7Il7
         nqc1GeP1zls63i6y6Wp+AwzPsOG4zLaIECnm8egUF8zddd4vsblNE07YMqrjPIDwvEsU
         XTqlbiqvWYH0eztRqsJHiX4LZxoqVxtq0+JLih/IFt8dHtu2najNJlnzdSPYrKCVxHj6
         t69Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UJoycXzncq++KEmoEraf9FwjqsaFOTyD4pmVFX86bs=;
        b=ZsG8Q8cFSPbueLPEXP112PJO50GdB4f9wtx5V+U9MjTRkPj867wMp3u5uyI4xsp/C3
         c6iO2fJWD2hlkBvROOPm/FpENaH4GW6mMmz9vzjWrST6T5L3Rh/J8NFWmDiik2d/Cluv
         VdrYETx9AZZJZ15SqZ9xUVuX9KYBdZ1mBeVkRoM9qM/LZ7jY0N4zdfwWhYaN0DDJaCd1
         JAUQH0f9r6q6As+JCz9mtVbIbNqkTASD+s0Jilh+KHV0oa4F36mOtw/Xz/2+vMyiHThr
         uLIwO7Vb1f+JQURWIKwGaqR99aIaMK6nkOBgKw1nESQb0IUSdT6SFkrfK9vqx9JNtWON
         7YKw==
X-Gm-Message-State: ANhLgQ2pgDm/SUqYoKUOwd9WEr4h2ltJneTaMK4HbycIX0RcOICswiWd
        WQBjvLzt4/WtNL+QTgoqBLGAhfZk
X-Google-Smtp-Source: ADFU+vtV4A/tWf85O4ChP2sgKJHiwTlMz2cMpRcl1ZKXYQ4S8+OpD6Cg9+XzLe5iZ2xf5uInEc0dRQ==
X-Received: by 2002:a63:a505:: with SMTP id n5mr3857737pgf.242.1585152833948;
        Wed, 25 Mar 2020 09:13:53 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id e7sm18924902pfj.97.2020.03.25.09.13.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Mar 2020 09:13:53 -0700 (PDT)
Subject: Re: [PATCH] ipv4: fix a RCU-list lock in fib_triestat_seq_show
To:     Qian Cai <cai@lca.pw>, davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200325155532.7238-1-cai@lca.pw>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5e2ed86a-23bc-d3e5-05ad-4e7ed147539c@gmail.com>
Date:   Wed, 25 Mar 2020 09:13:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200325155532.7238-1-cai@lca.pw>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/25/20 8:55 AM, Qian Cai wrote:
> fib_triestat_seq_show() calls hlist_for_each_entry_rcu(tb, head,
> tb_hlist) without rcu_read_lock() will trigger a warning,
> 
>  net/ipv4/fib_trie.c:2579 RCU-list traversed in non-reader section!!
> 
>  other info that might help us debug this:
> 
>  rcu_scheduler_active = 2, debug_locks = 1
>  1 lock held by proc01/115277:
>   #0: c0000014507acf00 (&p->lock){+.+.}-{3:3}, at: seq_read+0x58/0x670
> 
>  Call Trace:
>   dump_stack+0xf4/0x164 (unreliable)
>   lockdep_rcu_suspicious+0x140/0x164
>   fib_triestat_seq_show+0x750/0x880
>   seq_read+0x1a0/0x670
>   proc_reg_read+0x10c/0x1b0
>   __vfs_read+0x3c/0x70
>   vfs_read+0xac/0x170
>   ksys_read+0x7c/0x140
>   system_call+0x5c/0x68
> 
> Signed-off-by: Qian Cai <cai@lca.pw>
> ---
>  net/ipv4/fib_trie.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
> index ff0c24371e33..73fa37476f03 100644
> --- a/net/ipv4/fib_trie.c
> +++ b/net/ipv4/fib_trie.c
> @@ -2577,6 +2577,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
>  		   " %zd bytes, size of tnode: %zd bytes.\n",
>  		   LEAF_SIZE, TNODE_SIZE(0));
>  
> +	rcu_read_lock();
>  	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
>  		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
>  		struct fib_table *tb;
> @@ -2597,6 +2598,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
>  #endif
>  		}
>  	}
> +	rcu_read_unlock();
>  
>  	return 0;
>  }
> 

We probably want to be able to reschedule in the loop (adding a cond_resched() in net-next)

I would prefer :

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ff0c24371e3309b3068980f46d1ed743337d2a3e..4b98ffb27136d3b43f179d6b1b42fe84586acc06 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2581,6 +2581,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
                struct hlist_head *head = &net->ipv4.fib_table_hash[h];
                struct fib_table *tb;
 
+               rcu_read_lock();
                hlist_for_each_entry_rcu(tb, head, tb_hlist) {
                        struct trie *t = (struct trie *) tb->tb_data;
                        struct trie_stat stat;
@@ -2596,6 +2597,7 @@ static int fib_triestat_seq_show(struct seq_file *seq, void *v)
                        trie_show_usage(seq, t->stats);
 #endif
                }
+               rcu_read_unlock();
        }
 
        return 0;



