Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FDF1226B2
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 09:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfLQIaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 03:30:08 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52135 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfLQIaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 03:30:07 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so1988073wmd.1;
        Tue, 17 Dec 2019 00:30:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rXSSQVCYj/Qad5tcQJvjedfS+geoMZX3z+6qpzpCYqc=;
        b=JGdn24bfnay/sw6Sj4AByxjgWNolog285GnUzNGVgaJbiWLnrX7hAf61xAOfqz/YmG
         s+zBHHVcbSRgpz1/4v8PV5keLuRgspQ9XvcKOIqWsXztVAZxxQbvm31wqcDji9QhdNg9
         XaPG5xAtud1Jyl0YaFqW2BfY90jXut0a3gO1ZtYR/BgxmnPlXlqZXrZLUsx41uQjNpSP
         G/2cg0I8qaBU8CWZ20vadwodPxW3FcX9TkEKkbyUh5sLuKiIk6+Ajfqljf6SsE5Ue/Gv
         Rnp1boFVAiV/ViiZ2Myes34i0de+mmtcWu5ldodd2rZ8NMamUuarrQ6ulCEt6iMsj/vN
         c51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rXSSQVCYj/Qad5tcQJvjedfS+geoMZX3z+6qpzpCYqc=;
        b=UB5WJklXJ/ZIrS9UT0uO6eO7Pe/FeGi35q+7yeA0Dp7oF923YLr0XALMBuaaL6zsrS
         AYfHzq5LNZz0S1MyFkOIbAeZHrd4b34Jnuv/ipgu93XnlUcf5pvyGF7op+Fo9pXu21hS
         EAxMWoG89BzvwwCPy1w7k9REn5r3Ho+8+9ZQAg/qYaoTJzAXLGdRXh4gmJ5gU/wNpZnE
         ua4w1QAhvDIc/fyRNSimHFXGGQH8aisAE3t7xzcJlWghUacYHW+rPYARY2emrRiDEii9
         N9GpkIk8p0yvr/+ca2gsDBAFN/zyQGU+nKNKKIztvbitLFWjppFNZh+VzxH5uHrLb3Y6
         /CHg==
X-Gm-Message-State: APjAAAU9GuhT3eZaplcrafuRyQTwHmQ88dYed7eJR7wNk8gZGA1IdsMs
        ywMqEhiode1k8ZxY0YMLtvmsHUZj3s97B46HCa4=
X-Google-Smtp-Source: APXvYqwDMNUK3OKFsWVYbzgCoH0wK8oU52YXX2wIeCTFm4nojCFbhpB1F3J9gqJ5fceKm/F9K0aH+nP6Ejz7mVHtX3w=
X-Received: by 2002:a05:600c:d7:: with SMTP id u23mr3699213wmm.145.1576571405512;
 Tue, 17 Dec 2019 00:30:05 -0800 (PST)
MIME-Version: 1.0
References: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
In-Reply-To: <2a040bc8a75c67164a3d0e30726477c1a268c6d7.1576544284.git.marcelo.leitner@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 17 Dec 2019 16:30:58 +0800
Message-ID: <CADvbK_ePttg_D841q0fM2Qa5Ksa+wGq+eWhwzy3FToC9wsF5rw@mail.gmail.com>
Subject: Re: [PATCH net] sctp: fix memleak on err handling of stream initialization
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        Kent Overstreet <kent.overstreet@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-sctp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 17, 2019 at 9:01 AM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> syzbot reported a memory leak when an allocation fails within
> genradix_prealloc() for output streams. That's because
> genradix_prealloc() leaves initialized members initialized when the
> issue happens and SCTP stack will abort the current initialization but
> without cleaning up such members.
>
> The fix here is to always call genradix_free() when genradix_prealloc()
> fails, for output and also input streams, as it suffers from the same
> issue.
>
> Reported-by: syzbot+772d9e36c490b18d51d1@syzkaller.appspotmail.com
> Fixes: 2075e50caf5e ("sctp: convert to genradix")
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
>  net/sctp/stream.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/sctp/stream.c b/net/sctp/stream.c
> index df60b5ef24cbf5c6f628ab8ed88a6faaaa422b6d..e0b01bf912b3f3cdbc3f713bcfa50868e4802929 100644
> --- a/net/sctp/stream.c
> +++ b/net/sctp/stream.c
> @@ -84,8 +84,10 @@ static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
>                 return 0;
>
>         ret = genradix_prealloc(&stream->out, outcnt, gfp);
> -       if (ret)
> +       if (ret) {
> +               genradix_free(&stream->out);
>                 return ret;
> +       }
>
>         stream->outcnt = outcnt;
>         return 0;
> @@ -100,8 +102,10 @@ static int sctp_stream_alloc_in(struct sctp_stream *stream, __u16 incnt,
>                 return 0;
>
>         ret = genradix_prealloc(&stream->in, incnt, gfp);
> -       if (ret)
> +       if (ret) {
> +               genradix_free(&stream->in);
>                 return ret;
> +       }
>
>         stream->incnt = incnt;
>         return 0;
> --
> 2.23.0
>
Tested-by: Xin Long <lucien.xin@gmail.com>
