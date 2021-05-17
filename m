Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F853822B1
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 04:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEQCY4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 22:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbhEQCY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 22:24:56 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92ADBC061573;
        Sun, 16 May 2021 19:23:40 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id j11so3857769qtn.12;
        Sun, 16 May 2021 19:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfZ7kHaPXN2fRvPRo6RM6NcFZmfm+DWSIIIONEj15lQ=;
        b=UjE4WMm1YSjILhNqOb+N5VRPeVm0yYGKneQqAoTpb8/ZKaExFEB7El3nh6Og2fh52v
         wJAJreaIcoRZvX7sksbFJTe9G3xivxjF2bRBZuCM/Ufb/23mGd2Oci3BNcbTrrifQDMQ
         cuF4Qx6wDs0OpJD164MmjwIShZrTxdQGGRR03yL+dtBNT7SW1iAO4T1UkMAByR82+As7
         JEd5fLGeTJHud1kBDtCEB+37enRl5Tky3H398tk8IAC/V617uykL2DJRjjfENh9Ynjld
         JpCFtSzr+bhsHC2hiV83rBE+L791A+KiZcTJIN/941BWC5HQa3rzxWF8eCTZzw2r/cHY
         bOTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfZ7kHaPXN2fRvPRo6RM6NcFZmfm+DWSIIIONEj15lQ=;
        b=SngZK1J7MSI60MCtBg3k0Kskxao+yJK2Y4stf4Bqm4FUn6VRVPO7ivFHWVoIZorx90
         sp3B/zHCpayw/WAuxSByxvB98CLwz39hVAxPxSY2qusqT7p0kZFDSI2S4olmLrIYwRFl
         RVX0wHXSJUiFvBGRKA9iNyvmoIn4v0fYyDD87nASBatqEL0cxzVh4n0GKAzgN4OqJSE8
         g1kQ8AOJxnTk0GW06jhRZAW/eSPJ4z5wYXbde353dqs7O9sABkv6vj2Qj7ru4hd02p/7
         0U4Un12e2bzv872Folseb7729VXnqmhhtRmGQj6Bgh05s+zshrSNoCODX2vpreCaQ967
         CM4Q==
X-Gm-Message-State: AOAM533Nif+TdBxsF2bbUU67cbOe1DMzpsm+/hRJ3gx8AbVcBsL4OGQJ
        eDyShl/9sJ54k0MnuBbAUx7at7Lv1d1fvg==
X-Google-Smtp-Source: ABdhPJw4KN9AD7TQkDddMjLO/JrBUYLX80hrrXIQKeb9WM133gg2UJKZw07PjqPob6DwXrhow/nTpg==
X-Received: by 2002:ac8:7381:: with SMTP id t1mr54706178qtp.3.1621218219589;
        Sun, 16 May 2021 19:23:39 -0700 (PDT)
Received: from unknown.attlocal.net ([2600:1700:65a0:ab60:a15a:608b:20ec:867f])
        by smtp.gmail.com with ESMTPSA id 66sm9993888qkh.54.2021.05.16.19.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 19:23:39 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [Patch bpf] udp: fix a memory leak in udp_read_sock()
Date:   Sun, 16 May 2021 19:23:22 -0700
Message-Id: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

sk_psock_verdict_recv() clones the skb and uses the clone
afterward, so udp_read_sock() should free the original skb after
done using it.

Fixes: d7f571188ecf ("udp: Implement ->read_sock() for sockmap")
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/ipv4/udp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 15f5504adf5b..e31d67fd5183 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1798,11 +1798,13 @@ int udp_read_sock(struct sock *sk, read_descriptor_t *desc,
 		if (used <= 0) {
 			if (!copied)
 				copied = used;
+			kfree_skb(skb);
 			break;
 		} else if (used <= skb->len) {
 			copied += used;
 		}
 
+		kfree_skb(skb);
 		if (!desc->count)
 			break;
 	}
-- 
2.25.1

