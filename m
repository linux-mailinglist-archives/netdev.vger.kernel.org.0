Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57ABD12C6DD
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732032AbfL2RvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 12:51:08 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35346 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732021AbfL2RvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 12:51:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so16980862pgk.2
        for <netdev@vger.kernel.org>; Sun, 29 Dec 2019 09:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XvsnWTCfIdzsL88twtl2wRx+PRxRlb1z2NWR1p5Mnkw=;
        b=pV76YUL5qPdSAzqAkcpGm2fnvL6/JnQQb7h+S1yKQwvjc8fU2BZxiGUJ2RDrAEDeUh
         TCXGOKfKXYindFHTH8IJrDGEDd+EfIjkNUlUDFd21BTtPAuJLQbx1ktC7qUoFtzI6HH6
         KxupGgGefOdtDHNtD680vgbgAxkJdjTQGvPm4TvFneeDoDh/lJ/tSh0VIpIw8a5yWTAi
         JzKGPHQAYZR8bFa7MsSeiWwkozmw79rsj/uBJdpD/VQyYEPZQwIE/NdJ36X1Mci4rl2H
         uXwJ34Irzfa0JZI5KhMin32lmRn1RZW4MWSIJ4l/wxkSKJ/6Lmv+hvLekpDBAMl14dhF
         pIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XvsnWTCfIdzsL88twtl2wRx+PRxRlb1z2NWR1p5Mnkw=;
        b=TvQ82hDlXl9G9yrHkT0jWgZd4FLRC1jpsOW2JFtMRHueZiELyulbU3sIDs2OT+hcEy
         N1yH8VMpPvO8oY5z6KC/XNYa84gB/evcSo+InZ1/15lADmyJaBo16upIxhGqt4+Lqudm
         YMP5D5keZGvvYnKChP4otJI+t1OLs92n2s17wjLwYFBwiiD2/vOmINhfC4yCtsOS2iNX
         WWkz1fZ3fX0CvbI9tte/k7P051YEuE1nQhnQEKwBDY0cpJg0HrSzms0lHFhOAqrL7dwL
         Pp4cttVB2GL1bR550eDxBwe+URCFevDPQahGjCDtqA1zdvFNZn7tewTKMekomSg5iZjO
         fxBA==
X-Gm-Message-State: APjAAAXdlPQUyMAjtFSwfuxvvlCJjQydpcUmat+e7gMV2Zuk5ekmxZkO
        TJxUiHncSHgB8rh0pe++jfUpcwbW+eg=
X-Google-Smtp-Source: APXvYqy7cnWKliZIKhTkFupq4tIoeM4m0vAwU+4Pv+KFFhJ2pepyH5dNR0KkEs51ROPhozamQChBOw==
X-Received: by 2002:a63:6fca:: with SMTP id k193mr69730914pgc.416.1577641864860;
        Sun, 29 Dec 2019 09:51:04 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j18sm45367057pgk.1.2019.12.29.09.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 09:51:03 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2] rdma: remove tautological comparison
Date:   Sun, 29 Dec 2019 09:50:54 -0800
Message-Id: <20191229175054.12017-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The qp_type is a uint8 and the comparison with ARRAY_SIZE would
always be true as reported by clang 10.

res.c:148:10: warning: result of comparison of constant 256 with expression of type 'uint8_t' (aka 'unsigned char') is always true [-Wtautological-constant-out-of-range-compare]
        if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
            ~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~
Removing the comparison also allows for simpler trigraph
form of return.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 rdma/res.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/rdma/res.c b/rdma/res.c
index 251f5041f54c..ff92b0394601 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -145,9 +145,7 @@ const char *qp_types_to_str(uint8_t idx)
 						     [0xFF] = "DRIVER",
 	};
 
-	if (idx < ARRAY_SIZE(qp_types_str) && qp_types_str[idx])
-		return qp_types_str[idx];
-	return "UNKNOWN";
+	return qp_types_str[idx] ? : "UNKNOWN";
 }
 
 void print_comm(struct rd *rd, const char *str, struct nlattr **nla_line)
-- 
2.20.1

