Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65AD4E7C16
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiCYTZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 15:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiCYTZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 15:25:56 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012071D3069;
        Fri, 25 Mar 2022 11:57:45 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id d134so4759423ybc.13;
        Fri, 25 Mar 2022 11:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pMUdB3zlB3HAdVOnuQq2xqrqNwClgzIqakPQ1O+ryLU=;
        b=opPwPmQ9CLhSVpFfpRo/PnBU7bPVVHAPFJ1+x8z+qQd0hmCRkVKbvsaSiLtGvH7hri
         KWFRk2+QKbwa5BOQlXx+GWWjBEs1LVcfK5smQaCJNcIGlwdaJYAJbEQc4O8YDF2FK8dp
         FkmMTQxcnTuAXTULYRJT9c4v5g6IwTAoAsUpRgZCPr0gevfsCeeumVtaYvdcvYILjzc9
         ndggUmwBaFt70j4xy/UwL3Q+87A2iGWXSQYBhYfxxDuiIjjQNmcOWvR5iMOEM5RiIttx
         62+yd1ghBGIlWjr2ABqMozfiBbKKF4+Ro7YbzVDTcuC3Ty9FOj7vlzjp+BxfckRZTD+3
         m7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pMUdB3zlB3HAdVOnuQq2xqrqNwClgzIqakPQ1O+ryLU=;
        b=VsA1ytTjw03d8z+WiVrjboVkBunHQ9QhSQp8Zvxfjjfg60llg1Ftfy9XDO8X631M15
         u7Dpvtzu/bybMv5NybIldkdSnqtedH59xaHWiQr+p2WGnFSEGrQMYBNCpHIIU9B1gT7B
         4bA6VmP2hdIi+ulwABf0p0ek6q+ZvrR4Ur7JG9Ro5sG6c4JA7DecPJUnalKW3+iiiCGn
         UNoTtZrAgGPu6tLIG1pvkf6UrDEuCa2vaw/g/AArfd+w4F9M7fx1TPctmv9HUE1aFpPH
         Zu3BtWo+oMqqmFAYf71bMX1jG/5LvyNswT2xAH+nUszTZQKuDjb1Azg97b858tlxn1AV
         gj6g==
X-Gm-Message-State: AOAM533DvDixNK+cVIXEXOD8C5lTKDiU2ienZyGJJsH5+TjFf4q7gWxa
        FqQKwtfd7WBUw/aLt4Fvw+kBHN1r3fchW7f69KIs/RMV
X-Google-Smtp-Source: ABdhPJz9mZFBCIieZ8fOD5eJ9gyxfBvi/T2xMJdphBpSLz3OJ7s5HzF8ZMV1+EakSTtbiCrhnz4gCLq2e2SfDREHghk=
X-Received: by 2002:a05:6902:1009:b0:634:674f:ef16 with SMTP id
 w9-20020a056902100900b00634674fef16mr12320198ybt.459.1648234215466; Fri, 25
 Mar 2022 11:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220325033028.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
In-Reply-To: <20220325033028.1.I67f8ad854ac2f48701902bfb34d6e2070011b779@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 25 Mar 2022 11:50:04 -0700
Message-ID: <CABBYNZKF1Ye6D130XgaFmqN6JAssf78-FaQh_AEkwigy8qaVjw@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout
To:     Ying Hsu <yinghsu@chromium.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Joseph Hwang <josephsih@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ying,

On Thu, Mar 24, 2022 at 8:31 PM Ying Hsu <yinghsu@chromium.org> wrote:
>
> Connecting the same socket twice consecutively in sco_sock_connect()
> could lead to a race condition where two sco_conn objects are created
> but only one is associated with the socket. If the socket is closed
> before the SCO connection is established, the timer associated with the
> dangling sco_conn object won't be canceled. As the sock object is being
> freed, the use-after-free problem happens when the timer callback
> function sco_sock_timeout() accesses the socket. Here's the call trace:
>
> dump_stack+0x107/0x163
> ? refcount_inc+0x1c/
> print_address_description.constprop.0+0x1c/0x47e
> ? refcount_inc+0x1c/0x7b
> kasan_report+0x13a/0x173
> ? refcount_inc+0x1c/0x7b
> check_memory_region+0x132/0x139
> refcount_inc+0x1c/0x7b
> sco_sock_timeout+0xb2/0x1ba
> process_one_work+0x739/0xbd1
> ? cancel_delayed_work+0x13f/0x13f
> ? __raw_spin_lock_init+0xf0/0xf0
> ? to_kthread+0x59/0x85
> worker_thread+0x593/0x70e
> kthread+0x346/0x35a
> ? drain_workqueue+0x31a/0x31a
> ? kthread_bind+0x4b/0x4b
> ret_from_fork+0x1f/0x30
>
> Signed-off-by: Ying Hsu <yinghsu@chromium.org>
> Reviewed-by: Joseph Hwang <josephsih@chromium.org>
> ---
> Tested this commit using a C reproducer on qemu-x86_64 for 8 hours.

We should probably add a link or something to the reproducer then, was
it syzbot? It does have some instructions on how to link its issues.

>  net/bluetooth/sco.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/net/bluetooth/sco.c b/net/bluetooth/sco.c
> index 8eabf41b2993..380c63194736 100644
> --- a/net/bluetooth/sco.c
> +++ b/net/bluetooth/sco.c
> @@ -574,19 +574,24 @@ static int sco_sock_connect(struct socket *sock, struct sockaddr *addr, int alen
>             addr->sa_family != AF_BLUETOOTH)
>                 return -EINVAL;
>
> -       if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND)
> -               return -EBADFD;
> +       lock_sock(sk);
> +       if (sk->sk_state != BT_OPEN && sk->sk_state != BT_BOUND) {
> +               err = -EBADFD;
> +               goto done;
> +       }
>
> -       if (sk->sk_type != SOCK_SEQPACKET)
> -               return -EINVAL;
> +       if (sk->sk_type != SOCK_SEQPACKET) {
> +               err = -EINVAL;
> +               goto done;
> +       }
>
>         hdev = hci_get_route(&sa->sco_bdaddr, &sco_pi(sk)->src, BDADDR_BREDR);
> -       if (!hdev)
> -               return -EHOSTUNREACH;
> +       if (!hdev) {
> +               err = -EHOSTUNREACH;
> +               goto done;
> +       }
>         hci_dev_lock(hdev);
>
> -       lock_sock(sk);
> -

Also are we sure we are not introducing a locking hierarchy problem
here? Previously we had hci_dev_lock then sock_lock now it is the
opposite, or perhaps we never want to have them at the same time?

>         /* Set destination address and psm */
>         bacpy(&sco_pi(sk)->dst, &sa->sco_bdaddr);
>
> --
> 2.35.1.1021.g381101b075-goog
>


-- 
Luiz Augusto von Dentz
