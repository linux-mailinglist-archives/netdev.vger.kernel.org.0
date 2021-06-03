Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9208839995B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 06:50:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFCEwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 00:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhFCEwI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 00:52:08 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A8DC061756;
        Wed,  2 Jun 2021 21:50:07 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id p20so5453723ljj.8;
        Wed, 02 Jun 2021 21:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PMkoIgykrLxKf1BVjDSZxKW8LJf0Zsrl2rpAZilwckI=;
        b=qPtMwgZPykmzU0IQ4Q8WNo09olOm3BkywOwwMd/B3jiVJcB4mDps+6JJRqmYwyhFF/
         Bmmve3oavc5VXdywYoZAlDcqgXKwhjYvlE9Bu3AGU6KK71i1m3b1cHtUdJztwRS5X05P
         nEcOUIO0/mBR/qpw2FlK5kFziC0RIJpxp4vc7cisqwPJx3XbKZ9mweyjaJ0cwFm2sVvK
         YvDBYI/ouHAyardvK86QubN4ZGF9AiCiBZG27NHf0+Wfi7jeUPBXHeA7x5BX+eFcj1S6
         6yZYUfLBI+SBzLMVzV5y6ZuyXRPyC+gpc5GNPdZcsMFePPzWZ/zhD/uwy5rZqBeoam5l
         Tppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PMkoIgykrLxKf1BVjDSZxKW8LJf0Zsrl2rpAZilwckI=;
        b=G3pQ6Sg9wFptVPCjbOOa2szWGbziaWQ0r63HG/krjZ8be9voK42qFxMBxzs850hKbn
         BxAtF++8bjNdRGPxcmU/ZxId884dudQDMcMEukEXHCHbB8Z/ViWR4uZKZTYxK/qx1svu
         qGSgJLanaiINQ1AqsdTttgB4tVoaT736pLEBfMJx8uly5PVyWnjinSRHUjkHU43yryiK
         3yy1KAKtQ4gGAp2KQQii84guYCAOMCKh0jW0ZUOu7guhA4jndEfsGjf3PR0NIuNlbf95
         MBWEtuodNPPRmd6fF0go6inpPXOM/G8ceBIIEjBVYvS5/FVvFALO0dNCRt6fstteYPZj
         IJSA==
X-Gm-Message-State: AOAM532SIr/Ukl9lshW9rCA6VP8BDC+n+UlEZmgqMWyK2uJwuixeAijp
        RAahFoqTTiuelUSWLZHD3go=
X-Google-Smtp-Source: ABdhPJxrQYuTfTewbIIEDOKB5JbVPNslaAhZpQumZGikRou//p9oyGs8n0szLM8kbAyNBlumAbUHAA==
X-Received: by 2002:a2e:89d7:: with SMTP id c23mr28046893ljk.318.1622695805979;
        Wed, 02 Jun 2021 21:50:05 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id z2sm191328lfe.229.2021.06.02.21.50.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 21:50:05 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        Loic Poulain <loic.poulain@linaro.org>
Cc:     M Chetan Kumar <m.chetan.kumar@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 3/6] rtnetlink: fill IFLA_PARENT_DEV_NAME on link dump
Date:   Thu,  3 Jun 2021 07:49:51 +0300
Message-Id: <20210603044954.8091-4-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
References: <20210603044954.8091-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return a parent device using the FLA_PARENT_DEV_NAME attribute during
links dump. This should help a user figure out which links belong to a
particular HW device. E.g. what data channels exists on a specific WWAN
modem.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 net/core/rtnetlink.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 56ac16abe0ba..120887c892de 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1819,6 +1819,11 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_fill_prop_list(skb, dev))
 		goto nla_put_failure;
 
+	if (dev->dev.parent &&
+	    nla_put_string(skb, IFLA_PARENT_DEV_NAME,
+			   dev_name(dev->dev.parent)))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.26.3

