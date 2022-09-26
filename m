Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A52F35EADA5
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 19:08:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiIZRIn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 13:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbiIZRIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 13:08:11 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3B1B1B
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:14:42 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3487d84e477so73713077b3.6
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 09:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Oa22a4endrdosLQtjKEFeFefuX/MjZONJZ0tmRFJeYE=;
        b=Xcaxd7QgQL2IcEwtg+vNfLwEekd4cHBrZaazpr3DU/38jZEJX1ocaDz1zISiAWAKvC
         8wxrhE06bC55k0dR1zNntQJE8VcipXgLfhIhp1jl7ykftpCw6oN7OnMJCn5go/Ex04n7
         yIP7Td6YHKfXXD2NVZzz+EeWQqhBvxHw0mBiXXRDEk3SyvHNbTG0ICfDIaYE59uYbF35
         AovdLeGuTkhOSON7gfgxC7vcTEgLaOzHfC7ranIKnTeAit/G/C5kFXtxdMwKqg9szIEh
         QwnKxA5KZy6q6+JmZ1fSrOFRfqv9j/eerkZBqZj7rc0LhZsoWNKWiWi0rwqdTXgSSsaw
         dJnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=Oa22a4endrdosLQtjKEFeFefuX/MjZONJZ0tmRFJeYE=;
        b=4TvS/2/nHfHV3kzWbCz8o8s06qfMA2RQWhb+xvyB9h8tlYn95jtfNTnqyfUtma/U30
         cVR7wzKUbSvgufWGlUmnLOZgzP8GdU+ekX+bZYW8V0HNz8zyZZcbQgVCSoEeuBcD6eau
         HWw1IymqqLfOSH/haum+G0V17541EyQqGb/TbHku9Y33yP9yU++h7pDj4huW8qkSgtnc
         sXrxzlQGbd25w74DvPYAqmD7ILSdeUVgEtJzotxnGUqXU2xJ19qUk4dn2BPWktJNud4h
         FW89b0he0l7rNX21COaQQO79W7XkBopL3ed7wsd2/GB3fEoY9sTw5pHI7PZ7ZXYkeWoQ
         qweQ==
X-Gm-Message-State: ACrzQf0wsh4x5JtuseEo2N8g1vx5MsCJQqfX+2a5ouHhQPiYNQ1wjJFF
        D4tm/8tm8WUKbITDj/+mvX/aeURap6Fd06RNNLB4mA==
X-Google-Smtp-Source: AMsMyM7OpsvJSztac/ShiuiEHAZkAj0TrkjdKAI1u/34ICh1qE+XmXzoZDMtkGtQDB4ENnSqBFCdi9T4zixSGEFU5AA=
X-Received: by 2002:a81:451:0:b0:350:935c:613e with SMTP id
 78-20020a810451000000b00350935c613emr9977971ywe.55.1664208881510; Mon, 26 Sep
 2022 09:14:41 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000070db2005e95a5984@google.com> <20220926150907.8551-1-yin31149@gmail.com>
In-Reply-To: <20220926150907.8551-1-yin31149@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 26 Sep 2022 09:14:29 -0700
Message-ID: <CANn89i+vx3MJ8D1zz1jUh2XZbFvPicC1RwzREzYXc_TvAFBVxg@mail.gmail.com>
Subject: Re: [PATCH] wext: use flex array destination for memcpy()
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        18801353760@163.com, Kees Cook <keescook@chromium.org>
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

On Mon, Sep 26, 2022 at 8:09 AM Hawkins Jiawei <yin31149@gmail.com> wrote:
>
> Syzkaller reports refcount bug as follows:

This has nothing to do with a refcount bug...

> ------------[ cut here ]------------


> memcpy: detected field-spanning write (size 8) of single field
>         "&compat_event->pointer" at net/wireless/wext-core.c:623 (size 4)
> WARNING: CPU: 0 PID: 3607 at net/wireless/wext-core.c:623
>         wireless_send_event+0xab5/0xca0 net/wireless/wext-core.c:623
> Modules linked in:
> CPU: 1 PID: 3607 Comm: syz-executor659 Not tainted
>         6.0.0-rc6-next-20220921-syzkaller #0
> [...]
> Call Trace:
>  <TASK>
>  ioctl_standard_call+0x155/0x1f0 net/wireless/wext-core.c:1022
>  wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
>  wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
>  wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
>  wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
>  sock_ioctl+0x285/0x640 net/socket.c:1220
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:870 [inline]
>  __se_sys_ioctl fs/ioctl.c:856 [inline]
>  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>  [...]
>  </TASK>
>
> Wireless events will be sent on the appropriate channels in
> wireless_send_event(). Different wireless events may have different
> payload structure and size, so kernel uses **len** and **cmd** field
> in struct __compat_iw_event as wireless event common LCP part, uses
> **pointer** as a label to mark the position of remaining different part.
>
> Yet the problem is that, **pointer** is a compat_caddr_t type, which may
> be smaller than the relative structure at the same position. So during
> wireless_send_event() tries to parse the wireless events payload, it may
> trigger the memcpy() run-time destination buffer bounds checking when the
> relative structure's data is copied to the position marked by **pointer**.
>
> This patch solves it by introducing flexible-array field **ptr_bytes**,
> to mark the position of the wireless events remaining part next to
> LCP part. What's more, this patch also adds **ptr_len** variable in
> wireless_send_event() to improve its maintainability.
>
> Reported-and-tested-by: syzbot+473754e5af963cf014cf@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/all/00000000000070db2005e95a5984@google.com/
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
>  include/linux/wireless.h | 10 +++++++++-
>  net/wireless/wext-core.c | 17 ++++++++++-------
>  2 files changed, 19 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/wireless.h b/include/linux/wireless.h
> index 2d1b54556eff..e6e34d74dda0 100644
> --- a/include/linux/wireless.h
> +++ b/include/linux/wireless.h
> @@ -26,7 +26,15 @@ struct compat_iw_point {
>  struct __compat_iw_event {
>         __u16           len;                    /* Real length of this stuff */
>         __u16           cmd;                    /* Wireless IOCTL */
> -       compat_caddr_t  pointer;
> +
> +       union {
> +               compat_caddr_t  pointer;
> +
> +               /* we need ptr_bytes to make memcpy() run-time destination
> +                * buffer bounds checking happy, nothing special
> +                */
> +               DECLARE_FLEX_ARRAY(__u8, ptr_bytes);
> +       };
>  };
>  #define IW_EV_COMPAT_LCP_LEN offsetof(struct __compat_iw_event, pointer)
>  #define IW_EV_COMPAT_POINT_OFF offsetof(struct compat_iw_point, length)
> diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
> index 76a80a41615b..fe8765c4075d 100644
> --- a/net/wireless/wext-core.c
> +++ b/net/wireless/wext-core.c
> @@ -468,6 +468,7 @@ void wireless_send_event(struct net_device *        dev,
>         struct __compat_iw_event *compat_event;
>         struct compat_iw_point compat_wrqu;
>         struct sk_buff *compskb;
> +       int ptr_len;
>  #endif
>
>         /*
> @@ -582,6 +583,9 @@ void wireless_send_event(struct net_device *        dev,
>         nlmsg_end(skb, nlh);
>  #ifdef CONFIG_COMPAT
>         hdr_len = compat_event_type_size[descr->header_type];
> +
> +       /* ptr_len is remaining size in event header apart from LCP */
> +       ptr_len = hdr_len - IW_EV_COMPAT_LCP_LEN;
>         event_len = hdr_len + extra_len;
>
>         compskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
> @@ -612,16 +616,15 @@ void wireless_send_event(struct net_device *      dev,
>         if (descr->header_type == IW_HEADER_TYPE_POINT) {
>                 compat_wrqu.length = wrqu->data.length;
>                 compat_wrqu.flags = wrqu->data.flags;
> -               memcpy(&compat_event->pointer,
> -                       ((char *) &compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
> -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> +               memcpy(compat_event->ptr_bytes,
> +                      ((char *)&compat_wrqu) + IW_EV_COMPAT_POINT_OFF,
> +                       ptr_len);
>                 if (extra_len)
> -                       memcpy(((char *) compat_event) + hdr_len,
> -                               extra, extra_len);
> +                       memcpy(&compat_event->ptr_bytes[ptr_len],
> +                              extra, extra_len);
>         } else {
>                 /* extra_len must be zero, so no if (extra) needed */
> -               memcpy(&compat_event->pointer, wrqu,
> -                       hdr_len - IW_EV_COMPAT_LCP_LEN);
> +               memcpy(compat_event->ptr_bytes, wrqu, ptr_len);
>         }
>
>         nlmsg_end(compskb, nlh);
> --
> 2.25.1
>
