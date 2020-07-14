Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A410C21E655
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 05:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbgGNDc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 23:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbgGNDc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 23:32:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31829C061755;
        Mon, 13 Jul 2020 20:32:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g67so6979613pgc.8;
        Mon, 13 Jul 2020 20:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vp2v7K/jVQL/hTXnKmTvc6QUZyaIGxTNQsGNS514dBY=;
        b=EhaRIst/9s8/73496IxrX3ukNwxDGYHYNp7A8n9b7Wn85bUFYu4mDclfBE+bx38tRb
         EVSRrwDMBi4h1E5SN9hRGHRgFUXbA8F3/wnzUfhN1Djh9WDw4QnRwHyWR6AovTlKyzvJ
         Xq88m9aJl+qQCwu7xVQcT5wMI/M5uOohJaoeiYMkVLPOuuCDgq3ZmTL02hnnZ06MbyJO
         I+fHaJbFOUXN5usf3ckirjeB170OYtdvZFTV3RsStmsRC6d9qx9yhZgT9PhVeXoyyB3I
         IODf/aE24JYz5jBfsGSToxm9+BJASaWMdDzKRYIeAzy7yF8RsxYUPhLQOxATtV5VZjnQ
         uceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vp2v7K/jVQL/hTXnKmTvc6QUZyaIGxTNQsGNS514dBY=;
        b=Lbraf8dAwIezIStozFsefPOjU7XkxDB/DqeA+fnbFW5SpdC/UqYuHaxolIUI940bZJ
         55blX7b5UPPzqPo7cz9S1jSZ2KJg9xaYxYSgOqfHvjBRRTRXh7oXtGsonv0wO7UU8QMj
         uGMgKbXBEmiqdDcsWhfGjFITO23KLaeTbWbXOQXAhRLPBK43n0Zd2iMEnyxjf7GlPu3g
         ixz6NA/udN1S++uYboAmIyStjXCwXoAraKnQZLIyVNRR6ebOVJoEk8/+6kvMGx9CZPPA
         GTulLp8jS9My+o4nI7MKulbJL/HPtqyWQmUV1VBTSqQ7gZixoslZ9VKCeBgrUA/p/PUe
         6ERg==
X-Gm-Message-State: AOAM532/Q5bx7AoOwGFhCimoFuApYqJ3Gs3P4Q2182bUhnLtT8WqVLIr
        +JhpUr0F2nhVKmm29LkLeDySOWg6
X-Google-Smtp-Source: ABdhPJz4ILMyUxmgCof18nPJDV+MwbkqgBGtucF52k2b5Sg2NtCHQxbLc+W+8ruVuJPt9JJG5vWRuA==
X-Received: by 2002:a62:788d:: with SMTP id t135mr2369420pfc.315.1594697545371;
        Mon, 13 Jul 2020 20:32:25 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c1sm852591pje.9.2020.07.13.20.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jul 2020 20:32:24 -0700 (PDT)
Subject: Re: [PATCH] tipc: Don't using smp_processor_id() in preemptible code
To:     qiang.zhang@windriver.com, jmaloy@redhat.com,
        ying.xue@windriver.com, davem@davemloft.net, kuba@kernel.org,
        tuong.t.lien@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
References: <20200714015341.27446-1-qiang.zhang@windriver.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5cdd5051-7c7f-6686-88bd-4061f529c064@gmail.com>
Date:   Mon, 13 Jul 2020 20:32:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200714015341.27446-1-qiang.zhang@windriver.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/13/20 6:53 PM, qiang.zhang@windriver.com wrote:
> From: Zhang Qiang <qiang.zhang@windriver.com>
> 
> CPU: 0 PID: 6801 Comm: syz-executor201 Not tainted 5.8.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine,
> BIOS Google 01/01/2011
>
> Reported-by: syzbot+263f8c0d007dc09b2dda@syzkaller.appspotmail.com
> Signed-off-by: Zhang Qiang <qiang.zhang@windriver.com>
> ---
>  net/tipc/crypto.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
> index 8c47ded2edb6..520af0afe1b3 100644
> --- a/net/tipc/crypto.c
> +++ b/net/tipc/crypto.c
> @@ -399,9 +399,10 @@ static void tipc_aead_users_set(struct tipc_aead __rcu *aead, int val)
>   */
>  static struct crypto_aead *tipc_aead_tfm_next(struct tipc_aead *aead)
>  {
> -	struct tipc_tfm **tfm_entry = this_cpu_ptr(aead->tfm_entry);
> +	struct tipc_tfm **tfm_entry = get_cpu_ptr(aead->tfm_entry);
>  
>  	*tfm_entry = list_next_entry(*tfm_entry, list);
> +	put_cpu_ptr(tfm_entry);
>  	return (*tfm_entry)->tfm;
>  }
>  
> 

This seems to hide a real bug.

Presumably callers of this function should have disable preemption, and maybe interrupts as well.

In any case, a Fixes: tag would be welcomed.
