Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD551944E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235761AbiEDByx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343582AbiEDBxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:53:06 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC26545796
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:37 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id x12so11777pgj.7
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMAADGqtkadGyWtiMmUAPEm8bORo1cOmSuHFnzFIe9g=;
        b=HdhwV0WkvXZw3hjS8p1tFCKs9cZKJFJ7k5obLNyUKACusCcW1RzcVwG/3AkN25wPjr
         MN1c4fbIR9x0erwQN9MET5VRJYx8dh+R8g2fLDUMIFlB05v/yh9SmtiE3TYb5zg7tp+O
         AetyTzERcbfGEy31+di4TAAiEqxWduNa5FUWY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMAADGqtkadGyWtiMmUAPEm8bORo1cOmSuHFnzFIe9g=;
        b=a/oxm9fr/2MDGE3nalXzrJtFk0/yOoiyUNPgY3WR21ZM3bwKwCz+3VT82zfyNJPAfm
         4a4/9IzHOTgqAjKBJ1n/hKb3RiFahewWF9k7PGhFXW/7A425qgDaSBX3PtrZ5VSnxDKl
         5cM6TlL+bx4jMPTxuQmcwAD+B4vjlspArSYN6xUkh6y60bYAdype8jj/hr/JDoJz44wS
         y3N44tH+cOgne3CnJAF/wGSuzDz+GHQUWQIb/tqVA7xOj9D0gr0CDU/TfFCbp1u12yit
         +mlhL9rGP4XoihQmVajMUDit3HEtM8uy67I4MhdvhSxu7jyVtz3t99R9jAe6PElq/9pZ
         5KqA==
X-Gm-Message-State: AOAM533G3bcG3wtV4CdzoJDAWPDnGkZgf7tQDU/JniuPTqipxFXeuSuW
        5Dl05o3/XonTH9SsADKH531R5g==
X-Google-Smtp-Source: ABdhPJzJgAADMFFc6IgYXUwxUbgxm7TVuxaF377qcwdaawZlHxybyGrud242lBwhZCdVFfq7tPWaqA==
X-Received: by 2002:a63:86c6:0:b0:3ab:2c2c:42e9 with SMTP id x189-20020a6386c6000000b003ab2c2c42e9mr15878387pgd.230.1651628864123;
        Tue, 03 May 2022 18:47:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id j10-20020a62b60a000000b0050dc762817dsm6922289pff.87.2022.05.03.18.47.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Al Viro <viro@zeniv.linux.org.uk>, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Christian Brauner <brauner@kernel.org>,
        =?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Chris Zankel <chris@zankel.net>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Paris <eparis@parisplace.org>,
        Eugeniu Rosca <erosca@de.adit-jv.com>,
        Felipe Balbi <balbi@kernel.org>,
        Francis Laniel <laniel_francis@privacyrequired.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gregory Greenman <gregory.greenman@intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hulk Robot <hulkci@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Morris <jmorris@namei.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        John Keeping <john@metanate.com>,
        Juergen Gross <jgross@suse.com>, Kalle Valo <kvalo@kernel.org>,
        Keith Packard <keithp@keithp.com>, keyrings@vger.kernel.org,
        kunit-dev@googlegroups.com, "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-xtensa@linux-xtensa.org, llvm@lists.linux.dev,
        Loic Poulain <loic.poulain@linaro.org>,
        Louis Peens <louis.peens@corigine.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paul Moore <paul@paul-moore.com>,
        Rich Felker <dalias@aerifal.cx>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, selinux@vger.kernel.org,
        "Serge E. Hallyn" <serge@hallyn.com>,
        SHA-cyfmac-dev-list@infineon.com,
        Simon Horman <simon.horman@corigine.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Tadeusz Struk <tadeusz.struk@linaro.org>,
        Takashi Iwai <tiwai@suse.com>, Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 14/32] af_unix: Use mem_to_flex_dup() with struct unix_address
Date:   Tue,  3 May 2022 18:44:23 -0700
Message-Id: <20220504014440.3697851-15-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2272; h=from:subject; bh=8b5W7mEG2Sah1C3FkS/UxctivFJh7iOzV6P8ujUbZM8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqDcR3znMx51jViMoq05/q58V2/1rXjoJjYBmJ4 CKXc5kiJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagwAKCRCJcvTf3G3AJp8ZEA CTZiOebtApgRIMQFGfvlsj7s1U7ENKry+y1qCoH7clKk+kIHUFtKQuToAucuA7HnBVAIDqbBHa+dtu b1A4bqv4cHK21pPyhZmiE0VCyP00EYC8X6VbBCMRrhOvgKIRCQKYCDRRU3x3+zdTamMi+Cw4QRLFbr KeEVo3vWRxKFNYlUY6py6WsFnpaTCP45A1Rt2Mk1ONM+4tvkRlgJQKibXiiVxMmNJiq7diRyS43UyZ xdZzOY9N/SsdVs+DBAetVCVJfwnmWSxup+qwrjzAenumL1egb53niPav19Uu0KPGAkzqPtS4NDain6 T5G8UOgj2W4S/ZIxVzp3AEI0v7Q07cg9AUILFEUOEn2Ga7m2xtn/dn5Hqt0Gq5ryDybbgCBb0FW6nE apZrvb6JoF5ZEkWIMx0CD3b/SEJCPUMr1n+n/nlozI3/5uYk+uJuq11ezAU6BWwGeaiQi5MNENuLtJ f2iVuD520n1Ne+0aDX0g+6Bxq6CjD/3mk3NtQkdQZ1W7jF6hmMJWqPx/GWYvlmDlmSQNEQ659WICV6 styiy2WjRaD2LhpwT9sZHwcdpjjTGhsJ3rXcC+FrO5v7LrNOaE49f+5vGV2+PdIn7TzyijsyYCwjfC sD4MdxKc4Kc8wvaGgok8h676GkR5iOBRUeFIUjcwGTrf9mDGBR6ew5hwb4cQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the work to perform bounds checking on all memcpy() uses,
replace the open-coded a deserialization of bytes out of memory into a
trailing flexible array by using a flex_array.h helper to perform the
allocation, bounds checking, and copying.

Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Cong Wang <cong.wang@bytedance.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/af_unix.h | 14 ++++++++++++--
 net/unix/af_unix.c    |  7 ++-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index a7ef624ed726..422535b71295 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -25,8 +25,18 @@ extern struct hlist_head unix_socket_table[2 * UNIX_HASH_SIZE];
 
 struct unix_address {
 	refcount_t	refcnt;
-	int		len;
-	struct sockaddr_un name[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
+	union {
+		DECLARE_FLEX_ARRAY(struct sockaddr_un, name);
+		/*
+		 * While a struct is used to access the flexible
+		 * array, it may only be partially populated, and
+		 * "len" above is actually tracking bytes, not a
+		 * count of struct sockaddr_un elements, so also
+		 * include a byte-size flexible array.
+		 */
+		DECLARE_FLEX_ARRAY_ELEMENTS(u8, bytes);
+	};
 };
 
 struct unix_skb_parms {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e1dd9e9c8452..8410cbc82ded 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -244,15 +244,12 @@ EXPORT_SYMBOL_GPL(unix_peer_get);
 static struct unix_address *unix_create_addr(struct sockaddr_un *sunaddr,
 					     int addr_len)
 {
-	struct unix_address *addr;
+	struct unix_address *addr = NULL;
 
-	addr = kmalloc(sizeof(*addr) + addr_len, GFP_KERNEL);
-	if (!addr)
+	if (mem_to_flex_dup(&addr, sunaddr, addr_len, GFP_KERNEL))
 		return NULL;
 
 	refcount_set(&addr->refcnt, 1);
-	addr->len = addr_len;
-	memcpy(addr->name, sunaddr, addr_len);
 
 	return addr;
 }
-- 
2.32.0

