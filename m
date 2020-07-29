Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA5FF231EF2
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 15:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgG2NEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 09:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgG2NEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 09:04:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1C8C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:04:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so21560570wrh.3
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJOyUVG9VRNOOWz3sUVJjIxo3A/FXy36ItZQ1zCHGXg=;
        b=adxz9Ej8igCLpdpCQ5K7DA23tLvKFtOAlc6jDhlKiMwifPKZ2gk1soKlK3fS2tigrX
         pvhsoPIcldDJoIN8Aj8JSyzW1ntS8jSfWmNlchvYiiqoTZT4wPl9+oHxWSxweN92ukF0
         CkzgUwUKcHRF0F3LJlBI4v/Q6n6vEWFy4G5+E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yJOyUVG9VRNOOWz3sUVJjIxo3A/FXy36ItZQ1zCHGXg=;
        b=VLg1MmlpvvPJ2fe9GYZtqncOx8ra0sIKAxWuQxZx/4JP2jXNeTFk2JhtaqaY85MW6b
         LIbexxdOgaeCNY+N18oD51H6K/0fWClfY8sGE73sUlOa0UaCmQoVVpA+aRHkEDD+hQOz
         hFgO0RPwWsEjsTxJUeYOuTJTFqV1swG4uGfO+iX0ybnwrQ8hf/N5RYY8prNBG5zWXarp
         O06aclrM0uR/Un7y6x9MKcXEqXbg9iBbp++IROck3vjkE2EVaeMxm9bmfTk+QXyD7TKJ
         iNn/BnMMNNM4N7SfONTm58zBkAtoUL1cFx0xKFcAvWJe5n6fftwYM7HAIRXfuwQXNQFe
         Ouuw==
X-Gm-Message-State: AOAM532h8mmMSc778eYKDKyOWeliFjtFUFy0bVg3Dr/XOhXugRTcj7J1
        j3DtWCwKrAcu3FqvVyA5MUD9p55elQ==
X-Google-Smtp-Source: ABdhPJwK4BeGIceGQXh+8O2l+MDJORkdHkuobeIrzm8gfups4urLqhmUlz8CsbHgcsgJ+ik53fl2SA==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr28655209wrf.309.1596027879632;
        Wed, 29 Jul 2020 06:04:39 -0700 (PDT)
Received: from localhost.localdomain (82-64-1-127.subs.proxad.net. [82.64.1.127])
        by smtp.googlemail.com with ESMTPSA id 68sm5672575wra.39.2020.07.29.06.04.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Jul 2020 06:04:38 -0700 (PDT)
From:   Julien Fortin <julien@cumulusnetworks.com>
X-Google-Original-From: Julien Fortin
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, dsahern@gmail.com,
        Julien Fortin <julien@cumulusnetworks.com>
Subject: [PATCH iproute2 master v3] bridge: fdb show: fix fdb entry state output for json context
Date:   Wed, 29 Jul 2020 15:04:25 +0200
Message-Id: <20200729130425.4303-1-julien@cumulusnetworks.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Julien Fortin <julien@cumulusnetworks.com>

bridge json fdb show is printing an incorrect / non-machine readable
value, when using -j (json output) we are expecting machine readable
data that shouldn't require special handling/parsing.

$ bridge -j fdb show | \
python -c \
'import sys,json;print(json.dumps(json.loads(sys.stdin.read()),indent=4))'
[
    {
	"master": "br0",
	"mac": "56:23:28:4f:4f:e5",
	"flags": [],
	"ifname": "vx0",
	"state": "state=0x80"  <<<<<<<<< with the patch: "state": "0x80"
    }
]

Fixes: c7c1a1ef51aea7c ("bridge: colorize output and use JSON print library")

Signed-off-by: Julien Fortin <julien@cumulusnetworks.com>
---
 bridge/fdb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/bridge/fdb.c b/bridge/fdb.c
index 710dfc99..d59bfb34 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -62,7 +62,10 @@ static const char *state_n2a(unsigned int s)
 	if (s & NUD_REACHABLE)
 		return "";
 
-	sprintf(buf, "state=%#x", s);
+	if (is_json_context())
+		sprintf(buf, "%#x", s);
+	else
+		sprintf(buf, "state=%#x", s);
 	return buf;
 }
 
-- 
2.27.0

