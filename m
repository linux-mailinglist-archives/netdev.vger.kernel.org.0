Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AADE59636C
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 22:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236831AbiHPUBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 16:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbiHPUBP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 16:01:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16B687E82A
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 13:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660680074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6xCqrELniyhJBUUBRNURlNrorTl407Wr59qxH3GJIvA=;
        b=KowLt9sVJkGJ/667uzuMME8DAiJSf0eDde1jzcGaQ89HEwmSpZ2C4V9BN8U+6PSgXTkTkQ
        eif7S7JyOxj+s48rMJi7GtZs8LUl2e9g6ePsvNK2MVSONUpvizF14FXKalwzFN1ngUYQ7v
        e57o1aQDijTCP+i5zDMNEkOeI2RDeZE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-132-IxGidGdfP4Wypnus5uUmIw-1; Tue, 16 Aug 2022 16:01:09 -0400
X-MC-Unique: IxGidGdfP4Wypnus5uUmIw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C90A23C0D84F;
        Tue, 16 Aug 2022 20:01:08 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AA680140EBE3;
        Tue, 16 Aug 2022 20:01:06 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220816112147.3aa8d35b@kernel.org>
References: <20220816112147.3aa8d35b@kernel.org> <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk> <20220816103452.479281-1-yin31149@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     dhowells@redhat.com, Hawkins Jiawei <yin31149@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org, bpf@vger.kernel.org
Subject: Re: [PATCH] net: Fix suspicious RCU usage in bpf_sk_reuseport_detach()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <592635.1660680066.1@warthog.procyon.org.uk>
Date:   Tue, 16 Aug 2022 21:01:06 +0100
Message-ID: <592636.1660680066@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

> > +__rcu_dereference_sk_user_data_with_flags_check(const struct sock *sk,
> 
> This name is insanely long now.

I know.  47 chars.  Do you have something you'd prefer?  Maybe
get_sk_user_data_checked()?

It's a shame C doesn't allow default arguments.

David

