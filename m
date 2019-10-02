Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63C92C4613
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728980AbfJBDSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:18:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36570 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726869AbfJBDSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:18:02 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so24558994qtf.3;
        Tue, 01 Oct 2019 20:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DkfOxbgDr7IYTTOG7aOBpzhIL2nlLLSARJt6E+jjVXU=;
        b=IhspJJTCUMExojADiKr2W/9JHFM0sVu94fB83wkgQSgbKLnWmSlRyg7OBZ2wEQ6zFV
         yQRvkabi8UL5SqFLiyi6m1SPuhofDVvoaLHj2L0C5sx0uSySug1ibL7hNfGwvie86GJZ
         NPDitckoC0vaohlnMQmYOv3L4Gzsz5OKIx1/tNUWeRcIkDPLdjAYtuaq5ZnE6QFg6YmW
         b/ZHkclTCiwtvPp0BZ9CKTdn7ZAX02ne0DRLfidO2AcVv8LtvDpS+06BS7nGcH+8xBzy
         hX8Um03GcW04FPtVizP/47K82r2th84FqA7j86y5kLcTI9+J/FmtI6oDhKZ47QCYRd6j
         1uUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DkfOxbgDr7IYTTOG7aOBpzhIL2nlLLSARJt6E+jjVXU=;
        b=k8/+Nuij7PdJh+FT1554aeGnvu1e0FUYGRpJejN6MVLrH8wAhMM+VilQcA94S7Ydj0
         ++eCCbw0aItGuCT8cuoqLLIwbLcithTsKBz46XF1soHZ5K4VD102ktbHyp1/vUt33UXK
         D7VOX6XvBvSseVVPbVqmCVAp4wRtYpRxVGQfF0L4HJV52yejlOTVUXiaVw86FmBBqca6
         CdWYMwe2Ac8voOHHcuqT0IfSC4jBUJzbWTQAPzDhrQYAX1PxOF6tJHOFtKCxAWNrtbx/
         5UckLgHmwAEOXyCzRX2bDAc/QEkDeRFyaVauscvdVQyOFFgyy5prtRXUbbiI3Mkde6fl
         WgJg==
X-Gm-Message-State: APjAAAUY42veVtfPMZQsiJ/6OdarslG9yOBcJ9wTSkbl0jG8Fe+cnI8G
        p+UYUeTeMS+Uc5XwPGT5yCN/75xdG8bAx3MY/Nw=
X-Google-Smtp-Source: APXvYqw3Go3PwnQpyK3Qdr1NGe4I3IFRGZ1+38xzNKIt7ca1IGQDBDYkiZWNeqhmy2nhKIfw6qymUYBbF/yKvCcGtUk=
X-Received: by 2002:a0c:88f0:: with SMTP id 45mr1215730qvo.78.1569986280629;
 Tue, 01 Oct 2019 20:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191001173728.149786-1-brianvv@google.com> <20191001173728.149786-2-brianvv@google.com>
In-Reply-To: <20191001173728.149786-2-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 1 Oct 2019 20:17:49 -0700
Message-ID: <CAEf4Bzb7ag=bdhuAuDHuxk_+jQj7ZudU3Bd2zk3OPz8GSYVFtA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: test_progs: don't leak server_fd
 in tcp_rtt
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 1, 2019 at 10:39 AM Brian Vazquez <brianvv@google.com> wrote:
>
> server_fd needs to be closed if pthread can't be created.
>
> Fixes: 8a03222f508b ("selftests/bpf: test_progs: fix client/server race
> in tcp_rtt")

Fixes tag hast to be on single line, no wrapping. Besides that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

> Cc: Stanislav Fomichev <sdf@google.com>
>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/tcp_rtt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> index a82da555b1b02..f4cd60d6fba2e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/prog_tests/tcp_rtt.c
> @@ -260,13 +260,14 @@ void test_tcp_rtt(void)
>
>         if (CHECK_FAIL(pthread_create(&tid, NULL, server_thread,
>                                       (void *)&server_fd)))
> -               goto close_cgroup_fd;
> +               goto close_server_fd;
>
>         pthread_mutex_lock(&server_started_mtx);
>         pthread_cond_wait(&server_started, &server_started_mtx);
>         pthread_mutex_unlock(&server_started_mtx);
>
>         CHECK_FAIL(run_test(cgroup_fd, server_fd));
> +close_server_fd:
>         close(server_fd);
>  close_cgroup_fd:
>         close(cgroup_fd);
> --
> 2.23.0.444.g18eeb5a265-goog
>
