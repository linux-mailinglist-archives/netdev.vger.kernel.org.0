Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D18553F432
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 04:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236136AbiFGC56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 22:57:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiFGC54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 22:57:56 -0400
Received: from mail-il1-x14a.google.com (mail-il1-x14a.google.com [IPv6:2607:f8b0:4864:20::14a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9207064D15
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 19:57:55 -0700 (PDT)
Received: by mail-il1-x14a.google.com with SMTP id p12-20020a056e02144c00b002d196a4d73eso12889317ilo.18
        for <netdev@vger.kernel.org>; Mon, 06 Jun 2022 19:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=jQjQFYBtDc22SUnKgmbqzUWcCvd+rxgK8hINvOFvZEx81Ygb2xPsI//kcY60EW6nHL
         B6N+vYOKIdPC/AjAkPB1qt7RR+SQgZDKreOVBlOMDmAm0NQAWxLoJvS6d6QMdEoHWnlh
         P5vmgzKyHNWP5ia1ZHtymwY16xHXgd4SMA9UN02UXNLqUQXrjPH5D6thMWgL08JI42I8
         LbPwbuC1Pk0R5z76gem9FD3r0IvbvzzW+soqSZUIZqiOeZqAyly1SiH/FDtMpp2sp869
         4cy3KBTccNsZBOwNhAejd/JV7ZU7f/Npwry3ennMRZzlt+jnXRJqWlQwFLICbnBwOLh1
         n3rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pUBRV97xthCU10usUAjhjvk0rgt9U50UKyWh+gTd9as=;
        b=GZyjBIV7rcL496VhhNyfQ51IJ30V8sb0Vk73GSywFRaighkwoS+GGQHqMhzn6dEem4
         GryHnanVWTR+5uMj7HRM+wHTE1RmkLJHvG6lVTbyblJhxj2uj7/DeOCI9+E9rnR3pZ/Q
         9MK4GQ86QsO/7S1VdjY749lPsu/FL3oEt4Ds4rWxA2NfDq+pbhD8iADBOB+v1bbe5gXe
         YrZBg4R5KUQNERtpTEPaLY3IPE1jzR6AmPmTjLec3MYgSzopH6ef8usysbs2kwLa7nJ+
         +TQ2LU4qWWBKEFRYU+9hKWiYTEwbBQg5yAkCjVhDfJK9T7xkGkJwTDlKLbUGX+FjaP/O
         pHuA==
X-Gm-Message-State: AOAM533FMT2x/rPgTMBGRazAGqhpu7EEtiDBn5a1FG16wnqFdXHdLmVD
        +H4midPHuvWI8wH52yLzfWCiLg5Lzf2nzVU=
X-Google-Smtp-Source: ABdhPJysDsw2Xp3++JLDh4G8Le939Xv59gY1kyCvvC3FHcRQ7EqnrmRvBUR67LubtD6lvPUkGTmyVfh+q+ULlFU=
X-Received: from sunrising.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:fb8])
 (user=mfaltesek job=sendgmr) by 2002:a05:6e02:194c:b0:2d3:aff5:d855 with SMTP
 id x12-20020a056e02194c00b002d3aff5d855mr14669749ilu.263.1654570675034; Mon,
 06 Jun 2022 19:57:55 -0700 (PDT)
Date:   Mon,  6 Jun 2022 21:57:27 -0500
In-Reply-To: <20220607025729.1673212-1-mfaltesek@google.com>
Message-Id: <20220607025729.1673212-2-mfaltesek@google.com>
Mime-Version: 1.0
References: <20220607025729.1673212-1-mfaltesek@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH net v3 1/3] nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
From:   Martin Faltesek <mfaltesek@google.com>
To:     kuba@kernel.org, krzysztof.kozlowski@linaro.org
Cc:     christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        mfaltesek@google.com, martin.faltesek@gmail.com,
        netdev@vger.kernel.org, linux-nfc@lists.01.org,
        sameo@linux.intel.com, wklin@google.com, theflamefire89@gmail.com,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
Cc: stable@vger.kernel.org
Signed-off-by: Martin Faltesek <mfaltesek@google.com>
---
 drivers/nfc/st21nfca/se.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 7e213f8ddc98..9645777f2544 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -315,7 +315,7 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
+		if (skb->len < NFC_MIN_AID_LENGTH + 2 ||
 		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-- 
2.36.1.255.ge46751e96f-goog

