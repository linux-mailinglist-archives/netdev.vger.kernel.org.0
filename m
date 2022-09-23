Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CCC5E843C
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbiIWUlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbiIWUke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:40:34 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E86152205
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:35:46 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id s206so1288546pgs.3
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=+2laYBdgjwT7rG4W5AHSQduuvkvGMevdVubQImW4gKw=;
        b=nbTXxoItIcoLMSX/37BnKPPw/3YlEPQi9RGa22B4OfB3Mw3rQ7fVLlIBZDFWhU6SQB
         iQQy0oVdOCW9DPex5gUVO+9CVPiYxCD2RX7jYGmew9mYG9nePUONwhOxImpJpLdtHO3I
         +RIWIsZx79HIw7FNWO7gsYSXx6hJ7HZJNUkfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=+2laYBdgjwT7rG4W5AHSQduuvkvGMevdVubQImW4gKw=;
        b=RURRvDW+f/7FBVnuqvA2X8l1nlOhWa/xzfQr7eJXQCgli0EkdyaYPTcPOzJGcfTXy1
         q38FJ6kQX4eTgc50jr4pvoZAAeYMPjz7t4ACqAkMBWd4BtS9fskT+QCaYApsRzfj3nm2
         nVrUQVm0WEsTi7Yl4U4clmuXRvTuC2TlclZ3bfyqMWom8+1BdXpr7ypU1vsWt6Wq5gz5
         7veTqC/6PxgSWu58KjeON80KbQuNqpIvVIpfFsl6ZZRkRlg7ww6O+k/wa/wJuO2RWNyt
         3BbxWEmmpiUTcY0iX8jIBY/0lFeFZjxiV7ikUJGhyBi4IEGzEvyzIjtqaJUrU0wYQFeM
         RMGw==
X-Gm-Message-State: ACrzQf1rGJ4fwx+zTYrlHJin049eTS6s1RDKSCr7tjrH1ujPDBbk47An
        JcmTdOAI1jnxmmypYMVfHu+YVQ==
X-Google-Smtp-Source: AMsMyM5bm7zGXJ9d50JTGsymxB/VLZYV8oPS2I+E2tFMZpMAmvrfAs1/p+X8f9kZo4aKjt6+zvlMFg==
X-Received: by 2002:a63:8649:0:b0:43a:d230:d3b5 with SMTP id x70-20020a638649000000b0043ad230d3b5mr9208334pgd.493.1663965329910;
        Fri, 23 Sep 2022 13:35:29 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b0017685f53537sm6450933plg.186.2022.09.23.13.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:35:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
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
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 16/16] slab: Restore __alloc_size attribute to __kmalloc_track_caller
Date:   Fri, 23 Sep 2022 13:28:22 -0700
Message-Id: <20220923202822.2667581-17-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1650; h=from:subject; bh=/OaZMueZzIe84chcaXjPmGvBh3Vl4n1WZ7Et98TCic4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbmpXV27OdVCurixM5mD3YL9FeIo8HzPKP6kKFZ 0hj84SaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5gAKCRCJcvTf3G3AJrk1D/ 9suh4VQDWJhn6CjYJdrIyeIOje+kXnxuVQ4rZWxcfisvcOa9LBG3AeDjRuKI4VpUdYD37IwPPRov57 7ySYIwMkjVqKZEa/PzjhXiMhpeo5c/FR+mC/2/7gf0vf6wqxRDni79+/q13dY5meEj/JSCQ/VnxZRe gjJepCGBakVJaJJpuemoCwsjm59sySqVEfoXZQ3j8FvjLzn3UEHguFLm71uFRvZJYaFRgcZYER/6SM gtzHNWGWaCNhF8dkKOnwzFjb9Rnzxv996CnMgQ48xhu33oEvFn/qv87UNwxYH5nu+eGAj6AOn0942n o/n7ecuvzIw73BhNbAqSHTiF/7CH2P1ACFMXogDcRbmseRTH9IxMtimtJP4ycB5H3BlirHH62OwXYW HcNSihxuIstBMI+dXzPUAePdpDw9zFpCkThJFB3HawrMyY1xWxrUir3MaIirOiGPAaNsQ2phrSDz2q 89SyrvWcLNxNEqTTWGHN3J4vSrnAPQTLDJgx+qlchawQhrFpywa38+u+aGHG0NL7zPvmR7xoWq31Bj MvQuhlk8RDsuhGN+mFYxlipeK0PD5eo1yTnzSxnawr2guLYHLoh5ZATYEPsnWaJ23aiXDLUrWeSOx6 ihxdUdxuZS6AB+vqV1rDpWb7cFU4nZ6MydrAXZN1cwWnC866PyTB2WT4EREg==
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

With skbuff's post-allocation use of ksize() rearranged to use
kmalloc_size_round() prior to allocation, the compiler can correctly
reason about the size of these allocations. The prior mismatch had caused
buffer overflow mitigations to erroneously fire under CONFIG_UBSAN_BOUNDS,
requiring a partial revert of the __alloc_size attributes. Restore the
attribute that had been removed in commit 93dd04ab0b2b ("slab: remove
__alloc_size attribute from __kmalloc_track_caller").

Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: linux-mm@kvack.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/slab.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 727640173568..297b85ed2c29 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -693,7 +693,8 @@ static inline __alloc_size(1, 2) void *kcalloc(size_t n, size_t size, gfp_t flag
  * allocator where we care about the real place the memory allocation
  * request comes from.
  */
-extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller);
+extern void *__kmalloc_track_caller(size_t size, gfp_t flags, unsigned long caller)
+				   __alloc_size(1);
 #define kmalloc_track_caller(size, flags) \
 	__kmalloc_track_caller(size, flags, _RET_IP_)
 
-- 
2.34.1

