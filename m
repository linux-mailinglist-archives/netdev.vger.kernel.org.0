Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8EB14F2F2
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 20:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgAaTuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 14:50:06 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:35470 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbgAaTuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 14:50:06 -0500
Received: by mail-ot1-f66.google.com with SMTP id r16so7750046otd.2
        for <netdev@vger.kernel.org>; Fri, 31 Jan 2020 11:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ADBMyX2KlqFmMyJ5cxYgmqG+uE/FwP1nZWe5xNfOqk=;
        b=ewsUdngRp+cFF5LVI+sBi2W4Kvr96gQJpR0eZSiJRhZGTQAGDIDHvdyzoEr6TK8Uqu
         /niAM3le7TkBnCGhVOKIl4lwE8n9TNjVUixI2sGUBHlxhXT5zYnck9+1zsdTsawLh8nI
         knrHVa8qKzqAMOOdHKcvmQ/aV4KNAvhBfPYJmslS3rx70a1jg2DQS+VKhKPOZU2Yn3P8
         ON6e8uKQm6dY6N5odH+bHvTvkXvOkFAX8kITizLIvRA/vqCAjnBRMGI4LScnzJjmlFpR
         g10u38HgUYQhgyfbsChEO0z89Mkld6orRTV6IyM+rYeGMFZW6L85BgV5ujHbjtiomLkt
         2P8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ADBMyX2KlqFmMyJ5cxYgmqG+uE/FwP1nZWe5xNfOqk=;
        b=P+Kflyi1xWtOihxrETumN29p9ZKq8CNM8qYD2WwxflxyAxu3hNuKB3Vn8t/kUKvD6Z
         b76PAYsDEhMv/PuLw0YW92qezeeId6WNMAgPvgUL+DN4VX8IGUFrsyVND4DcNcNgd8et
         1RKK9kWiCPN8p1eTgL6qBfIzLUutj+kFjuOLMe4iomrLHMLzIY2PUgCvjH6rBqpkup52
         nnH3D5Ecy3Tm7d5QIGn0qjpzGYw7r/zckS5+lN5T/3cKyNQIKmIMpe80mvSvTan7kFpT
         ZdUhTz5/46v/Vm046gS79i/hYlQIeTE0ncSn3ONkPyzt0ADMYY6/CqajWp43iMLTCC36
         xYyQ==
X-Gm-Message-State: APjAAAV1FqwwbV8oHzOjqk3ATm052JD0mrV6M+PcdO+Tj8SWpuxNxrdT
        pLbx3hpzQCTL4Czf8pPQqOQ7Jq4EKOhCB37LOfEHfg==
X-Google-Smtp-Source: APXvYqyQG6H/KsIWev0wAhGsee4Xyw86hjinOg+7/LDfQyE5LJhf8dJ0nyQeooWwmFEuiX8irD60jhfq1ywP9aA6+bE=
X-Received: by 2002:a9d:7b51:: with SMTP id f17mr8641535oto.302.1580500205189;
 Fri, 31 Jan 2020 11:50:05 -0800 (PST)
MIME-Version: 1.0
References: <20200131184450.159417-1-edumazet@google.com>
In-Reply-To: <20200131184450.159417-1-edumazet@google.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Fri, 31 Jan 2020 14:49:48 -0500
Message-ID: <CADVnQyn-ELptMpumcbgn8yJ257imucaZen8n+xB2D1JkrzqSUA@mail.gmail.com>
Subject: Re: [PATCH net] tcp: clear tp->segs_{in|out} in tcp_disconnect()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 31, 2020 at 1:44 PM Eric Dumazet <edumazet@google.com> wrote:
>
> tp->segs_in and tp->segs_out need to be cleared in tcp_disconnect().
>
> tcp_disconnect() is rarely used, but it is worth fixing it.
>
> Fixes: 2efd055c53c0 ("tcp: add tcpi_segs_in and tcpi_segs_out to tcp_info")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>
> ---
>  net/ipv4/tcp.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index 3b601823f69a93dd20f9a4876945a87cd2196dc9..eb2d80519f8e5ad165ca3b8acef2b10bdf8b7345 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -2639,6 +2639,8 @@ int tcp_disconnect(struct sock *sk, int flags)
>         sk->sk_rx_dst = NULL;
>         tcp_saved_syn_free(tp);
>         tp->compressed_ack = 0;
> +       tp->segs_in = 0;
> +       tp->segs_out = 0;
>         tp->bytes_sent = 0;
>         tp->bytes_acked = 0;
>         tp->bytes_received = 0;
> --

Thanks, Eric!

Acked-by: Neal Cardwell <ncardwell@google.com>

neal
