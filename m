Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6618042B7FE
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238251AbhJMGxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238132AbhJMGxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 02:53:00 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9A9C061746;
        Tue, 12 Oct 2021 23:50:57 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id d3so5850301edp.3;
        Tue, 12 Oct 2021 23:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sYEkYt6iYNeaWn6bOb0NNKmx0bUVH+EyDgknjG8Vdgs=;
        b=NzXBqU13rCw8j2apKxQY9Nim2YLIxyaDipJlLu9zwTAvehJX/ngIG6JAvNaSQs2hh3
         g2MoPFfu43wK4Jh48R8A8mtUDIFcCwh+C7kIMHwiU/JVzWHNSb8PepdNjiRwrf/YbvUp
         Me9DBjxHW78XZ7ezplTqldHVIJBKzOMZtMGG2EK6Bp6JVf5nh9OaoiWUfsNHTrKxokyW
         Ka5XxLGGHjEHwds2x+f4Q+bchB6mNFs5kLZiVzHgjc6JeNobYxDSeVPs7Pkz7CxCc+jX
         RnsXshYR9hIcdWPi1WbObWmRDGLPibcgCjSR38GSf/doC3Xed7H9jjrZocXBOzEuXDdI
         f9ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sYEkYt6iYNeaWn6bOb0NNKmx0bUVH+EyDgknjG8Vdgs=;
        b=uhNpPa/iMLPB+PvJTakoVIKvOi6qjun466C0JseONebm41LqUJWYHbLnXxCSyo8aM+
         0jDyWRWrb27gVLnaQOim04cA2EediN9VqGSQJNX3cITaeTXxAWfG31EycX9uI0Kd9hbz
         1nb+rCSKl81DORPLnmsPv1ESiq3qV1UiwAa/HbhTxzG5BdNptS9X4fgr4ba8elDG3PjN
         WNpC0jlNAZ0ZANq0kTJMt7R5Quc2s6WyB9knsgshBKk2E3PfdYAe1RJZYU1i95yfz+1a
         Z512MC7nnjbOHIrDaoOnxaUGn5OylUd62J2U0SqeTXyP9U2DYoOmnG24hJeRr74mYBNO
         KO/Q==
X-Gm-Message-State: AOAM531+K7s4Rt23KheWH0njS4/L7rNsRPrDR5mLG/Jf7j31D4TjqNCL
        04A6EKuApfuHW5Oo1ZMIZJc=
X-Google-Smtp-Source: ABdhPJw2rNGppb9Gi5pZ6k5YuQdmOaDBkSi9jE/UxHZJSRAyHSAV+GHVlMoNAs1jdBu5UuygfsufGg==
X-Received: by 2002:a05:6402:40d2:: with SMTP id z18mr6900904edb.362.1634107855825;
        Tue, 12 Oct 2021 23:50:55 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:6346:a6a3:f7ea:349e])
        by smtp.gmail.com with ESMTPSA id m15sm4568710edd.5.2021.10.12.23.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:50:55 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] selftests: net/fcnal: Test --{do,no}-bind-key-ifindex
Date:   Wed, 13 Oct 2021 09:50:38 +0300
Message-Id: <e864a790986862bb09c69627067a0349253f0fc8.1634107317.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634107317.git.cdleonard@gmail.com>
References: <cover.1634107317.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Test that applications binding listening sockets to VRFs without
specifying TCP_MD5SIG_FLAG_IFINDEX will work as expected. This would
be broken if __tcp_md5_do_lookup always made a strict comparison on
l3index. See this email:

https://lore.kernel.org/netdev/209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com/

Applications using tcp_l3mdev_accept=1 and a single global socket (not
bound to any interface) also should have a way to specify keys that are
only for the default VRF, this is done by --do-bind-key-ifindex without
otherwise binding to a device.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 60 +++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 13350cd5c8ac..28728e2f3eae 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -287,10 +287,16 @@ set_sysctl()
 	echo "SYSCTL: $*"
 	echo
 	run_cmd sysctl -q -w $*
 }
 
+# get sysctl values in NS-A
+get_sysctl()
+{
+	${NSA_CMD} sysctl -n $*
+}
+
 ################################################################################
 # Setup for tests
 
 addr2str()
 {
@@ -1001,10 +1007,64 @@ ipv4_tcp_md5()
 
 	log_start
 	run_cmd nettest -s -I ${NSA_DEV} -M ${MD5_PW} -m ${NS_NET}
 	log_test $? 1 "MD5: VRF: Device must be a VRF - prefix"
 
+	test_ipv4_md5_vrf__vrf_server__no_bind_ifindex
+	test_ipv4_md5_vrf__global_server__bind_ifindex0
+}
+
+test_ipv4_md5_vrf__vrf_server__no_bind_ifindex()
+{
+	log_start
+	show_hint "Simulates applications using VRF without TCP_MD5SIG_FLAG_IFINDEX"
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: VRF-bound server, unbound key accepts connection"
+
+	log_start
+	show_hint "Binding both the socket and the key is not required but it works"
+	run_cmd nettest -s -I ${VRF} -M ${MD5_PW} -m ${NS_NET} --do-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: VRF-bound server, bound key accepts connection"
+}
+
+test_ipv4_md5_vrf__global_server__bind_ifindex0()
+{
+	# This particular test needs tcp_l3mdev_accept=1 for Global server to accept VRF connections
+	local old_tcp_l3mdev_accept
+	old_tcp_l3mdev_accept=$(get_sysctl net.ipv4.tcp_l3mdev_accept)
+	set_sysctl net.ipv4.tcp_l3mdev_accept=1
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --do-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 2 "MD5: VRF: Global server, Key bound to ifindex=0 rejects VRF connection"
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --do-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key bound to ifindex=0 accepts non-VRF connection"
+	log_start
+
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsb nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts VRF connection"
+
+	log_start
+	run_cmd nettest -s -M ${MD5_PW} -m ${NS_NET} --no-bind-key-ifindex &
+	sleep 1
+	run_cmd_nsc nettest -r ${NSA_IP} -X ${MD5_PW}
+	log_test $? 0 "MD5: VRF: Global server, key not bound to ifindex accepts non-VRF connection"
+
+	# restore value
+	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
 }
 
 ipv4_tcp_novrf()
 {
 	local a
-- 
2.25.1

