Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE577184F24
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 20:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgCMTBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 15:01:55 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34734 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbgCMTBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 15:01:54 -0400
Received: by mail-qk1-f194.google.com with SMTP id f3so14404336qkh.1;
        Fri, 13 Mar 2020 12:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eGZIA8am39kSNsxjV5aHy9AbRgYa061k2617RREiqeQ=;
        b=Mpf7Xh2AsXMFornP1+JlFaCix6PupJ7zuDRPODDq2p3wkosE+ArgspLIqY62gowqSy
         VlFtUTJk6TzMmC4LyN4DqIWHTRuE0EyNNhYANwlPV0DZBQA8qTedUFMnw059+MN/NMzX
         mvlHfb4BwOnrRnsa2IjojkAkIuYB2rkkq3ylcvrrsI9TVmgGVABlez9mTjGMeDuV12SP
         Q0MSgO4Atg1MHZ9MzFhaqmbga9Zj1KGZxXVagoSIEPQ6RR6bfqddxCsD2HtZmL3kJ1sH
         QQfCEoftq8uRVoGKIZ9MxQ3kYE0Z2lG2/vfAUynxMlYQunMfw3hDY/w41NQ3BYg/lBxi
         tBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eGZIA8am39kSNsxjV5aHy9AbRgYa061k2617RREiqeQ=;
        b=U47ruUIvupyLcryRJtZjG5i08wsUZ8pXtgJoiiRzSjQP7LfBrxZv3BRa3GD0Ej/5Ba
         KV2gMER9tGy347LzooQz6NqliFKEZCU6QSQfS/AshNWR07OQOJ/Z+H0c3qZBT3Yp0OKx
         BtDEWwUB+uFNnq7RapRfE/4g5oDpsT/xlK4IihnMNfhrPnvZ77kFd9ropQeUrW2WUFGg
         qdIpP5hRvcleN0BuALnCQoaoqh2IWDiJ8SxmtNaeIJ5JJ4jUH1or3gZSLvDmfFrNdWMb
         1M5NvM+1YAciUgybGeheXyr85h321a0uaB2Q8XTZtPDffPwOaQtca2C15J86Tmqwfcqb
         j30w==
X-Gm-Message-State: ANhLgQ0QJx/cap1XqgnGnzRF65u6EZWLuBUv9CjDWE4Hf0lYMs/Mb3wr
        cpLCexsJX6I+g8LpmRGSIJw2/r0pswuPOrXNnKwEzMFw
X-Google-Smtp-Source: ADFU+vvfntI621OzUeWWlKtXhXU+xzb2OByhiQoS2PcS0WPCiV82m/2E+d6+RodmbMJz5qm1uw1EvI99LW6uueiBJQU=
X-Received: by 2002:a37:e40d:: with SMTP id y13mr14690675qkf.39.1584126113956;
 Fri, 13 Mar 2020 12:01:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200313161049.677700-1-jakub@cloudflare.com>
In-Reply-To: <20200313161049.677700-1-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 13 Mar 2020 12:01:43 -0700
Message-ID: <CAEf4Bza493cXh+ffS7KHtgGnVDYwyxwDXQ_G6Ps1Bfm4WVRLQA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: Fix spurious failures in
 accept due to EAGAIN
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        Stanislav Fomichev <sdf@google.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 9:10 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Andrii Nakryiko reports that sockmap_listen test suite is frequently
> failing due to accept() calls erroring out with EAGAIN:
>
>   ./test_progs:connect_accept_thread:733: accept: Resource temporarily unavailable
>   connect_accept_thread:FAIL:733
>
> This is because we are using a non-blocking listening TCP socket to
> accept() connections without polling on the socket.
>
> While at first switching to blocking mode seems like the right thing to do,
> this could lead to test process blocking indefinitely in face of a network
> issue, like loopback interface being down, as Andrii pointed out.
>
> Hence, stick to non-blocking mode for TCP listening sockets but with
> polling for incoming connection for a limited time before giving up.
>
> Apply this approach to all socket I/O calls in the test suite that we
> expect to block indefinitely, that is accept() for TCP and recv() for UDP.
>
> Fixes: 44d28be2b8d4 ("selftests/bpf: Tests for sockmap/sockhash holding listening sockets")
> Reported-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

This looks good. Unfortunately can't repro the issue locally anymore.
But once this gets into bpf-next and we update libbpf in Github, I'll
enable sockmap_listen tests again and see if it's still flaky. Thanks
for following up!

Stanislav, would you get a chance to do something similar for tcp_rtt
as well? Seems like all the tests dealing with sockets might use this
approach?

Acked-by: Andrii Nakryiko <andriin@fb.com>

>
> Notes:
>     v2: Switch back to non-blocking mode, but with polling and timeout.
>         Extend the fix to all I/O calls that we expect to block. (Andrii)
>
>  .../selftests/bpf/prog_tests/sockmap_listen.c | 77 ++++++++++++++-----
>  1 file changed, 58 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> index 52aa468bdccd..d7d65a700799 100644
> --- a/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_listen.c
> @@ -16,6 +16,7 @@

[...]
