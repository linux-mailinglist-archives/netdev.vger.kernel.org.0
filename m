Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E21F34992D
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 19:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhCYSIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 14:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhCYSIa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 14:08:30 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FC1C06174A
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:30 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l123so2867170pfl.8
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 11:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mKM7oVa6y4nRhPmxzoHcqCS8UgaRTsod5Gj4cIVnOUQ=;
        b=Ik5DyOQ0268vxwbOq0Xv8E063JV8OgGI298Wr5PCP4bFrNVDB0mB0qSsquH9aHqOzn
         JWM01LW5f2QvpZxckwge7YWHlq7J6S9ki1KuL5sDloilPskq51KV4/fhcLpmSLk2onDZ
         U7CyYKBph2aX8MNxbByWuYqHAchrP+JOjCo/YBqk1BQTaNKd+YxbYUhoreYJpHljCP/W
         9/sCrh+X7KBjxtFeRXZx8A0G6RzE7H7OTjGCfkOiRmbo85rZzV3v7qzbn6by5VWUj079
         Yu4iiUmLTBbSsYoA1Z1An0CoiOpaCv16G+AY8+5E9I8dvd9TMrie6SHb3GVk7UZyGK/d
         i1yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mKM7oVa6y4nRhPmxzoHcqCS8UgaRTsod5Gj4cIVnOUQ=;
        b=U4GQ+cR4g5Nr24mfH/ZnhR4L+lRymX4waoTd2Ns9UTlOJmEWex/Fc17HqtWJbEVgSW
         IctASM5PKgjeHxPewIBFdMdvsE79ihrJoEO1BrI+VCX025x/iC0NFgkSIbwrzMscmowM
         NMVAkPg4rQ+PIXEWUuoZl2iEOfA/Sxni7ayvUOTqvYKVo8stjrqufsZW7ClhJRQKonEw
         cynCxGO/pgDEiA73nDkh3PRzgCbfCjV+xxkN37l+ObtrndjO8US+QXkxQdz7Cq3rCq3X
         nmm1QIScZzMAZzil399PVrSCvZoodjkSoyzyVkjPJHZicz8DbEMIdrSFOeBoev5zntQw
         tRuA==
X-Gm-Message-State: AOAM5324DSRnODvkeGlbilLlRSP1bp6/5ksOvFNTpN8pYyEjo9uTWPlI
        s5AtaXPg8QbsdNH54715myc=
X-Google-Smtp-Source: ABdhPJyV+7uWw9+TVLJy/QfjjfsMbXnQPoKU4kqNbz1aGGM6n40WwXBtc4DF4mAukwjPlR6O+Wbi5A==
X-Received: by 2002:a63:b12:: with SMTP id 18mr8673782pgl.45.1616695710056;
        Thu, 25 Mar 2021 11:08:30 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:2c0c:35d8:b060:81b3])
        by smtp.gmail.com with ESMTPSA id j20sm5968359pjn.27.2021.03.25.11.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:08:29 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 1/5] sysctl: add proc_dou8vec_minmax()
Date:   Thu, 25 Mar 2021 11:08:13 -0700
Message-Id: <20210325180817.840042-2-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
In-Reply-To: <20210325180817.840042-1-eric.dumazet@gmail.com>
References: <20210325180817.840042-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Networking has many sysctls that could fit in one u8.

This patch adds proc_dou8vec_minmax() for this purpose.

Note that the .extra1 and .extra2 fields are pointing
to integers, because it makes conversions easier.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 fs/proc/proc_sysctl.c  |  6 ++++
 include/linux/sysctl.h |  2 ++
 kernel/sysctl.c        | 65 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 984e42f8cb112ab026560835517630fe843462c2..7256b8962e3cb42a1f40050b61d44b47d959b70a 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -1108,6 +1108,11 @@ static int sysctl_check_table_array(const char *path, struct ctl_table *table)
 			err |= sysctl_err(path, table, "array not allowed");
 	}
 
+	if (table->proc_handler == proc_dou8vec_minmax) {
+		if (table->maxlen != sizeof(u8))
+			err |= sysctl_err(path, table, "array not allowed");
+	}
+
 	return err;
 }
 
@@ -1123,6 +1128,7 @@ static int sysctl_check_table(const char *path, struct ctl_table *table)
 		    (table->proc_handler == proc_douintvec) ||
 		    (table->proc_handler == proc_douintvec_minmax) ||
 		    (table->proc_handler == proc_dointvec_minmax) ||
+		    (table->proc_handler == proc_dou8vec_minmax) ||
 		    (table->proc_handler == proc_dointvec_jiffies) ||
 		    (table->proc_handler == proc_dointvec_userhz_jiffies) ||
 		    (table->proc_handler == proc_dointvec_ms_jiffies) ||
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 51298a4f4623573a6628718193331fb4f31d5469..d99ca99837debe2ab1f1141faf4e2566ae9b0ddb 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -53,6 +53,8 @@ int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
+int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
+			size_t *lenp, loff_t *ppos);
 int proc_dointvec_jiffies(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_userhz_jiffies(struct ctl_table *, int, void *, size_t *,
 		loff_t *);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62fbd09b5dc1c03eca02f0f99af6b9e0d1df44ac..90d2892ef6a3fcf9ad0043b660128fa45de26778 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1034,6 +1034,65 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 				 do_proc_douintvec_minmax_conv, &param);
 }
 
+/**
+ * proc_dou8vec_minmax - read a vector of unsigned chars with min/max values
+ * @table: the sysctl table
+ * @write: %TRUE if this is a write to the sysctl file
+ * @buffer: the user buffer
+ * @lenp: the size of the user buffer
+ * @ppos: file position
+ *
+ * Reads/writes up to table->maxlen/sizeof(u8) unsigned chars
+ * values from/to the user buffer, treated as an ASCII string. Negative
+ * strings are not allowed.
+ *
+ * This routine will ensure the values are within the range specified by
+ * table->extra1 (min) and table->extra2 (max).
+ *
+ * Returns 0 on success or an error on write when the range check fails.
+ */
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp;
+	unsigned int min = 0, max = 255U, val;
+	u8 *data = table->data;
+	struct do_proc_douintvec_minmax_conv_param param = {
+		.min = &min,
+		.max = &max,
+	};
+	int res;
+
+	/* Do not support arrays yet. */
+	if (table->maxlen != sizeof(u8))
+		return -EINVAL;
+
+	if (table->extra1) {
+		min = *(unsigned int *) table->extra1;
+		if (min > 255U)
+			return -EINVAL;
+	}
+	if (table->extra2) {
+		max = *(unsigned int *) table->extra2;
+		if (max > 255U)
+			return -EINVAL;
+	}
+
+	tmp = *table;
+
+	tmp.maxlen = sizeof(val);
+	tmp.data = &val;
+	val = *data;
+	res = do_proc_douintvec(&tmp, write, buffer, lenp, ppos,
+				do_proc_douintvec_minmax_conv, &param);
+	if (res)
+		return res;
+	if (write)
+		*data = val;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(proc_dou8vec_minmax);
+
 static int do_proc_dopipe_max_size_conv(unsigned long *lvalp,
 					unsigned int *valp,
 					int write, void *data)
@@ -1582,6 +1641,12 @@ int proc_douintvec_minmax(struct ctl_table *table, int write,
 	return -ENOSYS;
 }
 
+int proc_dou8vec_minmax(struct ctl_table *table, int write,
+			void *buffer, size_t *lenp, loff_t *ppos)
+{
+	return -ENOSYS;
+}
+
 int proc_dointvec_jiffies(struct ctl_table *table, int write,
 		    void *buffer, size_t *lenp, loff_t *ppos)
 {
-- 
2.31.0.291.g576ba9dcdaf-goog

