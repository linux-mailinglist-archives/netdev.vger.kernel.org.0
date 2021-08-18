Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2273F0B7C
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 21:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhHRTIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 15:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233277AbhHRTH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 15:07:58 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1743EC0613CF;
        Wed, 18 Aug 2021 12:07:22 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f5so5040137wrm.13;
        Wed, 18 Aug 2021 12:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=viCiWeLBgQYfYhWjpq4wMjdK20Zi2YY4mho1UtETxPw=;
        b=uk60/DRuP/r3It+7pa7c41w2H9nMbhocOBvWM2PzNNbRtyh82mKxX+ZwhX/rj9GSpH
         +3cuhdvkU39CeZujkSXqkz2LBGJFso0997z9PiU2KkILDTm01XPYaxjKy5JW5psJTN7L
         jiO5jkHxoTfPg5lBqc1umGWjuWX63VKaOoXUZ2p2pA8aR3OwrwKZTAVaw0CQLHDrgv4C
         Jj1L4aqXdX+lopaf8kNy4fmyg8WDD3sgmfrVqH3I0O7Qzel+a7dVyh1mM2vFA/vwUnNN
         ZwhJ6HMYftMzs9Wk2c7ZkTXz5tzqoNwGBH0H72Si8B9syMfkVwH8NM0sKUZIQN3Yahmz
         1+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=viCiWeLBgQYfYhWjpq4wMjdK20Zi2YY4mho1UtETxPw=;
        b=B/GuiMn2aovvGC8rgXgXWkPW+m/lu6WLxEQflMjWVoINBeRgMq7o1HvrItwtFSzW5Z
         vRZSxbfDqDpphptCE44a1R24cnJlNLLs/NZsgXZrOxjPLQuaE880kwEeM6QVFa+LS42A
         X+BW3FM3oF+/Is6AbehuBGywTVrVqQLpV1lX6/NMlp2Zoh/3kDnD279lPIXYIrxWpBRu
         r1kh0bZMVeIar+2EDZx9AGyAXx5QKlKpqISmX2rCDRKimPM5nUCl2CuxjfRIlG9hPQHs
         mStg8g7DcsBTCgERX27VhZtl5NUHgoEFSw/1TMNtXWMw8lpGIs6h/T0j5j+SlIPVwGOi
         SYOQ==
X-Gm-Message-State: AOAM533c3uryRMbsyFqFHGxYXJz+bsiux2I5p9twP6G+YB579rtDsSqs
        OUi3kEEMse84FHONYB2sUIqD2n6Y54Ohcw==
X-Google-Smtp-Source: ABdhPJwNK9wSwLji9YDtIe/ymlZz5bAhR385bB7wrMSefPHfNrn00T0PmbsT6wgPcdSSRqPlq1G0pQ==
X-Received: by 2002:a5d:58d2:: with SMTP id o18mr12328384wrf.277.1629313640512;
        Wed, 18 Aug 2021 12:07:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5c16:403a:870d:fceb? (p200300ea8f0845005c16403a870dfceb.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5c16:403a:870d:fceb])
        by smtp.googlemail.com with ESMTPSA id i8sm5956419wma.7.2021.08.18.12.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 12:07:20 -0700 (PDT)
Subject: [PATCH 7/8] tg3: Use new function pci_vpd_check_csum
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Message-ID: <7297fce9-47db-3b86-366e-10b9ef43beaf@gmail.com>
Date:   Wed, 18 Aug 2021 21:05:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use new VPD API function pci_vpd_check_csum() to simplify the code.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/broadcom/tg3.c | 31 ++++-------------------------
 1 file changed, 4 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index fd4522c81..309aec742 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -13010,33 +13010,10 @@ static int tg3_test_nvram(struct tg3 *tp)
 	if (!buf)
 		return -ENOMEM;
 
-	i = pci_vpd_find_tag((u8 *)buf, len, PCI_VPD_LRDT_RO_DATA);
-	if (i > 0) {
-		j = pci_vpd_lrdt_size(&((u8 *)buf)[i]);
-		if (j < 0)
-			goto out;
-
-		if (i + PCI_VPD_LRDT_TAG_SIZE + j > len)
-			goto out;
-
-		i += PCI_VPD_LRDT_TAG_SIZE;
-		j = pci_vpd_find_info_keyword((u8 *)buf, i, j,
-					      PCI_VPD_RO_KEYWORD_CHKSUM);
-		if (j > 0) {
-			u8 csum8 = 0;
-
-			j += PCI_VPD_INFO_FLD_HDR_SIZE;
-
-			for (i = 0; i <= j; i++)
-				csum8 += ((u8 *)buf)[i];
-
-			if (csum8)
-				goto out;
-		}
-	}
-
-	err = 0;
-
+	err = pci_vpd_check_csum(buf, len);
+	/* go on if no checksum found */
+	if (err == 1)
+		err = 0;
 out:
 	kfree(buf);
 	return err;
-- 
2.32.0


