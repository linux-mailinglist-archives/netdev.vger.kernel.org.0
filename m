Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E468F41BF08
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244251AbhI2GQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243585AbhI2GQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:16:12 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771C9C06161C;
        Tue, 28 Sep 2021 23:14:31 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id o19so930786wms.1;
        Tue, 28 Sep 2021 23:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjH00ULnPvaaEhtogRY+O9xuuituLohfTkt4dqW/uYQ=;
        b=XDxLNC+/BkMU+ukXAxTVk/47iebnulw5jsQWZpmYspvXM3I4rGVEijaZH9wB5yOiwM
         fmrl0R4DW+WxfpVAxASbyB+N6xH0d5bUBepGI8bHqC33ANTcYYH3hifRPzj0kUsVzUHp
         k3usFHh7crvjmsEAq3fyh6B395su83YP/TXyu3/1Jj6FrC7lKH1l92DVNDMAJuXfAn2q
         2xOqDQRWpWkKeMPuZUwyq0vKekzVi4M1ktzm7fQkDhbYvL8t3Wfv9fCj2DIQz48DApqT
         qCY6j3pPS7fOkxsuBx2JzNON80Rnkq7qp//gQGs7WWwuK/zY17DkhqqC14FOL2/YeOBi
         uALg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjH00ULnPvaaEhtogRY+O9xuuituLohfTkt4dqW/uYQ=;
        b=U7/LKmklD66HDBVNWQfH+90be/B0roUP4+9l9Tq3YWAix884SyQPDuKyBjx5e7LLkv
         Y1I4NMybt64tjmRukfVhGNxIpp9dolx0XUwtMPKKCUMcqlQMLGy2dATEFVwi2hMQ9+jA
         eSdWgSHNX/Xj9Uka44SyPWD6pIPNTMRghewwWGUZyc/a+h+zRpaPzqbWyrcP9b8T8Xh3
         2c/H7GY2zvorNtQHJD9CVgsG9KoTER9ovFhGC7e/BviDAQX8Jtr+k3teo4iVACKY1JZB
         Tv0mFAf7g67upI6j3KjTUXUU6Nr/V5j9CSfEHphr9AP7pKsf+4CYqO8MjqksOqzwUCyU
         3mVQ==
X-Gm-Message-State: AOAM532Lvsh6BeVKAtyzaPZjUESCiC8euz43Q64kJNnSOWKGd/XbU0s2
        Rnm3iSEUmvzcH8XUAsmZDD8=
X-Google-Smtp-Source: ABdhPJxnj8DbJJubIprhjnvlUiut42WY88ZFI92TSPMHEutDxnp6Jp1/4yUJ7mAe4UU4QzadPdoYhQ==
X-Received: by 2002:a1c:a757:: with SMTP id q84mr8550930wme.26.1632896070019;
        Tue, 28 Sep 2021 23:14:30 -0700 (PDT)
Received: from localhost.localdomain (213-66-48-107-no285.tbcn.telia.com. [213.66.48.107])
        by smtp.gmail.com with ESMTPSA id c15sm908017wrs.19.2021.09.28.23.14.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Sep 2021 23:14:29 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, jonathan.lemon@gmail.com,
        nathan@kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH bpf-next] xsk: fix clang build error in __xp_alloc
Date:   Wed, 29 Sep 2021 08:14:03 +0200
Message-Id: <20210929061403.8587-1-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Fix a build error with clang in __xp_alloc().

net/xdp/xsk_buff_pool.c:465:15: error: variable 'xskb' is uninitialized
when used here [-Werror,-Wuninitialized]
                        xp_release(xskb);
                                   ^~~~

This is correctly detected by clang, but not gcc. In fact, the
xp_release() statement should not be there at all in the refactored
code, so just remove it.

Fixes: 94033cd8e73b ("xsk: Optimize for aligned case")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 net/xdp/xsk_buff_pool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 96b14e51ba7e..90c4e1e819d3 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -462,7 +462,6 @@ static struct xdp_buff_xsk *__xp_alloc(struct xsk_buff_pool *pool)
 	for (;;) {
 		if (!xskq_cons_peek_addr_unchecked(pool->fq, &addr)) {
 			pool->fq->queue_empty_descs++;
-			xp_release(xskb);
 			return NULL;
 		}
 

base-commit: 72e1781a5de9e3ee804e24f7ce9a7dd85596fc51
-- 
2.29.0

