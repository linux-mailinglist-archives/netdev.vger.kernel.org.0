Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B455193EC
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245675AbiEDBwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 21:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245679AbiEDBw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:52:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4F4419B3
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:47:47 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id p12so36654pfn.0
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tt+uE/qYWOs3CEanZOjmvMoORa5i/xMNqAO3DwAd5m4=;
        b=YmT1lNTRttmLRyn/WOgpT0DAFWD3BvjkOIsApwxFa4B3Com0bh2yQqIJO66Wiak8Tt
         rwU+QSbZtL4swuVhrV8kkivMWLyJT9AqfxXpJ4Lm9ZibQLMBbHjNrpcN7FDNu1QRPCS+
         uiBQnyfLBZT2SNnaE6twmHxSxmZ2FlIbgcsF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tt+uE/qYWOs3CEanZOjmvMoORa5i/xMNqAO3DwAd5m4=;
        b=0Zbdh1WNXwymmKj/O+7n/Dvz9GaPujjIBXRqFUgVvZ1gXTV+hrgeDPM//ytRDM/n0m
         MS0+FkH9whjNqKcvOcR3C4X/NgT333Xa7xH0ix4vVYPa8Sh+nXP4cE7+xqT3kppPtapj
         xhRAwtaeYwMps92daw+ndWHfhP8qG9DOzvAa5nHyKHD4UDXKXRkdlyOvEhUpkO0SE+95
         itli7XkbfgYQPgTf0c4m+ang7yYSv2yzS4YePJPCJMYoaqsP1Nr2dYWPr3h4XiIwyWs6
         7OfeSYzxOHZyn3jAdlEQZqABh4B1It3Hti7qosYFzetsNo3/NPTHfnNUQZAaMEy2EvNU
         UBGg==
X-Gm-Message-State: AOAM53141NDXNvstz+4R7kksIVwxyKFMQqPvN6W07ahUKe4PMaK3cBIO
        KSCZhlkziMR827roJLtKwyXFww==
X-Google-Smtp-Source: ABdhPJyaDNAFsbp7ZFwZAoK9Xc4UX4Pztt8PjVEG/vpKdBDmGO/KaYu31SJFp8S1HaJxz30qr/Lnug==
X-Received: by 2002:a05:6a00:1c5c:b0:505:7469:134a with SMTP id s28-20020a056a001c5c00b005057469134amr19088479pfw.16.1651628867093;
        Tue, 03 May 2022 18:47:47 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q26-20020a63505a000000b003aa8b87feb5sm13939242pgl.0.2022.05.03.18.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:47:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        linux-arm-msm@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        alsa-devel@alsa-project.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Gabbasov <andrew_gabbasov@mentor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lavr <andy.lavr@gmail.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
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
        linux-afs@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-hardening@vger.kernel.org,
        linux-hyperv@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-xtensa@linux-xtensa.org,
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
Subject: [PATCH 21/32] soc: qcom: apr: Use mem_to_flex_dup() with struct apr_rx_buf
Date:   Tue,  3 May 2022 18:44:30 -0700
Message-Id: <20220504014440.3697851-22-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1693; h=from:subject; bh=f797ezn2sQWsQcALbTjtcz0/uVJxqqsdCbEE9J5EL4c=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqFcya5M1Ba7xKOXe16qG7jIlVI8ph+ibFXwwOp nrqS7nGJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahQAKCRCJcvTf3G3AJhB6D/ 4mAanYpWDhhzP0wFox6ZgqAP9umNDzMV7dRX4Y08wPvedXkTuo/N0jclu6EdK/Bs4KaQilIZSFkLno xsM8xXSf4UqStJoT27N7DzjgnXKUJuyB5HZu1PfC+8PJ3QEnqiU5wE/l/2KdIJiAa7Xrj82dQB2cOe f9cgwxVbs3UnZy77Wv+k8FP5dMShK5yfzH0kpSd88R+/mDgZ6PLzi6zr8ZQiGCGdehQ7yp7ahiIA+i aAsDm3/+QhB0XaYdbqgAm2IAn+ouEdBPFgeXFzXqJwdi8AEfwBoByO06B8F23M3UCLdd6ZTRuaYeVQ kIZhzXstlVWDB9mIUnTP7dpfIY0lC+xzWyCLtZeT4bAvCwQB9CAAEWnSx7qfxwfOCYH1OjKUWJ+Xo4 5bWdci/vlaLQLD13TFP2X8QMY+seDM4SmnQAjgo5eITKrQ8RREz044kssPiR5qrnynNMOFWoNryxir 5TxsUJqEcElCuxyYstu2GZWqRpIeTKHVnaCu6XWtUkfQXhXikks9R9eVs6gSl+qIiVvgsVs7Tv/R9N rFtDfCJB155p3+TaJfCxSA/1e92fAlkjvrq+Ar3n/Jqs+/JGlPFT7Zy0qsgxzMjclrsboCWAvbLZZ2 OSexYpHjEn8jykFiHVbn1z48UtV3JdplNzCir+Gph+mH4axRJfHc0k7gYzyA==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Cc: Andy Gross <agross@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: linux-arm-msm@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/soc/qcom/apr.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/qcom/apr.c b/drivers/soc/qcom/apr.c
index 3caabd873322..6cf6f6df276e 100644
--- a/drivers/soc/qcom/apr.c
+++ b/drivers/soc/qcom/apr.c
@@ -40,8 +40,8 @@ struct packet_router {
 
 struct apr_rx_buf {
 	struct list_head node;
-	int len;
-	uint8_t buf[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(int, len);
+	DECLARE_FLEX_ARRAY_ELEMENTS(uint8_t, buf);
 };
 
 /**
@@ -162,7 +162,7 @@ static int apr_callback(struct rpmsg_device *rpdev, void *buf,
 				  int len, void *priv, u32 addr)
 {
 	struct packet_router *apr = dev_get_drvdata(&rpdev->dev);
-	struct apr_rx_buf *abuf;
+	struct apr_rx_buf *abuf = NULL;
 	unsigned long flags;
 
 	if (len <= APR_HDR_SIZE) {
@@ -171,13 +171,9 @@ static int apr_callback(struct rpmsg_device *rpdev, void *buf,
 		return -EINVAL;
 	}
 
-	abuf = kzalloc(sizeof(*abuf) + len, GFP_ATOMIC);
-	if (!abuf)
+	if (mem_to_flex_dup(&abuf, buf, len, GFP_ATOMIC))
 		return -ENOMEM;
 
-	abuf->len = len;
-	memcpy(abuf->buf, buf, len);
-
 	spin_lock_irqsave(&apr->rx_lock, flags);
 	list_add_tail(&abuf->node, &apr->rx_list);
 	spin_unlock_irqrestore(&apr->rx_lock, flags);
-- 
2.32.0

