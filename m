Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9EC5BA6D5
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 08:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiIPGa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 02:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbiIPGax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 02:30:53 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFDA75467A;
        Thu, 15 Sep 2022 23:30:52 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso19434248pjd.4;
        Thu, 15 Sep 2022 23:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=kh3qx/CMyciqDvsEcGf9GgOfMAvKQrxqFwrNuTVKiI8=;
        b=XW6yjn79h0txPYQ9/waG7CV5bMeEwTtTaiBKevHif29ILiLR20UjPv3KQS+oT+nd5/
         ZjYRf16T2UBs8T31VKkOO4l3/SrANUR9YnMK3rEft3gdxLgS84LQfYa8fhy3Qq7rdFuq
         Bh4xgi/5/kwA6Y2t3ydDleZ1/Z0X39ewF1DMgkJnzTrt6wacqyVjsI7j7V/GK7zC12ou
         PlxzKimu1wYdjIQb68jJ7KhIY1CgkJV/3jibe6ptAVZELf0L/pn6vQQI6JSJj4KVs+wu
         Se+PYnSxhjO3Lu3ZzLSXXRFmpn0Du5rUbmO3OA87QaUJdj/jkd89YnKGVjSRMKeh98nA
         sVIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=kh3qx/CMyciqDvsEcGf9GgOfMAvKQrxqFwrNuTVKiI8=;
        b=JotUgCqtddftZgWtUc9E5fJnhP9OkZCyqL3Eb1QHfdy42lAo4TNSDoNVf3acvqW7o7
         K3rdU6vi6rBoepDLUd3BTR3eeF+Pwc+R5cLt1fSb4rw6n8LFrmYFzeoBLELKqRbrh1y1
         8dCp+mmH2bt1BB0AoX3/cgQASJykrRDDxoEEmzU0eEFvWfNoVBHgA7cm05BwYrBQcXuQ
         zMg/60HunI1Yvg7VRfkOc951BjK7KTfFVy8qXgdnB1MrkGR8vIpKUFDrDxwV06JEGp8s
         0zleyhMpcPR1DPmjsn9I/M6cYm49XrcdqgiLOvB2XEpxJbz+f0X6R6XHZStKhofXr0pJ
         PkXg==
X-Gm-Message-State: ACrzQf2sYNlCVDu0gspsY9B15ol3AGvrQyHlB/ZVq4SW3j9ceozKItAs
        OWFZBG2hjiIe0LmvmDhTL6A39QUyWHg=
X-Google-Smtp-Source: AMsMyM5/iWsbG6Wc9fZRTipzPEu0saoviPmDVg/k4+GI+qrAZV9o7/wtqE6vvIKNM4CtsqFyurCszw==
X-Received: by 2002:a17:90b:180a:b0:202:ae1f:328a with SMTP id lw10-20020a17090b180a00b00202ae1f328amr14957464pjb.78.1663309852099;
        Thu, 15 Sep 2022 23:30:52 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b9-20020a170902d40900b0016bedcced2fsm13927410ple.35.2022.09.15.23.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 23:30:51 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     chunkeey@googlemail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] carl9170: use strscpy() is more robust and safer
Date:   Fri, 16 Sep 2022 06:30:47 +0000
Message-Id: <20220916063047.155021-1-chi.minghao@zte.com.cn>
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

The implementation of strscpy() is more robust and safer.

That's now the recommended way to copy NUL terminated strings.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/net/wireless/ath/carl9170/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/fw.c b/drivers/net/wireless/ath/carl9170/fw.c
index 1ab09e1c9ec5..4c1aecd1163c 100644
--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -105,7 +105,7 @@ static void carl9170_fw_info(struct ar9170 *ar)
 			 CARL9170FW_GET_MONTH(fw_date),
 			 CARL9170FW_GET_DAY(fw_date));
 
-		strlcpy(ar->hw->wiphy->fw_version, motd_desc->release,
+		strscpy(ar->hw->wiphy->fw_version, motd_desc->release,
 			sizeof(ar->hw->wiphy->fw_version));
 	}
 }
-- 
2.25.1
