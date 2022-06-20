Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCFB551435
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 11:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239353AbiFTJYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 05:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbiFTJYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 05:24:07 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F9E910FEF;
        Mon, 20 Jun 2022 02:24:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id a14so183071pgh.11;
        Mon, 20 Jun 2022 02:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5CS4XuowHl3fOQ7b49ktrcd1HEr3NKrPs0rcjTFez0=;
        b=WID6xmpohixtFlYmxksYOKpB3rq0QO82zERJD1ltIKASW3B92zhFit4jpZ55xorv4R
         wdcIOCS29im2ljT7APria7bnLFfWZU42ACqvORgqIrKkm29hC2wBPANWPBxQRBXGnH7a
         cru3fHYKquGP94wwwRwaMru0vdWp9+iIiDziHou4hCmaXM1gHj6aSnPlEYpl699RPWfY
         8e5lyVuvhrhXPsmH0F+Jt1yF+v0LsItyDAjaoug97z0XfdNH2vGvAv3hz2SvED1+tfcP
         pXZ0dCeowDBcbcIjTJw6I/eRhhGJqNOk/a+WmBIv9uJ8f8QOt+j4rSaWbmZ4/UY0zIMp
         /37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=S5CS4XuowHl3fOQ7b49ktrcd1HEr3NKrPs0rcjTFez0=;
        b=4GvQU9tiPakmbDR6/3LcuuIg7y76OWKP18q1uBtLcappwZjVz4DCqfMeqZF7CCmzMm
         87vr2FB0O+89gDMh2+OJVouuQaW4g63XlCULs/vrpjRCMmErOD0AlZkg8yPM8fQ1Fjg7
         UT0PlkB2nPmNEy2vJBh3RXWHiVNhlKPxHjs1P2Q8T7AK+9hufCeMJM0XPT09xOOcB+tn
         r8uDGyJ0ulnEsHDVR0bmqoX9CPfEsuOmq3r8p3PTK/I9PY4zgGTs4T/q8fiRkta+uMye
         ERDuQwOhLxduE5utzHp/ohtxxP7TUzb39sGBImnqRDXDxi4lptzsE+d0Icpjv8fl94Hs
         MqsA==
X-Gm-Message-State: AJIora96lGFEOwX0VIwCNNh8h3ojcAN8EU89lm2mMTuEgpkPmFU1+dqV
        CxHhIhM3GhHPCJP+mEIWk5A=
X-Google-Smtp-Source: AGRyM1u3rLFCnE8Lo+RAAcfpyHC/N8fnrkkJavw2vCtskOUencdn6XVurRwJGrlRUhMHclC3z1Mkmg==
X-Received: by 2002:a63:f09:0:b0:3fd:7e20:6508 with SMTP id e9-20020a630f09000000b003fd7e206508mr21086223pgl.32.1655717046078;
        Mon, 20 Jun 2022 02:24:06 -0700 (PDT)
Received: from localhost.localdomain ([103.84.139.165])
        by smtp.gmail.com with ESMTPSA id b193-20020a6334ca000000b0040c95aeae26sm3414935pga.12.2022.06.20.02.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 02:24:05 -0700 (PDT)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, wanghai38@huawei.com,
        dsd@laptop.org, linville@tuxdriver.com, dcbw@redhat.com
Cc:     libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH] libertas: Fix possible refcount leak in if_usb_probe()
Date:   Mon, 20 Jun 2022 17:23:50 +0800
Message-Id: <20220620092350.39960-1-hbh25y@gmail.com>
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

usb_get_dev will be called before lbs_get_firmware_async which means that
usb_put_dev need to be called when lbs_get_firmware_async fails.

Fixes: ce84bb69f50e ("libertas USB: convert to asynchronous firmware loading")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 5d6dc1dd050d..32fdc4150b60 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -287,6 +287,7 @@ static int if_usb_probe(struct usb_interface *intf,
 	return 0;
 
 err_get_fw:
+	usb_put_dev(udev);
 	lbs_remove_card(priv);
 err_add_card:
 	if_usb_reset_device(cardp);
-- 
2.25.1

