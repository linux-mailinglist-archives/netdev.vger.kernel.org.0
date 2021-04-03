Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8680835347D
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 17:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbhDCPTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Apr 2021 11:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236364AbhDCPTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Apr 2021 11:19:02 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840CEC0613E6;
        Sat,  3 Apr 2021 08:18:59 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id d13so11359589lfg.7;
        Sat, 03 Apr 2021 08:18:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJMSco07kl6UgHcL4lI5BdZNbUDIYrJUOjySLJzHFcw=;
        b=sEBxfjtVS3jSVCEFwhxfH7RjMIkNyDTkHmAKxhHX28Oq7cvSprBREUyQTVousYRTju
         MZ3hIJPWFXF/gQ/JyXlCeS+R3CIsSpIfqJtDbTJAOOVyFya08iec3zsSIv4alskyAR6J
         5LJE3OnMjPvDIsmEADZUX8LI+QImh4jWx6i5qbM0hvIxkG/Xy5vDcG3cZKwgFf4s6hJj
         WXv5S2F8iTk1HND2alaWng6FUXjXLsWeDINEDrwK+VPHfL3KQj+VcUQmmzdj4YinjIji
         y/GDKxQXV1JM/Dmcsu1LKsPQqr81FxyP+CwUaihk54uwojFex0zsGbg2QkpFEGBAUZCf
         YDRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LJMSco07kl6UgHcL4lI5BdZNbUDIYrJUOjySLJzHFcw=;
        b=nacoH6iLp5Rp1omzEgkQdELXf4ElN570jnTSSr5v7juueP3Y7Vk9cyTPIUpNXT9mmK
         gYNv1jFLkVQw4LmDS1TXzrVQ4vsr0enndoz021N2WN4c1jgztNFp35QiVrw1d1CCf2nO
         mlzxSsDmpoV+C23tf/m+9sRUOPK2aUQu7KWNFZbsX8ytiea9N1H7+L2URFhfxTvyFUxl
         qG6gy6Ah/gHpfGe4DBAOA5fe1wToIsDJMy1qzS/CaQeLX7gvf4AG5AFyl0Gf/VXIplLg
         n4dZLeNtgwj7RcavMm0dvXfYBPxenWSadGrthmFatEQLNWmGc+7Q/CBHtiL/7qoWr2Ac
         /4Kg==
X-Gm-Message-State: AOAM531Wve45Q6eS/MW1lG9XyT2CRZSy0vec9SarwDtBRqgRsNgSeZh2
        x0kDr6ZUqpWJlwVd0fT3RzA=
X-Google-Smtp-Source: ABdhPJzdjHoTcKsPHbzfuMr6Zmj8CuysNF1elSXfZ86spAL44RsAs5/tD0AWZ81rKIrqlOWOFILuzA==
X-Received: by 2002:a05:6512:104e:: with SMTP id c14mr11626975lfb.570.1617463137430;
        Sat, 03 Apr 2021 08:18:57 -0700 (PDT)
Received: from localhost.localdomain ([94.103.229.149])
        by smtp.gmail.com with ESMTPSA id a18sm1216549ljj.106.2021.04.03.08.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Apr 2021 08:18:57 -0700 (PDT)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        davem@davemloft.net
Cc:     linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Subject: [PATCH] net: fix NULL ptr dereference in nl802154_del_llsec_key
Date:   Sat,  3 Apr 2021 18:18:51 +0300
Message-Id: <20210403151851.9437-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported NULL ptr dereference in nl802154_del_llsec_key()[1]
The problem was in case of info->attrs[NL802154_ATTR_SEC_KEY] == NULL.
nla_parse_nested_deprecated()[2] doesn't check this condition before calling
nla_len()[3]

Call Trace:
 nla_len include/net/netlink.h:1148 [inline]                       [3]
 nla_parse_nested_deprecated include/net/netlink.h:1231 [inline]   [2]
 nl802154_del_llsec_key+0x16d/0x320 net/ieee802154/nl802154.c:1595 [1]
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800

Reported-by: syzbot+ac5c11d2959a8b3c4806@syzkaller.appspotmail.com
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/ieee802154/nl802154.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 7c5a1aa5adb4..2f0a138bd5eb 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -1592,7 +1592,8 @@ static int nl802154_del_llsec_key(struct sk_buff *skb, struct genl_info *info)
 	struct nlattr *attrs[NL802154_KEY_ATTR_MAX + 1];
 	struct ieee802154_llsec_key_id id;
 
-	if (nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
+	if (!info->attrs[NL802154_ATTR_SEC_KEY] ||
+	    nla_parse_nested_deprecated(attrs, NL802154_KEY_ATTR_MAX, info->attrs[NL802154_ATTR_SEC_KEY], nl802154_key_policy, info->extack))
 		return -EINVAL;
 
 	if (ieee802154_llsec_parse_key_id(attrs[NL802154_KEY_ATTR_ID], &id) < 0)
-- 
2.30.2

