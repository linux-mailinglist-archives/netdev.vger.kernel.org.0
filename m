Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7724C6BE
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 22:29:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728306AbgHTU3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 16:29:32 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:33773 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgHTU3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 16:29:31 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 6eebc9dc;
        Thu, 20 Aug 2020 20:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :in-reply-to:references:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=vbB12wcoqGij8pNjbTWmmp+jHvY=; b=wUs8au
        lE4biNqHYhGliEHSQHFFLxEWY9JK5D3fy0wIB5+PTA1mWWxXL0IFPECmgrvwdMkl
        Ewys71yT2/SchWAbsGurH0rikrqWivc/7rHZ4Ie9ghMwEbKsfTnBIXCXhobobuJU
        obUr6B2hY9kDOSrPJOCXXWdD3aLfsYxOJDaJAqMvVbrziYgeMLbU4UCEnvVkcxys
        JIQpuuc+/rl8KI6xD+oCU7WjAge6x7vROtGA4diV8IDKYC5vHDincOFzm+ReN2lS
        VdeEim8JmC3VPmR/NOXeJpeTeEnDg2JDl3CsJOg7MmP2xu3w7iO+UhkW+rgiD5xC
        4SEiHWuayPrDwEDg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id aa7c0c0b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 20 Aug 2020 20:02:59 +0000 (UTC)
Received: by mail-il1-f179.google.com with SMTP id 77so2780107ilc.5;
        Thu, 20 Aug 2020 13:29:28 -0700 (PDT)
X-Gm-Message-State: AOAM533AfpcTOqXq/M+VL612QGJGxX0BUUzFGFWehSgTQOadb3zr+O3m
        JOlGiI3OOTUy63xOvE3Fp60AShVZzYgYjw4XE5w=
X-Google-Smtp-Source: ABdhPJxYAN5teeI+8iuarY1p5HV0KRkx/xSmiz39Aszl4gAfKEvCJyq1qzz5qPsVx8Vjx6yv+lbqRx1SMAobfZvt8H0=
X-Received: by 2002:a92:cf09:: with SMTP id c9mr364213ilo.38.1597955367170;
 Thu, 20 Aug 2020 13:29:27 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6e02:ed0:0:0:0:0 with HTTP; Thu, 20 Aug 2020 13:29:26
 -0700 (PDT)
In-Reply-To: <20200820.115512.511642239854628332.davem@davemloft.net>
References: <20200815074102.5357-1-Jason@zx2c4.com> <20200819.162247.527509541688231611.davem@davemloft.net>
 <CAHmME9oBQu-k6VKJ5QzVLpE-ZuYoo=qHGKESj8JbxQhDq9QNrQ@mail.gmail.com> <20200820.115512.511642239854628332.davem@davemloft.net>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 20 Aug 2020 22:29:26 +0200
X-Gmail-Original-Message-ID: <CAHmME9qzVc-3ZzC-Bhxyb5TG85jkEicM+T+-nNU7_ez6+vS8RA@mail.gmail.com>
Message-ID: <CAHmME9qzVc-3ZzC-Bhxyb5TG85jkEicM+T+-nNU7_ez6+vS8RA@mail.gmail.com>
Subject: Re: [PATCH net v6] net: xdp: account for layer 3 packets in generic
 skb handler
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, thomas@sockpuppet.org,
        adhipati@tuta.io, dsahern@gmail.com, toke@redhat.com,
        kuba@kernel.org, alexei.starovoitov@gmail.com, brouer@redhat.com,
        john.fastabend@gmail.com, daniel@iogearbox.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/20/20, David Miller <davem@davemloft.net> wrote:
> From: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Date: Thu, 20 Aug 2020 11:13:49 +0200
>
>> It seems like if an eBPF program pushes on a VLAN tag or changes the
>> protocol or does any other modification, it will be treated in exactly
>> the same way as the L2 packet above by the remaining parts of the
>> networking stack.
>
> What will update the skb metadata if the XDP program changes the
> wireguard header(s)?
>

XDP runs after decryption/decapsulation, in the netif_rx path, which
means there is no wireguard header at that point. All the wireguard
crypto/udp/header stuff is all inside the driver itself, and the rest
of the stack just deals in terms of plain vanilla L3 ipv4/ipv6
packets.

The skb->protocol metadata is handled by the fake ethernet header.

Is there other metadata I should keep in mind? WireGuard doesn't play
with skb_metadata_*, for example. (Though it may implicitly reach a
skb_metadata_clear via pskb_expand path.)
