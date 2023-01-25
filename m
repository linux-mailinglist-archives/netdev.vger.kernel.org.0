Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BE867B057
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 11:49:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235588AbjAYKtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 05:49:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235740AbjAYKtO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 05:49:14 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3F0577E6
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:13 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f19-20020a1c6a13000000b003db0ef4dedcso919268wmc.4
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 02:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares.net; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3qynjSOc6nz4Nf6cQvYVVmdAvys7aqe1bFN8sKVYTz8=;
        b=mvgkbs7E687JKkTLyPJRpf8Xfh8mSV2+GLd1lNG7xZ/hquVAxxx/ZdarKyszSnvPE+
         DBXn/W4v1I2+NKYIqjUPOOorRGG+Kdonx9kWv7PkfHwHg8NakgZhDD5UooSRECRGQDeX
         tBgY//8TJ1ncc4A1nGHSGMuHVvW6FLrQN/FaPsJSA9xHji44P9/C6IYa9KIuTTDWhkdi
         ipYwsJGijh9sT/4dflQh12wTP9sf7+iiKdPef3xIM6Sq9EKHcKd3pp+LiAXEFUUKavm6
         zXDZMFo+ywL3NJEM4wqelJNC2vv/n2y768gbUPChpXzC/EJ+n0NV8K2eInQsnFhps1Sc
         BqIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3qynjSOc6nz4Nf6cQvYVVmdAvys7aqe1bFN8sKVYTz8=;
        b=3G3vIBmFDdDde0MHhyuesBYOYM1eg3RqMJmqfE3wuA0VjnDCZIzeOgc46pzNy4OPjN
         ISUcxLD2wHog6OIF5CxRb4SK84YK5rqDSimJfvmNofgateRTbUDtRqP2txF2qBhv+OxL
         AGplLI736PdYnjeKXphTE+Sy7tMEjwSGqvPWoZuRf2pPL63bfOf58sGd8UJnoqrK5x9b
         RNb3RhbAejPSIzuOIfMv6zt2YV5RqtUKoGQQlTCTtnD7pNVFCHPfDjFyjsX/1b+CFyoP
         qtADMuHfNvopR88BCgxiDgkZAOjDiXFSg55aGU1uzpFK160gkunkLFjYdqoe0W9+PNib
         D/+g==
X-Gm-Message-State: AFqh2koaiq0GHRtZFpmKZEkkXGoKomCGPXsLV6KGA9fWttWcUCQU3g5h
        dwC4d/ci6kGuUSPPHgbUTtxaKw==
X-Google-Smtp-Source: AMrXdXue8fHvsLjHuYjJlYDZFc9m+OmNq0Yo/E91IxOqD8Lm3kf4A9yMhzqoxJAjsplHCLG0SdGLoA==
X-Received: by 2002:a05:600c:1713:b0:3da:fd90:19dd with SMTP id c19-20020a05600c171300b003dafd9019ddmr31052393wmn.26.1674643686984;
        Wed, 25 Jan 2023 02:48:06 -0800 (PST)
Received: from vdi08.nix.tessares.net (static.219.156.76.144.clients.your-server.de. [144.76.156.219])
        by smtp.gmail.com with ESMTPSA id r1-20020a05600c424100b003d9a86a13bfsm1423692wmm.28.2023.01.25.02.48.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 02:48:06 -0800 (PST)
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Date:   Wed, 25 Jan 2023 11:47:28 +0100
Subject: [PATCH net-next 8/8] selftests: mptcp: userspace: avoid read
 errors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230123-upstream-net-next-pm-v4-v6-v1-8-43fac502bfbf@tessares.net>
References: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
In-Reply-To: <20230123-upstream-net-next-pm-v4-v6-v1-0-43fac502bfbf@tessares.net>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
X-Mailer: b4 0.12.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2122;
 i=matthieu.baerts@tessares.net; h=from:subject:message-id;
 bh=6MOG1ZEazJbpV3v3EchrO329puIDO6dd5lQxjWDGRMo=;
 b=owEBbQKS/ZANAwAIAfa3gk9CaaBzAcsmYgBj0QjdROHosjdgthf7sJ7fwTT7T291txcJlOXdMy83
 0OLZ1G6JAjMEAAEIAB0WIQToy4X3aHcFem4n93r2t4JPQmmgcwUCY9EI3QAKCRD2t4JPQmmgc7csEA
 CbPf+IRNTcrGZQC9QI7Yjf/aCMXKOxRtzRhttRiohq7mKvymkfTT4g70DdGz+uRLKD+cK9TkMqd2mv
 HVH3WfEd+OSehw0Vk/yr3fYuXQewl8dVbg+DA1EagE3EDeUJ0Ztm/y5N2f7Zud34C5b1mWqKShx+dF
 wg1ybzUvvQu+GCkGL/SqRVNkVSK37EfnYB65gIikXED5CDt/I+wqCi/cOQcmFpjk7/Pfdaj4uhS2mP
 A/6iMw32sesJ2BMqCVuyCDRxPCOPEiFD22/45KINjXTfVOZGtBYchOynwxDxpTGsOnrWANUWay21xs
 7KJ7eIIXLiv+OJM+6+8Fyjl6vW2h5z1msYmcBZjmJMdKFFAGvnx6XGVji524YO3uQECONQolvJoItm
 Op86B/1iTSVmGpwB7wJJNCTcgWuEB9+GSbRWYyfuKPWgf1YpK4AEHBOCJn74qFvXd0qhHZ8bzKZ6D1
 0O/nrR+CJGb4HlMQCrzrr6Xe0KFPfx7UMZg/RiCG9APdhw3Viamh03zD8WfI1Bs0Ocb5x/0K9dwW48
 22UiCsU1M11LYEkINUw65f6XsqPO/uwWh7fGmXFHzM9gCg0HeHRi75RV1ztTqey69uMSk5d0aDKuRp
 RvfrKxDXEYcTaQAG+/nA/RXn78aCdfwHL6oHShYKJXZMf/Mm/6OLUsCoaNNA==
X-Developer-Key: i=matthieu.baerts@tessares.net; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the cleanup phase, the server pids were killed with a SIGTERM
directly, not using a SIGUSR1 first to quit safely. As a result, this
test was often ending with two error messages:

  read: Connection reset by peer

While at it, use a for-loop to terminate all the PIDs the same way.

Also the different files are now removed after having killed the PIDs
using them. It makes more sense to do that in this order.

Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
---
 tools/testing/selftests/net/mptcp/userspace_pm.sh | 32 +++++++++--------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 259382ad552c..66c5be25c13d 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -50,6 +50,9 @@ print_title()
 
 kill_wait()
 {
+	[ $1 -eq 0 ] && return 0
+
+	kill -SIGUSR1 $1 > /dev/null 2>&1
 	kill $1 > /dev/null 2>&1
 	wait $1 2>/dev/null
 }
@@ -58,32 +61,21 @@ cleanup()
 {
 	print_title "Cleanup"
 
-	rm -rf $file $client_evts $server_evts
-
 	# Terminate the MPTCP connection and related processes
-	if [ $client4_pid -ne 0 ]; then
-		kill -SIGUSR1 $client4_pid > /dev/null 2>&1
-	fi
-	if [ $server4_pid -ne 0 ]; then
-		kill_wait $server4_pid
-	fi
-	if [ $client6_pid -ne 0 ]; then
-		kill -SIGUSR1 $client6_pid > /dev/null 2>&1
-	fi
-	if [ $server6_pid -ne 0 ]; then
-		kill_wait $server6_pid
-	fi
-	if [ $server_evts_pid -ne 0 ]; then
-		kill_wait $server_evts_pid
-	fi
-	if [ $client_evts_pid -ne 0 ]; then
-		kill_wait $client_evts_pid
-	fi
+	local pid
+	for pid in $client4_pid $server4_pid $client6_pid $server6_pid\
+		   $server_evts_pid $client_evts_pid
+	do
+		kill_wait $pid
+	done
+
 	local netns
 	for netns in "$ns1" "$ns2" ;do
 		ip netns del "$netns"
 	done
 
+	rm -rf $file $client_evts $server_evts
+
 	stdbuf -o0 -e0 printf "Done\n"
 }
 

-- 
2.38.1

