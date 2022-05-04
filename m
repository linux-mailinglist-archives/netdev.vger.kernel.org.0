Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 200155194DA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 03:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343839AbiEDCAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 22:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343763AbiEDB6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 21:58:46 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3EA4993A
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 18:52:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id bo5so20552pfb.4
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 18:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tkQJNMDRPVcNM81JGzyx6JZrZP+sXh6Sgsv2ZLlrcME=;
        b=TYzsMmP+/eI9TqO4+QAx6yxqi3QYWePclkTlbFjhG/HlibMiAybufg/zrz+rLu5OQM
         GYSNJAX6L87NNLI9qdgxro62vFxqE/fqrqJQw8CwHhp/9rH1kcR4jgxtvHzWUzWEYP1/
         vfXC+WsSf1WXNAAHPYjXFPor5Evr5tOPUQrMM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tkQJNMDRPVcNM81JGzyx6JZrZP+sXh6Sgsv2ZLlrcME=;
        b=5Z0exPEUwtttABJ3WYtK7mVFhaoucGfp/2EzIzmpAcq32XJkvhZbeDI6nefwqmLGTf
         heQcjfSme8kc3Cmo4rMZHKVdy2VDRIrNg2F4xFigmTwVaNjQZMiEw367wM/Wj/suw3+q
         j0gB8q+oYFUOl9kDHmGDNt4dAronIysG7ICDmK+T5oXwqe2/sUjVZDp21LcrzzPC+RAg
         Fkawtp/cSC3ce/1iRFPd5OmX8heKEQChc82PeEtQOCPS1cn3rRV2mnA+ZHJGZlxDBSBz
         C17K8KH6BnuHyITAceSRYIE162BdYSSWs1omTI+8BGqp892TTCb3FAtN7zwFwMrjxL9J
         stiQ==
X-Gm-Message-State: AOAM5310Mg8qCIGGKeilBNrqErEQJMvHVCgIr9Dpb/t333+tnmj9VgxP
        6YQ2MfYDZMdLJGyU0y/+xv4NSA==
X-Google-Smtp-Source: ABdhPJzd2GOAjzGn3dHyifeB61yC1hzuZZRMfExezpGzXB0ryyiVV1/iB3lQu0jt+CvyiQCWH3gZ9w==
X-Received: by 2002:a05:6a00:1307:b0:4b0:b1c:6fd9 with SMTP id j7-20020a056a00130700b004b00b1c6fd9mr18835684pfu.27.1651629164498;
        Tue, 03 May 2022 18:52:44 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902c2c600b0015e8d4eb250sm6979470pla.154.2022.05.03.18.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 18:52:44 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A . R . Silva" <gustavoars@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, alsa-devel@alsa-project.org,
        Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
        Lee Jones <lee.jones@linaro.org>,
        Leon Romanovsky <leon@kernel.org>,
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
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Nathan Chancellor <nathan@kernel.org>, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
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
        Tom Rix <trix@redhat.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        wcn36xx@lists.infradead.org, Wei Liu <wei.liu@kernel.org>,
        xen-devel@lists.xenproject.org,
        Xiu Jianfeng <xiujianfeng@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 20/32] ASoC: sigmadsp: Use mem_to_flex_dup() with struct sigmadsp_data
Date:   Tue,  3 May 2022 18:44:29 -0700
Message-Id: <20220504014440.3697851-21-keescook@chromium.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220504014440.3697851-1-keescook@chromium.org>
References: <20220504014440.3697851-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; h=from:subject; bh=6F6KuGFShxf4JxPYrPXKFZeMoWxJdOn30za8QMiNMmc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBicdqFlVM0+m4mgxXYHmim1KeQeXuOmDGRSbqn4CM/ nO+6V12JAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYnHahQAKCRCJcvTf3G3AJlsGD/ wObp4TF0rjxUnDl2XU/AX62Kx0wgUSNaGDsaAeFZLHsspTJNlI1xRmKN2zRi+snj0mrEhw1q9Yh76Z 6xSGswQmdh9uemezB9oVUp2GxxN8WyMWOAR+OlnbPY//H6lChfwlnFARSS1Rkb2ZmcX//rZQZhHCXc svCtT3KSBt+VremyDJs9eQY7zKQWSEjl94vDal0JxS0GbWRYV672gtwgzYHATTiXJfZNK9Hnh5x9cI gP5/UtCpxOgh6ebk6PFJurz7rwB5cHVPIkhz8fgbd1cA/0ybs2wrCYj6JpgihAXuZtV18lAdnt8ND/ zB2f7mC3x32cU4603jCCh3lhtKY74eDhUyxc2qxDVBIyLoOufW0rNL12ZmPb/ZqzHlvwvJRNsgVIeo SLXEWPzSRWl4K2DFX2+37Xle5LxGv8rC5oIP/GCWXKXR98j60QjzBdcMWXTL+hc6sVS7VKBDtIDKQO bT+6D7J9MgSyuvsB8QDDWA1XfDXpj4PrZoT1fpgmZGGO+E9p7LhEd5TGmvmWF4EiqePthKxEq+ytkN iIM2UomARrjFWKhMiO7lt831EjVuWu1bB4+YBjMve73RZhWrYBTG1Fi4daezhQ+AyJvye8gqJgbfNu RIcWAmcfFgGhsp4VDM+sRhA/KybFzkFbvrxBwlwAx/rdq4RJkgf/AFGMfR9g==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Type: text/plain; charset=UTF-8
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

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: "Nuno Sá" <nuno.sa@analog.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 sound/soc/codecs/sigmadsp.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/codecs/sigmadsp.c b/sound/soc/codecs/sigmadsp.c
index b992216aee55..648bdc73c5d9 100644
--- a/sound/soc/codecs/sigmadsp.c
+++ b/sound/soc/codecs/sigmadsp.c
@@ -42,8 +42,8 @@ struct sigmadsp_data {
 	struct list_head head;
 	uint32_t samplerates;
 	unsigned int addr;
-	unsigned int length;
-	uint8_t data[];
+	DECLARE_FLEX_ARRAY_ELEMENTS_COUNT(unsigned int, length);
+	DECLARE_FLEX_ARRAY_ELEMENTS(uint8_t, data);
 };
 
 struct sigma_fw_chunk {
@@ -263,7 +263,7 @@ static int sigma_fw_load_data(struct sigmadsp *sigmadsp,
 	const struct sigma_fw_chunk *chunk, unsigned int length)
 {
 	const struct sigma_fw_chunk_data *data_chunk;
-	struct sigmadsp_data *data;
+	struct sigmadsp_data *data = NULL;
 
 	if (length <= sizeof(*data_chunk))
 		return -EINVAL;
@@ -272,14 +272,11 @@ static int sigma_fw_load_data(struct sigmadsp *sigmadsp,
 
 	length -= sizeof(*data_chunk);
 
-	data = kzalloc(sizeof(*data) + length, GFP_KERNEL);
-	if (!data)
+	if (mem_to_flex_dup(&data, data_chunk->data, length, GFP_KERNEL))
 		return -ENOMEM;
 
 	data->addr = le16_to_cpu(data_chunk->addr);
-	data->length = length;
 	data->samplerates = le32_to_cpu(chunk->samplerates);
-	memcpy(data->data, data_chunk->data, length);
 	list_add_tail(&data->head, &sigmadsp->data_list);
 
 	return 0;
-- 
2.32.0

