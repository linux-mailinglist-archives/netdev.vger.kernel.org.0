Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181FA8F5C4
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732093AbfHOUaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:30:02 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:40724 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731769AbfHOUaC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 16:30:02 -0400
Received: by mail-yw1-f67.google.com with SMTP id z64so1114575ywe.7;
        Thu, 15 Aug 2019 13:30:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8FtoZWxmjenZ99s1TgzzSkPwKWAhL+iPgH0tAhfsHxE=;
        b=VyQp5e/BtP4p0yqJjVL59nIssRaXIAKtJurk0Hjv+5MY5VgLivPZKB/VgRaY5L4pwv
         UoiyvbF4CCzq/QBErdMKYGrW8bYTat5H1H98/8tYK/hmB2aWdBAMr2V2qSeeL1vS1H6v
         V2oCTdbrgSPQwkO3nTbz4XQkQlYOH+967j61XkvQo5RKhUE3dTmk58uikAkWoSoHOUm7
         IXmIAHjl66lrzCtBI5gQ2dq9QKRCWZXRN02RUqBoMrp45gxKt/9HornSoz1jRMxff0BR
         nIqbSEkNCXxUbL7Of2vFbBCvlU9ErOs/rM+t8pvnqF8hvVjQv6zD7j/kRTfC+MLQoQPu
         3h5Q==
X-Gm-Message-State: APjAAAXs38ucfhzcWhVan6EiTTA53H4UkNHsP9cNrzHWfjxGKcN845c1
        oTry5EAH/L2YSAFnanVSO1c=
X-Google-Smtp-Source: APXvYqysP1FoTTm2159KLqqsIVAM8UEi8LXAtwl5JsTLy/boOc7RRlwPpaAzS1GzOLdjjPBfc3DzJg==
X-Received: by 2002:a81:ae55:: with SMTP id g21mr4533904ywk.222.1565901001047;
        Thu, 15 Aug 2019 13:30:01 -0700 (PDT)
Received: from localhost.localdomain (24-158-240-219.dhcp.smyr.ga.charter.com. [24.158.240.219])
        by smtp.gmail.com with ESMTPSA id u14sm836257ywg.67.2019.08.15.13.29.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 15 Aug 2019 13:29:59 -0700 (PDT)
From:   Wenwen Wang <wenwen@cs.uga.edu>
To:     Wenwen Wang <wenwen@cs.uga.edu>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com (supporter:INTEL WIRELESS WIMAX CONNECTION 2400),
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] wimax/i2400m: fix a memory leak bug
Date:   Thu, 15 Aug 2019 15:29:51 -0500
Message-Id: <1565900991-3573-1-git-send-email-wenwen@cs.uga.edu>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In i2400m_barker_db_init(), 'options_orig' is allocated through kstrdup()
to hold the original command line options. Then, the options are parsed.
However, if an error occurs during the parsing process, 'options_orig' is
not deallocated, leading to a memory leak bug. To fix this issue, free
'options_orig' before returning the error.

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
---
 drivers/net/wimax/i2400m/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
index e9fc168..489cba9 100644
--- a/drivers/net/wimax/i2400m/fw.c
+++ b/drivers/net/wimax/i2400m/fw.c
@@ -351,13 +351,15 @@ int i2400m_barker_db_init(const char *_options)
 			}
 			result = i2400m_barker_db_add(barker);
 			if (result < 0)
-				goto error_add;
+				goto error_parse_add;
 		}
 		kfree(options_orig);
 	}
 	return 0;
 
+error_parse_add:
 error_parse:
+	kfree(options_orig);
 error_add:
 	kfree(i2400m_barker_db);
 	return result;
-- 
2.7.4

