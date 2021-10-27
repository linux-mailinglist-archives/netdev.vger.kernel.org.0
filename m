Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B38D443CFE1
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243330AbhJ0RlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236752AbhJ0RlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:41:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49009C061570;
        Wed, 27 Oct 2021 10:38:45 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so2669840pjb.0;
        Wed, 27 Oct 2021 10:38:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkqSITbCIjnK7FZ/jf9UFsH0245UP24SRvOg2xF2AJ4=;
        b=GkmIV3DcqQ+aCfRl4Y6y/2a5fIZC9mpAbKRbs9z1Y7tiYi1i831uFjOhbzAAWGysAO
         3UPZVx7r2tGbZBrXZhSnVyBzvN8L5vH+M7r+clmkeUrb1++7B2uSf4d/xWTqoRQJiYmB
         BRkNi6VDh2mDqTwvNIDfhbpe5lNHV2FwX3UpdN7vMHPuVbeU2LdqwW2qqKWVFdDq4HR4
         L6DMIPQ0jXAzAzEsggn5zP3GSaXqurL/rmZD2GGlgq4wqCpDfVR+yEfQA4mpKZOgom+W
         3vnDBumIMm3j6q0uONWzDJ2g0qMojsO3F++5E71NIMEJShqDX2Lhtsx/nPPHYLGUrIhX
         K7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PkqSITbCIjnK7FZ/jf9UFsH0245UP24SRvOg2xF2AJ4=;
        b=6rO3Q/FAD88ooAdwPzQAVJmoQOsa1w1BMg5jfL3XbZUDS7hkwO8KvTLE+F4m09S5Ec
         A1EAti7JYryekV6GG+bxycUX3g+JCu5eFxpxdszbvw/t9Zvk4yV68g20TTulesp/8h3h
         fLK1fqIxLuya5CiE0+WXR/f8isohGZRoR673yLecw/zFWaARjvnqtz+d5d30tTB09TM/
         53sbph49WuATzdZuUeI5qHWYhY3b8WgNv3/Yv/JBV9HU0JUDY/RIq6VPiEDQVOJMJTNJ
         mmYbtxdIDwoYaQze3D3GRZ4a+j76gQtJsBF3P17JTWYxUadVoq/qCZLZj7w5LsVVYUBJ
         TO2w==
X-Gm-Message-State: AOAM531xmh+1NwXMhnqY2HbVrmiY4Xki+HR115LE+hw7BguQASptHlFF
        6TVI2n7uAKIc03jfzGEYq/1tXKfPgjtAPbGviIt6gQ==
X-Google-Smtp-Source: ABdhPJxoHmywfRhLDYW7fzdNA0OKcl8KNKkB9+wieDqHTRiuQZd0w6YEh53/dC7aoVnN0xV0rLPI9Q==
X-Received: by 2002:a17:90b:1e0b:: with SMTP id pg11mr7277222pjb.230.1635356324894;
        Wed, 27 Oct 2021 10:38:44 -0700 (PDT)
Received: from localhost.localdomain (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id b6sm572719pfv.171.2021.10.27.10.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 10:38:44 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com
Subject: [PATCH v2] net:wireless: call cfg80211_stop_ap when switch from P2P_GO type
Date:   Thu, 28 Oct 2021 01:37:22 +0800
Message-Id: <20211027173722.777287-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the userspace tools switch from NL80211_IFTYPE_P2P_GO to
NL80211_IFTYPE_ADHOC via send_msg(NL80211_CMD_SET_INTERFACE), it
does not call the cleanup cfg80211_stop_ap(), this leads to the
initialization of in-use data. For example, this path re-init the
sdata->assigned_chanctx_list while it is still an element of 
assigned_vifs list, and makes that linked list corrupt.

Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
Reported-by: syzbot+bbf402b783eeb6d908db@syzkaller.appspotmail.com
---
V2:
	- Fix wrong email address.
 net/wireless/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 18dba3d7c638..4fdf0877092d 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1044,6 +1044,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 		switch (otype) {
 		case NL80211_IFTYPE_AP:
+		case NL80211_IFTYPE_P2P_GO:
 			cfg80211_stop_ap(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_ADHOC:
-- 
2.25.1

