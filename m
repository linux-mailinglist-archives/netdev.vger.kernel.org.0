Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45E35C269B
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 22:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731063AbfI3UiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 16:38:08 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41461 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730105AbfI3UiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 16:38:07 -0400
Received: by mail-lj1-f195.google.com with SMTP id f5so10926716ljg.8;
        Mon, 30 Sep 2019 13:38:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gek2awizC19DRqdsGkSxiDjzH45dJ2a6h+V1E8hcFPc=;
        b=m5DZh/v+bR7He87gdSFPGLVJrrQjpD045RxFCvuUDYQgF1aEnzS+4GHh9Fx6HEG4mh
         Zh694ML65wXDvqCojVyghpo+7cJJzJ/dFwz1T+vS53V9wxTLZyTLPg6ECSNSyShebO9p
         SwMtDQ8B9RvJHmLifzOfjbzYUjpunHAF43uBhO4/hKlElXJV4DoacquPRsDa37EvuQd1
         HBZamqQUZ3+1o0guEHwwGMiQm2kRZgbd23sCBpxXt7vHIkGN5DiGNt7KLN9pOcgtmA8o
         Ed1FaVTjFX5CORqe0SI8428h8Oiwn3zgkN8LncGrHIXmEJ9IpQVMFgXtCDhjz3qtPj5m
         dPZQ==
X-Gm-Message-State: APjAAAVNph/TJ5wtEMujXwXIPp/bnlr6iNn58X6MpwOSQa6ODp7IWRaj
        QcBnZIs+ohTEGsVy2hc21ksVG1Zv
X-Google-Smtp-Source: APXvYqxbquIAk6jQ5ZvzBUZ4ucsaWt3KPUV0l4rJzJHZx8ghqG80pGGYdJnDeItjHrVrSB0aln7Dvw==
X-Received: by 2002:a2e:63da:: with SMTP id s87mr13106787lje.79.1569875513862;
        Mon, 30 Sep 2019 13:31:53 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id j84sm3548526ljb.91.2019.09.30.13.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 13:31:53 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Laight <David.Laight@ACULAB.COM>, stable@vger.kernel.org
Subject: [PATCH v2] ar5523: check NULL before memcpy() in ar5523_cmd()
Date:   Mon, 30 Sep 2019 23:31:47 +0300
Message-Id: <20190930203147.10140-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930140207.28638-1-efremov@linux.com>
References: <20190930140207.28638-1-efremov@linux.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy() call with "idata == NULL && ilen == 0" results in undefined
behavior in ar5523_cmd(). For example, NULL is passed in callchain
"ar5523_stat_work() -> ar5523_cmd_write() -> ar5523_cmd()". This patch
adds ilen check before memcpy() call in ar5523_cmd() to prevent an
undefined behavior.

Cc: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Laight <David.Laight@ACULAB.COM>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
V2: check ilen instead of idata as suggested by David Laight.

 drivers/net/wireless/ath/ar5523/ar5523.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index b94759daeacc..da2d179430ca 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -255,7 +255,8 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 
 	if (flags & AR5523_CMD_FLAG_MAGIC)
 		hdr->magic = cpu_to_be32(1 << 24);
-	memcpy(hdr + 1, idata, ilen);
+	if (ilen)
+		memcpy(hdr + 1, idata, ilen);
 
 	cmd->odata = odata;
 	cmd->olen = olen;
-- 
2.21.0

