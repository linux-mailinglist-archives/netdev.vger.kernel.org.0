Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADA0D44DEAA
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 00:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234476AbhKKXzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 18:55:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234473AbhKKXzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 18:55:10 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6FA8C061766
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:52:20 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n85so6893876pfd.10
        for <netdev@vger.kernel.org>; Thu, 11 Nov 2021 15:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpdC+HS7vrvA+pQ3eF/LseHwskJIDIWZDRzd+TXGi1I=;
        b=iA71HoTuOTYRl8Rk2mn+5jMAsR/HYURVKh5PcGoDvw66pc1yYjiyAndpIGm/kWf54e
         EoJx2uts5Cn/+fS+G/EvSZ+MIO6YSS0ZI+NN24xwKpyjmynHdI8IY7b4SiN6vqlMQfQQ
         oIvsTXvvrb8Bl3M3num8flPQpF6mUhoQAq79pLoy0OUjp7mkjJN49Cmf5lDQRmIvloBU
         jE2UiGgIfbgTz39AkKZqnu7fKBXWPe6rWxQPNx3IAjzRlp3WMFsgzZnJPU56QsR+5Zal
         MfHxfsRODamgn3xMHP9pF7IXrXerk011lLEe512f5JghTSlwCYbyMePOR70Ki1Ke4N0J
         KBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KpdC+HS7vrvA+pQ3eF/LseHwskJIDIWZDRzd+TXGi1I=;
        b=CTRmxoM2nBkbYJM9J1jWZN+S+ZHWcH/0yGhluPM3RXXQBIRQ/hitlrNTgbLuSjzPS/
         Ka3VNahlDS+VlLhNAXu5jBGJ/A8DFHCRPNSn0I9y0y3tUdEw8H7ipgnGOPIZLweB1Kwd
         OBEQu1D5O4C2hAYbypgn1jYq+UjRUUy4rEXvdBj9UndzU5GC7EcJjYHlRTwXLUNV2EIt
         rOVfv/Tmoh4FBz5A778Udde9JVIlPxSjAdViKmpFu+QQKlwuleiwCodavefDpU7wI6sH
         3gaVoSCHbQwllym0WD7bWHsXAh9pl0+jzi4evpfc6d0vyDb0VPVEvOfF383efscIM+ZZ
         iPtg==
X-Gm-Message-State: AOAM532hmVovdjreYpgl9RiWC6zNkh7jQLE1AoI3BHNZCTHj9mytGtAI
        U2+PWRf4dkcouw1YzYRhEi0=
X-Google-Smtp-Source: ABdhPJwHDc4nUx9jsSuIehjnTQTDGfbYe8bmfPQEOrphxCPh8jIHKjv8RcieLbR1MpbwVti/lYq3vQ==
X-Received: by 2002:a63:3348:: with SMTP id z69mr7317350pgz.177.1636674740292;
        Thu, 11 Nov 2021 15:52:20 -0800 (PST)
Received: from phantasmagoria.svl.corp.google.com ([2620:15c:2c4:201:f3d1:9c31:c5ef:f3e0])
        by smtp.gmail.com with ESMTPSA id f15sm4600325pfe.171.2021.11.11.15.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 15:52:19 -0800 (PST)
From:   Arjun Roy <arjunroy.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     arjunroy@google.com, edumazet@google.com, soheil@google.com,
        kuba@kernel.org
Subject: [net v2] tcp: Fix uninitialized access in skb frags array for Rx 0cp.
Date:   Thu, 11 Nov 2021 15:52:15 -0800
Message-Id: <20211111235215.2605384-1-arjunroy.kdev@gmail.com>
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
Fixes: 05255b823a61 ("tcp: add TCP_ZEROCOPY_RECEIVE support for zerocopy receive")

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

