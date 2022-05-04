Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438C851946D
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343791AbiEDByO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:54:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240872AbiEDBwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:52:30 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F133643AE5
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id i17so148061pla.10
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jHmaho/x33MqcwhAHjzMaEbYW3Sn2ucNcqc26yK2kNU=;
        b=P8OaWDj1i9vMS2YXwPGohhK4T/Iw+CyPZ/W6hEEhH6k1LaC96jgeOuZ+dQGCL7k52R
         9vedbYNUSwVa5cTgkoS7mq60UIXNgrNEh8xt0xCvSUKOkKMHizwfjhRvtgim24nhUgRa
         9onXSvEkUpL1rmnA+09r2XcsNzTJwLrKjOBuk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jHmaho/x33MqcwhAHjzMaEbYW3Sn2ucNcqc26yK2kNU=;
        b=DwBDAPE3qUtKhB23hQ/wllBBNgpTtYEpvw/djq3i17gHBA6yzUEvBZ44A2MGSdF/4L
         OU8357OmDNfilXC/jWUie72sinu76SKEHlZFIH5P8R2+TiHsosUHmo8D75mL9CGiu6pu
         490rJGL2DWL40NM9CVC9zbqyX3ePgZpOn9aA8rGy++EgyaBY+gya988qHJc670uyYJwy
         PnjB4HNIKMWL3Vnau9IN/ee6ZV42TckYdsaIY39h/ACbdD5ylWcUBEpiJ15jWudMtD6Y
         gKLhN+NJSZ9NJGOwX+DIYycLPl8Og0UrzNteYQRrYjAmNzgZTY1Xoy/AwTfIZhqBFWML
         rzEA==
X-Gm-Message-State: AOAM5312fg/GDCiWBbOWolwnobwmdI1+WeO33TH4z+t9+LpXdTQQbxVL
        y9CAfcyNgHX1ud9Mxhl8EZunFQs8LK44cg==
X-Google-Smtp-Source: ABdhPJw/YslU2yUBia+w/4PurFJMBiRJ5IDYAc+d7ObCpClWIglgELelEBFuL7QqIQfyj8Do+oUJyg==
X-Received: by 2002:a17:903:248:b0:155:e660:b774 with SMTP id j8-20020a170903024800b00155e660b774mr19737712plh.174.1651628859441;
        Tue, 03 May 2022 18:47:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x5-20020aa79a45000000b004fa743ba3f9sm7108890pfj.2.2022.05.03.18.47.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:39 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: [PATCH 12/32] cfg80211: Use mem_to_flex_dup() with struct cfg80211_bss_ies
Date:   Tue,  3 May 2022 18:44:21 -0700
Message-Id: <20220504014440.3697851-13-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4271; h=from:subject; bh=zLIoLyad9bBq8i+CHRJcAMhW5JgPaoyM4x0VIL3Wjf8=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqDR3XqoFSprf0Mf1o1HYj7dBBBP7wDZ118xdTx ToM0RNGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagwAKCRCJcvTf3G3AJpDCD/ wMlRRCUB8XTmCXlLdvPCGb5ACTTMa3Km0myBmfsx6i7FkHxAEfNtllJsJZ1xGdv/WP8g4XEUJ0zuGC 7wsRbPVl7sHYNyFiAu9iXMMSYvJVG0G1YrRXdH2A3UhX8o4+JfEVNj7XazhRyhM9cIwvTR0hQBUIKJ OO0TtkviYxesRpL1xBvgYIcCWjxEvNdpsGjAfF7Wn6Ml1dOstypUTb2ulq7hIf7BX8w63KuqOXZx6V eQKW4gi3cQO3gPoEWsv9zeDktQzxWbaMN212KDtDCB76/UH1i+QQg8eLLlaSQ/55nnf45kUX75sHkI zDmnUC7uL8hJaFE7/98/TeYKsLAgbyP1/MwzniEWgtSaLkPJj+BDTLhK4+jBB7zxpXsyQsyJXmfWnN 69jBTE8Z6ldaOWiCaA2dwzQcHNWXsHvzTspOWk/Tiv7AIUHd8Nqe4ecJtsbDBBxQU21ogSn3TNlfat 3ZCTfW1XDttiZNSK2Rit27Gb0LCzE4nKpVwxT5qmFoGk/jjq2ZfP1uWkMyv4TOb/bfGw5ZiXtTJwtA 22mI6CUOQ9lCD1lIB2WdB8z0yibGypy9fbuDpeqzg6v+weYYD4cY0Q38ZtkdzpABByyOAlmZm7iXIU /hIQA44hD8/vgfuYEgBfavnXALP3koZt6viHAklNZAsuY6wiAG9ZgR2ZT8XQ==
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
Cc: Eric Dumazet <edumazet@google.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/cfg80211.h |  4 ++--
 net/wireless/scan.c    | 21 ++++++---------------
 2 files changed, 8 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 68713388b617..fa236015f6ef 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2600,9 +2600,9 @@ struct cfg80211_inform_bss {
 struct cfg80211_bss_ies {
 	u64 tsf;
 	struct rcu_head rcu_head;
-	int len;
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
 	bool from_beacon;
-	u8 data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 /**
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 4a6d86432910..9f53d05c6aaa 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1932,7 +1932,7 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 				gfp_t gfp)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
-	struct cfg80211_bss_ies *ies;
+	struct cfg80211_bss_ies *ies = NULL;
 	struct ieee80211_channel *channel;
 	struct cfg80211_internal_bss tmp = {}, *res;
 	int bss_type;
@@ -1978,13 +1978,10 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 	 * override the IEs pointer should we have received an earlier
 	 * indication of Probe Response data.
 	 */
-	ies = kzalloc(sizeof(*ies) + ielen, gfp);
-	if (!ies)
+	if (mem_to_flex_dup(&ies, ie, ielen, gfp))
 		return NULL;
-	ies->len = ielen;
 	ies->tsf = tsf;
 	ies->from_beacon = false;
-	memcpy(ies->data, ie, ielen);
 
 	switch (ftype) {
 	case CFG80211_BSS_FTYPE_BEACON:
@@ -2277,7 +2274,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
 	size_t new_ie_len;
-	struct cfg80211_bss_ies *new_ies;
+	struct cfg80211_bss_ies *new_ies = NULL;
 	const struct cfg80211_bss_ies *old;
 	u8 cpy_len;
 
@@ -2314,8 +2311,7 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	if (!new_ie)
 		return;
 
-	new_ies = kzalloc(sizeof(*new_ies) + new_ie_len, GFP_ATOMIC);
-	if (!new_ies)
+	if (mem_to_flex_dup(&new_ies, new_ie, new_ie_len, GFP_ATOMIC))
 		goto out_free;
 
 	pos = new_ie;
@@ -2333,10 +2329,8 @@ cfg80211_update_notlisted_nontrans(struct wiphy *wiphy,
 	memcpy(pos, mbssid + cpy_len, ((ie + ielen) - (mbssid + cpy_len)));
 
 	/* update ie */
-	new_ies->len = new_ie_len;
 	new_ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	new_ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control);
-	memcpy(new_ies->data, new_ie, new_ie_len);
 	if (ieee80211_is_probe_resp(mgmt->frame_control)) {
 		old = rcu_access_pointer(nontrans_bss->proberesp_ies);
 		rcu_assign_pointer(nontrans_bss->proberesp_ies, new_ies);
@@ -2363,7 +2357,7 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 				      gfp_t gfp)
 {
 	struct cfg80211_internal_bss tmp = {}, *res;
-	struct cfg80211_bss_ies *ies;
+	struct cfg80211_bss_ies *ies = NULL;
 	struct ieee80211_channel *channel;
 	bool signal_valid;
 	struct ieee80211_ext *ext = NULL;
@@ -2442,14 +2436,11 @@ cfg80211_inform_single_bss_frame_data(struct wiphy *wiphy,
 		capability = le16_to_cpu(mgmt->u.probe_resp.capab_info);
 	}
 
-	ies = kzalloc(sizeof(*ies) + ielen, gfp);
-	if (!ies)
+	if (mem_to_flex_dup(&ies, variable, ielen, gfp))
 		return NULL;
-	ies->len = ielen;
 	ies->tsf = le64_to_cpu(mgmt->u.probe_resp.timestamp);
 	ies->from_beacon = ieee80211_is_beacon(mgmt->frame_control) ||
 			   ieee80211_is_s1g_beacon(mgmt->frame_control);
-	memcpy(ies->data, variable, ielen);
 
 	if (ieee80211_is_probe_resp(mgmt->frame_control))
 		rcu_assign_pointer(tmp.pub.proberesp_ies, ies);
-- 
2.32.0

