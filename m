Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35312E33D5
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393536AbfJXNVY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:21:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26849 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730061AbfJXNVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 09:21:24 -0400
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com [209.85.208.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2F37E3D94D
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 13:21:24 +0000 (UTC)
Received: by mail-lj1-f200.google.com with SMTP id p14so4003705ljh.22
        for <netdev@vger.kernel.org>; Thu, 24 Oct 2019 06:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GuoLFI180GdL56vV8nO50qFTF6fdq6eDG+c2BybpcyU=;
        b=P2DZ5HUCrq6GCPktk3EMFQbwuJAs0KiC2dMJoPYL4b8vOopblgWc7G86jcvfYnmkAD
         /YrHDWqZTNGeoEIVE2aWLbvfbVprR1Zst1oEOVMLfPk0eEkgGLh4EcbF0lxyUouDX9Hv
         dILbNIj8onHJeBAe6VJlVYqTiqLIbAhWo2iWpxsSf1fkD7ClIVr9pi6BXO51tKhmdyu7
         YaXrBdwiZ/ska9hPNC2MVw0p43HAnVSlTOJ4+O7qwdwM5IbYFPspKsE1cUvlboEHzCZm
         qcY4ZIATLk36+gKAzCcyWVpRgRSOZFJfxOQBKgKmvVuE5c+VDLibYP8xKEdsYeYFnAP2
         fNUQ==
X-Gm-Message-State: APjAAAUtgjFmKB5/kkLOnYho1NeWCq93urLqM//O5u/D0qVeXa1frMi0
        IUxMHoYiFWqoeZ1DckRQb3C16wIrSbmGfD157e+Kds6RnX9iu7x0DPDrKneOdzknbO7RbxeyLqq
        aIMlIFXJ7shLAg7KR
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr1339859ljc.10.1571923282364;
        Thu, 24 Oct 2019 06:21:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzTkbKGPfYCEvo/cXPu1tP1v+SxyEJBzuGQZ2v+4MNmHQpt+R5XWVeBbQeSwjMdSlLAmFC2MA==
X-Received: by 2002:a2e:6c15:: with SMTP id h21mr1339816ljc.10.1571923281703;
        Thu, 24 Oct 2019 06:21:21 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id b19sm10948284lji.41.2019.10.24.06.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 06:21:21 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 226091804B1; Thu, 24 Oct 2019 15:21:20 +0200 (CEST)
From:   =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     daniel@iogearbox.net, ast@fb.com
Cc:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next] libbpf: Add libbpf_set_log_level() function to adjust logging
Date:   Thu, 24 Oct 2019 15:21:07 +0200
Message-Id: <20191024132107.237336-1-toke@redhat.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the only way to change the logging output of libbpf is to
override the print function with libbpf_set_print(). This is somewhat
cumbersome if one just wants to change the logging level (e.g., to enable
debugging), so add another function that just adjusts the default output
printing by adjusting the filtering of messages.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/lib/bpf/libbpf.c   | 12 +++++++++++-
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index d1c4440a678e..93909d9a423d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -67,10 +67,12 @@
 
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
+static enum libbpf_print_level __libbpf_log_level = LIBBPF_INFO;
+
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
 {
-	if (level == LIBBPF_DEBUG)
+	if (level > __libbpf_log_level)
 		return 0;
 
 	return vfprintf(stderr, format, args);
@@ -86,6 +88,14 @@ libbpf_print_fn_t libbpf_set_print(libbpf_print_fn_t fn)
 	return old_print_fn;
 }
 
+enum libbpf_print_level libbpf_set_log_level(enum libbpf_print_level level)
+{
+	enum libbpf_print_level old_level = __libbpf_log_level;
+
+	__libbpf_log_level = level;
+	return old_level;
+}
+
 __printf(2, 3)
 void libbpf_print(enum libbpf_print_level level, const char *format, ...)
 {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index c63e2ff84abc..0bba6c2259f1 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -58,6 +58,8 @@ typedef int (*libbpf_print_fn_t)(enum libbpf_print_level level,
 				 const char *, va_list ap);
 
 LIBBPF_API libbpf_print_fn_t libbpf_set_print(libbpf_print_fn_t fn);
+LIBBPF_API enum libbpf_print_level
+libbpf_set_log_level(enum libbpf_print_level level);
 
 /* Hide internal to user */
 struct bpf_object;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index d1473ea4d7a5..c3f79418c2be 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -197,4 +197,5 @@ LIBBPF_0.0.6 {
 		bpf_object__open_mem;
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
+		libbpf_set_log_level;
 } LIBBPF_0.0.5;
-- 
2.23.0

