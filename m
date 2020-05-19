Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47C801D92B0
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbgESI5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:57:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgESI5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 04:57:41 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC3BC061A0C;
        Tue, 19 May 2020 01:57:41 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n18so6222811pfa.2;
        Tue, 19 May 2020 01:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=j8ObAxxVWs8w8QCW5X9TPd8dp69nKdKyrhYqCL5nbSU1+EnBDZJfc3GquxUU9gvAmt
         kF5czfN8z2hXpRzyTPjGqj5sI2WQ2msimEREyRVwcrFo/QGnbdFm310J/6oiXHFaVFDY
         P7Cf1c0G9Q5tUSa1Ls8AX+xPKLTHXg++/K/6Od1mANtxMyYbhAQzDV8Hn1dn9gmsnGwP
         szr4GQAkMdomeMZO9He46qcX7fMyHkC9r4/oHLRoQtIb+S2l/Mdak/XmGFcjmSS5GjSk
         REe6CqohWocpbj9w3rxAcJfdkwJ6P9tSi+Ee8irmIhl2OrFvtNKyNBQkLSGQYK138kfW
         7yTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l+ZitJMelLTFgi5ias/6H8gqKi08+ZfSOF9+XZodPuU=;
        b=WF/Cjm6lcySdLjDjztXgdaeucX+5UvzjrydV+PE8tzKlBGyBvHcZKZW4QroSadUJzo
         DE/BRs/dJMt7NJgf3qb3T2h6DxNTp6Sc7ITUOffTyrpdlARYiwZxWmQD+d7CswXwvndN
         FGLm20Ar4BU6i595D9CcZ7q6oVbq8Y+K4Xipihy1vSNRot1DJJoF5vna0wW0bflMw3AP
         M03LPHop6jIuvRwwKFotSJLPN1q5V226uGmSiPAJiii6IOqqYsb9aFcJuOOiHP/VPu9h
         +Tf19wUJAMMt3RL3ptbi1LlusqfAPl8Uqof9NlHD4dgZ3+OCzy5tdpwHSkMgZMLgjq6D
         WGqg==
X-Gm-Message-State: AOAM531T6zwekBRYYjS47hkpyAJY/k71EDMlXZzpjJNSBxoMpf823v7T
        wmUu1MWRqEF30o5GerLypPE=
X-Google-Smtp-Source: ABdhPJwqRE6M7GzqHvxjWUCdxLAOdca31qEGjvZRDzLqCsO/NLqCnbL9ykQx5jZS8ols12NR+7zizQ==
X-Received: by 2002:a65:51c7:: with SMTP id i7mr18865979pgq.382.1589878661253;
        Tue, 19 May 2020 01:57:41 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id k18sm5765748pfg.217.2020.05.19.01.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 May 2020 01:57:40 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        jeffrey.t.kirsher@intel.com
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        maximmi@mellanox.com, maciej.fijalkowski@intel.com
Subject: [PATCH bpf-next v3 01/15] xsk: fix xsk_umem_xdp_frame_sz()
Date:   Tue, 19 May 2020 10:57:10 +0200
Message-Id: <20200519085724.294949-2-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200519085724.294949-1-bjorn.topel@gmail.com>
References: <20200519085724.294949-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Calculating the "data_hard_end" for an XDP buffer coming from AF_XDP
zero-copy mode, the return value of xsk_umem_xdp_frame_sz() is added
to "data_hard_start".

Currently, the chunk size of the UMEM is returned by
xsk_umem_xdp_frame_sz(). This is not correct, if the fixed UMEM
headroom is non-zero. Fix this by returning the chunk_size without the
UMEM headroom.

Fixes: 2a637c5b1aaf ("xdp: For Intel AF_XDP drivers add XDP frame_sz")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 include/net/xdp_sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index abd72de25fa4..6b1137ce1692 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -239,7 +239,7 @@ static inline u64 xsk_umem_adjust_offset(struct xdp_umem *umem, u64 address,
 
 static inline u32 xsk_umem_xdp_frame_sz(struct xdp_umem *umem)
 {
-	return umem->chunk_size_nohr + umem->headroom;
+	return umem->chunk_size_nohr;
 }
 
 #else
-- 
2.25.1

