Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95981A4651
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 14:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgDJMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 08:33:16 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33066 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgDJMdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 08:33:16 -0400
Received: by mail-lj1-f196.google.com with SMTP id q22so1838535ljg.0;
        Fri, 10 Apr 2020 05:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=oZ4mTa/knZg2c3uydTiSH3iGohdOLCMYiOTGruiDB44=;
        b=INLqcIST63qUP2L0bEZpAvS/9RIaV7Qr6MrQkTXbpyKTxw2bckSqzVlr/UTU5vJPlV
         V0/BMJh/wM7nRQi3FBU/Gj9zVpdevlnc6EdAE4Q7v1uG5VEFStrbYDW0fdPQFdvMzt+4
         u0IlEl1z+syacsjqSgJtLhOpUOQuTnS5e1ggOXUIdORCvZLPKW77Bdo3WVNILoxWWuLx
         GcoDzdSxxOwH75+8UgRtDZVrdx9aSb6m4xuGAvn0/ovmVIfggkzmNBYZ7tz6579hYP1h
         q0YGuBtlequ5w64x2mpCl0PKJ2fMEpdABifPhEi0OZLfNV1ZArdkYh9f1znVgUdgfgam
         9mYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=oZ4mTa/knZg2c3uydTiSH3iGohdOLCMYiOTGruiDB44=;
        b=J3LAUvLnzqwVSfQo0+faf9EbrM74NngDUSNwTDLqs6HqsRYNxROarKwB2ykz6hIIX6
         D+ZAgrJiBUYTCyhmkRQtRubHGAFvr3n/YCgKaFJkE7dbTJ+hhhrf15eBLP6G1BlEFuGF
         sg6ENBOh1/EDQmQKSabMjQ5lGAuMOeRSVKmNW0PSBSJeD65wHRSDMCamOHlfDUfsNdDc
         BwPX0vKijw1QpR/SSXorP8Xa9J0SKPaXcGs4Hb9KO4QL7mdIIImw5QO1HXTM0fPXshK+
         7tz8EbixTrO/MffHart4vRdR/PG5M57sxUWJsptXSfaz1gM62qIfnrH6lIKhnzmp8Ons
         sG1g==
X-Gm-Message-State: AGi0PuasSP30BUKAweNKM1q3Mzme24sToHVtfPkNep2UXV6VR1erTSiJ
        ajuOdyzbDvPCcsmJxwrMAkg=
X-Google-Smtp-Source: APiQypI1WtuGNzKw6wZJX6wI33yCJEpZK1zTnaPinzEQNJpD/F835Vr6wwyW2yatQgL9RvoCtK3ivg==
X-Received: by 2002:a2e:8745:: with SMTP id q5mr2936178ljj.157.1586521993889;
        Fri, 10 Apr 2020 05:33:13 -0700 (PDT)
Received: from work.bb.dnainternet.fi (dffyyyyyyyyyyyysyd4py-3.rev.dnainternet.fi. [2001:14ba:2100::1e0:1e18])
        by smtp.gmail.com with ESMTPSA id r23sm1012619ljh.34.2020.04.10.05.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2020 05:33:13 -0700 (PDT)
From:   Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+6693adf1698864d21734@syzkaller.appspotmail.com,
        Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>, stable@kernel.org
Subject: [PATCH] mac80211_hwsim: Use kstrndup() in place of kasprintf()
Date:   Fri, 10 Apr 2020 15:32:57 +0300
Message-Id: <20200410123257.14559-1-tuomas.tynkkynen@iki.fi>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reports a warning:

precision 33020 too large
WARNING: CPU: 0 PID: 9618 at lib/vsprintf.c:2471 set_precision+0x150/0x180 lib/vsprintf.c:2471
 vsnprintf+0xa7b/0x19a0 lib/vsprintf.c:2547
 kvasprintf+0xb2/0x170 lib/kasprintf.c:22
 kasprintf+0xbb/0xf0 lib/kasprintf.c:59
 hwsim_del_radio_nl+0x63a/0x7e0 drivers/net/wireless/mac80211_hwsim.c:3625
 genl_family_rcv_msg_doit net/netlink/genetlink.c:672 [inline]
 ...
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Thus it seems that kasprintf() with "%.*s" format can not be used for
duplicating a string with arbitrary length. Replace it with kstrndup().

Reported-by: syzbot+6693adf1698864d21734@syzkaller.appspotmail.com
Cc: stable@kernel.org
Signed-off-by: Tuomas Tynkkynen <tuomas.tynkkynen@iki.fi>
---
Compile tested only.
---
 drivers/net/wireless/mac80211_hwsim.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 7fe8207db6ae..7c4b7c31d07a 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -3669,9 +3669,9 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	}
 
 	if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
-		hwname = kasprintf(GFP_KERNEL, "%.*s",
-				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
-				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		hwname = kstrndup((char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  GFP_KERNEL);
 		if (!hwname)
 			return -ENOMEM;
 		param.hwname = hwname;
@@ -3691,9 +3691,9 @@ static int hwsim_del_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	if (info->attrs[HWSIM_ATTR_RADIO_ID]) {
 		idx = nla_get_u32(info->attrs[HWSIM_ATTR_RADIO_ID]);
 	} else if (info->attrs[HWSIM_ATTR_RADIO_NAME]) {
-		hwname = kasprintf(GFP_KERNEL, "%.*s",
-				   nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
-				   (char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]));
+		hwname = kstrndup((char *)nla_data(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  nla_len(info->attrs[HWSIM_ATTR_RADIO_NAME]),
+				  GFP_KERNEL);
 		if (!hwname)
 			return -ENOMEM;
 	} else
-- 
2.17.1

