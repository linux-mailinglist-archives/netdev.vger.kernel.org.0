Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1051D30182D
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 21:06:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbhAWUFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 15:05:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726294AbhAWUAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 15:00:15 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5BEC06178B
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:34 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id u11so10500413ljo.13
        for <netdev@vger.kernel.org>; Sat, 23 Jan 2021 11:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=MsAz3qcmzDW5QGnZnBh2j+/7H+aTnytZK9igo/MrSsweIhhTX659XM4nS5ZT56FzsP
         DZd557Uph6TIHJ0YsXz73rr7n9T0Wtmj8HIeH78wlf/qh9lNJo4YBpEiwV/Y88+YJpeh
         jrE+uwWFYiB/nuMAPAx+0nzQKApurJ3wm9dQeJBiyppqyHbiwp1b61jJNxlzxwAcPHOk
         1DsvPdC55ZW/UXJ2sm/4YW/arnES5jMZjwk+6nID9GGLr2bND612jzDSht7JvSlDF/qG
         z3YADRXOTZQCH6z21+JrJDAOQBDSRZwp46EqT5fIrDG9bS8dY1yP2lUik9RZ2yTvfx5E
         lM5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BGpaEg0j3hIwyT8YaseDu5lYmdNhnyii6Jj6H/mUeXo=;
        b=r0GDPb1bBMQ7lcKCgPN3AirSlG5Jpz4Q07Hp8ZNspegd38+EUusJbPa4XdaRe335TB
         kThMfUX6hIvPql2WUyJkNuifn+KsaFiYh7CoiOucQayNNzuzgvsp29/ZQsbk39Lg/ObF
         dAgY16s1iyIykMWhmRW0SOcF2pWMX7nqz4MJHOJBkwVNpXvF5rM9QEeUuqGHyAXxXaB4
         6uTnmAkLqLf+GjobMXctDYZ82OMI8/EZPcQItwnhzOALus+YXvAYDAKcgNNYe4nRg4S6
         1u6Y9rvJtqCjTis+yNn/u2h9Q3TE4M7ASPtLTUcYGokntni8caOy6rNM3xSbo5hhFKF3
         bxFg==
X-Gm-Message-State: AOAM5317tM6hVW2X7sKhwmo8M98+hhg+hENmLIS4zmUj/eOJgPREJrda
        n0rMjkjzu9jd/RW+XSFvDat2eQ==
X-Google-Smtp-Source: ABdhPJz+yFQTdB91wMvNsvbGAU9JyTEggUgk9KTkWc1Aom+ShgLF0REV1Qwze3CgyzfS0vlYUUmOlQ==
X-Received: by 2002:a2e:9a4f:: with SMTP id k15mr1636047ljj.157.1611431973053;
        Sat, 23 Jan 2021 11:59:33 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id f9sm1265177lft.114.2021.01.23.11.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Jan 2021 11:59:32 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     laforge@gnumonks.org, netdev@vger.kernel.org, pbshelar@fb.com,
        kuba@kernel.org
Cc:     pablo@netfilter.org, Jonas Bonn <jonas@norrbonn.se>
Subject: [RFC PATCH 03/16] gtp: include role in link info
Date:   Sat, 23 Jan 2021 20:59:03 +0100
Message-Id: <20210123195916.2765481-4-jonas@norrbonn.se>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210123195916.2765481-1-jonas@norrbonn.se>
References: <20210123195916.2765481-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Querying link info for the GTP interface doesn't reveal in which "role" the
device is set to operate.  Include this information in the info query
result.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Harald Welte <laforge@gnumonks.org>
---
 drivers/net/gtp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 5a048f050a9c..5682d3ba7aa5 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -728,7 +728,8 @@ static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
 
 static size_t gtp_get_size(const struct net_device *dev)
 {
-	return nla_total_size(sizeof(__u32));	/* IFLA_GTP_PDP_HASHSIZE */
+	return nla_total_size(sizeof(__u32)) + /* IFLA_GTP_PDP_HASHSIZE */
+		nla_total_size(sizeof(__u32)); /* IFLA_GTP_ROLE */
 }
 
 static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
@@ -737,6 +738,8 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
 
 	if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
 		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_GTP_ROLE, gtp->role))
+		goto nla_put_failure;
 
 	return 0;
 
-- 
2.27.0

