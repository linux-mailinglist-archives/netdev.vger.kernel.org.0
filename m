Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC4581711BC
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 08:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgB0Huj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 02:50:39 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:53088 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728531AbgB0Huh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 02:50:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id p9so2335131wmc.2
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 23:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KB4q8CLgGMlJ72q8dHQZkRzsGVwwocw/cqE7JdhddGE=;
        b=pOsnpqe683vRYWuypnW2P0eRk5vPPtsMgJjNAaKROsHp4A8PU7/UNaJCT4dDw0I7Ke
         duOJL7pJjaR0mlI/sVYqAEoPfaD2MhSq7KnARMO5LZw4mtIJxiJaQD4CSYPj8DNMSLM6
         O8fDfVqlb68DrN0bR+bbZzqQtv9rTTsvgcHbRyUyhAOsgrwdwnn0gK6Thivgs/4WkkFi
         4wCSLdZbT4BJKPv9C1yji1IAyZoL5hov2jRtIvIPaxL0OzDNANkSmrIGAnuaw6ASn6Zo
         uAAFdwtEENMqM1iN91wQ0Fy4hrDa3SjRp5OeRA8XYRMCFoFLosmWCHCgSE+sEgC7xMiN
         5FQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KB4q8CLgGMlJ72q8dHQZkRzsGVwwocw/cqE7JdhddGE=;
        b=ixK3ds751kvb0z5sAgelUg8BT63zQQti24wa1Vtl/N7qx1eq4m3kjycdGXfebUC+hq
         2DXG2syZpay3tPoT1hJCsdJjXISVGRfnTCgXGIYd/CkWHqcjADHtfK36OZ1ancCpXj5E
         Qa8Ira8SG2yHhOKcC3f/141KNdzPAF72V1Ef+bplxdEVNSp9ru7/oLxOlc8KLHIYNQbH
         wlEv5ypmD/wf5TO4Q+VUP64J/wzbqB0V3LsYHRjmG/y9p/l3Bv9Aht+k6xLBnba3JfON
         higPFUUEGsZ26moiz3vuEMOJvv9wrrSuZEQfuNZyQHQIdwwSrIdxmK91pXqg0pZahNb2
         m1/w==
X-Gm-Message-State: APjAAAUgfe1ro4GOn4rAonJU2dqOj6Bw9XaK62KIKJVbWynBs7Rx3rLF
        vmvNBe+Jb6nIoEah028RpB5q5y02Lyk=
X-Google-Smtp-Source: APXvYqxkD41DWGZyeoP3DQPJNasMtVRzw6y9HP0ZIsd5cghgZ8UhnrziyCWLsSSPHGVL0yGUQZA+rw==
X-Received: by 2002:a1c:b08a:: with SMTP id z132mr3753219wme.73.1582789835721;
        Wed, 26 Feb 2020 23:50:35 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id h13sm6968665wml.45.2020.02.26.23.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 23:50:35 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, idosch@mellanox.com,
        mlxsw@mellanox.com, shuah@kernel.org
Subject: [patch net-next 11/16] selftests: devlink_lib: Add devlink port helpers
Date:   Thu, 27 Feb 2020 08:50:16 +0100
Message-Id: <20200227075021.3472-12-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200227075021.3472-1-jiri@resnulli.us>
References: <20200227075021.3472-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Add two devlink port helpers:
 * devlink port get by netdev
 * devlink cpu port get

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 .../selftests/net/forwarding/devlink_lib.sh      | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/devlink_lib.sh b/tools/testing/selftests/net/forwarding/devlink_lib.sh
index 07e360e2f275..0df6d8942721 100644
--- a/tools/testing/selftests/net/forwarding/devlink_lib.sh
+++ b/tools/testing/selftests/net/forwarding/devlink_lib.sh
@@ -419,3 +419,19 @@ devlink_trap_drop_cleanup()
 	kill $mz_pid && wait $mz_pid &> /dev/null
 	tc filter del dev $dev egress protocol $proto pref $pref handle $handle flower
 }
+
+devlink_port_by_netdev()
+{
+	local if_name=$1
+
+	devlink -j port show $if_name | jq -e '.[] | keys' | jq -r '.[]'
+}
+
+devlink_cpu_port_get()
+{
+	local cpu_dl_port_num=$(devlink port list | grep "$DEVLINK_DEV" |
+				grep cpu | cut -d/ -f3 | cut -d: -f1 |
+				sed -n '1p')
+
+	echo "$DEVLINK_DEV/$cpu_dl_port_num"
+}
-- 
2.21.1

