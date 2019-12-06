Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA3CB114B75
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 04:39:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfLFDjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 22:39:25 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:39749 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfLFDjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 22:39:24 -0500
Received: by mail-pf1-f180.google.com with SMTP id 2so2616600pfx.6
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 19:39:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WipYC30i9JGuCDCbBk6Z2CSjjhhcIDUv72WlSx01p30=;
        b=h7RU3mPbgT89CJL+1OFek734zu9biBvxdWZ3/SGN44Gby+DIQOnv9n2qTj82MTapze
         1twjGlQa1O62sJ0BjC1wbSCCjbhXmGJqkUdb6ay967dbL2jnzvy4QXTcMejl2XsF70Qc
         UB0wyNLODEGJBx8CK2sErL96E5yHUNHun9UTXI6vHangWf22Phg3E4SXJRzOnWIhwn0e
         uuHsjpOu13JaRs6STrkc74GXrXAzBTA5oGLGgb1I0Q/91gv/ubD+movGGvFLmBeMGPem
         CjGfDoQgGh5ZySufrCjcGryDILMa0kvxKmI6OtpPufXzcQzFD/fBPJbQwckiccaD4p2c
         uMaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WipYC30i9JGuCDCbBk6Z2CSjjhhcIDUv72WlSx01p30=;
        b=k7C8px4rf2Xomq6YN4jlyJLQ7GrnILqDqikEZnQKj7oNlwjawvSHkXOy9Vc0zyctcG
         EFgWhsaqV8TEIsc+me/i7NGuP0hONyzkXGc3r7THxyfH7RbqUG9PhMx/qHdP9lAuUnNt
         Gunhbo0Tcbpu61WlwB/sIjSP+xvPeJ5ywfQrsqm80LWbZLPddHrqcW2kl9RLW4Rx45HA
         5iyVkFgnL7+Qw4Pf7hxJ+Kjg3GsLLTR6C8Dh8C2P56KU+O3xVmVQKaOOpOTftnizZwM6
         nd7LVvwm1ukmYkcg0OsIQRZPvMZCPXJCcN8HekvEPD5nHw76RYIyrRG2ifIztr/LENtR
         R23w==
X-Gm-Message-State: APjAAAVtSq/N7taSougciRzFY1KsmVpiKS/ZzU7nI3XJo2FgkSoPVoD7
        TfxXBH8ZfizcXHA+1r6nU6oqe2xm9BQ=
X-Google-Smtp-Source: APXvYqyyWh0YQ5PSPKZSIiu2GPZ7PPBb6XO9657ilMsQ4lEE+akTw7bZPaXX85wKTWpC/S5IV7EQeQ==
X-Received: by 2002:a63:5062:: with SMTP id q34mr1177027pgl.378.1575603563859;
        Thu, 05 Dec 2019 19:39:23 -0800 (PST)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id l9sm12878327pgh.34.2019.12.05.19.39.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Dec 2019 19:39:23 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [Patch net] gre: refetch erspan header from skb->data after pskb_may_pull()
Date:   Thu,  5 Dec 2019 19:39:02 -0800
Message-Id: <20191206033902.19638-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After pskb_may_pull() we should always refetch the header
pointers from the skb->data in case it got reallocated.

In gre_parse_header(), the erspan header is still fetched
from the 'options' pointer which is fetched before
pskb_may_pull().

Found this during code review of a KMSAN bug report.

Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel lookup")
Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/ipv4/gre_demux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
index 44bfeecac33e..5fd6e8ed02b5 100644
--- a/net/ipv4/gre_demux.c
+++ b/net/ipv4/gre_demux.c
@@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb, struct tnl_ptk_info *tpi,
 		if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
 			return -EINVAL;
 
-		ershdr = (struct erspan_base_hdr *)options;
+		ershdr = (struct erspan_base_hdr *)(skb->data + nhs + hdr_len);
 		tpi->key = cpu_to_be32(get_session_id(ershdr));
 	}
 
-- 
2.21.0

