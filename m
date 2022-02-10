Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41A34B0612
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 07:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiBJGKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 01:10:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbiBJGKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 01:10:16 -0500
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC0FEC;
        Wed,  9 Feb 2022 22:10:16 -0800 (PST)
Received: by mail-qv1-xf2e.google.com with SMTP id o5so3973827qvm.3;
        Wed, 09 Feb 2022 22:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XnTlfC/2x4nU8jxxfPLwDgpfMYqygXbQEq1bZIQt1jE=;
        b=EZGx4WJiNDunR1WPhi39k4/6ZN0nK9jfRC+ShkmT7FS8xAMsYLAfkehNbNFDKoln17
         SDd8geDmJcsqr62D9px1Fgujy1JHGJPVwCJCzDyb+ffF7vfNqMmE0qGmN5ZWl1y9aBZg
         G12UR3tYJLftUj/iPgduQDCS07Ur7ir9OHtFnQL5n+x7yT85hkIjf2786RRESyZMdAKz
         o485B1/YuVB42fRe409eia4M2tSzcNEuQjXa+sSsFNE8hgGBqr5IHahAKb8WE+eWcEGf
         XXggc8WMP3TCys2hx7JD6fCeyvbDJZfmgyLtTh9X5srz2WsozgwH/LqjjmlsDPi1Gn/O
         G/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XnTlfC/2x4nU8jxxfPLwDgpfMYqygXbQEq1bZIQt1jE=;
        b=F6SSh85Gz1QrlQ64wMcE2iF4Id16dFRs310XlkDTNIBxemyrHJxXv2rd6E3W0yEq3k
         /UEQ6zWyYocRz4+69iB3aNhc/p9Dk4h5PA2++IqRftaXIBnh8ZXoW1iFctFnWl7zXuUd
         q2k9zgyb95ynGdf7mz6BZPhea1HwcmRdgfy65ORFY//QdJx1y4hy7C7MtDJj7tYzuoiL
         /xmFWk8KnAx8n6guN+m/0BQhy9ac0/+ixNCvWqC9L1ZwkLnBujrtjGvqRh3dQHIiXKnl
         49zYV1YJUBJcXfnRXS1nFXXsTWoSMRl1R9HJSqAv3T3BLYU7xxGjLri/l8oHLmNSC//T
         6hEg==
X-Gm-Message-State: AOAM533dLYIDmbtc7RoqFzw2TcwQnuH9QrAzHbzJIJo+mAkaqMs+rfx3
        o/zeoeHSss2+hvvi468p2I8=
X-Google-Smtp-Source: ABdhPJyRIjQr3Q1UO5UoVGh01kGMlu25+dOhQvvlLjVnC7TT4XAPR/oxv5s4cwa0EgtWeEgN0HEjiQ==
X-Received: by 2002:a05:6214:1948:: with SMTP id q8mr3971770qvk.98.1644473415502;
        Wed, 09 Feb 2022 22:10:15 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id e17sm10298456qte.94.2022.02.09.22.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 22:10:15 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jiri@resnulli.us
Cc:     ivecera@redhat.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH V2] net/switchdev: use struct_size over open coded arithmetic
Date:   Thu, 10 Feb 2022 06:10:08 +0000
Message-Id: <20220210061008.1608468-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Replace zero-length array with flexible-array member and make use
of the struct_size() helper in kmalloc(). For example:

struct switchdev_deferred_item {
    ...
    unsigned long data[];
};

Make use of the struct_size() helper instead of an open-coded version
in order to avoid any potential type mistakes.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/switchdev/switchdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/switchdev/switchdev.c b/net/switchdev/switchdev.c
index b62565278fac..12e6b4146bfb 100644
--- a/net/switchdev/switchdev.c
+++ b/net/switchdev/switchdev.c
@@ -85,7 +85,7 @@ static int switchdev_deferred_enqueue(struct net_device *dev,
 {
 	struct switchdev_deferred_item *dfitem;
 
-	dfitem = kmalloc(sizeof(*dfitem) + data_len, GFP_ATOMIC);
+	dfitem = kmalloc(struct_size(dfitem, data, data_len), GFP_ATOMIC);
 	if (!dfitem)
 		return -ENOMEM;
 	dfitem->dev = dev;
-- 
2.25.1

