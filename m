Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F22F5381665
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhEOGuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 02:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231481AbhEOGul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 02:50:41 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2499EC06174A
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 23:49:27 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x8so1219982wrq.9
        for <netdev@vger.kernel.org>; Fri, 14 May 2021 23:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLJ3Btaxtlct4nbexABhDafeTGhMh/9d9LXYfQ2H3gI=;
        b=Su9ePPS6XWlcHYtrLumla264rLUk7/Fixa5I6TCaqDrucSwlB23EqH7JE4yQCLZKT7
         CkWki16VN5jkQ/9jui00DjpDDDfBqk1q1pcxRkiGfT0sL9RYfjfDrbnQkkvOBGuwhd5s
         skDKXhHStr2Usf9maCF6tlSWS1cYAw1AOGzuZpo9FLlN0GXTaNLO1E6Vdir91YQ90feo
         sdUNVGDKvXJ2bLmVvMqn38ZzKMcIMI1YbDteUWy7tT5wnS3H/gey4dzzegMw/eYUGd4j
         GAlZdWe+3b+oS0SuGi+DlIUybtUi775Ptl0PMZ4zd1Rh8/mcvw5tM5S8oCvDhLsmaRBT
         bPNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jLJ3Btaxtlct4nbexABhDafeTGhMh/9d9LXYfQ2H3gI=;
        b=U1geWTU1lppaNztxjIqF5DbwyKeoibxTt5XX6j3lV7Q6UcOOq+538EH8QGeMaFIGFs
         C+H7tf1rxfRxQJOhpkajAm5uvtQOqMLQXQo8V61i36JR1Q4s5B7QDpsHU4WnimkNtswn
         tiKkd0693tWBK+bC1c6lSjpETIQuNXWeJGe0/G+qaeBGtYGjgpUZNBJZJyPUM5Ya9+Eb
         E/n8JpW2j/WxDHw6QY2zfCSosu5SbZeB7QwPIr7vRo4mvG/GjJEDxzQzbbGiD7CkK6+D
         Er7Jh/j7tLJDW5EvFaABZmBUDWHDN/9ZCic7ei3AhoyMZ3L8ga18zWfD7cM1QV8zGh4s
         MJtw==
X-Gm-Message-State: AOAM531nwwitdUhFd+W/oyLeOZtZan3MQy3hHArZkAH+qcTKMboM4pnV
        2UhOA1S7SYeiXcOUkyuIEb6589MaYAMezw==
X-Google-Smtp-Source: ABdhPJx2xJTZYmlwtIf+lu6VkmnqmZokukWlREomIPboN8hL5MYmLCZLSUlaJ5EBwbjEO7OvvATqbA==
X-Received: by 2002:adf:e110:: with SMTP id t16mr9445901wrz.359.1621061364315;
        Fri, 14 May 2021 23:49:24 -0700 (PDT)
Received: from t450s.fritz.box (ip1f1322f8.dynamic.kabel-deutschland.de. [31.19.34.248])
        by smtp.gmail.com with ESMTPSA id p187sm6825866wmp.8.2021.05.14.23.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 23:49:23 -0700 (PDT)
From:   Heiko Thiery <heiko.thiery@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ben Hutchings <bhutchings@solarflare.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Subject: [PATCH] Fix warning due to format mismatch for field width argument to fprintf()
Date:   Sat, 15 May 2021 08:49:08 +0200
Message-Id: <20210515064907.28235-1-heiko.thiery@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bnxt.c:66:54: warning: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 3 has type ‘unsigned int’ [-Wformat=]
   66 |   fprintf(stdout, "Length is too short, expected 0x%lx\n",
      |                                                    ~~^
      |                                                      |
      |                                                      long unsigned int
      |                                                    %x

Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
---
 bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/bnxt.c b/bnxt.c
index b46db72..0c62d1e 100644
--- a/bnxt.c
+++ b/bnxt.c
@@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __maybe_unused, struct ethtool_r
 		return 0;
 
 	if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
-		fprintf(stdout, "Length is too short, expected 0x%lx\n",
+		fprintf(stdout, "Length is too short, expected 0x%x\n",
 			BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);
 		return -1;
 	}
-- 
2.20.1

