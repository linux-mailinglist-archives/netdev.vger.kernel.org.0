Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E258B6A1A47
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 11:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbjBXK17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 05:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjBXK1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 05:27:54 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED123801F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:27:13 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so1776897wmb.3
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 02:27:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97K9PyfBtWtLazTWKQyq2GhNL30Sd18gLmfofEOQCyg=;
        b=QiMbP8GIPp4u0+i2e7HZj++OjBP78CJlG83yPRWiy1/ImnLmyrn2PvN7NmTCJo5P0t
         taWlXWjA13XS1S6jBbnnlmor8A6aeaBZpaHMK9ktlKTqYaLCogzeEJTalOaUB0ZQNJGr
         hklsLQMzS9HJzdlSAoM20VxB9mNRr+pFHgKqrDbc4IWf1vXZ+IQB6lp/J5zqfUQQI+pM
         4rIbPYuCUmar8esbTjglSlyb8m3trtQCYz0rVw23bh5CPw6DvU9RoWiPOXXyJ6Kjmvww
         Ywqu7XTv9gsnAvyJ5ttmRF6vw7nEAN6w4VN5SRjuEWqAWWUfwZ1Qm1H6PJS8amArPFkO
         bjfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=97K9PyfBtWtLazTWKQyq2GhNL30Sd18gLmfofEOQCyg=;
        b=NjCLRuimwJjShL+qzZYZSGFqEisQUZZ85/DJNpmfZvc4lm6x2F8s288E5+xaWZ8ufG
         ZdYOk5kAis6yJP3AGourH7xjCPPnQpE7Mdolg/sc8c6ZXb+xAnsj9XmzOmELLyj1yTTG
         IKSO7ORLtfu76hP13HF21U2TTPJBla3+FhfnVcIvjP/LBF66uzRwBgD4F3mlXH05YwHc
         qs3SskeCk4j3e8/D7mLH5K+aiXAc+r5hV5C2u5XNvJseDkMAG1mQsAtosS3kqzhDy4hw
         Ry3eM/o1IZPqwHwok9cbBJ5Tgc+uViMBetC3XNgmFa68m7xXd4STN4Wr3KlubvXcASHY
         69jA==
X-Gm-Message-State: AO0yUKXYB/q4LfVDvpQxwX9iSuG1WvmLkY4McOy5EN7mFg1rMHRU9j5i
        Bzh7Dyp29J2yKGX2Eyc3SVOvJ5ETLfeF16P+nzBfdScjB0SiMYCh60M=
X-Google-Smtp-Source: AK7set9u4s1V/096+eUajvb7H6WjvekcV72VyuPnA4GeV2QM4isiyDsDd/OjQB28zLJHn2P6hhM2ecFs2IvIn9Zosug=
X-Received: by 2002:a05:600c:1d8a:b0:3df:97de:8bad with SMTP id
 p10-20020a05600c1d8a00b003df97de8badmr1083002wms.6.1677234399297; Fri, 24 Feb
 2023 02:26:39 -0800 (PST)
MIME-Version: 1.0
References: <20230224071745.20717-1-equinox@diac24.net>
In-Reply-To: <20230224071745.20717-1-equinox@diac24.net>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 24 Feb 2023 11:26:27 +0100
Message-ID: <CANn89iL5EEMwO0cvHkm+V5+qJjmWqmnD_0=G6q7TGW0RC_tkUg@mail.gmail.com>
Subject: Re: [PATCH net-next] packet: allow MSG_NOSIGNAL in recvmsg
To:     David Lamparter <equinox@diac24.net>, Jens Axboe <axboe@kernel.dk>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 8:18=E2=80=AFAM David Lamparter <equinox@diac24.net=
> wrote:
>
> packet_recvmsg() whitelists a bunch of MSG_* flags, which notably does
> not include MSG_NOSIGNAL.  Unfortunately, io_uring always sets
> MSG_NOSIGNAL, meaning AF_PACKET sockets can't be used in io_uring
> recvmsg().
>
> As AF_PACKET sockets never generate SIGPIPE to begin with, MSG_NOSIGNAL
> is a no-op and can simply be ignored.
>
> Signed-off-by: David Lamparter <equinox@diac24.net>
> Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> ---
>  net/packet/af_packet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>

This is odd... I think MSG_NOSIGNAL flag has a meaning for sendmsg()
(or write sides in general)

EPIPE is not supposed to be generated at the receiving side ?

So I would rather make io_uring slightly faster :


diff --git a/io_uring/net.c b/io_uring/net.c
index cbd4b725f58c98e5bc5bf88d5707db5c8302e071..b7f190ca528e6e259eb2b072d7a=
16aaba98848cb
100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -567,7 +567,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const
struct io_uring_sqe *sqe)
        sr->flags =3D READ_ONCE(sqe->ioprio);
        if (sr->flags & ~(RECVMSG_FLAGS))
                return -EINVAL;
-       sr->msg_flags =3D READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+       sr->msg_flags =3D READ_ONCE(sqe->msg_flags);
        if (sr->msg_flags & MSG_DONTWAIT)
                req->flags |=3D REQ_F_NOWAIT;
        if (sr->msg_flags & MSG_ERRQUEUE)
