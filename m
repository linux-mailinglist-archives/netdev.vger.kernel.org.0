Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C237D700
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 10:11:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730941AbfHAILq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 04:11:46 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36189 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730094AbfHAILp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 04:11:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id l21so33716070pgm.3
        for <netdev@vger.kernel.org>; Thu, 01 Aug 2019 01:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ww2Edgc2Mn17QxdgJWaSNqf+cyOs86DTpg9N3pfAuBk=;
        b=H+61pHfEhMjq6Jv0YGksBEEQxVXQ/5uHF4QFspij1yWfSddIxNsPb9iL7xAH8Ru2uL
         370RrHcEqWsz4Q2kajMJC+fdOvZhRl+5vQuhkW8DuHyrqYUzcHAXNIZBbIgtObbscaoD
         EICBzFaFhLAZmxntkL9sqYTE6kB7ujjtUj4IdE9qmSoKNSzwRIgRMd7JaMTgAxGe2SE1
         MK068jPixO7+TlERe4d0ifi5PMac8ydE/dIqwRyQwUrP9AM3VwGp4k0Zh3irbtk6YYya
         TKW0CEp0kkhZbRjBu9GuGIwcSp5jLlFH7Q9rENhvb6LXFLSDervYD1YDNYbO5XyAOTZE
         mTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ww2Edgc2Mn17QxdgJWaSNqf+cyOs86DTpg9N3pfAuBk=;
        b=dlmu4qFksSnqkU25OTKBFPrFcr+mzL3Ezu7oxg55QXCYa06QhcA+WcDeztxwEinQTF
         R9Vv84gqXDBjZ3zMx8iPeG8eic6kHRAMJoYSGq7L7pgq2NaNnLimoKfV4c1OOVo7Hscl
         jPdPPHZEkzU4h32R/11X56NPMj4bPhk/y2cfvruukEcN945v6emyTkuJ/CY5qFhMxNbz
         y7IRNHIRPB+iHZPaBhvLTm+XmEjs7ro8Kv5U3OOWcKr7CblpMHTl+3T034pTndw6Oxgt
         KDXUM/1hRFwLjXbcLb6O+5lTmi8DQlOmgCThysZ11OFZtChQ7pu8eU2ysCck+ZZwcy/B
         8nhQ==
X-Gm-Message-State: APjAAAUfI9xpGebdD2hkLWIlmARCciufgu/+B5d0oxZky2vbaDVDFu+a
        VihpqERFC4uDCPQrgT1yzQ==
X-Google-Smtp-Source: APXvYqzeTM9tWJQSPt4Q9YM4LGa9aDK4GglDg6aBIvapqUst/iJwUWrTzhYwNRM433ofRADPqMIL/A==
X-Received: by 2002:a63:66c5:: with SMTP id a188mr117233966pgc.127.1564647104551;
        Thu, 01 Aug 2019 01:11:44 -0700 (PDT)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id br18sm3917286pjb.20.2019.08.01.01.11.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 01 Aug 2019 01:11:44 -0700 (PDT)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [v2,2/2] tools: bpftool: add net detach command to detach XDP on interface
Date:   Thu,  1 Aug 2019 17:11:33 +0900
Message-Id: <20190801081133.13200-3-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190801081133.13200-1-danieltimlee@gmail.com>
References: <20190801081133.13200-1-danieltimlee@gmail.com>
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
Changes in v2:
  - command 'unload' changed to 'detach' for the consistency

 tools/bpf/bpftool/net.c | 55 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/net.c b/tools/bpf/bpftool/net.c
index f3b57660b303..2ae9a613b05c 100644
--- a/tools/bpf/bpftool/net.c
+++ b/tools/bpf/bpftool/net.c
@@ -281,6 +281,31 @@ static int parse_attach_args(int argc, char **argv, int *progfd,
 	return 0;
 }
 
+static int parse_detach_args(int argc, char **argv,
+			     enum net_attach_type *attach_type, int *ifindex)
+{
+	if (!REQ_ARGS(2))
+		return -EINVAL;
+
+	*attach_type = parse_attach_type(*argv);
+	if (*attach_type == __MAX_NET_ATTACH_TYPE) {
+		p_err("invalid net attach/detach type");
+		return -EINVAL;
+	}
+
+	NEXT_ARG();
+	if (!REQ_ARGS(1))
+		return -EINVAL;
+
+	*ifindex = if_nametoindex(*argv);
+	if (!*ifindex) {
+		p_err("Invalid ifname");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int do_attach_detach_xdp(int *progfd, enum net_attach_type *attach_type,
 				int *ifindex)
 {
@@ -323,6 +348,31 @@ static int do_attach(int argc, char **argv)
 	return 0;
 }
 
+static int do_detach(int argc, char **argv)
+{
+	enum net_attach_type attach_type;
+	int err, progfd, ifindex;
+
+	err = parse_detach_args(argc, argv, &attach_type, &ifindex);
+	if (err)
+		return err;
+
+	/* to detach xdp prog */
+	progfd = -1;
+	if (is_prefix("xdp", attach_type_strings[attach_type]))
+		err = do_attach_detach_xdp(&progfd, &attach_type, &ifindex);
+
+	if (err < 0) {
+		p_err("link set %s failed", attach_type_strings[attach_type]);
+		return -1;
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
@@ -406,6 +456,7 @@ static int do_help(int argc, char **argv)
 	fprintf(stderr,
 		"Usage: %s %s { show | list } [dev <devname>]\n"
 		"       %s %s attach PROG LOAD_TYPE <devname>\n"
+		"       %s %s detach LOAD_TYPE <devname>\n"
 		"       %s %s help\n"
 		"\n"
 		"       " HELP_SPEC_PROGRAM "\n"
@@ -415,7 +466,8 @@ static int do_help(int argc, char **argv)
 		"      to dump program attachments. For program types\n"
 		"      sk_{filter,skb,msg,reuseport} and lwt/seg6, please\n"
 		"      consult iproute2.\n",
-		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2]);
+		bin_name, argv[-2], bin_name, argv[-2], bin_name, argv[-2],
+		bin_name, argv[-2]);
 
 	return 0;
 }
@@ -424,6 +476,7 @@ static const struct cmd cmds[] = {
 	{ "show",	do_show },
 	{ "list",	do_show },
 	{ "attach",	do_attach },
+	{ "detach",	do_detach },
 	{ "help",	do_help },
 	{ 0 }
 };
-- 
2.20.1

