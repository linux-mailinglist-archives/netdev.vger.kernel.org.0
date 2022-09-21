Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28CE95BF35E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiIUCQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbiIUCQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:16:25 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA07032BBD;
        Tue, 20 Sep 2022 19:16:24 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q9-20020a17090a178900b0020265d92ae3so12697553pja.5;
        Tue, 20 Sep 2022 19:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=GnHGtgHj033COJKahffZStPIaXE02OICjJM2Z9aEkfE=;
        b=ArRr74et4U1zLmXiJOghTrTMnedfdbF7K14oBBpNIc8qTkREGPO5v04fI1k1kbyrLx
         aE9AvyteVh2+qhO2Mdb8OF0GMzIxHqqYA7AHgEMHz8m3ZBG0PwqpaX4uoFIQTg10zUkz
         MwCcQnpBOkDxcL5Yt6/9QvFFjyx7CVdOExmelt+4nQuFpw3m7saN/EepKWFmT1xTW4Wv
         coNsRQJPCjqBxC2R2jbd/LOVOzubUoQ1Gm37yLcX/MfefYirEknZw/ktLHoEDM/P0J76
         fX0JWbhPys/CYrKJKqNQ6liKGabibcgJBuAF6GH29Vno10Zq+ui/epuVMeLTYcPMphfm
         nFIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=GnHGtgHj033COJKahffZStPIaXE02OICjJM2Z9aEkfE=;
        b=FqsWxyFbqZh31KikU2paLSCkMoltWCG88nEBnr+veg4oG3rlHOEi9VYqUi8hcJ7gQE
         TqsO5HgtFx9wvSAadjO6hwGx2HX4rx4W0ykrMmzDRFiXwsIKsBARhKqpvIsdjLdmgNfs
         g6cO0uLYrG/lwlSF4yaOe9VrKYbq+VUBeee/3jb3jo02cT9TXYf40Y7DNzBJPxiz+sgs
         aMoGxXXKEjgnV0VxskRcMKScne5Ns0dRSQRCF8ejrBb+nWvIju0zQncEDHJkz3fQzZxl
         6lPyfqN7EuBBDcG7iYJcFzdCXG3LJclHy/SJ59AVwuljwDa/5Jok25tccVbRf85MwPhM
         bTqQ==
X-Gm-Message-State: ACrzQf0cOirRQpdL/elru0rT3PdPnayyzHAZS1UCmDyTvfGftqtdaQU0
        YhVUP0KxzYMWmzRTrm3STD8=
X-Google-Smtp-Source: AMsMyM7MRypGCQbUxoyrc6WNFpMb9PFhoALdU/NO7Lw8H72HCSj9ZvzMDFM2cHVsH6lG7m+CxkybYQ==
X-Received: by 2002:a17:90a:8909:b0:203:ab27:a41 with SMTP id u9-20020a17090a890900b00203ab270a41mr7073542pjn.163.1663726584165;
        Tue, 20 Sep 2022 19:16:24 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id y1-20020a623201000000b0053e9ecf58f0sm661954pfy.20.2022.09.20.19.16.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 19:16:23 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     wei.liu@kernel.org
Cc:     paul@xen.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] xen-netback: use kstrdup instead of open-coding it
Date:   Wed, 21 Sep 2022 02:16:17 +0000
Message-Id: <20220921021617.217784-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
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

From: Minghao Chi <chi.minghao@zte.com.cn>

use kstrdup instead of open-coding it.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/xen-netback/xenbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index e85b3c5d4acc..c1ba4294f364 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -865,13 +865,12 @@ static int connect_data_rings(struct backend_info *be,
 	 * queue-N.
 	 */
 	if (num_queues == 1) {
-		xspath = kzalloc(strlen(dev->otherend) + 1, GFP_KERNEL);
+		xspath = kstrdup(dev->otherend, GFP_KERNEL);
 		if (!xspath) {
 			xenbus_dev_fatal(dev, -ENOMEM,
 					 "reading ring references");
 			return -ENOMEM;
 		}
-		strcpy(xspath, dev->otherend);
 	} else {
 		xspathsize = strlen(dev->otherend) + xenstore_path_ext_size;
 		xspath = kzalloc(xspathsize, GFP_KERNEL);
-- 
2.25.1
