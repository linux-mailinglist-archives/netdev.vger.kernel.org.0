Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB052601872
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiJQUBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbiJQUB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:01:29 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EEAA38B;
        Mon, 17 Oct 2022 13:01:23 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id i17so14343613lja.3;
        Mon, 17 Oct 2022 13:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OtfQx4B0WLYP5dmQVlOMcfd8LBC7vW+UVsItGtOvBCA=;
        b=bbolFJSshQHmSaJsnuQPr/nEKD0L8/upvlaXfWgUE10V6j/txqguUvQdLn+/8xv7hB
         F/A3y/rlDLDtkREa9ZfKMOWbdR+/OysfAPuWfqoAtE1V3rHMyDVg4PcgGoPGQmx25c9+
         GkCDQ0trvbyZz1HInGwtaNh4mmsnk3dVPWvxBDNjXD7pl15bG36lZ+gkUCQAyS4Cm9Xe
         EGITBPQUVzbPTpetvacMzkIeq4OyQCxc5EkoyvK52yfn0UTEYcvzwXg8RwpASI8f9Jf3
         xxfxinH0PSZVNprYXr6dj7DYuq7wWX1YhPWi0MHv7LTcUA1YSnkKwaMOT9Plj7QTzaCu
         r5Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OtfQx4B0WLYP5dmQVlOMcfd8LBC7vW+UVsItGtOvBCA=;
        b=h625kLKL58bVqGMhT72NMVbuJFYU2qvoov/jwc4ehpqb4UbPEUBa6ALJkjdkEnUJUz
         opsU35ehXPES8nFy6aalQ8tlxrLAgbws1xtUxwBg92ww5Wp167mklxD2yVoYDfqDNYWQ
         Jb2tW8RvBafVYsv0JIDX22JjrwaENhA80+oO3rUf/rBOW7Z9YAXPSG0p/WSFUvDCCrRv
         UO1SBoFkuaRdz0t8v50S3kDGfOwMFSIQfxeFZfCTaPBryBePc/gwDTguGjHYS4CbGJvY
         R5yWvbES7mGN+KlEAb0kVYW8IA8LTYwJClC1edRNSrzD5CkOQrKDpjvcGReFOGTYZ7OB
         iV0w==
X-Gm-Message-State: ACrzQf3v8sOiI/TMFvkqbDYr7qO56CYF+BxvcfOhNXiRdkjPOKur7Z8T
        4zsAlX2IIS6y6bW+NrUPb7ieG/ALO8aI/rtAzsc=
X-Google-Smtp-Source: AMsMyM6rwiKSkKPokCPazH9o9WFi7My7b7SwvLIVMs5xialnPfmJDCBBUBzpKBru7cG1SBFt/4wsBM+NxXfGJoct8wg=
X-Received: by 2002:a05:651c:1310:b0:26f:c102:b73b with SMTP id
 u16-20020a05651c131000b0026fc102b73bmr4699400lja.432.1666036881999; Mon, 17
 Oct 2022 13:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20221017074432.12177-1-yin31149@gmail.com>
In-Reply-To: <20221017074432.12177-1-yin31149@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 17 Oct 2022 13:01:10 -0700
Message-ID: <CABBYNZ+ycRfx3JQNwfCzXBP3G=+a=5qkdExkC2rV5+wiHUBTeA@mail.gmail.com>
Subject: Re: [PATCH] Bluetooth: L2CAP: Fix memory leak in vhci_write
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, 18801353760@163.com,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hawkins,

On Mon, Oct 17, 2022 at 12:47 AM Hawkins Jiawei <yin31149@gmail.com> wrote:
>
> Syzkaller reports a memory leak as follows:
> ====================================
> BUG: memory leak
> unreferenced object 0xffff88810d81ac00 (size 240):
>   [...]
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff838733d9>] __alloc_skb+0x1f9/0x270 net/core/skbuff.c:418
>     [<ffffffff833f742f>] alloc_skb include/linux/skbuff.h:1257 [inline]
>     [<ffffffff833f742f>] bt_skb_alloc include/net/bluetooth/bluetooth.h:469 [inline]
>     [<ffffffff833f742f>] vhci_get_user drivers/bluetooth/hci_vhci.c:391 [inline]
>     [<ffffffff833f742f>] vhci_write+0x5f/0x230 drivers/bluetooth/hci_vhci.c:511
>     [<ffffffff815e398d>] call_write_iter include/linux/fs.h:2192 [inline]
>     [<ffffffff815e398d>] new_sync_write fs/read_write.c:491 [inline]
>     [<ffffffff815e398d>] vfs_write+0x42d/0x540 fs/read_write.c:578
>     [<ffffffff815e3cdd>] ksys_write+0x9d/0x160 fs/read_write.c:631
>     [<ffffffff845e0645>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>     [<ffffffff845e0645>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>     [<ffffffff84600087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> ====================================
>
> HCI core will uses hci_rx_work() to process frame, which is queued to
> the hdev->rx_q tail in hci_recv_frame() by HCI driver.
>
> Yet the problem is that, HCI core does not free the skb after handling
> ACL data packets. To be more specific, when start fragment does not
> contain the L2CAP length, HCI core just reads possible bytes and
> finishes frame process in l2cap_recv_acldata(), without freeing the skb,
> which triggers the above memory leak.
>
> This patch solves it by releasing the relative skb, after processing the
> above case in l2cap_recv_acldata()
>
> Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
> Link: https://lore.kernel.org/all/0000000000000d0b1905e6aaef64@google.com/
> Reported-and-tested-by: syzbot+8f819e36e01022991cfa@syzkaller.appspotmail.com
> Signed-off-by: Hawkins Jiawei <yin31149@gmail.com>
> ---
>  net/bluetooth/l2cap_core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 1f34b82ca0ec..e0a00854c02e 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -8426,9 +8426,8 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
>                  * expected length.
>                  */
>                 if (skb->len < L2CAP_LEN_SIZE) {
> -                       if (l2cap_recv_frag(conn, skb, conn->mtu) < 0)
> -                               goto drop;
> -                       return;
> +                       l2cap_recv_frag(conn, skb, conn->mtu);
> +                       goto drop;

Let us use break; instead of goto drop since we have copied the skb into rx_sbk.

>                 }
>
>                 len = get_unaligned_le16(skb->data) + L2CAP_HDR_SIZE;
> @@ -8472,7 +8471,7 @@ void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
>
>                         /* Header still could not be read just continue */
>                         if (conn->rx_skb->len < L2CAP_LEN_SIZE)
> -                               return;
> +                               goto drop;
>                 }
>
>                 if (skb->len > conn->rx_len) {
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
