Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1CE62B27AA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 23:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgKMWAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 17:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbgKMWAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 17:00:14 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DD1C0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:32 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id w14so8765697pfd.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 13:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A8zsfPytFTy/hwu5xUSP68j8CCLrpITrvZlUE5OJS6w=;
        b=iVdH0d/PiEqdDbwFXAs6KdkN08BeCx5jiJz8EEKquqzW7+PFwfU7B0XnBdJWwEb//5
         hr8vXFsyqRLoEpAUkS8rSYgJnrnso6WxkaHwiC18YAljmOFNHUyBiDj40qYQMF0JfuVv
         DfyztPcfopFh61FTja/GUZi/mfUTLE1KsTZlidUOiONd1IZCk1KWinSq03Dm3Z2/+yPS
         ZlmpYPfewzxqjr6rdnUUpHRejdmUsZM1GT3xgXxiP9yqWD96iTlkr0wDLHIfaGib+oD4
         RAJwj1HiV9t7BCFdPTqBLD2Hda4CIM1IoXiQPxCwIzlkenRkSye5a+H5h76xi+94Eoan
         eJ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A8zsfPytFTy/hwu5xUSP68j8CCLrpITrvZlUE5OJS6w=;
        b=BkbgQQYejw+N+tVNvKr7Qe0Lhk/0N/9N/APJdpp5kufOIIUgupsM9m+r080Ww03CAf
         pbkwTtDIMdSl22Vos/FsapT7E3Hs1MEfpaQEBuoaTN5+HsQVpwMxvMkLmGYp7yOkjJ+h
         tt2wYl9Rb34p+3LRlILNlnOM7ZIQT9Ob3BDnaPyirGw535ARZpawpZqJGC37R1UkOWw5
         EGyfQggMh+ZeNwqlhsQRRQ3WanUwyj++2WaB5G4+HmybsNpZxrdUh/4x5XQ8IB46Rxkv
         XtqcJi82gkJGDz87tBrBWGg7BztFCdI1msTjvhANmukqKWAHXeFTPzxTsQMiTE9hHuK7
         VpAQ==
X-Gm-Message-State: AOAM530q15ua1pcJy3O2O+RSrgFX3JIraK98wh4uaDQlIH8Y4crVnjXS
        MGSUD0uSZf8WZJoOpOPJRSpN55sc/8thn6vF
X-Google-Smtp-Source: ABdhPJw8JesWU6LdHyg6pYPiZ+3qwu576IoDahPAnpFwxzdvH06S4yIC3rcDDs/WoH4VXFDsDeFdPw==
X-Received: by 2002:a17:90a:17a5:: with SMTP id q34mr5313534pja.4.1605304772258;
        Fri, 13 Nov 2020 13:59:32 -0800 (PST)
Received: from aroeseler-LY545.hsd1.ca.comcast.net ([2601:648:8400:9ef4:34d:9355:e74:4f1b])
        by smtp.googlemail.com with ESMTPSA id t85sm9310056pgb.29.2020.11.13.13.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 13:59:31 -0800 (PST)
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     davem@davemloft.net
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/3] net: add support for sending probe messages
Date:   Fri, 13 Nov 2020 13:59:30 -0800
Message-Id: <6e867d127ad9c6b40f2de312b22fd4ee331331a6.1605303918.git.andreas.a.roeseler@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
References: <cover.1605303918.git.andreas.a.roeseler@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Modifying the ping_supported function to support probe message types allows the
user to send probe requests through the existing framework for
sending ping requests.

Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
---
 net/ipv4/ping.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 248856b301c4..0077ef838fef 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -453,7 +453,9 @@ EXPORT_SYMBOL_GPL(ping_bind);
 static inline int ping_supported(int family, int type, int code)
 {
 	return (family == AF_INET && type == ICMP_ECHO && code == 0) ||
-	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0);
+	       (family == AF_INET && type == ICMP_EXT_ECHO  && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_ECHO_REQUEST && code == 0) ||
+	       (family == AF_INET6 && type == ICMPV6_EXT_ECHO_REQUEST && code == 0);
 }
 
 /*
-- 
2.29.2

