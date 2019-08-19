Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2BB9520C
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 02:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbfHTAAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 20:00:11 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39664 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728554AbfHTAAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 20:00:10 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so1000265wmg.4
        for <netdev@vger.kernel.org>; Mon, 19 Aug 2019 17:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oZOnUnIyGaNuUoHr2Bi1L/ITN5tvgAtjXraJPK/g5dY=;
        b=RxhVjAVwaW6ZqE9yyLY1ZFKQqD3fBCdjQjAMH4GmGbZsIlKrUeXoY+GNlyZ2PrHDJQ
         puFPUYvLmYsASx/JcPx5Fi/im4danSo/vzsZLpH1GjAGGP7uJsjUdl1DK6FIx/vSeBI+
         dUU1ijyj+NcyzKmOFnbQMlwXQM03eBnwGKgduQkz/ykC0X6xE6dN7SQzXuNPzdAgw/ZA
         MuZItHW0RnMmBOv9JlYxNoYD2ZLv1AqqdPobM23dtaNIz0U0KVWuDXdmWFNCK+iiqY9g
         dRyb1NGLGdr6/RKFjuRwSTGhQLh58vcTj6kI2VcC2n1gOqIU9t7Ircdr5MxM5plS4RQg
         x7bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oZOnUnIyGaNuUoHr2Bi1L/ITN5tvgAtjXraJPK/g5dY=;
        b=Zyl+rgOV48z6p56180aHU+6Ck0fn3gx984yr0USA/2qXLj8hNDXK/DOUsFwjFGtQWV
         1TgYcVcz+4V9721fYXDvkbLJEwoqljOGvJ4iY9bEpHvId3/V+KK2njhFsQsLyKK4Iu19
         Qu4jTnFRZtdQ2xMNiuERyS6K/QPmfUADbB+BbrNmEBQST3btyVG45hmzxP/VAa7z5ASv
         //G06yX7CduMaySqx5FYsjESYLt+Zm8cmCFs3594F6Dv0S23JBDBGYp7Awp9m3EioCch
         56YDMjC7W3V63s7EbB8eI8LvyRxb3IrgX0p6owjh/c74TqEYwnGrA+ETubxquOfA32oD
         KOlw==
X-Gm-Message-State: APjAAAVH/EsqPfCR8yLDhjx8QSc3vVP9RDor5fP7WWpeqv1TfRDybvmp
        cFxMS69+NtlTRauQEpL/BjgZadgeSFU=
X-Google-Smtp-Source: APXvYqxJpU3BVreYZfbvGbWhpiOPYq+i9Kh2mvFfNcfjd5nKDua2yvan1ZZ7NcalTTiHObZvEfaYBw==
X-Received: by 2002:a05:600c:218d:: with SMTP id e13mr22770427wme.29.1566259208197;
        Mon, 19 Aug 2019 17:00:08 -0700 (PDT)
Received: from localhost.localdomain ([188.25.91.80])
        by smtp.gmail.com with ESMTPSA id c9sm3814064wrv.40.2019.08.19.17.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2019 17:00:07 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        idosch@idosch.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/6] net: dsa: tag_8021q: Future-proof the reserved fields in the custom VID
Date:   Tue, 20 Aug 2019 02:59:57 +0300
Message-Id: <20190820000002.9776-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190820000002.9776-1-olteanv@gmail.com>
References: <20190820000002.9776-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After witnessing the discussion in https://lkml.org/lkml/2019/8/14/151
w.r.t. ioctl extensibility, it became clear that such an issue might
prevent that the 3 RSV bits inside the DSA 802.1Q tag might also suffer
the same fate and be useless for further extension.

So clearly specify that the reserved bits should currently be
transmitted as zero and ignored on receive. The DSA tagger already does
this (and has always did), and is the only known user so far (no
Wireshark dissection plugin, etc). So there should be no incompatibility
to speak of.

Fixes: 0471dd429cea ("net: dsa: tag_8021q: Create a stable binary format")
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/dsa/tag_8021q.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 6ebbd799c4eb..67a1bc635a7b 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -28,6 +28,7 @@
  *
  * RSV - VID[9]:
  *	To be used for further expansion of SWITCH_ID or for other purposes.
+ *	Must be transmitted as zero and ignored on receive.
  *
  * SWITCH_ID - VID[8:6]:
  *	Index of switch within DSA tree. Must be between 0 and
@@ -35,6 +36,7 @@
  *
  * RSV - VID[5:4]:
  *	To be used for further expansion of PORT or for other purposes.
+ *	Must be transmitted as zero and ignored on receive.
  *
  * PORT - VID[3:0]:
  *	Index of switch port. Must be between 0 and DSA_MAX_PORTS - 1.
-- 
2.17.1

