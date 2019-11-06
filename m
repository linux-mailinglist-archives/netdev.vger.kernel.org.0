Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11479F0E70
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 06:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730620AbfKFFjd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 00:39:33 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:37060 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfKFFjc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 00:39:32 -0500
Received: by mail-lf1-f67.google.com with SMTP id b20so17012873lfp.4
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 21:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qGTjy+zcT2e1yA2MRPN9kM8zQu04YAnRCawlHATxUEY=;
        b=iDxUcWfdUHYZ/NBlpYtSpzwyYzs45fHX7CfDnHpADcUHV5bPMOnA5iRTSYFgvv6JVE
         yq1HLts+QnQdzuJcXZXV/VHM3l9sCKUpDiovdVazyxRaC5+k2D9Cx4gaghh61dB2+qLZ
         leW1hID+/RSS6eexexqstw+iUv9vp7lketEtgr2ExOw1RkNpcWiewNKPTBeLjn641k2G
         RZMZiLSNsYxXYduxF7cI184bLn58OzZFMlmJUokHMuL3YdxDX9VkgFe5MafgWnHOQ6aE
         YZFzf8lRKoZmRr+MnqiUuHD2j5jQc9/FytmCniiKWmvkjYz/YCd/Xlne1VDzJPcBGhGV
         NhXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qGTjy+zcT2e1yA2MRPN9kM8zQu04YAnRCawlHATxUEY=;
        b=K23OaWVn+JqVqj0cJwbvI+GxEXooUTGkGQkePy8ck/wf8QiNqLpjL5m7i3g8i4oApX
         QWXn9pV3nHC+aJ2M5OdFSak0B+GVCiY8H09zOH5mMMq2MHusOQDCE06dlhs2JhtOQzKc
         4h+DR5/Nl4wMOmhHGSQwvz3bGVhJuQe8qOZYszpxYoOVtLAiq0KyCgh0UXFeHxO7zWNr
         SrHnsefdtd/9lHk46/Bsa2tngXFpa1Q3SifywJu/BeVP9b4p9TKxCDbUD9vmIKhbL5dk
         /TdIGAOv5HAZ1fe0WDEcSz+Cf+Hga5gEAA7InIG0jJd4uMD1Wjex3L3qAtlXWrfmwRVX
         IhqQ==
X-Gm-Message-State: APjAAAXf0jcxXo3+BbB34Q/Vc7NoOnW7LsrJo0xoRTC5jGMpMd+w2W4F
        xgkSjeAp8cQSYQe2FYstfNYicA==
X-Google-Smtp-Source: APXvYqz24TkgvmEN9A6s8pdkKXX3im0FiEpsbwh9fRtg+cQy1dz6OVvf+M7U72I430TNwokX+GGETQ==
X-Received: by 2002:a19:a8b:: with SMTP id 133mr23468345lfk.136.1573018770875;
        Tue, 05 Nov 2019 21:39:30 -0800 (PST)
Received: from mimer.lan (h-137-65.A159.priv.bahnhof.se. [81.170.137.65])
        by smtp.gmail.com with ESMTPSA id c22sm754737ljk.43.2019.11.05.21.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 21:39:30 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH v2 2/5] rtnetlink: skip namespace change if already effect
Date:   Wed,  6 Nov 2019 06:39:20 +0100
Message-Id: <20191106053923.10414-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191106053923.10414-1-jonas@norrbonn.se>
References: <20191106053923.10414-1-jonas@norrbonn.se>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RTM_SETLINK uses IFA_TARGET_NETNSID both as a selector for the device to
act upon and as a selection of the namespace to move a device in the
current namespace to.  As such, one ends up in the code path for setting
the namespace every time one calls setlink on a device outside the
current namespace.  This has the unfortunate side effect of setting the
'modified' flag on the device for every pass, resulting in Netlink
notifications even when nothing was changed.

This patch just makes the namespace switch dependent upon the namespace
the device currently resides in.

Signed-off-by: Jonas Bonn <jonas@norrbonn.se>
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/core/rtnetlink.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 269d1afefceb..a6ec1b4ff7cd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2393,11 +2393,15 @@ static int do_setlink(const struct sk_buff *skb,
 			goto errout;
 		}
 
-		err = dev_change_net_namespace(dev, net, ifname);
-		put_net(net);
-		if (err)
-			goto errout;
-		status |= DO_SETLINK_MODIFIED;
+		if (!net_eq(dev_net(dev), net)) {
+			err = dev_change_net_namespace(dev, net, ifname);
+			put_net(net);
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_MODIFIED;
+		} else {
+			put_net(net);
+		}
 	}
 
 	if (tb[IFLA_MAP]) {
-- 
2.20.1

