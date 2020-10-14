Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B728DD40
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 11:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgJNJXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 05:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbgJNJXN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 05:23:13 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2329C0613D9
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 02:20:42 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id e22so3829348ejr.4
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 02:20:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=/WnbvhyGcptPPBaNZxdAo4mg51wxanwUK78khnzdGus=;
        b=wzFripj/9LraAMEmzYAkjL1sotjg/tzxIUOn+3rAhgYLrFGhBppxP58Fj8lJk3Gn6f
         QxLE5MOpTScSC67rQ7Y+wNjc6xZaYQ9QPsCqwz0rO1XIwgM+0wXdDQlLbNfLAo/aDtwN
         8hhmK9wr8/zE8x05W8XeZ6xBYiKnxtZ9qgrbM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=/WnbvhyGcptPPBaNZxdAo4mg51wxanwUK78khnzdGus=;
        b=KBeV8K9UeoB7cA7yRu95ZuhwFpzM2XhV0M0YfcpinhjNjNSj3ZT1nzXPAg39mjOMiy
         Dhu2qLVQXVm7iqV377T375H/PrL4kiv0KTn1uEIFE2B790ojK7KjGGYVRiDC4YKbQJ0O
         1jL+g237rjRBoxy+konUNUIbWXa+zcJ1+unxwgPv+T9/iR5e++eYNlQnYiOcguPS9F3W
         NI1Gym9bMTs8eTDm+VykOfXRWqov8k0o69bUmyzTqlk0HQDatQYs9KyZFUoCXZi0tMRH
         q1qkJ2nKsezYA2PulSqwgDhKn3aJkkOqTcABH+HA9soZpYTDblShVKyDoQr/fPTRpGXc
         m3Xw==
X-Gm-Message-State: AOAM533BMA+LDtvrAy3lQ01s6BMInfxs6oUtryxXRLpy6d6IkGRdDSqy
        KCcIwdy5h9XzDYfX7um3+Ocxnw==
X-Google-Smtp-Source: ABdhPJxUvxlmotUTKMITZb02Wylkh1sw157EQWmBLNMnqJxc/0hczSTt/IE/DTObQL8sz0hci2Atmg==
X-Received: by 2002:a17:906:c015:: with SMTP id e21mr4156437ejz.432.1602667241168;
        Wed, 14 Oct 2020 02:20:41 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id bw25sm1326231ejb.119.2020.10.14.02.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 02:20:40 -0700 (PDT)
References: <20201012170952.60750-1-alex.dewar90@gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Alex Dewar <alex.dewar90@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sockmap: Don't call bpf_prog_put() on NULL pointer
In-reply-to: <20201012170952.60750-1-alex.dewar90@gmail.com>
Date:   Wed, 14 Oct 2020 11:20:39 +0200
Message-ID: <878sc9qi3c.fsf@cloudflare.com>
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

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
