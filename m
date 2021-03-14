Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2061833A6E9
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 17:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234514AbhCNQsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 12:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhCNQs3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 12:48:29 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D660BC061574
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:27 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id c17so1530030pfv.12
        for <netdev@vger.kernel.org>; Sun, 14 Mar 2021 09:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=WXo3hHewXk9JvkosPyM3N26wSKX9FJrpk2chPVLlk+EeMjmGKC4Vh8/0T1hEoFNVOd
         +4Lr6HyMsB0KbI2fFbQtJPjL0b81iCRlkhI3TIaykpuoV+u07mjLNRJnRtx/xKQnai0Z
         g9dx3951ZMQE1B3EHnJ94MH9J6IJEwjTLxXi3SOXMYMPAeK98DuPPslG796h2rAKmuw4
         IfYqtR1qTbjk7NxxmXEQk5ARFDgD3BRDetdcXeeQJ4hZ6gcGn4GSZqUCS3V10WCq23IO
         5GdgC/f0VtEq8t/Al9LTbapsXjhtNLC1JE4ouSIIvuhV7ToI4sFWZXdp4jIxAm601sZS
         cQSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=dZcW3EBnMbde1i+Cu/Q5llAnzPjVXzDmcDwYgQKkfkXmH6413+e+OZDDt6nhVTGcIm
         yLMyoowhPXEg7Y4G6Ae52+NiANkqR9NA+JR95YS5AuacDxMaBFsVgVCXuUFFj6CxPejy
         ISbHPQB5blFb+jHVUlSIDPG4TfyA56GEuRwa5w8Nnd9KGrs3Is1NQMfMIMoM8ji1KVUT
         y53lIom5mMuI+yN5bO5zjEyfngMdZFLGpp7LvVveOWdK9evDbrhI0SqXPie9dtDV9eTo
         DyIAABUH/nnb5J4qF9mMekKDFJKPM6AmI6ZbNp7T9BmLU+SDZ3qF/R9hPtyTiVcZS0zL
         kDnA==
X-Gm-Message-State: AOAM532FqQtYL1Cz/K3vrSSrsiT7Q7H58XajwebeWBH/KYBTTmiNRKt8
        vH7Z8vNuPJyZadciH0sX284=
X-Google-Smtp-Source: ABdhPJyR2Ire1Ced0+ItTIMqwyazr2doSeyj8Jvsq3Y5CHFB6/v9TG+o0Um3uYbf5MixFQpxLdIS4w==
X-Received: by 2002:a63:4406:: with SMTP id r6mr4870308pga.146.1615740507537;
        Sun, 14 Mar 2021 09:48:27 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:ed7e:5608:ecd4:c342])
        by smtp.googlemail.com with ESMTPSA id f19sm11339573pgl.49.2021.03.14.09.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 09:48:27 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH V4 net-next 2/5] ICMPV6: add support for RFC 8335 PROBE
Date:   Sun, 14 Mar 2021 09:48:24 -0700
Message-Id: <e21f27753a6123f5acba613f6f50fd0b43e70f4a.1615738431.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add definitions for the ICMPV6 type of Extended Echo Request and
Extended Echo Reply, as defined by sections 2 and 3 of RFC 8335.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 include/uapi/linux/icmpv6.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
index 0564fd7ccde4..ecaece3af38d 100644
--- a/include/uapi/linux/icmpv6.h
+++ b/include/uapi/linux/icmpv6.h
@@ -140,6 +140,9 @@ struct icmp6hdr {
 #define ICMPV6_UNK_OPTION		2
 #define ICMPV6_HDR_INCOMP		3
 
+/* Codes for EXT_ECHO (PROBE) */
+#define ICMPV6_EXT_ECHO_REQUEST		160
+#define ICMPV6_EXT_ECHO_REPLY		161
 /*
  *	constants for (set|get)sockopt
  */
-- 
2.17.1

