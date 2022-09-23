Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BD65E7F4E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 18:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231819AbiIWQJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 12:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232185AbiIWQJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 12:09:55 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9014A2CDEC
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id l10so583100plb.10
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 09:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=bownNDQQj26J60zbZJdnz8MUF15aZsgh0SO9wr3gHy4=;
        b=kQ9tMF6KQ7kDCI6fGlKVlAkbShITdMSuIRH/IFkU5bnKW8N4aQGUtJNLaCoDyigbB0
         xsS9WkYDo+gFzom0cEjbl+jxXtvtHN7VxEktbstNik2NVbLaWxd7rcywIy8r8ZxHaD1t
         Ks6fuW3Z134ov4CXAV3wEgVw/ORJwXlRyGI/3zB0EqOWsQHGR82hwCcHxbL8jj9+Ba2G
         ODADXxhJgoNX99/tM0gsZluXMGT22sUFd86QMCTj6rll5ua7yb/3Rcoa/4HndL0URs07
         aimAg/Z0QCtAPn2FyAH3QbelVpmrF18pTlG0z+fawiFJtzq7VlM4YGLhJ+28MPHwsiii
         STxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=bownNDQQj26J60zbZJdnz8MUF15aZsgh0SO9wr3gHy4=;
        b=GaSL+Upl0vmtc2izwXH+KrPdZbMOrx6TY+NVAxCGgy/KivtmeX9s895iFX5C2OjYSx
         tk9sfflBwtA5suKSqTvJIflSuoR8JK0Z8BNeVxPFsdVnUnk4MBXtPVkxgeK9C2sL0Zs5
         2OopiP5wVI0t95D4tgT512+hDTMvaq5f1IGdchvEoPG+PTigFENO9hlmyeUwekxG9nds
         7GY6P6LIjjspwKNECgitL8wvQhEPuHYjFtDTNKvsScOJGL7QrkxAVZ1Jtm6RyxqK4qU1
         sRhJ10FUnvsQUUMgoTzofOsyMwCiVrkLE9GQ6RHvzLGuNya2A5FwtA3XHKDYUzJmw8Kp
         hpRQ==
X-Gm-Message-State: ACrzQf2LFWDTfucFsY8A00IrsRvdD+nYnPialnzU7wFpdRnI/ivxTUSL
        1i29ELI1VEyZOHNn3bwAzNmDVyMBvTp+OXyu
X-Google-Smtp-Source: AMsMyM4k5a3mocys15tq3JXsI34ncLGCgtpkufTkLVO88lkTepWUYsP2RABjCneuItI5gNhgxnQRjQ==
X-Received: by 2002:a17:90b:4a91:b0:202:59ed:94d5 with SMTP id lp17-20020a17090b4a9100b0020259ed94d5mr10086417pjb.213.1663949391514;
        Fri, 23 Sep 2022 09:09:51 -0700 (PDT)
Received: from kvm.. ([58.76.185.115])
        by smtp.gmail.com with ESMTPSA id g10-20020a656cca000000b004351358f056sm5718334pgw.85.2022.09.23.09.09.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Sep 2022 09:09:50 -0700 (PDT)
From:   Juhee Kang <claudiajkang@gmail.com>
To:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     skhan@linuxfoundation.org, Juhee Kang <claudiajkang@gmail.com>
Subject: [PATCH net-next 3/3] nfp: abm: use netdev_unregistering instead of open code
Date:   Sat, 24 Sep 2022 01:09:37 +0900
Message-Id: <20220923160937.1912-3-claudiajkang@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220923160937.1912-1-claudiajkang@gmail.com>
References: <20220923160937.1912-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The open code is defined as a helper function(netdev_unregistering)
on netdev.h, which the open code is dev->reg_state == NETREG_UNREGISTERING.
Thus, netdev_unregistering() replaces the open code. This patch doesn't
change logic.

Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
---
 drivers/net/ethernet/netronome/nfp/abm/qdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c b/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
index 2a5cc64227e9..19b1ccc9abf6 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/qdisc.c
@@ -296,7 +296,7 @@ nfp_abm_qdisc_clear_mq(struct net_device *netdev, struct nfp_abm_link *alink,
 	 */
 	if (qdisc->type == NFP_QDISC_MQ &&
 	    qdisc == alink->root_qdisc &&
-	    netdev->reg_state == NETREG_UNREGISTERING)
+	    netdev_unregistering(netdev))
 		return;
 
 	/* Count refs held by MQ instances and clear pointers */
-- 
2.34.1

