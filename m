Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F352D118
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 13:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbiESLEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 07:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiESLEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 07:04:01 -0400
X-Greylist: delayed 473 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 19 May 2022 04:03:57 PDT
Received: from azure-sdnproxy-2.icoremail.net (azure-sdnproxy.icoremail.net [52.175.55.52])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 029AB5C347;
        Thu, 19 May 2022 04:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pku.edu.cn; s=dkim; h=Received:From:To:Cc:Subject:Date:
        Message-Id; bh=pYmFxl5EX9FT7BHXjR4DHU5ZJgyGAjXjcQaIbNKJXKE=; b=Q
        QGH5HTEz3arrj+Cgu4Iiy2c3lD4z54VgmsnOKBmRA5CrmGu/N23RBP6CkjU+O3Pf
        OJeE6UrdJrDrZ1FRplmI8zdl2ydfLmGO9B4KtJ90yNub4ZFMEt606Acl/xEGx22j
        MC1XGBFKs0muU1ROz3rN8Phf29SAPw1DhrwTViXBhc=
Received: from localhost (unknown [10.129.21.144])
        by front01 (Coremail) with SMTP id 5oFpogD3_6fvIYZi3ip+Bw--.21549S2;
        Thu, 19 May 2022 18:54:39 +0800 (CST)
From:   Yongzhi Liu <lyz_cs@pku.edu.cn>
To:     amitkarwar@gmail.com, ganapathi017@gmail.com,
        sharvari.harisangam@nxp.com, huxinming820@gmail.com,
        kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, arend.vanspriel@broadcom.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fuyq@stu.pku.edu.cn,
        Yongzhi Liu <lyz_cs@pku.edu.cn>
Subject: [PATCH v2] iio: vadc: Fix potential dereference of NULL pointer
Date:   Thu, 19 May 2022 03:54:34 -0700
Message-Id: <1652957674-127802-1-git-send-email-lyz_cs@pku.edu.cn>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: 5oFpogD3_6fvIYZi3ip+Bw--.21549S2
X-Coremail-Antispam: 1UD129KBjvJXoW7urWfuFyktr18KrWxGryfJFb_yoW8CF43pa
        yktayrKry2ka1fJ3WftFWDXryaqw42q3yUGFWxJ3W3Ar43trnYyw1aqw1FkFn7uFWxC3ya
        yr4YyFnYgr4Dur7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9F1xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2
        z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcV
        Aq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j
        6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64
        vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxkIecxE
        wVCm-wCF04k20xvY0x0EwIxGrwCF04k20xvE74AGY7Cv6cx26w4UJr1UMxC20s026xCaFV
        Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
        x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
        1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
        JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
        sGvfC2KfnxnUUI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: irzqijirqukmo6sn3hxhgxhubq/1tbiAwELBlPy7vJhCwADsb
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The return value of vadc_get_channel() needs to be checked
to avoid use of NULL pointer. Fix this by adding the null
pointer check on prop.

Fixes: 0917de94c ("iio: vadc: Qualcomm SPMI PMIC voltage ADC driver")

Signed-off-by: Yongzhi Liu <lyz_cs@pku.edu.cn>
---
 drivers/iio/adc/qcom-spmi-vadc.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/qcom-spmi-vadc.c b/drivers/iio/adc/qcom-spmi-vadc.c
index 34202ba..9fa61fb 100644
--- a/drivers/iio/adc/qcom-spmi-vadc.c
+++ b/drivers/iio/adc/qcom-spmi-vadc.c
@@ -358,14 +358,25 @@ static int vadc_measure_ref_points(struct vadc_priv *vadc)
 	vadc->graph[VADC_CALIB_ABSOLUTE].dx = VADC_ABSOLUTE_RANGE_UV;
 
 	prop = vadc_get_channel(vadc, VADC_REF_1250MV);
+	if (!prop) {
+		dev_err(vadc->dev, "Please define 1.25V channel\n");
+		ret = -ENODEV;
+		goto err;
+	}
 	ret = vadc_do_conversion(vadc, prop, &read_1);
 	if (ret)
 		goto err;
 
 	/* Try with buffered 625mV channel first */
 	prop = vadc_get_channel(vadc, VADC_SPARE1);
-	if (!prop)
+	if (!prop) {
 		prop = vadc_get_channel(vadc, VADC_REF_625MV);
+		if (!prop) {
+			dev_err(vadc->dev, "Please define 0.625V channel\n");
+			ret = -ENODEV;
+			goto err;
+		}
+	}
 
 	ret = vadc_do_conversion(vadc, prop, &read_2);
 	if (ret)
@@ -381,11 +392,21 @@ static int vadc_measure_ref_points(struct vadc_priv *vadc)
 
 	/* Ratiometric calibration */
 	prop = vadc_get_channel(vadc, VADC_VDD_VADC);
+	if (!prop) {
+		dev_err(vadc->dev, "Please define VDD channel\n");
+		ret = -ENODEV;
+		goto err;
+	}
 	ret = vadc_do_conversion(vadc, prop, &read_1);
 	if (ret)
 		goto err;
 
 	prop = vadc_get_channel(vadc, VADC_GND_REF);
+	if (!prop) {
+		dev_err(vadc->dev, "Please define GND channel\n");
+		ret = -ENODEV;
+		goto err;
+	}
 	ret = vadc_do_conversion(vadc, prop, &read_2);
 	if (ret)
 		goto err;
-- 
2.7.4

