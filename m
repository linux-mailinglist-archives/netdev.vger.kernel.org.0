Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE61A28DDB6
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgJNJc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:32:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJNJcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:32:50 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3F7C061755
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 02:32:48 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h24so3827010ejg.9
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 02:32:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=2Q2EXfY9q/OGGKRqeKKhw4ADQDGAvZJdTCK/YEvIMm4=;
        b=OT4R4azZBe83H2jAFxtXzBAZ+lZSdmcLVCr2JZ/C592Oath74URYOWe8A/1jNOG8Kh
         7Zr/5B9kixpwPUt31hr000uny9DfqH/D52Q4ddESsUWurzzDPOOSrjGerZySJtHeKdRv
         IbzWx9790xp3fX2rE8MGogzVVRQ88EQaClvuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=2Q2EXfY9q/OGGKRqeKKhw4ADQDGAvZJdTCK/YEvIMm4=;
        b=cvYsA6N6eI4lZ7b0sxz4q6+KvosyGjtfy/PWvx64F38vOV6XZSrHFAL4xunHFtYkDb
         /gcrtKPz54LDK+n9S1t2ImQSfaitVQs5VXFW8/SI4UKBAcbHOV2CDQAzn+iN2sTKD7de
         PiKVlQ98xOMDNo4KmY+Azf6XKqIn9VbxMtb3VNYAiViFGQlW7XY5JjvZffaKyocrIrt3
         0MXD8llPQQiqeO7rkRmj7ticFpmFKcw9xSnLFR7ZmvasJKsWJCbkX5u8lLmEGSZPk89B
         uImHgGijTIwf+NqT/Xn47WnzhmR2MTkYA4M4eRwgsiooCiSsFSAdFp4FKOG4VP8BCnDG
         43mg==
X-Gm-Message-State: AOAM532RHKViNfIA4NXF7qslUy1yrlYrsPTmwLruJrBAY0GCtsvG/q1Z
        5Y9y3HdVYuOS+0H8GMxPyZYD5Q==
X-Google-Smtp-Source: ABdhPJxjVAEFb20MNniWGcu/vedUiKayXCpuy0FwmpcpSpxWvQ7TYpYLJ8QYNDaxIR5qKoyrbGtUQQ==
X-Received: by 2002:a17:906:c08f:: with SMTP id f15mr4220755ejz.97.1602667967489;
        Wed, 14 Oct 2020 02:32:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a10sm1370276ejs.11.2020.10.14.02.32.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 02:32:46 -0700 (PDT)
References: <20201012170952.60750-1-alex.dewar90@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     Alex Dewar <alex.dewar90@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
In-reply-to: <20201012170952.60750-1-alex.dewar90@gmail.com>
Date:   Wed, 14 Oct 2020 11:32:45 +0200
Message-ID: <877drtqhj6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 07:09 PM CEST, Alex Dewar wrote:
> If bpf_prog_inc_not_zero() fails for skb_parser, then bpf_prog_put() is
> called unconditionally on skb_verdict, even though it may be NULL. Fix
> and tidy up error path.
>
> Addresses-Coverity-ID: 1497799: Null pointer dereferences (FORWARD_NULL)
> Fixes: 743df8b7749f ("bpf, sockmap: Check skb_verdict and skb_parser programs explicitly")
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>
> ---

Note to maintainers: the issue exists only in bpf-next where we have:

  https://lore.kernel.org/bpf/160239294756.8495.5796595770890272219.stgit@john-Precision-5820-Tower/

The patch also looks like it is supposed to be applied on top of the above.
