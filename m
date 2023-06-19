Return-Path: <netdev+bounces-11851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EF7734D90
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:25:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2EA6A1C20951
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 08:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3E6879C1;
	Mon, 19 Jun 2023 08:25:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E727C5393
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 08:25:42 +0000 (UTC)
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1ACF2;
	Mon, 19 Jun 2023 01:25:39 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4f845ca2d92so708317e87.1;
        Mon, 19 Jun 2023 01:25:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687163138; x=1689755138;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iX4CLwxuTuO4frE1ZkNfG2gJ9+rD4aADOYrpxzsHz/k=;
        b=EdQ9pICYHyXo74TlqjHv6RzHvb+U91P3Q5hJulSJEP12ygw8JjIUNKATCLJ9a41fGG
         AD3aKwfxaBZotTgarEYaB/azS0fe1EZqV5oSWENa3LJpfhxedF7hk575jInBu9EbDp2C
         A8DhRZTKpsIjH88m3AYypvMvsqp2kPPNXxjev4ftczENBorzfQH7V43yfqoXy3bPZt41
         Li2QPjil33QUSR2mRiNm1JJUsgekQx9vqvvVzlHS+23V8pF0be/5f3uGGU6GBxnvSBpa
         J3F34eVZufEzxEyw1e4vxWyRzTyCdNR0T6axuX3tp58zgVxoBYd84SrASRqaPd89KaHX
         f4sQ==
X-Gm-Message-State: AC+VfDw408D4c/ive4L2n6kbxWCZe15zwFMfJRsp+RZzsfojHoGD9xja
	7vgPPyie1MMpenYuMLzNeq0=
X-Google-Smtp-Source: ACHHUZ44wI+K691se6TLRFSf74cGJkGpEfK4OPsyBLOS0ZdfsAOZc8G8mvYNQR0Th0SgRlbHmYSxDw==
X-Received: by 2002:a05:6512:25a:b0:4f7:6a87:f16f with SMTP id b26-20020a056512025a00b004f76a87f16fmr3558941lfo.4.1687163137715;
        Mon, 19 Jun 2023 01:25:37 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id f13-20020a7bcd0d000000b003f7ba52eeccsm9853963wmj.7.2023.06.19.01.25.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 01:25:37 -0700 (PDT)
Message-ID: <55e7058b-07d0-3619-3481-2d70e95875ea@grimberg.me>
Date: Mon, 19 Jun 2023 11:25:34 +0300
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
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <755077.1687109321@warthog.procyon.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


>>      struct bio_vec bvec;
>>      struct msghdr msg = { .msg_flags = MSG_SPLICE_PAGES | ... };
>>
>>      ..
>>
>>      bvec_set_virt
>>      iov_iter_bvec
>>      sock_sendmsg
>>
>> is a frequent pattern. Does it make sense to define a wrapper? Same for bvec_set_page.
> 
> I dunno.  I'm trying to move towards aggregating multiple pages in a bvec
> before calling sendmsg if possible rather than doing it one page at a time,
> but it's easier and more obvious in some places than others.

That would be great to do, but nvme needs to calculate a data digest
and doing that in a separate scan of the payload is not very cache
friendly...

There is also the fact that the payload may be sent in portions 
asynchronously driven by how the controller wants to accept them,
so there is some complexity there.

But worth looking at for sure.

The patch looks good to me, taking it to run some tests
(from sendpage-3-frag branch in your kernel.org tree correct?)

For now, you can add:
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

