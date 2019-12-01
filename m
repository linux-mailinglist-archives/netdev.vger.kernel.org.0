Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC0B10E26A
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 16:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfLAPwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 10:52:41 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35643 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfLAPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Dec 2019 10:52:40 -0500
Received: by mail-lj1-f196.google.com with SMTP id j6so28047791lja.2
        for <netdev@vger.kernel.org>; Sun, 01 Dec 2019 07:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l19Fdg/fv/nWXTklwCIzDNkaeZWyglfRZtL5j2GsPg0=;
        b=d/bUG9G8ZbkvovQYggaGlTyBXJvNQAbrqI5mTCQFFT5v3G5/0ibx0WTX0HC7CQbxhz
         31i6yccXadK+9nUvwynGfcqErXYKs2ROUvdpEC4Cd1BjRE0z20bSzxqwUYvY7M3KncvO
         vz6K+OT5rNOjSuVAtbKF+lujeDaYsfZyGO/g+DTwvSV0meaTt/JeOhy73/FgQfEZ+7BR
         ygdLDKUCqZDGz8RG6MReCifrJhVNI5Yd7vPXvYVaZd+DuU7dlkCAtYH58xNZgVY5zYuA
         5XxwOwqa1DmK586kFqZdDUzqBNPTwcuMv2b95U65t2R7tMeMR9qZbS2vS2t/gLVbnwyQ
         t5Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l19Fdg/fv/nWXTklwCIzDNkaeZWyglfRZtL5j2GsPg0=;
        b=GSBgjj94exntqNg1i+s3K+pn0t8kGlzyO7DnLMw6oOQTMayTOmCm0Di4+wnHH5Ybdc
         KJHue843gxv69NyIabyWFGeCyaXkLifhAR7kAhGMkMuDx3Mu5JxO9qbDEKkFHtPnQ9ql
         Qs8qDinc1blZUsxRh0OnD6F+ysbmzzVS8uZocd5pHczMgOQejlJ1FLOd24rNz9i3AjMR
         4iGESmEzncktuaT0/Hi5Dp1voXlQ5hmLa7oCDTAp/yGvrJ7HjugD8C9/6HuqSvpxwUMP
         RMgbXNXe/jZxAJbiFw39XhgkzuzWseVktFRauTw6ZD6Mj4Vy1CBwoo5yqvwe7efVI1RL
         Zg9w==
X-Gm-Message-State: APjAAAX23K7qUw1cXf2EpFOGO7DzLp+hVDliBK/ea3MKvTxtY0E4E4Q8
        QrInpflzCVdEcLDD3VU0+1HokB+g00xE3WUfBL0=
X-Google-Smtp-Source: APXvYqwYpRyG9YwHiR9dP8/bsURv0qDumM7Ds5btZ6LrAtfYuUYuuBxCQ5Emk2jIXeFsk3jCbIt+G+UuxND42mxxC2c=
X-Received: by 2002:a05:651c:1b5:: with SMTP id c21mr29154677ljn.115.1575215558686;
 Sun, 01 Dec 2019 07:52:38 -0800 (PST)
MIME-Version: 1.0
References: <20191130142400.3930-1-ap420073@gmail.com> <20191130.103411.2158582570201430879.davem@davemloft.net>
In-Reply-To: <20191130.103411.2158582570201430879.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Mon, 2 Dec 2019 00:52:27 +0900
Message-ID: <CAMArcTVUo+fwUGEX1KbsxjfZWQdJCCMboVx_XOe-S0A_UtoZWQ@mail.gmail.com>
Subject: Re: [net PATCH] hsr: fix a NULL pointer dereference in hsr_dev_xmit()
To:     David Miller <davem@davemloft.net>
Cc:     xiyou.wangcong@gmail.com, Netdev <netdev@vger.kernel.org>,
        treeze.taeung@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 1 Dec 2019 at 03:34, David Miller <davem@davemloft.net> wrote:
>
Hi David,
Thank you for the review!

> From: Taehee Yoo <ap420073@gmail.com>
> Date: Sat, 30 Nov 2019 14:24:00 +0000
>
> > @@ -226,9 +226,16 @@ static int hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
> >       struct hsr_priv *hsr = netdev_priv(dev);
> >       struct hsr_port *master;
> >
> > +     rcu_read_lock();
> >       master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
>
> I don't want to distract from your bug fix but I had to audit and learn
> how this hsr->ports stuff works while reading your patch.
>
> hsr->ports has supposedly RCU protection...
>
> But add and delete opertions to the port list only occur by newlink
> netlink operations (the device isn't even visible yet at this point)
> and network device teardown (all packet processing paths will quiesce
> beforehand).
>
> Therefore, the port list never changes from it's effectively static
> configuration made at hsr_dev_finalize() time.
>
> The whole driver very inconsistently accesses the hsr->port list,
> and it all works only because of the above invariant.
>
> So let's not try to fix the RCU protection issues here ok?  That
> should be handled separately, and there are no real problems caused by
> the lack of RCU protection here right now.
>
> Thank you.

Why I thought that rcu_read_lock() is needed in the hsr_dev_xmit() is
that hsr_port_get_hsr() and hsr_forward_skb() should be called under
rcu_read_lock() but I found there is no rcu_read_lock() in the TX datapath.
Below is the test code.

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index ddd9605bad04..8a62474eb1f6 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -349,6 +349,8 @@ void hsr_forward_skb(struct sk_buff *skb, struct
hsr_port *port)
 {
        struct hsr_frame_info frame;

+       printk("[TEST]%s %u rcu_read_lock_held() = %d\n",
+               __func__, __LINE__, rcu_read_lock_held());
        if (skb_mac_header(skb) != skb->data) {
                WARN_ONCE(1, "%s:%d: Malformed frame (port_src %s)\n",
                          __FILE__, __LINE__, port->dev->name);

[12990.180324][    C2] [TEST]hsr_forward_skb 353 rcu_read_lock_held() = 1
[12990.337812][ T1946] [TEST]hsr_forward_skb 353 rcu_read_lock_held() = 0
[12990.341608][    C2] [TEST]hsr_forward_skb 353 rcu_read_lock_held() = 1

$ cat /proc/1946/cmdlind
ping192.168.100.2

we could see there is no rcu_read_lock() in the TX datapath.
So I'm sure that rcu_read_lock() should be added to the hsr_dev_xmit().

If rcu_read_lock() is unnecessary in there, please let me know about
the reason.

Thank you!
Taehee
