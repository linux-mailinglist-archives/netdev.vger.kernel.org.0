Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434BC493189
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 01:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbiASAD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 19:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350320AbiASAD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 19:03:27 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C27C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:03:27 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id h14so1871677ybe.12
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 16:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=3GMHeDlAK35WYsyM179iGuTtwsj0ExgjmIMnnhrvk7M=;
        b=Y93A1bCkJYOwWYz5yB5mTmJd4/WQ7BlqGkpRUg/U3uwoAV+DUS+BnQ4EoTy9Qxef9i
         2AqAViLfT23n67sEEwwMYnGij98pmJfR7js0ATw1zQXsrrLYuSaY+OFiOgKwi6Vq+r03
         ktkfMs5kEP0ASrOkMT33brxVoHrCyPw6oh+iU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=3GMHeDlAK35WYsyM179iGuTtwsj0ExgjmIMnnhrvk7M=;
        b=z9BcLGlPBJ0ZBQ79s9l625MFkZewhFy2MorVP544GuuFyGTv5U/JiP3HIzf6X1q4zl
         tq1Nm07R4Mk8XSyo30nOCVrmLPniZV79iAj40R9i2Z2TpwyX7xfQMHwkgcnv4LE5iwnk
         Kp0jLZ7NccldcASEZ+oUxV4kUojq40FAYadiYmVFCcpY2VVf/5Ulx102CrbqEVroX+dh
         hEf5X2RoGLWENVUbGJ+AwnbSgdxh201Oc0P6yWUQm/8IaI2Y8zANVbujhOFt0AfhzMt4
         T/bEeaB46PT/S4rdVSMu6jYKbLLcztALgWmuVuHconqbCxrso7OuPK5ogWwAe2f3wfai
         qDig==
X-Gm-Message-State: AOAM533ApF7JTvCIcZpbTVO8/BMo+qP66dqiKY9mw8B3bjUHhZ/G+MW5
        QAAg2OHQJqcJCLtowOkootyHkpAc8lZOAJCLSZnK3w==
X-Google-Smtp-Source: ABdhPJwHwZP1t5nQCHL55GDSBw7vsNlQr6xwxkwcYNzK+rkoRcH1DulxEbjXXhJ67X7k6mSQ0uPoOjH3bWoLjK7fIq4=
X-Received: by 2002:a25:d701:: with SMTP id o1mr35866679ybg.693.1642550606314;
 Tue, 18 Jan 2022 16:03:26 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 18 Jan 2022 16:03:15 -0800
Message-ID: <CABWYdi1a7MKxM8XX9_1zRkp_h8AHGWT_GQTwAbJdz0iKEfrsEA@mail.gmail.com>
Subject: Empty return from bond_eth_hash in 5.15
To:     Jussi Maki <joamaki@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

We noticed an issue on Linux 5.15 where it sends packets from a single
connection via different bond members. Some of our machines are
connected to multiple TORs, which means that BGP can attract the same
connection to different servers, depending on which cable you
traverse.

On Linux 5.10 I can see bond_xmit_hash always return the same hash for
the same connection:

$ sudo bpftrace --include linux/ip.h -e 'kprobe:bond_xmit_hash {
@skbs[pid] = arg1 } kretprobe:bond_xmit_hash { $skb_ptr = @skbs[pid];
if ($skb_ptr) { $skb = (struct sk_buff *) $skb_ptr; $ipheader =
((struct iphdr *) ($skb->head + $skb->network_header)); printf("%s
%x\n", ntop($ipheader->daddr), retval); } }' | fgrep --line-buffered
x.y.z.205
x.y.z.205 9f24591
x.y.z.205 9f24591
x.y.z.205 9f24591
x.y.z.205 9f24591
x.y.z.205 9f24591
... many more of these

On Linux 5.10 I get fewer lines, mostly zeros for hash and one actual hash:

$ sudo bpftrace -e 'kprobe:bond_xmit_hash { @skbs[pid] = arg1 }
kretprobe:bond_xmit_hash { $skb_ptr = @skbs[pid]; if ($skb_ptr) { $skb
= (struct sk_buff *) $skb_ptr; $ipheader = ((struct iphdr *)
($skb->head + $skb->network_header)); printf("%s %x\n",
ntop($ipheader->daddr), retval); } }' | fgrep --line-buffered
x.y.z.205
x.y.z.205 0
x.y.z.205 0
x.y.z.205 215fec1b

As I mentioned above, this ends up breaking connections for us, which
is unfortunate.

I suspect that "net, bonding: Refactor bond_xmit_hash for use with
xdp_buff" commit a815bde56b1 has something to do with this. I don't
think we use XDP on the machines I tested.
