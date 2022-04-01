Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844F84EF98B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236250AbiDASLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 14:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350989AbiDASLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 14:11:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0E312E15A
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:10:00 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id k25so4091510iok.8
        for <netdev@vger.kernel.org>; Fri, 01 Apr 2022 11:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7n7shanWw4CxVOi413BlNcTD72/SucjBf/727SiAHR0=;
        b=HPlo/oJh9IvP7IboHaQQvAfEl7Pni3soYCL3IEqnjHtWYP40S1lat4SKlUwMR5ItE3
         MQ3EP7JKJO6nioS0BixHSlIlDt4/ABHY7ziH+79AUvsZ65r9uoOF82OWthvhd2oMSEBn
         pWkyQ+Ta1FYMdQf4iscYPCxxu3jRdlbTsqbSg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7n7shanWw4CxVOi413BlNcTD72/SucjBf/727SiAHR0=;
        b=MNhrLZ7g9HjwJxu50Dpg+x+voPACze7z7v3DWoWQdQKLUlcf7UCf6c2rRxodDawKaO
         sEzUi4XMlsH5Ou/3hUELdVxHNBCf2HrJiTZ/wPSIrlFcy0ORpEKzBrrjBO1/6G2ATcVO
         pqku7JqMTiNRrubUHb1IZlMK4ixkWF4JKoKrYpmBRsZS8kqIOF5Avx+9z6AuNmVdeg75
         156+xmoEWdPC2xOQikDYnqRVHgz2vSy2iXOos1VAI6jm3Xq5jRxllPXokDGGL4TdDo+x
         JJa9SaqD2Lg/GMy2JJtNbgJRM35qyg9plrpR5xWI38g0JBgkViKkTNT1LRiuLsGIyFEB
         gF2w==
X-Gm-Message-State: AOAM5317JFtgjbCSFKXKBv8z5TM0+WxZ0YaHuL+SSq4o7t3Eurzv3t/f
        9w+kQHevwTb5JRiUW6KQpjRjOb1apLMXVA==
X-Google-Smtp-Source: ABdhPJyxDHZsFFUrbUOc7WF0/n+txOu7aa6wtQPbNAf0BU2MNAjL2A7MrypBy2JqIxlGmox62C3dIQ==
X-Received: by 2002:a05:6638:260f:b0:323:ae28:a0ec with SMTP id m15-20020a056638260f00b00323ae28a0ecmr3843268jat.278.1648836600051;
        Fri, 01 Apr 2022 11:10:00 -0700 (PDT)
Received: from sunset.corp.google.com (110.41.72.34.bc.googleusercontent.com. [34.72.41.110])
        by smtp.gmail.com with ESMTPSA id a3-20020a5ec303000000b006496b4dd21csm1716722iok.5.2022.04.01.11.09.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 11:09:57 -0700 (PDT)
From:   Martin Faltesek <mfaltesek@chromium.org>
X-Google-Original-From: Martin Faltesek <mfaltesek@google.com>
To:     netdev@vger.kernel.org, kuba@kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems
Cc:     sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: [PATCH v2 1/3] nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
Date:   Fri,  1 Apr 2022 13:09:55 -0500
Message-Id: <20220401180955.2025877-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first validation check for EVT_TRANSACTION has two different checks
tied together with logical AND. One is a check for minimum packet length,
and the other is for a valid aid_tag. If either condition is true (fails),
then an error should be triggered.  The fix is to change && to ||.

Fixes: 26fc6c7f02cb ("NFC: st21nfca: Add HCI transaction event support")
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index c922f10d0d7b..9a37de60f73f 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -307,7 +307,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.35.1.1094.g7c7d902a7c-goog

