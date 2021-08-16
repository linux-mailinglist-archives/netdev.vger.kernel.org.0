Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41953ECF7C
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 09:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhHPHjY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 03:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233725AbhHPHjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 03:39:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78B6C061764;
        Mon, 16 Aug 2021 00:38:52 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so15437913pjb.2;
        Mon, 16 Aug 2021 00:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5nKbIRM80jV50m92RFRSNDgACnLFClA1DW4sLx6kBRY=;
        b=MGiNtS7Yf/l/FB54ENHAXQNv6hiBiELUV2ALDtXMRQVPZi2GlYrSqCdkVxP5GDZj3u
         r6gAtLUl9Y7cCzeST+Et5c+9blLHXLdAXMZhquI2hq/yb3tT/Ea0yRZu2xSysTvcecEb
         yKpEim7HUb+swlOspF8c35l/SFG+hxOOPcIDJlbRsu4MPloDdRbcDnPcKQSikasbMnZp
         52mT5dIxWvDhZ1mtftfVe9uqzoG9+rtrHunhQl+f4cUxBkg4AMmGFfyHlgNYmTiwN3P3
         XzOy0aA4NyCSWDC13JXfJ2RMz/BATxpwXiZ+LwD3JHEgGav7jstyNGI5DqWWdqiavF1l
         z6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5nKbIRM80jV50m92RFRSNDgACnLFClA1DW4sLx6kBRY=;
        b=WhCGGRZHT8ASQXDO/eNKQyC1YryNZoFvtL77F5kwFrDy+qGebc0omaIoJDaTZaaUwe
         v0RJIEC/vgwhyHecvxwkQZ4OZoWtuAm2Tc/jWGNqdtKdQmH4OMP6hnSqZ7RInvitO4N5
         dRX0iZTn+9+QwLUTvf1276HWxUoyf9JBhSDbZoXv7V3HT3d2R8ZDqHmCWRbkNSU9tosK
         dX8lBO/RgsD+toQD6tMQyqpjmjL/0zk7vaIoamskHLcYkxVYVgwVk8TEmlNImIdwmke0
         cWj5sJLI51NA8DNs7Vqo8SD1PqOSCP9Iuct1+lcgwbKbXvLkCOzdI0fC1nXRDUN/wMAf
         9ypQ==
X-Gm-Message-State: AOAM533g2/uX1ObkSCFqu4hJMfxb1tJWX4kgrqVKeaxhMEBXDZ2U/hHO
        Mntd3vO1ZU5xrKMq/1DQkQw=
X-Google-Smtp-Source: ABdhPJw2drNKus8ikTVpUtgbYMvkiOj9krczzz/xNEM/uZcrMauxUXOtvqsXuH4X//A221tkhcpBUA==
X-Received: by 2002:a62:32c7:0:b029:3cd:fba0:3218 with SMTP id y190-20020a6232c70000b02903cdfba03218mr15157508pfy.52.1629099531983;
        Mon, 16 Aug 2021 00:38:51 -0700 (PDT)
Received: from localhost.localdomain ([154.16.166.205])
        by smtp.gmail.com with ESMTPSA id j21sm10087309pfn.75.2021.08.16.00.38.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 00:38:51 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com,
        stable@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: xfrm: fix bug in ipcomp_free_scratches
Date:   Mon, 16 Aug 2021 15:38:29 +0800
Message-Id: <20210816073832.199701-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipcomp_alloc_scratches, if the vmalloc fails, there leaves a NULL
pointer. However, ipcomp_free_scratches does not check the per_pcu_ptr
pointer when invoking vfree.

Fix this by adding a sanity check before vfree.

Call Trace:
 ipcomp_free_scratches+0xbc/0x160 net/xfrm/xfrm_ipcomp.c:203
 ipcomp_free_data net/xfrm/xfrm_ipcomp.c:312 [inline]
 ipcomp_init_state+0x77c/0xa40 net/xfrm/xfrm_ipcomp.c:364
 ipcomp6_init_state+0xc2/0x700 net/ipv6/ipcomp6.c:154
 __xfrm_init_state+0x995/0x15c0 net/xfrm/xfrm_state.c:2648
 xfrm_init_state+0x1a/0x70 net/xfrm/xfrm_state.c:2675
 pfkey_msg2xfrm_state net/key/af_key.c:1287 [inline]
 pfkey_add+0x1a64/0x2cd0 net/key/af_key.c:1504
 pfkey_process+0x685/0x7e0 net/key/af_key.c:2837
 pfkey_sendmsg+0x43a/0x820 net/key/af_key.c:3676
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723

Reported-by: syzbot+b9cfd1cc5d57ee0a09ab@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: 6fccab671f2f ("ipsec: ipcomp - Merge IPComp impl")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/xfrm/xfrm_ipcomp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index cb40ff0ff28d..9588ac05ab27 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -199,8 +199,11 @@ static void ipcomp_free_scratches(void)
 	if (!scratches)
 		return;
 
-	for_each_possible_cpu(i)
-		vfree(*per_cpu_ptr(scratches, i));
+	for_each_possible_cpu(i) {
+		void *scratch = *per_cpu_ptr(scratches, i);
+		if (!scratch)
+			vfree(scratch);
+	}
 
 	free_percpu(scratches);
 }
-- 
2.25.1

