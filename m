Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F38E5DA5F
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 03:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfGCBKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 21:10:24 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41793 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 21:10:24 -0400
Received: by mail-pl1-f195.google.com with SMTP id m7so229424pls.8
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 18:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=upcQJVUXF2P8RFoQW3rHZSKflzeQU5Q2gI0H8MqI5NI=;
        b=2IP/zI06toBzHwsXMk0535bXtGZzQISSXhxQnTLvK7rM9CbSgsoXsbjOrXgciCnyri
         k9ZPnKBmK+zeln1aeiFozOR0Ynur2psFRPn+ymFdQ/RrkWlF7smIe97yxFUfusth/KSn
         9BykAHyBWKbH4Zx8aHHp/DuSzDMGRb9Pz4fxu3n7LCqCfa+iUbXFWo/YsXe+X1GW0TLS
         +K6CBH7okFtCgJvR6JRNdl31S65CivtqBiQiabuwQ+4i1B1nIxZje8487QLqwBNwnsGZ
         J58DfIQrTTmuTxv3kwCfwVG71xemjX9Bt67W1/k4r11p0UmkzLxXHCJl+MqNHNCs+ke3
         ifrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=upcQJVUXF2P8RFoQW3rHZSKflzeQU5Q2gI0H8MqI5NI=;
        b=Bkh7BvRL0u0T51EQZ26AlpFORP8ekhMrkG++bJ9K171GkdibAcjwl2VTSwuCDq7rNz
         wkT0D7bB86doxrJRWW+OTSeKf1btXd5nNBTAghEksAOGceDPG3TjSant+ufjzOwelTPd
         n+RqxXNwnhIjfrkfaP6ubAnMTftrrpEHD0yeNuKkRJtDDFbSjlUSnWQy6LFHMX1KmkW1
         npuw4swTQ18k6lx8xVTLi0Q9/QxFGMxQQeVcJ0j9mKj3aLJS4OKibjUq8iB3eai7JIEy
         wk826oBE0un7h2VSSW1cxpMeLz3CepkcVJldZs8NEX1ZSwK5s368ScErAMo+gqE4zM6a
         KtFQ==
X-Gm-Message-State: APjAAAXgY4v/NCOvy+rrvFGU+ausN9x7EO8ssIWGSFdiPYofjbvxdUkP
        YDCqaB8tu3uy9MGbU73AFR7V8mBPIvw=
X-Google-Smtp-Source: APXvYqyV2+Upl4oXqleSMgUbVgn2FDTE/ACd8Q+pqJd6CcfBPjf9RoBMPbKesUSdk2PA0EtbUpo8ig==
X-Received: by 2002:a17:902:9041:: with SMTP id w1mr16904440plz.132.1562106029378;
        Tue, 02 Jul 2019 15:20:29 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t32sm137998pgk.29.2019.07.02.15.20.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 15:20:28 -0700 (PDT)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH v2] net: don't warn in inet diag when IPV6 is disabled
Date:   Tue,  2 Jul 2019 15:20:21 -0700
Message-Id: <20190702222021.28899-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IPV6 was disabled, then ss command would cause a kernel warning
because the command was attempting to dump IPV6 socket information.
The fix is to just remove the warning.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202249
Fixes: 432490f9d455 ("net: ip, diag -- Add diag interface for raw sockets")
Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 net/ipv4/raw_diag.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index 899e34ceb560..e35736b99300 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -24,9 +24,6 @@ raw_get_hashinfo(const struct inet_diag_req_v2 *r)
 		return &raw_v6_hashinfo;
 #endif
 	} else {
-		pr_warn_once("Unexpected inet family %d\n",
-			     r->sdiag_family);
-		WARN_ON_ONCE(1);
 		return ERR_PTR(-EINVAL);
 	}
 }
-- 
2.20.1

