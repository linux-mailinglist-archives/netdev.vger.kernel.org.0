Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA509D159
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 16:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731040AbfHZOHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 10:07:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36432 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbfHZOHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 10:07:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so16006202wme.1
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 07:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=I6voDA9AE+BFlOAVpikZCO2P/qtUgybJeegTd1AN73Q=;
        b=DF4UVcL82f47aPzIpilnXosH3zTpMPa9QY3x+f3qun3Duvf9F6gffLnOeiOzYT2CFc
         YMOmHjgYtl/97MQuT97pKtRivbAw4KeA4EuLHvkTlrgIk83IguCMS56Ye5R0UP+ud21r
         xnxL98mSTxon+QoKEkIju7HKbjy5jO+kPxoMtmY4y4W8UXxaCAW3mneCSy8vIXXmaTgt
         uv3sF81FU7VAKLOoQL1QW6csxKZ2gXFYWSLkfhvRGKPVgterRxIALqdBcYVSI6ts6UkX
         TVGsSovxuJgiix0OtJEIykFnMNaP67gY9WIGtITN9fhNHsT/I8Sl2rgormhDF2nkDzuZ
         Ghjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=I6voDA9AE+BFlOAVpikZCO2P/qtUgybJeegTd1AN73Q=;
        b=MfSRNBfy61g49yrbaMz9lDxvvn08MF/902bXP3ueRYVD37yPa5Psli/Wl2xbayPxwA
         YZSbttHj107Aek3rRpYSNLjnb7CiZsSrCLc6zVb7KT4c5b+GClvYZQigO8yQCZsN5DnV
         NvgPzssFBQzTWvVJWd7iNtj+DzYFxcQ2QVqTAK+XT+82lWGrguEgjKmTuS4xmGu/9H+f
         iZMIqFA71VbATt213TYbsWD8H8X7di0PjkRNiwDUYnK3DTqagqVjERjpl0S4px2lOjB0
         ieZMxb6dWHt3M4io/Fne4Fjbs81MLn/DtJbGQGS8BuVCs8rVNrrQ6BO0iSxYhqS2a8u+
         um0Q==
X-Gm-Message-State: APjAAAURNlJrVJuOdhHlScahyuQlZGtrfzWHuUYxyb1XtIowWK2S0mMM
        fDXzy52TfZDpW0/93Has3KE=
X-Google-Smtp-Source: APXvYqyXpR8mL/eMLuPIyKFikPh3eGThMUbJQMWrKiBK2GOqUhOmHtFBaCsPKwWTxqIUE/MRjs4Hng==
X-Received: by 2002:a1c:6087:: with SMTP id u129mr21192779wmb.108.1566828448680;
        Mon, 26 Aug 2019 07:07:28 -0700 (PDT)
Received: from pixies (bzq-82-81-225-244.cablep.bezeqint.net. [82.81.225.244])
        by smtp.gmail.com with ESMTPSA id d16sm9058847wrv.55.2019.08.26.07.07.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 26 Aug 2019 07:07:27 -0700 (PDT)
Date:   Mon, 26 Aug 2019 17:07:24 +0300
From:   Shmulik Ladkani <shmulik.ladkani@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>, Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        shmulik@metanetworks.com, eyal@metanetworks.com
Subject: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
Message-ID: <20190826170724.25ff616f@pixies>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In our production systems, running v4.19.y longterm kernels, we hit a
BUG_ON in 'skb_segment()'. It occurs rarely and although tried, couldn't
synthetically reproduce.

In v4.19.41 it crashes at net/core/skbuff.c:3711

		while (pos < offset + len) {
			if (i >= nfrags) {
				i = 0;
				nfrags = skb_shinfo(list_skb)->nr_frags;
				frag = skb_shinfo(list_skb)->frags;
				frag_skb = list_skb;
				if (!skb_headlen(list_skb)) {
					BUG_ON(!nfrags);
				} else {
3711:					BUG_ON(!list_skb->head_frag);

With the accompanying dump:

 kernel BUG at net/core/skbuff.c:3711!
 invalid opcode: 0000 [#1] SMP PTI
 CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Not tainted 4.19.41-041941-generic #201905080231
 Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 04/05/2016
 RIP: 0010:skb_segment+0xb65/0xda9
 Code: 89 44 24 60 48 89 4c 24 70 e8 87 b3 ff ff 48 8b 4c 24 70 44 8b 44 24 60 85 c0 44 8b 54 24 4c 0f 84 fc fb ff ff e9 16 fd ff ff <0f> 0b 29 c1 89 ce 09 ca e9 61 ff ff ff 0f 0b 41 8b bf 84 00 00 00
 RSP: 0018:ffff9e4d79b037c0 EFLAGS: 00010246
 RAX: ffff9e4d75012ec0 RBX: ffff9e4d74067500 RCX: 0000000000000000
 RDX: 0000000000480020 RSI: 0000000000000000 RDI: ffff9e4d74e3a200
 RBP: ffff9e4d79b03898 R08: 0000000000000564 R09: f69d84ecbfe8b972
 R10: 0000000000000571 R11: a6b66a32f69d84ec R12: 0000000000000564
 R13: ffff9e4c18d03ef0 R14: 0000000000000000 R15: ffff9e4d74e3a200
 FS:  0000000000000000(0000) GS:ffff9e4d79b00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00000000007f50d8 CR3: 000000009420a003 CR4: 00000000001606e0
 Call Trace:
  <IRQ>
  tcp_gso_segment+0xf9/0x4e0
  tcp6_gso_segment+0x5e/0x100
  ipv6_gso_segment+0x112/0x340
  skb_mac_gso_segment+0xb9/0x130
  __skb_gso_segment+0x84/0x190
  validate_xmit_skb+0x14a/0x2f0
  validate_xmit_skb_list+0x4b/0x70
  sch_direct_xmit+0x154/0x390
  __dev_queue_xmit+0x808/0x920
  dev_queue_xmit+0x10/0x20
  neigh_direct_output+0x11/0x20
  ip6_finish_output2+0x1b9/0x5b0
  ip6_finish_output+0x13a/0x1b0
  ip6_output+0x6c/0x110
  ? ip6_fragment+0xa40/0xa40
  ip6_forward+0x501/0x810
  ip6_rcv_finish+0x7a/0x90
  ipv6_rcv+0x69/0xe0
  ? nf_hook.part.24+0x10/0x10
  __netif_receive_skb_core+0x4fa/0xc80
  ? netif_receive_skb_core+0x20/0x20
  ? netif_receive_skb_internal+0x45/0xf0
  ? tcp4_gro_complete+0x86/0x90
  ? napi_gro_complete+0x53/0x90
  __netif_receive_skb_one_core+0x3b/0x80
  __netif_receive_skb+0x18/0x60
  process_backlog+0xb3/0x170
  net_rx_action+0x130/0x350
  __do_softirq+0xdc/0x2d4

To our best knowledge, the packet flow leading to this BUG_ON is:

  - ingress on eth0 (veth, gro:on), ipv4 udp encapsulated esp
  - re-ingresss on eth0, after xfrm, decapsulated ipv4 tcp
  - the skb was GROed (skb_is_gso:true)
  - ipv4 forwarding to dummy1, where eBPF nat4-to-6 program is attached
    at TC Egress (calls 'bpf_skb_change_proto()'), then redirect to ingress
    on same device.
    NOTE: 'bpf_skb_proto_4_to_6()' mangles 'shinfo->gso_size'
  - ingress on dummy1, ipv6 tcp
  - ipv6 forwarding
  - egress on tun2 (tun device) that calls:
    validate_xmit_skb -> ... -> skb_segment BUG_ON

A similar issue was reported and fixed by Yonghong Song in commit
13acc94eff12 ("net: permit skb_segment on head_frag frag_list skb").

However 13acc94eff12 added "BUG_ON(!list_skb->head_frag)" to line 3711,
and patchwork states:

    This patch addressed the issue by handling skb_headlen(list_skb) != 0
    case properly if list_skb->head_frag is true, which is expected in
    most cases. [1]

meaning, 13acc94eff12 does not support list_skb->head_frag=0 case.

Historically, it is claimed that skb_segment is rather intolerant to
gso_size changes, quote:

    Eric suggested to shrink gso_size instead to avoid segmentation+fragments.
    I think its nice idea, but skb_gso_segment makes certain assumptions about
    nr_frags and gso_size (it can't handle frag size > desired mss). [2]

Any suggestions how to debug and fix this?

Could it be that 'bpf_skb_change_proto()' isn't really allowed to
mangle 'gso_size', and we should somehow enforce a 'skb_segment()' call
PRIOR translation?

Appreciate any input and assistance,
Shmulik

[1] https://patchwork.ozlabs.org/patch/889166/
[2] https://patchwork.ozlabs.org/patch/314327/
