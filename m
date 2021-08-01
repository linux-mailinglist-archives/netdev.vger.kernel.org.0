Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC403DCB38
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 12:41:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhHAKlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 06:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbhHAKlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 06:41:49 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDE5C0613CF
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 03:41:40 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id u15so8670224wmj.1
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 03:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2WWj+94d/3vPbrhlJEinj3ISedWMhj8sWR62bmr9umo=;
        b=jskFl1+RI4WDC4zGvehfAKJY3UBe6UPFLXNuLJVwBHCkQx/b/AURVdbALoWiPexMTb
         bnwRavbX7ak0DNW0UfL/5s+fox17CbMPVGYUa0yR90HsfwcrIrHYPGw6oTL0WVe/chSx
         sYmhlpbh+OIAAsO+63ptsRwBjR0pqwHKb5W8RRrMmSrv8UCdTxpXDW5JhgWeVrNyxG0f
         CsGVOMiMJ+2Meb8QsVTN7c1G7VaFLx0P5UiVtbFmkvYk9sbjmA73ygPp/Eat6eKZ6Yl0
         sDUuKdEc3JcziG2IYgMgrIzQy5MJxGMAqDOmhU/kTzd5TqSwUIjCaZhuzhqmV707qsu/
         PW+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2WWj+94d/3vPbrhlJEinj3ISedWMhj8sWR62bmr9umo=;
        b=temiGbMMne/dyHIzndo9HpJSIW6lkKRAqedl7v48hC8cvmtp5eLzkutcVsRlrx0kB7
         o4pcQUsfjg/h24FBguIpn53eAaLqVJ2mMo7uO4c4EG9g2d1+YjFPN2+IQ4r3JbKBif44
         BB1c5AvrgSzKZ/3KKtUZQpJdcH1VhApgXAgl9aWs6hAwopInabkSDxRCm1E0/62SVgOO
         WRIA+PiaSDznX87/ENZ2uXrvT+MBpmiSILgyiLkl+hhFNOZN6YnSzh8e3iwzycplQXMJ
         PXya8ms+fv+UY1i7IeCO65uPajRB5XIqBxMQtc08dRCO78spoVCMT8PRnM37Pe5C4Cgv
         vLJg==
X-Gm-Message-State: AOAM530Icv6TGipV/GHX6ZXM+BChUdR8radJXKkPgw/ge1FMiA9Lellp
        NdX0wTPB8KZpxajmFjSB9nlFsQTGhshp5g==
X-Google-Smtp-Source: ABdhPJxlz6rv/aZ9ITHj5k6xfOhABRKBYFWo5NAmIEQ4YlMaC/H0d+ACjU0m28to3lQKC/dGqWksig==
X-Received: by 2002:a05:600c:3b9b:: with SMTP id n27mr12003718wms.188.1627814499006;
        Sun, 01 Aug 2021 03:41:39 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id v15sm7601751wmj.39.2021.08.01.03.41.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 03:41:38 -0700 (PDT)
Subject: [PATCH net-next 2/4] ethtool: move implementation of
 ethnl_ops_begin/complete to netlink.c
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Message-ID: <8de343c4-f34c-1f31-5be0-8ce6ca1dc19a@gmail.com>
Date:   Sun, 1 Aug 2021 12:37:39 +0200
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

In preparation of subsequent extensions to both functions move the
implementations from netlink.h to netlink.c.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 net/ethtool/netlink.c | 14 ++++++++++++++
 net/ethtool/netlink.h | 15 ++-------------
 2 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/net/ethtool/netlink.c b/net/ethtool/netlink.c
index 73e0f5b62..ac720d684 100644
--- a/net/ethtool/netlink.c
+++ b/net/ethtool/netlink.c
@@ -29,6 +29,20 @@ const struct nla_policy ethnl_header_policy_stats[] = {
 							  ETHTOOL_FLAGS_STATS),
 };
 
+int ethnl_ops_begin(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->begin)
+		return dev->ethtool_ops->begin(dev);
+	else
+		return 0;
+}
+
+void ethnl_ops_complete(struct net_device *dev)
+{
+	if (dev && dev->ethtool_ops->complete)
+		dev->ethtool_ops->complete(dev);
+}
+
 /**
  * ethnl_parse_header_dev_get() - parse request header
  * @req_info:    structure to put results into
diff --git a/net/ethtool/netlink.h b/net/ethtool/netlink.h
index 3fc395c86..077aac392 100644
--- a/net/ethtool/netlink.h
+++ b/net/ethtool/netlink.h
@@ -247,19 +247,8 @@ struct ethnl_reply_data {
 	struct net_device		*dev;
 };
 
-static inline int ethnl_ops_begin(struct net_device *dev)
-{
-	if (dev && dev->ethtool_ops->begin)
-		return dev->ethtool_ops->begin(dev);
-	else
-		return 0;
-}
-
-static inline void ethnl_ops_complete(struct net_device *dev)
-{
-	if (dev && dev->ethtool_ops->complete)
-		dev->ethtool_ops->complete(dev);
-}
+int ethnl_ops_begin(struct net_device *dev);
+void ethnl_ops_complete(struct net_device *dev);
 
 /**
  * struct ethnl_request_ops - unified handling of GET requests
-- 
2.32.0


