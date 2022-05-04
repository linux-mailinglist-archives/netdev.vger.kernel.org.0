Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AD6519466
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343587AbiEDBzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343633AbiEDBxl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:53:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD85D45AC4
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:48:41 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so2750579pjb.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hCvG0k88HO9y5mV8jIlfDaOoiV0I/JnHiEgOfadNreI=;
        b=nTykdqnni29IYFP/aKlZ1tz+wSZFndNhf6nwtWAlZtsI1+zfxgtaBvH+tz4Jq/XHTo
         7HJGSNs/F64gdmokeo6uSP6KePJfQuFps/a+uVb9CQhG7Wm+ptt1Wr19Dv7sboM4E5DX
         5fllnhK611XRrQM46REzeI6j7l3nMzBYK6UHc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hCvG0k88HO9y5mV8jIlfDaOoiV0I/JnHiEgOfadNreI=;
        b=ChReEJftM2sGYqVRIIjOMlu8koIxCyrKCQNfmfYAWcw2eAiOjuhQgTtQ2UGbV+w7bV
         L053TMmt0g/rbyAq1LEtOeOa1hjS2xMDNJasmTlli4Gerc+LBEIB6mADYqmQWjqqOM33
         Xk9dZh6e5S65sXNi3MPJwAigee1N9tJ3GamMfythwJNboq0N4XxESxz95U7zhNQ1qdpT
         WGx7R9dEm9lwUTpV2iAn1hgFzhv7WUpLj7PMZI2LK4A/jcN3iwQ2qXiOiinHLC4eDYtm
         hLfJgVCLUWrrQwmQyek8oN697E+sUUcEJs0yL9R51OPmOEj9rSisJndFLqDyleKDOnmq
         lmpw==
X-Gm-Message-State: AOAM5327CAts+TkbPO9/7r1Mqz/Tt9bcFXhn7zmBmgi9rYzH4+/Zc/SR
        Gjkws3AJwbjOflcMS11FA2Q2lg==
X-Google-Smtp-Source: ABdhPJwgYtUgRfXFStndc6tc8aWOhj34n+I6ph52sEva3s1BDogx8/opvP6kUhmqSBitrWDSodtTYw==
X-Received: by 2002:a17:90a:4581:b0:1bc:d215:8722 with SMTP id v1-20020a17090a458100b001bcd2158722mr7760505pjg.149.1651628864924;
        Tue, 03 May 2022 18:47:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id v12-20020a65568c000000b003c2f9540127sm1039683pgs.93.2022.05.03.18.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:41 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
        Xiu Jianfeng <xiujianfeng@huawei.com>
Subject: [PATCH 16/32] 802/mrp: Use mem_to_flex_dup() with struct mrp_attr
Date:   Tue,  3 May 2022 18:44:25 -0700
Message-Id: <20220504014440.3697851-17-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1997; h=from:subject; bh=OvOiYjzm/q6KNaMl+//jdZvtdGx65Whv0+J0OvbhHK4=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqE83ulc8i1Me+2H60c4+E7txzeLZOhw3piKY/N AW6WeVaJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahAAKCRCJcvTf3G3AJhJeD/ oCosU8dkvX3qhHC1w07Zs/6TYmI5gdPsPSk8ZM0TFXbvewK/h3P8F3y3Nj710vMoVm4HKj2kaEgTOk 2f2b5GE4O8jpZqRExVAK8Rw2Cf/+lieahxnXSaeHUcCSE5w7f3XjMdbU5lVFfxvOwj5yiCJ8AmC0h6 PKlej2yANnnifLBAy1vCwATP2HMjRoJK8z8V8EPZWY5Ak8cwN5N+W8aRpKReFLT56NqrSMNdex1APu dJQyH++TBuJBuyERb/vZdPxaz6qQCAzya/hpIBykyOqwSpa+BuzC5eaQePNcGDlTxES1vpgiLcnpCY ylYUXLQ+/MEaj/+FNFhQb44VMXSJW6mBxFuV9yP0MGuTLCFYQ2tjlsr0dWXoGDaFAaazyGNVjsWTdX POY6oata9LsQMBKZIVM5ROcKCdIv711ZQR5lFNVAIwLL/QUuyvkWtdQwSvdywSC8oK7xwBWlABXbox I9fjkKMnE1RYapMRtAmf2VKQ0RghvNMYTAPgLGO7OYoWbeGSQ2hIfI655r9udNZNdyoNBAjzqo0qLR QOmey3V+dlX3CiVaAbQTmtt3Nc5u/EhyJdE/xxV8TqqMA3btOXCemNQBKKIif6kQD22YoS7IRqY0J5 q1bRyY9izDrZQAwPOQpXq88UsmOMBlUHokCiJyT9thFEfc5wcLBU5JMv7gIA==
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
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/net/mrp.h | 4 ++--
 net/802/mrp.c     | 9 +++------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/net/mrp.h b/include/net/mrp.h
index 1c308c034e1a..211670bb46f2 100644
--- a/include/net/mrp.h
+++ b/include/net/mrp.h
@@ -91,8 +91,8 @@ struct mrp_attr {
 	struct rb_node			node;
 	enum mrp_applicant_state	state;
 	u8				type;
-	u8				len;
-	unsigned char			value[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(u8, len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(unsigned char, value);
 };
 
 enum mrp_applications {
diff --git a/net/802/mrp.c b/net/802/mrp.c
index 35e04cc5390c..8b9b2e685a42 100644
--- a/net/802/mrp.c
+++ b/net/802/mrp.c
@@ -257,7 +257,7 @@ static struct mrp_attr *mrp_attr_create(struct mrp_applicant *app,
 					const void *value, u8 len, u8 type)
 {
 	struct rb_node *parent = NULL, **p = &app->mad.rb_node;
-	struct mrp_attr *attr;
+	struct mrp_attr *attr = NULL;
 	int d;
 
 	while (*p) {
@@ -273,13 +273,10 @@ static struct mrp_attr *mrp_attr_create(struct mrp_applicant *app,
 			return attr;
 		}
 	}
-	attr = kmalloc(sizeof(*attr) + len, GFP_ATOMIC);
-	if (!attr)
-		return attr;
+	if (mem_to_flex_dup(&attr, value, len, GFP_ATOMIC))
+		return NULL;
 	attr->state = MRP_APPLICANT_VO;
 	attr->type  = type;
-	attr->len   = len;
-	memcpy(attr->value, value, len);
 
 	rb_link_node(&attr->node, parent, p);
 	rb_insert_color(&attr->node, &app->mad);
-- 
2.32.0

