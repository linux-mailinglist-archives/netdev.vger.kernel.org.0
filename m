Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53901FD4D2
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 20:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgFQSsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 14:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726835AbgFQSsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 14:48:35 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A58C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id w9so3680169ybt.2
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 11:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SDeYkckQM2DOazZCNWpIB/WKaZkfa+VmdFmYqfni9L0=;
        b=p0LrlUVCNh8e8k6mJOLzWsg7vmaCuHp1gnDQid2+Tqe6gjP8O923qlY2dDFfPjw4K3
         5NIWZ3FGUEVsyBCBVAsjD2dX+V6VWMhEiNuj+BESgNGI/k69kWkvDWOGatIWzjPD8fEg
         qCp2nz7iZak/wSStgmk1fvFA3daZ4UBIx4glIPJwFuZ60AABY9pX+vjY4/Zq/Dz70p/z
         1tGxtOTism937mfVlMo5u0XejVhDWL2qqrMk4LPeyz1tj9efkuq9wMxwgJwwuEgI8M6R
         untIdTF0rbe6uIqAPVD2fadDxZ0362x8YwdOP84a0dvwM6EAF+zEk+JrF9KSuIIBUzlU
         1m2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SDeYkckQM2DOazZCNWpIB/WKaZkfa+VmdFmYqfni9L0=;
        b=Z7RtX7fhwSeRm2fH45RpD+349IyWsrtCb1onzlziYce4kDC7W42Lr9wamM2zCkyZge
         zCsXj3fDcbajO3NWLcYrvDrEENUW4/SDg0dclW/C4JP6EYwbq8ZtDQKkoc9bXzZ0GqO2
         ifg+PfAaMbrXmIW/boWfetF/FFDAE1nnCs9Z4APWWd2Y3f2o1BaUPMtJIt66dOtfTHHy
         WupthExJ6+VPXNdRydA/RpoRdEmlwO/68OqqaFyg+3kdGuYE+D40OugCr8IjWDoeY9dT
         vyfXO6vlI9OFV5HuYPv2vIdKoaLBOCzh9Z3mciAK7vXKr0fg/dC6w5vq/8cuWrdKeJCA
         8nvQ==
X-Gm-Message-State: AOAM5311H67CsVxPydu+785DMviYsyilH6VdvBe0e+QLAmS5rlLnWQqp
        uTALSm41D9HbqPWcnMSb58fKpyr3+T11HA==
X-Google-Smtp-Source: ABdhPJz6ImCoRmb5+UXuiDqqdeuFvGsoEUQNygwEQ6NyyYwnPjt/uqpuI21IT2Y4d+DHeckbUqVcSV9o4JqEjA==
X-Received: by 2002:a25:cf82:: with SMTP id f124mr402405ybg.441.1592419714115;
 Wed, 17 Jun 2020 11:48:34 -0700 (PDT)
Date:   Wed, 17 Jun 2020 11:48:16 -0700
In-Reply-To: <20200617184819.49986-1-edumazet@google.com>
Message-Id: <20200617184819.49986-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200617184819.49986-1-edumazet@google.com>
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH net-next 2/5] net: tso: shrink struct tso_t
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

size field can be an int, no need for size_t

Removes a 32bit hole on 64bit kernels.

And align fields for better readability.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/tso.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/net/tso.h b/include/net/tso.h
index c33dd00c161f7a6aa65f586b0ceede46af2e8730..d9b0a14b2a57b388ae4518fc63497ffd600b8887 100644
--- a/include/net/tso.h
+++ b/include/net/tso.h
@@ -7,12 +7,12 @@
 #define TSO_HEADER_SIZE		256
 
 struct tso_t {
-	int next_frag_idx;
-	void *data;
-	size_t size;
-	u16 ip_id;
-	bool ipv6;
-	u32 tcp_seq;
+	int	next_frag_idx;
+	int	size;
+	void	*data;
+	u16	ip_id;
+	bool	ipv6;
+	u32	tcp_seq;
 };
 
 int tso_count_descs(struct sk_buff *skb);
-- 
2.27.0.290.gba653c62da-goog

