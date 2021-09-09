Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF98A405983
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349098AbhIIOqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345073AbhIIOqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:03 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D45C05BD30
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:23 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i6so2971337edu.1
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XfMLrua0MdTHFZoz901/cpqoFG6QjfNV3NlQ/D/QR3U=;
        b=0KPvJhRv5+Q9Wa/mLPFEkj4+tuCNRTUVOUirnNXJlnQMttNlVuITyduMTRoCad2hcw
         Wc+nUahSElbfLJxOE7eDRiRaG83GpaQPkhpHmxvLP9E7Hydaw1JLkVll7FXJqt13EQgo
         uyChnh498a49Z5dGheT8R5ZrMWqYbmP7MX9jMv9S3l8emKNl9WJ4dPfYA4iGUjX6d441
         p3lFAJwknXRB3CazY7jOVBlf4KEtazQJRTJbOD2vef8CLExn+trCV3yeX1Qk7GBLqjA4
         /3XCzaAONP6Zc6zkGhG0N45nXh8K5aYDRqD4IueFKQS9+9dfY8RYP2ejU+UUY1ds9ODc
         PViw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfMLrua0MdTHFZoz901/cpqoFG6QjfNV3NlQ/D/QR3U=;
        b=ZuqtLadZmVvM8OTzMwZS6dxshoQDrehS33qJJ6AJeQh5ULNtc6Ix4WA5Yw++472Tc3
         Y44d55YZcKhC+JoJPCHyPxY3aiwbPUbv3SN+53mfhj75SJurS3MzAZBX+FTpVq98QY9g
         NhVgfaodiUIToP4epCvWjCRNOB2Wsmaeh5x3o6z4EbE1/5m1vttjCpkGEiHuqPbfuaPv
         NOCcl4fH9KN/ATo6+uVqgCSyqYlgeCakpL1c3Twyg/n4ppRFwDejtOWIR4drTTBBMdiM
         +VtxVWl0XaYnMXy4k72b4PZ3/JdcB/CjjUpsgiJxkCubHr9MFjEcPCg6jigbFjhHhINT
         WeHg==
X-Gm-Message-State: AOAM533X82VrTHYw9yw8zLl9quGwAsaKhZT4Mv94e5WCVLpPBy7h6bCr
        2MLiDYidb/MvVX2uQZAhDmFJpw==
X-Google-Smtp-Source: ABdhPJyGTRQVFnswNEwqITlB1YkEkuKin0eZC2VnQvU7840ZuslIUG5mt6HaPbuDSq3SeRoqk11rTA==
X-Received: by 2002:aa7:c744:: with SMTP id c4mr3577741eds.0.1631198001581;
        Thu, 09 Sep 2021 07:33:21 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:21 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 08/13] bpf/tests: Add test case flag for verifier zero-extension
Date:   Thu,  9 Sep 2021 16:32:58 +0200
Message-Id: <20210909143303.811171-9-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new flag to indicate that the verified did insert
zero-extensions, even though the verifier is not being run for any
of the tests.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 6a04447171c7..26f7c244c78a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -52,6 +52,7 @@
 #define FLAG_NO_DATA		BIT(0)
 #define FLAG_EXPECTED_FAIL	BIT(1)
 #define FLAG_SKB_FRAG		BIT(2)
+#define FLAG_VERIFIER_ZEXT	BIT(3)
 
 enum {
 	CLASSIC  = BIT(6),	/* Old BPF instructions only. */
@@ -11280,6 +11281,8 @@ static struct bpf_prog *generate_filter(int which, int *err)
 		fp->type = BPF_PROG_TYPE_SOCKET_FILTER;
 		memcpy(fp->insnsi, fptr, fp->len * sizeof(struct bpf_insn));
 		fp->aux->stack_depth = tests[which].stack_depth;
+		fp->aux->verifier_zext = !!(tests[which].aux &
+					    FLAG_VERIFIER_ZEXT);
 
 		/* We cannot error here as we don't need type compatibility
 		 * checks.
-- 
2.30.2

