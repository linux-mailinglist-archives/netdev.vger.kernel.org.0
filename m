Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CA34234FA
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 02:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237149AbhJFAbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 20:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237086AbhJFAbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Oct 2021 20:31:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91D2C061749;
        Tue,  5 Oct 2021 17:29:14 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h1so859033pfv.12;
        Tue, 05 Oct 2021 17:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mO8eLvTvx7uyO48zoyP55mESCJ3tJ4Kie0/HPIIxwyg=;
        b=iGnWmTa44eJeXi9HPgNbokxxNV9dFqcdJ+HZ0wDpABr7YcoQYsGMaeK6NHHTFQbKXO
         LJseX/qX/t+q9nOkDM3raKstiSbBXhBIE1GKmHS8Q+DbByxuyNkPvDZDZ+xVn89E3Kii
         nvlYE2VSQZj7lQWdxMp9lU01wgn0mV1RZBF8NBFrJayvtjloWBX7BWyRtIm0sSMdVNCg
         Z43LcGHuInFo0j30FCmgkVJGf8ftxcuGI/rAYI2vEc1ZM4DxVfOndQ+FKA95LuPZS8hl
         oADO01uBPny3GXriDfcjpUOTTk+1wWh3Tlc3YkPpX/ZXGg+VgD3pxGfGUzw1VaCuDxF/
         o3AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mO8eLvTvx7uyO48zoyP55mESCJ3tJ4Kie0/HPIIxwyg=;
        b=QCxQZc24m/CkB5mdfcl/lWntjhGS5+PIT5EvR9c+usNs9icylE7nUXa6wKDdOL9+WH
         gNCd0xNKVHAZVC/EvjAnjKMCOXASK7aFsSeX1cuV+n2H3SZHUrOE/2I02Q0tpKMbXyBh
         KHTWV5p44Lc3bm8rIeD6hKJDKMFCRSPYb3ENIXZrtaCAH2xI24Voct7CkvSWAXHDE5cl
         /3YzaYIi1I41fyJi4tSw7TrBD7I6qhtAcLcmCPRRKDr8cLA1IcqhqkBrKjbLcOmd7FKC
         5JvNCA/fCccwDaGAutups44qsQBDDrwDw6VDEdpR1/YkXQ/N+MBaTe6RvqHy8PmNpw38
         e5bQ==
X-Gm-Message-State: AOAM533Suw/zxI6DyDHzJymp9sdeNpqyddY0NlDzHVSItOES4ZPEnBe+
        +txL7p5G0T0y6vfPXy4BmBldZgfL738=
X-Google-Smtp-Source: ABdhPJzjj1yOe+0NeHxesrweh0xp2G9MEAvOosO9U4jsdedoNFeGmDqFT2E9OHkTP8DF1csPrmmQtQ==
X-Received: by 2002:a65:6648:: with SMTP id z8mr18400234pgv.418.1633480154120;
        Tue, 05 Oct 2021 17:29:14 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j6sm18142623pgq.0.2021.10.05.17.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 17:29:13 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v1 6/6] bpf: selftests: Fix memory leak in test_ima
Date:   Wed,  6 Oct 2021 05:58:53 +0530
Message-Id: <20211006002853.308945-7-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006002853.308945-1-memxor@gmail.com>
References: <20211006002853.308945-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1115; h=from:subject; bh=4bfzhM+sYcTW2y2zdsHJx5N2vzbm4oaFQaoGmKSXTic=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhXOxQgI5e86LHo+jVOJkUuF0P4byE+Xxfe3jR9uE9 WjZQteGJAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYVzsUAAKCRBM4MiGSL8RynvrEA C0Powb1Gh+WDgwv+3rhP5DMBEFGdnK06lC6288bG4XXpDc95ESMY9HptZU36gkLigpKvnv6phTYgg3 0alu9cfQv2iS0b+3lqMGaQ6WxLvtn52BM0DXy4oMFnfOlToOdc0I54RVFl7hcOd1FsDbzSYBmFvoLr KBBO5dAqjevxlWAx/Xq1saaFCrpf0f34LXWeXvVK+Gmuo4+OYfN34ei1lBQ2i1sHxpxprlH88QzCGS ZMEUQNxBPDScvVKPv44IyGYEAtca9SvauMD2gdByGkFvDQ2//F43aV9gU7OOz19vQE8YOBV57sxb1W DTUFx5gefvGcxjO63V/y9UsKnduRrNbvMUIqGPaPEUxvoCIt75seB8KmQ4crFI2XNlhGMRX1/1NMOp 7OwLMc8z1CxgPuGpeHVNa9ftbaB6tmeNFPB3xVlXcfYEzpunY7K/MfW3zRSKQphsrUY/eoy5Kv+gKj AmxVhF/kgdyWQ1t0S6B21dVQ2iVMMgVqt2Fo3uHcVt2WREIiO0rrd4xfxQPapEXgoQ7aQs4X0ENdaD 4/2sqChoj3lCpkhckk9S9wjokyRgCu6zah3ZzfgSbK0xLwC6/kxLM5lVVDX90cQo1Vl7RZl1IrcWPe ilrZ3OVA9FfIxoGP4e1HU47CQcomDhW38rQ+GKkewmn9eEiBDQ2dNX5MBfrg==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The allocated ring buffer is never freed, do so in the cleanup path.

Fixes: f446b570ac7e (bpf/selftests: Update the IMA test to use BPF ring buffer)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
---
 tools/testing/selftests/bpf/prog_tests/test_ima.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/test_ima.c b/tools/testing/selftests/bpf/prog_tests/test_ima.c
index 0252f61d611a..97d8a6f84f4a 100644
--- a/tools/testing/selftests/bpf/prog_tests/test_ima.c
+++ b/tools/testing/selftests/bpf/prog_tests/test_ima.c
@@ -43,7 +43,7 @@ static int process_sample(void *ctx, void *data, size_t len)
 void test_test_ima(void)
 {
 	char measured_dir_template[] = "/tmp/ima_measuredXXXXXX";
-	struct ring_buffer *ringbuf;
+	struct ring_buffer *ringbuf = NULL;
 	const char *measured_dir;
 	char cmd[256];
 
@@ -85,5 +85,6 @@ void test_test_ima(void)
 	err = system(cmd);
 	CHECK(err, "failed to run command", "%s, errno = %d\n", cmd, errno);
 close_prog:
+	ring_buffer__free(ringbuf);
 	ima__destroy(skel);
 }
-- 
2.33.0

