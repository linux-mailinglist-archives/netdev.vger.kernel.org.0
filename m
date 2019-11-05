Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3B94EF6FC
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 09:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388312AbfKEILs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 03:11:48 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:44454 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388183AbfKEIL1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 03:11:27 -0500
Received: by mail-lj1-f194.google.com with SMTP id g3so14572093ljl.11
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 00:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=norrbonn-se.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nnPxUgcY+eJznzWuRNBGSFKsUKuKOJYTW/84Xz2aVtI=;
        b=ALbnm26qSw3qBI6lwMVbfQgweiwJhyxCdMHw/LwqnaCS272kbxVvPcR76yPD8jg8vn
         uPMaImK/pL75XFyu5TLMoTandyhlAIQR293BUbWt7WAA3r1AqUDNAp2G3BrXsBHs/Vlz
         Mx/SRmaZ1ZhCSjuuLMu/Oa/arJ/oaQdFsPYWvCnXadICxJEeVFugRYJnL+aweXDefKd7
         b9ne6Wx5s0X5ASMeij7ukUWXVRVSQ+9d0XmlnwlzIgdVZ0+5SBKoQbj1AI3yZa8AJLXX
         +C4U2A21AKXVI4ClSgnbd3Ve8hiRCGOtd2IS6CHBNFlVYQFshSd5Tpo6TkAEQ0vgwfKk
         OIeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nnPxUgcY+eJznzWuRNBGSFKsUKuKOJYTW/84Xz2aVtI=;
        b=biS21jrfCLK1suK5ZeNH+wLA4wilDg3AWCljHznabSiuNNqAIVXlTMG569ug+55Jq6
         2oDZjUtlh1cR3rn5g5x/lPqF/ch//3YALwCmn5XjvIe8IBYeOYAuc+aR1lhU15b7AWd+
         hDsdjDmVP92kJMkctQlvpJsrGxU2g3pTjZxb1ZZP3jMBWzzp9ImbyHH58c6sjIcaFFAe
         SJXiVaSBYUoZjw2HCFwsP9GvWyBqL2XrSSvwnROGEGH2jZL+yCEM9S6kY636boQe6o+q
         z4wfMsB3r8aQ9UjEezwZpMaE39Yy5cgDHsARBaeK3ueqXB2qwmT6WcEE+9V96BZqeBrX
         gzAA==
X-Gm-Message-State: APjAAAUdV+fYENViuEwfPG0ciU2826LfHUXqd1D7OiMe419p+4R0yEt3
        j+ff/6jWFpiIdxoPHB73/n5uIA==
X-Google-Smtp-Source: APXvYqx6e9T6EGwOfg+Sq1No54UmmdSneBfCpkVLjQJ4U9kLq7x32Mqaaru8yAR89aQi5EkowqQz/w==
X-Received: by 2002:a2e:b5a2:: with SMTP id f2mr21485342ljn.108.1572941485453;
        Tue, 05 Nov 2019 00:11:25 -0800 (PST)
Received: from mimer.lulea.netrounds.lan ([195.22.87.57])
        by smtp.gmail.com with ESMTPSA id m7sm7275986lfp.22.2019.11.05.00.11.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 00:11:24 -0800 (PST)
From:   Jonas Bonn <jonas@norrbonn.se>
To:     nicolas.dichtel@6wind.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, Jonas Bonn <jonas@norrbonn.se>
Subject: [PATCH 2/5] rtnetlink: skip namespace change if already effect
Date:   Tue,  5 Nov 2019 09:11:09 +0100
Message-Id: <20191105081112.16656-3-jonas@norrbonn.se>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191105081112.16656-1-jonas@norrbonn.se>
References: <20191105081112.16656-1-jonas@norrbonn.se>
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

