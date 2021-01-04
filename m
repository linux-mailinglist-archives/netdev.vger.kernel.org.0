Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F1E2E93F1
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 12:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbhADLI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 06:08:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28243 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726289AbhADLI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 06:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609758451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=aXmF7ZM6uSdCYSkS1zeIpIK77fT10Oniy+NfDbS/Gjs=;
        b=PV8wZ8o7uL2UF0QOfvxdW08kkAztxxiqDoWtNG8zC/PApCm7km4DSTqcUae/cF/CljkWOq
        NRkDdROCKsAS1m0wnox+uJb2Vmjww+41vkTC6gBcBP1ZLuZqfhRKTUlwATb5yLdQAiCtBq
        wJ7Gw7Nl7F7DIFuBWS3DBqYH0pisJPE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-0Zznn-W8Mtaoj7kuGBl8xA-1; Mon, 04 Jan 2021 06:07:29 -0500
X-MC-Unique: 0Zznn-W8Mtaoj7kuGBl8xA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1042C59;
        Mon,  4 Jan 2021 11:07:28 +0000 (UTC)
Received: from yiche-home.usersys.redhat.com (ovpn-12-222.pek2.redhat.com [10.72.12.222])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DA8B5D9C6;
        Mon,  4 Jan 2021 11:07:24 +0000 (UTC)
From:   Yi Chen <yiche@redhat.com>
To:     Chen Yi <yiche@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Leo <liuhangbin@gmail.com>
Subject: [PATCH net] selftests: netfilter: Pass the family parameter to conntrack tool
Date:   Mon,  4 Jan 2021 19:07:23 +0800
Message-Id: <20210104110723.43564-1-yiche@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: yiche <yiche@redhat.com>

Fix nft_conntrack_helper.sh fake fail:
conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.
sleep 1 second after background nc send packet, to make sure check
result after this statement is executed.

Signed-off-by: yiche <yiche@redhat.com>
---
 .../selftests/netfilter/nft_conntrack_helper.sh      | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
index edf0a48da6bf..ebdf2b23c8e3 100755
--- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -94,7 +94,13 @@ check_for_helper()
 	local message=$2
 	local port=$3
 
-	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
+	if [[ "$2" =~ "ipv6" ]];then
+	local family=ipv6
+	else
+	local family=ipv4
+	fi
+
+	ip netns exec ${netns} conntrack -L -f $family -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
 	if [ $? -ne 0 ] ; then
 		echo "FAIL: ${netns} did not show attached helper $message" 1>&2
 		ret=1
@@ -111,8 +117,8 @@ test_helper()
 
 	sleep 3 | ip netns exec ${ns2} nc -w 2 -l -p $port > /dev/null &
 
-	sleep 1
 	sleep 1 | ip netns exec ${ns1} nc -w 2 10.0.1.2 $port > /dev/null &
+	sleep 1
 
 	check_for_helper "$ns1" "ip $msg" $port
 	check_for_helper "$ns2" "ip $msg" $port
@@ -128,8 +134,8 @@ test_helper()
 
 	sleep 3 | ip netns exec ${ns2} nc -w 2 -6 -l -p $port > /dev/null &
 
-	sleep 1
 	sleep 1 | ip netns exec ${ns1} nc -w 2 -6 dead:1::2 $port > /dev/null &
+	sleep 1
 
 	check_for_helper "$ns1" "ipv6 $msg" $port
 	check_for_helper "$ns2" "ipv6 $msg" $port
-- 
2.26.2

