Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18EA04089D1
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 13:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239453AbhIMLEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 07:04:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239457AbhIMLEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 07:04:16 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51B0BC061574;
        Mon, 13 Sep 2021 04:03:01 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j1so5995674pjv.3;
        Mon, 13 Sep 2021 04:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8tTQhFrsWRNkUOBaOJA02WxHmquMo9+cmq045OwmYJU=;
        b=gh9X42uMlMHDFUWjUxSJCtekAQOTdQa+bBZcbZz4ISIUbUhtkSmtlUJK9z07cqJsoL
         f1vF7f6uaDfHXzgEEshszcSartet1RpGUl3CBwDHHxcdtSi7/HGmmIjlr/kaQDli2KwN
         U+rBEGlpUUg8X9NQm28/0xcxkRJb9+sfiS3BssvRPl1DgR9zSkvay7X8ltnoqb+wjzN6
         ynTcntFHIsWsWGFIRLhdrkxrg6RLZbyYHOT6m6tXkV+fXkwBp4pKfZJ1xYdT5x9S2wDo
         ie9lFUijdRA8UuFqe+0MyjP5AUAITPtSaF7Mxwf8hYuANblmZ98yl2Ieymck4GIMhlTO
         G4tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8tTQhFrsWRNkUOBaOJA02WxHmquMo9+cmq045OwmYJU=;
        b=w1FBpvsiNqW86aeRyOrQfpA47d4g1b830QSZLsM2Ety/iZctQMGv5LnLkWiLUNZ10U
         6sYu87MBv9jOls6EM1X2jPXMquU5URj8jXYCWQXCQ4PS8g/oNWnRzZPB4ZVFp/6ysSJX
         foFVDRTqV78yn4FjBVoKoZRc/xT16e+bfmC0Rgsrq7UDruphtWl/0OuIb629AZt+5s3C
         pntjPj9SWtfCF+muJGeirD06Zk/KaJBCumJ4PWf+1hwC8G0qpUD328oHE+Bihq9KnBVT
         kTRGZddf9bf+gbq02asiOvW5gu1V2xVEnyq4UJL+iLAkzVzdqE5ezDyjFAPeNMR9ECV1
         MehQ==
X-Gm-Message-State: AOAM533CBhgAzG3Q926D2jbLfvyxWBYI6VULlzPCAZPMZKqNCg6CRWhX
        n5ku402f9qadXtSxgrSHcuE=
X-Google-Smtp-Source: ABdhPJy3i8ua/fVQObcDsf9vLhNLgbuzOgUx8Z4B+IA0ShClO9iHfm+Fa1+5MahosqjqZJ7T7aYD2g==
X-Received: by 2002:a17:90a:ce84:: with SMTP id g4mr6604700pju.147.1631530980835;
        Mon, 13 Sep 2021 04:03:00 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.28])
        by smtp.gmail.com with ESMTPSA id gn11sm6480860pjb.39.2021.09.13.04.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 04:03:00 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Willy Tarreau <w@1wt.eu>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: fix kmalloc bug in bpf_check
Date:   Mon, 13 Sep 2021 19:02:46 +0800
Message-Id: <20210913110246.2955737-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 7661809d493b ("mm: don't allow oversized kvmalloc() calls
") does not allow oversized kvmalloc, it triggers a kmalloc bug warning
at bpf_check.

Fix it by adding a sanity check in th check_btf_line.

Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
Fixes: 7661809d493b ("mm: don't allow oversized kvmalloc() calls")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 047ac4b4703b..3c5a79f78bc5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9913,6 +9913,9 @@ static int check_btf_line(struct bpf_verifier_env *env,
 	if (!nr_linfo)
 		return 0;
 
+	if (nr_linfo > INT_MAX/sizeof(struct bpf_line_info))
+		return -EINVAL;
+
 	rec_size = attr->line_info_rec_size;
 	if (rec_size < MIN_BPF_LINEINFO_SIZE ||
 	    rec_size > MAX_LINEINFO_REC_SIZE ||
-- 
2.25.1

