Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7859A519480
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245521AbiEDBzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343667AbiEDBw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:52:57 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693EA4504B
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:28 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w17-20020a17090a529100b001db302efed6so6215pjh.4
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=P7uM3xoAcE7zuGNsfEYVdWWhl8RQOVkTgxnXHqQm9tk=;
        b=Ttm1udnLhK1uzAB04KBRSr/POGM0kwPI1bs4XPEU6UEtgK8/23ubm+dxeV4+X853RT
         0+Il5Jok8kr0+FDj5VV/8TyC5lx1HeS1NOnJkl2lVk9pme8hyn7Y1lYALOBUqbtoGYi3
         cAWN4x8Bl4pcx02o/CTto17Eyhwd5u2uMzQSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P7uM3xoAcE7zuGNsfEYVdWWhl8RQOVkTgxnXHqQm9tk=;
        b=t20CbXpzdblQ22DbE4+Inf91Yq/GKNxl19fL0SPNZY3AuIi0nrJPBmb3KGyo0RCxM1
         JjgTKl2su1+bnoK7Cz5TE2fiuxHmUcKAjLMxJa20y6TjMa1Pe9JshewDhmaoiSsFpzQu
         b8tXrxOV+KwFhkIYwXJWzLkyGRHwYbZoNPj8/x2f+2Ce9xpAX0ITO/iXUct4DasSp8Q5
         GobAXmh3k3ykwyVxNDqZ22FLO3JbkWPb7Wk4sIABJWeuZf85VcXrdEa0YzGBRr/h5SJB
         PatPLqOnoh2K6ohxOb7Dyinj9W886Vo8vLlSNCfdNUG0ryjDK1Rm632tRfEGU8n0wXlN
         0wag==
X-Gm-Message-State: AOAM5326pP+d1w694e3WauzLDJhLJIVSTPc0pPjOwboGW+FcppQYbews
        A1vL00WkDocyhCNsiFszT73tUQ==
X-Google-Smtp-Source: ABdhPJxlINiFv6UJHBX+/eJqyerMOceaIDiYJHkzj2pPV40RgErLtQ31Acn4ZOqZFTEIOPf1xFj0AA==
X-Received: by 2002:a17:90b:3b42:b0:1dc:5cdf:5649 with SMTP id ot2-20020a17090b3b4200b001dc5cdf5649mr7783206pjb.239.1651628861490;
        Tue, 03 May 2022 18:47:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id on13-20020a17090b1d0d00b001d9acbc3b4esm2003067pjb.47.2022.05.03.18.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:39 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
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
Subject: [PATCH 11/32] nl80211: Use mem_to_flex_dup() with struct cfg80211_cqm_config
Date:   Tue,  3 May 2022 18:44:20 -0700
Message-Id: <20220504014440.3697851-12-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2217; h=from:subject; bh=rRfAu1/k1e5caQg21/8VBHhysNqsP1FR5GA2AHrLW6w=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqDYqJpVuI+Da24TYyn7rK2cAZcih+2ZRWaGUhg VviQcPmJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagwAKCRCJcvTf3G3AJjdwD/ 9GoZycFvhK6h6fbIQwuLO60vgqzr+JFBMz2boSXTBJSryctNsbZrwuvUuiBZUKC1y9sGE+SgzQm0T7 WzDZtyTlGmT1CZjKFpgdCfMbuMLVROkIwwyYoraeYFirZmIIRURYhLoAsJh4ZeL+hi8jOWnaV5ClMm GpAX4WW1YsM9YRJimQri0QE7pLQKGb80KxVsDgul4e0OUj1wYZTYbTgr98Zpysc1nSby6oGnxfPJ5B GvVh8QA/SYaCCMlYyUKr3bjTLrKOZ0NSnt6bAW38OpCXj8344D0TsfmO6tGo0jkheFbpEhSFjRi0Lj 1/+lxcBQ3jvc7zB+0Q5hpVWgX0kC+MxgbmIRdXF66gXOY9KMZzGl6dt9Fdm0xQWH6kFZlX7zpOBeHx To/pgX+EVE7aw6zudBInH3vlkkTYIklAIL/O9ajINZfL2HKHTp1XgnQdpa0KDyxqJilBhkXXekcKjn s7KJFzs28RJWqn+YgyJ+4W4uA6XLQvHdqVGZu5zS748KLU05KkgCeTW+Wm195aiMdUvqPG1QyqpCX5 1oMep8SXDkjOyDi6DnWcfFivJfrpKBqXU3oWsvXdBRhX+fVXmfr/E7qrARl1smC7xBgqWCcJf152Rh nwFocx9Hoo9dTUkHbkM4z/OFi36I6ENfaPOS+x9fFE1riA7xPsrh1gW6nwwA==
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

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/wireless/core.h    |  4 ++--
 net/wireless/nl80211.c | 15 ++++-----------
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 3a7dbd63d8c6..899d111993c6 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -295,8 +295,8 @@ struct cfg80211_beacon_registration {
 struct cfg80211_cqm_config {
 	u32 rssi_hyst;
 	s32 last_rssi_event_value;
-	int n_rssi_thresholds;
-	s32 rssi_thresholds[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, n_rssi_thresholds);
+	DECLARE_FLEX_ARRAY_ELEMENTS(s32, rssi_thresholds);
 };
 
 void cfg80211_destroy_ifaces(struct cfg80211_registered_device *rdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 945ed87d12e0..70df7132cce8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12096,21 +12096,14 @@ static int nl80211_set_cqm_rssi(struct genl_info *info,
 
 	wdev_lock(wdev);
 	if (n_thresholds) {
-		struct cfg80211_cqm_config *cqm_config;
+		struct cfg80211_cqm_config *cqm_config = NULL;
 
-		cqm_config = kzalloc(struct_size(cqm_config, rssi_thresholds,
-						 n_thresholds),
-				     GFP_KERNEL);
-		if (!cqm_config) {
-			err = -ENOMEM;
+		err = mem_to_flex_dup(&cqm_config, thresholds, n_thresholds,
+				      GFP_KERNEL);
+		if (err)
 			goto unlock;
-		}
 
 		cqm_config->rssi_hyst = hysteresis;
-		cqm_config->n_rssi_thresholds = n_thresholds;
-		memcpy(cqm_config->rssi_thresholds, thresholds,
-		       flex_array_size(cqm_config, rssi_thresholds,
-				       n_thresholds));
 
 		wdev->cqm_config = cqm_config;
 	}
-- 
2.32.0

