Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22E16E8CA2
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 10:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234438AbjDTIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 04:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234435AbjDTIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 04:23:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890945266
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:55 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a6f0d8cdfeso7497705ad.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681978974; x=1684570974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=ZhWTt8RRTwq9m8zhg0QK6AEg07Vs2JHM6E61j+pzIVqj8Mk4DBTiDrxj2MXvc+C6sa
         C+rmkVJTJQ+cHwcuGOTEQO0PLTP5k4f4MBEFym4cA82LT1fZkj1q2Zva+07ze7OscLHU
         VzD/XIeXw2vfS+MUijkucX9Gv2XMc7QBLo6qyQT3ZBbgtBFt8Nho2I9JTHZiOjp5XZvS
         n4piIaYRnF8Nj98x/bUMeABbR27VZfSZqApLOPK/qppaOgFatqNQqYPr+JoaEBP+66vN
         jqORYIqGFc7y2DSsfGXwxwrhDZR8YJV1BjBfV8lAHkDeLN8QEpdSoPbZlfbkg/Xuf0tG
         1EYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681978974; x=1684570974;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=byz8DrvEOBV/DSCuv4G+TsCPSzSHDCTlZ8+dEGnlGdSpYnkYk1HXs7HVHiKkHFHkPh
         EiLbHn6Gcy2iCP2//WcaHXdP9oHRB8a+zonAAH5K7nwz+hlU8XxF0YCkMjrGyDsfGBxI
         UJ0JuhFBHiKMry7j6w+XMr+GGnfI794gLRWnZExVHgs0RgxcmgpN5loxUF7XnPSP32KD
         loAqrd3y2ChlyE9yqEtb8S7Ah9XT/RVWOT4gEbZaJJ8np71KC00Uj0wPuwKyf/RkEdN3
         RRzU4sFvjuvyEa/lbNADGq7T1f1/xGQC91J97HlhMbboH0VTw3QuUe7VksL1nT3VjEbN
         Z4gA==
X-Gm-Message-State: AAQBX9fUtr+D8cx9OjXjVYqsy/qo2j06MK6nSe6EOsjMpEDsQARB9DKG
        GSlGtol7pdoIq4oIkWLvPQOt+2FUhIMfwYMZjzI=
X-Google-Smtp-Source: AKy350aRn72PSLlgVJhjhBtvcRFMZP6fQR7lAZ1DMXMMWmn3mivyTtEYwZpT5GT/iLX6ibI3yR3CGg==
X-Received: by 2002:a17:902:db0a:b0:1a1:b52d:68e1 with SMTP id m10-20020a170902db0a00b001a1b52d68e1mr843807plx.32.1681978974151;
        Thu, 20 Apr 2023 01:22:54 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l11-20020a170902d34b00b001a1ed2fce9asm662175plk.235.2023.04.20.01.22.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 01:22:53 -0700 (PDT)
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Liang Li <liali@redhat.com>,
        Vincent Bernat <vincent@bernat.ch>,
        Hangbin Liu <liuhangbin@gmail.com>
Subject: [PATCH net 4/4] kselftest: bonding: add num_grat_arp test
Date:   Thu, 20 Apr 2023 16:22:30 +0800
Message-Id: <20230420082230.2968883-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230420082230.2968883-1-liuhangbin@gmail.com>
References: <20230420082230.2968883-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TEST: num_grat_arp (active-backup miimon num_grat_arp 10)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 20)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 30)           [ OK ]
TEST: num_grat_arp (active-backup miimon num_grat_arp 50)           [ OK ]

Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
---
 .../drivers/net/bonding/bond_options.sh       | 50 +++++++++++++++++++
 .../drivers/net/bonding/bond_topo_3d1c.sh     |  2 +
 2 files changed, 52 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/bonding/bond_options.sh b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
index db29a3146a86..607ba5c38977 100755
--- a/tools/testing/selftests/drivers/net/bonding/bond_options.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_options.sh
@@ -6,6 +6,7 @@
 ALL_TESTS="
 	prio
 	arp_validate
+	num_grat_arp
 "
 
 REQUIRE_MZ=no
@@ -255,6 +256,55 @@ arp_validate()
 	arp_validate_ns "active-backup"
 }
 
+garp_test()
+{
+	local param="$1"
+	local active_slave exp_num real_num i
+	RET=0
+
+	# create bond
+	bond_reset "${param}"
+
+	bond_check_connection
+	[ $RET -ne 0 ] && log_test "num_grat_arp" "$retmsg"
+
+
+	# Add tc rules to count GARP number
+	for i in $(seq 0 2); do
+		tc -n ${g_ns} filter add dev s$i ingress protocol arp pref 1 handle 101 \
+			flower skip_hw arp_op request arp_sip ${s_ip4} arp_tip ${s_ip4} action pass
+	done
+
+	# Do failover
+	active_slave=$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].linkinfo.info_data.active_slave")
+	ip -n ${s_ns} link set ${active_slave} down
+
+	exp_num=$(echo "${param}" | cut -f6 -d ' ')
+	sleep $((exp_num + 2))
+
+	active_slave=$(cmd_jq "ip -n ${s_ns} -d -j link show bond0" ".[].linkinfo.info_data.active_slave")
+
+	# check result
+	real_num=$(tc_rule_handle_stats_get "dev s${active_slave#eth} ingress" 101 ".packets" "-n ${g_ns}")
+	if [ "${real_num}" -ne "${exp_num}" ]; then
+		echo "$real_num garp packets sent on active slave ${active_slave}"
+		RET=1
+	fi
+
+	for i in $(seq 0 2); do
+		tc -n ${g_ns} filter del dev s$i ingress
+	done
+}
+
+num_grat_arp()
+{
+	local val
+	for val in 10 20 30 50; do
+		garp_test "mode active-backup miimon 100 num_grat_arp $val peer_notify_delay 1000"
+		log_test "num_grat_arp" "active-backup miimon num_grat_arp $val"
+	done
+}
+
 trap cleanup EXIT
 
 setup_prepare
diff --git a/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
index 4045ca97fb22..69ab99a56043 100644
--- a/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
+++ b/tools/testing/selftests/drivers/net/bonding/bond_topo_3d1c.sh
@@ -61,6 +61,8 @@ server_create()
 		ip -n ${g_ns} link set s${i} up
 		ip -n ${g_ns} link set s${i} master br0
 		ip -n ${s_ns} link set eth${i} master bond0
+
+		tc -n ${g_ns} qdisc add dev s${i} clsact
 	done
 
 	ip -n ${s_ns} link set bond0 up
-- 
2.38.1

