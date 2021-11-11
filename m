Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D3F44DE73
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 00:25:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhKKX2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 18:28:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbhKKX2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 18:28:10 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D5FC061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:25:20 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id y5so6894296pfb.4
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bb4YfWVvkz2UHEtxCuuuGnDa+oKMp8v1j+3+/92BNCU=;
        b=LH1Di0H2xg6+5MbGDrXO22lK3hAKKRDeMsz4ySI9od8iHqXxo2wH+5enwkwYo9yvAp
         FA6DZmCpJc0ITC0DUQ89lWZxiFPcLJLxI7lnyp1imZqsm/xHAw9kr6okJFl272MBhl4y
         iVfDhQO2OJBHhHPxt2uyXe1bzmYyOJeUPMrCGro6ATGcVbKNVO7x2VSqVjQeDoj8yzl5
         jchuGGVPBeCzLJPcKwb5Wu9NdqYocTduxYa6rmBFkoKryhN58FgCcXEfp1y5gBUpLumu
         DCNmRGumfbUVrfTPJSDsds0kEaSeZRjxt9M1xXzJxmuL/sFm1NQ/hH432wEq4HRqmylj
         5lyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bb4YfWVvkz2UHEtxCuuuGnDa+oKMp8v1j+3+/92BNCU=;
        b=CI3eu3RdR3wRFZHrRoMwKMK7LoaZ1tJDYsWj2yTg1g06fG9a486Xb5/8Wg43dg5236
         J9MxRM3cWdjpGsXxVC+vB6dk9Eyi8tmYCjiAQlx93mu03LwXpo3Af0MMJ6cC3znwKd1M
         yTsHp0cTq6Ac3SHz6AMgVgRqZcFonrfzLVjHRn5gN8ZQN2nJcJg5smtJNnsQoTv09dJe
         gpfPdpMcbxIAPahoMCn7Pixnqcx02Bh775SYknw2kk4KeJ2mGdBTQ39K/UOgiS83YPCj
         jEtUhbcd+iHrpp9rasQ/GDHkewZeQR9AjMpfmTFKyACoIKIxwoEPKAn1+XUJjMONobcG
         00cg==
X-Gm-Message-State: AOAM531aCuhwJ6DHmQv+jtPldxtLx5+/urt6bOppyQHLv8UFxFWS1/vH
        pvB+Jzrz5XG1UrXmch5SWi5u7r0dU8w=
X-Google-Smtp-Source: ABdhPJwoE2TaDpS7ibL6eiYiR26D4LY00PI0zV43cTygGF5PxNc+7qDvsVm3cAGHvntpnF/dgY26iQ==
X-Received: by 2002:a05:6a00:234f:b0:3eb:3ffd:6da2 with SMTP id j15-20020a056a00234f00b003eb3ffd6da2mr9821392pfj.15.1636673120093;
        Thu, 11 Nov 2021 15:25:20 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f3d1:9c31:c5ef:f3e0])
        by smtp.gmail.com with ESMTPSA id l6sm4674382pfc.126.2021.11.11.15.25.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 15:25:19 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
Date:   Thu, 11 Nov 2021 15:24:29 -0800
Message-Id: <20211111232429.2604394-1-arjunroy.kdev@gmail.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy@google.com>

TCP Receive zerocopy iterates through the SKB queue via
tcp_recv_skb(), acquiring a pointer to an SKB and an offset within
that SKB to read from. From there, it iterates the SKB frags array to
determine which offset to start remapping pages from.

However, this is built on the assumption that the offset read so far
within the SKB is smaller than the SKB length. If this assumption is
violated, we can attempt to read an invalid frags array element, which
would cause a fault.

tcp_recv_skb() can cause such an SKB to be returned when the TCP FIN
flag is set. Therefore, we must guard against this occurrence inside
skb_advance_frag().

One way that we can reproduce this error follows:
1) In a receiver program, call getsockopt(TCP_ZEROCOPY_RECEIVE) with:
char some_array[32 * 1024];
struct tcp_zerocopy_receive zc = {
  .copybuf_address  = (__u64) &some_array[0],
  .copybuf_len = 32 * 1024,
};

2) In a sender program, after a TCP handshake, send the following
sequence of packets:
  i) Seq = [X, X+4000]
  ii) Seq = [X+4000, X+5000]
  iii) Seq = [X+4000, X+5000], Flags = FIN | URG, urgptr=1000

(This can happen without URG, if we have a signal pending, but URG is
a convenient way to reproduce the behaviour).

In this case, the following event sequence will occur on the receiver:

tcp_zerocopy_receive():
-> receive_fallback_to_copy() // copybuf_len >= inq
-> tcp_recvmsg_locked() // reads 5000 bytes, then breaks due to URG
-> tcp_recv_skb() // yields skb with skb->len == offset
-> tcp_zerocopy_set_hint_for_skb()
-> skb_advance_to_frag() // will returns a frags ptr. >= nr_frags
-> find_next_mappable_frag() // will dereference this bad frags ptr.

With this patch, skb_advance_to_frag() will no longer return an
invalid frags pointer, and will return NULL instead, fixing the issue.

Signed-off-by: Arjun Roy <arjunroy@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: e32689db3b50 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")

---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bc7f419184aa..ef896847f190 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1741,6 +1741,9 @@ static skb_frag_t *skb_advance_to_frag(struct sk_buff *skb, u32 offset_skb,
 {
 	skb_frag_t *frag;
 
+	if (unlikely(offset_skb >= skb->len))
+		return NULL;
+
 	offset_skb -= skb_headlen(skb);
 	if ((int)offset_skb < 0 || skb_has_frag_list(skb))
 		return NULL;
-- 
2.34.0.rc1.387.gb447b232ab-goog

