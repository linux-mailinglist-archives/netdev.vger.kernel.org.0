Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B834116C9B
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 12:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727625AbfLIL5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 06:57:05 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:58597 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727163AbfLIL5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 06:57:04 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 4e27e77d
        for <netdev@vger.kernel.org>;
        Mon, 9 Dec 2019 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :from:date:message-id:subject:to:content-type; s=mail; bh=ioH3ax
        SkPr8J8bblz4mr4XrAz7g=; b=mZ+HyPHP1k9HxrxNjXqXapDI9mams55+NWL17T
        woLGmwWlev8J++wV5I283cgHQ7RxcRIlrC1NRPo+q1ymQra/NJTsYfKGqza7ZTm1
        3FDsrJ3NoFUnv/Z89brq1czzMp1MqjmuSbucUKgEPHjDYBbOsEvsOGM//XDbkhAb
        cNgSMtOU1+R5E/4ponjTcautQQtsz6gbNrp2CWsqZSxE85GrPQnxKCz3c07QLuyV
        1n5eT+/eXLklmyz1xGJSnWGBkjzIL9o3JoAXJGak+uOodwFYsQ5cePqqDa4qozrz
        jmqvXuF4Hw3OKS/bw6hZJwqzkT52lctG+PFufYrDAg/G/YAg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ac5f55f1 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 9 Dec 2019 11:01:37 +0000 (UTC)
Received: by mail-oi1-f175.google.com with SMTP id a124so5997553oii.13
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 03:57:01 -0800 (PST)
X-Gm-Message-State: APjAAAUEO3L6QRjrKuGzbDGEi1VDpjriVL++mngKwDtt56CtZUpB0iY6
        tgJEFkU7pDkUo9iSxspUEV99sSCBYhioCN3eRuM=
X-Google-Smtp-Source: APXvYqwOqTjKU/LHLNPlGAMqyvGsHaPi566amNvjtNpLmFyUDZvFu7Zx2VPnx3VgSRR72ecxG4I4NyQ0cl4PNTzHAyc=
X-Received: by 2002:aca:5143:: with SMTP id f64mr22626453oib.66.1575892620789;
 Mon, 09 Dec 2019 03:57:00 -0800 (PST)
MIME-Version: 1.0
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 9 Dec 2019 12:56:49 +0100
X-Gmail-Original-Message-ID: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
Message-ID: <CAHmME9p1-5hQXv5QNqqHT+OBjn-vf16uAU2HtYcmwKMtLhnsTA@mail.gmail.com>
Subject: organization of wireguard linux kernel repos moving forward
To:     WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[Cross-posted to wireguard mailing list and netdev.]

Hey folks,

With WireGuard in net-next, it's time to break up the monolithic repo
we've been using for development into something a bit more manageable
and in line with ordinary kernel development.

Right now the "WireGuard.git" repo has been structured as an out of
tree module, alongside a subdirectory for tools, one for scripts, one
for tests, and another for a super gnarly compat layer that makes the
thing work on all kernels going back to 3.10. We're going to break
this up into three repositories:

1) wireguard-linux.git will be a full Linux tree, with wireguard
changes, and regularly merge in net/net-next, and have things from
there posted on netdev like usual for review. This repo won't be an
out of tree module any more, obviously. This lives at:
https://git.zx2c4.com/wireguard-linux/
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux.git/

2) wireguard-tools.git will have the userspace utilities and scripts,
such as wg(8) and wg-quick(8), and be easily packageable by distros.
This repo won't be live until we get a bit closer to the 5.6 release,
but when it is live, it will live at:
https://git.zx2c4.com/wireguard-tools/ [currently 404s]
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-tools.git/
[currently 404s]

3) wireguard-linux-compat.git will be an out-of-tree module containing
the aforementioned horrific compat.h layer. New development will go
into upstream wireguard-linux.git, but we'll do our best to keep
things mostly working for as long as it makes sense and is feasible.
This repo won't be live until we get a bit closer to the 5.6 release,
but when it is live, it will live at:
https://git.zx2c4.com/wireguard-linux-compat/ [currently 404s]
https://git.kernel.org/pub/scm/linux/kernel/git/zx2c4/wireguard-linux-compat.git/
[currently 404s]

Since 5.6 is a long ways off, we'll probably have a few more snapshots
posted out of the monolithic WireGuard.git repo, but in the next few
months we'll be transitioning things over and working with distro
packagers to make sure the new tarball URLs for the tools are all set.

The CI that runs on build.wireguard.com will also see some updates to
reflect these adjustments, and also more closely align with the
net-next tree. Additionally, I'm interested to see if I can make our
CI useful for a variety of things in net/ and drivers/net/ instead of
just for wireguard.

More generally, wireguard linux development will be moving to the
release cadence, development, and review practices of netdev, rather
than living sequestered as an out-of-tree snapshot-only thing.

Regards,
Jason
