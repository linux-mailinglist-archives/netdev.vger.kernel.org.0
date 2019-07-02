Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88F5D2BF
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727055AbfGBPYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:24:11 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:35179 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGBPYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:24:11 -0400
Received: by mail-pg1-f194.google.com with SMTP id s27so7853195pgl.2
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=H5YVno4WCiXQA9eWbK1LzW9cfzXvcKQqHrSxyIbLeis=;
        b=uP9+GkbBlZ/FeAN0XdLlB89EUUqPpQ5JfsU9U2xLGHnnBo4HJRly73sA/RWzKMFItO
         Wxpnk62o4W1nKWps/ww7LI+G32Je3hhTIZ+EmgTUh4dRnCnFcXpJq90XN3MKnFi46t8r
         dcxxiXIDSim794fObnad9P7H41erD5Tk+TKc6F3zpGLRdlAr5muFPwN//p4obVaDgoXc
         r5mHKsHL2DYXeuUjLYuTcI25wkSrrB+uJUnZ5ZtUMjB5eqlKYy8nxsiSEyehpvUQsTDA
         ixMLWULl8qyLgF9VxIYvCuXfkBDIFUMe6xNP9BKIkh/3JlMnNYGYtV4vW3+xMa8fchSQ
         r/rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=H5YVno4WCiXQA9eWbK1LzW9cfzXvcKQqHrSxyIbLeis=;
        b=qaWtAATbBzCYtvIfu6++dl8/Yhs8y8rZoDSqMCCyMq/odKLen/pOApDcc7P9ZgsVvv
         WCZtx1/vrGUahfRbcwHm/LQkk+5NtFC5G2aAmxzZhogjrcT81kDLas2MB+0RgHM9/Y0R
         QPiSV3ksVIpeqUAujm52Fxfm5h5wPorG5A12jQ7S7gJjzwWZWJcL89p8fiD7jpKo2Wcf
         3lqXbrVWbB3EVhOMk4v3OLq83ospMaSSXEk8XFioCsrtZZE6tbu4KdU9oeOJYDRFGBQ7
         cY96XPm0dbWN+1dVMqzyZPubbJtW2tIIgJ0R9+QeiA4RSMpKp8AT5kuVH5G4FPVmYVLq
         QCGg==
X-Gm-Message-State: APjAAAVByfK2drNblLH7JvGvxpwr9jmBDoQKGZO1SqzoiypzCrY6X7CI
        hAI42civMmkAMA8IR9tvxh8=
X-Google-Smtp-Source: APXvYqyylfXXBNTXrVGLKG2VV7I1hXPpSWCUk5AeP8svx2I4AaA2XJTxuHzhC8yPUX+4GuFLCixNNg==
X-Received: by 2002:a63:6986:: with SMTP id e128mr32602107pgc.220.1562081050733;
        Tue, 02 Jul 2019 08:24:10 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id d2sm15133462pgo.0.2019.07.02.08.24.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:24:10 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 6/6] gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()
Date:   Wed,  3 Jul 2019 00:24:04 +0900
Message-Id: <20190702152404.23210-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If an invalid role is sent from user space, gtp_encap_enable() will fail.
Then, it should call gtp_encap_disable_sock() but current code doesn't.
It makes memory leak.

Fixes: 91ed81f9abc7 ("gtp: support SGSN-side tunnels")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/gtp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index b3ccac54e204..ecfe26215935 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -857,8 +857,13 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
 
 	if (data[IFLA_GTP_ROLE]) {
 		role = nla_get_u32(data[IFLA_GTP_ROLE]);
-		if (role > GTP_ROLE_SGSN)
+		if (role > GTP_ROLE_SGSN) {
+			if (sk0)
+				gtp_encap_disable_sock(sk0);
+			if (sk1u)
+				gtp_encap_disable_sock(sk1u);
 			return -EINVAL;
+		}
 	}
 
 	gtp->sk0 = sk0;
-- 
2.17.1

