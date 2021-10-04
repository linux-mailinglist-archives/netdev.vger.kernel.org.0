Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC634208B8
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 11:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhJDJvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 05:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhJDJvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 05:51:03 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3CFC0613EC;
        Mon,  4 Oct 2021 02:49:13 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so2309547pjc.3;
        Mon, 04 Oct 2021 02:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CbD5H0SjWeX2L+M3qQ4l6zqxKZW9almMsshRo50UrIM=;
        b=kMlXmwhQXcfNiWO56HSeC3Dbt/8hCBG5CdTRin8XsOyIfSfqOr3GJL3irsvitubaxK
         sxZlYjrrmjVgxkBSgQ39R30nlb239c+7qGUZj/ylSsZvWyb97cfpiKhrAgMxvf0x09Zm
         nvqEaWJ2idOWcxwqExU/wDGbQ5Ip4jRr9tFl/2jkmYvYUnHV0Jfb5p86vX5sAG9ICc1c
         dSt7RjL3fTywfIRCd4vRaSLD897fxcx6hxzRr9NHvKcpCy3wdpfnziIHifRNVH26Te2C
         II0tV8vhEhY/n4MwdOtIU1b/QB7pGEmdmqMV0i02bXOVAdpshx4TYEW6XQ7m1T2nTd/h
         adDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CbD5H0SjWeX2L+M3qQ4l6zqxKZW9almMsshRo50UrIM=;
        b=xBNn59fZ0REtaQMWrfTbOM/9XrEE+H7fQAGHNuXMGePt54nTwT20LkQfGW+F2K8+wr
         0zfCPxXYH9cbxyNhHLb5xFHiL1ZSclAAPzSO0JKAaVX22xbvwpgJkT3pHaLzX2zGSxkz
         O5RMpoHPxpzycMe7d2wFzKidB5+jSzYAeqM/lRQmSKDxOukvtMddLZjZNo9Dowgwp6R6
         jj7yY1mtv2ZuP/SHoEx9IcSK0cpd/Pp0sqzuLBffVo28IAs083Am8ip3RmbrtKvW8Mkc
         guHFwg5cHQPeTyr6lI60eyp5C4Mw+XWAj2QFF1IcEiDig9dd7dNmyEgphjWNAALnkpqe
         6sSQ==
X-Gm-Message-State: AOAM532SpuycpITAky87sJgKaoJYqVPNfWtCTYPitLPVysRp9Hy7teLF
        dUyaExH3IecIebYDIVtyBgRuGyUgXKMoMw==
X-Google-Smtp-Source: ABdhPJzp6SIrZFjNga3UEQqnM14j3DcnoW7tKvaRr++cpm0aUXoqtiMfYvPR9QZ+jVZBvPB9Zc92ZA==
X-Received: by 2002:a17:90a:304:: with SMTP id 4mr35414400pje.124.1633340953530;
        Mon, 04 Oct 2021 02:49:13 -0700 (PDT)
Received: from localhost ([27.102.113.79])
        by smtp.gmail.com with ESMTPSA id t33sm8153628pfg.42.2021.10.04.02.49.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 02:49:12 -0700 (PDT)
From:   Hou Tao <hotforest@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Ingo Molnar <mingo@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, houtao1@huawei.com
Subject: [PATCH bpf-next v5 2/3] libbpf: support detecting and attaching of writable tracepoint program
Date:   Mon,  4 Oct 2021 17:48:56 +0800
Message-Id: <20211004094857.30868-3-hotforest@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211004094857.30868-1-hotforest@gmail.com>
References: <20211004094857.30868-1-hotforest@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hou Tao <houtao1@huawei.com>

Program on writable tracepoint is BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
but its attachment is the same as BPF_PROG_TYPE_RAW_TRACEPOINT.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 tools/lib/bpf/libbpf.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e23f1b6b9402..25a01ad894c4 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -8029,6 +8029,8 @@ static const struct bpf_sec_def section_defs[] = {
 	SEC_DEF("tp/",			TRACEPOINT, 0, SEC_NONE, attach_tp),
 	SEC_DEF("raw_tracepoint/",	RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
 	SEC_DEF("raw_tp/",		RAW_TRACEPOINT, 0, SEC_NONE, attach_raw_tp),
+	SEC_DEF("raw_tracepoint.w/",	RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
+	SEC_DEF("raw_tp.w/",		RAW_TRACEPOINT_WRITABLE, 0, SEC_NONE, attach_raw_tp),
 	SEC_DEF("tp_btf/",		TRACING, BPF_TRACE_RAW_TP, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("fentry/",		TRACING, BPF_TRACE_FENTRY, SEC_ATTACH_BTF, attach_trace),
 	SEC_DEF("fmod_ret/",		TRACING, BPF_MODIFY_RETURN, SEC_ATTACH_BTF, attach_trace),
@@ -9786,12 +9788,26 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(const struct bpf_program *pr
 
 static struct bpf_link *attach_raw_tp(const struct bpf_program *prog, long cookie)
 {
-	const char *tp_name;
+	static const char *const prefixes[] = {
+		"raw_tp/",
+		"raw_tracepoint/",
+		"raw_tp.w/",
+		"raw_tracepoint.w/",
+	};
+	size_t i;
+	const char *tp_name = NULL;
 
-	if (str_has_pfx(prog->sec_name, "raw_tp/"))
-		tp_name = prog->sec_name + sizeof("raw_tp/") - 1;
-	else
-		tp_name = prog->sec_name + sizeof("raw_tracepoint/") - 1;
+	for (i = 0; i < ARRAY_SIZE(prefixes); i++) {
+		if (str_has_pfx(prog->sec_name, prefixes[i])) {
+			tp_name = prog->sec_name + strlen(prefixes[i]);
+			break;
+		}
+	}
+	if (!tp_name) {
+		pr_warn("prog '%s': invalid section name '%s'\n",
+			prog->name, prog->sec_name);
+		return libbpf_err_ptr(-EINVAL);
+	}
 
 	return bpf_program__attach_raw_tracepoint(prog, tp_name);
 }
-- 
2.20.1

