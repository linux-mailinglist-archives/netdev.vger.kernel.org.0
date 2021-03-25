Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA84349ABB
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 20:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhCYT5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 15:57:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhCYT4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 15:56:31 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1920C06174A;
        Thu, 25 Mar 2021 12:56:30 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id x21so3805994eds.4;
        Thu, 25 Mar 2021 12:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cMxe7I7l2vSX0n+XPp1Pbjsdyyq6ZSpuIHYWB6ESO5o=;
        b=D+Cw8CaDRyrGWV497QEgwi4O4sNpKjHdSOs+9Uzk1811L/Xsv1ab1O21+/S8NHveCH
         lf+KjxAYYoCTEctlvAkWxva5dPQCRgQEawEfk0Z6XElHqcgKnxx9RAhhK6Z64S/NgRR8
         C2edylmQbBF4od32hpzvhQxGc5UiD5viYy5eG6HRWT6o5Ow4h3r5z9rUmHWLKrTVezP7
         86wv9X7ZLmXa2sSTDBi0Cq9Htg3WqY6f86UrlqnMeE7v3rzgHN+brXzZuk0jYjtCxj8e
         xcWMVvKUhAFDXdbMMOcSg0DJSKTQqdLTbnhHLozqmqY+1IMvKTwbSgTw7KrQj7NhbcNY
         rQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cMxe7I7l2vSX0n+XPp1Pbjsdyyq6ZSpuIHYWB6ESO5o=;
        b=d1d3ydwwMmnJjg9JEZ8xGOLGBDF478JP7hwGbxcZnmr9omDwruVI4A6l3R0PoU4FkL
         v5W46YyeJjTm5aBtkWZrn8qSP450K7zC0ixn+eu2/HvuafVe8W5NRpNriUTbbLYyZzoW
         ycO+h4xzINQSBhKG6gpf6L6e08Tt3iwKSnTBXNtro8KmpQ7+Jixp5YcskEhEBy4PFKdm
         x9jIMiSCso5Xf/tCCZBut7jE3ew9UbXmgL1cJg6ehfq2Tg0NKM1bfQj+wuwiaFD8jsXW
         drW+mdW/hQDdP35bo/YewFgfJSxt5x9IRbwK8/qJXSK+oTWiQwf5rea7SkSg1VZvbeUn
         EyKA==
X-Gm-Message-State: AOAM532rEqXBeJT9tYHoVdRvF0DzlZjABGk0Bg3L673Gv1fJGhLLPdiC
        QhkxuZ8dTeR58mIF2Nh0YX41RxPyyN/PLQ==
X-Google-Smtp-Source: ABdhPJyRgnmeZFf0kVwZSD5Xon7u769lr0EeDQWXEjIYbtA+q6WAJbuO1xZtIWSxVSuW/5wXqTGAhA==
X-Received: by 2002:a05:6402:34c8:: with SMTP id w8mr11430998edc.235.1616702189436;
        Thu, 25 Mar 2021 12:56:29 -0700 (PDT)
Received: from localhost.localdomain (ip-178-202-123-242.hsi09.unitymediagroup.de. [178.202.123.242])
        by smtp.googlemail.com with ESMTPSA id t17sm3144044edr.36.2021.03.25.12.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 12:56:29 -0700 (PDT)
From:   Norman Maurer <norman.maurer@googlemail.com>
X-Google-Original-From: Norman Maurer <norman_maurer@apple.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH] udp: Add support for getsockopt(..., ..., UDP_GRO, ..., ...);
Date:   Thu, 25 Mar 2021 20:56:14 +0100
Message-Id: <20210325195614.800687-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norman Maurer <norman_maurer@apple.com>

Support for UDP_GRO was added in the past but the implementation for
getsockopt was missed which did lead to an error when we tried to
retrieve the setting for UDP_GRO. This patch adds the missing switch
case for UDP_GRO

Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
 net/ipv4/udp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 4a0478b17243..99d743eb9dc4 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2754,6 +2754,10 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 		val = up->gso_size;
 		break;
 
+	case UDP_GRO:
+		val = up->gro_enabled;
+		break;
+
 	/* The following two cannot be changed on UDP sockets, the return is
 	 * always 0 (which corresponds to the full checksum coverage of UDP). */
 	case UDPLITE_SEND_CSCOV:
-- 
2.30.2

