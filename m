Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2F12B708F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 21:59:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727327AbgKQU7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 15:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727253AbgKQU7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 15:59:12 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1808C0617A6
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:59:10 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w7so6007089ybk.1
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 12:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=BLk5dSFtmdiQf+dVyNBatJh0crrkpXwPxI3Zr+HNXOg=;
        b=R74DUu1MznpCPjSEy1Y1zKxE+hequl7V9yxn58RA3rnRifpmrOQiLE+LST1uvqO+5z
         f1cNuVYE1DjVi5FCzR/l6EkNzjKZ4HZidJPSusCSJSX0wBrAU4D/t6t8MVoySsyKyFa4
         dOe35ZzUw66wN3Wj8NrkhuffSYQIyJTF604oaynrulQggMlW58Wn7+ZdD7unXxVaJ0DW
         aWKdA8i15g6+zbL4aXjx4DftS36wWhJZjGf1q5Bp/j6bAEU6W9d3sf8azeVM+LngKEOQ
         fYXlYIq464lq52lHI+HqRUEmfgQLJQKXAFLHm9/CXX4GQIWQWylT6qbf0bMZadlDSxrd
         j9rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=BLk5dSFtmdiQf+dVyNBatJh0crrkpXwPxI3Zr+HNXOg=;
        b=bWu/GaJDsZtzxCoq6K19hL0/8dF+ALTwls7foUKhajE7gxfL+ZzOixUXk6oROSklHr
         UuQ7geImmYOTS5oZ1m68S44jmDnnn1wUKXD0tRMtEIUQoNw2Q/HpnK40JDiAgUyekogD
         9w9sN/pzf5vHg09ToBwd7caxIVe4u95DqFP6YIWlPx7eyJr6XWna2o8/sVn01crBF+gZ
         p9pO4VBHOVeOFdizbhP9mDpLFs7RApacoA9G7aIC1/82Onf+h0Kkka82V+3RC8zuC/B3
         YI+EHXyrap3CiCSwWLFrgK2pSDPQwpv4MS2CpJk65xR9jQczhcIO/QNr3LkaHYo1JQoC
         wbzg==
X-Gm-Message-State: AOAM530QgpmCLOhmaT3URKoWhzms5nm+jSDed54Lx+HIDk8OK0nG5n9P
        lTx6JN4vmkmCq1sNa3Jg+38qFeDniOS1HK1A5J8=
X-Google-Smtp-Source: ABdhPJyX1THzVh8dP+Sq0xdIsHDOPpLtkYHc2uWkqQhAhFkw9T6TXW9rHkruXVXP7WfvDilXxSllhQEJA2D9k0W58E0=
Sender: "samitolvanen via sendgmr" 
        <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:c946:: with SMTP id
 z67mr1553023ybf.56.1605646750100; Tue, 17 Nov 2020 12:59:10 -0800 (PST)
Date:   Tue, 17 Nov 2020 12:59:02 -0800
Message-Id: <20201117205902.405316-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH net] cfg80211: fix callback type mismatches in wext-compat
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of casting callback functions to type iw_handler, which trips
indirect call checking with Clang's Control-Flow Integrity (CFI), add
stub functions with the correct function type for the callbacks.

Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 net/wireless/wext-compat.c | 103 +++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 32 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 78f2927ead7f..cf54c6e5b397 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1472,39 +1472,78 @@ static int cfg80211_wext_siwpmksa(struct net_device *dev,
 	}
 }
 
+#define DEFINE_WEXT_COMPAT_STUB(func, type)			\
+	static int __ ## func(struct net_device *dev,		\
+			      struct iw_request_info *info,	\
+			      union iwreq_data *wrqu,		\
+			      char *extra)			\
+	{							\
+		return func(dev, info, (type *)wrqu, extra);	\
+	}
+
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwname, char)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfreq, struct iw_freq)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfreq, struct iw_freq)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmode, u32)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwmode, u32)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrange, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwap, struct sockaddr)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwap, struct sockaddr)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwmlme, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwscan, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwessid, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwessid, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrate, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrate, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwrts, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwrts, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwfrag, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwfrag, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwretry, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwretry, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencode, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwencode, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwpower, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpower, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwgenie, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_giwauth, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwauth, struct iw_param)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwencodeext, struct iw_point)
+DEFINE_WEXT_COMPAT_STUB(cfg80211_wext_siwpmksa, struct iw_point)
+
 static const iw_handler cfg80211_handlers[] = {
-	[IW_IOCTL_IDX(SIOCGIWNAME)]	= (iw_handler) cfg80211_wext_giwname,
-	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= (iw_handler) cfg80211_wext_siwfreq,
-	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= (iw_handler) cfg80211_wext_giwfreq,
-	[IW_IOCTL_IDX(SIOCSIWMODE)]	= (iw_handler) cfg80211_wext_siwmode,
-	[IW_IOCTL_IDX(SIOCGIWMODE)]	= (iw_handler) cfg80211_wext_giwmode,
-	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= (iw_handler) cfg80211_wext_giwrange,
-	[IW_IOCTL_IDX(SIOCSIWAP)]	= (iw_handler) cfg80211_wext_siwap,
-	[IW_IOCTL_IDX(SIOCGIWAP)]	= (iw_handler) cfg80211_wext_giwap,
-	[IW_IOCTL_IDX(SIOCSIWMLME)]	= (iw_handler) cfg80211_wext_siwmlme,
-	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= (iw_handler) cfg80211_wext_siwscan,
-	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= (iw_handler) cfg80211_wext_giwscan,
-	[IW_IOCTL_IDX(SIOCSIWESSID)]	= (iw_handler) cfg80211_wext_siwessid,
-	[IW_IOCTL_IDX(SIOCGIWESSID)]	= (iw_handler) cfg80211_wext_giwessid,
-	[IW_IOCTL_IDX(SIOCSIWRATE)]	= (iw_handler) cfg80211_wext_siwrate,
-	[IW_IOCTL_IDX(SIOCGIWRATE)]	= (iw_handler) cfg80211_wext_giwrate,
-	[IW_IOCTL_IDX(SIOCSIWRTS)]	= (iw_handler) cfg80211_wext_siwrts,
-	[IW_IOCTL_IDX(SIOCGIWRTS)]	= (iw_handler) cfg80211_wext_giwrts,
-	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= (iw_handler) cfg80211_wext_siwfrag,
-	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= (iw_handler) cfg80211_wext_giwfrag,
-	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= (iw_handler) cfg80211_wext_siwtxpower,
-	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= (iw_handler) cfg80211_wext_giwtxpower,
-	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= (iw_handler) cfg80211_wext_siwretry,
-	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= (iw_handler) cfg80211_wext_giwretry,
-	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= (iw_handler) cfg80211_wext_siwencode,
-	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= (iw_handler) cfg80211_wext_giwencode,
-	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= (iw_handler) cfg80211_wext_siwpower,
-	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= (iw_handler) cfg80211_wext_giwpower,
-	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= (iw_handler) cfg80211_wext_siwgenie,
-	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= (iw_handler) cfg80211_wext_siwauth,
-	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= (iw_handler) cfg80211_wext_giwauth,
-	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= (iw_handler) cfg80211_wext_siwencodeext,
-	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= (iw_handler) cfg80211_wext_siwpmksa,
+	[IW_IOCTL_IDX(SIOCGIWNAME)]	= __cfg80211_wext_giwname,
+	[IW_IOCTL_IDX(SIOCSIWFREQ)]	= __cfg80211_wext_siwfreq,
+	[IW_IOCTL_IDX(SIOCGIWFREQ)]	= __cfg80211_wext_giwfreq,
+	[IW_IOCTL_IDX(SIOCSIWMODE)]	= __cfg80211_wext_siwmode,
+	[IW_IOCTL_IDX(SIOCGIWMODE)]	= __cfg80211_wext_giwmode,
+	[IW_IOCTL_IDX(SIOCGIWRANGE)]	= __cfg80211_wext_giwrange,
+	[IW_IOCTL_IDX(SIOCSIWAP)]	= __cfg80211_wext_siwap,
+	[IW_IOCTL_IDX(SIOCGIWAP)]	= __cfg80211_wext_giwap,
+	[IW_IOCTL_IDX(SIOCSIWMLME)]	= __cfg80211_wext_siwmlme,
+	[IW_IOCTL_IDX(SIOCSIWSCAN)]	= cfg80211_wext_siwscan,
+	[IW_IOCTL_IDX(SIOCGIWSCAN)]	= __cfg80211_wext_giwscan,
+	[IW_IOCTL_IDX(SIOCSIWESSID)]	= __cfg80211_wext_siwessid,
+	[IW_IOCTL_IDX(SIOCGIWESSID)]	= __cfg80211_wext_giwessid,
+	[IW_IOCTL_IDX(SIOCSIWRATE)]	= __cfg80211_wext_siwrate,
+	[IW_IOCTL_IDX(SIOCGIWRATE)]	= __cfg80211_wext_giwrate,
+	[IW_IOCTL_IDX(SIOCSIWRTS)]	= __cfg80211_wext_siwrts,
+	[IW_IOCTL_IDX(SIOCGIWRTS)]	= __cfg80211_wext_giwrts,
+	[IW_IOCTL_IDX(SIOCSIWFRAG)]	= __cfg80211_wext_siwfrag,
+	[IW_IOCTL_IDX(SIOCGIWFRAG)]	= __cfg80211_wext_giwfrag,
+	[IW_IOCTL_IDX(SIOCSIWTXPOW)]	= cfg80211_wext_siwtxpower,
+	[IW_IOCTL_IDX(SIOCGIWTXPOW)]	= cfg80211_wext_giwtxpower,
+	[IW_IOCTL_IDX(SIOCSIWRETRY)]	= __cfg80211_wext_siwretry,
+	[IW_IOCTL_IDX(SIOCGIWRETRY)]	= __cfg80211_wext_giwretry,
+	[IW_IOCTL_IDX(SIOCSIWENCODE)]	= __cfg80211_wext_siwencode,
+	[IW_IOCTL_IDX(SIOCGIWENCODE)]	= __cfg80211_wext_giwencode,
+	[IW_IOCTL_IDX(SIOCSIWPOWER)]	= __cfg80211_wext_siwpower,
+	[IW_IOCTL_IDX(SIOCGIWPOWER)]	= __cfg80211_wext_giwpower,
+	[IW_IOCTL_IDX(SIOCSIWGENIE)]	= __cfg80211_wext_siwgenie,
+	[IW_IOCTL_IDX(SIOCSIWAUTH)]	= __cfg80211_wext_siwauth,
+	[IW_IOCTL_IDX(SIOCGIWAUTH)]	= __cfg80211_wext_giwauth,
+	[IW_IOCTL_IDX(SIOCSIWENCODEEXT)]= __cfg80211_wext_siwencodeext,
+	[IW_IOCTL_IDX(SIOCSIWPMKSA)]	= __cfg80211_wext_siwpmksa,
 };
 
 const struct iw_handler_def cfg80211_wext_handler = {

base-commit: 9c87c9f41245baa3fc4716cf39141439cf405b01
-- 
2.29.2.299.gdc1121823c-goog

