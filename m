Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FD705E594F
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 05:13:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231377AbiIVDMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 23:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiIVDLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 23:11:37 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBC993226
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:29 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d24so7546306pls.4
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 20:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=nllmYacJVnWYWyMDuOWg+UhFJID/1u9fgEUSXV9a/I0=;
        b=ObVBgj10USdxX2qau03B/fvKSrj9pfzNX++HX3pR1Ku6Ct/c+Mn8B6TC2gGByEksOv
         ftM/dSMzexkJk0pSadbJzyromjdrIDks1988E0vt92N7zZIkoEa3uLvIJsqtFfZmvRDx
         8dl5wBNFG6y2ajB8JRxgoslRMstHrNUREimgg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=nllmYacJVnWYWyMDuOWg+UhFJID/1u9fgEUSXV9a/I0=;
        b=es8+vQzyywAqgRYXq7fc/gIpqRjbgxeIuika59RcOHIj0L2xPgO7NEpS2tKoer9myt
         y/bBkr5Y4yOv4Z0dWIO7kU/wRvTGMXYfhHkBHj0OmlJSNCOxpiMyGsP2t1ezJl0R8XYH
         vp8CA7egdmnQBYOWhsit6gRC9+jgjRWoaaKqUqciob2rno1Io4nRrAkaa8xLcN2HHI34
         qq7RyBqeoFhcThgOa20LmNKe4X7HJsKWGQNDHOvmG01+LW9pa/huCeaw3trVLMxvHWMW
         hDEy1pbgWNNvtCMe6URY2XXb5wBLvpET4akOzY2z9Kr/Y0+/+8BMkUlmuEZlw4S/fMof
         dy9g==
X-Gm-Message-State: ACrzQf14i7coNwxZfDMWAup0Zzt7lYbaLMr5YUlbOT/9GwFRwqIIHwsw
        x561SipViT83OdulAzEH3USHyw==
X-Google-Smtp-Source: AMsMyM49XhohtYBkjYXAytE2XFYLdWSstHIvAKOydHl9P7CLdwWaHlEa/nts1aXdGwMJ6p2JjPZrLw==
X-Received: by 2002:a17:90b:180a:b0:202:ae1f:328a with SMTP id lw10-20020a17090b180a00b00202ae1f328amr13239578pjb.78.1663816228865;
        Wed, 21 Sep 2022 20:10:28 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id d18-20020a170902ced200b001783f964fe3sm2766723plg.113.2022.09.21.20.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 20:10:26 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Kees Cook <keescook@chromium.org>,
        Daniel Micay <danielmicay@gmail.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
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
        Yonghong Song <yhs@fb.com>, Marco Elver <elver@google.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, linux-wireless@vger.kernel.org,
        llvm@lists.linux.dev, linux-hardening@vger.kernel.org
Subject: [PATCH 09/12] x86/microcode/AMD: Track patch allocation size explicitly
Date:   Wed, 21 Sep 2022 20:10:10 -0700
Message-Id: <20220922031013.2150682-10-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220922031013.2150682-1-keescook@chromium.org>
References: <20220922031013.2150682-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2149; h=from:subject; bh=LRLPHeutQvsvCqROzEs3/rr/P6uPQnPuMyr/7IE9r2g=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjK9IUgfEF5Q67qoI3XgFPEX8J4smU+peBuyPzdpCc nIEpFpaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYyvSFAAKCRCJcvTf3G3AJsUGD/ 4jiZQIVRjbRNvUVUl7QhNkO/5LbO1QHELDOu9VeAlksbBy6XuO+qlBw7CoqEHO44r9YLdeZFAssNud wYDnzHSwrmpVT9VOZKujYIXUu4jVQeSmpRL+/zi2WAX5dpAscIDYzhoFkFQuW/aQn9nvVlwwWv2G5A GfumYAURZ8BP94NLhlaTRLKHc10AEhWJ08FZCbBy/NXE7LT5VZa1H9zYppFy1ulRzYa4xiX1Weubkg o7PsRtqxx2jPKi9ywlm4JL33MLhQ7Hl1dObUN2bhp8DRTalPx6Bc6SUbteYJPbwKYEr7+5pD3iT+ek 78esKD6WsOGfBLAZ8pf8lCldD0XPYRApJVGasz+zBeg9LCqumUaDwNzE9GNpHfaorgWXNBuXeuKFif 5rYMN95t+ygRdOvQdNJlCJ0JlPfMcJajLzKyYKCvSlICPcTlaGpjjCGXtVFMSUZgvkbvhOZnwoRTfP LCMqYLu+xX8m1YKOnipcqlhorAe+A8u41dR2tlI0HUW4UYrUIZQ5O+CQqG80Ge713Eg5bk43crrhKD YsmBHTsJ/g7EuL/mG/+BltzwRQSF9KUT12J1eO+hSib+I+7XiE4mW8dN4M4JLJmSxvAa5G/pJSmhKH 6ZKIBAfSeBqo6VbAeV28Lkl0KnRiBwVDbQ08NwltR1YuONRBkYjOqYRx4S+w==
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

In preparation for reducing the use of ksize(), record the actual
allocation size for later memcpy(). This avoids copying extra
(uninitialized!) bytes into the patch buffer when the requested allocation
size isn't exactly the size of a kmalloc bucket. Additionally fixes
potential future issues where runtime bounds checking will notice that
the buffer was allocated to a smaller value than returned by ksize().

Suggested-by: Daniel Micay <danielmicay@gmail.com>
Link: https://lore.kernel.org/lkml/CA+DvKQ+bp7Y7gmaVhacjv9uF6Ar-o4tet872h4Q8RPYPJjcJQA@mail.gmail.com/
Fixes: 757885e94a22 ("x86, microcode, amd: Early microcode patch loading support for AMD")
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/microcode.h    | 1 +
 arch/x86/kernel/cpu/microcode/amd.c | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index 0c3d3440fe27..aa675783412f 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -9,6 +9,7 @@
 struct ucode_patch {
 	struct list_head plist;
 	void *data;		/* Intel uses only this one */
+	unsigned int size;
 	u32 patch_id;
 	u16 equiv_cpu;
 };
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 8b2fcdfa6d31..615bc6efa1dd 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -788,6 +788,7 @@ static int verify_and_add_patch(u8 family, u8 *fw, unsigned int leftover,
 		kfree(patch);
 		return -EINVAL;
 	}
+	patch->size = *patch_size;
 
 	mc_hdr      = (struct microcode_header_amd *)(fw + SECTION_HDR_SIZE);
 	proc_id     = mc_hdr->processor_rev_id;
@@ -869,7 +870,7 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
 		return ret;
 
 	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
-	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
 
 	return ret;
 }
-- 
2.34.1

