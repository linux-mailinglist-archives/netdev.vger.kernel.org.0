Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE4A261F61
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 22:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732646AbgIHUC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 16:02:26 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:51343 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730504AbgIHPel (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:34:41 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 83cb8164
        for <netdev@vger.kernel.org>;
        Tue, 8 Sep 2020 14:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=7N+w6kF7E0t5Uk3YN/81VBi5JP8=; b=VuAkIl
        Itj15IoZZINWbVlMfqt095SNhfstPxIdR6wCEt20s57hwB4f4rqo3Qc0yB6QHyTX
        dVjiyrTW5xs1xYlPvR7fVQ7GVhW0AwTw3KuxxFlovgIXnzUknqj46uvE6DP1z1Mf
        AgAzDXSZ51xmQQ8PDAOV3z9SzvhEWiKLE4WP4ETBL7qpfPIsB4AygmzTFzBd6NnZ
        ovWVeaLmXS0x564P24DaHk/FmMRhhWQCjx/h603GRtc4H0UwhD16J6B04EaBiC3o
        ruDnrMIPdSfV3CNhKUs0JG0RY0DbH+0xR67Dqg+jNUMNK0KIfwOur4YlAQhRLFLu
        U7E2fCG+JL6mDtvw==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a94ea228 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Tue, 8 Sep 2020 14:57:15 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id d190so17526588iof.3
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 08:26:09 -0700 (PDT)
X-Gm-Message-State: AOAM531CaQhh7MYgDtbMEfaEQXF8PM6dggiOG5wsmtCROFFbez0aHMUi
        IvrqsSfF+KsJ2CY0jztVdsb+8L1ax2Ttd6dpIKY=
X-Google-Smtp-Source: ABdhPJw9Fax3meqqSqqUE1/U9G0Fj74FgZShwJy2QUoc8l2nSwvdSkxd/y/U0NP2RxNtMkno7Plyroz+rmnjcspNDrc=
X-Received: by 2002:a6b:7112:: with SMTP id q18mr21017767iog.79.1599578768890;
 Tue, 08 Sep 2020 08:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200908145911.4090480-1-edumazet@google.com>
In-Reply-To: <20200908145911.4090480-1-edumazet@google.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 8 Sep 2020 17:25:58 +0200
X-Gmail-Original-Message-ID: <CAHmME9qG6ceo+ZYncHOJ1+PE_bv74suN5LAv1gFUTHaBy31p7A@mail.gmail.com>
Message-ID: <CAHmME9qG6ceo+ZYncHOJ1+PE_bv74suN5LAv1gFUTHaBy31p7A@mail.gmail.com>
Subject: Re: [PATCH net] wireguard: fix race in wg_index_hashtable_replace()
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Eric,

On Tue, Sep 8, 2020 at 4:59 PM Eric Dumazet <edumazet@google.com> wrote:
>
> syzbot got a NULL dereference in wg_index_hashtable_replace() [1]
>
> Issue here is that right after checking hlist_unhashed(&old->index_hash)
> another cpu might have removed @old already from the hash.
>
> Since we are dealing with a very unlikely case, we can simply
> acquire the table lock earlier.

That's a nice bug. It looks like this is triggered by a teardown race,
when wg_index_hashtable_replace races with wg_index_hashtable_remove.

Since all the other hashtable mutator functions are protected by that
spinlock, it doesn't seem harmful to fix this by doing the same, even
if formally that spinlock is supposed to protect hash bucket heads
rather than entry pointers.

I'm playing with your patch and a variant of it, which I'll have
queued up in my tree in the next hour or so.

Thanks a lot for triaging this.

Jason
