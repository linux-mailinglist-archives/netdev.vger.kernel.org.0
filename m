Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73455E592A
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiIVDLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiIVDKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:10:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858D176941
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id a80so7953061pfa.4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=kaPCbEUam/i/QzM3EsiD/q7EbxvCz2hqpx3qsHkAHe4=;
        b=n3JitkeKKUUxbz6yn64Uwj1L8NZF8ivw+xHJGwLWPTznbBHC9NKX5oIDtTPO2BaSLc
         93ZTFQf3icolOuiYEksXgK7g/tzg0rkadZNBpMtyblAayJyXz59n3d2igSogXrXOJeEu
         gpFsv/wtpmyI2nisZWM6BTAhUm+uMJ0L5a/t4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=kaPCbEUam/i/QzM3EsiD/q7EbxvCz2hqpx3qsHkAHe4=;
        b=rKYCw0bJp8zLgX8GhUjLki/cubTVcCIAN4KsdKmNA+Qgkxk8CKKxr8IyMjqHxy01fG
         /KRw+yA+0R+X4E1L38GkUvINOC7ykDyFDEiN8tZHTurJvf2G8A7fhP4BEmPU7Re0hh7E
         c+yCd8oe76+qmzmD2Wi5/mCReMpKePkgyfFS3qJCYMHiN0pBFxeRT4T2MgC70mKOVOJ/
         z5OSZ00takj2PDhfYnBEFHeUKNcIhklhPYCGG2zvoUMTuBuEG/UnhW9TfA8NVLHeFwRr
         BX6kgTtxpM+KnAfJTAKSIgMjUhQ/Y6yNwJGyBkOvnNq+osP6fKsDv9oMRQCcdL9YmWEs
         GL3g==
X-Gm-Message-State: ACrzQf2CDq6QcWHqetvOInz7tyrgAG7ko3lPIEQv7MukER6u37FQjuYA
        ItVNxKLkllImAkar4ZCwGouufQ==
X-Google-Smtp-Source: AMsMyM6cFS7tDGVCwJ0vHG2t9zSWZS1Eoi8Welusn2TdzO1FITGlKW23X2CzrnylSu9gzNhY4M5M0Q==
X-Received: by 2002:a05:6a00:c91:b0:540:f165:b049 with SMTP id a17-20020a056a000c9100b00540f165b049mr1383264pfv.76.1663816224094;
        Wed, 21 Sep 2022 20:10:24 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 69-20020a621748000000b0053725e331a1sm2959597pfx.82.2022.09.21.20.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:22 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>, linux-btrfs@vger.kernel.org,
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
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH 04/12] btrfs: send: Proactively round up to kmalloc bucket size
Date:   Wed, 21 Sep 2022 20:10:05 -0700
Message-Id: <20220922031013.2150682-5-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1342; h=from:subject; bh=PATxOgKCtfzCXQKH17glgfixgYzE1x2L+YHf7rSxpvE=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9ITJpSDjmxsaSk36KMYUjIvxLLAk9hi4Gv/fvEs tw4mn0yJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSEwAKCRCJcvTf3G3AJh3FD/ 9lgh/1XHl0SkyqPlMmPB17u7DDgE4q/VJ/Qa3GzTJ+egqjXOgy56TZhDHA57JAbNFH368V7dUHPLKC QXVOMAIaBG86hiTbSG2GFtspKIl5m4mQliPhYXo+9i2ctGvX67kQtgkloJBBOBTzM1Va+l8n8oDiM7 1keZZzJh1/Ke/X48PR3xg7Nx1uYbX9+ergUrLAPxTg/zdXdpoqFOJHqJQ3KTDdZ/Ei4EYr7MM+zZd1 B+a+f4KPaYbr0rUNv/eRElOKPdR3IRmKr00cn3bz0YQJFHMIHIfiUC7c02Q5mRGArZMpC6TDBu3Tkb nuAA6r64037k3F4P3KgpNrjYdXUKHgrLD5MS0HV/wt0Jl9wh6vCNnbY9hyrP1HoFV59EkKwXqy05Vl 7L7CE/IjCudzIhmSQJ5qMWxuufWw0aOCT98jEVLKn5HNir4xbt3Nk5GB3h8odtKKt5aij2g+sglk0N VozOjrkQEETzGVX7M0zWbpzsD61ZTOIY4ZAn6Zzztl/0Napt96blNs9J1EbovYn8uMQ2+XR6pZAwD1 TALlt7LDxwlItLIQQBK7XhEI2TYqOric6v3Z1icQjPqGGv16cy/WXfeY/MEtdwAcxELgoSF7ClvUlL BHriLuCX3SJCTRPP98sRsMm0ReDlyAlIib9iPFvDtr+pDztAlOw51wwNqgZQ==
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

Cc: linux-btrfs@vger.kernel.org
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

