Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 833043BEBB4
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 17:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232097AbhGGP71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 11:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbhGGP70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 11:59:26 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EE3C061574;
        Wed,  7 Jul 2021 08:56:46 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id f20so2585037pfa.1;
        Wed, 07 Jul 2021 08:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjs60eTmFylT6zlXhuolFL93YMY2z/i7m9j2AIBEDZA=;
        b=BO/yGi0dKV1ujG/AidQDFg1jrW4oL8Krq+3DlvsnIdI0YPafwXTEE+2jftQFPA3VP3
         y0AEvf/ySQUxFWF0Tup2njvy0LPYVWEP8BlwJkzKu7viFhOkhvVByeLTpGfIPdPZ+4SC
         3xmkdcDh1FsviVX8DnF851C3cRpa10WkahClM+M5BIlGJy6FAC3RFEfr4qJgPThK/w1Y
         5hwRC6/QYkKHIDr3ihkv8FHSB/Lf9GA3Tu2xIqRMEHrXGSY+a3fDv+lzxpYS/aTuhOzn
         1JEzcpf+SxN7xZ4S2+te9CpmIfPQ340m+6n/clvvuobIsB21dN1QyoIqFR0rJRhklBvj
         r88w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zjs60eTmFylT6zlXhuolFL93YMY2z/i7m9j2AIBEDZA=;
        b=GU/q2YnjruNJYhHV+g1Vbgo8PocRFkdI6Xo1FnV77JO2e/7erENXucqGFltr8gVB8Z
         zjngfYvUWEdYzs8KX9TGujZj/m3CEUFpgtSEICHH9USbtpvV2gIY55mybwRXDHjTADe4
         6U9D3JY0SVy3JdX253OL5V1yqQXUoeGJmoSwcG8OH5J5vxrmMyZsOZUVpaqBSaYGY4kN
         HxoUCqX8hFEVbuH9dBad51GUKMSZXZIQ8YJziw3BOwbxgqp51vvtAC50ovfhSbhkdnX1
         mESKHi3ik0vl2cg0ZHkMHlW8VPkhnKjyyswCu/SVaAvhoWpRlkyLiuPItVlxUasZcnpm
         G6EQ==
X-Gm-Message-State: AOAM532ESJQDCKJ9djxr36U7pYhdwL76mqc5Qe8oI9BFQmvCYG5TQKZJ
        B7bUWGtvQyKCb7+GT5GRqMg=
X-Google-Smtp-Source: ABdhPJxwF72LgxLgSJA0rkc1Cc9HEyrpZjUwEI9uIJ98YFPNtUGgcUqJOh5Q4W8ULiCVKlo/d8JBFA==
X-Received: by 2002:a63:b303:: with SMTP id i3mr27053915pgf.25.1625673405675;
        Wed, 07 Jul 2021 08:56:45 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.27])
        by smtp.gmail.com with ESMTPSA id gi20sm6865823pjb.20.2021.07.07.08.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 08:56:45 -0700 (PDT)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        Alexander Aring <aring@mojatatu.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ieee802154: hwsim: fix GPF in hwsim_new_edge_nl
Date:   Wed,  7 Jul 2021 23:56:32 +0800
Message-Id: <20210707155633.1486603-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both MAC802154_HWSIM_ATTR_RADIO_ID and MAC802154_HWSIM_ATTR_RADIO_EDGE
must be present to fix GPF.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index cae52bfb871e..8caa61ec718f 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -418,7 +418,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
-- 
2.25.1

