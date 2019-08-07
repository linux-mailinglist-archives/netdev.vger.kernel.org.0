Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781F68426D
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 04:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729416AbfHGCZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 22:25:24 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46951 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfHGCZX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 22:25:23 -0400
Received: by mail-pf1-f194.google.com with SMTP id c3so19426160pfa.13
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 19:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PJxgwheVjWJMZkY4yZBhyAZk9oyVr4L1c/3xuU4qo2A=;
        b=HHsE6fhbdNis6P/qQuf3meS+mYC/BAggBIIf1V51q/5zGGTM+c+jJ0lxGV9CQ9hBWB
         ub0RfZIPp0DVcENc3A37k2hI96r2Q1/gtQ9wK65dgswrYQQBgL93T5xInhM6PAqAE9v0
         4iNVLzQCPRQvyb4vhpKCzNOkOhCM0IA2r7uCD1xXOpEmOXL8UMZQ5HwIb5k6LNeBwJp9
         SGTgc2jD6Oh3pPOzS+IQR4OV7MX3l1i4OzdlXJ/ufMGSAxkWi6Jy+bzXZygScEMMkdQu
         WsG6dUFUgHocvA+H576wPWpSLMWlUnJkS8p2xUxd+Wv+so/w/6jbq4unRt7CaSroZ/EQ
         Jliw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PJxgwheVjWJMZkY4yZBhyAZk9oyVr4L1c/3xuU4qo2A=;
        b=AUr4U7MbX4XI74fSIIPMoAVIYqm66u3uSmpx0xdrZVskw5Kx4b5nAlmMW6XyrY379j
         Rqdjt9dBwjSPbdiiRJwxDlJIcA92uoRU91z0r0w0uGeX647QIYkZP7Fdx6wKs1R5D3I5
         Ko7pZeLZKxZ+4HaS/bbXqf4JArwNMDqt/ccwoHs7c4/HiKM3fUdbnZyyMEksqEp9qvXi
         1zF2KhAZifn9yIZ3lqq1PcSjsGDrAGIKM2R7qvL5AnkeUnLmTbsXFOyaaQKG+KX7Cz6W
         YpxuG6TVG0NpJqNmCZJtL/kyfgy0cLuW5GTYL8g6zzVFIue5BUMmyitZjvfOQ3hbpe7I
         oKuA==
X-Gm-Message-State: APjAAAXgjOh36mem1GTyKH1LkXXAAoyGV/0TyTPhJ0zuRfzK8jJA7riK
        kI4L4wU+fJqrfvrWUd8ePa4lGhh6JQ==
X-Google-Smtp-Source: APXvYqxoUO/UUx+NbLYqDGeXRW79fv94s9gHzR2MJfsMlV1vZdzsz8g/eUdj58b2SWQWNMAeFVHfxw==
X-Received: by 2002:a63:5765:: with SMTP id h37mr5550229pgm.183.1565144722874;
        Tue, 06 Aug 2019 19:25:22 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id b126sm129275991pfa.126.2019.08.06.19.25.21
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 19:25:22 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v3,2/4] tools: bpftool: add net detach command to detach XDP on interface
Date:   Wed,  7 Aug 2019 11:25:07 +0900
Message-Id: <20190807022509.4214-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190807022509.4214-1-danieltimlee@gmail.com>
References: <20190807022509.4214-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By this commit, using `bpftool net detach`, the attached XDP prog can
be detached. Detaching the BPF prog will be done through libbpf
'bpf_set_link_xdp_fd' with the progfd set to -1.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 tools/bpf/bpftool/net.c | 42 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index c05a3fac5cac..7be96acb08e0 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -343,6 +343,43 @@ static int do_attach(int argc, char **argv)
 	return 0;
 }
 
+static int do_detach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int progfd, ifindex, err = 0;
+
+	/* parse detach args */
+	if (!REQ_ARGS(3))
+		return -EINVAL;
+
+	attach_type = parse_attach_type(*argv);
+	if (attach_type == max_net_attach_type) {
+		p_err("invalid net attach/detach type");
+		return -EINVAL;
+	}
+
+	NEXT_ARG();
+	ifindex = net_parse_dev(&argc, &argv);
+	if (ifindex < 1)
+		return -EINVAL;
+
+	/* detach xdp prog */
+	progfd = -1;
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(progfd, attach_type, ifindex, NULL);
+
+	if (err < 0) {
+		p_err("interface %s detach failed",
+		      attach_type_strings[attach_type]);
+		return err;
+	}
+
+	if (json_output)
+		jsonw_null(json_wtr);
+
+	return 0;
+}
+
 static int do_show(int argc, char **argv)
 {
 	struct bpf_attach_info attach_info = {};
@@ -419,6 +456,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
 		"       %s %s attach ATTACH_TYPE PROG dev <devname> [ overwrite ]\n"
+		"       %s %s detach ATTACH_TYPE dev <devname>\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -429,7 +467,8 @@ static int do_help(int argc, char **argv)
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -438,6 +477,7 @@ static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
 	{ "attach",	do_attach },
+	{ "detach",	do_detach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

