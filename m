Return-Path: <netdev+bounces-12223-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AEC8736C97
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 15:00:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DABCD281283
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 13:00:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B9EE154B5;
	Tue, 20 Jun 2023 13:00:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBA22F5B
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 13:00:52 +0000 (UTC)
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66702170A;
	Tue, 20 Jun 2023 06:00:36 -0700 (PDT)
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-3f99aa36d18so6098345e9.1;
        Tue, 20 Jun 2023 06:00:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687266035; x=1689858035;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X93F7b0wOWdtuJBRHnqORIf5mXHGdp4ICFY23Klr0r0=;
        b=OqqDccxaNYK5K3d98pfgNW7/Ll1qR4eLEoPTGluvID+UPYyEF74c6N2P8F8xOTTCQT
         2YiPn45rdos8PQBzoE8dmEBTNIaijq3QGDjpGmwO3DmEw/IsVnirmNEj444sCrea3R64
         bvwmuUNkUmUgU5UVdSViqcdUv1hYo1nUyt5a7d+cNT2I3ATFWe19srg/bvgWG3CT923h
         dFbMAjVKUC0RMrrrjDNZ5lvoCWokJz8yx1S5sfBGAilIRk5B4K1W+/cnkr4jceaWTRvS
         gtXQiIJ2RVLs5I+F8Heqcx4oL+OmnQ1qBUnNuvhZo3MjqUXkfAdKu26ywf3tiW99YEvv
         FwXg==
X-Gm-Message-State: AC+VfDzRQYpLGuaCZHEAio7lqYmhtsyT7Z0+1q/cmWQmQx8X5vEbhMCv
	6Gnzl+XJ1I0TD4dnfTo/anA=
X-Google-Smtp-Source: ACHHUZ4fMadoVOeylQzjAgw+8ckeVgibkoIHqT/D3sxLYyMEY5mGEhxW4ZiDHDRruH9UX+wLysw2Mg==
X-Received: by 2002:a1c:ed17:0:b0:3f5:f543:d81f with SMTP id l23-20020a1ced17000000b003f5f543d81fmr13305521wmh.3.1687266034561;
        Tue, 20 Jun 2023 06:00:34 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id z8-20020a05600c220800b003f9b12b1598sm5339723wml.22.2023.06.20.06.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 06:00:34 -0700 (PDT)
Message-ID: <028fd6f1-6fc2-6e8d-3de0-71c2b8f6b754@grimberg.me>
Date: Tue, 20 Jun 2023 16:00:31 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net-next v2 10/17] nvme: Use sendmsg(MSG_SPLICE_PAGES)
 rather then sendpage
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
To: David Howells <dhowells@redhat.com>,
 Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: netdev@vger.kernel.org, Alexander Duyck <alexander.duyck@gmail.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 David Ahern <dsahern@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
 Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>,
 Chaitanya Kulkarni <kch@nvidia.com>, linux-nvme@lists.infradead.org
References: <648f353c55ce8_33cfbc29413@willemb.c.googlers.com.notmuch>
 <20230617121146.716077-1-dhowells@redhat.com>
 <20230617121146.716077-11-dhowells@redhat.com>
 <755077.1687109321@warthog.procyon.org.uk>
 <55e7058b-07d0-3619-3481-2d70e95875ea@grimberg.me>
In-Reply-To: <55e7058b-07d0-3619-3481-2d70e95875ea@grimberg.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


>>>      struct bio_vec bvec;
>>>      struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES | ... };
>>>
>>>      ..
>>>
>>>      bvec_set_virt
>>>      iov_iter_bvec
>>>      sock_sendmsg
>>>
>>> is a frequent pattern. Does it make sense to define a wrapper? Same 
>>> for bvec_set_page.
>>
>> I dunno.  I'm trying to move towards aggregating multiple pages in a bvec
>> before calling sendmsg if possible rather than doing it one page at a 
>> time,
>> but it's easier and more obvious in some places than others.
> 
> That would be great to do, but nvme needs to calculate a data digest
> and doing that in a separate scan of the payload is not very cache
> friendly...
> 
> There is also the fact that the payload may be sent in portions 
> asynchronously driven by how the controller wants to accept them,
> so there is some complexity there.
> 
> But worth looking at for sure.
> 
> The patch looks good to me, taking it to run some tests
> (from sendpage-3-frag branch in your kernel.org tree correct?)
> 
> For now, you can add:
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

Patches seem to hold up.
Tested-by: Sagi Grimberg <sagi@grimberg.me>

However if possible, can you please split nvme/host and nvme/target
changes? We try to separate host side and target side changes in the
same patch.

