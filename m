Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0092A4EB343
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 20:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiC2SV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 14:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237003AbiC2SV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 14:21:26 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC6E71621B6;
        Tue, 29 Mar 2022 11:19:42 -0700 (PDT)
Received: from localhost.localdomain (c-73-140-2-214.hsd1.wa.comcast.net [73.140.2.214])
        by linux.microsoft.com (Postfix) with ESMTPSA id BE43220B96D6;
        Tue, 29 Mar 2022 11:19:41 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BE43220B96D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1648577982;
        bh=f9qUQoZpYwIEzqc7SGe0CJ57hdKsehX5evOGy/BoPYc=;
        h=From:To:Cc:Subject:Date:From;
        b=q/ggZtAEYBzvhh9xN1WECC6t4CwtTywgUYpNB/Az2BGLpVj0a9njS8eMNi/F1hBEJ
         WFWP4NmEBdUEw9yYnVgRlQLroJqO5P1SMFJhkT8DZJzhngiUslLX4Pde3U8kSCkWuK
         jsWs4/QbL2A7rcSvjxigL9PPyvINMM9rP69ohDW0=
From:   Beau Belgrave <beaub@linux.microsoft.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     linux-trace-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-arch@vger.kernel.org, mathieu.desnoyers@efficios.com,
        beaub@linux.microsoft.com
Subject: [PATCH] tracing/user_events: Add eBPF interface for user_event created events
Date:   Tue, 29 Mar 2022 11:19:35 -0700
Message-Id: <20220329181935.2183-1-beaub@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Send user_event data to attached eBPF programs for user_event based perf
events.

Add BPF_ITER flag to allow user_event data to have a zero copy path into
eBPF programs if required.

Update documentation to describe new flags and structures for eBPF
integration.

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
---
 Documentation/trace/user_events.rst | 14 ++++--
 include/uapi/linux/user_events.h    | 53 +++++++++++++++++++++
 kernel/trace/trace_events_user.c    | 73 ++++++++++++++++++++++++++++-
 3 files changed, 136 insertions(+), 4 deletions(-)

diff --git a/Documentation/trace/user_events.rst b/Documentation/trace/user_events.rst
index c180936f49fc..bddedabaca80 100644
--- a/Documentation/trace/user_events.rst
+++ b/Documentation/trace/user_events.rst
@@ -7,7 +7,7 @@ user_events: User-based Event Tracing
 Overview
 --------
 User based trace events allow user processes to create events and trace data
-that can be viewed via existing tools, such as ftrace and perf.
+that can be viewed via existing tools, such as ftrace, perf and eBPF.
 To enable this feature, build your kernel with CONFIG_USER_EVENTS=y.
 
 Programs can view status of the events via
@@ -67,7 +67,8 @@ The command string format is as follows::
 
 Supported Flags
 ^^^^^^^^^^^^^^^
-None yet
+**BPF_ITER** - EBPF programs attached to this event will get the raw iovec
+struct instead of any data copies for max performance.
 
 Field Format
 ^^^^^^^^^^^^
@@ -159,7 +160,7 @@ The following values are defined to aid in checking what has been attached:
 
 **EVENT_STATUS_FTRACE** - Bit set if ftrace has been attached (Bit 0).
 
-**EVENT_STATUS_PERF** - Bit set if perf has been attached (Bit 1).
+**EVENT_STATUS_PERF** - Bit set if perf/eBPF has been attached (Bit 1).
 
 Writing Data
 ------------
@@ -203,6 +204,13 @@ It's advised for user programs to do the following::
 
 **NOTE:** *The write_index is not emitted out into the trace being recorded.*
 
+EBPF
+----
+EBPF programs that attach to a user-based event tracepoint are given a pointer
+to a struct user_bpf_context. The bpf context contains the data type (which can
+be a user or kernel buffer, or can be a pointer to the iovec) and the data
+length that was emitted (minus the write_index).
+
 Example Code
 ------------
 See sample code in samples/user_events.
diff --git a/include/uapi/linux/user_events.h b/include/uapi/linux/user_events.h
index 736e05603463..e570840571e1 100644
--- a/include/uapi/linux/user_events.h
+++ b/include/uapi/linux/user_events.h
@@ -32,6 +32,9 @@
 /* Create dynamic location entry within a 32-bit value */
 #define DYN_LOC(offset, size) ((size) << 16 | (offset))
 
+/* Use raw iterator for attached BPF program(s), no affect on ftrace/perf */
+#define FLAG_BPF_ITER (1 << 0)
+
 /*
  * Describes an event registration and stores the results of the registration.
  * This structure is passed to the DIAG_IOCSREG ioctl, callers at a minimum
@@ -60,4 +63,54 @@ struct user_reg {
 /* Requests to delete a user_event */
 #define DIAG_IOCSDEL _IOW(DIAG_IOC_MAGIC, 1, char*)
 
+/* Data type that was passed to the BPF program */
+enum {
+	/* Data resides in kernel space */
+	USER_BPF_DATA_KERNEL,
+
+	/* Data resides in user space */
+	USER_BPF_DATA_USER,
+
+	/* Data is a pointer to a user_bpf_iter structure */
+	USER_BPF_DATA_ITER,
+};
+
+/*
+ * Describes an iovec iterator that BPF programs can use to access data for
+ * a given user_event write() / writev() call.
+ */
+struct user_bpf_iter {
+
+	/* Offset of the data within the first iovec */
+	__u32 iov_offset;
+
+	/* Number of iovec structures */
+	__u32 nr_segs;
+
+	/* Pointer to iovec structures */
+	const struct iovec *iov;
+};
+
+/* Context that BPF programs receive when attached to a user_event */
+struct user_bpf_context {
+
+	/* Data type being passed (see union below) */
+	__u32 data_type;
+
+	/* Length of the data */
+	__u32 data_len;
+
+	/* Pointer to data, varies by data type */
+	union {
+		/* Kernel data (data_type == USER_BPF_DATA_KERNEL) */
+		void *kdata;
+
+		/* User data (data_type == USER_BPF_DATA_USER) */
+		void *udata;
+
+		/* Direct iovec (data_type == USER_BPF_DATA_ITER) */
+		struct user_bpf_iter *iter;
+	};
+};
+
 #endif /* _UAPI_LINUX_USER_EVENTS_H */
diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 3bc97e44253f..8b3d241a31c2 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -42,6 +42,9 @@
 #define MAX_FIELD_ARRAY_SIZE 1024
 #define MAX_FIELD_ARG_NAME 256
 
+#define MAX_BPF_COPY_SIZE PAGE_SIZE
+#define MAX_STACK_BPF_DATA 512
+
 static char *register_page_data;
 
 static DEFINE_MUTEX(reg_mutex);
@@ -402,6 +405,19 @@ static int user_event_parse_field(char *field, struct user_event *user,
 				    type[0] != 'u', FILTER_OTHER);
 }
 
+static void user_event_parse_flags(struct user_event *user, char *flags)
+{
+	char *flag;
+
+	if (flags == NULL)
+		return;
+
+	while ((flag = strsep(&flags, ",")) != NULL) {
+		if (strcmp(flag, "BPF_ITER") == 0)
+			user->flags |= FLAG_BPF_ITER;
+	}
+}
+
 static int user_event_parse_fields(struct user_event *user, char *args)
 {
 	char *field;
@@ -697,14 +713,64 @@ static void user_event_ftrace(struct user_event *user, struct iov_iter *i,
 }
 
 #ifdef CONFIG_PERF_EVENTS
+static void user_event_bpf(struct user_event *user, struct iov_iter *i)
+{
+	struct user_bpf_context context;
+	struct user_bpf_iter bpf_i;
+	char fast_data[MAX_STACK_BPF_DATA];
+	void *temp = NULL;
+
+	if ((user->flags & FLAG_BPF_ITER) && iter_is_iovec(i)) {
+		/* Raw iterator */
+		context.data_type = USER_BPF_DATA_ITER;
+		context.data_len = i->count;
+		context.iter = &bpf_i;
+
+		bpf_i.iov_offset = i->iov_offset;
+		bpf_i.iov = i->iov;
+		bpf_i.nr_segs = i->nr_segs;
+	} else if (i->nr_segs == 1 && iter_is_iovec(i)) {
+		/* Single buffer from user */
+		context.data_type = USER_BPF_DATA_USER;
+		context.data_len = i->count;
+		context.udata = i->iov->iov_base + i->iov_offset;
+	} else {
+		/* Multi buffer from user */
+		struct iov_iter copy = *i;
+		size_t copy_size = min_t(size_t, i->count, MAX_BPF_COPY_SIZE);
+
+		context.data_type = USER_BPF_DATA_KERNEL;
+		context.kdata = fast_data;
+
+		if (unlikely(copy_size > sizeof(fast_data))) {
+			temp = kmalloc(copy_size, GFP_NOWAIT);
+
+			if (temp)
+				context.kdata = temp;
+			else
+				copy_size = sizeof(fast_data);
+		}
+
+		context.data_len = copy_nofault(context.kdata,
+						copy_size, &copy);
+	}
+
+	trace_call_bpf(&user->call, &context);
+
+	kfree(temp);
+}
+
 /*
- * Writes the user supplied payload out to perf ring buffer.
+ * Writes the user supplied payload out to perf ring buffer or eBPF program.
  */
 static void user_event_perf(struct user_event *user, struct iov_iter *i,
 			    void *tpdata, bool *faulted)
 {
 	struct hlist_head *perf_head;
 
+	if (bpf_prog_array_valid(&user->call))
+		user_event_bpf(user, i);
+
 	perf_head = this_cpu_ptr(user->call.perf_events);
 
 	if (perf_head && !hlist_empty(perf_head)) {
@@ -1070,6 +1136,8 @@ static int user_event_parse(char *name, char *args, char *flags,
 
 	user->tracepoint.name = name;
 
+	user_event_parse_flags(user, flags);
+
 	ret = user_event_parse_fields(user, args);
 
 	if (ret)
@@ -1507,6 +1575,9 @@ static int user_seq_show(struct seq_file *m, void *p)
 			busy++;
 		}
 
+		if (flags & FLAG_BPF_ITER)
+			seq_puts(m, " FLAG:BPF_ITER");
+
 		seq_puts(m, "\n");
 		active++;
 	}
-- 
2.25.1

