Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77015161FAB
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 04:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgBRDu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 22:50:29 -0500
Received: from mail-pj1-f47.google.com ([209.85.216.47]:53075 "EHLO
        mail-pj1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgBRDu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 22:50:29 -0500
Received: by mail-pj1-f47.google.com with SMTP id ep11so399870pjb.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 19:50:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xerYhA/fvUUMNFn4ar2McA52CLBUSySk7Gpr3dq0qwk=;
        b=Ayrdd7pdDbkWTXo6s3b/MZrgE+UK5KBw4iTkoZsnkVG+MXxNZGgtlWLKnZBjxSNDOL
         VrSkzaNIhWK7tYtzKA1ip5tyttx3NJX9seOEw0rspLdYjhPYWu7ORTmqc8AB2hzJPMjQ
         eCWT8oVgDAef7FouQchYpe66cyb7g/3g0EiqiqbdoFQZ62sUI0mrQdGht7xEuCsG5wyF
         VDXLP8sGe9x4qUpKF3Z4QtYImjWLQaHZoFpgKn/xA0jxg/YP/VoKoJ6RzuWW4veMVPnY
         zwKaScxXOS4gsM7tKceNKIofzhZZzIayIfQNRbOwWrVr48W5XbpOPc+Qm4RtJcLn8vzD
         USOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xerYhA/fvUUMNFn4ar2McA52CLBUSySk7Gpr3dq0qwk=;
        b=obIUZBSrj6lw2eNVkNRC3cgfgGwMNu9VVXz3ZtEC0HxiwHeiTVW7Kr+c2XQPfS1xes
         1HVFcsEo/1geYqpMo+x1a2C7uTOvzYxz8xXhGkVC05M+srQmtOSp7G2CD5yPeT4kC2OM
         SAUykGXb1B5B2yV2MUw2PJkCLK6jgQnrT53ytt2kCmc6KpDRf+bUZttnkrzgh1y5PSZN
         XamQgravmNGbrmhL64IEAoDi06PiQbNB6pNayuZs7x3Wuywwx9bcyrBEWOwrDeX2MJrr
         tY+ZzzXZnsV2oOPMbMF83Dn0A0EGSWTSTi5oikmTTBZF/jvE2ylfhojR0Dap4lOcFQCa
         0Vjg==
X-Gm-Message-State: APjAAAXpBgvq2Hdp/3+sQEC7WDKLoC5CaSFRmoNPTKdoJ07YS/iznk4Q
        tdYwbCNp8Ep4v4TR33zKOKi8MLzQdfY=
X-Google-Smtp-Source: APXvYqwR/4gqsBslrZU/yxbMJpgOd/RbZR3U8A7qOFuiNVRIyyO/WlqJg/MxYLi2rzb0v5mWmSm9dQ==
X-Received: by 2002:a17:90a:7187:: with SMTP id i7mr209184pjk.6.1581997828705;
        Mon, 17 Feb 2020 19:50:28 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l29sm2272432pgb.86.2020.02.17.19.50.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 19:50:28 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, stephen@networkplumber.org
Cc:     William Tu <u9012063@gmail.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCHv3 iproute2] erspan: set erspan_ver to 1 by default
Date:   Tue, 18 Feb 2020 11:50:20 +0800
Message-Id: <0719e2437448261ef83bf5d4e902481cad1a8e46.1581997820.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 289763626721 ("erspan: add erspan version II support")
breaks the command:

 # ip link add erspan1 type erspan key 1 seq erspan 123 \
    local 10.1.0.2 remote 10.1.0.1

as erspan_ver is set to 0 by default, then IFLA_GRE_ERSPAN_INDEX
won't be set in gre_parse_opt().

  # ip -d link show erspan1
    ...
    erspan remote 10.1.0.1 local 10.1.0.2 ... erspan_index 0 erspan_ver 1
                                              ^^^^^^^^^^^^^^

This patch is to change to set erspan_ver to 1 by default.

v1->v2:
  - no change.
v2->v3:
  - add the same fix for v6.

Fixes: 289763626721 ("erspan: add erspan version II support")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 ip/link_gre.c  | 2 +-
 ip/link_gre6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/ip/link_gre.c b/ip/link_gre.c
index 15beb73..e42f21a 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -94,7 +94,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
 	__u32 erspan_idx = 0;
-	__u8 erspan_ver = 0;
+	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
 	__u16 erspan_hwid = 0;
 
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 9d1741b..94a4ee7 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -106,7 +106,7 @@ static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
 	__u8 metadata = 0;
 	__u32 fwmark = 0;
 	__u32 erspan_idx = 0;
-	__u8 erspan_ver = 0;
+	__u8 erspan_ver = 1;
 	__u8 erspan_dir = 0;
 	__u16 erspan_hwid = 0;
 
-- 
2.1.0

