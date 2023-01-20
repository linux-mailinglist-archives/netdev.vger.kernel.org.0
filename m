Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09B9567552F
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 14:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230400AbjATNC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 08:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjATNCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 08:02:55 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F05ABCE06
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:02:54 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-4c2d68b6969so49230817b3.7
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 05:02:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3wOD9yCy+fUCPxUtDRCPTMoxl6dqkzD1U7ynRB9tyEc=;
        b=ixKEBa+pYn27SLirJt0Ck9fjVK/WNAZRQ2md1kEoCGK5/Akb6ooHxPAPaWJLEem6Xr
         07PvSYoQs6lMllkiZMLxuiUacqe/Cg/REtiBssc2DEJxkekLUt03wzoLg7q5J8xrB/Hh
         mwhxD+n487vKmkgqBr4osoNlfCMOBgPVZ7Km2uRj4Q0S2ho3D0uMuKv3y+/0f2WllJPV
         /fn1Cj37qX32uPlRR8i8PTNw+ibZ4r23ccc1fkQ0jSwwtwOu6oQOueNwkEt96kNSGhu6
         oXd6rHslgWMcUnz3gcc58EySOUZXExdn6+Fzb63rmsOeLHUuXacSCi+DNP10PqNbnhwz
         05vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3wOD9yCy+fUCPxUtDRCPTMoxl6dqkzD1U7ynRB9tyEc=;
        b=61B0KYJtXjv24q6cRlYlv/JY6qp1MNR3MLl9Ogt9RyHsXJW+9vCzjBMa6cB5ZhGS5q
         zyaVQrrZqleS2WQNnWgI95d4+VG/LtTIvHZGQXowv1qdzptlVqQRYkiX9C3OcHLAVhnj
         QlOwLfbdqHRRFPfG/gXiDRdY90GdCMftcsU5LGIBYcD/CqqqZHNL0uHWChEdSBxBA5TU
         nWYO1nlrdvCx+f6f4+CraOo7q4EB5cTlxA9MpgdUncyJB5pUJhz+tpTOUM/5vrnDTRji
         UlQL7O4HuvtN2rvjJEnDmumbKCDrDOUl9zA/tRiFsEYyAEAotqlBinPp7ausgUl1/loW
         WVcQ==
X-Gm-Message-State: AFqh2koDJCTDOF7+/6rVG0IcCRR+rB4d0O9lLXC+6Qdo4Tx1z1W+9btd
        b+3EthlDGT5H/IOGbI3Vi2XCHixJGw1N6w==
X-Google-Smtp-Source: AMrXdXvcrd4n7B47VXz5JrL6i20OED/DOVqiuOcwKoQtmjvOQV9fdHj/PWPwy8Vc5Vb3MenmLskjpZ0BjXTLwA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:8383:0:b0:7ec:b507:1211 with SMTP id
 t3-20020a258383000000b007ecb5071211mr1828516ybk.483.1674219773396; Fri, 20
 Jan 2023 05:02:53 -0800 (PST)
Date:   Fri, 20 Jan 2023 13:02:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.1.405.gd4c25cc71f-goog
Message-ID: <20230120130249.3507411-1-edumazet@google.com>
Subject: [PATCH net] xfrm/compat: prevent potential spectre v1 gadget in xfrm_xlate32_attr()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  int type = nla_type(nla);

  if (type > XFRMA_MAX) {
            return -EOPNOTSUPP;
  }

@type is then used as an array index and can be used
as a Spectre v1 gadget.

  if (nla_len(nla) < compat_policy[type].len) {

array_index_nospec() can be used to prevent leaking
content of kernel memory to malicious users.

Fixes: 5106f4a8acff ("xfrm/compat: Add 32=>64-bit messages translator")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dmitry Safonov <dima@arista.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index a0f62fa02e06e0aa97901aaf226dc84895f6a8ec..46bb239e4f06d56abbf3deecd89ac26625efb560 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -5,6 +5,7 @@
  * Based on code and translator idea by: Florian Westphal <fw@strlen.de>
  */
 #include <linux/compat.h>
+#include <linux/nospec.h>
 #include <linux/xfrm.h>
 #include <net/xfrm.h>
 
@@ -437,6 +438,7 @@ static int xfrm_xlate32_attr(void *dst, const struct nlattr *nla,
 		NL_SET_ERR_MSG(extack, "Bad attribute");
 		return -EOPNOTSUPP;
 	}
+	type = array_index_nospec(type, XFRMA_MAX + 1);
 	if (nla_len(nla) < compat_policy[type].len) {
 		NL_SET_ERR_MSG(extack, "Attribute bad length");
 		return -EOPNOTSUPP;
-- 
2.39.1.405.gd4c25cc71f-goog

