Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DA02FCEFD
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 12:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389084AbhATLQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 06:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbhATKbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 05:31:18 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B4AC061757
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 02:29:59 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id my11so2932981pjb.1
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 02:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BovxAlKxDAHtbx5WxAO06W/RvFFdfkUC05TRSDfGPPI=;
        b=gfd9ZPpvusNpEO+G5xYNGDedza9WKSwqovhluKwmnmkeLw1+x4qOnF7w6iZYz3Fs3R
         sXM+COiUar5syJOF66BMKYDfDdWTlG62LPaU1opA9niJ5UAX8ehTUJPyRkosk11LSJTR
         KH2Xxt+eUpuEu04QEoW3Ygoqh19XsjGscNzaIEsf54HQ3JKlpago+25T7g6tCI5bFOUK
         koEU+Szz3xxVHh04bh8tOn2QStxA4pHCCwZl49ivKXXxDiKlnHhuNKnjAQ4x/sST+fL+
         N8tujuHBOH7H58j53gN9Q0nPJaxHwpoZhDtGIbdRloQEhlC9HHnJ3H9Hhd3t4qzkh89s
         X9fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BovxAlKxDAHtbx5WxAO06W/RvFFdfkUC05TRSDfGPPI=;
        b=tbZ8QgKe0au0BM5cD1DrbQwQyfZlfmzHqSaQkkWtWVrC8iQd/bqXrvVQve4bN6sRYW
         NYexMCTM3Z4BiGFxNGzRK9gJt+BJ/4wvdk9iFd7oKZ2XrusEZFu6GigpR8jXYXMYMY43
         4e9/9OoZXkV57J4YPlzTinq4LC5LwFKhxqp9Z3PAhsLG19mM9AASGVBFlFP/fhaGS6w7
         08W3fa4w6xQjv8AKJoYm/C3f4XPnSmuBf3jg8E1bit93KfcRH2lguI8/2ip7YQCQyva8
         RHvqcZ68Wpi6cVPVtabA7MWR3RIaLZzEI3gBBtY6PRM92BIFt+ZvZN9HQ2QHOfrSTEom
         3uAQ==
X-Gm-Message-State: AOAM5332i3mBBS3649j7YB9VycEc2ksltacc6BIR5nqjUF5mGT1GVATE
        0rJgZEL5hcYKMQbPfAxCC7A93j5giP8JSA==
X-Google-Smtp-Source: ABdhPJxjkrXZHEfnNkYzENfz3hDpCSFtW0ept3nV6qCw8bvsUWz1XQsDX1SGhqOcMA9WF/bxvmt1vQ==
X-Received: by 2002:a17:90a:540c:: with SMTP id z12mr5129226pjh.34.1611138599367;
        Wed, 20 Jan 2021 02:29:59 -0800 (PST)
Received: from Leo-laptop-t470s.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e68sm1843082pfe.23.2021.01.20.02.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 02:29:58 -0800 (PST)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net] selftests/net: set link down before enslave
Date:   Wed, 20 Jan 2021 18:29:47 +0800
Message-Id: <20210120102947.2887543-1-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set the link down before enslave it to a bond device, to avoid
Error: Device can not be enslaved while up.

Fixes: 6374a5606990 ("selftests: rtnetlink: Test bridge enslavement with different parent IDs")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 tools/testing/selftests/net/rtnetlink.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index c9ce3dfa42ee..a26fddc63992 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -1205,6 +1205,8 @@ kci_test_bridge_parent_id()
 	dev20=`ls ${sysfsnet}20/net/`
 
 	ip link add name test-bond0 type bond mode 802.3ad
+	ip link set dev $dev10 down
+	ip link set dev $dev20 down
 	ip link set dev $dev10 master test-bond0
 	ip link set dev $dev20 master test-bond0
 	ip link add name test-br0 type bridge
-- 
2.26.2

