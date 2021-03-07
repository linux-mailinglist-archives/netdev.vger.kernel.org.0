Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB73304E8
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 22:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233175AbhCGVuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 16:50:12 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:58976 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233151AbhCGVt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Mar 2021 16:49:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1615153795;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RUVCoOWCZgwYe0ildtedhPApp+y7b5Piejnp/H1K+cY=;
        b=DTdXgcK4DariqMvnym9sG1u7NHE6Gzrnn5KzEo8sefXyKH0YMyqkmwLNplArVCh/txXeEu
        kWQGCpXBCHFWRBKj68FACOet+24cno8+fQ7nke9lAE5rz93twxSZYnzGiZ7VWnL3YdqWn5
        ML4nI2+rU1hIRf8ViORfiQPd6It7GtU=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id bf0b30b9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 7 Mar 2021 21:49:55 +0000 (UTC)
Received: by mail-yb1-f178.google.com with SMTP id x19so8190987ybe.0;
        Sun, 07 Mar 2021 13:49:55 -0800 (PST)
X-Gm-Message-State: AOAM530/mxNtWKQRo4zQGf1ZMnPcwGvfNDhy1n5ifwa3MC2vSxfeQw5g
        D/a5j9EuiTFBvbgxIi4Cuy/BASYfFPSS9j001TE=
X-Google-Smtp-Source: ABdhPJy7mvJ0VD3nNKLyI81nc+txqkVyTDiapeHN0ZoxsxFksc1hv6STbLAtNih32M/g6LLphFUqgV47sytRwUNHSMw=
X-Received: by 2002:a25:5289:: with SMTP id g131mr29648018ybb.178.1615153794700;
 Sun, 07 Mar 2021 13:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20210109210056.160597-1-linus@lotz.li>
In-Reply-To: <20210109210056.160597-1-linus@lotz.li>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 7 Mar 2021 14:49:43 -0700
X-Gmail-Original-Message-ID: <CAHmME9osYO9O6dikmwR+i44hB_4YqKyc2P3Sre_g9ReHkMJDpQ@mail.gmail.com>
Message-ID: <CAHmME9osYO9O6dikmwR+i44hB_4YqKyc2P3Sre_g9ReHkMJDpQ@mail.gmail.com>
Subject: Re: [PATCH] wireguard: netlink: add multicast notification for peer changes
To:     Linus Lotz <linus@lotz.li>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Linus,

Thanks for the patch and sorry for the delay in reviewing it. Seeing
the basic scaffolding for getting netlink notifiers working with
WireGuard is enlightening; it looks surprisingly straightforward.

There are three classes of things that are interesting to receive
notifications for:

1) Things that the admin changes locally. This is akin to the `ip
monitor`, in which you can see various things that other programs (or
the kernel) modify. This seems straightforward and uncontroversial.

2) Authenticated events from peers. This basically amounts to new
sessions being created following a successful handshake. This seems
mostly okay because authenticated actions already have various DoS
protections in place.

3) Unauthenticated events. This would be things like (a) your patch --
a peer's endpoint changes -- or, more interestingly, (b) public keys
of unknown peers trying to handshake.

(b) is interesting because it allows doing database lookups in
userspace, adding the looked up entry, adding it to the interface, and
initiating a handshake in the reverse direction using the endpoint
information. It's partially DoS-protected due to the on-demand cookie
mac2 field.

(a) is also interesting for the use cases you outlined, but much more
perilous, as these are highspeed packets where the outer IP header is
totally unauthenticated. What prevents a man in the middle from doing
something nasty there, causing userspace to be inundated with
expensive calls and filling up netlink socket buffers and so forth?

I wonder if this would be something better belonging to (2) -- getting
an event on an authenticated peer handshake -- and combining that with
the ability to disable roaming (something discussed a few times on
wgml). Alternatively, maybe you have a different idea in mind about
this?

I also don't (yet) know much about the efficiency of multicast netlink
events and what the overhead is if nobody is listening, and questions
like that. So I'd be curious to hear your thoughts on the matter.

Regards,
Jason
