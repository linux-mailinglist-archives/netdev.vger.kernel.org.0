Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E6017A4EE
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgCEMK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:10:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54790 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725926AbgCEMK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:10:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id i9so6009822wml.4
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 04:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=KBXCSNE6peE5+CeIlF7Ibk2Tx9p083hyIskUpmp4ugo=;
        b=HMJ+lHeo2umbYbq6oXwH22EWNZT3pfIKsXfc3R1w2M7q/3FKgVcphERbRC1YmGOjc+
         FTOtTT95mKeRMFgnIO/3zuoGHzkS3IUcj5MNhI8jzkSk2zkBhLeBE05AAMH332Y/xxDT
         Rbb5T/ItFsjC9E5Pq6G4aiyTheYLk2JqOmXDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=KBXCSNE6peE5+CeIlF7Ibk2Tx9p083hyIskUpmp4ugo=;
        b=OiuMggOBcCmavBbKcylZYOt+0SJ67fBIBmhfbv1gl+Z5ULzNujcFEoGT4lnX95MsDh
         e5KNJMQZEPzQyBFCO7NjrHjzFSV8ogQFTAm0sQlVd7wgHE03ZuYIsUyq6nanUSWP8yPu
         wtKMZgguhQQaM9QdIki6LTzDtuA0+DuP/Jnx9poo5FZ9JPBEUxY/2NYw2/II7JD948BH
         mfns8/KvUJ81Orb8YaLAlOP7+c1ZKRVBb/paRC4j/tFmZqEVgRVwaTJUUiarvfzMKxIb
         SO8lzVZ8SnwYeKZeIL7f750u/uF1v63Ct9yrcXdEGDYsuCXyDj+m/Z3uDsRW9Ue3cH04
         x/VQ==
X-Gm-Message-State: ANhLgQ071dgiZNI+LTJLsp9bwl9eje3Vr0c6PnuYXpNqcjogdVBrEN0W
        rNZpdOqqui/HSJodlfs8l2OivQ==
X-Google-Smtp-Source: ADFU+vve3Cp34TjAaj76w49rGzR8ApG72pFtUpRPvbSnRiWaCN++WdPMrApJQ0hUIg+avKsK0gvzTQ==
X-Received: by 2002:a7b:c858:: with SMTP id c24mr9545345wml.118.1583410227949;
        Thu, 05 Mar 2020 04:10:27 -0800 (PST)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id o27sm46387012wro.27.2020.03.05.04.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 04:10:27 -0800 (PST)
References: <20200304101318.5225-1-lmb@cloudflare.com> <20200304101318.5225-4-lmb@cloudflare.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     john.fastabend@gmail.com, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Alexei Starovoitov <ast@kernel.org>,
        kernel-team@cloudflare.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 03/12] bpf: tcp: move assertions into tcp_bpf_get_proto
In-reply-to: <20200304101318.5225-4-lmb@cloudflare.com>
Date:   Thu, 05 Mar 2020 13:10:26 +0100
Message-ID: <87eeu7ypcd.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 11:13 AM CET, Lorenz Bauer wrote:
> We need to ensure that sk->sk_prot uses certain callbacks, so that
> code that directly calls e.g. tcp_sendmsg in certain corner cases
> works. To avoid spurious asserts, we must to do this only if
> sk_psock_update_proto has not yet been called. The same invariants
> apply for tcp_bpf_check_v6_needs_rebuild, so move the call as well.
>
> Doing so allows us to merge tcp_bpf_init and tcp_bpf_reinit.
>
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

[...]
