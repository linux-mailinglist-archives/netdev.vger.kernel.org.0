Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F04698B19
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 08:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731565AbfHVGAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 02:00:32 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33978 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbfHVGA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 02:00:29 -0400
Received: by mail-oi1-f196.google.com with SMTP id g128so3522419oib.1;
        Wed, 21 Aug 2019 23:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YluVw3FQcQqlMabmOIDq2KLrInzmsoUYZc4IQN5YmtM=;
        b=JqYvOYjuef3saBKQs3+29283DrdRtXBMuhEu0BBU3p7Q0wbuQ542BpWtBaDKDmcsQ9
         HFlAQAShm7r6ygrxZtyGQloPdz9J8Agu1Hn7WZIa+0YrgynLnC2YDEEsbEYRf9AuN74X
         lNwaG2PfVJOaP4M50y+FduRMlEliwI4feQYDc2kZPyTSMZit6f9KecUC0r/YQ+QVjWHZ
         eyk5q/ZgPczXnBG69B8S9HziYPYQWwZpYq8gvYkIM5TqeM+NXTBPFc2cZ6fojucOoY9+
         +079MAlTMr9aoG4LJ5TZPNooKydTCoNjm46KZaawjEMW4jTYLGYg8yYA2IS95xvlB0Ch
         K+Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YluVw3FQcQqlMabmOIDq2KLrInzmsoUYZc4IQN5YmtM=;
        b=V5fihhJ5p8XBNtGe2/285GuNJyMPZTiezfpwyzzvQRe/olgqTfgAFhiS5HRGVoij0M
         C/LSlHLmPpeUmPZ8DIdE68WhRKBsVJ4Zra+tOJCYq3dbEUa+65trB1bgX3aoXi9kF1Mt
         Tbb0JL34mmdWrXBkMJyLBuwuAWpK0SBt2RUi2E06BHtzkUmjcTvw2qbvbfOalzSdNbFG
         2hBQowwllBlca0+REcke19ykEODH23/yCw2d0Wwe2vAifp2stsMZno6LDybZqLYLz6ZX
         F6pDwhx/L2n3yRlqvqTcsVMc6sQS1VqKgj/C0j+PCyio3Pd0SMErU1QWtAdJvSsdMtS5
         66pA==
X-Gm-Message-State: APjAAAXwNCW2v2XnIRBJPT6vKJEVLKDZhweoCkzpv+NCdnGHlb245Vzd
        vRfOU6RF2Q203UWmxDT4qy7/mTX6yJzrnVhSMeA=
X-Google-Smtp-Source: APXvYqzRnO+l/kwsBwkFGP9v7ygVphdCh3n/VmUbd2w1Q7i9ocTS89dO+t5wKzUEFIEDMJwJWSR6/iNgoK2cyQ1VKsY=
X-Received: by 2002:aca:d08:: with SMTP id 8mr2494087oin.51.1566453629101;
 Wed, 21 Aug 2019 23:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190821121720.22009-1-jakub@cloudflare.com>
In-Reply-To: <20190821121720.22009-1-jakub@cloudflare.com>
From:   Petar Penkov <ppenkov.kernel@gmail.com>
Date:   Wed, 21 Aug 2019 23:00:18 -0700
Message-ID: <CAGdtWsSQT4wfXB8F=putR-Cm8xKcXFH1omfY3YGhJ8i9WBxjfQ@mail.gmail.com>
Subject: Re: [PATCH bpf] flow_dissector: Fix potential use-after-free on BPF_PROG_DETACH
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes sense, thanks!

Acked-by: Petar Penkov <ppenkov@google.com>

On Wed, Aug 21, 2019 at 5:19 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Call to bpf_prog_put(), with help of call_rcu(), queues an RCU-callback to
> free the program once a grace period has elapsed. The callback can run
> together with new RCU readers that started after the last grace period.
> New RCU readers can potentially see the "old" to-be-freed or already-freed
> pointer to the program object before the RCU update-side NULLs it.
>
> Reorder the operations so that the RCU update-side resets the protected
> pointer before the end of the grace period after which the program will be
> freed.
>
> Fixes: d58e468b1112 ("flow_dissector: implements flow dissector BPF hook")
> Reported-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  net/core/flow_dissector.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 3e6fedb57bc1..2470b4b404e6 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -142,8 +142,8 @@ int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
>                 mutex_unlock(&flow_dissector_mutex);
>                 return -ENOENT;
>         }
> -       bpf_prog_put(attached);
>         RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
> +       bpf_prog_put(attached);
>         mutex_unlock(&flow_dissector_mutex);
>         return 0;
>  }
> --
> 2.20.1
>
