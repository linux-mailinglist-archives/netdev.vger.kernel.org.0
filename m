Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0A35EA61D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 14:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbiIZMai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 08:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235525AbiIZMaJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 08:30:09 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20DE02DDB
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:09:36 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id c192-20020a1c35c9000000b003b51339d350so4849065wma.3
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 04:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=ucf7OH+hKqISgH7uytaennco+mZXP2xC8bLUOBxFQKA=;
        b=M9qffJd5zSF3XEe1EQCOdFhjJ5oO5v+PqMgytNu+V+7NbJx9JVgFU6TGcmb9oPk+X4
         zURuvEGK66LU0jqZxWtamb1bXMATuujA2NkGKhrfh9tOAwmn4mCCUSBD4dClNeIG7MsD
         rKFxa8/zqTYa1Ta2AZqadOJhjhkjuv+o64xhWA69UGYm1BjGj+z6IIkX3UhYi07fKrt3
         m1qy0bOXXuFzONdrVaG1SE7I/WBSGv5uP0qULNpKBWcdTg1Sr9Tx/CMgXwLZ5/ySksBv
         lJS0NLSl3wggyK5b8w62Ey3TMDrKuFawll+krgrbyo2x57VGSN+qpT0I6CdrmUUb5cBn
         gbqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=ucf7OH+hKqISgH7uytaennco+mZXP2xC8bLUOBxFQKA=;
        b=XjYqapImMNlb7OZO0mO7eKsc6UNy+7+zBnvtsR/DtLk7OIiUOFP4h7I3P9dcVrouql
         hi87B8sVlZm2S/EozakB/Mibqc3uM8EvQyTKOQiXHHIWT/WzxUOXDYUuJIuCxzeVXEBf
         fN+FO7PjXUyfiTaTFDPGPvo/lv893uG4Bwd7dIEd2G1WPh7Mx3IgTV1yeoRVyXbc5ePI
         ZKyrfZ5XHzPteMpxog8wwqryPpM6KD15UahBQKdu7arLDrP0ojcWv+3keNBT2lGypa3u
         c8te+jaBc7XGoL39puB/WDsuS4it1YIhClHCy0WXeDMb86ZW6tksqIF1xy9Q+Kz2Yd/5
         BoDg==
X-Gm-Message-State: ACrzQf1mafhBv8JnQ3USO2a928CzT1MsUO1tZymDgESnoh552mFyQkNx
        f52YjFQKv0JJKVSQezOfXxph58gwPKk=
X-Google-Smtp-Source: AMsMyM7LX27tikM0RYXHiiNJz6wHxCe+jTb7GKPrkCbmHUZMzsoH39S5ZDb3EkW8+T+24bFzqyyy3w==
X-Received: by 2002:a05:600c:3483:b0:3b4:99f4:1191 with SMTP id a3-20020a05600c348300b003b499f41191mr14158024wmq.147.1664188670010;
        Mon, 26 Sep 2022 03:37:50 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.6.209.threembb.co.uk. [94.196.6.209])
        by smtp.gmail.com with ESMTPSA id c1-20020adffb01000000b00228da396f9dsm14120306wrr.84.2022.09.26.03.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 03:37:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next] selftests/net: enable io_uring sendzc testing
Date:   Mon, 26 Sep 2022 11:35:36 +0100
Message-Id: <28e743602cdd54ffc49f68bbcbcbafc59ba22dc2.1664142210.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

d8b6171bd58a5 ("selftests/io_uring: test zerocopy send") added io_uring
zerocopy tests but forgot to enable it in make runs. Add missing
io_uring_zerocopy_tx.sh into TEST_PROGS.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 tools/testing/selftests/net/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index d87e8739bb30..2a6b0bc648c4 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -66,6 +66,7 @@ TEST_GEN_FILES += cmsg_sender
 TEST_GEN_FILES += stress_reuseport_listen
 TEST_PROGS += test_vxlan_vnifiltering.sh
 TEST_GEN_FILES += io_uring_zerocopy_tx
+TEST_PROGS += io_uring_zerocopy_tx.sh
 TEST_GEN_FILES += bind_bhash
 TEST_GEN_PROGS += sk_bind_sendto_listen
 TEST_GEN_PROGS += sk_connect_zero_addr
-- 
2.37.2

