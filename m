Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF19618D98
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 02:25:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiKDBZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 21:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbiKDBZI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 21:25:08 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CDC2339A
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 18:25:07 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-370547b8ca0so31960027b3.0
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 18:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lToyp0EgaeZrIwiFmFTuf4gl0OZ3lSV2+wziFDvZU0c=;
        b=BwjfzLpI7W5zZiHbND1rLgzjf82q9tnMyeShyKAkCXXZqs+YmydpwUHoO/WirQt3lf
         yJGCXs8z4IJlm6o5WJIqHbWuRVQJSN9TGyCHAc4ENasZO8Nxj5hAXkBr0nZamE7EeCOw
         xAIOCFupCalx9OZtXnQjUTbT+a1WKlc4ucPabyUTmV+d8tQvdXzyShr9cIBUndxy+EV8
         se3fS6MzkdceUSg3BB83wEcGmZrnWfrcFEU4PEYzTrcrqBFk7S9F03SmmQahxITu7P98
         9owynZWuHcUWju8byAKyV54LDWFyYAwZxW01YtyHOfOmcmgQc5Qm6nNnkh9AMv6t+Kil
         sX1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lToyp0EgaeZrIwiFmFTuf4gl0OZ3lSV2+wziFDvZU0c=;
        b=jH6vnRCb7N1y3ADJCL4fbWFPyRkHZuhNIiCFBzFxo/650bky3Ye45t+jSOc792edGV
         l5WROX1NLiYcjV+dqftoR1XREaz0iVoKMzGeKKzPS7LiEh6PLYlg8Ab1p7CVOoT31dI5
         YnbjEgyBBO05AO3f8FGeW891GMvTabJXRvl4UyXfNBwByAwOA05We5tIjjCRNxUX6mUx
         vmwkr2AzufneTi7E22PhnjicapYbnK67qpGrekXAT8T1eX9IDIQIJr3VYc1UQxk9HW4Q
         Nn6WYDlz08xj7eXvApE/ltO7AXDUZBURNZ9verqO7LJLXemxVmiuuEcyuUCqS0D8XAis
         NUGQ==
X-Gm-Message-State: ACrzQf0w+SJr+Bw0A1lsNexEctKUGxcu5vq31YIrj7xP8f13t6oBCVeu
        J9Kn24XAHInwE3CuqxczYKdzA/IR12P4J1ESeCXOkw==
X-Google-Smtp-Source: AMsMyM4l63xPJCnxqq3wUHD84HXv74JHao2lfXPNGvrT3jau3PH7lHQLU8mbdztP3lXdowg41GV/MmDJFi/pXl6U7ro=
X-Received: by 2002:a81:5a86:0:b0:36f:cece:6efd with SMTP id
 o128-20020a815a86000000b0036fcece6efdmr30814116ywb.489.1667525106247; Thu, 03
 Nov 2022 18:25:06 -0700 (PDT)
MIME-Version: 1.0
References: <20221104022723.1066429-1-luwei32@huawei.com>
In-Reply-To: <20221104022723.1066429-1-luwei32@huawei.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Nov 2022 18:24:55 -0700
Message-ID: <CANn89i+Pe+yMnGUTUbg=---VB1RO1KDfRLrZjaUVM7OHktMw2g@mail.gmail.com>
Subject: Re: [patch net v5] tcp: prohibit TCP_REPAIR_OPTIONS if data was
 already sent
To:     Lu Wei <luwei32@huawei.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com, xemul@parallels.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Thu, Nov 3, 2022 at 6:22 PM Lu Wei <luwei32@huawei.com> wrote:
>
> If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
> of TCPOPT_SACK_PERM is called to enable sack after data is sent
> and dupacks are received , it will trigger a warning in function
> tcp_verify_left_out() as follows:
>

> In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
> Step7 not happen and the warning will not be triggered. As suggested by
> Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
> already sent.
>
> socket-tcp tests in CRIU has been tested as follows:
> $ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
>        --ignore-taint
>
> socket-tcp* represent all socket-tcp tests in test/zdtm/static/.
>
> Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
> v5: modify the commit message
>  net/ipv4/tcp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
> index ef14efa1fb70..54836a6b81d6 100644
> --- a/net/ipv4/tcp.c
> +++ b/net/ipv4/tcp.c
> @@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
>         case TCP_REPAIR_OPTIONS:
>                 if (!tp->repair)
>                         err = -EINVAL;
> -               else if (sk->sk_state == TCP_ESTABLISHED)
> +               else if (sk->sk_state == TCP_ESTABLISHED && !tp->bytes_sent)
>                         err = tcp_repair_options_est(sk, optval, optlen);
>                 else
>                         err = -EPERM;
> --
> 2.31.1
>

SGTM, thanks.

Reviewed-by: Eric Dumazet <edumazet@google.com>
