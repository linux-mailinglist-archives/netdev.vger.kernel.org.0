Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850D450333C
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 07:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiDPCFM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 22:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiDPCEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 22:04:42 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711DD137B27;
        Fri, 15 Apr 2022 18:54:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id u18so11727039eda.3;
        Fri, 15 Apr 2022 18:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Bf9ok3qqr2tkNhXNTndNo5u+WE3bYamPKOf2o8UuHw=;
        b=XjCVFe5nIUhZlq4sKzILLAUdIcxaTYQDznCGjtGrbpXRwwYQ3M8wUeCXPgk46XJoD3
         7XUMZmoK8UrtKecT8Y4P1PpUGnksBn1GcIkLrYuB5duFNp4tu+okUQL5HFRmNCfKaXgi
         AROzOsRZwhOvzwFhvzB5+VEakpDbJgKQpIyqZBU/mdmOVForkW8DJxB77ZwkUU6mLgTV
         xNMz+I9FdONbz1R7D9cLrbg1hjv1pyfrumrlSK/pq9FtBDXN0GuLtcFYw5uhO4X8xWWL
         baktCX0XpEarzZNDA0oFU7Z6Y3n6t38iYUYym5XOLmYW1oRVzJN8q5QFZI9sHQ+FGdXm
         1cvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Bf9ok3qqr2tkNhXNTndNo5u+WE3bYamPKOf2o8UuHw=;
        b=FHS/PIQDOKCgzj3NyhOVkTZB+gFmcUJLhMBheywsFt5npsFNzGrhlQP/lVeLcdqnfv
         WEG1Zy3lNKj5owIFU/ze06AfUeP9sEk0VbiDOGx4AZ87DIkmAHW8PxwghKr6KxEMbprC
         7fvbcQulxtk6uN/u5APMBBHPLxoAAQB+fa+mNnii0P1hKrww0no1pERRum1ZDH4ndTpG
         eTE21D055VFpIPuHOeVi5WvvMOBABE/xdad0URsb5cflszbxkeDiWS6lv0JVW8Qz86t2
         57Qty+SQHLde7Fi7mgG7wcqYoJWNRfxYM37q0e8G5ReZPzKQtNaYLZdTgAXM06jDNpkQ
         +SBw==
X-Gm-Message-State: AOAM531V2QHH+spQiyqjHhmfORBHhn94ihRcoARS8gGz1gM500HnJhwR
        ElQR2sObC8MNKJnykihLA3Ept/zwjptvfw==
X-Google-Smtp-Source: ABdhPJzVIQW3hTUxtbFojN9M9UGqtaIuMj0zU3SmMQ6W/p3T3CkqpwCpZtc9yxr9eRL4LR0bx7nWAA==
X-Received: by 2002:a5d:48d0:0:b0:207:a861:dcc9 with SMTP id p16-20020a5d48d0000000b00207a861dcc9mr1022300wrs.490.1650071963568;
        Fri, 15 Apr 2022 18:19:23 -0700 (PDT)
Received: from alaa-emad ([197.57.90.163])
        by smtp.gmail.com with ESMTPSA id x3-20020a5d6b43000000b001e317fb86ecsm4998374wrw.57.2022.04.15.18.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 18:19:23 -0700 (PDT)
From:   Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
To:     outreachy@lists.linux.dev
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ira.weiny@intel.com,
        eng.alaamohamedsoliman.am@gmail.com
Subject: [PATCH v2] intel: igb: igb_ethtool.c: Convert kmap() to kmap_local_page()
Date:   Sat, 16 Apr 2022 03:19:20 +0200
Message-Id: <20220416011920.5380-1-eng.alaamohamedsoliman.am@gmail.com>
X-Mailer: git-send-email 2.35.2
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

The use of kmap() is being deprecated in favor of kmap_local_page()
where it is feasible.

With kmap_local_page(), the mapping is per thread, CPU local and not
globally visible.

Signed-off-by: Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>
---
changes in V2:
	fix kunmap_local path value to be address
---
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 2a5782063f4c..c14fc871dd41 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -1798,14 +1798,14 @@ static int igb_check_lbtest_frame(struct igb_rx_buffer *rx_buffer,
 
 	frame_size >>= 1;
 
-	data = kmap(rx_buffer->page);
+	data = kmap_local_page(rx_buffer->page);
 
 	if (data[3] != 0xFF ||
 	    data[frame_size + 10] != 0xBE ||
 	    data[frame_size + 12] != 0xAF)
 		match = false;
 
-	kunmap(rx_buffer->page);
+	kunmap_local(data);
 
 	return match;
 }
-- 
2.35.2

