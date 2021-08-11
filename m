Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1993E880C
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 04:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231990AbhHKCh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 22:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231699AbhHKCh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 22:37:28 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7722C061765;
        Tue, 10 Aug 2021 19:37:05 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cp15-20020a17090afb8fb029017891959dcbso7316901pjb.2;
        Tue, 10 Aug 2021 19:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c34YqbDj4H2LkHIxUJ62k4rMkPDaBHR70bxWD8IA/H8=;
        b=e9gDwcexdW+buNc728tSZSTDkMYQCZ8NLHBQgiANGkb1skl7uhP3dgDQzwR9/1pDFE
         3KUbLGVxjJ+Abb8IHtezOFIoNwqcTd+Oopw50ieDYlwJe2S7Znk/MyIKwu/JSO1bQlTc
         kwavT97aiZ8tVsbMCP8t05MLqXo7ahF1onj34Hh5rKm5jCtiVJ5UiPLTm7Mp8FPP5Xb3
         ui5zDg5rr9ka1F2X9Q1BmtGeWDvAsmcq+d53nRhVRAh0Dw3bEFqs2jEMhTfFht55mbku
         vYSFNcPq+7WcWM9UsXuTfhY1aGw/r98qfJ1CQTVDv1P7UyJIN52gOgjya300YhKfX8wy
         +HSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c34YqbDj4H2LkHIxUJ62k4rMkPDaBHR70bxWD8IA/H8=;
        b=rzptiEqCCOt/xeGhHzgwvi/OyVBSKileS33ubXlcRpScHYrxq9sx9hTBfeNinW1cwe
         s8FD5x+JsRd5LG/jBwo35406vWmyCm4XsdUdWBtT0kSY1OW7Dz0ATluw23v5RkeOwnYx
         jOK1e/FG7TIB9+Y08SnLZMc+Jn6zoNJ6WAAKyamEXbXC7gzgcS7I0rY3S+S598Y+muVJ
         1RZjpaoH0aAauQ+0yitkZ3ILOfinIuHayCmQ256wuEdtTWXnqqEmbky47mAVNusIHNeh
         PH6NclwYIYtXYr95HNwoadIZ4lHbKDXh544gWO5c7xgIHEshXetlS8ukBbKqy22SgiKH
         A03g==
X-Gm-Message-State: AOAM531d3M0sXEru0FrjJlsB8ODJI6RJO8SrmS6E4g8hx9KjInuA8WYT
        LT855mR7PV3RDqyqvhF120c=
X-Google-Smtp-Source: ABdhPJxeuzMTAdfuaWG3SE+gfJ7vLtU8abmwxbRvqmjSGRsIdZrRxNFrczjRApq+qN5EnIJCY6GIhA==
X-Received: by 2002:a17:90a:ab07:: with SMTP id m7mr33714953pjq.27.1628649425179;
        Tue, 10 Aug 2021 19:37:05 -0700 (PDT)
Received: from localhost.localdomain ([45.135.186.103])
        by smtp.gmail.com with ESMTPSA id l185sm18044975pfd.62.2021.08.10.19.37.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 19:37:04 -0700 (PDT)
From:   Tuo Li <islituo@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
        Tuo Li <islituo@gmail.com>, TOTE Robot <oslab@tsinghua.edu.cn>
Subject: [PATCH] ieee802154: hwsim: fix possible null-pointer dereference in mac802154_hwsim.c
Date:   Tue, 10 Aug 2021 19:36:54 -0700
Message-Id: <20210811023654.2971-1-islituo@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In hwsim_new_edge_nl() and hwsim_set_edge_lqi(), if only one of the two
info->attrs is NULL, the functions will not return.
  if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
      !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
	  return -EINVAL;

However, both of them may be dereferenced in the function
nla_parse_nested_deprecated(), causing a null-pointer dereference.
To fix this possible null-pointer dereference, the function returns
-EINVAL if any info_attr is NULL.

Similarly, in hwsim_set_edge_lqi(), if only one of the two edge_attrs is
NULL, both nla_get_u32() and nla_get_u8() will be called, causing a
null-pointer dereference.
Also, to fix this possible null-pointer dereference, the function returns
-EINVAL if any edge_attr is NULL.

Fixes: f25da51fdc38 ("ieee802154: hwsim: add replacement for fakelb")
Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Tuo Li <islituo@gmail.com>
---
 drivers/net/ieee802154/mac802154_hwsim.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/mac802154_hwsim.c b/drivers/net/ieee802154/mac802154_hwsim.c
index ebc976b7fcc2..8caa61ec718f 100644
--- a/drivers/net/ieee802154/mac802154_hwsim.c
+++ b/drivers/net/ieee802154/mac802154_hwsim.c
@@ -418,7 +418,7 @@ static int hwsim_new_edge_nl(struct sk_buff *msg, struct genl_info *info)
 	struct hwsim_edge *e;
 	u32 v0, v1;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
@@ -528,14 +528,14 @@ static int hwsim_set_edge_lqi(struct sk_buff *msg, struct genl_info *info)
 	u32 v0, v1;
 	u8 lqi;
 
-	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] &&
+	if (!info->attrs[MAC802154_HWSIM_ATTR_RADIO_ID] ||
 	    !info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE])
 		return -EINVAL;
 
 	if (nla_parse_nested_deprecated(edge_attrs, MAC802154_HWSIM_EDGE_ATTR_MAX, info->attrs[MAC802154_HWSIM_ATTR_RADIO_EDGE], hwsim_edge_policy, NULL))
 		return -EINVAL;
 
-	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] &&
+	if (!edge_attrs[MAC802154_HWSIM_EDGE_ATTR_ENDPOINT_ID] ||
 	    !edge_attrs[MAC802154_HWSIM_EDGE_ATTR_LQI])
 		return -EINVAL;
 
-- 
2.25.1

