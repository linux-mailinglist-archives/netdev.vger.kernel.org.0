Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAF23F5C6F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 12:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236394AbhHXKxr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 06:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236150AbhHXKxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 06:53:45 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A3FCC061757;
        Tue, 24 Aug 2021 03:53:01 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id c17so19395718pgc.0;
        Tue, 24 Aug 2021 03:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNPUq/my7v0mlOT+sydB1v9A4usTz8ZuFnFZblPYipE=;
        b=ac6NqL2kYMbSjIW7lO8U2EAfeZ8ZSvdYpRAN5FtVqf26LMPDTR/PlH9M2ZVJqumiQW
         RJDD+CSR17WXxqAkHvZ0bDjZ08DUhoo9s+30kz8LmAM0Q5g52gTe1ZAN3aG+YV5Wls8z
         ehmq4UcLfCOGpaui3XKMdm9knQgZO0LvG6jZkyqUnadxQQVmu0vU9X3iDAFyJhQhptTt
         LMzauYG6fQWOJbmpUlMzdAWEGD9PZD5pCdGe/baFjq5R5Gw9fo8Yk6bqQ6pXfPeri4Mv
         BIcAnN0KkSLu472Ek1yiBAUbpXNK/vaY9z6jz4/hhrwlCM5R2hD2ugLKZh2+1u8HWvRw
         zYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LNPUq/my7v0mlOT+sydB1v9A4usTz8ZuFnFZblPYipE=;
        b=og7vJphA2O2qLFFTXPOXq+DK/AMHthuHJX72vVrHcGeP15yQAhCqNlXDXLnLNzEC5u
         O5Qi7BfFsgY2tWOTtU1NfORmiE6hGvg/XFP6mhDZMng/39WEO8nlF7gcaJ1C9kYvhKYv
         jonBpNTnIoXBzgcxRQF7C8k49XCQbxYreb4VvNCFYPoSk8GR/qaUOVtGjsO86iwBdJng
         ILG2+IaoBYVj4Y0Q7lIbDmYRxqbLLrZEsDOREqLEs0GOYVirkfyMcF/mIjjJ7YxUgbxO
         HAN4DBRKtL9BmSAVPi6uOeREljmjFXYIYK/tl8AUVy7x3sG1t3/pJKf7GQDFeDibvtWO
         AhXQ==
X-Gm-Message-State: AOAM530WLEIJfkweq0bVm1KjNVezXljArMNqexhnjaI45D/4IuEK32UY
        isOJ1wqakVMhDk5un5vYA24=
X-Google-Smtp-Source: ABdhPJyDnSmefDKPzZ1Z0XNecxC4jE/Ejbls2ucBKiWsPZI9M7jABvsh6Bf8IyUVEzp6yyrPXBJaLw==
X-Received: by 2002:a63:170d:: with SMTP id x13mr35222225pgl.216.1629802380966;
        Tue, 24 Aug 2021 03:53:00 -0700 (PDT)
Received: from localhost.localdomain ([162.219.34.246])
        by smtp.gmail.com with ESMTPSA id q12sm2085126pfj.153.2021.08.24.03.52.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Aug 2021 03:53:00 -0700 (PDT)
From:   kerneljasonxing@gmail.com
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <xingwanli@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Subject: [PATCH] ixgbe: let the xdpdrv work with more than 64 cpus
Date:   Tue, 24 Aug 2021 18:49:18 +0800
Message-Id: <20210824104918.7930-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <xingwanli@kuaishou.com>

Originally, ixgbe driver doesn't allow the mounting of xdpdrv if the
server is equipped with more than 64 cpus online. So it turns out that
the loading of xdpdrv causes the "NOMEM" failure.

Actually, we can adjust the algorithm and then make it work, which has
no harm at all, only if we set the maxmium number of xdp queues.

Fixes: 33fdc82f08 ("ixgbe: add support for XDP_TX action")
Co-developed-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Shujin Li <lishujin@kuaishou.com>
Signed-off-by: Jason Xing <xingwanli@kuaishou.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c  | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index 0218f6c..5953996 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -299,7 +299,7 @@ static void ixgbe_cache_ring_register(struct ixgbe_adapter *adapter)
 
 static int ixgbe_xdp_queues(struct ixgbe_adapter *adapter)
 {
-	return adapter->xdp_prog ? nr_cpu_ids : 0;
+	return adapter->xdp_prog ? min_t(int, MAX_XDP_QUEUES, nr_cpu_ids) : 0;
 }
 
 #define IXGBE_RSS_64Q_MASK	0x3F
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 14aea40..b36d16b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10130,9 +10130,6 @@ static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
 			return -EINVAL;
 	}
 
-	if (nr_cpu_ids > MAX_XDP_QUEUES)
-		return -ENOMEM;
-
 	old_prog = xchg(&adapter->xdp_prog, prog);
 	need_reset = (!!prog != !!old_prog);
 
-- 
1.8.3.1

