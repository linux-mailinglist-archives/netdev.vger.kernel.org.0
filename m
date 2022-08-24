Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74E4A59FFCD
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237727AbiHXQvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHXQvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:51:02 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3CB3DF08
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:01 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id e19so16438320pju.1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc;
        bh=2i3KeujLyTfdjSKnRoU3FEZcLbW2+erV0LGXF4FPZZA=;
        b=Y5Ke4scyehexTTs0zFtE8zAS1Pjf9LBdCiaJf9xjwmqMa2GrSc+rXA0hfpBwY9l+eg
         Zuz4bnbe6HbfI4yVnol/Sw82RMvycVFITkK7pUezFM+n4NND7bX21lE7pTiEwI40vldJ
         sscPLpcERmChdrUWUAwafYB9BIW8msL0pWy6kbjVFRcejGC928B5JjRwfFwjGm0BYroF
         LnE9Uc+f8Y/69k9yLZpMRExI9tZJlfhuAvVh7dxChE29rXGJqvT62Dm/u954pkQrGdiP
         XbHQ/960Jsx7nJnJr2ki8oWiRcjS5UhC3jv7jtNWE/RNZWeunuD56PI+dNvZTBup7zdT
         SrKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc;
        bh=2i3KeujLyTfdjSKnRoU3FEZcLbW2+erV0LGXF4FPZZA=;
        b=hO7q+UWmwVZkruH2gSzXwhN3cU2n9LZxfXXxio8frNo1xgYIVj0uol/4GEhCa9fAfp
         ysJbnIU/XvZWjJTVkYCiM24So0RqIg1eends5e9BuEGS9HD2OYfvd7X2yH1DrncX2eOt
         Amp/FB7bGBlnVaOoVgUQPLsNpegd42kBsE81DrFEw6RFXyfwN/r3GaSVMZZNCYq7H1mZ
         nUriLHTFbUgvF7NLOb0HKyRj1FAjZXBWJKw/E4h2zmN1wxSmRRJRZ7YX3XGXEmnvj9au
         fixSm9yBmw8hMovI7Fv5uxtt/7Z4S0raAUWyy+IiD3/sui/QS8fSPP6lHS/KhrNuCw40
         6VzQ==
X-Gm-Message-State: ACgBeo0IoLdaAHfGNVQ0RKnO7YmVW/nmXQbR2NFAphyEMuxulBy6nh65
        lpP9dz+s1W+Of5wpDQAiuvEX5A==
X-Google-Smtp-Source: AA6agR6ls1XMHrn2YiRY5yY68a7HCfhvRl1rx+JdGx4oLfwg9vURdnfiRyDyxVsQJ8bv4qcwrPaHTQ==
X-Received: by 2002:a17:90b:4a51:b0:1fb:765c:8416 with SMTP id lb17-20020a17090b4a5100b001fb765c8416mr14997pjb.199.1661359860880;
        Wed, 24 Aug 2022 09:51:00 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a68-20020a621a47000000b005366280c39fsm8960349pfa.140.2022.08.24.09.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:51:00 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, mohamed@pensando.io,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 1/3] ionic: clear broken state on generation change
Date:   Wed, 24 Aug 2022 09:50:49 -0700
Message-Id: <20220824165051.6185-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220824165051.6185-1-snelson@pensando.io>
References: <20220824165051.6185-1-snelson@pensando.io>
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a case found in heavy testing where a link flap happens just
before a firmware Recovery event and the driver gets stuck in the
BROKEN state.  This comes from the driver getting interrupted by a FW
generation change when coming back up from the link flap, and the call
to ionic_start_queues() in ionic_link_status_check() fails.  This can be
addressed by having the fw_up code clear the BROKEN bit if seen, rather
than waiting for a user to manually force the interface down and then
back up.

Fixes: 9e8eaf8427b6 ("ionic: stop watchdog when in broken state")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1443f788ee37..d4226999547e 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -2963,6 +2963,9 @@ static void ionic_lif_handle_fw_up(struct ionic_lif *lif)
 
 	mutex_lock(&lif->queue_lock);
 
+	if (test_and_clear_bit(IONIC_LIF_F_BROKEN, lif->state))
+		dev_info(ionic->dev, "FW Up: clearing broken state\n");
+
 	err = ionic_qcqs_alloc(lif);
 	if (err)
 		goto err_unlock;
-- 
2.17.1

