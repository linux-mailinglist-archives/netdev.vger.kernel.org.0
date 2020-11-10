Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3A32AD455
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 12:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730370AbgKJLCT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 06:02:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730291AbgKJLCR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 06:02:17 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF0EC0613D1;
        Tue, 10 Nov 2020 03:02:17 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w14so8478418pfd.7;
        Tue, 10 Nov 2020 03:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=bAeSUpBLbjOCEiLqRz8yHChict8yQeBE89i4qMRCUYE=;
        b=ukDfondez4f1XSppfnFc+BqF8nQ4L3FdFhCthj7LN4hHv62Bc6btOnZghg75/vUhoC
         SgBLIjpr3dnU39LDAiTywvdqiYorGMLmYViWeiBMTc2vcSU+oKypGOfj3ctC4gOMAqv1
         2BxuTVAg0FPF7IYzCWFasiov0yQN00GObJQWmVDQ4INjoONNHlP8MeV9Tsl3sXBziEHP
         dzVv+3U7r4iVqELVVMQkBkItHS2+aJ4nLgG4wTWhbrJ0LQNlPl1h+sUQDbUzxHmfXAVr
         R/zwAK00jdJuFb0ZQokoY75S4oyzlHUfRhlLxLRbi0CMB6AxlRB1g635DAAC3vop7rj8
         dHDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=bAeSUpBLbjOCEiLqRz8yHChict8yQeBE89i4qMRCUYE=;
        b=GEFr75U2pvKv3PKRrDraw4VuA8PWPPxx/9rHXBZQjt8rV8b3xxE/hwwDojC7oDlUPL
         Ck+rX4TrWoDPqUuQE6rr0TdpFPJ66JMC6gAP7hS/LfE7f4bQth1MUGh7NwTa9ibmhEy6
         nvohEyifYBDomW7O0EB61ebdCqK8aUSwPc3lKhxRQLFCObXoG3qdqSZj2ykzjAZcH8o2
         X7togiAx3oReD4eIfU+cVoB6GAStXm0VThzGmD1/+yHbDBGMzrEp/Bu5/FrPsuMP6dj5
         N/RJiK0TpfSFjNdu5WZU9pKPJ+qMtxsN9TrTKw4OOvZOrq/K7ZvQYOMelDm7qWFIEZlT
         En3w==
X-Gm-Message-State: AOAM5307AfIDe6BX2vvvfDfh0hugdAYhyGqwTyJNEFiHqYUm3g/gKmAF
        VFqVesHe3e02+0+ZWUUpRRA=
X-Google-Smtp-Source: ABdhPJxAFPJE7ck3w/rJbVJgGyaBFc5nGW5An7BtutpvMMirfepfVJnKzWTpZoLEvdslA1CaiziadA==
X-Received: by 2002:a17:90b:395:: with SMTP id ga21mr4396814pjb.219.1605006137204;
        Tue, 10 Nov 2020 03:02:17 -0800 (PST)
Received: from VM.ger.corp.intel.com ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id 22sm3012024pjb.40.2020.11.10.03.02.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Nov 2020 03:02:16 -0800 (PST)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        jonathan.lemon@gmail.com, kuba@kernel.org, john.fastabend@gmail.com
Cc:     bpf@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        anthony.l.nguyen@intel.com, maciej.fijalkowski@intel.com,
        maciejromanfijalkowski@gmail.com, intel-wired-lan@lists.osuosl.org
Subject: [PATCH bpf-next v2 3/5] xsk: introduce padding between more ring pointers
Date:   Tue, 10 Nov 2020 12:01:32 +0100
Message-Id: <1605006094-31097-4-git-send-email-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
References: <1605006094-31097-1-git-send-email-magnus.karlsson@gmail.com>
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

