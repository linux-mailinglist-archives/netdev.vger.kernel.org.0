Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 343045E8401
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 22:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbiIWUel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 16:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiIWUch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 16:32:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EB314B85F
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f23so1168219plr.6
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=9WHW9dcNJ7USo93XbepCTz52gEB8RJhZFTCAgOxjaWE=;
        b=MCrThrcpHBXTtrPTMUDahiOxJ8D8ml0adnc2b/ZnUpLhKCWbzkicjK7DVQ0Out5WOD
         FREFmdsJO4H0m9nZW5aGp3kZr8NyuDEg+cjmHSd2PFaU5B93FD7J4xKRdTkOt4VgUbKn
         UMInxMGoGT3uNhBnpORcuWbRNV0aijKsC637c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=9WHW9dcNJ7USo93XbepCTz52gEB8RJhZFTCAgOxjaWE=;
        b=pVNW6gWR7qLQR2xCElqEdz2zNuNp/d8XnO0oykzVK/FHHHjhAXfKYP+RNyryk+QodF
         Vyy+s5s2fYW1FMq8MgwDeZAm/Vj+PXVqABOTaYfRrpf0jql4QOg0xBygqF1CGCt4hO0+
         V3j2KW8+NtgxETKtn96mHHt+BDAPeZG7gBRklschejB4X19ZkHNL0rP2iLgWLNumBdsr
         Klqij3qkkJWJOgsopV6zNQgrgHklnftqb/UwQQBGIqD0ENE0JME6EL37T0vniNee5DnR
         dXJR9VS4uoK6+qd8NWVFULz8Lo9gs0fdbtkNDqHVnX7oHwjq5xkJcdnqAbStnwLdOv7R
         QzdA==
X-Gm-Message-State: ACrzQf3OEyIc5gH4Uc+2rHJ94BeUfo0B1WtX7Dt+FaiTe5gqDpq00nao
        xn3lMHWql66zllekGppXNAXNTqaHPGpwng==
X-Google-Smtp-Source: AMsMyM5oK9MYI8mIo+EhF+H1NGRpmeDN3XTs1GMolX8M2ezSAV2Ua89sZ12ya0mBIXqqAy1a/ohl1A==
X-Received: by 2002:a17:902:ce85:b0:178:2402:1f7d with SMTP id f5-20020a170902ce8500b0017824021f7dmr10208022plg.81.1663964912148;
        Fri, 23 Sep 2022 13:28:32 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id n8-20020a170902d2c800b00174d9bbeda4sm6514749plc.197.2022.09.23.13.28.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 13:28:28 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
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
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, dev@openvswitch.org,
        x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2 08/16] dma-buf: Proactively round up to kmalloc bucket size
Date:   Fri, 23 Sep 2022 13:28:14 -0700
Message-Id: <20220923202822.2667581-9-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923202822.2667581-1-keescook@chromium.org>
References: <20220923202822.2667581-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1536; h=from:subject; bh=1k9cluqwH+m+5FA9iHjyZRl7ltBBZL1qz3WU+O4eJDg=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjLhbkkQMIyxW+p5Yq+8oZ2wcfayyBNx+y5dQbw2fi AE/i2oWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYy4W5AAKCRCJcvTf3G3AJs+QD/ sFhRuVLRx0nMn49LZ3LgzAUGJu/OCv8HKw/plbSsv+vpxeMZ5Y4Z2yz+8pOjvg3cX6lD5EGOFnhfDh AkybvgBPzOD3UBEmc2+orSVNWeDOnYXG/2dyEL7KYashVN5HVyJ+SxZeRk177uhTjBzjbNRkAQ/SVs Oxp1fa8tJlAzSNr4khPvRqKxudlyHIfws9eHam1m+xu9Yx4IaRjlpv73TPFSCF3B4R61s5d9qdqmI6 QtxsboSAw9VmMnwtQ92JY/zE3XF4HhRRzOwCGtrvQkJf7xWir9bHo5kODtv29MGnYSHOD7MNuLNHvy yT9yMlcMCSUI01Gqw83MyXuzCvvbGT8fRIxDuE0OLV8AuytMSMYtLLvmi8aqicaaH1P85zLrbxJ7VQ ibgpFBaDwYITAulUo26Uezs0cpbObE4vDsRPIMUwW8KNHI4PXEY3ej4CfYwEi05WAoQDnHjsKiI3mw NgRo1Knltm0LSiFomNDPAPC2bLhoNZ5ap0NV7jcfaCdq1s+e8i6UWoxTNuvUmvNZIO/WymKW5MaK0w VFLb8zJYoMtYLSQQRa1twKC/oiHyzfBWzmy0upGh1vD2LcXJMTsecq1f9iPUzq0AYRDLPe3zIIPTo5 8qm3uJJ1hdyE1VeTF4mKkOhP+oujwwLKoB9fQmxF1d5+YH73zekSnLGtymEw==
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

Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/dma-buf/dma-resv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/dma-buf/dma-resv.c b/drivers/dma-buf/dma-resv.c
index 205acb2c744d..5b0a4b8830ff 100644
--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -98,12 +98,17 @@ static void dma_resv_list_set(struct dma_resv_list *list,
 static struct dma_resv_list *dma_resv_list_alloc(unsigned int max_fences)
 {
 	struct dma_resv_list *list;
+	size_t size;
 
-	list = kmalloc(struct_size(list, table, max_fences), GFP_KERNEL);
+	/* Round up to the next kmalloc bucket size. */
+	size = kmalloc_size_roundup(struct_size(list, table, max_fences));
+
+	list = kmalloc(size, GFP_KERNEL);
 	if (!list)
 		return NULL;
 
-	list->max_fences = (ksize(list) - offsetof(typeof(*list), table)) /
+	/* Given the resulting bucket size, recalculated max_fences. */
+	list->max_fences = (size - offsetof(typeof(*list), table)) /
 		sizeof(*list->table);
 
 	return list;
-- 
2.34.1

