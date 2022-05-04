Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A975194E0
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343840AbiEDCAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343874AbiEDB64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:58:56 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9B442A12
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:53:14 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id x18so167424plg.6
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vEhg+UN+nvvIRlNnvIoleDYLxzWI/4j+AXJ2OBahvyQ=;
        b=E5bLX9p+4KMQ7dCXesW/uSO4Z3TzhqBoNV2cnwQ6UenYFaZTatAXLltuILaNWlnTeH
         ZPF9bsRL6MA89tW5PvZIMCIKWfhOmFJwJGsxRwJiF9IEfmjgBCchcmHUHUKuUjfJgzaf
         xdp24lDnEh6QoNKPI3Ft2lTJ+h48bMoBlTL80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vEhg+UN+nvvIRlNnvIoleDYLxzWI/4j+AXJ2OBahvyQ=;
        b=MznJOoMm46qrk+e1aE735ZEnxgg5qxN/VYHWBedoAzzGPALBGnFbkGtqqtYPvhfW3v
         5eSfo85tGinXAvYe2Q411L802PbagImsVv/EKXlG/7yehEnaNt5Num2Cjuvzmjfw+P4c
         htvt/L94kbMmKstBJ8kedRhWdy43nvBzRkxqGLOxxcWIW1oGXUg7hjMbVkLFWqPKMwor
         eSVVboPsW8fEpd86qKO89Kg49XI+9GkVgfvvTypkuF5FL0vXKheGlpNfSd0SWUMAiV3X
         ZSQwLA0L+WaAEvHtsfgFpxol19UJAzIhvOESW8+zfiWf9LpDW6TRlt3Er5ylp6b58jbg
         P8XA==
X-Gm-Message-State: AOAM533GO1Cp2+RfvF+gUpHc8+wu2GYlKwQAtUt4+1BE8DRCEk+fO9WB
        /xJmnNXScSm9ARNtG4Q5mQS0bQ==
X-Google-Smtp-Source: ABdhPJzI4IiRrxPSXkixkcvlB8cGm8brcWRiM4L1KUnKofXLRSVRJRXFkv6QdN0IforxNoZJSUOL5w==
X-Received: by 2002:a17:903:2d1:b0:156:7ceb:b56f with SMTP id s17-20020a17090302d100b001567cebb56fmr19656689plk.11.1651629165975;
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o1-20020a170902778100b0015e8d4eb2cbsm7014958pll.277.2022.05.03.18.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Eli Cohen <elic@nvidia.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Gross <agross@kernel.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
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
        David Howells <dhowells@redhat.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        devicetree@vger.kernel.org, Dexuan Cui <decui@microsoft.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
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
        kunit-dev@googlegroups.com,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
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
Subject: [PATCH 17/32] net/flow_offload: Use mem_to_flex_dup() with struct flow_action_cookie
Date:   Tue,  3 May 2022 18:44:26 -0700
Message-Id: <20220504014440.3697851-18-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; h=from:subject; bh=PrKJ7fngslFAVnoAR+kxxSWcyzyvUbqj4Z3UXnDbHJY=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqEQoFbddPpYBIL178hMkYpivETQV90l3JHFEnm 7J1thjCJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahAAKCRCJcvTf3G3AJtw3EA C0LNh89YqDNrcJCXsCKfSbcHlFxrq44D7OA0sCgHExo+fXdaECb+Xj3tfEkQFm9bgvn/VnNhpCwqMV U8VQzGL6UaTCr267IE8XzSzkQJ6Uu2Nn+oM8/g6gDst8U7DsXu/1M4XVa8NK32yL6cBvV8PVBTcChy j8jyHBC43g8+Lg9oLs4UB/SO8Tb2ObCEpGf+h+/rD6v1mUrkoYKhvITvEAQ6BXgJ7NMeKfMd5TbnLL n7fyJaP0DKQoiMbMCMPhOnbaBLKTz9JjJ2/U07j/wfD/U5vjQBmTOZvo7vv3sex/J3PimMP/LVVrgg rZ19XaTiGULGLnmPuJjPt4zppdXAE7bED4queSk/tjdOsuMkougu3osd+yKLNrkqDRGxwMqxHn6Adg VL64IdPA3BY3aE8mOXGUxTLKtJs1pv7lv1msRzE5gUB7RTMHQ1//cIMC8EgdL5FVxZNtm4Nrhurpsb fvUFe8jDSjzE++5RHGWvAqbIheq7tgJhhaDmUF+rUmIMNowlHUeWcz7qDRxFSgMiX+xi/ZX4sJtg/V tnoPJ9uGluYyVnNod6v2TAn0dMpQirNr3BrADN1GRZ9iYaSt2xYRiifwpxLWUpi4DIfHGqb2y4ockX o/g9MpGsEistTYeWgK8HQdvJO+YhqSNADTeBhz9hngLOsUZU3CcUlT8pVg2A==
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
Cc: Baowen Zheng <baowen.zheng@corigine.com>
Cc: Eli Cohen <elic@nvidia.com>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Simon Horman <simon.horman@corigine.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/flow_offload.h | 4 ++--
 net/core/flow_offload.c    | 7 ++-----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 021778a7e1af..ca5db457a0bc 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -190,8 +190,8 @@ enum flow_action_hw_stats {
 typedef void (*action_destr)(void *priv);
 
 struct flow_action_cookie {
-	u32 cookie_len;
-	u8 cookie[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u32, cookie_len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, cookie);
 };
 
 struct flow_action_cookie *flow_action_cookie_create(void *data,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 73f68d4625f3..e23c8d05b828 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -199,13 +199,10 @@ struct flow_action_cookie *flow_action_cookie_create(void *data,
 						     unsigned int len,
 						     gfp_t gfp)
 {
-	struct flow_action_cookie *cookie;
+	struct flow_action_cookie *cookie = NULL;
 
-	cookie = kmalloc(sizeof(*cookie) + len, gfp);
-	if (!cookie)
+	if (mem_to_flex_dup(&cookie, data, len, gfp))
 		return NULL;
-	cookie->cookie_len = len;
-	memcpy(cookie->cookie, data, len);
 	return cookie;
 }
 EXPORT_SYMBOL(flow_action_cookie_create);
-- 
2.32.0

