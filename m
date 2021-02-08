Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02DD831311F
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 12:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhBHLmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 06:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232705AbhBHLjF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 06:39:05 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C755FC06174A;
        Mon,  8 Feb 2021 03:38:22 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e7so1087644pge.0;
        Mon, 08 Feb 2021 03:38:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riHMqULrRSzhbcP8hGkGbuD0aYoEEZcqBKEw7J0dIxE=;
        b=HlWJ3GOVS6cvpYfSzvMrcbIPlXWj4n8wb6tm4ERcSXqHll/OAVjWJ1iuGmKVnKtmsF
         e/WM6tIUJRaM8Ih8sSxahNHgTIu2HKhkOzsRWgA0ezi32d/+N8f6xcU0XeKiCwxfD3U6
         A7FxYmJT+URHQuRbcBlWgpgH9uXq2Jj1hjrnppVOvflhHDLvzn0gUgIj/yfcOSYtzTzG
         YhY47W285C7k+zik+cXjhMiWrR2U9QEQXo4Zi34LzLJ/SIZmfFQBRboXumOqq47gwiyG
         qontao8wszhXrPt8NpTUEOBUCFYA2jdkZMww4Wdcd5mnx1cVOcV5DmwFQgv4sUgTdlNF
         FOqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=riHMqULrRSzhbcP8hGkGbuD0aYoEEZcqBKEw7J0dIxE=;
        b=nWdSSTdBdsSNxPjZHupkyGJXcSfamumZB1BW5KrEKaVaweaH7IsdidOrKP9ycQfsri
         2pFuOCDH0ksbCIDQBmp1kGas+QcVjmksSmWn87GbsBwgAqAm5tzMhR/L2qQxLEj+9A6+
         OI0P9z/q0ut3w5Kkz7jBqm9waQ2d8FgmcDK1cIxBMhARqt8DjvCOwNXzniB5ODkId/Ep
         q9uKQjAHQkyQ1LaLTSvkwEc4E1AOZ1pDRD3nZ6TCtAQMAIh89Rb34rZdrh0A7Zl+FYCs
         LdGemMd0W2qRcmFhGUJs+pFcTqb33JjAy/MEEUkzF/58wfzCIOkvUSnaXH0QKiZm/WPk
         C3ng==
X-Gm-Message-State: AOAM530Z9qDvl9cxiFLKurzONO2zR8NW7b6irFSr8S7/5sV85FpUWeca
        XYEbCagaueR+n3pP4Jz/5pBmFU/aaeOzYQ==
X-Google-Smtp-Source: ABdhPJwd5sRolEVgWLa5J2j+T6Irk2tBYmfym8RfqRzn4anmRHys1BUJuK4nC+WoeHY4kzVLbXkp0A==
X-Received: by 2002:a05:6a00:847:b029:1b3:b9c3:11fb with SMTP id q7-20020a056a000847b02901b3b9c311fbmr17100497pfk.44.1612784302019;
        Mon, 08 Feb 2021 03:38:22 -0800 (PST)
Received: from localhost.localdomain ([154.48.252.67])
        by smtp.gmail.com with ESMTPSA id w7sm15732702pjv.24.2021.02.08.03.38.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Feb 2021 03:38:21 -0800 (PST)
From:   huangxuesen <hxseverything@gmail.com>
To:     davem@davemloft.net
Cc:     bpf@vger.kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        huangxuesen <huangxuesen@kuaishou.com>,
        chengzhiyong <chengzhiyong@kuaishou.com>,
        wangli <wangli09@kuaishou.com>
Subject: [PATCH] bpf: in bpf_skb_adjust_room correct inner protocol for vxlan
Date:   Mon,  8 Feb 2021 19:38:10 +0800
Message-Id: <20210208113810.11118-1-hxseverything@gmail.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: huangxuesen <huangxuesen@kuaishou.com>

When pushing vxlan tunnel header, set inner protocol as ETH_P_TEB in skb
to avoid HW device disabling udp tunnel segmentation offload, just like
vxlan_build_skb does.

Drivers for NIC may invoke vxlan_features_check to check the
inner_protocol in skb for vxlan packets to decide whether to disable
NETIF_F_GSO_MASK. Currently it sets inner_protocol as the original
skb->protocol, that will make mlx5_core disable TSO and lead to huge
performance degradation.

Signed-off-by: huangxuesen <huangxuesen@kuaishou.com>
Signed-off-by: chengzhiyong <chengzhiyong@kuaishou.com>
Signed-off-by: wangli <wangli09@kuaishou.com>
---
 net/core/filter.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee72402..f8d3ba3fe10f 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3466,7 +3466,12 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 		skb->inner_mac_header = inner_net - inner_mac_len;
 		skb->inner_network_header = inner_net;
 		skb->inner_transport_header = inner_trans;
-		skb_set_inner_protocol(skb, skb->protocol);
+
+		if (flags & BPF_F_ADJ_ROOM_ENCAP_L4_UDP &&
+		    inner_mac_len == ETH_HLEN)
+			skb_set_inner_protocol(skb, htons(ETH_P_TEB));
+		else
+			skb_set_inner_protocol(skb, skb->protocol);
 
 		skb->encapsulation = 1;
 		skb_set_network_header(skb, mac_len);
-- 
2.28.0

