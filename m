Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2791F596480
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbiHPVRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237566AbiHPVRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:17:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C0B8B997
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660684616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2iqj6YUSsuItIPg1WhM2vpcdPov5sWXfn7fAfkdN2WE=;
        b=XqXG4wc8LdKYZwL4TIySo+mcx4p3wKH1F8/xZ+wPZHBHEqHuJGREgl4w+TXCxHfvtZouZC
        ExHT3gC7cKX0QEqRXOmWpVdU/ZD8nCXf57Dl1lRBDVg/AwFFNDJwrTiHuU4MUdaA7w+7e9
        x/OnumOSFoLstlJhmPRpqvkxcWF6a1c=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-111-60_09m4xMDqeYoZnVse8mQ-1; Tue, 16 Aug 2022 17:16:50 -0400
X-MC-Unique: 60_09m4xMDqeYoZnVse8mQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A80E61C13945;
        Tue, 16 Aug 2022 21:16:48 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.72])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B088518ECC;
        Tue, 16 Aug 2022 21:16:46 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
From:   David Howells <dhowells@redhat.com>
In-Reply-To: <20220816103452.479281-1-yin31149@gmail.com>
References: <20220816103452.479281-1-yin31149@gmail.com> <166064248071.3502205.10036394558814861778.stgit@warthog.procyon.org.uk>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     dhowells@redhat.com, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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
Content-ID: <804152.1660684606.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date:   Tue, 16 Aug 2022 22:16:46 +0100
Message-ID: <804153.1660684606@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hawkins Jiawei <yin31149@gmail.com> wrote:

> +__rcu_dereference_sk_user_data_with_flags_check(const struct sock *sk,
> +						uintptr_t flags, bool condition)

That doesn't work.  RCU_LOCKDEP_WARN() relies on anything passing on a
condition down to it to be a macro so that it can vanish the 'condition'
argument without causing an undefined symbol for 'lockdep_is_held' if lock=
dep
is disabled:

x86_64-linux-gnu-ld: kernel/bpf/reuseport_array.o: in function `bpf_sk_reu=
seport_detach':
/data/fs/linux-fs/build3/../kernel/bpf/reuseport_array.c:28: undefined ref=
erence to `lockdep_is_held'

So either __rcu_dereference_sk_user_data_with_flags_check() has to be a ma=
cro,
or we need to go with something like the first version of my patch where I
don't pass the condition through.  Do you have a preference?

David

