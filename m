Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D27C718BCC3
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:39:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgCSQjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:39:40 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43081 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgCSQjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:39:39 -0400
Received: by mail-pl1-f195.google.com with SMTP id f8so1277915plt.10;
        Thu, 19 Mar 2020 09:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Np+AyNy3MHuEquUWcNaMg8zVu+PbOoCsQdmQOg407VU=;
        b=ewV8jx3mofFWOuAAxjea08Ett/qZ1rJxPw1E9yr8bQ0Z3sW6T6kxPOXt/NXhy8fqdS
         AkcyK4gC87gpk82X86bf+MrrYDKEydwln1jQNiklt5PK5dJylQ8bUaLcwR1niRoOp4EO
         31kmS91D/bvflOKkJGqK2JKJ86zftrWhiOj9TJDBcbmPAcNok7I/W+8NvwJHqC+8dUPT
         6ZcOHPvFRW66A+zHheUN1mQHF2iDzBKJdyrE2OKlS/Nbvg7YFk80i6F20XePStp1VZWt
         IX130SXipK9eItDCrLrfg1pvd0A0ze9l6y4E9L+JWw+IoRDNIwWn1GWyP6yBJLkMgGDQ
         gafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Np+AyNy3MHuEquUWcNaMg8zVu+PbOoCsQdmQOg407VU=;
        b=LIViQ9c+Ye8x7lO+venj4Zz73lTnAkTOK+2pdmtApOgCSmacfGDAAYe9BsPWwhQqn+
         VmoefFKpf7/vzRJYtXiIOG25tUI4G3EEzYRvhAFY4368Y5K0tpyG237kvEjxMH1+MQWI
         R/oNXwod9RXZVrucbyQtKPNmO+P0nIpc9PDCqrCAW9qgSXBnb6DpylXwoKVTFY2rgDsu
         5SYwEcrwWgp9wfA0yS5iDjxDntonRzWmF27cgDc9gO0hI6FtNPX4ggClrA+ZtOgwEeUH
         APUnWlg7KzjzDoI9RhTFD828QFBtsLMF2UixZGoYZu8qk/qR8NIZEmI9hKQVG0PJdIMZ
         9axQ==
X-Gm-Message-State: ANhLgQ0S4jiHxJyQQo2i+buAOWNzDGgtcyTQEeoIbXayhA02kvfgX8k+
        Mo3Bq/aVA4nSwDeplJ7snFM=
X-Google-Smtp-Source: ADFU+vuw8R/GyHqJV2hgFkznw5MRYwzrzK+m5Q2tWMvk1JlZh0HdoDldVx5LNyrFwxhQmHkzgIKnnw==
X-Received: by 2002:a17:902:8ec3:: with SMTP id x3mr4215144plo.137.1584635978572;
        Thu, 19 Mar 2020 09:39:38 -0700 (PDT)
Received: from localhost ([216.24.188.11])
        by smtp.gmail.com with ESMTPSA id x15sm2979232pfq.107.2020.03.19.09.39.37
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 19 Mar 2020 09:39:38 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, tglx@linutronix.de,
        broonie@kernel.org, corbet@lwn.net, mchehab+samsung@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next 1/7] iopoll: introduce read_poll_timeout macro
Date:   Fri, 20 Mar 2020 00:39:04 +0800
Message-Id: <20200319163910.14733-2-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200319163910.14733-1-zhengdejin5@gmail.com>
References: <20200319163910.14733-1-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this macro is an extension of readx_poll_timeout macro. the accessor
function op just supports only one parameter in the readx_poll_timeout
macro, but this macro can supports multiple variable parameters for
it. so functions like phy_read(struct phy_device *phydev, u32 regnum)
and phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum) can
also use this poll timeout framework.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 include/linux/iopoll.h | 40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/include/linux/iopoll.h b/include/linux/iopoll.h
index 35e15dfd4155..7d44a2e20267 100644
--- a/include/linux/iopoll.h
+++ b/include/linux/iopoll.h
@@ -13,6 +13,46 @@
 #include <linux/errno.h>
 #include <linux/io.h>
 
+/**
+ * read_poll_timeout - Periodically poll an address until a condition is
+ *			met or a timeout occurs
+ * @op: accessor function (takes @args as its arguments)
+ * @val: Variable to read the value into
+ * @cond: Break condition (usually involving @val)
+ * @sleep_us: Maximum time to sleep between reads in us (0
+ *            tight-loops).  Should be less than ~20ms since usleep_range
+ *            is used (see Documentation/timers/timers-howto.rst).
+ * @timeout_us: Timeout in us, 0 means never timeout
+ * @args: arguments for @op poll
+ *
+ * Returns 0 on success and -ETIMEDOUT upon a timeout. In either
+ * case, the last read value at @args is stored in @val. Must not
+ * be called from atomic context if sleep_us or timeout_us are used.
+ *
+ * When available, you'll probably want to use one of the specialized
+ * macros defined below rather than this macro directly.
+ */
+#define read_poll_timeout(op, val, cond, sleep_us, timeout_us, args...)	\
+({ \
+	u64 __timeout_us = (timeout_us); \
+	unsigned long __sleep_us = (sleep_us); \
+	ktime_t __timeout = ktime_add_us(ktime_get(), __timeout_us); \
+	might_sleep_if((__sleep_us) != 0); \
+	for (;;) { \
+		(val) = op(args); \
+		if (cond) \
+			break; \
+		if (__timeout_us && \
+		    ktime_compare(ktime_get(), __timeout) > 0) { \
+			(val) = op(args); \
+			break; \
+		} \
+		if (__sleep_us) \
+			usleep_range((__sleep_us >> 2) + 1, __sleep_us); \
+	} \
+	(cond) ? 0 : -ETIMEDOUT; \
+})
+
 /**
  * readx_poll_timeout - Periodically poll an address until a condition is met or a timeout occurs
  * @op: accessor function (takes @addr as its only argument)
-- 
2.25.0

