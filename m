Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850E82DF6DF
	for <lists+netdev@lfdr.de>; Sun, 20 Dec 2020 22:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgLTVLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Dec 2020 16:11:54 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:38439 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727130AbgLTVLx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 20 Dec 2020 16:11:53 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id ce323d38
        for <netdev@vger.kernel.org>;
        Sun, 20 Dec 2020 21:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=zmDED1Y+07Jzv5N5n9KH6ZmggEQ=; b=TlHwmD
        ZGs0AMG7W1B76oAS2fgJDNIKPKU1NDV3KZFmW4eTpQ80UZWQToQ1V0vBUVcT4VA0
        MMtunVyFA0qtfWpTaFVq85TjuNN/xgiylil0Am72aNbMjUi8q75nHqi2T2l8l2jV
        W5nR1jb1b9tJHczXi8NC2DYpQRfhLzx/gioVYh04RMpFrdA1hWEENNqN+f2CKuX7
        ABLF1jERPlpKPDwac55aUOflyQ6/E00ZzSR9njSirczWd2C8UAYETH8M9D6696DD
        p7CdU68yZEDgNgaQkep/ONBvl9x75Sc9xT3QNnYPOa/DH669E2xXIggj2izFo8bz
        DnCBi5ftlTW2Lupw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f7036f09 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sun, 20 Dec 2020 21:03:00 +0000 (UTC)
Received: by mail-yb1-f181.google.com with SMTP id w135so7095920ybg.13
        for <netdev@vger.kernel.org>; Sun, 20 Dec 2020 13:11:11 -0800 (PST)
X-Gm-Message-State: AOAM530W8RttfyVoOwXOS9WxpH+Oj9jNfhd6e1q6G3nZLmtSmzLZPnQ4
        bWAvDDvMcvQto/A2eR9fExq1SzMgFan+Z4ICHS4=
X-Google-Smtp-Source: ABdhPJzwDxy3f0LzIY+2Z+AQrvE7snpg47zmrQJtcuWWdaZy2pS0N6uFr10oKvcfkZu+YsLadEXVlHGoUZbqIsmdbjg=
X-Received: by 2002:a25:4845:: with SMTP id v66mr15227490yba.178.1608498670933;
 Sun, 20 Dec 2020 13:11:10 -0800 (PST)
MIME-Version: 1.0
References: <000000000000e13e2905b6e830bb@google.com>
In-Reply-To: <000000000000e13e2905b6e830bb@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 20 Dec 2020 22:11:00 +0100
X-Gmail-Original-Message-ID: <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
Message-ID: <CAHmME9qwbB7kbD=1sg_81=82vO07XMV7GyqBcCoC=zwM-v47HQ@mail.gmail.com>
Subject: Re: UBSAN: object-size-mismatch in wg_xmit
To:     Netdev <netdev@vger.kernel.org>
Cc:     syzkaller-bugs@googlegroups.com,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hmm, on first glance, I'm not sure I'm seeing the bug:

On Sun, Dec 20, 2020 at 5:54 PM syzbot
<syzbot+8f90d005ab2d22342b6d@syzkaller.appspotmail.com> wrote:
> UBSAN: object-size-mismatch in ./include/linux/skbuff.h:2021:28
> member access within address 0000000085889cc2 with insufficient space
> for an object of type 'struct sk_buff'
>  __skb_queue_before include/linux/skbuff.h:2021 [inline]
>  __skb_queue_tail include/linux/skbuff.h:2054 [inline]
>  wg_xmit+0x45d/0xdf0 drivers/net/wireguard/device.c:182

The code in question is:

        struct sk_buff_head packets;
        __skb_queue_head_init(&packets);
...
        skb_list_walk_safe(skb, skb, next) {
               skb_mark_not_on_list(skb);

               skb = skb_share_check(skb, GFP_ATOMIC);
               if (unlikely(!skb))
                       continue;
...
               __skb_queue_tail(&packets, skb);
       }

We're in a netdev's xmit function, so nothing else should have skb at
that point. Given the warning is about "member access", I assume it's
the next->prev dereference here:

static inline void __skb_queue_before(struct sk_buff_head *list,
                                     struct sk_buff *next,
                                     struct sk_buff *newsk)
{
       __skb_insert(newsk, next->prev, next, list);
}

So where is "next" coming from that UBSAN would complain about
object-size-mismatch?

static inline void __skb_queue_tail(struct sk_buff_head *list,
                                  struct sk_buff *newsk)
{
       __skb_queue_before(list, (struct sk_buff *)list, newsk);
}

It comes from casting "list" into an sk_buff. While this might be some
CFI-violating polymorphism, I can't see why this cast would actually
be a problem in practice. The top of sk_buff is intentionally the same
as sk_buff_head:

struct sk_buff_head {
       struct sk_buff  *next;
       struct sk_buff  *prev;
...
struct sk_buff {
       union {
               struct {
                       struct sk_buff          *next;
                       struct sk_buff          *prev;
...

I'd suspect, "oh maybe it's just a clang 11 bug", but syzbot says it
can't reproduce. So that makes me a little more nervous.

Does anybody see something I've missed?

Jason
