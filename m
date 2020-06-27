Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAAA20BEEA
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 07:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgF0F6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 01:58:35 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:59397 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725880AbgF0F6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 01:58:35 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id e3797eb5
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 05:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=lSKJWVXiquJUkLW3FiyUsruDEc8=; b=SI2qzB
        Fv/+EhVcImVvvNThQZrEO2SeeA+2RpT0fzjtXgFI7LgsqG2HjBxseccYCHWdnxes
        GU1c1YBBxW8UeifVJL4ACDw3yPFvX4zXmYtSGKaCUOOZcRUXOr+3e/c+F2wSVefL
        QQ6GI8E1o3whmeu2RXKYvtRNDbKutKYGSedYK/q/G5pmz3WpZB3r3jjFPELORQBS
        RRGJ+jS0bP/1/X9TkYPfdkHnS6sBnXSZsxV+kxlsSj2WDNg7rLnOWj7pNlbVkmbd
        /wKcEXfdnJ4xDxpwvuFtnI0fWvSEOhmB3JzXvUd8dyuCvU9Bepn4gb6QEWmBvwf+
        7FX01VUMes5emyFQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c967702f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Sat, 27 Jun 2020 05:39:12 +0000 (UTC)
Received: by mail-il1-f175.google.com with SMTP id l9so10282260ilq.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 22:58:33 -0700 (PDT)
X-Gm-Message-State: AOAM531f7rKx9bnpHFx6sEnxPGyTx3hRDxwumMa9MLeGC24RskmlH77V
        grnyr0N1fwU+65vdROCxqTx9iOPNpn6cdY+CDDk=
X-Google-Smtp-Source: ABdhPJz5RAymW776qmwtCYvV3KB1wNCci5/wvnu0+PUl9NP2duAtlCW+BTM8ZzBu38g+crotInXbn2a9L1SHcFR8mhk=
X-Received: by 2002:a92:d24a:: with SMTP id v10mr6773457ilg.224.1593237512930;
 Fri, 26 Jun 2020 22:58:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net> <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
 <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
In-Reply-To: <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 26 Jun 2020 23:58:21 -0600
X-Gmail-Original-Message-ID: <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com>
Message-ID: <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     Hans Wippel <ndev@hwipl.net>
Cc:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi again Hans,

A few remarks: although gre implements header_ops, it looks like
various parts of the networking stack change behavior based on it. I'm
still analyzing that to understand the extent of the effects.
Something like <https://git.zx2c4.com/wireguard-linux/commit/?id=40c24fd379edc1668087111506ed3d0928052fe0>
would work, but I'm not thrilled by it. Further research is needed.

However, one thing I noticed is that other layer 3 tunnels don't seem
to be a fan of libpcap. For example, try injecting a packet into an
ipip interface. You'll hit exactly the same snag for skb->protocol==0.
So, if I do go the route of the first option -- adding a header_ops --
maybe I'll be inclined to make a shared l3_header_ops struct that can
be shared between things, and fix up all of these at once.

Alternatively, it might turn out to be that, because this is broken
for other layer 3 devices, it's meant to be broken here. But I hope
that won't be the conclusion.

Jason
