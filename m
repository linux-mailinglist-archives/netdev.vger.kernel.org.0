Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 351823611C3
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 20:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234457AbhDOSLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 14:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233609AbhDOSLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 14:11:09 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C698CC061574
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:10:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id p19so12967793wmq.1
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 11:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3MoAcLYy17K8X9UNftdCqYkfKG14fIL+HbkkjJtMVwk=;
        b=COo6x3DYMIG2a6zDfnWu2eCeO71dLB/6+RQvnYYrZSpoD/nXQi2DkdDdUM6TGoKcbL
         L5XnV+sKimOo/+eD0fM0UAMBz6k1rUph5T2wi0dOZss9Z4LwSKkyIJiyrUWq4Jhrq0+K
         97tomApEZuVs1W+ok3SDDULCb9bhlqQOlN7OCBE5XDCvtS1MjouTNZYPsHbRkdiiMafn
         kOGxa7vTe1h5ONeZRFHyQpH+BpnWqIgvibzQ7PNH3ewo39qt3FBOGYsI45U02znzzkU7
         qGdn67cc5diUH5bZk5CEzzYAgHwvDEXYkZd0Dfo0YpXmzGgx4uPyC6IbKaJxI2f5SwR7
         x3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3MoAcLYy17K8X9UNftdCqYkfKG14fIL+HbkkjJtMVwk=;
        b=pZImNnhBe0YbjrmpEx27sIGJR+B+vFy+lcMRDtxnqf9vetDNYNXg6akReiJr5dHr+V
         VNh7uwwgErrAiRsdWYUb6tpUL9S8VSsDAe3HLO1ZpY/zai4aPTf+03O2IMipgKgljZXy
         sOgGGDMN/dRUHcROBofAQEUOcU4xV9wC2MXg1gW8lsEUVwtk8ScKtY/jS7AYLdfEINVy
         kvkdbc+SmQHzONNdFA9/XDwzt0uGdGm7Iw1H//CArgm6LHm5Ii90VaqIindPQPDhvQSb
         4aNb6kHjEiLoaZago7y0VUpR50BU9p8v9xBfsD1ZN+WHQm8VfVNOAXYLWlCAPzxnMgRE
         s2Yw==
X-Gm-Message-State: AOAM530JxCMaYITeOb3XoRs87bg/AZk+MupU2Lq+jVaEApeTtzpUMB7C
        +BTS8Wec7J1Rnm6va6UlrNFg0F9gXa2tWaNJhPwh+g==
X-Google-Smtp-Source: ABdhPJzSkxDfwJizeo5rHEVc+Ho0G2cr5UR0O89B0xIzLpfZ6P2KnKn9DyOCOOh23lMX3uVA7PzODzDMIOX2S77/EvQ=
X-Received: by 2002:a7b:c1d2:: with SMTP id a18mr4231870wmj.108.1618510243315;
 Thu, 15 Apr 2021 11:10:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210415173753.3404237-1-eric.dumazet@gmail.com>
In-Reply-To: <20210415173753.3404237-1-eric.dumazet@gmail.com>
From:   Soheil Hassas Yeganeh <soheil@google.com>
Date:   Thu, 15 Apr 2021 14:10:07 -0400
Message-ID: <CACSApvZU=G6D7rM+dfem0TAyk8Qbu4EkM=SehNSqRDwPTf0nmQ@mail.gmail.com>
Subject: Re: [PATCH net-next] scm: optimize put_cmsg()
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 15, 2021 at 1:38 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> From: Eric Dumazet <edumazet@google.com>
>
> Calling two copy_to_user() for very small regions has very high overhead.
>
> Switch to inlined unsafe_put_user() to save one stac/clac sequence,
> and avoid copy_to_user().
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Soheil Hassas Yeganeh <soheil@google.com>

Acked-by: Soheil Hassas Yeganeh <soheil@google.com>

Very nice! Thank you, Eric!

> ---
>  net/core/scm.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/net/core/scm.c b/net/core/scm.c
> index 8156d4fb8a3966122fdfcfd0ebc9e5520aa7b67c..bd96c922041d22a2f3b7ee73e4b3183316f9b616 100644
> --- a/net/core/scm.c
> +++ b/net/core/scm.c
> @@ -228,14 +228,16 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
>
>         if (msg->msg_control_is_user) {
>                 struct cmsghdr __user *cm = msg->msg_control_user;
> -               struct cmsghdr cmhdr;
>
> -               cmhdr.cmsg_level = level;
> -               cmhdr.cmsg_type = type;
> -               cmhdr.cmsg_len = cmlen;
> -               if (copy_to_user(cm, &cmhdr, sizeof cmhdr) ||
> -                   copy_to_user(CMSG_USER_DATA(cm), data, cmlen - sizeof(*cm)))
> -                       return -EFAULT;
> +               if (!user_write_access_begin(cm, cmlen))
> +                       goto efault;
> +
> +               unsafe_put_user(len, &cm->cmsg_len, efault_end);
> +               unsafe_put_user(level, &cm->cmsg_level, efault_end);
> +               unsafe_put_user(type, &cm->cmsg_type, efault_end);
> +               unsafe_copy_to_user(CMSG_USER_DATA(cm), data,
> +                                   cmlen - sizeof(*cm), efault_end);
> +               user_write_access_end();
>         } else {
>                 struct cmsghdr *cm = msg->msg_control;
>
> @@ -249,6 +251,11 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
>         msg->msg_control += cmlen;
>         msg->msg_controllen -= cmlen;
>         return 0;
> +
> +efault_end:
> +       user_write_access_end();
> +efault:
> +       return -EFAULT;
>  }
>  EXPORT_SYMBOL(put_cmsg);
>
> --
> 2.31.1.368.gbe11c130af-goog
>
