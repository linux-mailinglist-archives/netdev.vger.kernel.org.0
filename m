Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 799D5485200
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 12:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239784AbiAELsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 06:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbiAELsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 06:48:46 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBEDC061761;
        Wed,  5 Jan 2022 03:48:46 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n30-20020a17090a5aa100b001b2b6509685so6103547pji.3;
        Wed, 05 Jan 2022 03:48:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiQjnU8Hrsk+QJPvgwtUIOLZeuz8Cq0lnUr949yvq/c=;
        b=qT/iBa9FzrOJnedSIDr+3rWnxwcEvPW7Qb3QnFLNCEgjF4uCOCoeaxfpMG2gjFLMHe
         wz4zCHbkR2NKHUMgs+VTMU4yg5G4/6nEeg3TFDgRkTIO1g7DkqDSUAuOVpmz9nFijZWx
         GMzHaQ4tUxC6NiO4L9YCcz48TeYoJKseMdwTgY1tLT+OjKzXJTHq71cV54QD+Qvt/z4q
         vZiO9I0mWFEeFB3IYJvzRviOWkeOEtKbjSVUS2tWQvpLrqSkfDQXHGdVwUdPPgpDz/b6
         FSPP9jA4Lg/7QxxEqSAC3CRRQvyxArzcG0+56jK0vf8WsPv9lLQjBynSBCJrYCELALtq
         MMGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HiQjnU8Hrsk+QJPvgwtUIOLZeuz8Cq0lnUr949yvq/c=;
        b=frVW1+YPzfDJ0le6HmCG0MddkuH6qzFcymGwZKnBuT9d/uv5DV/VnLB/z32k1Y/w2R
         RGjb9xJVW+DylancF3/8UsaLClmTn5kj8Pd/wpciIIsuXbU49gO/s9O3kksmq0wgZ/ZF
         zAPNZjRqZPqhQ2yqA5By9BhKIx3pcT3KqlrI9S1YA3v0OrDxDmOzoNwV3wfx3SsOzU/3
         R+xEtwT3/j0mixfTXX7yIlNKD0fifeiVgGYj2il/XswQB9Q7IRqbQfnlLdpziW8W4agO
         0PxZnxucKvMLA/CNP83+wuwbYUyyd9gYxDHey0QMLKunLdFGBTiKYAUXAcvb97I6/Cd4
         1FBw==
X-Gm-Message-State: AOAM531XdDz3/l+5jCTBpE4MAizXtDSrSyn9iXh6P4MbJ7a1EdwpT/pU
        EIaglBJc4V0kzeputYv/SAg=
X-Google-Smtp-Source: ABdhPJx0gYWFxYbderN+4MEKKuNA1qNGlwigWEAaCU7JzPzhqtSqlmAuMKFD4pbEuE6rCDr12Xp3ww==
X-Received: by 2002:a17:90a:656:: with SMTP id q22mr3667043pje.74.1641383326047;
        Wed, 05 Jan 2022 03:48:46 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:af04:a4cf:7c72:9c40])
        by smtp.gmail.com with ESMTPSA id o7sm44567181pfu.108.2022.01.05.03.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 03:48:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] ppp: ensure minimum packet size in ppp_write()
Date:   Wed,  5 Jan 2022 03:48:42 -0800
Message-Id: <20220105114842.2380951-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It seems pretty clear ppp layer assumed user space
would always be kind to provide enough data
in their write() to a ppp device.

This patch makes sure user provides at least
2 bytes.

It adds PPP_PROTO_LEN macro that could replace
in net-next many occurrences of hard-coded 2 value.

I replaced only one occurrence to ease backports
to stable kernels.

The bug manifests in the following report:

BUG: KMSAN: uninit-value in ppp_send_frame+0x28d/0x27c0 drivers/net/ppp/ppp_generic.c:1740
 ppp_send_frame+0x28d/0x27c0 drivers/net/ppp/ppp_generic.c:1740
 __ppp_xmit_process+0x23e/0x4b0 drivers/net/ppp/ppp_generic.c:1640
 ppp_xmit_process+0x1fe/0x480 drivers/net/ppp/ppp_generic.c:1661
 ppp_write+0x5cb/0x5e0 drivers/net/ppp/ppp_generic.c:513
 do_iter_write+0xb0c/0x1500 fs/read_write.c:853
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Uninit was created at:
 slab_post_alloc_hook mm/slab.h:524 [inline]
 slab_alloc_node mm/slub.c:3251 [inline]
 __kmalloc_node_track_caller+0xe0c/0x1510 mm/slub.c:4974
 kmalloc_reserve net/core/skbuff.c:354 [inline]
 __alloc_skb+0x545/0xf90 net/core/skbuff.c:426
 alloc_skb include/linux/skbuff.h:1126 [inline]
 ppp_write+0x11d/0x5e0 drivers/net/ppp/ppp_generic.c:501
 do_iter_write+0xb0c/0x1500 fs/read_write.c:853
 vfs_writev fs/read_write.c:924 [inline]
 do_writev+0x645/0xe00 fs/read_write.c:967
 __do_sys_writev fs/read_write.c:1040 [inline]
 __se_sys_writev fs/read_write.c:1037 [inline]
 __x64_sys_writev+0xe5/0x120 fs/read_write.c:1037
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: linux-ppp@vger.kernel.org
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 drivers/net/ppp/ppp_generic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 1180a0e2445fbfb3204fea785f1c1cf48bc77141..3ab24988198feaa147397f9ce231815ed1dfa293 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -69,6 +69,8 @@
 #define MPHDRLEN	6	/* multilink protocol header length */
 #define MPHDRLEN_SSN	4	/* ditto with short sequence numbers */
 
+#define PPP_PROTO_LEN	2
+
 /*
  * An instance of /dev/ppp can be associated with either a ppp
  * interface unit or a ppp channel.  In both cases, file->private_data
@@ -497,6 +499,9 @@ static ssize_t ppp_write(struct file *file, const char __user *buf,
 
 	if (!pf)
 		return -ENXIO;
+	/* All PPP packets should start with the 2-byte protocol */
+	if (count < PPP_PROTO_LEN)
+		return -EINVAL;
 	ret = -ENOMEM;
 	skb = alloc_skb(count + pf->hdrlen, GFP_KERNEL);
 	if (!skb)
@@ -1764,7 +1769,7 @@ ppp_send_frame(struct ppp *ppp, struct sk_buff *skb)
 	}
 
 	++ppp->stats64.tx_packets;
-	ppp->stats64.tx_bytes += skb->len - 2;
+	ppp->stats64.tx_bytes += skb->len - PPP_PROTO_LEN;
 
 	switch (proto) {
 	case PPP_IP:
-- 
2.34.1.448.ga2b2bfdf31-goog

