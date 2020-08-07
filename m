Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAE823F44A
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 23:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727872AbgHGV37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 17:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgHGV3m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 17:29:42 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACFC8C061A29
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 14:29:42 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id e14so2620461qtm.5
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 14:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=wF2sKYSCPfS1oM0NH0xBupgB1N/FqdnAiRnprzF9CglUuoj8PFS0W/tP4/W0GJPNuX
         TyrQaJi9YYWikcZeI0piuRjIgi7S5jtC+iCUMgx8SN14rfqmKY7koAozdgACk/O4WfVJ
         yv7+JzWcCmipUuyAMJMfzjLlkCoyIjH1rZVL2QfDcg/SnWLNI8ygMAJbmEQc4uzHhanr
         cOazUENtE+ArWoT9JNvMKb2ZhVEp8J8eXYoSQYPithEBghTam0jogYR9DsEv5IJ8i0zG
         nhl2W24qoGsirdUwqm7iXnLP0F2QVNElE3cyh5qkdYDPSSJRi85rrFJtgQ3oy1s4p4h+
         sSCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=O7nU7lYRfe2R9ziGF333WHlsyARaR/Q4/HWduypodHg=;
        b=LbsqjSlgdRuJHZ+GdrZrVuLulxSWneJBaWeXE38WgrueYlG06VtCGdENvtKQvb/pw7
         md94sIk+/E0TGwHbKCnB1+ArMLaVxovKR/7AavpFDu9I5kxGLjfVAJgeQtX7+qTssIKy
         b1MVISXq//FAfBZZ+uRb1QeQTfil4PdDJRHo03+qY/9iCeP9ROEAv3g56GDZEwZUQMGt
         YWxX+reJNxq5qzzkpsD+rWnJY9BsDoslX4rUsCbYEg2rbdmh2T35igEaEYnux24gTI9f
         tpvLARkgxDxazNH5JnQe2/ADMW4GH6FNGmmhIlF2iZSVlErt4tcyPByhE2m9dVhZKYzz
         U59A==
X-Gm-Message-State: AOAM533M0Qtz3qaRWGFm4rsNXSDWluZNxrBxn2vMIsTT+y5ODxeoJFIC
        qIqf+4mmJGOKahJUq5TtvNObt/Rfmjw=
X-Google-Smtp-Source: ABdhPJwX9D4en+hACeaFijzp6xuG9EX9sqMK2d3+XO8tWnEdN3dt94ChhAurZV3Fxr5jxFzwH9+/rqq5AG1s
X-Received: by 2002:a05:6214:11a8:: with SMTP id u8mr15191510qvv.88.1596835781537;
 Fri, 07 Aug 2020 14:29:41 -0700 (PDT)
Date:   Fri,  7 Aug 2020 14:29:13 -0700
In-Reply-To: <20200807212916.2883031-1-jwadams@google.com>
Message-Id: <20200807212916.2883031-5-jwadams@google.com>
Mime-Version: 1.0
References: <20200807212916.2883031-1-jwadams@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [RFC PATCH 4/7] core/metricfs: expose softirq information through metricfs
From:   Jonathan Adams <jwadams@google.com>
To:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     netdev@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add metricfs support for displaying percpu softirq counters.  The
top directory is /sys/kernel/debug/metricfs/softirq.  Then there
is a subdirectory for each softirq type.  For example:

    cat /sys/kernel/debug/metricfs/softirq/NET_RX/values

Signed-off-by: Jonathan Adams <jwadams@google.com>

---

jwadams@google.com: rebased to 5.8-pre6
	This is work originally done by another engineer at
	google, who would rather not have their name associated with this
	patchset. They're okay with me sending it under my name.
---
 kernel/softirq.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/kernel/softirq.c b/kernel/softirq.c
index c4201b7f42b1..1ae3a540b789 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -25,6 +25,8 @@
 #include <linux/smpboot.h>
 #include <linux/tick.h>
 #include <linux/irq.h>
+#include <linux/jump_label.h>
+#include <linux/metricfs.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
@@ -738,3 +740,46 @@ unsigned int __weak arch_dynirq_lower_bound(unsigned int from)
 {
 	return from;
 }
+
+#ifdef CONFIG_METRICFS
+
+#define METRICFS_ITEM(name) \
+static void \
+metricfs_##name(struct metric_emitter *e, int cpu) \
+{ \
+	int64_t v = kstat_softirqs_cpu(name##_SOFTIRQ, cpu); \
+	METRIC_EMIT_PERCPU_INT(e, cpu, v); \
+} \
+METRIC_EXPORT_PERCPU_COUNTER(name, #name " softirq", metricfs_##name)
+
+METRICFS_ITEM(HI);
+METRICFS_ITEM(TIMER);
+METRICFS_ITEM(NET_TX);
+METRICFS_ITEM(NET_RX);
+METRICFS_ITEM(BLOCK);
+METRICFS_ITEM(IRQ_POLL);
+METRICFS_ITEM(TASKLET);
+METRICFS_ITEM(SCHED);
+METRICFS_ITEM(HRTIMER);
+METRICFS_ITEM(RCU);
+
+static int __init init_softirq_metricfs(void)
+{
+	struct metricfs_subsys *subsys;
+
+	subsys = metricfs_create_subsys("softirq", NULL);
+	metric_init_HI(subsys);
+	metric_init_TIMER(subsys);
+	metric_init_NET_TX(subsys);
+	metric_init_NET_RX(subsys);
+	metric_init_BLOCK(subsys);
+	metric_init_IRQ_POLL(subsys);
+	metric_init_TASKLET(subsys);
+	metric_init_SCHED(subsys);
+	metric_init_RCU(subsys);
+
+	return 0;
+}
+module_init(init_softirq_metricfs);
+
+#endif
-- 
2.28.0.236.gb10cc79966-goog

