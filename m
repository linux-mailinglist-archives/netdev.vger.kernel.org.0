Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AEF0813
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729873AbfKEVRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:17:25 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43975 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729656AbfKEVRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:17:24 -0500
Received: by mail-lf1-f66.google.com with SMTP id j5so16242815lfh.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:17:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AS0orDHI3+2Aj1n4T3xpW3UEe0kOtpE+/5HDJjkQqdg=;
        b=kyE2pQ/fswbSs5a61kRTlD+sq+0/sTfH2PscBlRXcuNxR3XSDAB3WuR01YO868qvOF
         SeCCu7OdhmxgTxz6QyUG8Dap92P4f2CClb3t3k99nHV/5M8WuryrL4V4kHhUgPO+08ur
         xsDY73Q9YLoSCr14Cm9q3hpd/IHGm+BMBu/FbmcmXQsHG6Zf7YGfNIMH/ppfHGd7vUFx
         QLuU/eXQYttMkJ1IsMWXeAD9JteY7oidqGAF/56bnE143VcKvclZZUDnrjnKlX3xcWiL
         jSMiFxiuOPHrk7tQAfSu5CEVqyLpTmyL2h0dpYGjqIXmYxJh6aWYIR0+BNp8HRxOiloc
         bsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AS0orDHI3+2Aj1n4T3xpW3UEe0kOtpE+/5HDJjkQqdg=;
        b=ZZwz8hpWO9pUoCx+y9LSwaWloqvi+bhorCqhcooEKyNvGLHWw2RKFF6RPO5ChhNKkG
         gSjYWrs3MHI02B6uJ7lR0UKAZ0lxlxJawW7P2KtNAMfiqblfZrGJDc95QaX54RmUKmNb
         u2Pddmu8/iQk3TYBK89xs+DHqlSJuPtxnH81WF/0GEIbNhP3mJ653xEGODstncMNUdYB
         CjxpnVUVMZbCx8KsGydgP2pvTgvLIxDVjoa99zxPbFeQ2fPvNA5/NV3ktmMPQzE+ucMl
         mXrR5qObxmnqdUUwXeIrr61PuZxuCMfeEYSAiToi2YGiRDI/alVZnEh3h437OGQ0H1mb
         gAwQ==
X-Gm-Message-State: APjAAAWyoCBetlSMZdn+iXvGsqlTEiHpjXS+UqTz8gP84CoL/UiNvf3e
        U3h9J6Or9k2kNHnHC1nJt3zDPw==
X-Google-Smtp-Source: APXvYqxWucwznAkePSmY7fvVnrNCjho7Hq5+TOB9e9PtUY5Y0NHgTWSVTPFiFfXLyeOOMcPaRZFR+Q==
X-Received: by 2002:ac2:4d10:: with SMTP id r16mr22745781lfi.70.1572988642570;
        Tue, 05 Nov 2019 13:17:22 -0800 (PST)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 81sm9861270lje.70.2019.11.05.13.17.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 05 Nov 2019 13:17:21 -0800 (PST)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     dsahern@gmail.com
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, jiri@resnulli.us,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH iproute2-next 1/3] devlink: fix referencing namespace by PID
Date:   Tue,  5 Nov 2019 13:17:05 -0800
Message-Id: <20191105211707.10300-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191105211707.10300-1-jakub.kicinski@netronome.com>
References: <20191105211707.10300-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

netns parameter for devlink reload is supposed to take PID
as well as string name. However, the PID parsing has two
bugs:
 - the opts->netns member is unsigned so the < 0
   condition is always false;
 - the parameter list is not rewinded after parsing as
   a name, so parsing as a pid uses the wrong argument.

Fixes: 08e8e1ca3e05 ("devlink: extend reload command to add support for network namespace change")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 devlink/devlink.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 9c96d05ea666..682f832a064c 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -345,6 +345,12 @@ static void dl_arg_inc(struct dl *dl)
 	dl->argv++;
 }
 
+static void dl_arg_dec(struct dl *dl)
+{
+	dl->argc++;
+	dl->argv--;
+}
+
 static char *dl_argv_next(struct dl *dl)
 {
 	char *ret;
@@ -1460,7 +1466,8 @@ static int dl_argv_parse(struct dl *dl, uint64_t o_required,
 			if (err)
 				return err;
 			opts->netns = netns_get_fd(netns_str);
-			if (opts->netns < 0) {
+			if ((int)opts->netns < 0) {
+				dl_arg_dec(dl);
 				err = dl_argv_uint32_t(dl, &opts->netns);
 				if (err)
 					return err;
-- 
2.23.0

