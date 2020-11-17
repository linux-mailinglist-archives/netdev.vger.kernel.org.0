Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE32B6888
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 16:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgKQPUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 10:20:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:31570 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730019AbgKQPUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 10:20:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605626435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JbdIWC2ZJQ+7LsSjfYypLW/JSHlnb0hkj/yErltOVQ4=;
        b=Gpu3kwr87tZYoSEfF2zXcFXJyJ8p2SG39NRQcD/plXn+P+SCy16FVNZmnAUDlA/IG6unl5
        GzuifafjAmpwhHFjCQ0eHa5HbXFKZknhC4v4B4y3qdYR0yBlYFEPxaBrBA/8ePZzs5ZiQY
        YfTFGiLwzUOG6yZloU+Vkp8Ej9jQomc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-z8HSxgD9NsW8-K68zK7ZtA-1; Tue, 17 Nov 2020 10:20:30 -0500
X-MC-Unique: z8HSxgD9NsW8-K68zK7ZtA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D89AD1017DD1;
        Tue, 17 Nov 2020 15:20:28 +0000 (UTC)
Received: from yoda.fritz.box (unknown [10.40.192.212])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A849A18401;
        Tue, 17 Nov 2020 15:20:27 +0000 (UTC)
From:   Antonio Cardace <acardace@redhat.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next v4 5/6] selftests: refactor get_netdev_name function
Date:   Tue, 17 Nov 2020 16:20:14 +0100
Message-Id: <20201117152015.142089-6-acardace@redhat.com>
In-Reply-To: <20201117152015.142089-1-acardace@redhat.com>
References: <20201117152015.142089-1-acardace@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index fa44cf6e732c..3c287ac78117 100644
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
+    echo $(ls /sys/bus/netdevsim/devices/netdevsim${NSIM_ID}/net/)
 }
-- 
2.28.0

