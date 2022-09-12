Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B06D45B61D0
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 21:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229687AbiILTk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 15:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiILTk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 15:40:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C1F1476FB
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 12:40:55 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id b14-20020a056902030e00b006a827d81fd8so8118330ybs.17
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 12:40:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=W9p0zgnz9HiTB/0UdjjdirPbtTvGNOenVCLlAeF5/ks=;
        b=kIb9mKHmh4VQUbwYfXIeufs0L7HoYm3h9bYoHWm+YV/YM7E2S/kT/MuCBTJZhvsFUN
         Y9bE2nnTCELd6Uo5Yb0KZV6NJYg4VmwjsPKZf24YSXT0fN1sJ7YNzv5LW4IvYS41tEMU
         OImAFif75ZIAry74Xs/FhQVBm+/YKcNT0FevROVA26L/Ca0YSjMlfBRJjjGuEOSZijRp
         T/oOJjfZtZ+z7WwqOR3IW2awHC2aQ93LrxI2nDWUjvBq7hzurTfhaYQXZfQE5NHYGXtk
         npwMfzAwfFoFGUd4Cox7D4F100e0zQUkv5uRq8ocq1AzOMqg2wXE0/r+aD6W0S+hpfqh
         KCAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=W9p0zgnz9HiTB/0UdjjdirPbtTvGNOenVCLlAeF5/ks=;
        b=1i6qI/CIA6CsREheZSn/aszBlKy6A/UCilezM9L+7UCPMSAIAU3nsJCkT0/6bqTf1p
         C3l6X3xQIvuTzKv569nTBKZprOpD657hSDjPa9P80QdRMtjmDky2I5p4SOwHgHSRMVrj
         GqbjcbI4a4rFI2T5pMcwgT28URE/ECiB3fg0PsCUxFLjLgS4eV5QBH0WRp30PfLunSUG
         Ph6934J4soFOa3ynJbghTlnv9bzmfRTugZgm5Ij3L9JbXC3p7Vkuw/4gxGwLvobdFzPd
         bIZfyDdmhEgmNrs55srzy13+o4lS4MvUMdGBZI0p/V4j872bmdtWPh01jcPOPHjYgYXY
         zoZA==
X-Gm-Message-State: ACgBeo24MTtrO7MCmU5gTyqwMwii87CJO1EEp0Uh5xkMJq+SAxBuVtmT
        YXx1VBvSrnFYA/yiXtt4AbV7YuZb7Q==
X-Google-Smtp-Source: AA6agR5tT07BLedJkk78QlwL8aAcT2zOwZ+TyghN3uTLRGF5Uit5WEI7B1ycrzrVCbXp9ca7l8J/GIJPlg==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:690c:812:b0:345:27dc:56e2 with SMTP id
 bx18-20020a05690c081200b0034527dc56e2mr23623616ywb.313.1663011654220; Mon, 12
 Sep 2022 12:40:54 -0700 (PDT)
Date:   Mon, 12 Sep 2022 12:40:30 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912194031.808425-1-nhuck@google.com>
Subject: [PATCH] net: ax88796c: Fix return type of ax88796c_start_xmit
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "=?UTF-8?q?=C5=81ukasz=20Stelmach?=" <l.stelmach@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of ax88796c_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/ethernet/asix/ax88796c_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 6ba5b024a7be..f1d610efd69e 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -381,7 +381,7 @@ static int ax88796c_hard_xmit(struct ax88796c_device *ax_local)
 	return 1;
 }
 
-static int
+static netdev_tx_t
 ax88796c_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
-- 
2.37.2.789.g6183377224-goog

