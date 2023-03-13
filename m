Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAF06B6E7B
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 05:33:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjCMEdx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 00:33:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjCMEdx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 00:33:53 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 824F52BED2
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 21:33:51 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id ne1so7491382qvb.9
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 21:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678682030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8Q2Zh/7fF4Er8L9YqUwAeh1RtxUirfezV0rxxEBcPQY=;
        b=XTNjGblDojzx7HhtT+LVxtcQmdad965nugpXM0wvcRlUJCEHG3D6ekm0xbbv0O6sYI
         0LtTqaNuon78pGdVxidOwyHaoYBQ1I0/5I1yaZLcHSkA8uk4mPXnKc/LFaq+IKMEqiUu
         70d6+oN1NQT+xNoPDx5WnJ5X5nAFw9cLgFwrbHATNZVKYD2TkivhYZ3M/UG8IqV9yQmf
         Zn4D5M3V8NZFN+o7VYO3BLi/Y8roQdEigN9rRSu9wKfoaFUrYT3+DOkqipP8mHzBIoJ0
         kYJ6YjCLkZfYaZjdtLiiotd48XRwLXl1Gij7w0i3ZCLSQVkU2JdKxTrPZLRNBVKg+M9Q
         ZmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678682030;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8Q2Zh/7fF4Er8L9YqUwAeh1RtxUirfezV0rxxEBcPQY=;
        b=RGwti6cMgXtHzZRsmMSPbKrkSZcaGETCm4xYj4R0F3tsSssqSCewzLV9llU2bQHiiV
         qxgjFIZXYx8D5zMajH5MqmC/BtqVgzzOu26V8ZfoZqd6b8jCaiuJf9q/voBcy++kOV/k
         lVYe5NwsEO8F21HY0eKaAEE5y1dwpmoi5xqlG6pTTQ7zyCXpxO5z89a6fibNp7f1Z1xM
         Jbm+H/qwfeCdCrH3Lu9Ku8hL98Y8COFPzc8Cu+zlLS6ZYFreez55fSI6t9PKuONpV6CB
         EL0/GP9s4lSNkzk3LcCHM/ma34+3AMs1OwKFnV5e4eZ9akIxsA2A5gCvHlwaoreBjYOT
         0DZA==
X-Gm-Message-State: AO0yUKUJ9Qclo6AjSFOJZThChi+bJWcs/+r/q5ANw+zKlVsVGql7XyjT
        5Qx06/wCKDKD+yhH1/LvY+HrFRgtcMg=
X-Google-Smtp-Source: AK7set+FFeYtrMi1O0Dee+l5Xf/dkZzuktGcLY9YW+/J9qXzPoU4H6viwukQWyURYO9ECf+dsAq5eQ==
X-Received: by 2002:a05:6214:1cc8:b0:53a:7253:4093 with SMTP id g8-20020a0562141cc800b0053a72534093mr11853036qvd.14.1678682030254;
        Sun, 12 Mar 2023 21:33:50 -0700 (PDT)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:af2d:ae33:c139:49d7])
        by smtp.gmail.com with ESMTPSA id do53-20020a05620a2b3500b007435a646354sm4702989qkb.0.2023.03.12.21.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 21:33:49 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     john.fastabend@gmail.com, jakub@cloudflare.com,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch iproute2-next] ss: dump sockmap information
Date:   Sun, 12 Mar 2023 21:33:39 -0700
Message-Id: <20230313043339.395737-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

This patch dumps sockmap ID's which a socket has been added to.

Sample output:

      # ./iproute2/misc/ss -tnaie --bpf-map
      ESTAB  0      344329     127.0.0.1:1234     127.0.0.1:40912 ino:21098 sk:5 cgroup:/user.slice/user-0.slice/session-c1.scope <-> sockmap: 1

      # bpftool map
      1: sockmap  flags 0x0
            key 4B  value 4B  max_entries 2  memlock 4096B
            pids echo-sockmap(549)
      4: array  name pid_iter.rodata  flags 0x480
            key 4B  value 4B  max_entries 1  memlock 4096B
            btf_id 10  frozen
            pids bpftool(624)

Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 include/uapi/linux/inet_diag.h |  1 +
 include/uapi/linux/sock_diag.h |  8 ++++++++
 include/uapi/linux/unix_diag.h |  1 +
 misc/ss.c                      | 35 ++++++++++++++++++++++++++++++++++
 4 files changed, 45 insertions(+)

diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index d81cb69a..adadeb3c 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -161,6 +161,7 @@ enum {
 	INET_DIAG_SK_BPF_STORAGES,
 	INET_DIAG_CGROUP_ID,
 	INET_DIAG_SOCKOPT,
+	INET_DIAG_BPF_MAP,
 	__INET_DIAG_MAX,
 };
 
diff --git a/include/uapi/linux/sock_diag.h b/include/uapi/linux/sock_diag.h
index 35c0ce67..fb7c3f22 100644
--- a/include/uapi/linux/sock_diag.h
+++ b/include/uapi/linux/sock_diag.h
@@ -62,4 +62,12 @@ enum {
 
 #define SK_DIAG_BPF_STORAGE_MAX        (__SK_DIAG_BPF_STORAGE_MAX - 1)
 
+enum {
+	SK_DIAG_BPF_MAP_NONE,
+	SK_DIAG_BPF_MAP_IDS,
+	__SK_DIAG_BPF_MAP_MAX,
+};
+
+#define SK_DIAG_BPF_MAP_MAX        (__SK_DIAG_BPF_MAP_MAX - 1)
+
 #endif /* __SOCK_DIAG_H__ */
diff --git a/include/uapi/linux/unix_diag.h b/include/uapi/linux/unix_diag.h
index a1988576..b95a2b33 100644
--- a/include/uapi/linux/unix_diag.h
+++ b/include/uapi/linux/unix_diag.h
@@ -42,6 +42,7 @@ enum {
 	UNIX_DIAG_MEMINFO,
 	UNIX_DIAG_SHUTDOWN,
 	UNIX_DIAG_UID,
+	UNIX_DIAG_BPF_MAP,
 
 	__UNIX_DIAG_MAX,
 };
diff --git a/misc/ss.c b/misc/ss.c
index de02fccb..a4e72346 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -121,6 +121,7 @@ static int show_tipcinfo;
 static int show_tos;
 static int show_cgroup;
 static int show_inet_sockopt;
+static int show_bpf_map;
 int oneline;
 
 enum col_id {
@@ -3377,6 +3378,28 @@ static void parse_diag_msg(struct nlmsghdr *nlh, struct sockstat *s)
 	memcpy(s->remote.data, r->id.idiag_dst, s->local.bytelen);
 }
 
+static void print_bpf_map(struct rtattr *tb)
+{
+	if (tb) {
+		struct rtattr *sockmap[SK_DIAG_BPF_MAP_MAX + 1] = { 0 };
+
+		parse_rtattr_nested(sockmap, SK_DIAG_BPF_MAP_MAX, tb);
+		if (sockmap[SK_DIAG_BPF_MAP_IDS]) {
+			__u32 *maps = RTA_DATA(sockmap[SK_DIAG_BPF_MAP_IDS]);
+			int len = RTA_PAYLOAD(sockmap[SK_DIAG_BPF_MAP_IDS]);
+
+			out(" sockmap:");
+			out(" %d", *maps);
+			maps++;
+			for (len -= 4; len > 0; len -= 4) {
+				out(",");
+				out(" %d", *maps);
+				maps++;
+			}
+		}
+	}
+}
+
 static int inet_show_sock(struct nlmsghdr *nlh,
 			  struct sockstat *s)
 {
@@ -3470,6 +3493,9 @@ static int inet_show_sock(struct nlmsghdr *nlh,
 		}
 	}
 
+	if (show_bpf_map)
+		print_bpf_map(tb[INET_DIAG_BPF_MAP]);
+
 	if (show_mem || (show_tcpinfo && s->type != IPPROTO_UDP)) {
 		if (!oneline)
 			out("\n\t");
@@ -4153,6 +4179,9 @@ static int unix_show_sock(struct nlmsghdr *nlh, void *arg)
 		}
 	}
 
+	if (show_bpf_map)
+		print_bpf_map(tb[UNIX_DIAG_BPF_MAP]);
+
 	return 0;
 }
 
@@ -5469,6 +5498,8 @@ static int scan_state(const char *state)
 
 #define OPT_INET_SOCKOPT 262
 
+#define OPT_BPF_MAP 263
+
 static const struct option long_opts[] = {
 	{ "numeric", 0, 0, 'n' },
 	{ "resolve", 0, 0, 'r' },
@@ -5513,6 +5544,7 @@ static const struct option long_opts[] = {
 	{ "mptcp", 0, 0, 'M' },
 	{ "oneline", 0, 0, 'O' },
 	{ "inet-sockopt", 0, 0, OPT_INET_SOCKOPT },
+	{ "bpf-map", 0, 0, OPT_BPF_MAP },
 	{ 0 }
 
 };
@@ -5715,6 +5747,9 @@ int main(int argc, char *argv[])
 		case OPT_INET_SOCKOPT:
 			show_inet_sockopt = 1;
 			break;
+		case OPT_BPF_MAP:
+			show_bpf_map = 1;
+			break;
 		case 'h':
 			help();
 		case '?':
-- 
2.34.1

