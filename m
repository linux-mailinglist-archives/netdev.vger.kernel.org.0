Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D102574894
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 11:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238063AbiGNJWu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 05:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236997AbiGNJWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 05:22:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B5D145F64
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657790397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WNIVg2JVkK0ew9e74cH1QcUxXyxjlZdS8CtGDjX0fkQ=;
        b=SGm/zIvQmLH6jlc67SCSTNKXgrM6JbLkoTPIF07136R1/Wa7xrk+Ud9lD4YjReX+kbzO3Q
        g9oPTPRu2WC8ap7DOwCVYtpn/ZU4RB5Fcz9VKwHRWYtpFv8OQgqPVLgqxa9Mi/EDQzCEQa
        eRcvmEtXEPm5MgvcArK9kYHQD9euWjU=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-JY_q6dADOT-bVg6nhEO9fw-1; Thu, 14 Jul 2022 05:19:55 -0400
X-MC-Unique: JY_q6dADOT-bVg6nhEO9fw-1
Received: by mail-wm1-f71.google.com with SMTP id t25-20020a7bc3d9000000b003a2ea772bd2so503413wmj.2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 02:19:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WNIVg2JVkK0ew9e74cH1QcUxXyxjlZdS8CtGDjX0fkQ=;
        b=jIzaREradxrOL6DA4JN5FCEolLBQHbkK1gHJxz8NgYhHEsgj1APmgaqx4dsNytdlNf
         LcLhiT2oc+i+dI4mVIT/DigkaaKLlefmV04qd1nqtxm8J7f9OzNaSCA4afJjVn2SScPI
         e0DaPMo/yfanTJCR9Rl1fa0eNhzSqwA09M3ZcdH5vGB7VFSumu5jJ5jsPxOolkQ8l9cA
         DT3iaAnngDdNxkybGkDD45juKqotI26U6ayGG5rC/u5WwdFVWs8WbFcnEsyVpkhoD7SE
         fJ59evXpZFFueJS+kXgW8/sdtTxPduT2EU64JrVNlZN2RgJGxDE39YJIIN6shljYsO5z
         1xoA==
X-Gm-Message-State: AJIora97g5mSoV5eGxTwHRxOZO7ahzbWjMrNHO8KMnANKLe8hVLONIz9
        A5yveDko8/IZYIZjhRKmieP1Ct5oxj5fQlbhBhbL8RJ91uZtZxMR6CU59UpkE3GMNKBxACc2BR+
        l4xH2GbZZ9iO+bIDP
X-Received: by 2002:a5d:6e8d:0:b0:21d:7adc:7102 with SMTP id k13-20020a5d6e8d000000b0021d7adc7102mr7178472wrz.9.1657790394424;
        Thu, 14 Jul 2022 02:19:54 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vq0RQN4DrviwKnk25X1P7YpzxAB28bAaomjCI4n8EzB+y8nyeK6rqNMUFkNtGDb8i5kqCdhg==
X-Received: by 2002:a5d:6e8d:0:b0:21d:7adc:7102 with SMTP id k13-20020a5d6e8d000000b0021d7adc7102mr7178459wrz.9.1657790394210;
        Thu, 14 Jul 2022 02:19:54 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-238.dyn.eolo.it. [146.241.97.238])
        by smtp.gmail.com with ESMTPSA id z3-20020a5d4c83000000b0021baf5e590dsm954470wrs.71.2022.07.14.02.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 02:19:53 -0700 (PDT)
Message-ID: <e2d28352a6c00db7c3b31d0b9aeca3ee5b196247.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/3] selftests/net: Add
 sk_bind_sendto_listen test
From:   Paolo Abeni <pabeni@redhat.com>
To:     Joanne Koong <joannelkoong@gmail.com>, netdev@vger.kernel.org
Cc:     edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        davem@davemloft.net
Date:   Thu, 14 Jul 2022 11:19:52 +0200
In-Reply-To: <20220712235310.1935121-4-joannelkoong@gmail.com>
References: <20220712235310.1935121-1-joannelkoong@gmail.com>
         <20220712235310.1935121-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-07-12 at 16:53 -0700, Joanne Koong wrote:
> This patch adds a new test called sk_bind_sendto_listen.
> 
> This test exercises the path where a socket's rcv saddr changes after it
> has been added to the binding tables, and then a listen() on the socket
> is invoked. The listen() should succeed.
> 
> This test is copied over from one of syzbot's tests:
> https://syzkaller.appspot.com/x/repro.c?x=1673a38df00000
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  tools/testing/selftests/net/.gitignore        |  1 +
>  tools/testing/selftests/net/Makefile          |  1 +
>  .../selftests/net/sk_bind_sendto_listen.c     | 80 +++++++++++++++++++
>  3 files changed, 82 insertions(+)
>  create mode 100644 tools/testing/selftests/net/sk_bind_sendto_listen.c
> 
> diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
> index 5b1adf6e29ae..5fd74a1162cc 100644
> --- a/tools/testing/selftests/net/.gitignore
> +++ b/tools/testing/selftests/net/.gitignore
> @@ -39,3 +39,4 @@ toeplitz
>  cmsg_sender
>  unix_connect
>  bind_bhash
> +sk_bind_sendto_listen
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index e678fc3030a2..ffcc472d50d5 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -61,6 +61,7 @@ TEST_GEN_FILES += cmsg_sender
>  TEST_GEN_FILES += stress_reuseport_listen
>  TEST_PROGS += test_vxlan_vnifiltering.sh
>  TEST_GEN_FILES += bind_bhash
> +TEST_GEN_FILES += sk_bind_sendto_listen

It looks like this is never invoked by the self-tests ?!? you should
likely update bind_bhash.sh to run the new program.

Thanks!

Paolo

