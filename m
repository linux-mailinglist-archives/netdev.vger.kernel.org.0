Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 121D5409D91
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 21:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347698AbhIMT7y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 15:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242324AbhIMT7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 15:59:52 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF0AC061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 12:58:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id g128so3052372wma.5
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 12:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=PYlzQYdxy8VAl7peANJ4X43W5ChJ/NDaakiAE4XJJec=;
        b=lqGfGOqa+6SyURy36tWmfdAlsdJlynL1q3nVHi4BX/GfWLFK5UyNnUwV6x5kmaZBSb
         9jcpknI0tCd3iQ/LkG6QNDiDverKCpT1uNGlRrk08eLlkyyBpWR6AYA2Y459PQkBK1ey
         bM2ZfLqQ9znG8jKMgPg0LwEHplW8Du54R/BKH8a0bYMKg7pgeLCqOrvyP+LGOXuhAO6l
         kmVzbYV+QxyNafaR+xSF8PaP5Zm+MZ2E/q2dVH9Ibo+KEky6tQ0Jd+3GVeeTbVR2+oSW
         96wwbbxGNtUSibm6lBw0i+ySRQCK1fJpI2hjndTY5b/IyAjv/QPMXQQC2saFF/UUMPXw
         zevg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=PYlzQYdxy8VAl7peANJ4X43W5ChJ/NDaakiAE4XJJec=;
        b=14K+PJe0gMvc1Yrv8iby2lpe7Om/F68Nzj05mQzq49PO2CEu+4rILv+IDvfGh+jbm8
         UgYAwTwA6XIATcYJK26ifwZfQZjfqAfg9TVya6sahfBl2oEPsmjwP19q8N8RwYPlwj8U
         PHHXO7kg1KsIuTYMcIBeMbMot7f8J2lAPdDZvlQFmzMhN55gLnl+ntbyucWjx+G154cU
         +uFHVTEy/F5kqmD9twK8BN53qb8TodOdD36r4a30Nhi+dfOzoPWq2/ZOPPhIJgRdv9Wq
         YylhRLEtIqPINPZz24JfcoPARIWxlDQg+zwtOxKlWGEVBG6XuWi4cvyHNMLXgS3pf9OS
         Uclg==
X-Gm-Message-State: AOAM530gOlnLDfWQY0csdGe0zsubx2okKEWgnX0GheTTiBp6eSlAiboW
        Km7DqySRmZL8FK97DjQzxOr3HLQi5zM=
X-Google-Smtp-Source: ABdhPJyNWv1cI/UlVkBz//bDPRc7SOniATWVgCeAnFfxXL2tbRXKVm6Y+L9F0TcZaU77lel3ZV9PxA==
X-Received: by 2002:a05:600c:4f13:: with SMTP id l19mr12963506wmq.39.1631563114815;
        Mon, 13 Sep 2021 12:58:34 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:2517:8cca:49d8:dcdc? (p200300ea8f08450025178cca49d8dcdc.dip0.t-ipconnect.de. [2003:ea:8f08:4500:2517:8cca:49d8:dcdc])
        by smtp.googlemail.com with ESMTPSA id z13sm9601226wrs.90.2021.09.13.12.58.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Sep 2021 12:58:34 -0700 (PDT)
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH net-next] ethtool: prevent endless loop if eeprom size is
 smaller than announced
Message-ID: <f6b5c29f-ca07-a6a0-6e94-6b52dc56407b@gmail.com>
Date:   Mon, 13 Sep 2021 21:58:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It shouldn't happen, but can happen that readable eeprom size is smaller
than announced. Then we would be stuck in an endless loop here because
after reaching the actual end reads return eeprom.len = 0. I faced this
issue when making a mistake in driver development. Detect this scenario
and return an error.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/ioctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f2abc3152..999e2a6be 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -1537,6 +1537,10 @@ static int ethtool_get_any_eeprom(struct net_device *dev, void __user *useraddr,
 		ret = getter(dev, &eeprom, data);
 		if (ret)
 			break;
+		if (!eeprom.len) {
+			ret = -EIO;
+			break;
+		}
 		if (copy_to_user(userbuf, data, eeprom.len)) {
 			ret = -EFAULT;
 			break;
-- 
2.33.0


