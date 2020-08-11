Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0322422BE
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 01:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgHKXKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 19:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbgHKXKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 19:10:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6D9C06174A;
        Tue, 11 Aug 2020 16:10:31 -0700 (PDT)
Received: from localhost (50-47-103-195.evrt.wa.frontiernet.net [50.47.103.195])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 76C30128B99C3;
        Tue, 11 Aug 2020 15:53:44 -0700 (PDT)
Date:   Tue, 11 Aug 2020 16:10:29 -0700 (PDT)
Message-Id: <20200811.161029.1720063119338694115.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     linmiaohe@huawei.com, kuba@kernel.org, edumazet@google.com,
        kafai@fb.com, daniel@iogearbox.net, jakub@cloudflare.com,
        keescook@chromium.org, zhang.lin16@zte.com.cn,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: Fix potential memory leak in proto_register()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpW6R5=J0VPwNimOLJRrhwUh--aknpbksizzs0o6Q-gxFA@mail.gmail.com>
References: <20200810121658.54657-1-linmiaohe@huawei.com>
        <CAM_iQpW6R5=J0VPwNimOLJRrhwUh--aknpbksizzs0o6Q-gxFA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Aug 2020 15:53:44 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Tue, 11 Aug 2020 16:02:51 -0700

>> @@ -3406,6 +3406,16 @@ static void sock_inuse_add(struct net *net, int val)
>>  }
>>  #endif
>>
>> +static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot)
>> +{
>> +       if (!twsk_prot)
>> +               return;
>> +       kfree(twsk_prot->twsk_slab_name);
>> +       twsk_prot->twsk_slab_name = NULL;
>> +       kmem_cache_destroy(twsk_prot->twsk_slab);
> 
> Hmm, are you sure you can free the kmem cache name before
> kmem_cache_destroy()? To me, it seems kmem_cache_destroy()
> frees the name via slab_kmem_cache_release() via kfree_const().
> With your patch, we have a double-free on the name?
> 
> Or am I missing anything?

Yep, there is a double free here.

Please fix this.
