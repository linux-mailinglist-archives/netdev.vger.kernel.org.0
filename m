Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA2124275F
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbgHLJVs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 12 Aug 2020 05:21:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3114 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726255AbgHLJVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Aug 2020 05:21:47 -0400
Received: from dggeme754-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id 182CEAA35F889125B018;
        Wed, 12 Aug 2020 17:21:37 +0800 (CST)
Received: from dggeme753-chm.china.huawei.com (10.3.19.99) by
 dggeme754-chm.china.huawei.com (10.3.19.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Wed, 12 Aug 2020 17:21:36 +0800
Received: from dggeme753-chm.china.huawei.com ([10.7.64.70]) by
 dggeme753-chm.china.huawei.com ([10.7.64.70]) with mapi id 15.01.1913.007;
 Wed, 12 Aug 2020 17:21:36 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     David Miller <davem@davemloft.net>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "zhang.lin16@zte.com.cn" <zhang.lin16@zte.com.cn>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: Fix potential memory leak in proto_register()
Thread-Topic: [PATCH] net: Fix potential memory leak in proto_register()
Thread-Index: AdZwUsoSFctrm9tgR62RlU4Cwvd7hw==
Date:   Wed, 12 Aug 2020 09:21:36 +0000
Message-ID: <a139c6e194974321822b4ef3d469aefe@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.252]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all:
David Miller <davem@davemloft.net> wrote:
>From: Cong Wang <xiyou.wangcong@gmail.com>
>Date: Tue, 11 Aug 2020 16:02:51 -0700
>
>>> @@ -3406,6 +3406,16 @@ static void sock_inuse_add(struct net *net, 
>>> int val)  }  #endif
>>>
>>> +static void tw_prot_cleanup(struct timewait_sock_ops *twsk_prot) {
>>> +       if (!twsk_prot)
>>> +               return;
>>> +       kfree(twsk_prot->twsk_slab_name);
>>> +       twsk_prot->twsk_slab_name = NULL;
>>> +       kmem_cache_destroy(twsk_prot->twsk_slab);
>> 
>> Hmm, are you sure you can free the kmem cache name before 
>> kmem_cache_destroy()? To me, it seems kmem_cache_destroy() frees the 
>> name via slab_kmem_cache_release() via kfree_const().
>> With your patch, we have a double-free on the name?
>> 
>> Or am I missing anything?
>
>Yep, there is a double free here.
>
>Please fix this.

Many thanks for both of you to point this issue out. But I'am not really understand, could you please explain it more?
As far as I can see, the double free path is:
1. kfree(twsk_prot->twsk_slab_name)
2. kmem_cache_destroy 
	--> shutdown_memcg_caches
		--> shutdown_cache
			--> slab_kmem_cache_release
				--> kfree_const(s->name)
But twsk_prot->twsk_slab_name is allocated from kasprintf via kmalloc_track_caller while twsk_prot->twsk_slab->name is allocated 
via kstrdup_const. So I think twsk_prot->twsk_slab_name and twsk_prot->twsk_slab->name point to different memory, and there is no double free.

Or am I missing anything?

By the way, req_prot_cleanup() do the same things, i.e. free the slab_name before involve kmem_cache_destroy(). If there is a double
free, so as here?

Thanks.

