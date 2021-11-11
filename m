Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E387044D8C6
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233746AbhKKPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:01:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhKKPBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 10:01:51 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112A0C061766;
        Thu, 11 Nov 2021 06:59:02 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id t5-20020a17090a4e4500b001a0a284fcc2so4822872pjl.2;
        Thu, 11 Nov 2021 06:59:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Yx94cRnNd+ciU2qcn93J0WLk2cjcP9Vnc7TYoHKDSk=;
        b=BZLmbhT6VAg8/MsrPoNrXPN1QVWYMcbmVg2kt1WS6knXM7eXnBhqIkhVCjxm8TlppO
         GnmmXe0vo8yoFPUgMNNbbMdO2/1J1BgihYx4TzUi+7NIDCuJe39x0351TiZ3XULcg53Q
         lcaKTRoLDcp6oxr/5Kq68WwLl3uovsNuSHlHjuzSUWwOgbrVM3GaDc9VmyFYkmgaYojN
         ZF8IHkKTIR6qEB9XxZL7TgsCRi/6aV/HDS5vYmxL4hlaHdV3AQj6qXqrBpcSxDmBo8NB
         Wx+cdSDdfL7FbeL8Ycm85doDprzeC6+BgX419H72ztNibczIV6TViM7MM64xeTbTfwft
         H2ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5Yx94cRnNd+ciU2qcn93J0WLk2cjcP9Vnc7TYoHKDSk=;
        b=xqW1yM5ykcEU7TxF/4U1BTO7ETIEIG2/dmrEr9bxZeXFwPqk/NddC80VTEXLTmP25X
         8Pf0xqILaBZsF3JqXbAHvogbr5K6q8OcnKa9Yac6nobJZXOEI5yfkWDVvccBvfgGjcTC
         gR3Eq3K6y1ffAvBKfUsWt7PV0XtMRQb1dk1tuOAeni91FbK/p5G+uHEcxI18CRQ/0Hne
         NQaTEeIy+VFpkpT2trZp/EaUrlUPCIgg/vs5qi2SVOKSCAqhEiU9fO+iR76ZsuN8py9I
         DF1eYEddacJpCRUBj3l4vBrOSlpUB3dmwdPt3OnEW0Jfq1DNMj1iKJ65dgOJKL8xDPV/
         VqTA==
X-Gm-Message-State: AOAM531NVhWkCM6UrWLIY3gqhpUvB8FzCJEDdgBdyyevJz4/8jXgJYII
        iqFNNJZYVwgITQvt1ro8O7s=
X-Google-Smtp-Source: ABdhPJyDAIY5N/ATJV2ryiJf4qnri1QXa5We39zqC1IfxYri3RZTSg2fHTG6KNhDSf5MiOo0FrV29Q==
X-Received: by 2002:a17:902:ec8f:b0:142:11aa:3974 with SMTP id x15-20020a170902ec8f00b0014211aa3974mr8290216plg.30.1636642741500;
        Thu, 11 Nov 2021 06:59:01 -0800 (PST)
Received: from localhost.localdomain ([94.177.118.102])
        by smtp.gmail.com with ESMTPSA id c21sm3976106pfl.15.2021.11.11.06.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 06:59:01 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] net: ieee802154: fix shift-out-of-bound in nl802154_new_interface
Date:   Thu, 11 Nov 2021 22:58:46 +0800
Message-Id: <20211111145847.1487241-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In nl802154_new_interface, if type retrieved from info->attr is
NL802154_IFTYPE_UNSPEC(-1), i.e., less than NL802154_IFTYPE_MAX,
it will trigger a shift-out-of-bound bug in BIT(type) [1].

Fix this by adding a condition to check if the variable type is
larger than NL802154_IFTYPE_UNSPEC(-1).

Fixes: 65318680c97c ("ieee802154: add iftypes capability")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 net/ieee802154/nl802154.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 277124f206e0..0613867d43ce 100644
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

