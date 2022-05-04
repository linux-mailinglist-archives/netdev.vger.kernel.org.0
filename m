Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD6A5194EB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbiEDCAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343863AbiEDB64 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:58:56 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE50A419A7
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:53:09 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id j6so16136812pfe.13
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mP4n/1nXKyry8BA7O9b2ZHkrsFy8iWlCifKEx03rFnY=;
        b=KHTjDn10FYAC4WZ7g7q0AiHpgmThRRwNrbm62hmsBLY/2xCOlkENwcyXQ7aBQDInHn
         4dM/qCI2Tdd2RF0pF33RCRgUwHIp4H4DbO/aaCcleZepYJ5vWn77BhvgITsj4rJQjCoy
         BKAgqDEuTpx8EMb/HQ18TpUE/vAD2m0OUQRDA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mP4n/1nXKyry8BA7O9b2ZHkrsFy8iWlCifKEx03rFnY=;
        b=fnLnUnVm5RksUJxi7z1/Tk3RR/1tTt0v+bGaVDlzNgxgdYsp539I2EMW961Rpc7Hfz
         FuoyS6WkfFDJVKrPBl6WEXczd6gT0P5qBszUbw47nW31yeJi2DBeveOjgB3WpObBuI+6
         YOG6Y45Izl6bSyWuzDnR/M0AbMt8A6/Bg6PPtacV/eWHLWcsnTaXp9XWE9kpwxRcfiIW
         TWUcw8VREEbzXP/dCDK8upN9QKtEaPJQRhrlHw4eRchw7rB4V8rItI9R7TceXtpu76hr
         ThF+DxaO0nkCQe4ZqxyoGvgyUfnCWpcyYXN9W49ZdFlF2TfUOMoLMIYHqSRxtTgJbheC
         Hm5A==
X-Gm-Message-State: AOAM531cKSn9mbHrPqh94fDZEJW24e8VuVbCg1LIuzXv207Z5wml7jH9
        Sh79XoouXuzTJF3tzmM0NrFuVQ==
X-Google-Smtp-Source: ABdhPJzUSy3U+8rwgzAr/sj8yR4Fp6xF6K+q2DzcNSLrX9k+1afSBMzKvEfV6BFVNR+tlb7A2wmzdw==
X-Received: by 2002:a63:5c6:0:b0:3ab:a0ef:9711 with SMTP id 189-20020a6305c6000000b003aba0ef9711mr15918624pgf.426.1651629165641;
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b0015eb6d49679sm1918908plp.62.2022.05.03.18.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:52:45 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Johannes Berg <johannes@sipsolutions.net>,
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
Subject: [PATCH 13/32] mac80211: Use mem_to_flex_dup() with several structs
Date:   Tue,  3 May 2022 18:44:22 -0700
Message-Id: <20220504014440.3697851-14-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4296; h=from:subject; bh=pufTBCpv1+FASDh6fZcOJeIhSO8YXc6ZD3a299NrZm4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqDYrX5tu9Go+cvYwIXEOTpZneB8YhW9dUC3sac ck3ML8KJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHagwAKCRCJcvTf3G3AJq+JD/ 0X3AbEhtjv68HS2Qdhx7xmo3K/uONkt1yj8h+vION6AHfDmeZPu5bBaCsLzt2TEAHsBPpBRc/uejYa E5pfehOGAmVM9Fmpr+oP9ly2RkyPTwtNTxFzb4xd27IkVD6UCFORNFDveBYD2VZmO04Vlo9STZ2Bva Ya86oVZEXAhbCZ0AKH2Z49cpjz9VZgyDJ90DrfDKvzm96gavfrOqU0IVXkfUaaZ2QIO1JKI1ll5mvN bjuyTdXnOlMf6CsLwcLHMMb3wDPPpFe8MXv8dayu3NC1pfidvNqoPkozVAiGWacsIqIp8awptGqHH3 yZM3uXcRJhmG01Xnag1yX2F7KLQmdLxTX6Hbi08mVFLjqUHf68oJ6AVzIx7EMO+10VCaS/VKc3pV3a pK6YmhDCo4DAFS2qS/uEZXisfMRLsJ/cNqfILKDs5PJ0Es4D+au1dZbccNyNOsuJKBeugjRZ5yxcT7 MJKOMLVY1PqPEf5qN8rvFBbg71fUmT5dpnBhj5KXWGXisWBxjiXBivh+CA2Ejt0B6LRCEsIE3FDe5W KUS1oA4CkivV4K+FG1LXa3Rjg0Q3XEjfoJZfQnEJWIevZxzJmOPWarLDNgPdL+D9ql+ZHO2xZ2SL6R x2yZO7FnhS+Q3p1vFXul6o0tnRCpX7VXjQMb8yEVgGi33g8kkzRVmWX114lw==
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
allocation, bounds checking, and copying:

    struct probe_resp
    struct fils_discovery_data
    struct unsol_bcast_probe_resp_data

Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 net/mac80211/cfg.c         | 22 ++++++----------------
 net/mac80211/ieee80211_i.h | 12 ++++++------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index f1d211e61e49..355edbf41707 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -867,20 +867,16 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 			 const struct ieee80211_csa_settings *csa,
 			 const struct ieee80211_color_change_settings *cca)
 {
-	struct probe_resp *new, *old;
+	struct probe_resp *new = NULL, *old;
 
 	if (!resp || !resp_len)
 		return 1;
 
 	old = sdata_dereference(sdata->u.ap.probe_resp, sdata);
 
-	new = kzalloc(sizeof(struct probe_resp) + resp_len, GFP_KERNEL);
-	if (!new)
+	if (mem_to_flex_dup(&new, resp, resp_len, GFP_KERNEL))
 		return -ENOMEM;
 
-	new->len = resp_len;
-	memcpy(new->data, resp, resp_len);
-
 	if (csa)
 		memcpy(new->cntdwn_counter_offsets, csa->counter_offsets_presp,
 		       csa->n_counter_offsets_presp *
@@ -898,7 +894,7 @@ ieee80211_set_probe_resp(struct ieee80211_sub_if_data *sdata,
 static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 					struct cfg80211_fils_discovery *params)
 {
-	struct fils_discovery_data *new, *old = NULL;
+	struct fils_discovery_data *new = NULL, *old = NULL;
 	struct ieee80211_fils_discovery *fd;
 
 	if (!params->tmpl || !params->tmpl_len)
@@ -909,11 +905,8 @@ static int ieee80211_set_fils_discovery(struct ieee80211_sub_if_data *sdata,
 	fd->max_interval = params->max_interval;
 
 	old = sdata_dereference(sdata->u.ap.fils_discovery, sdata);
-	new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
-	if (!new)
+	if (mem_to_flex_dup(&new, params->tmpl, params->tmpl_len, GFP_KERNEL))
 		return -ENOMEM;
-	new->len = params->tmpl_len;
-	memcpy(new->data, params->tmpl, params->tmpl_len);
 	rcu_assign_pointer(sdata->u.ap.fils_discovery, new);
 
 	if (old)
@@ -926,17 +919,14 @@ static int
 ieee80211_set_unsol_bcast_probe_resp(struct ieee80211_sub_if_data *sdata,
 				     struct cfg80211_unsol_bcast_probe_resp *params)
 {
-	struct unsol_bcast_probe_resp_data *new, *old = NULL;
+	struct unsol_bcast_probe_resp_data *new = NULL, *old = NULL;
 
 	if (!params->tmpl || !params->tmpl_len)
 		return -EINVAL;
 
 	old = sdata_dereference(sdata->u.ap.unsol_bcast_probe_resp, sdata);
-	new = kzalloc(sizeof(*new) + params->tmpl_len, GFP_KERNEL);
-	if (!new)
+	if (mem_to_flex_dup(&new, params->tmpl, params->tmpl_len, GFP_KERNEL))
 		return -ENOMEM;
-	new->len = params->tmpl_len;
-	memcpy(new->data, params->tmpl, params->tmpl_len);
 	rcu_assign_pointer(sdata->u.ap.unsol_bcast_probe_resp, new);
 
 	if (old)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index d4a7ba4a8202..2e9bbfb12c0d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -263,21 +263,21 @@ struct beacon_data {
 
 struct probe_resp {
 	struct rcu_head rcu_head;
-	int len;
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
 	u16 cntdwn_counter_offsets[IEEE80211_MAX_CNTDWN_COUNTERS_NUM];
-	u8 data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 struct fils_discovery_data {
 	struct rcu_head rcu_head;
-	int len;
-	u8 data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 struct unsol_bcast_probe_resp_data {
 	struct rcu_head rcu_head;
-	int len;
-	u8 data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(u8, data);
 };
 
 struct ps_data {
-- 
2.32.0

