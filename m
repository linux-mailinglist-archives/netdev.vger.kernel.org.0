Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67C2B4116A8
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 16:16:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbhITORp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 10:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240074AbhITOR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 10:17:29 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0436C061767;
        Mon, 20 Sep 2021 07:16:00 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id w19so16307262pfn.12;
        Mon, 20 Sep 2021 07:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JEoGrDkWbNbm7f7hgUxBaYzaSXmo3n5r7w/q8QLAfZA=;
        b=lWrt821KvYmdQ2e7DLU6hwhCF9d7LlQOSQjgyIP9t5bfZ7gn9wLISpZMtvtqgcRyym
         tcnbYEf8J9Bo6vgwqtidJpCBKyHmuKp+uUQW7y+lpuADI/dpXtLHaxkiR8u1WkF6ydUS
         2lYCJv1if+EqEHHtfc251qRCCaPAzkrZnUOrk9I2CACPaJoS7U8XLAEvdDdZuvzoYF8/
         i41aBz28ftN4Fwlg3mYfbvVvF4s8GmZRNOHf6R3Nx3IgPEdjauzkNqHxXy5TYe05GAq5
         PTKIJrWIQPgNwvhY7tpUjv4jROjUuOu5TRct7bhJO3QloWOddE2f2SxkZ70sg3Brkrf/
         hUQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JEoGrDkWbNbm7f7hgUxBaYzaSXmo3n5r7w/q8QLAfZA=;
        b=ven1qX1hPkZYlRnE+sBnYrNfeXUG43qlL2dxA5ROSwSpTvxtJ2EDrFn4p6fBtQOqtB
         3ZqbGWhU/lUatg/DoM75eDw7pbBGZ5Mz/Q8xyBgqzQcyzEVpI1fb6L5atyvYN7STRt6t
         6cDProlHuD/OragdWAQe02KUV8GryHRnb/zVruAzWkFrcQmpvJ2TdxZMsMdBISbbkWrl
         eFE1VdWcMZDlBPawN6hNnRzR2o+ke2luqOV0KRakzTUfcK0f6PjLj+ElKTsG2Oym62xx
         ryixvQPE759aqnRx+B2BVlVFDX0cDohRpgn+uon1f5ldv+GonU/ziaw5mdmTo1NHNhEq
         9hCA==
X-Gm-Message-State: AOAM533+FapMU2xWdSHpqqsxClNsROO4lWVhzPfxyrB/jK7h7blpeEnk
        f52IyQVsEKhvuHwMW00VQ1shis7D1MAp+w==
X-Google-Smtp-Source: ABdhPJxT+Sh2kVFIxZSwAVAv2O7CepLT2VCcOBuaM1xlPY9Eu5rSEk5UELXe9RoDQJiOejTVbvo/og==
X-Received: by 2002:a63:2d07:: with SMTP id t7mr23886374pgt.101.1632147359841;
        Mon, 20 Sep 2021 07:15:59 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id b129sm12963642pfg.157.2021.09.20.07.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:15:59 -0700 (PDT)
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 09/11] tools: bpftool: Add separate fd_array map support for light skeleton
Date:   Mon, 20 Sep 2021 19:45:24 +0530
Message-Id: <20210920141526.3940002-10-memxor@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920141526.3940002-1-memxor@gmail.com>
References: <20210920141526.3940002-1-memxor@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1310; h=from:subject; bh=2Sp/0Ej9RChgmna89RwHMC6AwnAZ35ulV5rtInB+ISw=; b=owEBbQKS/ZANAwAIAUzgyIZIvxHKAcsmYgBhSJaEFPw5EfsYGk37EJe1dUaupisaiklHdr1Iuyf9 TN6c3f+JAjMEAAEIAB0WIQRLvip+Buz51YI8YRFM4MiGSL8RygUCYUiWhAAKCRBM4MiGSL8Ryg3QEA CNNc4LHNrz99hisn3dVA+xSbblcqRI4D9ydytO/8LBPwQp+y/Su6rrCAe2pRW975aRzKjlgKdQfEyu QY8v8xSmWON41L9g+/dqV7Fgn4yY/7qBn0j+Br6x0Q0h3W0tWgGHvjyKXNutBVDSlC2nibIjcsSoMy iU+g3kACYBtvBszUwJ1hZnOtRslDsWsylE1Gzb2LfvtspP7KUiwt3c638IMLAZFhlGmFjqC4fWq15V rP9d7JDLAli9b7A0oLwHTLlJsc4fsptqOmpaUb3ZFj8Tk1A1rbP+lndYOpk3GTagpL3dkHTT0s9q6a RosV+cH0bO85Ij2QwpEsWgcRgvc57hSETfJo+GHtUZR5RKy6KV4DLF8fiNdUtM4ATjukqBfsjfHK7T jVWgNIZd36UMycsaZLre4+LJo6G2otcrchXX9ca9bls9J7hWbDfMW1/A2P6nTHVdUFuKfgYKR5GCyo LZvmBVhKGOvUEoQjAlnfOavwL9ETxoWEWnCQcrNolq0PKJzavCFxVyI2+wquEoau4AjCxys6bDKW9Z IIJmGqd8bA50c4SX49H+Vq3ic4z0j0UVI1fBC16jqXA47aIgqweOHJIEzWJAbgmRnp7C9/qGFYfH+i HnXdlRE79J0vCkFfKDtn/PMzv2Ni4Bdcc/y0sKt/nKmP/vtCatDoDHnQ+zKQ==
X-Developer-Key: i=memxor@gmail.com; a=openpgp; fpr=4BBE2A7E06ECF9D5823C61114CE0C88648BF11CA
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This prepares bpftool to pass fd_array_sz parameter, so that the map can
be created by bpf_load_and_run function to hold map and BTF fds.
---
 tools/bpf/bpftool/gen.c  | 3 ++-
 tools/bpf/bpftool/prog.c | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index e3ec47a6a612..5bd3650956a4 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -532,10 +532,11 @@ static int gen_trace(struct bpf_object *obj, const char *obj_name, const char *h
 
 	codegen("\
 		\n\
+			opts.fd_array_sz = %d;				    \n\
 			opts.insns_sz = %d;				    \n\
 			opts.insns = (void *)\"\\			    \n\
 		",
-		opts.insns_sz);
+		opts.fd_array_sz, opts.insns_sz);
 	print_hex(opts.insns, opts.insns_sz);
 	codegen("\
 		\n\
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 9c3e343b7d87..1d6286d727f4 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1693,6 +1693,7 @@ static int try_loader(struct gen_loader_opts *gen)
 	opts.data_sz = gen->data_sz;
 	opts.insns = gen->insns;
 	opts.insns_sz = gen->insns_sz;
+	opts.fd_array_sz = gen->fd_array_sz;
 	fds_before = count_open_fds();
 	err = bpf_load_and_run(&opts);
 	fd_delta = count_open_fds() - fds_before;
-- 
2.33.0

