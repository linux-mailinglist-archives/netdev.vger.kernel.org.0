Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B871365BCEC
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 10:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237084AbjACJRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 04:17:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237066AbjACJRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 04:17:46 -0500
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A50E028;
        Tue,  3 Jan 2023 01:17:45 -0800 (PST)
Received: by mail-lf1-x131.google.com with SMTP id p36so44815987lfa.12;
        Tue, 03 Jan 2023 01:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C7NjRiu7yNj/gaqX5nfaaqWiPjVYEcvStY3bSuitipo=;
        b=NHCofaVjJOSEk5I+et6U5lbknDF4+Ung5vA4J/2MxboMwWIWU/eV3md5YS1DqMhMMp
         7xalI1SaMxN0nT9SgAdVin71LUZRWucJO8DSYl9sSzNVjv7JL4ksKiBN3ZoKIOqsKz4J
         YgvMUf2COYsYu8UDkL8jCZkj7Mx7HVwv9blky9583gwPVUeebpn4q+tnAZ5ZymuF/DDf
         VanCkcgVW6AaP+smeXiTxjDiqHqmOcuVmrZcfPsg1owLeBXfKfnXfI5e4tYkOld/MSwI
         lg3aNPf2MUBKoXJWIBTQMpx2thfnd5/MtDzPZP9FZimwv491Tvmml3rprke/phjXkoMy
         /j4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C7NjRiu7yNj/gaqX5nfaaqWiPjVYEcvStY3bSuitipo=;
        b=q5HI+yJZseXWAY9li8PfSUKdHEvvdUUMoxwUkqydUUT0bHVQj9eM8allIkkbZ0lZ5U
         xsf3YcsGSo++cGlEmqCndViOF193+MSIxiOEX7qXea0ZDzEIYJRMaggHCN8XdwC+r/G7
         0OcNbRssUrkx9++c54Vx2RrMNTve2tbqaxFwpIAPvxvCV9D7bfWhFYhgQYIgyu++ALiv
         Ud9quN5lyT5xlP5u7d0SkPlpKzGKHgfD85snX0kwK00u84iAQ1Uiwz3mMKsvmsWYTFoT
         +veUAzexZig2wuWjm7+b6quMw9UZ4RkGvyt4xvMGEC+mgDJriPsB1uLNN4iYTofgrHzn
         TZjg==
X-Gm-Message-State: AFqh2kp+SWcL0JKPxBikjSajduZCWfeINeuzy7+3N2BEz8xv8uPsi1xb
        u9i36LRPZfF0eXJLqptV/ec=
X-Google-Smtp-Source: AMrXdXvAqDoLZ/NuJZCywOQ1kmOggM+e2g757Ohtxv60DAp7xaeQVG40UJTkVzoWYsyD5DYJZK7neA==
X-Received: by 2002:a05:6512:e9d:b0:4b5:5476:4c27 with SMTP id bi29-20020a0565120e9d00b004b554764c27mr15917613lfb.43.1672737463481;
        Tue, 03 Jan 2023 01:17:43 -0800 (PST)
Received: from localhost.localdomain (077222238029.warszawa.vectranet.pl. [77.222.238.29])
        by smtp.googlemail.com with ESMTPSA id v11-20020ac258eb000000b004aa0870b5e5sm4790562lfo.147.2023.01.03.01.17.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 01:17:42 -0800 (PST)
From:   Szymon Heidrich <szymon.heidrich@gmail.com>
To:     davem@davemloft.ne, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     szymon.heidrich@gmail.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] usb: rndis_host: Secure rndis_query check against int overflow
Date:   Tue,  3 Jan 2023 10:17:09 +0100
Message-Id: <20230103091710.81530-1-szymon.heidrich@gmail.com>
X-Mailer: git-send-email 2.39.0
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

Variables off and len typed as uint32 in rndis_query function
are controlled by incoming RNDIS response message thus their
value may be manipulated. Setting off to a unexpectetly large
value will cause the sum with len and 8 to overflow and pass
the implemented validation step. Consequently the response
pointer will be referring to a location past the expected
buffer boundaries allowing information leakage e.g. via
RNDIS_OID_802_3_PERMANENT_ADDRESS OID.

Fixes: ddda08624013 ("USB: rndis_host, various cleanups")
Signed-off-by: Szymon Heidrich <szymon.heidrich@gmail.com>
---
 drivers/net/usb/rndis_host.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/rndis_host.c b/drivers/net/usb/rndis_host.c
index f79333fe1..7b3739b29 100644
--- a/drivers/net/usb/rndis_host.c
+++ b/drivers/net/usb/rndis_host.c
@@ -255,7 +255,8 @@ static int rndis_query(struct usbnet *dev, struct usb_interface *intf,
 
 	off = le32_to_cpu(u.get_c->offset);
 	len = le32_to_cpu(u.get_c->len);
-	if (unlikely((8 + off + len) > CONTROL_BUFFER_SIZE))
+	if (unlikely((off > CONTROL_BUFFER_SIZE - 8) ||
+		     (len > CONTROL_BUFFER_SIZE - 8 - off)))
 		goto response_error;
 
 	if (*reply_len != -1 && len != *reply_len)
-- 
2.39.0

