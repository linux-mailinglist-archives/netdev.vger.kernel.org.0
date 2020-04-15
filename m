Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF681AAA79
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370839AbgDOOkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S370819AbgDOOkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:40:23 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818DEC061A0F
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:23 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k28so2798806lfe.10
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 07:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AVCFFN+RExCPz+0pipPO4RfMJ3qPdoajAh19ljXWUko=;
        b=SVCzrPxeeiSU5ag82YnjJPLo2dop6HOXzb4g+8flS00wPEQWGASjezHYu2Eba1knSq
         Ze1qqK7XLyOZAGThCk7f3+rMNniy6hbNjfmxu5z1jqJcziQgQ/WmZwAFiXgik8yRlifc
         kla7ESHSisr8ZT2zVwleYVWcScftBKuzo42NeqjRvr8fUknHOn2DdRbXdaptaTnVvePS
         N5TTL04Q/Y7UUA7l8rHVUA2WWLKiMcKxpuqR3o7Lc8R/aMmlye5MJ1W3y05mOtaq+zAh
         +HT8y92f3QCe54p1dqWb5hgPucf8FJLM6Lv0Kz+AIUN83q8iCy4HHUOe1kfORPr/0LFc
         CsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AVCFFN+RExCPz+0pipPO4RfMJ3qPdoajAh19ljXWUko=;
        b=NYvXu2ILNoAgDvbD1ZfAp/fnmI9JfF4KKqoRPZyolN2NXlSeWvAOwVQr/pIkKSE0EW
         4dJHGKsH3GBGURm9e2cVDnHIDpPNzrS5yxiY9zN1RJlb40PpoH/X1UkajneSRUQJ2Rqm
         j55oVmvGVBtxXu8lECyjK8Rhmh528X9UylUlayYszvWnqGN6ttkkNUR92NVbwZ32pdPn
         1VVX3N+y7xNz6ZIhAQXa/zmw/LFRn0Ez1gEhfMWqi/5TchLqqrReXn5kLwv58z7f37fX
         YCgnjhjwJJAcnwmJkbB7hbIA3IWjUVNInxo69J2/3Z9pWUgRWqBXDid8P4pUxZAZo3CD
         Lsog==
X-Gm-Message-State: AGi0PuaSuBD7st9hwnGSbkSapy+FrbPhRIA1YGjE7V+M01mzheWPwsJm
        Ax7LYLVtfTAqJyN98/xvGK9iXQ==
X-Google-Smtp-Source: APiQypKDYQCkzyaOKUKe2LPMESlaOckDDZ3AoQc3Lq3rJMXGR+6fUbKBnsVDzggemqBiIBpNsjoFCA==
X-Received: by 2002:a05:6512:3b0:: with SMTP id v16mr3257804lfp.213.1586961621951;
        Wed, 15 Apr 2020 07:40:21 -0700 (PDT)
Received: from xps13.home ([2001:4649:7d40:0:4415:c24b:59d6:7e4a])
        by smtp.gmail.com with ESMTPSA id l22sm1860327lja.74.2020.04.15.07.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Apr 2020 07:40:21 -0700 (PDT)
From:   Odin Ugedal <odin@ugedal.com>
To:     toke@redhat.com, netdev@vger.kernel.org
Cc:     Odin Ugedal <odin@ugedal.com>
Subject: [PATCH 3/3] q_cake: detect overflow in get_size
Date:   Wed, 15 Apr 2020 16:39:36 +0200
Message-Id: <20200415143936.18924-4-odin@ugedal.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200415143936.18924-1-odin@ugedal.com>
References: <20200415143936.18924-1-odin@ugedal.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This detects overflow during parsing of value:

eg. running:

$ tc qdisc add dev lo root cake memlimit 11gb

currently gives a memlimit of "3072Mb", while with this patch it errors
with 'illegal value for "memlimit": "11gb"', since memlinit is an
unsigned integer.

Signed-off-by: Odin Ugedal <odin@ugedal.com>
---
 tc/tc_util.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tc/tc_util.c b/tc/tc_util.c
index 5f13d729..68938fb0 100644
--- a/tc/tc_util.c
+++ b/tc/tc_util.c
@@ -385,6 +385,11 @@ int get_size(unsigned int *size, const char *str)
 	}
 
 	*size = sz;
+
+	/* detect if an overflow happened */
+	if (*size != floor(sz))
+		return -1;
+
 	return 0;
 }
 
-- 
2.26.1

