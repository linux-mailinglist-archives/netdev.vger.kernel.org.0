Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0F0D2D7863
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406424AbgLKO6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 09:58:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406403AbgLKO6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 09:58:14 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3C7C0613D6;
        Fri, 11 Dec 2020 06:57:34 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id i3so7150428pfd.6;
        Fri, 11 Dec 2020 06:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0zHk7EvBmUvHalVg3tJqPcBK4UoTwgMaJQ6bNwcn394=;
        b=iEjrBYlAAonFO9lBncbMDK/ImhO/uYrR1YIQh9Y3ATTXqJTN4jmBNXS/iaw/h9NqdL
         O0TtBXV0Gsl1xCi5caEs5oX9NmdqMQWcBchNbfAdLpS7YdXyfY7bqONMQegG4fHPistl
         s7ihmm2vJw+RgSnNXfBdgHwJyhVYu7IbY+mw3cF138gPv+eQ1hu02khftCy5SbmAJEtc
         f/mcd4NQQ0TLl3+jNle4PQRET/DkegRRKScTXu9RtpvuPqpe+3UfHLeKnPAagYPrjbl0
         UTUdsyAs1xuB8CK2YDPB2kEHzCZku0sVFPHuVmBZTF9jWDP8TIq02EzlNHwt7BAo6VIX
         B2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0zHk7EvBmUvHalVg3tJqPcBK4UoTwgMaJQ6bNwcn394=;
        b=XFRnGR/7pKNb0oQYWahRIc8j8zu5vDwvI2g7hlKrEKMLPf/xCCWEImopHaAB+IvUMg
         7xywk87ptym6eMLepXDk8DLWnla1ULIGmL1vs1La/5+uBP9X2qLgTWtQONSl3mF5ghsC
         X9ZjXyBBMqnWXFy8q4NCct7A2SMJ1Z4BDNad+xrrZqkSVXP4mcqvJ8631zJwyBgDCNj1
         MjB+m10oCLowVJ9NPaTzi9fgDBuhH03xaYZAOUlC9KCU+prP0CWFjgrA1wffNj8Pi50l
         KvZzqwI+OwPNr90Q+kUkYdEs6UZDq3XbiUP/csu7xldDy5JqrVdJ/vkNqEst04dUmM0d
         SueA==
X-Gm-Message-State: AOAM530T9q56V7zxJViQMd5bB7F7CCtHxLcFB530uAL8Zn1feYbl/8aJ
        QaBpT8nwSHXiS4kqnzj7Deg=
X-Google-Smtp-Source: ABdhPJy+oMtVfQNttQdM8jLOQcNcy6+vYzX4kdWFd3yoHOPWfwAPklr/0SUDdMDmH+JIrVT4a7Pagg==
X-Received: by 2002:a63:1764:: with SMTP id 36mr12095932pgx.177.1607698654288;
        Fri, 11 Dec 2020 06:57:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id k23sm10583085pfk.50.2020.12.11.06.57.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:57:33 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, maciej.fijalkowski@intel.com
Subject: [PATCH net 2/2] i40e, xsk: clear the status bits for the next_to_use descriptor
Date:   Fri, 11 Dec 2020 15:57:12 +0100
Message-Id: <20201211145712.72957-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201211145712.72957-1-bjorn.topel@gmail.com>
References: <20201211145712.72957-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

On the Rx side, the next_to_use index points to the next item in the
HW ring to be refilled/allocated, and next_to_clean points to the next
item to potentially be processed.

When the HW Rx ring is fully refilled, i.e. no packets has been
processed, the next_to_use will be next_to_clean - 1. When the ring is
fully processed next_to_clean will be equal to next_to_use. The latter
case is where a bug is triggered.

If the next_to_use bits are not cleared, and the "fully processed"
state is entered, a stale descriptor can be processed.

The skb-path correctly clear the status bit for the next_to_use
descriptor, but the AF_XDP zero-copy path did not do that.

This change adds the status bits clearing of the next_to_use
descriptor.

Fixes: 3b4f0b66c2b3 ("i40e, xsk: Migrate to new MEM_TYPE_XSK_BUFF_POOL")
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 567fd67e900e..e402c62eb313 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -219,8 +219,11 @@ bool i40e_alloc_rx_buffers_zc(struct i40e_ring *rx_ring, u16 count)
 	} while (count);
 
 no_buffers:
-	if (rx_ring->next_to_use != ntu)
+	if (rx_ring->next_to_use != ntu) {
+		/* clear the status bits for the next_to_use descriptor */
+		rx_desc->wb.qword1.status_error_len = 0;
 		i40e_release_rx_desc(rx_ring, ntu);
+	}
 
 	return ok;
 }
-- 
2.27.0

