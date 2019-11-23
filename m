Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA080107D36
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 06:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726752AbfKWFwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 00:52:02 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33132 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWFwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 00:52:01 -0500
Received: by mail-pl1-f196.google.com with SMTP id ay6so4134315plb.0;
        Fri, 22 Nov 2019 21:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v4PrA+SOKv4cHaWyIyu3RnovXT8/gc3K8y8DPAIgcqQ=;
        b=GLd+Ge48I4pO6NXO8KcXFx2jIOTcT45blieRnY43S2PqaXSJJkPazQ8rA5b0E4kKDa
         uiqni5mvtS20GYgFpeVp1I5z315z/FQz1yqovn9rGAL0RUcf4ofXXViYWJWVoPmgX2rY
         KwiDZkVXZyZHnZ+RS0etAD7COHiLBudbLQf7MlTQPAIEPpYYh230HP+nyzAEasp4USYV
         Aou5UyFsdqug+rEXEunu8fxTDeg8n1qfxMCWTZH/6nMcaUkYUi7nRJH+r1c/3YV7evUl
         VICZRKR3C0TZsTKkoi+3+NVlpE3OTssM1jIyvksdOHA1Wzz+FRVz8a+qPLgMZsbJcFK+
         WosA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v4PrA+SOKv4cHaWyIyu3RnovXT8/gc3K8y8DPAIgcqQ=;
        b=nnyADKm9JNSgHVJco5D1X/9MOPCt4DjiNMNHqeUWTZaGw8lvtO/wqwsYM3bRG+gWRD
         GdkuhniQENPEVd33b1gDxvjcLjRnqIIyLLyTeWfnyfhGMXvy5uQjLSWepqwSq5ttQjaN
         3OTRhRIyhoDmMcd9/9W8CwxlKJiNQSFXJRCEdtpWIkntcqz23xpFNDdsjVZNMdveztBc
         c3AnYqqwf8m44Tnr86+D5VwNLKd0HjDoCoYjWzvTMyuI6JSnBCsvGMg5lhdkP0bsWsN5
         YhpI56N3AYJ4JavO6uaPm7C4Nb/bqmYE37+cC1HBTfZOAV+9AcjalOoQ82VOEAuvzUxL
         KlYA==
X-Gm-Message-State: APjAAAXQDu8KaxmBFrqNlAFnZFwRYnwIDKgmSn1UsQYECSmrZE2NOE3Q
        Q85LFJzutohCAX+VZTAemQ==
X-Google-Smtp-Source: APXvYqyF0W5bzNAxP/NoIDjfCfkTlCRYrTIPmJwzYJXuQA6RewjsRrYJd1VcR+Hsv3EAvCTkCPiKYg==
X-Received: by 2002:a17:90a:e90:: with SMTP id 16mr23719800pjx.65.1574488320990;
        Fri, 22 Nov 2019 21:52:00 -0800 (PST)
Received: from localhost.localdomain ([211.196.191.92])
        by smtp.gmail.com with ESMTPSA id s22sm738350pjr.5.2019.11.22.21.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2019 21:52:00 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next 1/2] samples: bpf: replace symbol compare of trace_event
Date:   Sat, 23 Nov 2019 14:51:50 +0900
Message-Id: <20191123055151.9990-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191123055151.9990-1-danieltimlee@gmail.com>
References: <20191123055151.9990-1-danieltimlee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously, when this sample is added, commit 1c47910ef8013
("samples/bpf: add perf_event+bpf example"), a symbol 'sys_read' and
'sys_write' has been used without no prefixes. But currently there are
no exact symbols with these under kallsyms and this leads to failure.

This commit changes exact compare to substring compare to keep compatible
with exact symbol or prefixed symbol.

Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
---
 samples/bpf/trace_event_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/samples/bpf/trace_event_user.c b/samples/bpf/trace_event_user.c
index 16a16eadd509..749a50f2f9f3 100644
--- a/samples/bpf/trace_event_user.c
+++ b/samples/bpf/trace_event_user.c
@@ -37,9 +37,9 @@ static void print_ksym(__u64 addr)
 	}
 
 	printf("%s;", sym->name);
-	if (!strcmp(sym->name, "sys_read"))
+	if (!strstr(sym->name, "sys_read"))
 		sys_read_seen = true;
-	else if (!strcmp(sym->name, "sys_write"))
+	else if (!strstr(sym->name, "sys_write"))
 		sys_write_seen = true;
 }
 
-- 
2.24.0

