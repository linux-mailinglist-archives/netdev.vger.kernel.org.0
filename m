Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3CF542D1B7
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 06:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbhJNExD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 00:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhJNExD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 00:53:03 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC745C061746;
        Wed, 13 Oct 2021 21:50:58 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id b12so4759837qtq.3;
        Wed, 13 Oct 2021 21:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jK7Q7E6i+ZoIujPcPy074Lb3x9EKhyYtkiDI4ANwemE=;
        b=Fc0TdBIHYwV/JaXlXDcrDnLBCz/g64+qDiQR0lHCAQJN8EPHuKqrNSxmbKLLCzvsgs
         YjPH1Qo2uGRpw1I7GYyRAL9OXmCwO+TK6/DrnBIOqff6t4WLYz0Trj11mNgp99JhokDz
         mrswgj1OD+R8/hxXLL8WMmEEk1Zj3hyTOMkOU6pTgJT1rxLoCAtQsvGpC7N3NvuSvuZR
         nwCv6/QRWAB7X+ybDwlRRewtQBx1a12VVHMUwku5SYrPVhr9b8sQN8nhr7/n9lPlZzMQ
         h6j4x5UCyeC1kowMBXuulplMF/GFx6+XDs3gn8EvzLeoiucsRPwTKKwXb0i8JEZvXihO
         5I5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jK7Q7E6i+ZoIujPcPy074Lb3x9EKhyYtkiDI4ANwemE=;
        b=Dzn27//P5PxdNoAitx81PeCojjFSpC6pI0WfCF5GMaLeOx+Ya4zdzuEUTzXLSMAvaM
         26goBd6v1XreuSVRw8yJyx2iPYyX6Ym755Khh90Al7QFh15S9pG/EtXMMkXEs0JZaB9p
         z/fFbJ7xa0cXHKVERORRqfaMeGxU0yauKf3DOc4lmNCaCpR5ST8cM1wVFvqvnaC+Bz21
         xO8K9qiXqtWsnb1y11QVKx3Ml2fO93m3UNBqyc8CZ3kVNWEk+hqfa4cqogjS5sLkDWS1
         tOVRZE1ZEzOA9mcYCqcPYQ5fopC1a0n1wx5i3PfF3hG9m3vyNgmQGc+07SXK6P+P4PuC
         Sr+g==
X-Gm-Message-State: AOAM530J4zg1nsGF8feDeiZRMcrrmhdYzCVC28b4DQV7R67JZqEpFXfN
        tfTBe9TwPU4M107j8Ckq5R8USZ6UG8haQA==
X-Google-Smtp-Source: ABdhPJzSRdeVtLfEjqpbdSG9OIB4vNUhogtXtthki7w1xukJ9mVj1GaTgCYuWr2KcsXLSzhPmzGwGA==
X-Received: by 2002:ac8:5f4f:: with SMTP id y15mr4126335qta.19.1634187057539;
        Wed, 13 Oct 2021 21:50:57 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i67sm869534qkd.90.2021.10.13.21.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 21:50:56 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net] sctp: fix transport encap_port update in sctp_vtag_verify
Date:   Thu, 14 Oct 2021 00:50:55 -0400
Message-Id: <acbf36fdcdbe862de562d0d77fc918d8a886ba96.1634187055.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

transport encap_port update should be updated when sctp_vtag_verify()
succeeds, namely, returns 1, not returns 0. Correct it in this patch.

While at it, also fix the indentation.

Fixes: a1dd2cf2f1ae ("sctp: allow changing transport encap_port by peer packets")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sm.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/sctp/sm.h b/include/net/sctp/sm.h
index 2eb6d7c2c931..f37c7a558d6d 100644
--- a/include/net/sctp/sm.h
+++ b/include/net/sctp/sm.h
@@ -384,11 +384,11 @@ sctp_vtag_verify(const struct sctp_chunk *chunk,
 	 * Verification Tag value does not match the receiver's own
 	 * tag value, the receiver shall silently discard the packet...
 	 */
-        if (ntohl(chunk->sctp_hdr->vtag) == asoc->c.my_vtag)
-                return 1;
+	if (ntohl(chunk->sctp_hdr->vtag) != asoc->c.my_vtag)
+		return 0;
 
 	chunk->transport->encap_port = SCTP_INPUT_CB(chunk->skb)->encap_port;
-	return 0;
+	return 1;
 }
 
 /* Check VTAG of the packet matches the sender's own tag and the T bit is
-- 
2.27.0

