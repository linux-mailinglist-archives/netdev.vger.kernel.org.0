Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92294C3F34
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 08:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238217AbiBYHmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 02:42:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiBYHme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 02:42:34 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184FA1AA491;
        Thu, 24 Feb 2022 23:42:02 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id bt3so1740016qtb.0;
        Thu, 24 Feb 2022 23:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WB2UJiGQQxiDi2Mxv6dyEHAg8UeTsSc7+1pqPfX8yFE=;
        b=VUCwRvbs2awdPoNnKnLqLr7KCxDcgpZ8/Ilak4tfVc1xLDoAyywZNz676eigbUVtgf
         Iyl+CbynMVnbMFw7VXjVxGK+LvUC9bCyr8oFEncwxpRaYOKSSM+pI2/ol0gQeKcc3eRJ
         9KOg/G3svYXaZPwkUNnqNlquPMrtolkCHgnHZxMg2jc6ureY639A3rI6pugLFw78xe/x
         Ok+h2TdNyCvXFtbGQnEKxOyN7QYqcEnmXe5N/+wjgrW9ceOLbS/HhH0Xw+jcn0CfyixY
         oyJzvbA2a2F0uwe1UZfrHZp751sDw3G4JkdLe5TtH5bkVjIJC4k3BOb41CewV7IXn6tv
         2fRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WB2UJiGQQxiDi2Mxv6dyEHAg8UeTsSc7+1pqPfX8yFE=;
        b=mjhj2nNrP3GkyYe8ltYZUS3saDzeYbEwysZ6O+U9z/j86QdXflDzaFMgDT7ye6ihmp
         8pPIcwxIZdfVWWCbqdPnbiYLQq5Tt8fNU/naSjT7oN5cuwQ65EKuhyijX5/NPeTW9f0P
         inpQLxn+cfTTbFVc6yh5KY0+jSuceN8lI2PcpabRAxx6f28l1OgH/D2Vi4y2CTET2LCM
         NCHHDcmd4Q6riAcmbzjSbWDU9zeRGleGdUmJ2DsFfRoamj+VDPvfuygp4JeC6ulOVFlT
         zORnb3lxDlz8b70ZB+79yOz8ZQU9KPUmqh3uLBRGpfg+dGxg+mj9UGq6a0eHVEFoOSQM
         miKg==
X-Gm-Message-State: AOAM530PsPVX/NqF+hrr24PweufhzHeuaS7frQlhDjjLGFdYLagu2KiU
        pAHGSQ/lM9M6piHIlxISvlE=
X-Google-Smtp-Source: ABdhPJxjqnhaU9ZhDG0v+hpfHVSdL81T+h8tnNNbR5dn9I8Val+zYcI4zqcJTbHvP9qn8SFDfI7T9Q==
X-Received: by 2002:ac8:58c7:0:b0:2dd:1a1:191d with SMTP id u7-20020ac858c7000000b002dd01a1191dmr5758070qta.334.1645774921290;
        Thu, 24 Feb 2022 23:42:01 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id bq42-20020a05620a46aa00b006494fb49246sm864853qkb.86.2022.02.24.23.41.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 23:42:00 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     marcel@holtmann.org
Cc:     johan.hedberg@gmail.com, luiz.dentz@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net/bluetooth: use memset avoid memory leaks
Date:   Fri, 25 Feb 2022 07:41:52 +0000
Message-Id: <20220225074152.2039466-1-chi.minghao@zte.com.cn>
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

Use memset to initialize structs to prevent memory leaks
in l2cap_ecred_connect

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
---
 net/bluetooth/l2cap_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e817ff0607a0..8df99c07f272 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1436,6 +1436,7 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
 
 	l2cap_ecred_init(chan, 0);
 
+	memset(&data, 0, sizeof(data));
 	data.pdu.req.psm     = chan->psm;
 	data.pdu.req.mtu     = cpu_to_le16(chan->imtu);
 	data.pdu.req.mps     = cpu_to_le16(chan->mps);
-- 
2.25.1

