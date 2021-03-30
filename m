Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B8B34DDBD
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhC3Bpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhC3BpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 21:45:25 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24C25C061762
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:25 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id m21-20020a9d7ad50000b02901b83efc84a0so14099096otn.10
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 18:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=sjdiIKj8jBI94tLeS/ACxHnKtsI/g/KngzQkwxEndDXMSwJAeRwUNGSADxXXlmIA6U
         C2Hez6wCQys33NvpvjbxeTl3VgCekQd3yya13toFUwr+x/ipFUUvQpIOAtnWcVbfzuxD
         8DlCdi/eMwyuIKstBfer8BT2RJcasqytwU8XkjTvxbp3LNhq2yf+KnqC8Lo4Y6vy0clJ
         ddJzDjcpaJ7O4k15eJyT5DTPf6Tz3AjNR43Ge3Hu1W4Qf8cXx/WDE7Pi4tZOxSkQYCyS
         5J4zOufGQa/+L2ci9XoW6XBy0bvZOeOiWS8K5d9zG2agFOdTrk+VtZSjOVQRYn8yIgWr
         uplA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Lio5CHdjePdGCdvRLilg1iaYE0Vy2lHPlsFlnZ4SNRQ=;
        b=m6JuKAo7uxyjsFaAIlz7069ZUSH1CZ4ZpiB8vkdrw5l7hkcZhA9DXPn8BarEZoUuVJ
         4+EH72FSfI5liKUmGji7ALPhUgjg65TWYgT1rabJExnxwj3UCzYPztii4y6J6G/zfACb
         LQNIugg2DGDLtJ0lUhaKFagMfB6I93RQFewJKaEchLpNh36iJg9rnxAPTkL6YM5jifQK
         kFlTFxvHZmry1BvraBxKnGFtrdL3+hCAxEYhuB+jalL+tdbEI4t2EPGQe1PY3Cc+J311
         v32/281dJQyvy3E/Q/tZ1S/bUWGoNI1HxzzuKdAbmutDSR2y+t3Y+SiSMI6RHuQkaTY8
         5IZQ==
X-Gm-Message-State: AOAM533y1UfXywAeDaI8uVq4avOfjS9ED8j1WsOIel7FJPoyW0EP9h7k
        OLyeLk50wsx1cS0NSc8CDiT+2kHyXDo=
X-Google-Smtp-Source: ABdhPJxXp0GKhIh6inC/XImdrcx97gJ5Msdr66vaGa/tTqtyzTnAY6+vEo5nRCzb7nGf28reEMBK3Q==
X-Received: by 2002:a05:6830:817:: with SMTP id r23mr24399653ots.234.1617068724556;
        Mon, 29 Mar 2021 18:45:24 -0700 (PDT)
Received: from clinic20-Precision-T3610.hsd1.ut.comcast.net ([2601:681:8800:baf9:35b:834f:7126:8db])
        by smtp.googlemail.com with ESMTPSA id j11sm3191262ooo.45.2021.03.29.18.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 18:45:24 -0700 (PDT)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: [PATCH net-next V6 2/6] ICMPV6: add support for RFC 8335 PROBE
Date:   Mon, 29 Mar 2021 18:45:21 -0700
Message-Id: <3d570c53c4b3f4932a6011a699db06e732cb7b0c.1617067968.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
References: <cover.1617067968.git.andreas.a.roeseler@gmail.com>
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

