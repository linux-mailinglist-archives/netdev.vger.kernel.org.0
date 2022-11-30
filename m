Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1251A63D7BF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 15:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbiK3OIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 09:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbiK3OHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 09:07:40 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BA98BD1A
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:11 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id gu23so23382437ejb.10
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 06:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=crtfe0BqYH7z6M5EdvzpYlnGHWPelxQYGarO1VmKQvw=;
        b=otqhoCh8Mfyz+qmipWbuwC3TgoKxWSKZ0iHSVOuvBsvwv7W4AUrr0dof5qilNIYMcy
         O5Db8C0CcRhQTQIYNzXaM2Vne0WAImxhNbYC6r/7Fx1/JRzV+QA2IV85FuFUefA1ZFI4
         6Gk7jYT9ah0kMe5cV9LdmKNGaRlF113NP+fUuXmd8jkSnCRu0ejY9E44R3JXX7Ne+vuB
         9vWqUc8KC+pFlSH1EtPDgCWNOHAMcZd3Q3x9E8so551HXFle6nHfS36G+RKgH9B90f81
         5DP3NWvZMLcCnOi5syjz95eIXGgNcHi4PRIS7ceKYA4DIyHImvv2wcB6JQvVe5TeCc2A
         DhPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=crtfe0BqYH7z6M5EdvzpYlnGHWPelxQYGarO1VmKQvw=;
        b=4fQLqzSpesSUwqdwxyDuYdOeASasnM34xF4zHAc20sEkUAUqNw2TikOLaiImyZwmBq
         zNNt5847e253qlRkDXcMAaxg4QtJHfcXi8ZnCTJiuzJIwaOw7McLdVKs6QN9SRt8Z2eG
         LweMX7blAIPv12Ip6g/gvIQaAKinLwxUsuExMQ2JvdOG+aNs9WNSW2WCQyaaETyX8KS1
         7q+3Bv6sdqXOYDAsCesRQhuRG3nIuFTaphGexn11AuISd7SX1Tl3IhRWYx9ylIcCk3fu
         5hLjrxun7x3yGY1LLvyv25JRKxNjMgKVzh7+izqHHODgdyh+/NJhyNGnSJSwjm1ayxB1
         6BeQ==
X-Gm-Message-State: ANoB5pntrSqN9kw5+PZjr1wKUa4I3y9bPs2433VEsa+4lRpcW13uyWN1
        AygSVntxzYzSf9aLP1dt9Koikg==
X-Google-Smtp-Source: AA0mqf6iuqR5tkTBTX5XDYNTW/0KzzHvEQ3V6EgUmFA7Rz6lbNnAK+pA/9/lcq7SWOrS/f/bV6hEjg==
X-Received: by 2002:a17:907:cb83:b0:7ad:f43a:cb0a with SMTP id un3-20020a170907cb8300b007adf43acb0amr37990314ejc.560.1669817229960;
        Wed, 30 Nov 2022 06:07:09 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id mh1-20020a170906eb8100b0073d83f80b05sm692454ejb.94.2022.11.30.06.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 06:07:09 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 09/11] selftests: mptcp: listener test for userspace PM
Date:   Wed, 30 Nov 2022 15:06:31 +0100
Message-Id: <20221130140637.409926-10-matthieu.baerts@tessares.net>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20221130140637.409926-1-matthieu.baerts@tessares.net>
References: <20221130140637.409926-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3985; i=matthieu.baerts@tessares.net;
 h=from:subject; bh=bIIKO9xkuUAb1XnV8gcwknYCwBdI9wFkRM47L72h+T8=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBjh2NpubqDWHxbifXmvSXmneZrESd5I3dNUavydpFi
 vSuR2UuJAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY4djaQAKCRD2t4JPQmmgc9hgD/
 9gnV2rgJgPZ2ofqd1SbpeZkNWzNpgzoPb8ErESeVWdk71fcLXgZ+aPqRwHdmktIV/ae171hvvvq4Mw
 bWRxh6pFseApMksjLYPLIS89B0dzg8gCuPM+Mx0c66awI5L+2EpyC1Ni/Nc/zdNzsKPwjvohOzxfup
 LMPttz+5fKjDvLarL1Pr0sCxy6/jtXNPNixh0np4WrkyHq+NWscotw7hJdf1G3pAaslOIzqFB5VNBX
 L3vtsov4cVyuxOOahHUnJCjD9Xw6ax8FAadHBHbYCH3uthWIdCwzrn8lRk14he0lmpjKuZAY+FU6q7
 So9yQOC5DBzt3X29uhxF8os/xfyN0oq8DF4bJhOu+EM5JrkhqjA7GdiSeimRoHDDxWrUlqFtyaRMgy
 KosuhwU7RVhaWcECOvNrfy6XR2WBGvGWFHR+wsasvd6tWsa8thGiTiCz/krJ77uuVT+n8uiQSKFKAY
 vhGbTajYFa65K2HG5esVQ19l7isnMsOE1U7rGDDrRawSZR1vz/R52yTecJGkL5B8PtgQjQ5zgQq32P
 e1ddchz3HLom4dDLmx0zs2lMvLHtuQYJU2Ds1pq83DdJMxHIGTp4Gv7QRDX6c5fZM8B6BCng66wX+P
 vtdq5ZMsSjv/y27Hd872amRcdE5WvdCbbKvxGivKs2mOQU+HO8r1i6uXx86A==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp; fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geliang Tang <geliang.tang@suse.com>

This patch adds test coverage for listening sockets created by userspace
processes.

It adds a new test named test_listener() and a new verifying helper
verify_listener_events(). The new output looks like this:

 CREATE_SUBFLOW 10.0.2.2 (ns2) => 10.0.2.1 (ns1)              [OK]
 DESTROY_SUBFLOW 10.0.2.2 (ns2) => 10.0.2.1 (ns1)             [OK]
 MP_PRIO TX                                                   [OK]
 MP_PRIO RX                                                   [OK]
 CREATE_LISTENER 10.0.2.2:37106				      [OK]
 CLOSE_LISTENER 10.0.2.2:37106				      [OK]

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 .../selftests/net/mptcp/userspace_pm.sh       | 76 +++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 91d6f30e2fe4..a29deb9fa024 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -11,6 +11,8 @@ ANNOUNCED=6        # MPTCP_EVENT_ANNOUNCED
 REMOVED=7          # MPTCP_EVENT_REMOVED
 SUB_ESTABLISHED=10 # MPTCP_EVENT_SUB_ESTABLISHED
 SUB_CLOSED=11      # MPTCP_EVENT_SUB_CLOSED
+LISTENER_CREATED=15 #MPTCP_EVENT_LISTENER_CREATED
+LISTENER_CLOSED=16  #MPTCP_EVENT_LISTENER_CLOSED
 
 AF_INET=2
 AF_INET6=10
@@ -781,11 +783,85 @@ test_prio()
 	fi
 }
 
+verify_listener_events()
+{
+	local evt=$1
+	local e_type=$2
+	local e_family=$3
+	local e_saddr=$4
+	local e_sport=$5
+	local type
+	local family
+	local saddr
+	local sport
+
+	if [ $e_type = $LISTENER_CREATED ]; then
+		stdbuf -o0 -e0 printf "CREATE_LISTENER %s:%s\t\t\t\t\t"\
+			$e_saddr $e_sport
+	elif [ $e_type = $LISTENER_CLOSED ]; then
+		stdbuf -o0 -e0 printf "CLOSE_LISTENER %s:%s\t\t\t\t\t"\
+			$e_saddr $e_sport
+	fi
+
+	type=$(grep "type:$e_type," $evt |
+	       sed --unbuffered -n 's/.*\(type:\)\([[:digit:]]*\).*$/\2/p;q')
+	family=$(grep "type:$e_type," $evt |
+		 sed --unbuffered -n 's/.*\(family:\)\([[:digit:]]*\).*$/\2/p;q')
+	sport=$(grep "type:$e_type," $evt |
+		sed --unbuffered -n 's/.*\(sport:\)\([[:digit:]]*\).*$/\2/p;q')
+	if [ $family ] && [ $family = $AF_INET6 ]; then
+		saddr=$(grep "type:$e_type," $evt |
+			sed --unbuffered -n 's/.*\(saddr6:\)\([0-9a-f:.]*\).*$/\2/p;q')
+	else
+		saddr=$(grep "type:$e_type," $evt |
+			sed --unbuffered -n 's/.*\(saddr4:\)\([0-9.]*\).*$/\2/p;q')
+	fi
+
+	if [ $type ] && [ $type = $e_type ] &&
+	   [ $family ] && [ $family = $e_family ] &&
+	   [ $saddr ] && [ $saddr = $e_saddr ] &&
+	   [ $sport ] && [ $sport = $e_sport ]; then
+		stdbuf -o0 -e0 printf "[OK]\n"
+		return 0
+	fi
+	stdbuf -o0 -e0 printf "[FAIL]\n"
+	exit 1
+}
+
+test_listener()
+{
+	# Capture events on the network namespace running the client
+	:>$client_evts
+
+	# Attempt to add a listener at 10.0.2.2:<subflow-port>
+	ip netns exec $ns2 ./pm_nl_ctl listen 10.0.2.2\
+		$client4_port > /dev/null 2>&1 &
+	local listener_pid=$!
+
+	verify_listener_events $client_evts $LISTENER_CREATED $AF_INET 10.0.2.2 $client4_port
+
+	# ADD_ADDR from client to server machine reusing the subflow port
+	ip netns exec $ns2 ./pm_nl_ctl ann 10.0.2.2 token $client4_token id\
+		$client_addr_id > /dev/null 2>&1
+	sleep 0.5
+
+	# CREATE_SUBFLOW from server to client machine
+	ip netns exec $ns1 ./pm_nl_ctl csf lip 10.0.2.1 lid 23 rip 10.0.2.2\
+		rport $client4_port token $server4_token > /dev/null 2>&1
+	sleep 0.5
+
+	# Delete the listener from the client ns, if one was created
+	kill_wait $listener_pid
+
+	verify_listener_events $client_evts $LISTENER_CLOSED $AF_INET 10.0.2.2 $client4_port
+}
+
 make_connection
 make_connection "v6"
 test_announce
 test_remove
 test_subflows
 test_prio
+test_listener
 
 exit 0
-- 
2.37.2

