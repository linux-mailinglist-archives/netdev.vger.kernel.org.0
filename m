Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6DDF113CB6
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 09:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbfLEIB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 03:01:26 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:36449 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726007AbfLEIBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 03:01:25 -0500
Received: by mail-pj1-f65.google.com with SMTP id n96so973717pjc.3;
        Thu, 05 Dec 2019 00:01:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5SmfLXA2j9dmElnAXf7Lf2Iqlec7nI/vhFa9+GlzqLI=;
        b=KFHlesfeTRB/+vTvBm6n/PSwnJ5gz/ngzviPxNU9FJdzBev/IOctlkuQo0ZALi6N4n
         tDb6wVC8j6EyxyVzV5vi1Ft6T8qJT/694G7ZJRoeox7HapdLQIq6qnooRJVFiZXHAkgV
         HN/5IKrPUATIwx/IlAorG0JX0qc3cO2wHbXv1PspFYWDy29HK1gPp7CDk6byn/XJ5Fmm
         WhtV01QJJY4JpIAEUkvzAh5dldiuM/pWM6s9IRTx1EIpIsFy/GyHB8i6Go88AfmXJV1i
         R87yn49sSHQNz6g1iEtent0I0iBxBbzPsrnFVMsrRkhPvamY3JQjgdCnaGVNpc4MhYxi
         OFQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5SmfLXA2j9dmElnAXf7Lf2Iqlec7nI/vhFa9+GlzqLI=;
        b=lFnIVA/YXKoDjbfANjopvGtc4TjNTtIhtnFBCLNrLInzaliROQV61dTe51D1HGU/iD
         lFAz8vO/8J9DJ/5tnapnzClj2mvVxGAXTkFDPMTvIUrzhkedIk553W7jRW8/OACHWC9C
         br13MTzF+M5/8Mpu7Omnq0Yuq8k3JRg27fw5DZW9RXThJ6WD1x8PLga5IeNNlSG29M4+
         kTLwWn70IjNcQcyvsyFBuda+4jUfGZHTOwfJncRXZ3uAwcf7b/s4XBvXfmHjoeXhYCup
         Bryp2+uelEgh37mXzYCEtQm+lRcFSwE7CZ/f/1YlAEvIznlT5/teitq6X7lxy92qMHsU
         dJZw==
X-Gm-Message-State: APjAAAU7K3I6O5mZEkdNf9qADsxCQrKv8PzRrD48y7YbLeyP4WmNVjQg
        nlZZAmnw10pkK2WGiSNvCg==
X-Google-Smtp-Source: APXvYqwpcDYDSHhpkc1jF9WRhm48MwwDYwKV4bGvmE/XG1xLOTglkUfXAxME5mXuXVmGJd3zEpUERg==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr7819707pjb.89.1575532884013;
        Thu, 05 Dec 2019 00:01:24 -0800 (PST)
Received: from localhost.localdomain ([114.71.48.24])
        by smtp.gmail.com with ESMTPSA id 129sm11510739pfw.71.2019.12.05.00.01.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 00:01:23 -0800 (PST)
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH,bpf-next v2 1/2] samples: bpf: replace symbol compare of trace_event
Date:   Thu,  5 Dec 2019 17:01:13 +0900
Message-Id: <20191205080114.19766-2-danieltimlee@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191205080114.19766-1-danieltimlee@gmail.com>
References: <20191205080114.19766-1-danieltimlee@gmail.com>
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

Fixes: 1c47910ef8013 ("samples/bpf: add perf_event+bpf example")
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

