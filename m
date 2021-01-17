Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 514602F9379
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 16:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729650AbhAQPTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 10:19:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbhAQPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 10:16:28 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CADC061573
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 07:15:47 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id e17so491018qto.3
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 07:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cd2NPHUGFrnIHhojsmV7SDuqgJ3QRJdhDoLac8RGOzQ=;
        b=r+L8k9vUP89jeewXRDIJDwx8eTXs5lUjh3rpjKTWpafAvLE+pm/IiufyjQBEwfR0RX
         fS5ERbPk7KqMLF07ov9FgQma4adeFfe56gej6U5cWKU+WDvvUM+8RvC+VB35oIXXP/gv
         oj4wMecEO8QhmOw3fIjZ6PEMO1JHfmJmcfhZIn1E0wYPaTt0MtcIQUz3Rqza2ygVhkN3
         CvI1wIDdz5PsFJzRFcvqKJE7agV8cQM805mjo2aH4kzx80RikC4yjocnGF6RUxIP905a
         Wz1UBhEdeskYpH0MozqY4HG9k2mXS6HEqrQI/hL9EXXdsprxypFhxFZbfJPakkW3aey3
         hMCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cd2NPHUGFrnIHhojsmV7SDuqgJ3QRJdhDoLac8RGOzQ=;
        b=DZN2e3+NQwTno8Pj0MP+czF9FSw/ASwgKURixbLlK80eYNKfOTqMrgJx6pjEhfTOFq
         cRCaLgOTlGjjlo+dkvNHsrPexG6irkdbVzZShzPoc2LtJNJzgL5obMgyIYLsRuXL86A5
         kQoraq2Mbl46LdufCUVnudqITv17xI/bvRyhG4pDiK9TKLU5n/6RjIsG1rw08uLLVAiz
         0NbiVmOAqWJNyxEEQR22NFY2z+739CNIvpFjUAV/yrWx2OpbzIhRR4zumsJeTJ7CdAiB
         i/rzo6UgO17w/JSQiYo6uPjz2qF4TVf5Etu4seZqzuhPygTVr4Na2eF5X22Z2sbHVS5I
         gVNg==
X-Gm-Message-State: AOAM532D+60nOX+0eItjD0/8gPDM8eL54vl9ZWmITqOawABlkAzFSpsA
        JX7cxzKhpUqAE1nxP5lzJWePcA==
X-Google-Smtp-Source: ABdhPJy68LaDC9s/Jnr6sQfmLrTRJUIP7xmEZAsxlvtYWO9tuN8EVz3QkiGkmuPDtpDrMG/a37Wcsw==
X-Received: by 2002:aed:29c2:: with SMTP id o60mr19326842qtd.253.1610896547053;
        Sun, 17 Jan 2021 07:15:47 -0800 (PST)
Received: from [192.168.2.48] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id d3sm9130122qka.36.2021.01.17.07.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jan 2021 07:15:46 -0800 (PST)
Subject: Re: [Patch net-next] net_sched: fix RTNL deadlock again caused by
 request_module()
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Cong Wang <cong.wang@bytedance.com>,
        syzbot+82752bc5331601cf4899@syzkaller.appspotmail.com,
        syzbot+b3b63b6bff456bd95294@syzkaller.appspotmail.com,
        syzbot+ba67b12b1ca729912834@syzkaller.appspotmail.com,
        Jiri Pirko <jiri@resnulli.us>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Vlad Buslov <vlad@buslov.dev>,
        Briana Oursler <briana.oursler@gmail.com>
References: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <acba35f6-2e29-903f-6eb8-a50dde25a147@mojatatu.com>
Date:   Sun, 17 Jan 2021 10:15:45 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210117005657.14810-1-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-16 7:56 p.m., Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> tcf_action_init_1() loads tc action modules automatically with
> request_module() after parsing the tc action names, and it drops RTNL
> lock and re-holds it before and after request_module(). This causes a
> lot of troubles, as discovered by syzbot, because we can be in the
> middle of batch initializations when we create an array of tc actions.
> 
> One of the problem is deadlock:
> 
> CPU 0					CPU 1
> rtnl_lock();
> for (...) {
>    tcf_action_init_1();
>      -> rtnl_unlock();
>      -> request_module();
> 				rtnl_lock();
> 				for (...) {
> 				  tcf_action_init_1();
> 				    -> tcf_idr_check_alloc();
> 				   // Insert one action into idr,
> 				   // but it is not committed until
> 				   // tcf_idr_insert_many(), then drop
> 				   // the RTNL lock in the _next_
> 				   // iteration
> 				   -> rtnl_unlock();
>      -> rtnl_lock();
>      -> a_o->init();
>        -> tcf_idr_check_alloc();
>        // Now waiting for the same index
>        // to be committed
> 				    -> request_module();
> 				    -> rtnl_lock()
> 				    // Now waiting for RTNL lock
> 				}
> 				rtnl_unlock();
> }
> rtnl_unlock();
> 
> This is not easy to solve, we can move the request_module() before
> this loop and pre-load all the modules we need for this netlink
> message and then do the rest initializations. So the loop breaks down
> to two now:
> 
>          for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
>                  struct tc_action_ops *a_o;
> 
>                  a_o = tc_action_load_ops(name, tb[i]...);
>                  ops[i - 1] = a_o;
>          }
> 
>          for (i = 1; i <= TCA_ACT_MAX_PRIO && tb[i]; i++) {
>                  act = tcf_action_init_1(ops[i - 1]...);
>          }
> 
> Although this looks serious, it only has been reported by syzbot, so it
> seems hard to trigger this by humans. And given the size of this patch,
> I'd suggest to make it to net-next and not to backport to stable.
> 
> This patch has been tested by syzbot and tested with tdc.py by me.
> 

LGTM.
Initially i was worried about performance impact but i found nothing
observable. We need to add a tdc test for batch (I can share how i did
batch testing at next meet).

Tested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
