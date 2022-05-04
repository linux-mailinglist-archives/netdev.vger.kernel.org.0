Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A61B519483
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbiEDBzt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343566AbiEDBxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:53:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 166154553C
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d15so171603plh.2
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ifZyQ0FGREg3J5AlhSr1XwF8hVhKkYa2p2S/5EeDNQo=;
        b=oI9BqoXIzDP9CoImflntgKhs0kNacYAtoqQVKtiTaZQIfSzE3upaJIyWSMVlJB9jX5
         Uzgry9KW4Gc+1VYbvAKoSW8Y7tDSPleB46+D+uoXs4vfR0muKw9a9urjnLYWGuq+yUxW
         TpztkzpLBXFj1c/3e7LzufWdk2zzK47xh6GHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ifZyQ0FGREg3J5AlhSr1XwF8hVhKkYa2p2S/5EeDNQo=;
        b=uJTUvP/w+jzsOW68cthFIh6pCDqmP6uoNbBdXJbzpEQJpU6Azm5KmmNpW2pJiQxpsJ
         orUeGJDFR/Oub1OcVQilNly2WYKR/WMz1GC2z5V7jA2rp9/4vbeI811QdS0XZY0Pndnf
         UHE5G5ZSLmrU5PgjHmnCjtk+N10FH7g5r5ylYIE5N3YBRgVyoY+ONFWQ3qEnqxnx3LFV
         0UkF+939df+342KS25774zv9+jnpfp9SghZl9zq7NVpncY4c3g8gSTQ03PXSxq7ZSI0M
         rgNYVvvqjaZbNQA+jQVgLYOjQcfQi3C9DOn7Tpn/ho7MQm+kbiGV5TtS5WNK+zasLmXf
         NDdw==
X-Gm-Message-State: AOAM532vBMX9nZyEsihYmvcNRPkG7XKXCmASrqGjPAbra31m8opkLIYs
        qPZ+BmZIOi8YftVfpGO56SAy8A==
X-Google-Smtp-Source: ABdhPJw0m5mVFCOgCUpCE8GLC3GlwaR4OoV/F1PJE/v/+oOh0kg89xS/hIyuryWJooLw39F8A8MZEA==
X-Received: by 2002:a17:902:9a81:b0:158:1c91:4655 with SMTP id w1-20020a1709029a8100b001581c914655mr20008107plp.162.1651628863597;
        Tue, 03 May 2022 18:47:43 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p7-20020aa78607000000b0050dc762814dsm6945126pfn.39.2022.05.03.18.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:43 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        David Howells <dhowells@redhat.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        linux-afs@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
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
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Axtens <dja@axtens.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dan Williams <dan.j.williams@intel.com>,
        David Gow <davidgow@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        Eli Cohen <elic@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
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
        Jakub Kicinski <kuba@kernel.org>,
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
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux1394-devel@lists.sourceforge.net,
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
        Marcel Holtmann <marcel@holtmann.org>,
        Mark Brown <broonie@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Paolo Abeni <pabeni@redhat.com>,
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
Subject: [PATCH 19/32] afs: Use mem_to_flex_dup() with struct afs_acl
Date:   Tue,  3 May 2022 18:44:28 -0700
Message-Id: <20220504014440.3697851-20-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1709; h=from:subject; bh=saaNwrN23mX+OUTBowMD9D5OUm7L78VX128VXuwjwK4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqFfM0vuwTYMUTv7e3BZX/iyY3njPgklra+Pkd2 Z4Ou11+JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahQAKCRCJcvTf3G3AJnn8D/ 0T93KRcb7qCWTB465n1/YTnsBy2jNLz/U2OLVBzcDFt0AYoA7buN0/1goMxvPhSLi6bjE8UGxc7Fm2 xx2FN5ysX9H/h+AK/cJ3DkHLeBbkc/PToOz1Rhf5ASBW2+V7+qa6CVBSwtSMKSrvj1IM0/N6ioBB18 MCYPkmQ5qhj0A1T1FA5/P3wK+c+Ifo0Yti2zuuDAIo5vSlw/g2lJmCFOlKoVoRmzWGn3UyVXJ9I2UQ xKVYebiH78lPg6s6N8CPVfENvu4vx//FaBlyLvf4NFhRMP18HACQP44Qc0JxstvU7LUJDijflXIFRi grE+kmE6e8bz3l6xfmcLLCVVxLK6kcbN3OPR+1k6kH5962HfiJPZd9T/oRuzkyyoFrBDpqQaKr2g97 9t3Z++vXgvnHcsU1cXdQfiWNAJpoV7p0N66Awn9yJJxP+n2LKF+1g7vkk1gkZ2hlcco2zbVq1FoTnd Kq1+DAU+g1ED0hIHLj9KRfnow47QSvPnc3E3GtLGWqIqKnDHNqPKkcdMSkOm3B6mDT3H0KPxEPrXSQ e1b3nOgGEcTvPf2Pm2gSCNuMfjkK4yrpVG4rvDniz6n+9MLWIpAAWJQjbptVRYhcyt8n75fxNua/sq zBQRxeXk3BLz5v/Hfp5qbE1czFgBcqhDqrr0pErXoP5/DINTx+J9WdEMY0DQ==
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

Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: linux-afs@lists.infradead.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/afs/internal.h | 4 ++--
 fs/afs/xattr.c    | 7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 7a72e9c60423..83014d20b6b3 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -1125,8 +1125,8 @@ extern bool afs_fs_get_capabilities(struct afs_net *, struct afs_server *,
 extern void afs_fs_inline_bulk_status(struct afs_operation *);
 
 struct afs_acl {
-	u32	size;
-	u8	data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u32, size);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 extern void afs_fs_fetch_acl(struct afs_operation *);
diff --git a/fs/afs/xattr.c b/fs/afs/xattr.c
index 7751b0b3f81d..77b3af283d49 100644
--- a/fs/afs/xattr.c
+++ b/fs/afs/xattr.c
@@ -73,16 +73,13 @@ static int afs_xattr_get_acl(const struct xattr_handler *handler,
 static bool afs_make_acl(struct afs_operation *op,
 			 const void *buffer, size_t size)
 {
-	struct afs_acl *acl;
+	struct afs_acl *acl = NULL;
 
-	acl = kmalloc(sizeof(*acl) + size, GFP_KERNEL);
-	if (!acl) {
+	if (mem_to_flex_dup(&acl, buffer, size, GFP_KERNEL)) {
 		afs_op_nomem(op);
 		return false;
 	}
 
-	acl->size = size;
-	memcpy(acl->data, buffer, size);
 	op->acl = acl;
 	return true;
 }
-- 
2.32.0

