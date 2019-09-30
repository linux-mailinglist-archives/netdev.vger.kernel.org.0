Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A28CC2295
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 16:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731473AbfI3OCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 10:02:25 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33350 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730524AbfI3OCY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 10:02:24 -0400
Received: by mail-wr1-f68.google.com with SMTP id b9so11513358wrs.0;
        Mon, 30 Sep 2019 07:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7wr4aVdaxbEMv/UX7nqpmCIH8uVZ65LnsbgEKWRrbhc=;
        b=RtpRwsDwr1LTPoUq5NUM+nrpO63VDB1OLtLqQP7qiOq+hIhz/UcRSEGmSbXxAtwsjE
         J3UWgjASH3/BrHk1TMxdacLaOBoktTsDOEtn7Bc3RTkw3otK69yq577gHe5zj2TL3RYl
         qPjcCJnVjNslaG/FPUKEB17jbDRVyBOJvJ6eCwGa/TPf54WVCKZoEsEFQm1ffBy50sPe
         SfoEkzVC9OjnUwkRAL+b6XHHa26ITQYP5fkZqK7WtJKYhIKcOj+mRnjZOuAKp58vnEeJ
         +pfoxMcCxVjb0Y+T0v9tax75iJHH0nftbeEe4ih3Odgw7hvF0lld2FXmxbux0mGEeffJ
         3Gmg==
X-Gm-Message-State: APjAAAXE4cLZ2KsXFJtau9qgz9t7dKlbQeZYKtsQGDelB4XIUDB6bY/j
        DKaP6403EQI4pZfbxk7q7UlpAntC
X-Google-Smtp-Source: APXvYqxiiFMzv3srbGQK/zZY+ci87zR844eKxu3fL2x+CU3Oy0tDmHDfI0I4XxcXHe1hilTCqog5ug==
X-Received: by 2002:adf:b648:: with SMTP id i8mr12771912wre.372.1569852142160;
        Mon, 30 Sep 2019 07:02:22 -0700 (PDT)
Received: from green.intra.ispras.ru (bran.ispras.ru. [83.149.199.196])
        by smtp.googlemail.com with ESMTPSA id x129sm20494089wmg.8.2019.09.30.07.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 07:02:21 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>,
        Pontus Fuchs <pontus.fuchs@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: [PATCH] ar5523: check NULL before memcpy() in ar5523_cmd()
Date:   Mon, 30 Sep 2019 17:02:07 +0300
Message-Id: <20190930140207.28638-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

memcpy() call with "idata == NULL && ilen == 0" results in undefined
behavior in ar5523_cmd(). For example, NULL is passed in callchain
"ar5523_stat_work() -> ar5523_cmd_write() -> ar5523_cmd()". This patch
adds idata check before memcpy() call in ar5523_cmd() to prevent an
undefined behavior.

Cc: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: stable@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/net/wireless/ath/ar5523/ar5523.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ar5523/ar5523.c b/drivers/net/wireless/ath/ar5523/ar5523.c
index b94759daeacc..f25af5bc5282 100644
--- a/drivers/net/wireless/ath/ar5523/ar5523.c
+++ b/drivers/net/wireless/ath/ar5523/ar5523.c
@@ -255,7 +255,8 @@ static int ar5523_cmd(struct ar5523 *ar, u32 code, const void *idata,
 
 	if (flags & AR5523_CMD_FLAG_MAGIC)
 		hdr->magic = cpu_to_be32(1 << 24);
-	memcpy(hdr + 1, idata, ilen);
+	if (idata)
+		memcpy(hdr + 1, idata, ilen);
 
 	cmd->odata = odata;
 	cmd->olen = olen;
-- 
2.21.0

