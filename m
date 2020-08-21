Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27D2724D6B3
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 15:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgHUN4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 09:56:15 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:39722 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728130AbgHUN4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 09:56:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598018169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=iYHZ9rEeh+4mirTCdwtBo4QZdb8y4a+LohJ/ODv3tOY=;
        b=TKFCMB1yh2oS5NCM2UAW9ACq0HtNvO3WfTTyJA3+p0JzQOL6TnMEJk7t/q5EYd116owqDI
        EBAmMtDA/tKf0GeD4+3vmAvsnoy4C6iEtRdtctpc5u1/v98MuBY+ydYCLGVnP7+66lvWH9
        WrLhXkz+Fct79WQs95Mc29JzCwz6Qu8=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-386-c2gcb0q2Mbqc5meVRAxdcg-1; Fri, 21 Aug 2020 09:56:07 -0400
X-MC-Unique: c2gcb0q2Mbqc5meVRAxdcg-1
Received: by mail-qk1-f198.google.com with SMTP id n128so1443455qke.2
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 06:56:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=iYHZ9rEeh+4mirTCdwtBo4QZdb8y4a+LohJ/ODv3tOY=;
        b=UjvA8/3k24t/FielNM+Mc2fLX0lbRKIuNSCWW0C3FVwcyCjdeQzKmViLrd3L97idBh
         L47Tn+P7gReN0rOTWvOzZlDB8tZZvtyf5e2kFlj9YcS1KuqX53qRr7trwp5B/eAefKPX
         jUn0XcZgB2zKb42cDJqGfZdZjPQS5er1RMM5T/+kc3zHIz7uj3WbvLKPqg2QfCOfooYM
         nXhaUV/FveSomycTCSYV/e7t+6Wa9p2h/kePkfMfdqFDDwlr3db2w9QC5/Zp1PjJYbmF
         rGEwyYq9y+OMDhNZHplrfiW4yMt3SBpIpoR3lGhRaKl8yFu9jvklRYwGmdewvpUATONT
         C/7g==
X-Gm-Message-State: AOAM532m9fkdJKLA/GJvSLh08/5eWS4QOjZWq4U+JbX/pYgssRTp2f+t
        YzQvPwz66LoallbiisDkY+/wn+y5RmO4dW1W+rhblhmaZO4YjUV8EQKNE9VUFeYS9/AyDmC2iqY
        5GT4pgQwCVijDcHAQ
X-Received: by 2002:a37:a797:: with SMTP id q145mr2612662qke.13.1598018167019;
        Fri, 21 Aug 2020 06:56:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1o7ZF4qH1t8r6ITbYV6KemBEtJ5AJ+GkcUjHtK9cXYSjNa2zcI8bL6ZWuEDg1nNcYpIvT6w==
X-Received: by 2002:a37:a797:: with SMTP id q145mr2612640qke.13.1598018166747;
        Fri, 21 Aug 2020 06:56:06 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id a67sm1717700qkd.40.2020.08.21.06.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 06:56:06 -0700 (PDT)
From:   trix@redhat.com
To:     f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] net: dsa: b53: check for timeout
Date:   Fri, 21 Aug 2020 06:56:00 -0700
Message-Id: <20200821135600.18017-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

b53_common.c:1583:13: warning: The left expression of the compound
  assignment is an uninitialized value. The computed value will
  also be garbage
        ent.port &= ~BIT(port);
        ~~~~~~~~ ^

ent is set by a successful call to b53_arl_read().  Unsuccessful
calls are caught by an switch statement handling specific returns.
b32_arl_read() calls b53_arl_op_wait() which fails with the
unhandled -ETIMEDOUT.

So add -ETIMEDOUT to the switch statement.  Because
b53_arl_op_wait() already prints out a message, do not add another
one.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/dsa/b53/b53_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index abe0a3e20648..e731db900ee0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1554,6 +1554,8 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 		return ret;
 
 	switch (ret) {
+	case -ETIMEDOUT:
+		return ret;
 	case -ENOSPC:
 		dev_dbg(dev->dev, "{%pM,%.4d} no space left in ARL\n",
 			addr, vid);
-- 
2.18.1

