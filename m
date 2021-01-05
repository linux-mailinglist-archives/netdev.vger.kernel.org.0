Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9834C2EAE9F
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 16:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbhAEPfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 10:35:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35361 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727660AbhAEPfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 10:35:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609860838;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=pDzAcq2nT/KXhp+AqF/2GVIqAYTMHTBHiO9DQwkg9VA=;
        b=BwsoOXFa3LM9hMWqy41RuL6lDr8nfsWHMna76YPbsD3gMnszRpCInMsrsJtpFhUMIVuRKL
        OA+Vq1RSxEu39eZ9HVtTchlezOjctDp5uwgn8YLXPlLMktMfvIn7zdnU/VM93LD7CUaHVM
        4Obi32xRYuDraCWMnLy9OZkycTeq6qE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-2-1JPyH1czPxurlL3jUNITaw-1; Tue, 05 Jan 2021 10:31:27 -0500
X-MC-Unique: 1JPyH1czPxurlL3jUNITaw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A03F8030A3;
        Tue,  5 Jan 2021 15:31:26 +0000 (UTC)
Received: from yiche-home.usersys.redhat.com (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4F9E6271BF;
        Tue,  5 Jan 2021 15:31:22 +0000 (UTC)
From:   Chen Yi <yiche@redhat.com>
To:     Chen Yi <yiche@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Leo <liuhangbin@gmail.com>
Subject: [PATCH] selftests: netfilter: Pass family parameter "-f" to conntrack tool
Date:   Tue,  5 Jan 2021 23:31:20 +0800
Message-Id: <20210105153120.42710-1-yiche@redhat.com>
Reply-To: 20210104110723.43564-1-yiche@redhat.com
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix nft_conntrack_helper.sh false fail report:

1) Conntrack tool need "-f ipv6" parameter to show out ipv6 traffic items.

2) Sleep 1 second after background nc send packet, to make sure check
is after this statement executed.

False report:
FAIL: ns1-lkjUemYw did not show attached helper ip set via ruleset
PASS: ns1-lkjUemYw connection on port 2121 has ftp helper attached
...

After fix:
PASS: ns1-2hUniwU2 connection on port 2121 has ftp helper attached
PASS: ns2-2hUniwU2 connection on port 2121 has ftp helper attached
...

Fixes: 619ae8e0697a6 ("selftests: netfilter: add test case for conntrack helper assignment")
Signed-off-by: Chen Yi <yiche@redhat.com>
---
 .../selftests/netfilter/nft_conntrack_helper.sh      | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
index edf0a48da6bf..bf6b9626c7dd 100755
--- a/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
+++ b/tools/testing/selftests/netfilter/nft_conntrack_helper.sh
@@ -94,7 +94,13 @@ check_for_helper()
 	local message=$2
 	local port=$3
 
-	ip netns exec ${netns} conntrack -L -p tcp --dport $port 2> /dev/null |grep -q 'helper=ftp'
+	if echo $message |grep -q 'ipv6';then
+		local family="ipv6"
+	else
+		local family="ipv4"
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

