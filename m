Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2123968E8CD
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:17:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjBHHRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjBHHQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:16:50 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5C6457C8;
        Tue,  7 Feb 2023 23:16:35 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id v23so18329195plo.1;
        Tue, 07 Feb 2023 23:16:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ycnlYn5d+KKZ8BASQ7jATYjFBHohKH+QlxWuOVP8JLU=;
        b=gpVLRNJ6k7Ifu96i3tuj4J/TOHMt8b2lD/FkauSl3Jm54161GKuT5EjzeeSVSC06Rh
         FRLChx18UhzKg0tCvkJmbHlc4gvMlGO09/SZUNbFNhRGwqBIgNJGsX5w9hRibTANeRes
         tGtNi/idgTQJ+z6fmgS+kNQQeSMmyGKMBe2R1we7aeTu80um+KDlVnSNt22antGx1Rwd
         WlfPQCwy3AYt0nxAdbhcadh+7CvWDjfEb+fcTmnsDM2HBTs1XWm1gUGoy0/xZ88Y21Ew
         Pop9AH8+aOwkaBSymKt82+Y0suv91GYkHjfMSBMXeIW25vqYzBacddAu0O/+1OQEcG7L
         CzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycnlYn5d+KKZ8BASQ7jATYjFBHohKH+QlxWuOVP8JLU=;
        b=jr6MIkQH5XgOQfhQvDWh/infJD2T1KrAGh3Rt3C+2MkK87mBSVzhb+7Om3cOVq92QF
         zAu+hlCeRIIOTh0+HzPYKcU8GcSjIXCQC5ZGXqLjqMg9dDtPS/U5ZKBrgeqdTTvu3mIJ
         Pch6uKIeTuBCHDld8i4ZUNxo3QluWF5ptJ5RKmtgEQQzIFhIhtR8QzNxM7xRMXKPrYbY
         O1pHuowP6JET6+qTNFSKdHfhKzbMPMHryeExWpyKD0/Kln6eyNgf7/+OcCFHhiPNiIvJ
         MoKNsFdjb76HWIJ4oSdfSyBsk4kJQKMnB7clcc2viWJHToOUHxXhYfI58mp+6tsUDpsS
         GW1w==
X-Gm-Message-State: AO0yUKVT9LjrUQNDY+UwVd2Oe2McqlVubbFb+yoHleY51uSL+N5KmwxM
        J/nBANqKNQ7eMeEjr9/DGq8=
X-Google-Smtp-Source: AK7set9HqIUFYtU0m8+n9dTTg8SaoEFy0rE+dr0E557QdS8WiYACmUCUmF4bXujKeOm3wkcF8rgO7g==
X-Received: by 2002:a17:902:c946:b0:189:f460:d24b with SMTP id i6-20020a170902c94600b00189f460d24bmr6402388pla.5.1675840595223;
        Tue, 07 Feb 2023 23:16:35 -0800 (PST)
Received: from hbh25y.. ([129.227.150.140])
        by smtp.gmail.com with ESMTPSA id e5-20020a170902784500b001965540395fsm6533116pln.105.2023.02.07.23.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 23:16:34 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
Date:   Wed,  8 Feb 2023 15:16:23 +0800
Message-Id: <20230208071623.13013-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

old_meter needs to be free after it is detached regardless of whether
the new meter is successfully attached.

Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 net/openvswitch/meter.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 6e38f68f88c2..e84082e209e9 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -448,8 +448,10 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock;
 
 	err = attach_meter(meter_tbl, meter);
-	if (err)
+	if (err) {
+		ovs_meter_free(old_meter);
 		goto exit_unlock;
+	}
 
 	ovs_unlock();
 
-- 
2.34.1

