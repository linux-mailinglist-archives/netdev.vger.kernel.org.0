Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0062B85EB
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727310AbgKRUpl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:45:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22424 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727298AbgKRUpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:45:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605732339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s1/NRA0IcfSE+sNP/YR+0YHuFh+fpJOX7TpxnHhSo2I=;
        b=gGoOXFxhJVDJmibl0OXjEd1znnOpm/qk0eu7+2XkGrPfrRMA2a63M8Iee74omOi1YWuCnx
        wWejjJY0AybKCpmiOAxirW5x6xAQjX8Zc0BNx5/31b4r/pCZyPgHXobk/EBz8/ZzFx5Ufx
        Fw3laewYrkWKtydFywxzki0PTyIM24E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-TK9s3u_iOaKzEWcUmcVU4A-1; Wed, 18 Nov 2020 15:45:37 -0500
X-MC-Unique: TK9s3u_iOaKzEWcUmcVU4A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 474371084D61;
        Wed, 18 Nov 2020 20:45:36 +0000 (UTC)
Received: from yoda.redhat.com (unknown [10.40.192.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0301719C59;
        Wed, 18 Nov 2020 20:45:34 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v6 5/6] selftests: refactor get_netdev_name function
Date:   Wed, 18 Nov 2020 21:45:21 +0100
Message-Id: <20201118204522.5660-6-acardace@redhat.com>
In-Reply-To: <20201118204522.5660-1-acardace@redhat.com>
References: <20201118204522.5660-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As pointed out by Michal Kubecek, getting the name
with the previous approach was racy, it's better
and easier to get the name of the device with this
patch's approach.

Essentialy the function doesn't need to exist
anymore as it's a simple 'ls' command.

Signed-off-by: Antonio Cardace <acardace@redhat.com>
---
 .../drivers/net/netdevsim/ethtool-common.sh   | 20 ++-----------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
index fa44cf6e732c..9f64d5c7107b 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/ethtool-common.sh
@@ -20,23 +20,6 @@ function cleanup {
 
 trap cleanup EXIT
 
-function get_netdev_name {
-    local -n old=$1
-
-    new=$(ls /sys/class/net)
-
-    for netdev in $new; do
-	for check in $old; do
-            [ $netdev == $check ] && break
-	done
-
-	if [ $netdev != $check ]; then
-	    echo $netdev
-	    break
-	fi
-    done
-}
-
 function check {
     local code=$1
     local str=$2
@@ -65,5 +48,6 @@ function make_netdev {
     fi
 
     echo $NSIM_ID > /sys/bus/netdevsim/new_device
-    echo `get_netdev_name old_netdevs`
+    # get new device name
+    ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/
 }
-- 
2.28.0

