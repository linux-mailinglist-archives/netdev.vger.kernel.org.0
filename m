Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C46F144D6E1
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 13:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233274AbhKKMyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 07:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbhKKMyn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 07:54:43 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A6DFC061766;
        Thu, 11 Nov 2021 04:51:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so4549887pja.1;
        Thu, 11 Nov 2021 04:51:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Zki/+Prvo1eo5OhzEfA0T2kN/JtMjM+kEl6i27v6H4=;
        b=S3aEwpUINTXBJfQgvEaI8QUqbSBsqDFcfLcJ6paCwc07PPXrc8McDtdmnkNn6v4WwI
         FMRUcZpP4RqUqjq9df9t6eQSPyz/D22iK5O/esHKSQ8rJBkTCowvcbY7+ROLcSUkY4pd
         KlaU56gHglO0tzJ3bUeb9N1nL9MptsL97AwGGFarxuHxIznxAD6hVDSX2lo2T2tHwaTQ
         iPvW4njj49kDBUrrWQ9cg7HwRe0iqcRFEX7sET0qR17lx8oiuV5T3n9ttlzMn4Et3zE8
         3ZYUsS9rDMLrKxe5ZNHMojLvJFPGDpmcaU0PlMh7/U/KbZydNHUkDdBtkbvqA1xhBXYB
         bYbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2Zki/+Prvo1eo5OhzEfA0T2kN/JtMjM+kEl6i27v6H4=;
        b=QFsuEUdJ2sBaaxf2Fh5s4YXdBVLMXoKCfqrsKbsTJGvyoD9yhU6NCBMGVcWK7N9prX
         rpsdHuQq5KmXd/hrA+XiQl4srbKb4xigy0oP4HIZ3TYRS/Xv+HaKNqbstK9IPtPDcqCt
         egOskuFLcm0mjtacOVDHFUv3AtGHvZG53Hxf/CdYhQKn7FKJU1wS80UcjIt/SjfOd8hh
         F+26oa4VYnTJ7yO01PKOOURv//m0+KB3hxno1YkKbMtYp9FSRZ2MwD4qlF1HOZYPR2Q2
         NJ1XJ9gfiqE4X54LyfOsJ8ci6vKt4Gk4Nz7znKDWp6SCoGWaj8VpjgXjIJ5anQ2DaKeb
         xVXQ==
X-Gm-Message-State: AOAM531Xuwx/cAGB9VUJAemm+Z3/+fDXmYCWRGxc6P0hq0+7ccHp/DIW
        uh/UUUkh7pD0+AjmQDVvd2I=
X-Google-Smtp-Source: ABdhPJwt99d4BkCxuxtRIF+4/JqokNM9vnLOlM6lTpcGAFSpmf7q1tKQOTn4V5otzvfeHL5CODzFcA==
X-Received: by 2002:a17:90b:11c1:: with SMTP id gv1mr26644744pjb.208.1636635113640;
        Thu, 11 Nov 2021 04:51:53 -0800 (PST)
Received: from localhost.localdomain ([94.177.118.102])
        by smtp.gmail.com with ESMTPSA id z8sm2272138pgc.53.2021.11.11.04.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 04:51:53 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: ieee802154: fix shift-out-of-bound in nl802154_new_interface
Date:   Thu, 11 Nov 2021 20:51:17 +0800
Message-Id: <20211111125118.1441463-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nl802154_new_interface, if type retrieved from info->attr is
NL802154_IFTYPE_UNSPEC(-1), i.e., less than NL802154_IFTYPE_MAX,
it will trigger a shift-out-of-bound bug in BIT(type).

Fix this by adding a condition to check if the variable type is
larger than NL802154_IFTYPE_UNSPEC(-1).

Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 277124f206e0..cecf5ce0aa20 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -915,7 +915,7 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL802154_ATTR_IFTYPE]) {
 		type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
-		if (type > NL802154_IFTYPE_MAX ||
+		if (type <= NL802154_IFTYPE_UNSPEC || type > NL802154_IFTYPE_MAX ||
 		    !(rdev->wpan_phy.supported.iftypes & BIT(type)))
 			return -EINVAL;
 	}
-- 
2.25.1

