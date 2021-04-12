Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF1B535B97E
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 06:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhDLEZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 00:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhDLEZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Apr 2021 00:25:53 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF09EC061574
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:35 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id g15so12090406qkl.4
        for <netdev@vger.kernel.org>; Sun, 11 Apr 2021 21:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hzXpdZCh29GdRHKf5U+TmRbPCLLw51BgI9PuNfDGsBw=;
        b=Tloo9PF7nLys8wp+TgMK+YbMG9zEBPvlW5xBkcifhy9iGrOUju5JIyAgouM+xasCrt
         XNQnyOJNSRl+715bNS6H2Zq9AazC2005qdu8WwdVM8r4ClduB41JiwMAfxhmPQP/eVN8
         bK+bzeOLXQNPZnEDxZWRin3D0YL1Ua1h9iMQ+3AcpK1OtketAhYYAy2ko0aleCaieYjM
         3s0A+Xy6DfxYmHU6qeKuCyuhUR64i5el9J6NG3U8foU8z3r5bbCgrVi6VOuXLRwrg+h6
         tUyYtwsz9qUAaXC/zgZ3WXh1vecrGR/zZedmKisrLwpDgX1WGEiw8tec8WKHykMUIPg0
         p7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzXpdZCh29GdRHKf5U+TmRbPCLLw51BgI9PuNfDGsBw=;
        b=sMCZiQF6vXsxNP9jzkpJbTHAl2imHf5/fWUGkc6fjiC5mwHFh8Iy1uSgeSSW3JGdle
         4JisRrYF3Wp6EnGnpU/B7oWhVAZy2u/9RvSLf3XBP8wy6w7WLt+KSh+6ELm5urcNsn2q
         GQFXRdrXvD9ZhX6Vw8aIMTl/oU1xDVze2q35hVjJKLLfmyvhsziuh75Nr+wUIdJJIJ6E
         RAw4N/be2ndH4xff8ou62CNLGWMl7yLmd2tHOU+qGozi3J7E89NpmkrlgbmMYzJQboI5
         lynNHg1T02EIwq8JHocFtSrNj4+wReJeMwd5cpPkg5xulCuytu0IV6QLLhU8mudFlu8i
         hEOA==
X-Gm-Message-State: AOAM531AH3PYDkci4kQfqLTST+sn9w3crANRkuMUjktLNmCM338vQA74
        L0SzZr6Q7uhJ1WNpo22R/GjTXMh+nGU7Zg==
X-Google-Smtp-Source: ABdhPJwfxbrLnqVyEoLmtMVIOJ/bmmDmTE9Dq3woUtQ1Emff/hI5+E1od3w5vMsdlkvOPAbpuXmS4w==
X-Received: by 2002:a37:ae04:: with SMTP id x4mr25322217qke.245.1618201533765;
        Sun, 11 Apr 2021 21:25:33 -0700 (PDT)
Received: from jrr-vaio.onthefive.com (2603-6010-7221-eda3-0000-0000-0000-1d7d.res6.spectrum.com. [2603:6010:7221:eda3::1d7d])
        by smtp.gmail.com with ESMTPSA id a187sm7090996qkd.69.2021.04.11.21.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Apr 2021 21:25:33 -0700 (PDT)
From:   Jonathon Reinhart <jonathon.reinhart@gmail.com>
X-Google-Original-From: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jonathon Reinhart <Jonathon.Reinhart@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH net-next 1/2] net: Ensure net namespace isolation of sysctls
Date:   Mon, 12 Apr 2021 00:24:52 -0400
Message-Id: <20210412042453.32168-2-Jonathon.Reinhart@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
References: <20210412042453.32168-1-Jonathon.Reinhart@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds an ensure_safe_net_sysctl() check during register_net_sysctl()
to validate that sysctl table entries for a non-init_net netns are
sufficiently isolated. To be netns-safe, an entry must adhere to at
least (and usually exactly) one of these rules:

1. It is marked read-only inside the netns.
2. Its data pointer does not point to kernel/module global data.

An entry which fails both of these checks is indicative of a bug,
whereby a child netns can affect global net sysctl values.

If such an entry is found, this code will issue a warning to the kernel
log, and force the entry to be read-only to prevent a leak.

To test, simply create a new netns:

    $ sudo ip netns add dummy

As it sits now, this patch will WARN for two sysctls which will be
addressed in a subsequent patch:
- /proc/sys/net/netfilter/nf_conntrack_max
- /proc/sys/net/netfilter/nf_conntrack_expect_max

Signed-off-by: Jonathon Reinhart <Jonathon.Reinhart@gmail.com>
---
 net/sysctl_net.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/net/sysctl_net.c b/net/sysctl_net.c
index d14dab8b6774..f6cb0d4d114c 100644
--- a/net/sysctl_net.c
+++ b/net/sysctl_net.c
@@ -115,9 +115,57 @@ __init int net_sysctl_init(void)
 	goto out;
 }
 
+/* Verify that sysctls for non-init netns are safe by either:
+ * 1) being read-only, or
+ * 2) having a data pointer which points outside of the global kernel/module
+ *    data segment, and rather into the heap where a per-net object was
+ *    allocated.
+ */
+static void ensure_safe_net_sysctl(struct net *net, const char *path,
+				   struct ctl_table *table)
+{
+	struct ctl_table *ent;
+
+	pr_debug("Registering net sysctl (net %p): %s\n", net, path);
+	for (ent = table; ent->procname; ent++) {
+		unsigned long addr;
+		const char *where;
+
+		pr_debug("  procname=%s mode=%o proc_handler=%ps data=%p\n",
+			 ent->procname, ent->mode, ent->proc_handler, ent->data);
+
+		/* If it's not writable inside the netns, then it can't hurt. */
+		if ((ent->mode & 0222) == 0) {
+			pr_debug("    Not writable by anyone\n");
+			continue;
+		}
+
+		/* Where does data point? */
+		addr = (unsigned long)ent->data;
+		if (is_module_address(addr))
+			where = "module";
+		else if (core_kernel_data(addr))
+			where = "kernel";
+		else
+			continue;
+
+		/* If it is writable and points to kernel/module global
+		 * data, then it's probably a netns leak.
+		 */
+		WARN(1, "sysctl %s/%s: data points to %s global data: %ps\n",
+		     path, ent->procname, where, ent->data);
+
+		/* Make it "safe" by dropping writable perms */
+		ent->mode &= ~0222;
+	}
+}
+
 struct ctl_table_header *register_net_sysctl(struct net *net,
 	const char *path, struct ctl_table *table)
 {
+	if (!net_eq(net, &init_net))
+		ensure_safe_net_sysctl(net, path, table);
+
 	return __register_sysctl_table(&net->sysctls, path, table);
 }
 EXPORT_SYMBOL_GPL(register_net_sysctl);
-- 
2.20.1

