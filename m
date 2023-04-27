Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70E566EFFE9
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 05:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242924AbjD0Djo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 23:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242907AbjD0Djd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 23:39:33 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E63212D
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:32 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-63b50a02bffso6506406b3a.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 20:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682566772; x=1685158772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=i7OmKyDE6tnYR2ACl3ePynhT8RBKJNfahShx4vwm+3sC6PnsUR5SJqewoJ8u+CDXuH
         57pANs3xxyAgz2WOqhrefmvv4RMylEfj1x3MtEQJLbDJKcBrcE5nLjggKmgCpJK6w4NO
         upind+RIzGeycafQGdkZeod+crBUJUgX78rDLQiMfB2WnEnDGZEl1hCQoalRjYnIo9gn
         ZU96JDk/L6YdTXp11IDimdag8Nmket2RHuNJVLVdEBIr3xLorP9/26FIdPmisRDP1liQ
         /ndtUw36nwwCbg2hIaxdbkcFZuIy6PvffuBGijNjMQsmyUUKdgs9jU1lNQAd3Yu7fi74
         mDNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682566772; x=1685158772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YeQDXm9CMBUR8AZx0MS+ObA2072iRcqiixIQ1S3eJEE=;
        b=IN15TepIRQqDHqjYXUlaCAyqzLSoJQc1tS2aZeAG2SJSRBBVMe6P9n/7p+h3R6HKqT
         gHyGF6A6vaTy5/taa+KnRHbU9FKxcWiwLD367ikBWWZDHFKtsZaoAAmQlpNlJ4DkoFsY
         X52P2hNw3q8CnF7M6Djt7a4GACHb6gKiKnaJUn8CEAIVAIgR63popqflf+QT5Xufx536
         R9W7ikKK6gCdl8yhexet0JEqH2hIQ6HOF0/s1G6g+MZ4bJNbY1zSw95TNzo+5HzMppZL
         tB7uXth0FN9tJ8wI5DAszNggk6H36Yyr2nO1WgrKj8JEnBD9D/fqZlZSaGYCU6TyVvEw
         N6Pw==
X-Gm-Message-State: AC+VfDwGsUdWObnqiIozdk6RFseEjISMLjY7/oy9XOn+FSphrx5By1a8
        um9knLQfl7cFv+jvH/zkbbFrJEIuQGIYiHOS
X-Google-Smtp-Source: ACHHUZ7wT9Tf5llVbur+R3hv6WRWrPmXmxbMT4a68MdmTzSv6XqF/1f8NqInw7ZileMIej8nHpOpJA==
X-Received: by 2002:a05:6a00:218e:b0:638:7e00:3737 with SMTP id h14-20020a056a00218e00b006387e003737mr361256pfi.23.1682566771688;
        Wed, 26 Apr 2023 20:39:31 -0700 (PDT)
Received: from Laptop-X1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h17-20020a056a001a5100b005abc30d9445sm12017743pfv.180.2023.04.26.20.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 20:39:31 -0700 (PDT)
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
Subject: [PATCHv2 net 4/4] kselftest: bonding: add num_grat_arp test
Date:   Thu, 27 Apr 2023 11:39:09 +0800
Message-Id: <20230427033909.4109569-5-liuhangbin@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230427033909.4109569-1-liuhangbin@gmail.com>
References: <20230427033909.4109569-1-liuhangbin@gmail.com>
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

