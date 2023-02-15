Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCE769837C
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 19:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230294AbjBOSgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 13:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjBOSer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 13:34:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426CB3A099
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 10:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676486037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8H+Rq2TtqEV0E/fvZ/Dj9was8abSxIY6L7nWNidxOq8=;
        b=ITlZE2Xy8ANJK3qzEkrLPFaBqBkMVvDk5azBm+i7Ak4phAxMwwuui4KjNPIKPIVbdMOyxz
        LTEQ9lIWifxIPR2Zz9CJkBjNkGk6ZhT/VV7D6/Vq8PNdnNlqkaogBqfZmpCLDhvg4ZTjSw
        c0SKRqrSzA0ha+OsYD2rgUxSeJk/7oo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-613-E6JM5RgiPgilxR6Cb1HwwA-1; Wed, 15 Feb 2023 13:33:53 -0500
X-MC-Unique: E6JM5RgiPgilxR6Cb1HwwA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 35CEC857F41;
        Wed, 15 Feb 2023 18:33:53 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.192.137])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2348640C1423;
        Wed, 15 Feb 2023 18:33:51 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Shuah Khan <shuah@kernel.org>
Subject: [PATCH net-next 2/2] self-tests: more rps self tests
Date:   Wed, 15 Feb 2023 19:33:37 +0100
Message-Id: <36b6f576ac497986d4231a64616fb79f1718a314.1676484775.git.pabeni@redhat.com>
In-Reply-To: <cover.1676484775.git.pabeni@redhat.com>
References: <cover.1676484775.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly check for child netns and main ns independency

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 .../testing/selftests/net/rps_default_mask.sh | 41 +++++++++++++------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/net/rps_default_mask.sh b/tools/testing/selftests/net/rps_default_mask.sh
index c81c0ac7ddfe..0fd0d2db3abc 100755
--- a/tools/testing/selftests/net/rps_default_mask.sh
+++ b/tools/testing/selftests/net/rps_default_mask.sh
@@ -8,7 +8,9 @@ ret=0
 [ $cpus -gt 2 ] || exit $ksft_skip
 
 readonly INITIAL_RPS_DEFAULT_MASK=$(cat /proc/sys/net/core/rps_default_mask)
-readonly NETNS="ns-$(mktemp -u XXXXXX)"
+readonly TAG="$(mktemp -u XXXXXX)"
+readonly VETH="veth${TAG}"
+readonly NETNS="ns-${TAG}"
 
 setup() {
 	ip netns add "${NETNS}"
@@ -21,11 +23,15 @@ cleanup() {
 }
 
 chk_rps() {
-	local rps_mask expected_rps_mask=$3
-	local dev_name=$2
+	local rps_mask expected_rps_mask=$4
+	local dev_name=$3
+	local netns=$2
+	local cmd="cat"
 	local msg=$1
 
-	rps_mask=$(ip netns exec $NETNS cat /sys/class/net/$dev_name/queues/rx-0/rps_cpus)
+	[ -n "$netns" ] && cmd="ip netns exec $netns $cmd"
+
+	rps_mask=$($cmd /sys/class/net/$dev_name/queues/rx-0/rps_cpus)
 	printf "%-60s" "$msg"
 	if [ $rps_mask -eq $expected_rps_mask ]; then
 		echo "[ ok ]"
@@ -39,19 +45,30 @@ trap cleanup EXIT
 
 echo 0 > /proc/sys/net/core/rps_default_mask
 setup
-chk_rps "empty rps_default_mask" lo 0
+chk_rps "empty rps_default_mask" $NETNS lo 0
 cleanup
 
 echo 1 > /proc/sys/net/core/rps_default_mask
 setup
-chk_rps "non zero rps_default_mask" lo 1
+chk_rps "changing rps_default_mask dont affect existing devices" "" lo $INITIAL_RPS_DEFAULT_MASK
 
 echo 3 > /proc/sys/net/core/rps_default_mask
-chk_rps "changing rps_default_mask dont affect existing netns" lo 1
+chk_rps "changing rps_default_mask dont affect existing netns" $NETNS lo 0
+
+ip link add name $VETH type veth peer netns $NETNS name $VETH
+ip link set dev $VETH up
+ip -n $NETNS link set dev $VETH up
+chk_rps "changing rps_default_mask affect newly created devices" "" $VETH 3
+chk_rps "changing rps_default_mask don't affect newly child netns[II]" $NETNS $VETH 0
+ip netns del $NETNS
+
+setup
+chk_rps "rps_default_mask is 0 by default in child netns" "$NETNS" lo 0
+
+ip netns exec $NETNS sysctl -qw net.core.rps_default_mask=1
+ip link add name $VETH type veth peer netns $NETNS name $VETH
+chk_rps "changing rps_default_mask in child ns don't affect the main one" "" lo $INITIAL_RPS_DEFAULT_MASK
+chk_rps "changing rps_default_mask in child ns affects new childns devices" $NETNS $VETH 1
+chk_rps "changing rps_default_mask in child ns don't affect existing devices" $NETNS lo 0
 
-ip -n $NETNS link add type veth
-ip -n $NETNS link set dev veth0 up
-ip -n $NETNS link set dev veth1 up
-chk_rps "changing rps_default_mask affect newly created devices" veth0 3
-chk_rps "changing rps_default_mask affect newly created devices[II]" veth1 3
 exit $ret
-- 
2.39.1

