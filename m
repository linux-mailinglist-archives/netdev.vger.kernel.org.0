Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F79DC7DE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 16:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2634265AbfJROyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 10:54:41 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33400 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2634249AbfJROyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 10:54:41 -0400
Received: by mail-io1-f67.google.com with SMTP id z19so7829174ior.0;
        Fri, 18 Oct 2019 07:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=gEBvQG945nw6PeIGCHJGYkG1Klh1FidBj3ztTvMKYBs=;
        b=N6EOAFQ2a7O9MKI+Z8IxNJe/A8YLej0PCXCjXgwqpe4/jio5eqp+PtYvmicAHBvFSM
         aiNAyuRTe78VLn5mHkf6mopFvDOBkWwl7yChNA+e3ViwqspRXcmQk1VwedaMSmvB0/9H
         S9DK1AS93cwQFcCkEwZ3GtOUqN5EBy+rEZkC67lYr5eV33QE93zOK/Y+1Zeu+O93ADOE
         jVK6xuYLDh2c19aAB70Eyo3RR7QcX9DklIUV6yOkjPzQSSTzIKY5WWCQTsCPcadVMmAw
         if7RN2mTHmkN3QfDR5Jh1iGBCMaVik7U+io4PYtcQDAb/bMdQTlQbiLQIUPVynFcpjDz
         MnLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=gEBvQG945nw6PeIGCHJGYkG1Klh1FidBj3ztTvMKYBs=;
        b=Z8d4gzBKwhUfUOKhyg3+MeW5hTtIrndPBsF+lHn3tt5VtMdHcR8g021kD3QCkEZaJV
         zlQvAgay6Mh0JK2aTKDjQUCLJf+qpshPoFRIvO/RzEc0P4G5xUlnLxYMOzcsmFcDD/9Q
         1k4XHBtt5M/pLN6HsxC3bHlA6EeWIcLJQjb3zxLABT9t6AvyDLMHi0eo68wZQ7ltKEye
         wgekbFgijh9C6erc1csDaMSbHMR4T8oUWhfe9yt0w1FK98zxy+NxJaSuVJh+vCAVjcvk
         4n8NrsToWdwKd3cPD0tm1N70/rfFPN2K/FodFKTQ1M0sIdo899qsfMAHLEvmlOjLTphr
         Pz3g==
X-Gm-Message-State: APjAAAW4zG6lBV//YuKhfOgkRBE17I7TK4hEfpDc1LMKpPWz/9fhLda9
        6pOJ/s7DapL8mJzT+1qitQE=
X-Google-Smtp-Source: APXvYqwBStv5BfhCS5uZgaXdkePDhGiYLBLRwiuOfx3ZOIcjy1Gd5x4VdKe/oNnY4ulhsQtfyj7s/w==
X-Received: by 2002:a05:6602:2205:: with SMTP id n5mr9174331ion.258.1571410479704;
        Fri, 18 Oct 2019 07:54:39 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o26sm1731264ioo.61.2019.10.18.07.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 07:54:39 -0700 (PDT)
Subject: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
From:   John Fastabend <john.fastabend@gmail.com>
To:     andriin@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Fri, 18 Oct 2019 07:54:26 -0700
Message-ID: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following ./Documentation/trace/kprobetrace.rst add support for loading
kprobes programs on older kernels.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 tools/lib/bpf/libbpf.c |   81 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index fcea6988f962..12b3105d112c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5005,20 +5005,89 @@ static int determine_uprobe_retprobe_bit(void)
 	return parse_uint_from_file(file, "config:%d\n");
 }
 
+static int use_kprobe_debugfs(const char *name,
+			      uint64_t offset, int pid, bool retprobe)
+{
+	const char *file = "/sys/kernel/debug/tracing/kprobe_events";
+	int fd = open(file, O_WRONLY | O_APPEND, 0);
+	char buf[PATH_MAX];
+	int err;
+
+	if (fd < 0) {
+		pr_warning("failed open kprobe_events: %s\n",
+			   strerror(errno));
+		return -errno;
+	}
+
+	snprintf(buf, sizeof(buf), "%c:kprobes/%s %s",
+		 retprobe ? 'r' : 'p', name, name);
+
+	err = write(fd, buf, strlen(buf));
+	close(fd);
+	if (err < 0)
+		return -errno;
+	return 0;
+}
+
 static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 				 uint64_t offset, int pid)
 {
 	struct perf_event_attr attr = {};
 	char errmsg[STRERR_BUFSIZE];
+	uint64_t config1 = 0;
 	int type, pfd, err;
 
 	type = uprobe ? determine_uprobe_perf_type()
 		      : determine_kprobe_perf_type();
 	if (type < 0) {
-		pr_warning("failed to determine %s perf type: %s\n",
-			   uprobe ? "uprobe" : "kprobe",
-			   libbpf_strerror_r(type, errmsg, sizeof(errmsg)));
-		return type;
+		if (uprobe) {
+			pr_warning("failed to determine uprobe perf type %s: %s\n",
+				   name,
+				   libbpf_strerror_r(type,
+						     errmsg, sizeof(errmsg)));
+		} else {
+			/* If we do not have an event_source/../kprobes then we
+			 * can try to use kprobe-base event tracing, for details
+			 * see ./Documentation/trace/kprobetrace.rst
+			 */
+			const char *file = "/sys/kernel/debug/tracing/events/kprobes/";
+			char c[PATH_MAX];
+			int fd, n;
+
+			snprintf(c, sizeof(c), "%s/%s/id", file, name);
+
+			err = use_kprobe_debugfs(name, offset, pid, retprobe);
+			if (err)
+				return err;
+
+			type = PERF_TYPE_TRACEPOINT;
+			fd = open(c, O_RDONLY, 0);
+			if (fd < 0) {
+				pr_warning("failed to open tracepoint %s: %s\n",
+					   c, strerror(errno));
+				return -errno;
+			}
+			n = read(fd, c, sizeof(c));
+			close(fd);
+			if (n < 0) {
+				pr_warning("failed to read %s: %s\n",
+					   c, strerror(errno));
+				return -errno;
+			}
+			c[n] = '\0';
+			config1 = strtol(c, NULL, 0);
+			attr.size = sizeof(attr);
+			attr.type = type;
+			attr.config = config1;
+			attr.sample_period = 1;
+			attr.wakeup_events = 1;
+		}
+	} else {
+		config1 = ptr_to_u64(name);
+		attr.size = sizeof(attr);
+		attr.type = type;
+		attr.config1 = config1; /* kprobe_func or uprobe_path */
+		attr.config2 = offset;  /* kprobe_addr or probe_offset */
 	}
 	if (retprobe) {
 		int bit = uprobe ? determine_uprobe_retprobe_bit()
@@ -5033,10 +5102,6 @@ static int perf_event_open_probe(bool uprobe, bool retprobe, const char *name,
 		}
 		attr.config |= 1 << bit;
 	}
-	attr.size = sizeof(attr);
-	attr.type = type;
-	attr.config1 = ptr_to_u64(name); /* kprobe_func or uprobe_path */
-	attr.config2 = offset;		 /* kprobe_addr or probe_offset */
 
 	/* pid filter is meaningful only for uprobes */
 	pfd = syscall(__NR_perf_event_open, &attr,

