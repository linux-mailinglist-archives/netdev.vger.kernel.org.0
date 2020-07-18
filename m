Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01BED2248F9
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 07:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgGRF0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 01:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgGRF0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 01:26:42 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F75C0619D2;
        Fri, 17 Jul 2020 22:26:42 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so12552455iob.4;
        Fri, 17 Jul 2020 22:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SCHfx5BI0heiM7sUgX9/TzzuZtUxyDEqeWGyvIFDhhA=;
        b=sRYpxoRAbVVJddam3wPjUBFy+q++TqDEySUNHSYndfoezqzTo/CV4brjxOsB9Ju6Pw
         AdHziWCgVlJjRGjKMDJY3bhgYmBV6sUMLfzoCEPl9FROW37s3RepHiB20odn9h/N/8An
         t54gSf1j3G/d12jADgTphGomHtt8EpR4G2YDYT66p2EzJqmcXeEWP+LQQmgsmUK1CXgw
         U9JQIOE/cC1pf1rYlHvoKYopmvKS12v2x0ZZedl5O4uWZfYhVom/SItwhlG8kLj5gCW5
         tOrwZj79RVfLeMW2bX2OXBmsqQ43M+JZPTXeKGPr0+tPxsPLYixgpr+SNMAkQQ4y36tZ
         eRvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SCHfx5BI0heiM7sUgX9/TzzuZtUxyDEqeWGyvIFDhhA=;
        b=ajsUMzuwutb1RpUdpkvMsNkSHXnW9vsXpyo+GCxFz43Ma/CmwGQVSe8wHzyYUcqqez
         F3cpCj/w3teta3xTnUVRIinM+4hPXfXyqCr1bSsaE/XvauHds954j0ZNW0N9/ATUhwaO
         hC0hZ28Ke3X8OCauHpyvFvS8lytnuJdrxNBmdXh3ZBsr+4TSg26dpq8MSg6Fr3a8FjrE
         K5vfGLJfRe3MXiPxyEJgC6q32OzMAg5p2GAlv7CIYUlMTD+T7vvaaCM2hQsZjiDoIQ2o
         tOSjzrhxh1DnLCs4fbgGatKgV5PCWCRR41vki4BLvPcJ2ScF4NlzKsoMO0hhGm2dO1XB
         F1iA==
X-Gm-Message-State: AOAM532CVD4ZZX+2Xr9hdNDWnWzqHF6e1FgO091ILlRA9ANYx3gdcFo5
        IMCkd6qItBbll324x587PH6EJUEVNkQ=
X-Google-Smtp-Source: ABdhPJzQqlmtBgAX2zPQun++Nq03W8tZGAakz1U8y4y8IC7ATIM4teO1+JqaUrmSpAflgfliW/kn+Q==
X-Received: by 2002:a5d:9306:: with SMTP id l6mr13072604ion.105.1595050001248;
        Fri, 17 Jul 2020 22:26:41 -0700 (PDT)
Received: from cs-dulles.cs.umn.edu (cs-dulles.cs.umn.edu. [160.94.145.20])
        by smtp.googlemail.com with ESMTPSA id 13sm5357408ilj.81.2020.07.17.22.26.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 22:26:40 -0700 (PDT)
From:   Navid Emamdoost <navid.emamdoost@gmail.com>
To:     Jakub Kicinski <kubakici@wp.pl>, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     emamd001@umn.edu, Navid Emamdoost <navid.emamdoost@gmail.com>
Subject: [PATCH] mt7601u: add missing release on skb in mt7601u_mcu_msg_send
Date:   Sat, 18 Jul 2020 00:26:29 -0500
Message-Id: <20200718052630.11032-1-navid.emamdoost@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the implementation of mt7601u_mcu_msg_send(), skb is supposed to be
consumed on all execution paths. Release skb before returning if
test_bit() fails.

Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>
---
 drivers/net/wireless/mediatek/mt7601u/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index af55ed82b96f..1b5cc271a9e1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -116,8 +116,10 @@ mt7601u_mcu_msg_send(struct mt7601u_dev *dev, struct sk_buff *skb,
 	int sent, ret;
 	u8 seq = 0;
 
-	if (test_bit(MT7601U_STATE_REMOVED, &dev->state))
+	if (test_bit(MT7601U_STATE_REMOVED, &dev->state)) {
+		consume_skb(skb);
 		return 0;
+	}
 
 	mutex_lock(&dev->mcu.mutex);
 
-- 
2.17.1

