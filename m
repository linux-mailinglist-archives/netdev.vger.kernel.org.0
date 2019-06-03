Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9288333B04
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfFCWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:18:03 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45652 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfFCWSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:18:02 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so7729977qtr.12
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=loXo940mcEkH/jomhFLC5bEI3h7MvT135dQq0Y1WCwU=;
        b=RjnY+W1Oscb1pUXKk6AOTEavhg3y+YyagZ+b9VikfUoeU8nG6n9q5B6yezptE7Jgi3
         +2qY+PfoWMIh4j8QWdqgPPUWCVHsh5GarFlAL+TlYWuggvLCQ27gLFCu2Ul78KOVrSzB
         mwgcDRqJHSGzr6pOp3zvgidTul7mdoYBa6c5BW1kR7djxcwI+k5N+dDOhiXKzfEcLtec
         mI0NDQyxmwXMusIY/K8tlzCYY9Cm9Ca8m0xbrkYD0s7028y7ZxhhPgT5aDq9/iBprFQp
         OZhP9XQ/HE5Qr7fSvIMNxLGL8n/kTBARAraWfT8I3g1AONsMrabhTASqxduQ3/1mRRvW
         3P5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=loXo940mcEkH/jomhFLC5bEI3h7MvT135dQq0Y1WCwU=;
        b=HkEbflMy3c77wm+78acliMz5UW04/w4EeXiSBSIwmpNerz7kDdqwTzo6uc8YkIYxcK
         mXwsBJPnUFphnJ0eZwcNs4DZXW4iWQX3vH8YEg+KRYO5FSl2RoKZoS37MAS9xkXGuxqn
         +MxqkSf+PngBKK6KI9cbwVUpi9YkbQPDXqQSy/jPmBE3OJH/ni1PyZ7yGoBcwp+c0HwX
         3MpQdv2XZ0Sf5UhHTIoR5P9KoWggnM8oRM5zyYCPLNtiilEcJ3TUViLCOs4NcTpVrpFx
         wpYmQg1w4j+pNnQ42guvw3weu+CXGvFz9w0ewd0UcB+xrrprkejLlea1QkrIgFc0J4sh
         pqHA==
X-Gm-Message-State: APjAAAVsE5NheLm286l7P+1/KFy77qc6DPfSgT2jomrAQMbHNetKU1Xg
        Dd5JtZ7mTr02AZIRcRaZHi3vhg==
X-Google-Smtp-Source: APXvYqxw+reDKMm2OeXh2ZEB5DW0QyMthcUd08/j+Jxb4wIKlRb5i3pbrnCJPc5mS/6TWLK/aZMBuw==
X-Received: by 2002:a0c:add8:: with SMTP id x24mr24673957qvc.167.1559600281469;
        Mon, 03 Jun 2019 15:18:01 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.18.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:18:00 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 4/8] net/tls: don't look for decrypted frames on non-offloaded sockets
Date:   Mon,  3 Jun 2019 15:17:01 -0700
Message-Id: <20190603221705.12602-5-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603221705.12602-1-jakub.kicinski@netronome.com>
References: <20190603221705.12602-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the RX config of a TLS socket is SW, there is no point iterating
over the fragments and checking if frame is decrypted.  It will
always be fully encrypted.  Note that in fully encrypted case
the function doesn't actually touch any offload-related state,
so it's safe to call for TLS_SW, today.  Soon we will introduce
code which can only be called for offloaded contexts.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 net/tls/tls_sw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 960494f437ac..f833407c789f 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1492,9 +1492,11 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 
 	if (!ctx->decrypted) {
 #ifdef CONFIG_TLS_DEVICE
-		err = tls_device_decrypted(sk, skb);
-		if (err < 0)
-			return err;
+		if (tls_ctx->rx_conf == TLS_HW) {
+			err = tls_device_decrypted(sk, skb);
+			if (err < 0)
+				return err;
+		}
 #endif
 		/* Still not decrypted after tls_device */
 		if (!ctx->decrypted) {
-- 
2.21.0

