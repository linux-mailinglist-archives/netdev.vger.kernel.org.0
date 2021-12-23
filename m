Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F29F47E1FE
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347871AbhLWLIJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347870AbhLWLII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:08:08 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6B6C061401;
        Thu, 23 Dec 2021 03:08:07 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id i31so11561045lfv.10;
        Thu, 23 Dec 2021 03:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Q2sDj8vBUbZIesYQrujYlWmiKDT0P354Oapa4ONG34=;
        b=g3aYWmCexve9yEciuzZeNB9QdT9WkllhzHhrFMmmkLaHuq/k/YZdxtMhy1c8TnN0Q2
         vxh7vVZXJth6rkJWQ8nwD7112UkXMrZ067dGk1Tm3/6+JEBb5t7zHQuWCffxLeav8o+t
         dCFyYc1CRE/2T/imtoxz1YzMS9eev4Qj7BmwlUaUi78abwQGIE6ys2Iu3SLtfBLVM4z9
         Lfi4e99FutwWBVD7c9durybCIMHtAHNsimVy2ELOJtjOUShqelg+7FFAz/62H/iqhE12
         0Y2wWrT790fmU9r4R9LFOliRiGlIWhrAKsxAyT3vwx8szgON2LgHF7kqiIuMvRRQdTGu
         myZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Q2sDj8vBUbZIesYQrujYlWmiKDT0P354Oapa4ONG34=;
        b=F26K/eqpvvr77m3k7Vo+Pccb7TIziPsdLWOGwp/H8RvS2X0+URthDtjNRkYrN6Ip6a
         MZMXThkH+c30PrVdIEa05WehIl27qVg9GxocTdHIRZqRkstC8SD5RHE4K0jLcJrpi0sc
         HfMH66QLYGZi7YWi4mYfAajKuyubQrCCaLGUI776eefrA6BFa+VIOiqWK6YVrWdD2QIk
         I2qBgBtZA4RdhxW58iHVaYsaaD5ksgHY1VdkM6vwJTjQDzMEk7joOSCJWwZEibuvCiB3
         q6F6XJGpgiSL+OXljJvJh7VimEfwxKxjIBiLZr7eYsx2Lc3At41JIhOWJ8u7d6VTKEla
         A54Q==
X-Gm-Message-State: AOAM533Yfr3Yxf9yi6ACr2/yBaNxLpCYr9JhKdQ+3WB0o1daA0ndK2b3
        gDFLx7JOEr+ar2BSDAMKb6HDGgaITgc=
X-Google-Smtp-Source: ABdhPJzGNI930rsD+erY1tcIyxPvd4M5jaZyrpQINFCweZG3cd5Pkri6K8w5ykWmSOlxi2h3/EOxAw==
X-Received: by 2002:a05:6512:3b14:: with SMTP id f20mr1452307lfv.410.1640257685904;
        Thu, 23 Dec 2021 03:08:05 -0800 (PST)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id t7sm473047lfg.115.2021.12.23.03.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Dec 2021 03:08:05 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/5] nvmem: core: read OF defined NVMEM cell name from "label" property
Date:   Thu, 23 Dec 2021 12:07:52 +0100
Message-Id: <20211223110755.22722-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223110755.22722-1-zajec5@gmail.com>
References: <20211223110755.22722-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Prefer it over $nodename. Property "label" allows more fancy /
customized names with special characters.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/nvmem/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 23a38dcf0fc4..45c39ac401bd 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -685,6 +685,7 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 	struct device *dev = &nvmem->dev;
 	struct nvmem_cell_entry *cell;
 	const __be32 *addr;
+	const char *label;
 	int len;
 
 	parent = dev->of_node;
@@ -708,7 +709,11 @@ static int nvmem_add_cells_from_of(struct nvmem_device *nvmem)
 		cell->nvmem = nvmem;
 		cell->offset = be32_to_cpup(addr++);
 		cell->bytes = be32_to_cpup(addr);
-		cell->name = kasprintf(GFP_KERNEL, "%pOFn", child);
+
+		if (!of_property_read_string(child, "label", &label))
+			cell->name = kasprintf(GFP_KERNEL, "%s", label);
+		else
+			cell->name = kasprintf(GFP_KERNEL, "%pOFn", child);
 
 		addr = of_get_property(child, "bits", &len);
 		if (addr && len == (2 * sizeof(u32))) {
-- 
2.31.1

