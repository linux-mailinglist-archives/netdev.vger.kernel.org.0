Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80D268C58C
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 19:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjBFSR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 13:17:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjBFSR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 13:17:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 572831E1CF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 10:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675707404;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NWIEEv3YZ5R54vpTmaVoAU8vr6ac5knkqgOJ0PzPWBk=;
        b=Qjh1O2pvHIroAQqDznf7+KR9LcJjDym7nftCf4o1gL0At1xdvrfu9SMvZLG9iADthu3bCn
        mlf9xAcNJ/iS9DJ+V8VQg5jjFvFTJiD+3IAUQ6pbd9nerPyEy18WBAmQmJDWECAG/ftzYt
        FQuDItWXuSOhUQ0TYYvxWnpKkmVdIUo=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-98-crjiEZmJNUWNjR261ygVcg-1; Mon, 06 Feb 2023 13:16:43 -0500
X-MC-Unique: crjiEZmJNUWNjR261ygVcg-1
Received: by mail-qv1-f69.google.com with SMTP id lw11-20020a05621457cb00b005376b828c22so6179224qvb.6
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 10:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NWIEEv3YZ5R54vpTmaVoAU8vr6ac5knkqgOJ0PzPWBk=;
        b=Igc/KoHbOiDPcgk3cn2FhZstzwjNYST6wCOgqEYPWPQjHHNG6BbK22qe+bfblDyurC
         GNFeuEuanlo2DbMCqZFMPztDTC93Tfpmop08Yy/JZWP68dLnqFKIY7cUeYy6PdKHhWyK
         hRrDO5CbS7Wj9jWWnxJCmkDIQAVi0NUZP72IPN91/+GOD3PwlCLexwak6YprUjNDBHLc
         1OlmVzx3UHYOiWwId5Jt60fbIUoxfzW7+dRm2SrvOYAY7LQx4HT16PiEM7O+0ZNFZwdv
         GrN4UjwRHdrCMIAQGYI0RxcDH0fVMqhg4VgRe9LWhQQ4RciTgwCdInJwtjzuEZWxCEpI
         2EiA==
X-Gm-Message-State: AO0yUKVVutUM09M4H0RMOpbFxbN62EvyADmioO2FMdOZVbPzxlNNxvBz
        gXatui+3SqytMctUfTE9Ljbd/b17FH0BYfDiMNfDpz75cele9ZTzDq6QEgOO0FRpXwDpO6XY+qO
        xLE7BStCLw57wY/6U
X-Received: by 2002:ac8:4e8d:0:b0:3ba:1ace:8bae with SMTP id 13-20020ac84e8d000000b003ba1ace8baemr745898qtp.0.1675707402846;
        Mon, 06 Feb 2023 10:16:42 -0800 (PST)
X-Google-Smtp-Source: AK7set8ktL/qFjzheGFquSH5GqmnNK0MwEk4BermcWtnqDC/yCCLQKfKDccQL+D9sq0ii7BatNlacA==
X-Received: by 2002:ac8:4e8d:0:b0:3ba:1ace:8bae with SMTP id 13-20020ac84e8d000000b003ba1ace8baemr745857qtp.0.1675707402536;
        Mon, 06 Feb 2023 10:16:42 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id b15-20020ae9eb0f000000b007090cad77c1sm7906088qkg.3.2023.02.06.10.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 10:16:41 -0800 (PST)
Message-ID: <d31bd1b26b07bd316b0adea3aa897c4623268304.camel@redhat.com>
Subject: Re: [PATCH net-next 0/4] net: core: use a dedicated kmem_cache for
 skb head allocs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Alexander Duyck <alexanderduyck@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Date:   Mon, 06 Feb 2023 19:16:39 +0100
In-Reply-To: <20230202185801.4179599-1-edumazet@google.com>
References: <20230202185801.4179599-1-edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-02-02 at 18:57 +0000, Eric Dumazet wrote:
> Our profile data show that using kmalloc(non_const_size)/kfree(ptr)
> has a certain cost, because kfree(ptr) has to pull a 'struct page'
> in cpu caches.
>=20
> Using a dedicated kmem_cache for TCP skb->head allocations makes
> a difference, both in cpu cycles and memory savings.
>=20
> This kmem_cache could also be used for GRO skb allocations,
> this is left as a future exercise.
>=20
> Eric Dumazet (4):
>   net: add SKB_HEAD_ALIGN() helper
>   net: remove osize variable in __alloc_skb()
>   net: factorize code in kmalloc_reserve()
>   net: add dedicated kmem_cache for typical/small skb->head
>=20
>  include/linux/skbuff.h |  8 ++++
>  net/core/skbuff.c      | 95 +++++++++++++++++++++++++++---------------
>  2 files changed, 70 insertions(+), 33 deletions(-)

LGTM,

Acked-by: Paolo Abeni <pabeni@redhat.com>

Thanks!

Paolo

