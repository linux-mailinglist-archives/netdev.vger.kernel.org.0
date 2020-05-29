Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579C31E7536
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 07:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgE2FMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 01:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgE2FMn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 01:12:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0162C08C5C8
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:43 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t16so587958plo.7
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 22:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OIhA+R6ZZ45lmk6yDqFtszgZtlzZhvmED6iQwRq6C4U=;
        b=YNqG1RoBAY14u79CYMyHwBMYBwacXdJ0V/fEOn6Z/KHgLYyRJBerd8UGRdmZLyg34d
         HKlD1ZGnswuYXjcYr+l6kt9zGsILEWrD6ua1pduPWoA5iB1ovrGLYzJq+e2gaeZ0k2FU
         dls4ekYl5uNoA9ygPiYdNUAPi1mUZvVHWC5N4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OIhA+R6ZZ45lmk6yDqFtszgZtlzZhvmED6iQwRq6C4U=;
        b=oYKDIPgK/mCIvlf2yrL4tE9+13CCMIZxlj7ErlVgoYKivSb4tNxrl645cmeLWW2Naw
         W2NG7TwCvvOjY8H/W0u4na5GG+EFY+ljxn7b4z882mmcG5VBAU0bwTkMY9Ngkw/s5bRE
         kXgwM1SIdSz88R0CH7Izg3IZLul53Ub/MEVF8SBS66OuzBmbmKG2ea2nay+zrUDyGYo2
         wk5ePiGnz1t5TXaIsw3UFl+CLrI2mNgep7d5MVGuVGmLJy6gDNgB4HiCtR3B6L/KKsON
         T0gLRrE5rlnvi/y5106yWXErsFeIEnHFxXcsSJHlxxCOXd8VJIZeJWKV7PwEbSwVTzTt
         4eog==
X-Gm-Message-State: AOAM532IjsA+4DtHsnft8rA+QvxV4kJRgFMC0UKbDAX9dr+AnVQa2qZo
        oEmr7M4s2RLHn5nKB2URf7HFuA==
X-Google-Smtp-Source: ABdhPJx3/XhtGGgx//onG6d4CuaM4eHSDWUAM2leX4SyL9CnCPhW4u1+Gr7xXPgnSxrOT0FkeVCIIg==
X-Received: by 2002:a17:90a:8416:: with SMTP id j22mr7722681pjn.92.1590729163210;
        Thu, 28 May 2020 22:12:43 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id z20sm6935634pjn.53.2020.05.28.22.12.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 May 2020 22:12:42 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, jiri@mellanox.com,
        idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next 1/2] vxlan: add check to prevent use of remote ip attributes with NDA_NH_ID
Date:   Thu, 28 May 2020 22:12:35 -0700
Message-Id: <1590729156-35543-2-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
References: <1590729156-35543-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

NDA_NH_ID represents a remote ip or a group of remote ips.
It allows use of nexthop groups in lieu of a remote ip or a
list of remote ips supported by the fdb api.

Current code ignores the other remote ip attrs when NDA_NH_ID is
specified. In the spirit of strict checking, This commit adds a
check to explicitly return an error on incorrect usage.

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
Note: extack support for this is a bit intrusive to be included
in this patch. The function already does not support extack for the
other errors.  ndo_fdb_add and ndo_fdb_del handlers use this function
and ndo_fdb_del does not support extack. I can send a separate patch
covering extack for these add/del paths.

 drivers/net/vxlan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a0015cd..fe606c6 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1196,6 +1196,10 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 	struct net *net = dev_net(vxlan->dev);
 	int err;
 
+	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
+	    tb[NDA_PORT]))
+		return -EINVAL;
+
 	if (tb[NDA_DST]) {
 		err = vxlan_nla_get_addr(ip, tb[NDA_DST]);
 		if (err)
-- 
2.1.4

