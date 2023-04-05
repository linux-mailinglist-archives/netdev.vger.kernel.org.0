Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB7686D74FB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 09:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbjDEHF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 03:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236940AbjDEHF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 03:05:56 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B346127
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 00:05:51 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id q19so32063827wrc.5
        for <netdev@vger.kernel.org>; Wed, 05 Apr 2023 00:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680678350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HB42Tr6pI9GgWr23U+2bBvbETEuwRCwRzDMnWzxAW2Y=;
        b=Kbjv/l1oBxmHuShkmGsRUu6r7pzC83EoPKK6JFkdMVra8bLhsB39i2z0/znmBAMgxi
         noQksoKhD4WPHcIpi97xAFlDxaniZTH5a4SHX9jaDeiWDahshaWjIxKG4AKBCk+YLQ9n
         istsOEZUOHtcRC3LyrfFFLIdt8HwXbccsuNE5WOx+rxN9EcMRsAr22XYqd/teoyAMpEA
         TOBSnSBQZCz5vK0BLWXK7Z+vxoSIs1BP5OV4Fc1pT8Hxtm6CLx9If3SLdXIUDLfgBzWK
         Tivlbgrl5QpdawA9OyveM+1Cvf4BzIWYB42B9UxSSS1G0o8i6ibzcYVzf5heWPASDgEw
         jkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680678350;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HB42Tr6pI9GgWr23U+2bBvbETEuwRCwRzDMnWzxAW2Y=;
        b=Wi9ke2LFCYHGJ6R8hkbKvpt71Xj7YkK1OseMicL4WZeSPc5oPZeUxpAs0Spgs1wljf
         auo8Tt6wtysQfmDIexN1H94Bsd6QQSunbNwWNn9Oj9KC3Qi0fCdN9sMuMbSrXwhJSxlK
         qxIwNC1LswiKV1OcjH8/YzvUdtOuRARtVbgdpVDs/+VIC7g0Iwomsres6mIIJAD0RPxp
         amiU/oYHxgNwdhyTdJE6RpLgAP2WVEJ2VpeBRWH35idwQ4ETmbkD4tkHRsCoQ4xgRUZk
         PMkfFiFGXYQkedjLIRqaerV3QpDu1mzGcLaXr/TYQKAP0q/CD2/+E0IWr7AywUNVuhCx
         9YDQ==
X-Gm-Message-State: AAQBX9fn+Yb6d057N57jjn2KNxraQsp6AP2q3qzyXuM3LU3HtgjVeBES
        kAVhAMhEDSBDl6jCpooXmTiX2JfcxczAUKnirEc+Yg==
X-Google-Smtp-Source: AKy350Z87fN5+rJ0iseVRtKsGEudxBoEH4BdQu7xJNhnEGUzwjHJdFfv3C58OYF8NwCkdGT6h0cJFBQ4d4AB+1Sr1G4=
X-Received: by 2002:a5d:64e1:0:b0:2cf:ef9f:33f6 with SMTP id
 g1-20020a5d64e1000000b002cfef9f33f6mr576968wri.1.1680678349878; Wed, 05 Apr
 2023 00:05:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230405023236.10128-1-kuniyu@amazon.com>
In-Reply-To: <20230405023236.10128-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 5 Apr 2023 09:05:38 +0200
Message-ID: <CANn89iK+Gv2AbNH5DGxTUX_LAXZ8dzyrp0ivCKq6rYaJB1dYsQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next] selftest/net: Fix uninit val warning in tcp_mmap.c.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Coco Li <lixiaoyan@google.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 5, 2023 at 4:33=E2=80=AFAM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> Commit 5c5945dc695c ("selftests/net: Add SHA256 computation over data
> sent in tcp_mmap") forgot to initialise a local var.
>
>   $ make -s -C tools/testing/selftests/net
>   tcp_mmap.c: In function =E2=80=98child_thread=E2=80=99:
>   tcp_mmap.c:211:61: warning: =E2=80=98lu=E2=80=99 may be used uninitiali=
zed in this function [-Wmaybe-uninitialized]
>     211 |                         zc.length =3D min(chunk_size, FILE_SZ -=
 lu);
>         |                                                             ^
>
> Fixes: 5c5945dc695c ("selftests/net: Add SHA256 computation over data sen=
t in tcp_mmap")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> Note that the cited commit is not merged in net.git.
> ---
>  tools/testing/selftests/net/tcp_mmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/tcp_mmap.c b/tools/testing/selft=
ests/net/tcp_mmap.c
> index 607cc9ad8d1b..1056e37f4d98 100644
> --- a/tools/testing/selftests/net/tcp_mmap.c
> +++ b/tools/testing/selftests/net/tcp_mmap.c
> @@ -168,7 +168,7 @@ void *child_thread(void *arg)
>         double throughput;
>         struct rusage ru;
>         size_t buffer_sz;
> -       int lu, fd;
> +       int lu =3D 0, fd;
>
>         fd =3D (int)(unsigned long)arg;
>
> --
> 2.30.2
>

This is not the right fix. I sent it yesterday, not sure if you have seen i=
t ?
