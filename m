Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68833DCB39
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231786AbhHAKlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:41:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbhHAKlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:41:50 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BA8C06175F
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:41:41 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id l18so17822925wrv.5
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0VZIUu6dLplavofQc8GARE/eHYZjxQlYMRjSNgOND94=;
        b=Jqcsv0z5NXvM809recF4DcloV/kxXC4OCDjS54nP73XHQpp20GvZmDj5oy1K6IHIv7
         y03NvlLkRN+IY6dKOQGEwwWZLbc3v3dKUTWHDYzoi+eOpxAgCJwI8IIX2cIH8i+nbvr8
         Wt4W0EGhOHkh5bePvVguW8neg1xKn2jr4BWf3XivzaNcL3MeOMjY+EwIgAZyJfwFZqQC
         rjfc0zo/o6y0B1MncuDDJNSal5x/OqW+xEgT/r5rdjUAhQ/R2Aesyg/5FjLwxWS0ExN7
         q9lpxbGExUNc48jXLUKe6WcSbvVMu+9DPgw1P3pbZPXe1GwoXWl0TzhU21Cmy0KnJKQ+
         CEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0VZIUu6dLplavofQc8GARE/eHYZjxQlYMRjSNgOND94=;
        b=AvvBh0KsNqrHc//183ktJKtzfisnqMx2fQpgbtBWDpNo1Hj7SnjjQRmgLA5EA3W7n/
         I4yRWLxu5ncc+dEgh6eHAdSMYbsGSZW+Zdw7sGvcWqBaW0PAHGQ7bWPUq2jh08aqLSV+
         nXkaj49wv1n9YnloOmrew/tI4J0baqsT0EHipfhwExTmYjYI4jLxxoOD+fU7x9DlR1R/
         kOLsvkrGDdg0K5rM7P9XJjY14XnENMfQWNsWftuHuZPYWhTDjcVT693DlZLr/Des+Lln
         kQaP9HvQ8h+oQTOgCrTvo/ypvuLH86Uwmt8SwMViyaTOHIotxks2FbdoXjenqBmYOhow
         8CsQ==
X-Gm-Message-State: AOAM531x1nOFZCb+ITi2lcPmaIXXEVhGeGu1+R/iaPzIztwnHE80+xZ9
        XXPeHGsxn9ssyWpygHy+SnCgXWmpglYTnw==
X-Google-Smtp-Source: ABdhPJxTX22o6b7JYWMhJ/H4opUDN3K4oeA6TvZCs5duiPtjwnG7S9zjewaM2l5ys2e462GcAgbvuA==
X-Received: by 2002:adf:d219:: with SMTP id j25mr12309929wrh.82.1627814499995;
        Sun, 01 Aug 2021 03:41:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id l41sm7696353wmp.23.2021.08.01.03.41.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:41:39 -0700 (PDT)
Subject: [PATCH net-next 3/4] ethtool: move netif_device_present check from
 ethnl_parse_header_dev_get to ethnl_ops_begin
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Message-ID: <82cd410f-8e0e-86d1-031c-bbb43c315574@gmail.com>
Date:   Sun, 1 Aug 2021 12:40:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If device is runtime-suspended and not accessible then it may be
flagged as not present. If checking whether device is present is
done too early then we may bail out before we have the chance to
runtime-resume the device. Therefore move this check to
ethnl_ops_begin(). This is in preparation of a follow-up patch
that tries to runtime-resume the device before executing ethtool
ops.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/netlink.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index ac720d684..e628d17f5 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -31,7 +31,13 @@ const struct nla_policy ethnl_header_policy_stats[] = {
 
 int ethnl_ops_begin(struct net_device *dev)
 {
-	if (dev && dev->ethtool_ops->begin)
+	if (!dev)
+		return 0;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	if (dev->ethtool_ops->begin)
 		return dev->ethtool_ops->begin(dev);
 	else
 		return 0;
@@ -115,12 +121,6 @@ int ethnl_parse_header_dev_get(struct ethnl_req_info *req_info,
 		return -EINVAL;
 	}
 
-	if (dev && !netif_device_present(dev)) {
-		dev_put(dev);
-		NL_SET_ERR_MSG(extack, "device not present");
-		return -ENODEV;
-	}
-
 	req_info->dev = dev;
 	req_info->flags = flags;
 	return 0;
-- 
2.32.0


