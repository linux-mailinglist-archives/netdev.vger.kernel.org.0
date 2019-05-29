Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1272B2E85F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 00:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfE2WgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 18:36:15 -0400
Received: from mail-yw1-f73.google.com ([209.85.161.73]:52539 "EHLO
        mail-yw1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbfE2WgO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 18:36:14 -0400
Received: by mail-yw1-f73.google.com with SMTP id b189so3585291ywa.19
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 15:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=BE7pPN2bmLURSu+DG4gQbNhP1gibIeZGHNV9HZXvfak=;
        b=b5/p1qbWWkierNQ8l+jmF2vaAixn0OVEUp4OjJxGybUU7GnChmAUWbaEqSFi8FzqKW
         ebUSmPRk4TK19CpFj0v4jHx7C9uqq4+ujXyVzO0T1L9w8c6xkZSxtZYFIzbfQOfb2DcT
         fE3QV3Etemsg8+LHTvrlmA2VvKNDl8wagvK807hFJwR9c4nUgHZbwJZUWrwXl9m9eY7a
         t9v24cg3F5Mkx58tVbmNQ6BE1Vi8P1f14v04q83znSxzaG2qeEAGHJhcmvCp+bLj2F5a
         CPoVasO7hJTre1bk5zDqcDhU4gOwUPhilaj1bPgARYH7u2lGw0imJJGogEhCwTak0MF9
         C2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=BE7pPN2bmLURSu+DG4gQbNhP1gibIeZGHNV9HZXvfak=;
        b=Ass/wgkRLS6+8nf3Nj50ePVTYBI8wcLiUFLRgrLro0pvgMMwPieQv4HgJYTWUCZTAJ
         HFxOenY34OZULNr+CxlhTCbnNXgB7aAPXIHE7QnNeV/ods+3iBPEmZ3slHKtO6FiP4NA
         RakT/eAI8H7ux98yTYfDXwynHrHuRGuQtMulVoq91tPx7JO2JZcluyoeSSvy0CWpldPb
         007Zj0qtDqoLndCiK9cfgY/WOoGIzFlvSzEGJCPk9jBmsX+QXAROJhGMtEJVX4SVbMCl
         BPLzFD45Ows3XEP3onhFsEFCh7OiQtJ8GKWdYek7MSjgd5IuMy9F3pKjKKfZV9ql6inM
         70bw==
X-Gm-Message-State: APjAAAVmcLwKtKS0vS2oHodRai8z6NwA19K+cdvKIFkaXvIN11Lde0Cq
        +3iesuV1pxx9bEoV/zgEbHJxLzuUTtUyJA==
X-Google-Smtp-Source: APXvYqzH5tSSBVmAnyq/IbkWn+L8t3dPXk9GfnF0pHyWZg8g8zuPrZiI3rWgIwmw1sKhpCoWQiBc9uLHfOtIvA==
X-Received: by 2002:a81:283:: with SMTP id 125mr240273ywc.471.1559169373972;
 Wed, 29 May 2019 15:36:13 -0700 (PDT)
Date:   Wed, 29 May 2019 15:36:10 -0700
Message-Id: <20190529223610.141253-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH net] net-gro: fix use-after-free read in napi_gro_frags()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a network driver provides to napi_gro_frags() an
skb with a page fragment of exactly 14 bytes, the call
to gro_pull_from_frag0() will 'consume' the fragment
by calling skb_frag_unref(skb, 0), and the page might
be freed and reused.

Reading eth->h_proto at the end of napi_frags_skb() might
read mangled data, or crash under specific debugging features.

BUG: KASAN: use-after-free in napi_frags_skb net/core/dev.c:5833 [inline]
BUG: KASAN: use-after-free in napi_gro_frags+0xc6f/0xd10 net/core/dev.c:5841
Read of size 2 at addr ffff88809366840c by task syz-executor599/8957

CPU: 1 PID: 8957 Comm: syz-executor599 Not tainted 5.2.0-rc1+ #32
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x172/0x1f0 lib/dump_stack.c:113
 print_address_description.cold+0x7c/0x20d mm/kasan/report.c:188
 __kasan_report.cold+0x1b/0x40 mm/kasan/report.c:317
 kasan_report+0x12/0x20 mm/kasan/common.c:614
 __asan_report_load_n_noabort+0xf/0x20 mm/kasan/generic_report.c:142
 napi_frags_skb net/core/dev.c:5833 [inline]
 napi_gro_frags+0xc6f/0xd10 net/core/dev.c:5841
 tun_get_user+0x2f3c/0x3ff0 drivers/net/tun.c:1991
 tun_chr_write_iter+0xbd/0x156 drivers/net/tun.c:2037
 call_write_iter include/linux/fs.h:1872 [inline]
 do_iter_readv_writev+0x5f8/0x8f0 fs/read_write.c:693
 do_iter_write fs/read_write.c:970 [inline]
 do_iter_write+0x184/0x610 fs/read_write.c:951
 vfs_writev+0x1b3/0x2f0 fs/read_write.c:1015
 do_writev+0x15b/0x330 fs/read_write.c:1058

Fixes: a50e233c50db ("net-gro: restore frag0 optimization")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b6b8505cfb3e2394f74b41b8e01055c697ad384b..af12c434192e73440e2dffb84b87945b515cdf16 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5809,7 +5809,6 @@ static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
 	skb_reset_mac_header(skb);
 	skb_gro_reset_offset(skb);
 
-	eth = skb_gro_header_fast(skb, 0);
 	if (unlikely(skb_gro_header_hard(skb, hlen))) {
 		eth = skb_gro_header_slow(skb, hlen, 0);
 		if (unlikely(!eth)) {
@@ -5819,6 +5818,7 @@ static struct sk_buff *napi_frags_skb(struct napi_struct *napi)
 			return NULL;
 		}
 	} else {
+		eth = (const struct ethhdr *)skb->data;
 		gro_pull_from_frag0(skb, hlen);
 		NAPI_GRO_CB(skb)->frag0 += hlen;
 		NAPI_GRO_CB(skb)->frag0_len -= hlen;
-- 
2.22.0.rc1.257.g3120a18244-goog

