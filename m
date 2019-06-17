Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D01C447F15
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 12:03:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfFQKDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 06:03:52 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53735 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726708AbfFQKDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 06:03:52 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so8572820wmj.3
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 03:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rEHLzZ23khG4P5uM+JS/w5AzON/xWAmRBd/wtio95bM=;
        b=RFHgOn0pbdq+TsTK3jq2Fcq7lMheEZMgJ/MQGJ7TmB+TsQhY8nlXOM95+D1y0ICCxp
         lEAiqaCQHu/9TmMOFH4ViOlC8S0xU1Ca2cdIk7RRVvgXw0QI16ZMOficK48d4ackchLm
         fYZigyKg0GrtPZR1eoQGZ0SKUaXD4I5w/nIWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=rEHLzZ23khG4P5uM+JS/w5AzON/xWAmRBd/wtio95bM=;
        b=t4hyFSjWXep/KCou6g9qPrcwr3YVVBcJyHKuXiZ2AYENK8sYBYq9HTy9ZMQ7Y/j1cQ
         cBwzimoUFKZe8xA25RHmGKnHKmhdYvcqjWDqBcSnH1whagjAdmK0RveiVDu8ofpPh9Qx
         AOWmhqONXJB8qbr2kABFy2sYYs/KufxjOBsLG/Nb6TNPlUS66ZyisnHWcTmygiT2ZRnS
         fX5q2DYeinaS7I/QUE6fw5yK83JCNTgTmDdfAQ/umATZSCQT/4H4OJ8wByWEWEzjCwdH
         +uuVPwXDWIcYPE5Z9eY66ZJxHdc2FCApmpfxSbOGPnm7/CkoOyHi33z1Wb52cBEErlLD
         pPvQ==
X-Gm-Message-State: APjAAAXCiY1RxGuxZDVvkhsdVHUYbi0TAkR9oAQUTBc/6gzE/bQ5xBRj
        DvZNs0rxsB6u4VcCXEHwBwH2RWS7om/xXw==
X-Google-Smtp-Source: APXvYqzu83iwtSjh+We1ok7PdNrF6xHxIAXHQACjyv+6DUiybj3ozRyXpmnErMR/LzJGtUwioXeLtg==
X-Received: by 2002:a1c:ca06:: with SMTP id a6mr18317470wmg.48.1560765828975;
        Mon, 17 Jun 2019 03:03:48 -0700 (PDT)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1268:6500::dc83])
        by smtp.gmail.com with ESMTPSA id n1sm9791302wrx.39.2019.06.17.03.03.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 03:03:48 -0700 (PDT)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netdev@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next 1/2] net: sched: act_ctinfo: fix action creation
Date:   Mon, 17 Jun 2019 11:03:26 +0100
Message-Id: <20190617100327.24796-2-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.20.1 (Apple Git-117)
In-Reply-To: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
References: <20190617100327.24796-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use correct return value on action creation: ACT_P_CREATED.

The use of incorrect return value could result in a situation where the
system thought a ctinfo module was listening but actually wasn't
instantiated correctly leading to an OOPS in tcf_generic_walker().

Confession time: Until very recently, development of this module has
been done on 'net-next' tree to 'clean compile' level with run-time
testing on backports to 4.14 & 4.19 kernels under openwrt.  During the
back & forward porting during development & testing, the critical
ACT_P_CREATED return code got missed despite being in the 4.14 & 4.19
backports.  I have now gone through the init functions, using act_csum
as reference with a fine toothed comb.  Bonus, no more OOPSes.  I
managed to also miss this issue till now due to the new strict
nla_parse_nested function failing validation before action creation.

As an inexperienced developer I've learned that
copy/pasting/backporting/forward porting code correctly is hard.  If I
ever get to a developer conference I shall don the cone of shame.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 net/sched/act_ctinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index a7d3679d7e2e..2c17f6843107 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -213,6 +213,7 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 			tcf_idr_cleanup(tn, actparm->index);
 			return ret;
 		}
+		ret = ACT_P_CREATED;
 	} else if (err > 0) {
 		if (bind) /* don't override defaults */
 			return 0;
-- 
2.20.1 (Apple Git-117)

