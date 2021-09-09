Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CED405971
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 16:45:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348373AbhIIOqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 10:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345399AbhIIOqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 10:46:00 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96AFC05BD21
        for <netdev@vger.kernel.org>; Thu,  9 Sep 2021 07:33:15 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id i6so2970784edu.1
        for <netdev@vger.kernel.org>; Thu, 09 Sep 2021 07:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=anyfinetworks-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0lLX1fHB6jaPieI1cPC3xc4QwmyAR0d5okYwLH3KQR4=;
        b=UvVXDxmVAAYtwyy50O5wnJ0yiaRnTlTH3e47uMPDrUH2Vpi35L648ZnRqYVbilqN1I
         mfK/bftrPEE1VoKwHMoxhh6pKJ1pQkphQjRJbwzrTBZJ84fq5Y0nqFCIgZ+dYUuMaook
         Mc8kuSHYdLpvt1mlZjI3jPXD6VRhYh9xOGM3zYPodnRYDR6Oy1n+XIkMIFXt+b+SS4+s
         wcvW02XKWtNOOB1sUq7/qB4R3l0aIdTKyOn9q0ygaiYswC1fTvzAfkytqL236sD4Jvjv
         pLQfPplaGwXyCdwjBrSOD6SlGuUSvyiAZVUJpV1V6jHdbaMGUSM48qQCHjn8ULwKxUf8
         nCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0lLX1fHB6jaPieI1cPC3xc4QwmyAR0d5okYwLH3KQR4=;
        b=KkDrQi9E28GFc6EoSuW2bvhEx2km9U/t5iYxm8/v12crdmpewBipbz9Js5YxbpyKQM
         qqSfsDKe1ZSmUvccxhWZimRLWduZloPde4GIbHcm0Lk0/wH1S9/sWGtjmyXrZfEYds2n
         ybojpb5qnMVz+BkkJDFuR4WcmGh2NhkQ2QCRVojtsrEyu3DF7v3HtTVlgnjgH2AeyeBN
         u7exakPy3EhepgS+ojt8mLQdiEalelaY33kkDERZy+Ybz//tJNzx3IDYDBMCMl9L90zN
         vi3EGxjrhDWnAb8m1WsQhvTb/a0qdo4EA8TZGEMyr3Vh+aZKNvw7qeQDGDV2RbI2BJX2
         w9IA==
X-Gm-Message-State: AOAM5306oXkhP42u5Xp6RLBZfpkFOpwr76lORR30cn6Ts8nF5dXT3ft1
        ayNcJ5S4lm1oPjds0r8i34jE6Q==
X-Google-Smtp-Source: ABdhPJw+hPuz4JOi3hxHCzdmpA77dd0NfQTj4eFlg5fQng/AuOZWp6nMEwYedQTB4X0U+oPoOq5Isg==
X-Received: by 2002:a50:9e8b:: with SMTP id a11mr3440117edf.126.1631197994405;
        Thu, 09 Sep 2021 07:33:14 -0700 (PDT)
Received: from anpc2.lan (static-213-115-136-2.sme.telenor.se. [213.115.136.2])
        by smtp.gmail.com with ESMTPSA id bj10sm1030909ejb.17.2021.09.09.07.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 07:33:14 -0700 (PDT)
From:   Johan Almbladh <johan.almbladh@anyfinetworks.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, iii@linux.ibm.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>
Subject: [PATCH bpf-next v3 01/13] bpf/tests: Allow different number of runs per test case
Date:   Thu,  9 Sep 2021 16:32:51 +0200
Message-Id: <20210909143303.811171-2-johan.almbladh@anyfinetworks.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
References: <20210909143303.811171-1-johan.almbladh@anyfinetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch allows a test cast to specify the number of runs to use. For
compatibility with existing test case definitions, the default value 0
is interpreted as MAX_TESTRUNS.

A reduced number of runs is useful for complex test programs where 1000
runs may take a very long time. Instead of reducing what is tested, one
can instead reduce the number of times the test is run.

Signed-off-by: Johan Almbladh <johan.almbladh@anyfinetworks.com>
---
 lib/test_bpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/lib/test_bpf.c b/lib/test_bpf.c
index 830a18ecffc8..c8bd3e9ab10a 100644
--- a/lib/test_bpf.c
+++ b/lib/test_bpf.c
@@ -80,6 +80,7 @@ struct bpf_test {
 	int expected_errcode; /* used when FLAG_EXPECTED_FAIL is set in the aux */
 	__u8 frag_data[MAX_DATA];
 	int stack_depth; /* for eBPF only, since tests don't call verifier */
+	int nr_testruns; /* Custom run count, defaults to MAX_TESTRUNS if 0 */
 };
 
 /* Large test cases need separate allocation and fill handler. */
@@ -8631,6 +8632,9 @@ static int run_one(const struct bpf_prog *fp, struct bpf_test *test)
 {
 	int err_cnt = 0, i, runs = MAX_TESTRUNS;
 
+	if (test->nr_testruns)
+		runs = min(test->nr_testruns, MAX_TESTRUNS);
+
 	for (i = 0; i < MAX_SUBTESTS; i++) {
 		void *data;
 		u64 duration;
-- 
2.30.2

