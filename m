Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011D13E4FA8
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 00:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236969AbhHIW7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 18:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhHIW7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 18:59:36 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7F0C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 15:59:15 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id c25so17924679ejb.3
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 15:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mind.be; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uXG7ELmiZoNzLZ2pgYPQUSM9JkoNS53RPkD9vHo8gV8=;
        b=BFobs69XpLFO/a5gXkE1aVaSzmnRBd3m82uFIhFvzQnB2l+y8vpOfHEzMK0bnPxYVz
         MTGpyrwUGc5qzflkZaunjSZjxsMc2rwaaB7nDYols9T6TMf3pHD+7sBX5C5VcNfLcmE0
         LQezddntSGvGPhe8urCTeHRKuv8JamMorHKCr0L//iW7ox+71SO3X/cN3UvM0xG0t/C2
         s+QO6Zf9O7/3MR9I3PUPXVmsxE6vP/3bm38YtlAWjsfPIFkiAH9qk1YZoCr3HS5F6PD2
         NbMBq/xq1tHu8+p2iQ23zY7y16XcPNemGB9+8tnm5OibgLTUTs9S5ibKGdMUWmGJ1H+l
         8k3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uXG7ELmiZoNzLZ2pgYPQUSM9JkoNS53RPkD9vHo8gV8=;
        b=cQni3J4hFnH4r9QXHEM39NoV27Zr52zaYCdw6IHx+UCQ+58vCcOyszKUY5kmOA15aw
         NgtxAIC004kxF44uvJCqTOo5fifLBkBfgAQ4RJ8etJEmT8n27HwTXpw7uoPo9zFXSb0f
         qntVhOw6KHFRZSufiA5kRnSJ928NZPS6jcVl5CAUaTElpTJ+lUseUvkINlQkkm5ycyK1
         zOHejPmJDXii+cWDvNwpXnDT4Ip8vrS7s3PwznOpYRUcVQWaqW88S1+ZIB3RmGuO8rTI
         8r+Bk6BOtjsWQHMkNohdVi3elsw9qv5FisO9P4xyR+bLdCu9jCAIQP74IbuoQZ5lWlhJ
         KC5w==
X-Gm-Message-State: AOAM531eeziOxBNgdpTnBWQAziOUfnGAs3S4XBgMM16ONjvC4K2R6xz9
        cMAgmVMGfrCiJqWvMR96RBSPkA==
X-Google-Smtp-Source: ABdhPJwOUi6hZgQaJlBLz8kLXTLv81VXP7Qwlu3kJhPk8gXVc2SlaIZchFwK5jCe681pkPAIlcw0tg==
X-Received: by 2002:a17:906:2994:: with SMTP id x20mr9915174eje.471.1628549954366;
        Mon, 09 Aug 2021 15:59:14 -0700 (PDT)
Received: from cephalopod (168.7-181-91.adsl-dyn.isp.belgacom.be. [91.181.7.168])
        by smtp.gmail.com with ESMTPSA id i10sm8665546edf.12.2021.08.09.15.59.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 15:59:14 -0700 (PDT)
Date:   Tue, 10 Aug 2021 00:59:12 +0200
From:   Ben Hutchings <ben.hutchings@mind.be>
To:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 1/7] net: dsa: microchip: Fix ksz_read64()
Message-ID: <20210809225911.GB17207@cephalopod>
References: <20210809225753.GA17207@cephalopod>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809225753.GA17207@cephalopod>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ksz_read64() currently does some dubious byte-swapping on the two
halves of a 64-bit register, and then only returns the high bits.
Replace this with a straightforward expression.

Fixes: e66f840c08a2 ("net: dsa: ksz: Add Microchip KSZ8795 DSA driver")
Signed-off-by: Ben Hutchings <ben.hutchings@mind.be>
---
 drivers/net/dsa/microchip/ksz_common.h | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index 2e6bfd333f50..6afbb41ad39e 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -205,12 +205,8 @@ static inline int ksz_read64(struct ksz_device *dev, u32 reg, u64 *val)
 	int ret;
 
 	ret = regmap_bulk_read(dev->regmap[2], reg, value, 2);
-	if (!ret) {
-		/* Ick! ToDo: Add 64bit R/W to regmap on 32bit systems */
-		value[0] = swab32(value[0]);
-		value[1] = swab32(value[1]);
-		*val = swab64((u64)*value);
-	}
+	if (!ret)
+		*val = (u64)value[0] << 32 | value[1];
 
 	return ret;
 }
-- 
2.20.1

