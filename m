Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E6623F880
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHHSq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgHHSqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 14:46:25 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEAAC061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 11:46:24 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id d6so5420431ejr.5
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 11:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=jOXDu9SlBmCidK+pytWuqMzjKUtQ47NPeS1CryxgtcA=;
        b=uTa4Z0q3FtuS8TMevIcT6y2L4zwl7CbwT7H+AMLFM8w2TviNKYw0lULyfUXIU0VtTy
         7FyzC0MJM4rP+lHltx4M3P+nvmsfS8G6gnxR2fF6IAGHH19q/a1sH5NSoadhB4eJ+IaS
         cUQwEmP3plJaCsy2lBdVYCEP28Pi74DgyQSVA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=jOXDu9SlBmCidK+pytWuqMzjKUtQ47NPeS1CryxgtcA=;
        b=tO3DgY6GAQhgGaaUWkOfoDVoVno2vRoQcWXNN61IYHBxaaU6vtvjOZ9vGjGxM80zC9
         HW6CV8Pjg2GjvKG6i96JPKYxzNbMtay/7VJmN9dYEOLjLpJqZDLzwXszUeEy/xRZY/2D
         A+9vGMtFgO7e6Yvad6udzYbIuhw0UYdkvYk1kphNLqRfQBvehhy9sExHdsU8fL50ZLnz
         JlOYVPbCUQ94Kc+jzEzoS1Hq0GAYbWIlA6fSr/TmDdKA5Ptx/k7yRe3Lx66XWC+PR5rH
         1l93YhsKFVJOAxu06rvzqE8t/3Vpbm0kzV4kxbZdAgwjGvmwrUyEH+jIhSk+KlfLLAha
         GrQw==
X-Gm-Message-State: AOAM532AuJHNsY8Hwb2bn5kGpWaa+B1c6NW4D0fO+GBFhuQ/mVQqheQX
        ukrkaqImEUS/5lH9jV6/QrTChHjYlRA=
X-Google-Smtp-Source: ABdhPJyIhrirp+mhF72d/SQWNFeglyQ4M+5ZA/ZZlyr1jaKCcD0TykiC97iM6OYJCfOAQL9lc9tTMQ==
X-Received: by 2002:a17:906:3850:: with SMTP id w16mr15637492ejc.205.1596912383282;
        Sat, 08 Aug 2020 11:46:23 -0700 (PDT)
Received: from cloudflare.com (user-5-173-160-125.play-internet.pl. [5.173.160.125])
        by smtp.gmail.com with ESMTPSA id y7sm9080305ejd.73.2020.08.08.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 11:46:22 -0700 (PDT)
References: <20200807223846.4190917-1-sdf@google.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net
Subject: Re: [PATCH bpf] selftests/bpf: fix v4_to_v6 in sk_lookup
In-reply-to: <20200807223846.4190917-1-sdf@google.com>
Date:   Sat, 08 Aug 2020 20:46:20 +0200
Message-ID: <87zh756kn7.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 08, 2020 at 12:38 AM CEST, Stanislav Fomichev wrote:
> I'm getting some garbage in bytes 8 and 9 when doing conversion
> from sockaddr_in to sockaddr_in6 (leftover from AF_INET?).
> Let's explicitly clear the higher bytes.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/sk_lookup.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> index c571584c00f5..9ff0412e1fd3 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sk_lookup.c
> @@ -309,6 +309,7 @@ static void v4_to_v6(struct sockaddr_storage *ss)
>  	v6->sin6_addr.s6_addr[10] = 0xff;
>  	v6->sin6_addr.s6_addr[11] = 0xff;
>  	memcpy(&v6->sin6_addr.s6_addr[12], &v4.sin_addr.s_addr, 4);
> +	memset(&v6->sin6_addr.s6_addr[0], 0, 10);
>  }
>
>  static int udp_recv_send(int server_fd)

That was badly written. Sorry about that. And thanks for the fix.

I'd even zero out the whole thing:

        memset(v6, 0, sizeof(*v6));

... because right now IPv4 address is left as sin6_flowinfo.  I can
follow up with that change, unless you'd like to roll a v2.

Fixes: 0ab5539f8584 ("selftests/bpf: Tests for BPF_SK_LOOKUP attach point")
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
