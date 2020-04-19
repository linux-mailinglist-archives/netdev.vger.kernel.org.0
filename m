Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7B41AFD25
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgDSSQl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgDSSQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:16:39 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83907C061A0F
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id k1so9315473wrx.4
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wp/fWdSFYgcoNndDQxJgsDFZAAm9b5zX0KfrujAQ34w=;
        b=FXjHNSlz7wWrbQvR6MKJzH0jKQ/bZNEwMc5CQmnFtcxPGWUF5qjeEgSs1by8wX63h4
         8b6PtOhEoIZCPClm+y5ganwt1Ed+Og2mHJ5l0gjKkpDKfuUiC6g2gzRKdg/4wNL8TY2B
         tGAfNBXW48MkdZhDXnmuyLPE7+txJRpjFNc0g6/MuPxxN5lg/fWMeC5uWWRSQrkesyMD
         ddeExk7Y1xUddWxgyOahVaBoqhML9CAn1+FsWkACA0amLYGuThr96w1UIglodaOzh/4r
         lPAy8LPWs2Wy/8HyCiQDVUEqtW/4owaB+9HgmIJmAPnC4KCCOdHs0N6P2LglnwDG2/MK
         7D1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wp/fWdSFYgcoNndDQxJgsDFZAAm9b5zX0KfrujAQ34w=;
        b=qWNPBuEZItKJecQ2oX2EYuo6NRJ1SiNqxeSnZNAxFVoWa/3jXEcgcGkh6FW3p8tFOX
         ALBzEeqFKbEEqL2K9+IHQBoQjwt7P/gsVKaP04Lgby6VH0RqosI7yGUj9Hun2IOCC+y3
         2LWUqt5SKgZeilqQDzJtoPu2u755uecpAz1IuvffNrZIkTJlqxR38dj0v0LoVjpeh5Vc
         7OXnMk0YeLMSBp1I881Oq0OcGrNyxjpoeGwY/qBisqPK5LGYEZc010yppYveh38cWpdo
         EMr+WPs/1MzhAAJBPxN4AjyL8gpQpMxiraZ1xmfkr/Q/OSgEtYf9ggH6tTG/98psRDeu
         va/A==
X-Gm-Message-State: AGi0PuZ5faGTTNZbG+i6lkTeHqr3FrAQRS/E8DEsV2V9MOSaxg0qsAya
        GJsbv5mYXExYMo37J/+bEZsgyEWt
X-Google-Smtp-Source: APiQypIU3Hre56LkXiwQ9eqRZc+RyZNFa+Qd3eE3u/mXKJu5A0Uay0OZ13dZG/Cq6uO9adPGNQYKMQ==
X-Received: by 2002:adf:e586:: with SMTP id l6mr10741955wrm.184.1587320198005;
        Sun, 19 Apr 2020 11:16:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id h2sm15727078wmb.16.2020.04.19.11.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 11:16:37 -0700 (PDT)
Subject: [PATCH net-next v2 3/3] r8169: use WRITE_ONCE instead of dma_wmb in
 rtl8169_mark_to_asic
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Message-ID: <612105ff-f21d-40c4-2b02-0ac0c12615fb@gmail.com>
Date:   Sun, 19 Apr 2020 20:16:21 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <a7e1d491-bede-6f86-cff0-f2b74d8af2b3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to ensure that desc->opts1 is written as last descriptor field.
This doesn't require a full compiler barrier, WRITE_ONCE provides the
ordering guarantee we need.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 2fc65aca3..3e4ed2528 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3892,11 +3892,9 @@ static inline void rtl8169_mark_to_asic(struct RxDesc *desc)
 {
 	u32 eor = le32_to_cpu(desc->opts1) & RingEnd;
 
-	desc->opts2 = 0;
-	/* Force memory writes to complete before releasing descriptor */
-	dma_wmb();
-
-	desc->opts1 = cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE);
+	/* Ensure ordering of writes */
+	WRITE_ONCE(desc->opts2, 0);
+	WRITE_ONCE(desc->opts1, cpu_to_le32(DescOwn | eor | R8169_RX_BUF_SIZE));
 }
 
 static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
@@ -3919,7 +3917,7 @@ static struct page *rtl8169_alloc_rx_data(struct rtl8169_private *tp,
 		return NULL;
 	}
 
-	desc->addr = cpu_to_le64(mapping);
+	WRITE_ONCE(desc->addr, cpu_to_le64(mapping));
 	rtl8169_mark_to_asic(desc);
 
 	return data;
-- 
2.26.1


