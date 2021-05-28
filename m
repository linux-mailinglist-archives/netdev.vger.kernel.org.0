Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3622394960
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 01:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhE1X4K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 19:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhE1X4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 19:56:05 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C7FC0613ED;
        Fri, 28 May 2021 16:54:25 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v14so3705755pgi.6;
        Fri, 28 May 2021 16:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0QZLbqkCIH0r+P47KlUh/Z70XeLVxWHCUDIgLe1Pyr8=;
        b=cReB7qvr21/+jI88eUmp1kJUJEg+p1stl+YvjIFuDHvPK3/SeCXOJS9kxNrXh/6PBn
         xbmcMG1kwVHTeE6IGm2eAxcN6e1jUTBz5UXqpkY3d3y8s6SEcVJDCGxuGUaes4mIRxoz
         W9AHgTMSXmmVD4wZhwJ0Tpws2HgU9QS0agmOA/yfOG/mlI1gtxzMn6P1j97p5oCj+bhk
         I8+jFHI62tkdRvhazYXuYl/0D74ifRy4PRvbUOhWQjtYS9WGYBl3WpwhOvJ4Gvygf7UD
         D+ybCObWZ/ZbWbfQrgbU6t/8KwzQs3n9X9sOvz5bEHWn6K6lNxovarYZyfV0BtGdNStW
         BZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0QZLbqkCIH0r+P47KlUh/Z70XeLVxWHCUDIgLe1Pyr8=;
        b=FaJAaDXiAWW4CWY5IkTlgxL5iBNHBem4TZFkeX6fpHCJEHlxUeiXYea2RqYG78JXGM
         zMS8KT2U7EQTbKxX6GzmLB8gn19QgG04fVk8hfYbWlzV7AMjK1LvIVDS11Kkhn8BaAEb
         Sap/Zg5PRd8tWKWv5dk+yE32k40sJr2cUTGIgAAMg3EN1nvVNvE8pWT8xFYxvRwTXLDV
         I9Jw4ULXU0XK9HgK+CsfDbr9g5B7o78U4zwPzDYn3evF+/b7dazIqbmo187gXefSLSGd
         BcDuRZimJoEME+jazWJvZ9+JHyw26D4cqkz0si9PP/4k65FUnOKgclhrasTOxg+zXLK+
         YXIw==
X-Gm-Message-State: AOAM53220WPOYx6ixObvk6jPlBYg6yl8s2oFEMxhjPNtpaXv2+K60jWk
        yYxw6VZGBH3Lhkx3J7Rif0PQl2mBBms=
X-Google-Smtp-Source: ABdhPJxMwGLKEYq27r5EBvsW31BOlHVK+fEDzonZGYEILp9YQZSFHc8rKQ3ZXi0L1oMu1n4l+ZwJOA==
X-Received: by 2002:a63:fd44:: with SMTP id m4mr11712379pgj.396.1622246065161;
        Fri, 28 May 2021 16:54:25 -0700 (PDT)
Received: from localhost ([2402:3a80:11db:3aa9:ad24:a4a2:844f:6a0a])
        by smtp.gmail.com with ESMTPSA id 141sm402521pgf.20.2021.05.28.16.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 16:54:24 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH RFC bpf-next 14/15] samples: bpf: add documentation
Date:   Sat, 29 May 2021 05:22:49 +0530
Message-Id: <20210528235250.2635167-15-memxor@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210528235250.2635167-1-memxor@gmail.com>
References: <20210528235250.2635167-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prints some help text meant to explain the output.

Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 samples/bpf/xdp_monitor_user.c      | 10 ++++--
 samples/bpf/xdp_redirect_cpu_user.c |  8 +++--
 samples/bpf/xdp_redirect_map_user.c |  6 ++--
 samples/bpf/xdp_sample_user.c       | 52 +++++++++++++++++++++++++++++
 samples/bpf/xdp_sample_user.h       |  1 +
 5 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/samples/bpf/xdp_monitor_user.c b/samples/bpf/xdp_monitor_user.c
index b37d8f7379ec..71d59e714bae 100644
--- a/samples/bpf/xdp_monitor_user.c
+++ b/samples/bpf/xdp_monitor_user.c
@@ -35,6 +35,10 @@ static const char *__doc_err_only__=
 static bool debug = false;
 struct bpf_object *obj;
 
+static int mask = SAMPLE_REDIRECT_ERR_CNT | SAMPLE_CPUMAP_ENQUEUE_CNT |
+		  SAMPLE_CPUMAP_KTHREAD_CNT | SAMPLE_EXCEPTION_CNT |
+		  SAMPLE_DEVMAP_XMIT_CNT;
+
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
 	{"debug",	no_argument,		NULL, 'D' },
@@ -56,6 +60,9 @@ static void int_exit(int sig)
 static void usage(char *argv[])
 {
 	int i;
+
+	sample_print_help(mask);
+
 	printf("\nDOCUMENTATION:\n%s\n", __doc__);
 	printf("\n");
 	printf(" Usage: %s (options-see-below)\n",
@@ -110,9 +117,6 @@ static void print_bpf_prog_info(void)
 
 int main(int argc, char **argv)
 {
-	int mask = SAMPLE_REDIRECT_ERR_CNT | SAMPLE_CPUMAP_ENQUEUE_CNT |
-		   SAMPLE_CPUMAP_KTHREAD_CNT | SAMPLE_EXCEPTION_CNT |
-		   SAMPLE_DEVMAP_XMIT_CNT;
 	int longindex = 0, opt;
 	int ret = EXIT_FAILURE;
 	char filename[256];
diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index d56b89254cd1..9233b8a2bf2d 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -37,6 +37,9 @@ static int avail_fd;
 static int count_fd;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
+		  SAMPLE_CPUMAP_ENQUEUE_CNT | SAMPLE_CPUMAP_KTHREAD_CNT |
+		  SAMPLE_EXCEPTION_CNT;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -96,6 +99,8 @@ static void usage(char *argv[], struct bpf_object *obj)
 {
 	int i;
 
+	sample_print_help(mask);
+
 	printf("\nDOCUMENTATION:\n%s\n", __doc__);
 	printf("\n");
 	printf(" Usage: %s (options-see-below)\n", argv[0]);
@@ -201,9 +206,6 @@ static void __stats_poll(int interval, bool redir_suc, char *prog_name,
 			 char *mprog_name, struct bpf_cpumap_val *value,
 			 bool stress_mode)
 {
-	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_CNT |
-		   SAMPLE_CPUMAP_ENQUEUE_CNT | SAMPLE_CPUMAP_KTHREAD_CNT |
-		   SAMPLE_EXCEPTION_CNT;
 	struct stats_record *record, *prev;
 
 	record = alloc_stats_record();
diff --git a/samples/bpf/xdp_redirect_map_user.c b/samples/bpf/xdp_redirect_map_user.c
index eb4013fa58cb..f4bdefa83709 100644
--- a/samples/bpf/xdp_redirect_map_user.c
+++ b/samples/bpf/xdp_redirect_map_user.c
@@ -28,6 +28,8 @@ static __u32 prog_id;
 static __u32 dummy_prog_id;
 
 static __u32 xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
+static int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
+		  SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT;
 
 static const struct option long_options[] = {
 	{"help",	no_argument,		NULL, 'h' },
@@ -78,6 +80,8 @@ static void usage(char *argv[])
 {
 	int i;
 
+	sample_print_help(mask);
+
 	printf("\n");
 	printf(" Usage: %s (options-see-below)\n",
 	       argv[0]);
@@ -97,8 +101,6 @@ static void usage(char *argv[])
 
 int main(int argc, char **argv)
 {
-	int mask = SAMPLE_RX_CNT | SAMPLE_REDIRECT_ERR_MAP_CNT |
-		   SAMPLE_EXCEPTION_CNT | SAMPLE_DEVMAP_XMIT_CNT;
 	struct bpf_prog_load_attr prog_load_attr = {
 		.prog_type	= BPF_PROG_TYPE_UNSPEC,
 	};
diff --git a/samples/bpf/xdp_sample_user.c b/samples/bpf/xdp_sample_user.c
index 96d36c708ee3..aa02d9bbea6c 100644
--- a/samples/bpf/xdp_sample_user.c
+++ b/samples/bpf/xdp_sample_user.c
@@ -77,6 +77,58 @@ static bool err_exp;
 #define PASS(pass) pass, "pass/s"
 #define REDIR(redir) redir, "redir/s"
 
+void sample_print_help(int mask)
+{
+	printf("Output format description\n\n"
+	       "By default, redirect success statistics are disabled, use -s to enable.\n"
+	       "The terse output mode is default, verbose mode can be activated using -v\n"
+	       "Use SIGQUIT (Ctrl + \\) to switch the mode dynamically at runtime\n\n"
+	       "Terse mode displays at most the following fields:\n"
+	       "  rx/s     Number of packets received per second\n"
+	       "  redir/s  Number of packets successfully redirected per second\n"
+	       "  error/s  Aggregated count of errors per second (including dropped packets)\n"
+	       "  xmit/s   Number of packets transmitted on the output device per second\n\n"
+	       "Output description for verbose mode:\n"
+	       "  FIELD         DESCRIPTION\n");
+	if (mask & SAMPLE_RX_CNT) {
+		printf("  receive\tDisplays the number of packets received & errors encountered\n"
+		       " \t\tWhenever an error or packet drop occurs, details of per CPU error\n"
+		       " \t\tand drop statistics will be expanded inline in terse mode.\n"
+		       " \t\t\tpkt/s     - Packets received per second\n"
+		       " \t\t\tdrop/s    - Packets dropped per second\n"
+		       " \t\t\terror/s   - Errors encountered per second\n\n");
+	}
+	if (mask & (SAMPLE_REDIRECT_CNT|SAMPLE_REDIRECT_ERR_CNT)) {
+		printf("  redirect\tDisplays the number of packets successfully redirected\n"
+		       "  \t\tErrors encountered are expanded under redirect_err field\n"
+		       "  \t\tNote that passing -s to enable it has a per packet overhead\n"
+		       "  \t\t\tredir/s   - Packets redirected successfully per second\n\n"
+		       "  redirect_err\tDisplays the number of packets that failed redirection\n"
+		       "  \t\tThe errno is expanded under this field with per CPU count\n"
+		       "  \t\tThe recognized errors are EOPNOTSUPP, EINVAL, ENETDOWN and EMSGSIZE\n"
+		       "  \t\t\terror/s   - Packets that failed redirection per second\n\n");
+	}
+
+	if (mask & SAMPLE_EXCEPTION_CNT) {
+		printf("  xdp_exception\tDisplays xdp_exception tracepoint events\n"
+		       "  \t\tThis can occur due to internal driver errors, unrecognized\n"
+		       "  \t\tXDP actions and due to explicit user trigger by use of XDP_ABORTED\n"
+		       "  \t\tEach action is expanded below this field with its count\n"
+		       "  \t\t\thit/s     - Number of times the tracepoint was hit per second\n\n");
+	}
+
+	if (mask & SAMPLE_DEVMAP_XMIT_CNT) {
+		printf("  devmap_xmit\tDisplays devmap_xmit tracepoint events\n"
+		       "  \t\tThis tracepoint is invoked for successful transmissions on output\n"
+		       "  \t\tdevice but these statistics are not available for generic XDP mode,\n"
+		       "  \t\thence they will be omitted from the output when using SKB mode\n"
+		       "  \t\t\txmit/s    - Number of packets that were transmitted per second\n"
+		       "  \t\t\tdrop/s    - Number of packets that failed transmissions per second\n"
+		       "  \t\t\tdrv_err/s - Number of internal driver errors per second\n"
+		       "  \t\t\tbulk_avg  - Average number of packets processed for each event\n\n");
+	}
+}
+
 static const char *elixir_search[NUM_TP] = {
 	[TP_REDIRECT_CNT] = "_trace_xdp_redirect",
 	[TP_REDIRECT_MAP_CNT] = "_trace_xdp_redirect_map",
diff --git a/samples/bpf/xdp_sample_user.h b/samples/bpf/xdp_sample_user.h
index 588bd2f15352..41be57d7b663 100644
--- a/samples/bpf/xdp_sample_user.h
+++ b/samples/bpf/xdp_sample_user.h
@@ -169,6 +169,7 @@ void sample_stats_print_cpumap_remote(struct stats_record *stats_rec,
 				      struct stats_record *stats_prev,
 				      unsigned int nr_cpus, char *mprog_name);
 void sample_reset_mode(void);
+void sample_print_help(int mask);
 
 const char *get_driver_name(int ifindex);
 int get_mac_addr(int ifindex, void *mac_addr);
-- 
2.31.1

