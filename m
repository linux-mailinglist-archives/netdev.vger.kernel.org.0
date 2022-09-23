Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E80FF5E8420
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiIWUen (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:34:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233066AbiIWUci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECD6130BC8
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:30 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f193so1308470pgc.0
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=lIp3Rau3XN5DhulJvqmP3ROLBDtGBYLacs8yQVXUsIc=;
        b=ayrELvkz6RCr+VJ5YTbdaI+C+7T6BGsJEAguxUgCPIN9LMOSG1cQ+4QSxLfuYecJ7g
         rEkt3pKt8Q3IXycqxre3TSAUHzDDJJG0qs2FtZn9cMqz4CShi0DQb1RnbrzDmC1TGFDB
         UCnS6y6zB4oIa+C342OBOENRxbAzNtGyV/eDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=lIp3Rau3XN5DhulJvqmP3ROLBDtGBYLacs8yQVXUsIc=;
        b=NZuAJx1velt7MugYlCheCtDHASS6sgRgOp6qXlD2yfJDTw/nODa4N6VVKwRIbmmWbA
         S0SPTAO8/0tHeQWYO2o+ux1Cm82GC/AMlFaUh2uP3MRtW1Cs/h4D8IaE53ZKbEJvEM1V
         p+eQWNvVRkKLH8MTQD4ZCC7o4UH1zgX/n0jbQpFXL/DvPyaA0FT3d1sM4HX+K/J0k9Yt
         luZgi/XjsdgthjJ3YQJ59rO07oB8zEEiXS2HiTYWUo9YOb+QEwuanTRzRY80i0G+7hNe
         nCOHJCmBcb7rMjsY6GY3AkVHD6q0y8oyU7CGPmKjfftOBQX/nAxEy6LKuveqwnRowYxY
         ALgA==
X-Gm-Message-State: ACrzQf2EBiQaC81Na1RwdUZ6F6c1aoBJh6uKtPcydcx55ryZlNbpumo3
        9Hguj/e4g1/b1QFs4XbqEHAixA==
X-Google-Smtp-Source: AMsMyM6/T55zDNr2wZmPqXofdZ9R/U3i46Zn4bR+d3pjEfZ773lmSd+dIb1qk1eRO6CnC5XeCBBzng==
X-Received: by 2002:a63:2221:0:b0:43b:f4a3:80cc with SMTP id i33-20020a632221000000b0043bf4a380ccmr9160031pgi.367.1663964909744;
        Fri, 23 Sep 2022 13:28:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a5-20020aa795a5000000b0054095e1b2e5sm6854521pfk.215.2022.09.23.13.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 07/16] btrfs: send: Proactively round up to kmalloc bucket size
Date:   Fri, 23 Sep 2022 13:28:13 -0700
Message-Id: <20220923202822.2667581-8-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1522; h=from:subject; bh=B3w/yPcNxrDzZTqNaOBRmqqUYMKjQkfGlvei/e1+oVk=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbkv/6yf2iFhq9YdN0Aj+2wDjdTaVU6RYLE7C1a mKAEuIiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5AAKCRCJcvTf3G3AJuZJEA CsVm4vzR8guJhS9ev8gPlqvsMaYX7r8aLG4A2NyUhHtbSYNZT7nhbnknnZom1pWNwXgl8qpCTbd6+f vjFzrrIjZtd4D+mSEQPZbx+7rT8VpT3Gtb3/D2nYYDaxLdL/DH99n2c2cbhe8zTWcTnyynJYvES2KC EyHjGO9+9QBzmAOfL6UqxFPxgSN6Mwe3il8Jqb4M5is1whaTpYWBL5PS8pHVDzWbA0hBRdEd/F7aPw o3KlBtzCSp4XR1hHtVT8NWbMPwch83XMmXdi0o6/GubfCfksfBTpaXo7dIG+SMZZQWfgCIvRni8oUC qF3eZ2rfkK2BLw1wcdknu/z43jqhoPV5OtU9fgboiNn0cRbYZC7GmCUWAST/dEfoMQx73mUpyFKCbB QKgl1tbq34QTMFjDcV6u59zyZLRrnP18YpxwCaUglLSod93wDcCin1+C5OXvXtCxNg3CAAlxDJHTVx 0pTds4BRbXQj2/4i4Hb/jcctaZnAs0UoMTTcW+BrbOixx0+CrzBJ0vNQMZh5Hs2WYucbihNX7w0sum 2KnTPVVPKpteClxy32zMqoJRvgjzvqik9+nj4bHX5wgV6aVi+dbQdRPezJyGYxH+GkBtsj0h3BjaPk k/mBMntGy8FlUD9pzWHKmr5gF7fYzXCDe75VLz+YEUGvOyBawRkvwMlkpY3w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of discovering the kmalloc bucket size _after_ allocation, round
up proactively so the allocation is explicitly made for the full size,
allowing the compiler to correctly reason about the resulting size of
the buffer through the existing __alloc_size() hint.

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org
Acked-by: David Sterba <dsterba@suse.com>
Link: https://lore.kernel.org/lkml/20220922133014.GI32411@suse.cz
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/btrfs/send.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index e7671afcee4f..d40d65598e8f 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -435,6 +435,11 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	path_len = p->end - p->start;
 	old_buf_len = p->buf_len;
 
+	/*
+	 * Allocate to the next largest kmalloc bucket size, to let
+	 * the fast path happen most of the time.
+	 */
+	len = kmalloc_size_roundup(len);
 	/*
 	 * First time the inline_buf does not suffice
 	 */
@@ -448,11 +453,7 @@ static int fs_path_ensure_buf(struct fs_path *p, int len)
 	if (!tmp_buf)
 		return -ENOMEM;
 	p->buf = tmp_buf;
-	/*
-	 * The real size of the buffer is bigger, this will let the fast path
-	 * happen most of the time
-	 */
-	p->buf_len = ksize(p->buf);
+	p->buf_len = len;
 
 	if (p->reversed) {
 		tmp_buf = p->buf + old_buf_len - path_len - 1;
-- 
2.34.1

