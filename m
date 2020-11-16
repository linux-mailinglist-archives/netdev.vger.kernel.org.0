Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 160082B4261
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 12:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729645AbgKPLN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 06:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728211AbgKPLNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 06:13:55 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B577C0613CF;
        Mon, 16 Nov 2020 03:13:55 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id p68so2448357pga.6;
        Mon, 16 Nov 2020 03:13:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bAeSUpBLbjOCEiLqRz8yHChict8yQeBE89i4qMRCUYE=;
        b=HRCZiGhfMze/cT5wkg+jlzsWbS+rxF+M74VHbs97vSlv4BcozFiJz4X5bULSA4eYGX
         oXA9P2hKK6KgmqvqgtJqqY0kXLZw0eX4QZpq8jDHudx3xROAALtPd9eRsYYVOyX92kIL
         ipHf9kmhuFfB2tYdh7dGrbY63rgvcPAYWqaUQJP2TLY0VsBJ6OeNaR9XpVWXYx45Upa0
         VlPceHOcu5NldcF798EeqbU4hh19dGE1AuMzsrLl6Ja/nT+zdtKMhRrWKSJ8XmYBzoXB
         onxai0vJ6XujhSgUcUcSeXY+yEBOPNTfxOzdQxMUu/fa284GHOB/cZn+eDAGaSjp7ZpT
         vr1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bAeSUpBLbjOCEiLqRz8yHChict8yQeBE89i4qMRCUYE=;
        b=TC4SrMHIjwXb06qcWAgfUTLKOGizbQCJKNICiLIWm+9MSRLTGtkjCz2kHV5ohn3gcm
         jdrzHujrOhjPPv/+07yFdd3uI65bAO1pck8SJwL0iZjTJsr8JKZCjsPAv9+tAO32Onj+
         d2zFpCgJuDK35AEz1fjK3rhTZqHOWKh0dy86zDVbW8xu+nn9FAbf2tYiFyVifjdZEHkn
         grh2l51H3SMjC18hpilGbj3Ubpchiqy91UabhjKo/IFKnDwXje+lTpq1zPE7O++epmPY
         5o2RfMBYNHBf5eP5J2R4WUx+shxcO1TO3QGwu7SAkiXI/EPibg10RwgdFqDvsO0D8fe2
         O//A==
X-Gm-Message-State: AOAM532LOVgRd2Q1EEqZ4ak0rlDgp5Mu0RTCBjeLc+rHxCTWCBArwzn4
        dsybp186VweCmQgOt9LUZao=
X-Google-Smtp-Source: ABdhPJx783S1CRCdIOA53Z4HGpeqjGAjBbOjl5cElVHcw6E5vtxhwsc0gOevd4EBaRZuUaGtKPawbw==
X-Received: by 2002:a17:90a:bc4c:: with SMTP id t12mr14790488pjv.163.1605525235215;
        Mon, 16 Nov 2020 03:13:55 -0800 (PST)
Received: from localhost.localdomain ([192.55.54.40])
        by smtp.gmail.com with ESMTPSA id u24sm19486826pfm.81.2020.11.16.03.13.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 16 Nov 2020 03:13:54 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v3 3/5] xsk: introduce padding between more ring pointers
Date:   Mon, 16 Nov 2020 12:12:45 +0100
Message-Id: <1605525167-14450-4-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605525167-14450-1-git-send-email-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Introduce one cache line worth of padding between the consumer pointer
and the flags field as well as between the flags field and the start
of the descriptors in all the lockless rings. This so that the x86 HW
adjacency prefetcher will not prefetch the adjacent pointer/field when
only one pointer/field is going to be used. This improves throughput
performance for the l2fwd sample app with 1% on my machine with HW
prefetching turned on in the BIOS.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
---
 net/xdp/xsk_queue.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index cdb9cf3..74fac80 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -18,9 +18,11 @@ struct xdp_ring {
 	/* Hinder the adjacent cache prefetcher to prefetch the consumer
 	 * pointer if the producer pointer is touched and vice versa.
 	 */
-	u32 pad ____cacheline_aligned_in_smp;
+	u32 pad1 ____cacheline_aligned_in_smp;
 	u32 consumer ____cacheline_aligned_in_smp;
+	u32 pad2 ____cacheline_aligned_in_smp;
 	u32 flags;
+	u32 pad3 ____cacheline_aligned_in_smp;
 };
 
 /* Used for the RX and TX queues for packets */
-- 
2.7.4

