Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D4BD37D9
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 05:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfJKD1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 23:27:05 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36034 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJKD1F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 23:27:05 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so7659277qkc.3
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 20:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=skGBENV0wXv3Qt+Vq+q+fUaArJk6GyjBCA/U6VwwEeU=;
        b=bL3x0owZTOMqITjal+81td0uXZMkYveqAnwEgKmWV1rBTENe9+on9iooRYtY0r50dH
         PVQN/3Wv8WEzGvm/5W/WSQ7k52Mv3Ap3rv7N/QhAbR1cBoI+VC53D+4ho6/dFPdT3ecb
         uAU+eqOMroI9stllrSI0voZAqmWiYf/cJpFNL4VUdGGGDa3qXUQxCc9R6+uGHxhnjdgW
         hoEfit9w8FU8gGbptROK3Kmug/vHtp6fzGzbX9aZ6BaQ5WTdsDNWk++5inLCct7FIt/7
         dfoHgQL2H4GiKdHZAM591GdukJEoGQpo6nhtub/ChTwcnNafi2MW8uxhVe5EooP/dWjX
         VV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=skGBENV0wXv3Qt+Vq+q+fUaArJk6GyjBCA/U6VwwEeU=;
        b=bD0IFCFlAovs1U8Vka1Su1f4GxXrRFoUpoOdNiYjHw3gJwGO2BQasMV5NDCPL1VIcC
         bf5zPA6h9cl2g9F6ECpa3npp7UukNh4vWuk7Gv5VHAcGKgmddBoCdSAW5bLIxwNOnhhz
         J7jadYUdwQMHcKleodR9mxXhjLKcuzyrr7sabzX9ugE/KLAn7diuVmXnqBqw8DtSvJz3
         u4HvHp1VBl25QDX9GCI5tiIamfeQuh5JRhFDB/kPeVmpuy3B+CjOgc85IPQaZrogSfUa
         2jmBmflMXAQDQ/eG4qSIO8p+JpdRs0sK6zy9C56jD4X/ODfMlFfoFZALaTYo3YdtViMU
         SoWg==
X-Gm-Message-State: APjAAAW+XU/ogkqyNsTQdaPi0LUaAdypecGk/BX2IrLguA7fqLeEvm+F
        ht8g/enFi0n2FxCURMTQf1bE7xYp
X-Google-Smtp-Source: APXvYqyPjuZMPCf2L/tFsu6R9lsv+R+st02Z6vl+XKLdMlZz4CwvWg9IR2OSZBcBAH6UUVm9bSNK8A==
X-Received: by 2002:a05:620a:12c4:: with SMTP id e4mr13194632qkl.336.1570764424661;
        Thu, 10 Oct 2019 20:27:04 -0700 (PDT)
Received: from soheil24.nyc.corp.google.com ([2620:0:1003:312:3dee:cd13:c779:e9e9])
        by smtp.gmail.com with ESMTPSA id c12sm3054555qkc.81.2019.10.10.20.27.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 20:27:04 -0700 (PDT)
From:   Soheil Hassas Yeganeh <soheil.kdev@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     edumazet@google.com, Soheil Hassas Yeganeh <soheil@google.com>
Subject: [PATCH net-next] tcp: improve recv_skip_hint for tcp_zerocopy_receive
Date:   Thu, 10 Oct 2019 23:27:02 -0400
Message-Id: <20191011032702.59998-1-soheil.kdev@gmail.com>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Soheil Hassas Yeganeh <soheil@google.com>

tcp_zerocopy_receive() rounds down the zc->length a multiple of
PAGE_SIZE. This results in two issues:
- tcp_zerocopy_receive sets recv_skip_hint to the length of the
  receive queue if the zc->length input is smaller than the
  PAGE_SIZE, even though the data in receive queue could be
  zerocopied.
- tcp_zerocopy_receive would set recv_skip_hint of 0, in cases
  where we have a little bit of data after the perfectly-sized
  packets.

To fix these issues, do not store the rounded down value in
zc->length. Round down the length passed to zap_page_range(),
and return min(inq, zc->length) when the zap_range is 0.

Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index f98a1882e537..9f41a76c1c54 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1739,8 +1739,8 @@ static int tcp_zerocopy_receive(struct sock *sk,
 				struct tcp_zerocopy_receive *zc)
 {
 	unsigned long address = (unsigned long)zc->address;
+	u32 length = 0, seq, offset, zap_len;
 	const skb_frag_t *frags = NULL;
-	u32 length = 0, seq, offset;
 	struct vm_area_struct *vma;
 	struct sk_buff *skb = NULL;
 	struct tcp_sock *tp;
@@ -1767,12 +1767,12 @@ static int tcp_zerocopy_receive(struct sock *sk,
 	seq = tp->copied_seq;
 	inq = tcp_inq(sk);
 	zc->length = min_t(u32, zc->length, inq);
-	zc->length &= ~(PAGE_SIZE - 1);
-	if (zc->length) {
-		zap_page_range(vma, address, zc->length);
+	zap_len = zc->length & ~(PAGE_SIZE - 1);
+	if (zap_len) {
+		zap_page_range(vma, address, zap_len);
 		zc->recv_skip_hint = 0;
 	} else {
-		zc->recv_skip_hint = inq;
+		zc->recv_skip_hint = zc->length;
 	}
 	ret = 0;
 	while (length + PAGE_SIZE <= zc->length) {
-- 
2.23.0.700.g56cf767bdb-goog

