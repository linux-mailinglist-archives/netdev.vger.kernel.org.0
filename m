Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD9956730BF
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbjASEzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjASEyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:54:17 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598C971F07
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:46:17 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id 123so1105089ybv.6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 20:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gYdaFetUPf0E0ye7Z3ZJlSmRWJOtaHOZWbhbExkiyx8=;
        b=oD5uLA0y/00qtaZD98y+906UbmyKCQ91Umx0p1OmhRh1HjdSOThxXCzmSIAMlnkLsz
         QmK4AMU5cifY6S/eqpC3BrBqPm8ZjbimNTFWEFOTw1h4KrXN+yCwGIG7ptzsQ4qBWA07
         k44GyPHq9OxtUpubkZW3Pr+sVRph8cLT8kM+BybuBNZyINZ1qrnQHWW13+UflMUYSr0l
         iMPa7DklAsIJ0k/92neTiXESaKe2EBJcShKGhVvQVKWVR/Jjhh5FPH6HjQYGVlgtG4m+
         JQPMTAjNovYZQXsxSNppricUSA6IWDHK/5gTYgSqzOrlLUrGyn7EVPbPgR4jIlbj8GAP
         8KQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gYdaFetUPf0E0ye7Z3ZJlSmRWJOtaHOZWbhbExkiyx8=;
        b=DX1J6I0klnmZ6sfJo7W4L/LwXA2c94hUcTVTfHfZLA0JkDwnvsCPt4cVCKGfrbC+In
         paXMzy7qNVQOe5N3gbMk9/+oNAqWE2srZeCfyk2iJh0Nz8rlgPDweEFjPPd99D9c/lEI
         bPKmoXB2u0w2as99XDA3oGYonssZCv1KIghdt5iya3GUOA4zTK9Y62bpvcTNTzOcASby
         sRfYVFRU1WFj65zbodhxjWngOh2T+u38mtHLnRJkYwlDDWVWN04tIKXGwnEQt+6f7inO
         /2PNWwQTxGf+Qbv9KshU+YsVbG1nh0x7e0oyt2gMMlQEQStnQfoaoI8pbVIsJWmIWOZh
         M/4g==
X-Gm-Message-State: AFqh2kqKkVRJnKPMVocCiYyb1uMzQNn4q5w7F9qQV+NXKt3jsq89IF/Z
        /eqsghB/02GeIosnqKWdHj/ETUC3pku7tt/m43vvwe0P53xhw1Rz
X-Google-Smtp-Source: AMrXdXvk62oDAXFWdiHI8MIYop20AX4xbZv0HPtfGaRjO2UGZYt6AErVloW1A0knHlP+SQOxc0zFNtzy8qq9s7CuD3A=
X-Received: by 2002:a81:351:0:b0:36c:aaa6:e571 with SMTP id
 78-20020a810351000000b0036caaa6e571mr859614ywd.467.1674101784903; Wed, 18 Jan
 2023 20:16:24 -0800 (PST)
MIME-Version: 1.0
References: <20230119013405.3870506-1-iam@sung-woo.kim>
In-Reply-To: <20230119013405.3870506-1-iam@sung-woo.kim>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 19 Jan 2023 05:16:13 +0100
Message-ID: <CANn89iK6DZodENC8pR-toW_n5-VFyQR8X1XOuG9Lx1-kr1tmqQ@mail.gmail.com>
Subject: Re: [PATCH] L2CAP: Fix null-ptr-deref in l2cap_sock_set_shutdown_cb
To:     Sungwoo Kim <iam@sung-woo.kim>
Cc:     daveti@purdue.edu, wuruoyu@me.com, benquike@gmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "open list:BLUETOOTH SUBSYSTEM" <linux-bluetooth@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 2:35 AM Sungwoo Kim <iam@sung-woo.kim> wrote:
>
> The L2CAP socket shutdown invokes l2cap_sock_destruct without a lock
> on conn->chan_lock, assigning NULL to chan->data *just before*
> the l2cap_disconnect_req thread that accesses to chan->data.

This is racy then ?

> This patch prevent it by adding a null check for a workaround, instead
> of fixing a lock.

This would at least require some barriers I think.

What about other _cb helpers also reading/using chan->data ?

>
> This bug is found by FuzzBT, a modified Syzkaller by Sungwoo Kim(me).
> Ruoyu Wu(wuruoyu@me.com) and Hui Peng(benquike@gmail.com) has helped
> the FuzzBT project.
>
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>

I would also add

Fixes: 1bff51ea59a9 ("Bluetooth: fix use-after-free error in
lock_sock_nested()")

> ---
>  net/bluetooth/l2cap_sock.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
> index ca8f07f35..350c7afdf 100644
> --- a/net/bluetooth/l2cap_sock.c
> +++ b/net/bluetooth/l2cap_sock.c
> @@ -1681,9 +1681,11 @@ static void l2cap_sock_set_shutdown_cb(struct l2cap_chan *chan)
>  {
>         struct sock *sk = chan->data;
>

Other similar fixes simply do:

     if (!sk)
          return;

I would chose to use the same coding style in net/bluetooth/l2cap_sock.c

> -       lock_sock(sk);
> -       sk->sk_shutdown = SHUTDOWN_MASK;
> -       release_sock(sk);
> +       if (!sk) {
> +               lock_sock(sk);
> +               sk->sk_shutdown = SHUTDOWN_MASK;
> +               release_sock(sk);
> +       }
>  }
>
>  static long l2cap_sock_get_sndtimeo_cb(struct l2cap_chan *chan)
> --
> 2.25.1
>
