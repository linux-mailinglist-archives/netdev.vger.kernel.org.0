Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4158195271
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfHTATL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:19:11 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:46589 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729160AbfHTATK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:19:10 -0400
Received: by mail-pl1-f202.google.com with SMTP id k9so2939340pls.13
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=y7A0HibhyhfzIREut3Dwuxy8x8kSL4ALtDSq/DvbdZU=;
        b=E6L68QxBaU21/SMLGJjUVxfcqlYeoh9KKiuYntVofw3Je/54Bv5YFbSTgASr+mR0Up
         bRdR94U1mPd4NJbF7fenNctW8EA2R6U5r36ZaVdRqbzVdB805s1Z8hoPo3xgk/bW/FsJ
         XGISHYMqTtZ5pi0dKMfRWUPYNNUk1ZqQm/dCORAvOZmWxh118qjX/XKjLbG7G80zbnIw
         5pvIDjlLJdT1xmoZTAVXRxK/LknQgJgzmfo610NNtIpmiWzgk8yIPwNQ3QASW8Irtw+e
         7Y+74jZkbHXcj5BHnftE099IRg7qujtK3/hCilLV90w5IuGYYe+RYjsvGg1pYHQ8kAZy
         vZwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=y7A0HibhyhfzIREut3Dwuxy8x8kSL4ALtDSq/DvbdZU=;
        b=iwfZmBAdej0MMD/xvIuwOi67nmbmF9+Q++Narwy4EZqvoPZ9aE34LiCDOvzaqZAZg5
         3Wdn89XE4RQ3Tq1O4DlcVn5jhVTvVBVJBETWtwdwN/POgjMxewpTKvAkpVB00/qMqe02
         QyD6jceS0ZFa0PZXVgbidNC+81C3X2pCTzNsLK7dusVLmfYMCstX5UYLikAP2BXoU4qm
         KGzPoa2VhG27NrHVR2YcX3srR5kqnxZBUCV5naEQfYXpGK8Ox0QO4AN3wEZu5fRDfoat
         rD7Ts841JUCxmoQp9PQPHQcF+56nGUw5mX0ehn9sUeUu5HL1zaH4aRQJ+aewnI85Z90F
         jdIQ==
X-Gm-Message-State: APjAAAWSZwrucAXcfsZm9tHLOjE08xNeg+GOGB4qrk/n8P42ino0mKLU
        IaWk6KlcmIA6GVX8x8FhJhc4/jJRWG9dw+LORm9Gkw==
X-Google-Smtp-Source: APXvYqxNgzDjWlK9zVX2D1LRxy26StW0LiS4oj6z0C920gpBqNX5FvSjQfD9J9cmE4lXFk1B8ByAYmM4L1IzFMjpRqlxBg==
X-Received: by 2002:a65:60cd:: with SMTP id r13mr22971318pgv.315.1566260349868;
 Mon, 19 Aug 2019 17:19:09 -0700 (PDT)
Date:   Mon, 19 Aug 2019 17:17:59 -0700
In-Reply-To: <20190820001805.241928-1-matthewgarrett@google.com>
Message-Id: <20190820001805.241928-24-matthewgarrett@google.com>
Mime-Version: 1.0
References: <20190820001805.241928-1-matthewgarrett@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH V40 23/29] bpf: Restrict bpf when kernel lockdown is in
 confidentiality mode
From:   Matthew Garrett <matthewgarrett@google.com>
To:     jmorris@namei.org
Cc:     linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Matthew Garrett <mjg59@google.com>,
        Kees Cook <keescook@chromium.org>, netdev@vger.kernel.org,
        Chun-Yi Lee <jlee@suse.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Howells <dhowells@redhat.com>

bpf_read() and bpf_read_str() could potentially be abused to (eg) allow
private keys in kernel memory to be leaked. Disable them if the kernel
has been locked down in confidentiality mode.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Matthew Garrett <mjg59@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
cc: netdev@vger.kernel.org
cc: Chun-Yi Lee <jlee@suse.com>
cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: James Morris <jmorris@namei.org>
---
 include/linux/security.h     |  1 +
 kernel/trace/bpf_trace.c     | 10 ++++++++++
 security/lockdown/lockdown.c |  1 +
 3 files changed, 12 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 0b2529dbf0f4..e604f4c67f03 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -118,6 +118,7 @@ enum lockdown_reason {
 	LOCKDOWN_INTEGRITY_MAX,
 	LOCKDOWN_KCORE,
 	LOCKDOWN_KPROBES,
+	LOCKDOWN_BPF_READ,
 	LOCKDOWN_CONFIDENTIALITY_MAX,
 };
 
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 1c9a4745e596..33a954c367f3 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -139,8 +139,13 @@ BPF_CALL_3(bpf_probe_read, void *, dst, u32, size, const void *, unsafe_ptr)
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_BPF_READ);
+	if (ret < 0)
+		goto out;
+
 	ret = probe_kernel_read(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
+out:
 		memset(dst, 0, size);
 
 	return ret;
@@ -566,6 +571,10 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_BPF_READ);
+	if (ret < 0)
+		goto out;
+
 	/*
 	 * The strncpy_from_unsafe() call will likely not fill the entire
 	 * buffer, but that's okay in this circumstance as we're probing
@@ -577,6 +586,7 @@ BPF_CALL_3(bpf_probe_read_str, void *, dst, u32, size,
 	 */
 	ret = strncpy_from_unsafe(dst, unsafe_ptr, size);
 	if (unlikely(ret < 0))
+out:
 		memset(dst, 0, size);
 
 	return ret;
diff --git a/security/lockdown/lockdown.c b/security/lockdown/lockdown.c
index 27b2cf51e443..2397772c56bd 100644
--- a/security/lockdown/lockdown.c
+++ b/security/lockdown/lockdown.c
@@ -33,6 +33,7 @@ static char *lockdown_reasons[LOCKDOWN_CONFIDENTIALITY_MAX+1] = {
 	[LOCKDOWN_INTEGRITY_MAX] = "integrity",
 	[LOCKDOWN_KCORE] = "/proc/kcore access",
 	[LOCKDOWN_KPROBES] = "use of kprobes",
+	[LOCKDOWN_BPF_READ] = "use of bpf to read kernel RAM",
 	[LOCKDOWN_CONFIDENTIALITY_MAX] = "confidentiality",
 };
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

