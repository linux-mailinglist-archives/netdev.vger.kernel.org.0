Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20F7C5194E8
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343854AbiEDCAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343803AbiEDB6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:58:54 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9335549F07
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:53:03 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q76so10500pgq.10
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:53:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z9UACyPlKQMpsfBiUxRNSWJwLKyqQ0BVbIzFlqTVpEg=;
        b=VrQ6dmSQ7VwQQlIfvwbiI2ql0BVm4J4y9LnkKFZwetWH13cFjtZDcQhXtoigM+PS1n
         cWMsbR1tWdnyAFxVTIwv3Ub+HJcEvYJUmHiHKdd7Tvd9COj+RhcM0WyuPg5dj9PivY8a
         z6yX6sb9Wvgoc2VwmZES4MbGCx8+oyfzVBgW4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z9UACyPlKQMpsfBiUxRNSWJwLKyqQ0BVbIzFlqTVpEg=;
        b=gBKucx7Lwaj6xrrp0XdFhRzJ9fbLUiehEQeeiZ2XjZ1LhHoOVxDS9mnlfgAhvYRRPQ
         Sw2nKiXL8BwukMaF9bSwHrGEuql6XNHUnPiprEkUlhuFVkO50nd/hcSp8WtlZA6do0Nv
         Hs2qEKG/S+NMOEZpnneEWy8+w3u6b2r/3q80tApscjUtPru6VCzkxZwdmH8cLehc8PJs
         AuRReTjkXark+hqzRAUc7izdYwiIy3L30FO52HBOwqyqFrvrx60WHqhxMjKjjHwJOQne
         LZwpTTI4a+LKn8oDpBUl82WVbyhaq9Xb4uQhSW4qnKdJBaytmoKUBK8eIpsW1jF/aBPw
         d0CQ==
X-Gm-Message-State: AOAM530K1j3/84Wa77qAOyJowXgIhIj/LU3kAuRhR3Aq3SBDWQA007nU
        JWq8vNg2G6PiWRmXAQwq4/bWBP0rQuxxhQ==
X-Google-Smtp-Source: ABdhPJzVcWQGsHn59vPaROucz1ySXZ5cZciM95zHzlrdtXApKNM9/OxOMaJu00isogLV6p+6gAjquw==
X-Received: by 2002:a63:2b01:0:b0:3c2:4b0b:e1c6 with SMTP id r1-20020a632b01000000b003c24b0be1c6mr8066903pgr.288.1651629165524;
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p6-20020a170902780600b0015e8d4eb1cesm6917631pll.24.2022.05.03.18.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
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
        Juergen Gross <jgross@suse.com>,
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
        linux-usb@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        llvm@lists.linux.dev, Loic Poulain <loic.poulain@linaro.org>,
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
Subject: [PATCH 09/32] p54: Use mem_to_flex_dup() with struct p54_cal_database
Date:   Tue,  3 May 2022 18:44:18 -0700
Message-Id: <20220504014440.3697851-10-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2429; h=from:subject; bh=nMnYI58OZL/NYqqBGThX6X9At9N55AKclw2PdmxLkv8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqCpEYc7sUWDpluF0bUB90CkVbrB3/z8O0fymGg eduju0uJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHaggAKCRCJcvTf3G3AJkJoEA CB3d+CRBr1VkScrlHfbIs1LkNyymQ0HwJgl7p4QyueseREG9Mt5326Iwc7RqKF+Rn+YzyWk8dFShzv z6gbI8PNrGAqBPz5BIqLg3dYYHVK5dPPYcYrISNYxFwyXlYH5CnwM8gllN72k9RJxbWzAxh0A+60N/ jviJWlHykiM1Zhxd/qazs6ZevTYO060Zif3DN8WCX/LuwNHp30u5sclQ55oDW3betiobkSC6Ov1eP6 Hi7uDPuaVPlM2ZtdStVUbJUtmb0ddMSgxtTLjFPmzu+/igOg0pwYTovc41hbeEbBnxlRHIoUJWYLEF 9HwXpVeVj29IIka07Wj1DhYds+eo/zSM1UgogveTLy1YqauYGa0HDWQq9oUmlyE1DVBtfNlwDKfQFw abW5WTkLqlaK1bDWZEM/2f5rXJ6Qb2wLF8985KU4MwKaSdM+Jib4Npl3mdvg3RTIqLUDL5C0EsnPZd jx7VWu4NuZxHBeVOpG042kcl9h6NgrzPV4i2lneNTdK9Mf4aIUBuhXuEi0RjjZPRX5KWBWDETa+SHA xIpk2sXTFarSyRcDwvPPRN7FWxxM5y5OPAGRGPRQhj9zCDB+Eh+NAEZe1GFUTZYOWu4PHtyiVVuH0q lf+bEbHqDfX8rt+XVzeUsKcH3bW7KZvEkMLgB/C70MIwPtiUdXvWDMDbvCRw==
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

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/intersil/p54/eeprom.c | 8 ++------
 drivers/net/wireless/intersil/p54/p54.h    | 4 ++--
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/eeprom.c b/drivers/net/wireless/intersil/p54/eeprom.c
index 5bd35c147e19..bd9b3ea327b9 100644
--- a/drivers/net/wireless/intersil/p54/eeprom.c
+++ b/drivers/net/wireless/intersil/p54/eeprom.c
@@ -702,7 +702,7 @@ static int p54_convert_output_limits(struct ieee80211_hw *dev,
 static struct p54_cal_database *p54_convert_db(struct pda_custom_wrapper *src,
 					       size_t total_len)
 {
-	struct p54_cal_database *dst;
+	struct p54_cal_database *dst = NULL;
 	size_t payload_len, entries, entry_size, offset;
 
 	payload_len = le16_to_cpu(src->len);
@@ -713,16 +713,12 @@ static struct p54_cal_database *p54_convert_db(struct pda_custom_wrapper *src,
 	     (payload_len + sizeof(*src) != total_len))
 		return NULL;
 
-	dst = kmalloc(sizeof(*dst) + payload_len, GFP_KERNEL);
-	if (!dst)
+	if (mem_to_flex_dup(&dst, src->data, payload_len, GFP_KERNEL))
 		return NULL;
 
 	dst->entries = entries;
 	dst->entry_size = entry_size;
 	dst->offset = offset;
-	dst->len = payload_len;
-
-	memcpy(dst->data, src->data, payload_len);
 	return dst;
 }
 
diff --git a/drivers/net/wireless/intersil/p54/p54.h b/drivers/net/wireless/intersil/p54/p54.h
index 3356ea708d81..22bbb6d28245 100644
--- a/drivers/net/wireless/intersil/p54/p54.h
+++ b/drivers/net/wireless/intersil/p54/p54.h
@@ -125,8 +125,8 @@ struct p54_cal_database {
 	size_t entries;
 	size_t entry_size;
 	size_t offset;
-	size_t len;
-	u8 data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(size_t, len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 #define EEPROM_READBACK_LEN 0x3fc
-- 
2.32.0

