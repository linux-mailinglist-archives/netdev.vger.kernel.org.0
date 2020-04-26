Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF7201B93C8
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 21:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgDZTw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 15:52:59 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:42241 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726171AbgDZTw7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 26 Apr 2020 15:52:59 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4234d2d7;
        Sun, 26 Apr 2020 19:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=hFPaJylJBtGuVDFNSlAKx8BfCy4=; b=zfvrZ2
        zRKJWRr5WKRl/cFmJwkXS3woumJPnHJYRXPgRAD8/lE96qS8V14Y6VM/iw43ltIt
        QH7Ujn+2bcOA5+X66WrVicoVT5Q3c9cABDAJmRPwBfy+QKdKFHZAXgbnKX5kIwg0
        RUTCjCPnIEBUKKRwTN26mNcB1xyAU8DN5X1x7pcPT8vtwxnQ0S8Q8CgG/jIFrVv7
        G/t228erdsQkiXFFHa+9C5MYzEBckXDhgdqiflE6s7YIB9gJotas9UhJwYIUFtbY
        I1KYpsBMxRV/exQoPR8kpdC9HjjtqjmLUVezIQ0bx548bis7E8y9KKrdl1Dv4Yub
        yAkIzWObrl9cNNvA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id f4718d32 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Sun, 26 Apr 2020 19:41:32 +0000 (UTC)
Received: by mail-il1-f171.google.com with SMTP id s10so14712799iln.11;
        Sun, 26 Apr 2020 12:52:57 -0700 (PDT)
X-Gm-Message-State: AGi0PubZw6uEXqPB8HscbDaXAC059QUg03shMeNHKwogIvu8q4e0l65J
        KyAIopJ3wl/k2iCzIPI9dmZk2xM0uouZq0fUwro=
X-Google-Smtp-Source: APiQypKWR1kPZMsj7G23BDHeamJD24j7N4WJFHC0YyaebHjrfsFGWkBXzNp/eJtifanT7be3tT0fDVxn98lqpOK/+i0=
X-Received: by 2002:a92:5f46:: with SMTP id t67mr17415358ilb.64.1587930776486;
 Sun, 26 Apr 2020 12:52:56 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005fd19505a4355311@google.com> <e40c443e-74aa-bad4-7be8-4cdddfdf3eaf@gmail.com>
 <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
In-Reply-To: <CAHmME9ov2ae08UTzwKL7enquChzDNxpg4c=ppnJqS2QF6ZAn_Q@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 26 Apr 2020 13:52:45 -0600
X-Gmail-Original-Message-ID: <CAHmME9rxYkDhH3Fj-U24Ho7oGcdABK9hXsACPDQ1rz9WUcEuSQ@mail.gmail.com>
Message-ID: <CAHmME9rxYkDhH3Fj-U24Ho7oGcdABK9hXsACPDQ1rz9WUcEuSQ@mail.gmail.com>
Subject: Re: INFO: rcu detected stall in wg_packet_tx_worker
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     syzbot <syzbot+0251e883fe39e7a0cb0a@syzkaller.appspotmail.com>,
        David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        jhs@mojatatu.com,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Krzysztof Kozlowski <krzk@kernel.org>, kuba@kernel.org,
        kvalo@codeaurora.org, leon@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, syzkaller-bugs@googlegroups.com,
        Thomas Gleixner <tglx@linutronix.de>, vivien.didelot@gmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It looks like part of the issue might be that I call
udp_tunnel6_xmit_skb while holding rcu_read_lock_bh, in
drivers/net/wireguard/socket.c. But I think there's good reason to do
so, and udp_tunnel6_xmit_skb should be rcu safe. In fact,
every.single.other user of udp_tunnel6_xmit_skb in the kernel uses it
with rcu locked. So, hm...
