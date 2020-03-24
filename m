Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E01917D1
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 18:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727697AbgCXRjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 13:39:31 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34373 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727223AbgCXRjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 13:39:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id t3so9396920pgn.1;
        Tue, 24 Mar 2020 10:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=vzoGBdCQrWjbiBxQI1MbFOzqtYhJmJc0P7ozXlXz9qI=;
        b=D613SQE6h7Cw/TSLnVvPAAD97YGFHq6MsQAszfYdOtXXHssa/oLBp5YQCF2PiQnHnr
         4JfBNiQMgPJqxE4SkSoEN76HUWOuCJiwrpUuR8wh9M0Dg0spD878Res/CK+Q2ARv+cym
         V52waf6yQHfcQoXAUifeE9Yrfsl98wAuLPSINYbtnXK2hJEV3ROom2IOctyZcSlmFv30
         OyTB6vT7xPQjDIG89oblYENUAUldLWFI+/q3Vizkm1YhTcdo3u0doaksZEvM5teKHZ3A
         nZSAmGY/54qchKVd2HQbhJ3+g1oHQxAcxC75L7HuYAsYJ+D6DCT+BnWf1RLu5OVjm1zH
         LRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=vzoGBdCQrWjbiBxQI1MbFOzqtYhJmJc0P7ozXlXz9qI=;
        b=t3hFsjGZGq7RnD0TVk/xmCBRZRxB/NTgS3bE8+suUxCCDroxsilmGq7ahhZ5WDdMWm
         pnBf9n7nSM53YMfZ2YgDBcAxXeY8emNsIlhLeQHEXzAQlo34pzIt7lA1AV7PnSkh5AMW
         IeJDH9KKxEFW7vkK44UUbC6KdF8h674HuVJHypBr6wKj0+KnA9eLGXOkhNsECd2PS2SB
         I5wwV1vRJUxYeMPoO6NxY9XK0bf5fMTdBIQcaz+PWISUBSV7ZL/U+OYtqKwuJNVN2tUQ
         wSmV/SoH+wsZFfOCBD5P14KR8gpiHlNz5R8WLEffgUPIsbixH+OLALmhqyXueHW9uep7
         ggzg==
X-Gm-Message-State: ANhLgQ2uVo4C5+a2QLRZRoQ3IoZAz2XEQ/z+pgHNtl0kE2L9Ng3mSWEN
        mJMCFcy9WX/46XtB8TF7RdI=
X-Google-Smtp-Source: ADFU+vv+MY6NBAIiW2RtGB/J/MW8LwgTbsvqVKhBWuImsJmomCVSPMpNm316aCx+PmH2IhOgJRwT7Q==
X-Received: by 2002:a63:f447:: with SMTP id p7mr28447554pgk.326.1585071569892;
        Tue, 24 Mar 2020 10:39:29 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y131sm16657505pfg.25.2020.03.24.10.39.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 10:39:29 -0700 (PDT)
Subject: [bpf-next PATCH 05/10] bpf: verifier,
 return value is an int in do_refine_retval_range
From:   John Fastabend <john.fastabend@gmail.com>
To:     ecree@solarflare.com, yhs@fb.com, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        john.fastabend@gmail.com
Date:   Tue, 24 Mar 2020 10:39:16 -0700
Message-ID: <158507155667.15666.4189866174878249746.stgit@john-Precision-5820-Tower>
In-Reply-To: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
References: <158507130343.15666.8018068546764556975.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark 32-bit subreg region with max value because do_refine_retval_range()
catches functions with int return type (We will assume here that int is
a 32-bit type). Marking 64-bit region could be dangerous if upper bits
are not zero which could be possible.

Two reasons to pull this out of original patch. First it makes the original
fix impossible to backport. And second I've not seen this as being problematic
in practice unlike the other case.

Fixes: 849fa50662fbc ("bpf/verifier: refine retval R0 state for bpf_get_stack helper")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6372fa4..3731109 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4328,7 +4328,7 @@ static void do_refine_retval_range(struct bpf_reg_state *regs, int ret_type,
 	     func_id != BPF_FUNC_probe_read_str))
 		return;
 
-	ret_reg->smax_value = meta->msize_max_value;
+	ret_reg->s32_max_value = meta->msize_max_value;
 	__reg_deduce_bounds(ret_reg);
 	__reg_bound_offset(ret_reg);
 	__update_reg_bounds(ret_reg);

