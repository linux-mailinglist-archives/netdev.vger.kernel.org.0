Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45388B0542
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 23:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728558AbfIKVgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 17:36:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34140 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfIKVgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 17:36:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id y135so189107wmc.1
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 14:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qjO0AZ2ADHNETbAyejtuyky5NidKdoE4pEo9fjKjxYU=;
        b=pbK+k4zifAzBQGjymSv8t8Il4OQPThry3kAuWfdJa0nMznWLl5PCwL7m7KCBOBkhv9
         FPSWfgLKoITimihM7wCwr7Osz6YFc7f3dNYcDqGUpVK5ujYxMYRjo/uEtrl8zx1ldsRn
         +JW+uAAjKybtJPoD6SOFi+GZhHkqz33yHqUbWOduMYkVY7ROdr04IC6Nhs9UujzLeKlU
         9LmyMizBqR4aSAt7ADVQinHUqAxWr08avuxY5B3wTaJN17kIeCHts90wgVNNyetITzOa
         b5B2klPtx+GvH0wtXDmUwPMKmB1xK1xFZAvIsaxJC8FqQZAlKlGtOtAQEtVXtndcbkrM
         1hmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qjO0AZ2ADHNETbAyejtuyky5NidKdoE4pEo9fjKjxYU=;
        b=rogik0XYQQTWfxNSUwMWtvGic17oPgwdkrhUb21qbczowi74lS/xKTApfNXq7Oqd0I
         wrKkEi6M0YRqErSbvCUai2UbSwXi+8MCJ+XlslB3lxZR/U4gGsjAjYcbtGg6oFNB8Mrh
         SdmjGGmHKCKhMwaAhV9hSDiisGERs6xQEeM7u6cbnLYNwu3wnUjuZGD+OT5GUWt8O8NT
         qqLRFSYdBTAITru+8m62TFdScMW3LAJkib9iK6zRk7cSIXsPFzU1O200S0KvZfRTpUL7
         k+xQXh5vKaCv8GHPENC/g02Tg3XNGJfmOMwwe4Hv6jrCy02LBI5+FMwINxeOX/vWtddu
         LYrg==
X-Gm-Message-State: APjAAAWF2As2TRLFI04sRIBqk7m8aUG413OuZU58mqEO/Sw9zqvN7jTz
        Fk9iyXIi8OQi6sfF5n8fcIg=
X-Google-Smtp-Source: APXvYqyYfgEFpqQ2IBQ7peB/d/Jmekzui7lKLyndMERQsfN3S7YH8xRmrh6hLZu5m+nNjf9kudX7Nw==
X-Received: by 2002:a05:600c:212:: with SMTP id 18mr5359907wmi.168.1568237765351;
        Wed, 11 Sep 2019 14:36:05 -0700 (PDT)
Received: from [172.21.45.101] ([88.214.186.169])
        by smtp.gmail.com with ESMTPSA id a7sm27282022wra.43.2019.09.11.14.36.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 14:36:04 -0700 (PDT)
Subject: Re: [Patch net] sch_sfb: fix a crash in sfb_destroy()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
References: <20190911183445.32547-1-xiyou.wangcong@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7b5b69a9-7ace-2d21-f187-7a81fb1dae5a@gmail.com>
Date:   Wed, 11 Sep 2019 23:36:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911183445.32547-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/11/19 8:34 PM, Cong Wang wrote:
> When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
> pointer which leads to a crash in sfb_destroy().
> 
> Linus suggested three solutions for this problem, the simplest fix
> is just moving the noop_qdisc assignment before tcf_block_get()
> so that qdisc_put() would become a nop.
> 
> Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
> Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/sched/sch_sfb.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
> index 1dff8506a715..db1c8eb521a2 100644
> --- a/net/sched/sch_sfb.c
> +++ b/net/sched/sch_sfb.c
> @@ -552,11 +552,11 @@ static int sfb_init(struct Qdisc *sch, struct nlattr *opt,
>  	struct sfb_sched_data *q = qdisc_priv(sch);
>  	int err;
>  
> +	q->qdisc = &noop_qdisc;
> +
>  	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
>  	if (err)
>  		return err;
> -
> -	q->qdisc = &noop_qdisc;
>  	return sfb_change(sch, opt, extack);
>  }
>  
> 

It seems a similar fix would be needed in net/sched/sch_dsmark.c ?

