Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71645026B9
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 10:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351393AbiDOIgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 04:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351391AbiDOIgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 04:36:44 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBACB647D
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:34:15 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id r10so2970951pfh.13
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 01:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ysx3z0qnoZDqcu7UnVwDjeUCNklxQolOFd8xLQkr+KM=;
        b=f0Zkt6CSqZSuTsHua1ZHl4MqZfe7e9Wnhk7efeM2anzekwCZLNFsVbpmokUIhl9kjO
         x/LIQO66scGXHK6WhVdhjpzxSA50ApU7RaX40rP+qbWMU1JrrYKmed8EJnE8hcDRXPJ0
         KXflY+GBbIaB//dI9OhDjNNmV1/JM04qQBDgfRR23owy+AFojP8Yv4IhN5LkWyaEsYlD
         aZgPVxyuyeeIgIpL02M/cBYaM02jF6HFdpI7E2nV4Gf3VZ2KwzpMXED6uiMXjkHkyykn
         YRoVrGwGewgyyGddYZeZmh7EjEyIFb2Kbb3oRsXu0gg+eq7JFTBWNSq1s7GWHWYpPbJV
         PAMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ysx3z0qnoZDqcu7UnVwDjeUCNklxQolOFd8xLQkr+KM=;
        b=S+C5Z2XiQAQ8N0GOozVdsk1f7YmL2vxNh/oJ/3wyLDf0/oKppVRYr+IkHW8G9nSqBr
         XReCG+83lxbLAzv8JLnAooiQ8IG19A3gTrKKQfQCGUvyE8qetouGPTa3Vku5nAmv6MDO
         qMQpHj14Az9UFCClrzLAPV2tisxmcRA2z2Q90ljtniR4ZkwjJ0JhvE1DTUq87B+Lnzsw
         yadhRYV+wsxGFR8breZcCpFoxCUwTj9B6hUD9N3hjhV1eV7sMHx8EHoej502jwhrpDs5
         5fZ2rwnqW52bTkzO3m62NNP+J1EhGLXNpZjR9HuwEceDH2uHFzBqSNBIlzS7w4io4cm5
         4O8Q==
X-Gm-Message-State: AOAM5339uBav3UuA9K59vUGYDVY4b0rN/NhbU5JwkvMN2VtTSvQOR1z0
        aHg7Q1UvToYsnm1GQFZVpKE3K88/ixv9UfS6
X-Google-Smtp-Source: ABdhPJzXom3js69xulWvQ7denJwxJj4chYKz/TnWnTkAfu8Wy8Lde7DA7wnJvRM6r4ORT5xMSdURqA==
X-Received: by 2002:a05:6a00:2442:b0:4fd:8b00:d2f with SMTP id d2-20020a056a00244200b004fd8b000d2fmr7838082pfj.39.1650011653846;
        Fri, 15 Apr 2022 01:34:13 -0700 (PDT)
Received: from localhost.localdomain ([49.37.166.144])
        by smtp.gmail.com with ESMTPSA id bx6-20020a056a00428600b00508211a70absm1933100pfb.112.2022.04.15.01.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 01:34:12 -0700 (PDT)
From:   Arun Ajith S <aajith@arista.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, prestwoj@gmail.com, gilligan@arista.com,
        noureddine@arista.com, gk@arista.com, aajith@arista.com
Subject: [PATCH net-next v6] net/ipv6: Introduce accept_unsolicited_na knob to implement router-side changes for RFC9131
Date:   Fri, 15 Apr 2022 08:34:02 +0000
Message-Id: <20220415083402.39080-1-aajith@arista.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new neighbour cache entry in STALE state for routers on receiving
an unsolicited (gratuitous) neighbour advertisement with
target link-layer-address option specified.
This is similar to the arp_accept configuration for IPv4.
A new sysctl endpoint is created to turn on this behaviour:
/proc/sys/net/ipv6/conf/interface/accept_unsolicited_na.

Signed-off-by: Arun Ajith S <aajith@arista.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 Documentation/networking/ip-sysctl.rst        |  27 ++
 include/linux/ipv6.h                          |   1 +
 include/uapi/linux/ipv6.h                     |   1 +
 net/ipv6/addrconf.c                           |  10 +
 net/ipv6/ndisc.c                              |  20 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/ndisc_unsolicited_na_test.sh          | 255 ++++++++++++++++++
 7 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/ndisc_unsolicited_na_test.sh

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index b0024aa7b051..433f2e4a5fed 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2467,6 +2467,33 @@ drop_unsolicited_na - BOOLEAN
 
 	By default this is turned off.
 
+accept_unsolicited_na - BOOLEAN
+	Add a new neighbour cache entry in STALE state for routers on receiving an
+	unsolicited neighbour advertisement with target link-layer address option
+	specified. This is as per router-side behavior documented in RFC9131.
+	This has lower precedence than drop_unsolicited_na.
+
+	 ====   ======  ======  ==============================================
+	 drop   accept  fwding                   behaviour
+	 ----   ------  ------  ----------------------------------------------
+	    1        X       X  Drop NA packet and don't pass up the stack
+	    0        0       X  Pass NA packet up the stack, don't update NC
+	    0        1       0  Pass NA packet up the stack, don't update NC
+	    0        1       1  Pass NA packet up the stack, and add a STALE
+	                        NC entry
+	 ====   ======  ======  ==============================================
+
+	This will optimize the return path for the initial off-link communication
+	that is initiated by a directly connected host, by ensuring that
+	the first-hop router which turns on this setting doesn't have to
+	buffer the initial return packets to do neighbour-solicitation.
+	The prerequisite is that the host is configured to send
+	unsolicited neighbour advertisements on interface bringup.
+	This setting should be used in conjunction with the ndisc_notify setting
+	on the host to satisfy this prerequisite.
+
+	By default this is turned off.
+
 enhanced_dad - BOOLEAN
 	Include a nonce option in the IPv6 neighbor solicitation messages used for
 	duplicate address detection per RFC7527. A received DAD NS will only signal
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 16870f86c74d..918bfea4ef5f 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -61,6 +61,7 @@ struct ipv6_devconf {
 	__s32		suppress_frag_ndisc;
 	__s32		accept_ra_mtu;
 	__s32		drop_unsolicited_na;
+	__s32		accept_unsolicited_na;
 	struct ipv6_stable_secret {
 		bool initialized;
 		struct in6_addr secret;
diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
index d4178dace0bf..549ddeaf788b 100644
--- a/include/uapi/linux/ipv6.h
+++ b/include/uapi/linux/ipv6.h
@@ -194,6 +194,7 @@ enum {
 	DEVCONF_IOAM6_ID,
 	DEVCONF_IOAM6_ID_WIDE,
 	DEVCONF_NDISC_EVICT_NOCARRIER,
+	DEVCONF_ACCEPT_UNSOLICITED_NA,
 	DEVCONF_MAX
 };
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1afc4c024981..6473dc84b71d 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5587,6 +5587,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_IOAM6_ID] = cnf->ioam6_id;
 	array[DEVCONF_IOAM6_ID_WIDE] = cnf->ioam6_id_wide;
 	array[DEVCONF_NDISC_EVICT_NOCARRIER] = cnf->ndisc_evict_nocarrier;
+	array[DEVCONF_ACCEPT_UNSOLICITED_NA] = cnf->accept_unsolicited_na;
 }
 
 static inline size_t inet6_ifla6_size(void)
@@ -7037,6 +7038,15 @@ static const struct ctl_table addrconf_sysctl[] = {
 		.extra1		= (void *)SYSCTL_ZERO,
 		.extra2		= (void *)SYSCTL_ONE,
 	},
+	{
+		.procname	= "accept_unsolicited_na",
+		.data		= &ipv6_devconf.accept_unsolicited_na,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+		.extra1		= (void *)SYSCTL_ZERO,
+		.extra2		= (void *)SYSCTL_ONE,
+	},
 	{
 		/* sentinel */
 	}
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index fcb288b0ae13..254addad0dd3 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -979,6 +979,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	struct inet6_ifaddr *ifp;
 	struct neighbour *neigh;
+	bool create_neigh;
 
 	if (skb->len < sizeof(struct nd_msg)) {
 		ND_PRINTK(2, warn, "NA: packet too short\n");
@@ -999,6 +1000,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 	/* For some 802.11 wireless deployments (and possibly other networks),
 	 * there will be a NA proxy and unsolicitd packets are attacks
 	 * and thus should not be accepted.
+	 * drop_unsolicited_na takes precedence over accept_unsolicited_na
 	 */
 	if (!msg->icmph.icmp6_solicited && idev &&
 	    idev->cnf.drop_unsolicited_na)
@@ -1039,7 +1041,23 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		in6_ifa_put(ifp);
 		return;
 	}
-	neigh = neigh_lookup(&nd_tbl, &msg->target, dev);
+	/* RFC 9131 updates original Neighbour Discovery RFC 4861.
+	 * An unsolicited NA can now create a neighbour cache entry
+	 * on routers if it has Target LL Address option.
+	 *
+	 * drop   accept  fwding                   behaviour
+	 * ----   ------  ------  ----------------------------------------------
+	 *    1        X       X  Drop NA packet and don't pass up the stack
+	 *    0        0       X  Pass NA packet up the stack, don't update NC
+	 *    0        1       0  Pass NA packet up the stack, don't update NC
+	 *    0        1       1  Pass NA packet up the stack, and add a STALE
+	 *                          NC entry
+	 * Note that we don't do a (daddr == all-routers-mcast) check.
+	 */
+	create_neigh = !msg->icmph.icmp6_solicited && lladdr &&
+		       idev && idev->cnf.forwarding &&
+		       idev->cnf.accept_unsolicited_na;
+	neigh = __neigh_lookup(&nd_tbl, &msg->target, dev, create_neigh);
 
 	if (neigh) {
 		u8 old_flags = neigh->flags;
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 3fe2515aa616..af7f6e6ff182 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -36,6 +36,7 @@ TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
 TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
 TEST_PROGS += vrf_strict_mode_test.sh
 TEST_PROGS += arp_ndisc_evict_nocarrier.sh
+TEST_PROGS += ndisc_unsolicited_na_test.sh
 TEST_PROGS_EXTENDED := in_netns.sh setup_loopback.sh setup_veth.sh
 TEST_PROGS_EXTENDED += toeplitz_client.sh toeplitz.sh
 TEST_GEN_FILES =  socket nettest
diff --git a/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh b/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
new file mode 100755
index 000000000000..f508657ee126
--- /dev/null
+++ b/tools/testing/selftests/net/ndisc_unsolicited_na_test.sh
@@ -0,0 +1,255 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# This test is for the accept_unsolicited_na feature to
+# enable RFC9131 behaviour. The following is the test-matrix.
+# drop   accept  fwding                   behaviour
+# ----   ------  ------  ----------------------------------------------
+#    1        X       X  Drop NA packet and don't pass up the stack
+#    0        0       X  Pass NA packet up the stack, don't update NC
+#    0        1       0  Pass NA packet up the stack, don't update NC
+#    0        1       1  Pass NA packet up the stack, and add a STALE
+#                           NC entry
+
+ret=0
+# Kselftest framework requirement - SKIP code is 4.
+ksft_skip=4
+
+PAUSE_ON_FAIL=no
+PAUSE=no
+
+HOST_NS="ns-host"
+ROUTER_NS="ns-router"
+
+HOST_INTF="veth-host"
+ROUTER_INTF="veth-router"
+
+ROUTER_ADDR="2000:20::1"
+HOST_ADDR="2000:20::2"
+SUBNET_WIDTH=64
+ROUTER_ADDR_WITH_MASK="${ROUTER_ADDR}/${SUBNET_WIDTH}"
+HOST_ADDR_WITH_MASK="${HOST_ADDR}/${SUBNET_WIDTH}"
+
+IP_HOST="ip -6 -netns ${HOST_NS}"
+IP_HOST_EXEC="ip netns exec ${HOST_NS}"
+IP_ROUTER="ip -6 -netns ${ROUTER_NS}"
+IP_ROUTER_EXEC="ip netns exec ${ROUTER_NS}"
+
+tcpdump_stdout=
+tcpdump_stderr=
+
+log_test()
+{
+	local rc=$1
+	local expected=$2
+	local msg="$3"
+
+	if [ ${rc} -eq ${expected} ]; then
+		printf "    TEST: %-60s  [ OK ]\n" "${msg}"
+		nsuccess=$((nsuccess+1))
+	else
+		ret=1
+		nfail=$((nfail+1))
+		printf "    TEST: %-60s  [FAIL]\n" "${msg}"
+		if [ "${PAUSE_ON_FAIL}" = "yes" ]; then
+		echo
+			echo "hit enter to continue, 'q' to quit"
+			read a
+			[ "$a" = "q" ] && exit 1
+		fi
+	fi
+
+	if [ "${PAUSE}" = "yes" ]; then
+		echo
+		echo "hit enter to continue, 'q' to quit"
+		read a
+		[ "$a" = "q" ] && exit 1
+	fi
+}
+
+setup()
+{
+	set -e
+
+	local drop_unsolicited_na=$1
+	local accept_unsolicited_na=$2
+	local forwarding=$3
+
+	# Setup two namespaces and a veth tunnel across them.
+	# On end of the tunnel is a router and the other end is a host.
+	ip netns add ${HOST_NS}
+	ip netns add ${ROUTER_NS}
+	${IP_ROUTER} link add ${ROUTER_INTF} type veth \
+                peer name ${HOST_INTF} netns ${HOST_NS}
+
+	# Enable IPv6 on both router and host, and configure static addresses.
+	# The router here is the DUT
+	# Setup router configuration as specified by the arguments.
+	# forwarding=0 case is to check that a non-router
+	# doesn't add neighbour entries.
+        ROUTER_CONF=net.ipv6.conf.${ROUTER_INTF}
+	${IP_ROUTER_EXEC} sysctl -qw \
+                ${ROUTER_CONF}.forwarding=${forwarding}
+	${IP_ROUTER_EXEC} sysctl -qw \
+                ${ROUTER_CONF}.drop_unsolicited_na=${drop_unsolicited_na}
+	${IP_ROUTER_EXEC} sysctl -qw \
+                ${ROUTER_CONF}.accept_unsolicited_na=${accept_unsolicited_na}
+	${IP_ROUTER_EXEC} sysctl -qw ${ROUTER_CONF}.disable_ipv6=0
+	${IP_ROUTER} addr add ${ROUTER_ADDR_WITH_MASK} dev ${ROUTER_INTF}
+
+	# Turn on ndisc_notify on host interface so that
+	# the host sends unsolicited NAs.
+	HOST_CONF=net.ipv6.conf.${HOST_INTF}
+	${IP_HOST_EXEC} sysctl -qw ${HOST_CONF}.ndisc_notify=1
+	${IP_HOST_EXEC} sysctl -qw ${HOST_CONF}.disable_ipv6=0
+	${IP_HOST} addr add ${HOST_ADDR_WITH_MASK} dev ${HOST_INTF}
+
+	set +e
+}
+
+start_tcpdump() {
+	set -e
+	tcpdump_stdout=`mktemp`
+	tcpdump_stderr=`mktemp`
+	${IP_ROUTER_EXEC} timeout 15s \
+                tcpdump --immediate-mode -tpni ${ROUTER_INTF} -c 1 \
+                "icmp6 && icmp6[0] == 136 && src ${HOST_ADDR}" \
+                > ${tcpdump_stdout} 2> /dev/null
+	set +e
+}
+
+cleanup_tcpdump()
+{
+	set -e
+	[[ ! -z  ${tcpdump_stdout} ]] && rm -f ${tcpdump_stdout}
+	[[ ! -z  ${tcpdump_stderr} ]] && rm -f ${tcpdump_stderr}
+	tcpdump_stdout=
+	tcpdump_stderr=
+	set +e
+}
+
+cleanup()
+{
+	cleanup_tcpdump
+	ip netns del ${HOST_NS}
+	ip netns del ${ROUTER_NS}
+}
+
+link_up() {
+	set -e
+	${IP_ROUTER} link set dev ${ROUTER_INTF} up
+	${IP_HOST} link set dev ${HOST_INTF} up
+	set +e
+}
+
+verify_ndisc() {
+	local drop_unsolicited_na=$1
+	local accept_unsolicited_na=$2
+	local forwarding=$3
+
+	neigh_show_output=$(${IP_ROUTER} neigh show \
+                to ${HOST_ADDR} dev ${ROUTER_INTF} nud stale)
+	if [ ${drop_unsolicited_na} -eq 0 ] && \
+			[ ${accept_unsolicited_na} -eq 1 ] && \
+			[ ${forwarding} -eq 1 ]; then
+		# Neighbour entry expected to be present for 011 case
+		[[ ${neigh_show_output} ]]
+	else
+		# Neighbour entry expected to be absent for all other cases
+		[[ -z ${neigh_show_output} ]]
+	fi
+}
+
+test_unsolicited_na_common()
+{
+	# Setup the test bed, but keep links down
+	setup $1 $2 $3
+
+	# Bring the link up, wait for the NA,
+	# and add a delay to ensure neighbour processing is done.
+	link_up
+	start_tcpdump
+
+	# Verify the neighbour table
+	verify_ndisc $1 $2 $3
+
+}
+
+test_unsolicited_na_combination() {
+	test_unsolicited_na_common $1 $2 $3
+	test_msg=("test_unsolicited_na: "
+		"drop_unsolicited_na=$1 "
+		"accept_unsolicited_na=$2 "
+		"forwarding=$3")
+	log_test $? 0 "${test_msg[*]}"
+	cleanup
+}
+
+test_unsolicited_na_combinations() {
+	# Args: drop_unsolicited_na accept_unsolicited_na forwarding
+
+	# Expect entry
+	test_unsolicited_na_combination 0 1 1
+
+	# Expect no entry
+	test_unsolicited_na_combination 0 0 0
+	test_unsolicited_na_combination 0 0 1
+	test_unsolicited_na_combination 0 1 0
+	test_unsolicited_na_combination 1 0 0
+	test_unsolicited_na_combination 1 0 1
+	test_unsolicited_na_combination 1 1 0
+	test_unsolicited_na_combination 1 1 1
+}
+
+###############################################################################
+# usage
+
+usage()
+{
+	cat <<EOF
+usage: ${0##*/} OPTS
+        -p          Pause on fail
+        -P          Pause after each test before cleanup
+EOF
+}
+
+###############################################################################
+# main
+
+while getopts :pPh o
+do
+	case $o in
+		p) PAUSE_ON_FAIL=yes;;
+		P) PAUSE=yes;;
+		h) usage; exit 0;;
+		*) usage; exit 1;;
+	esac
+done
+
+# make sure we don't pause twice
+[ "${PAUSE}" = "yes" ] && PAUSE_ON_FAIL=no
+
+if [ "$(id -u)" -ne 0 ];then
+	echo "SKIP: Need root privileges"
+	exit $ksft_skip;
+fi
+
+if [ ! -x "$(command -v ip)" ]; then
+	echo "SKIP: Could not run test without ip tool"
+	exit $ksft_skip
+fi
+
+if [ ! -x "$(command -v tcpdump)" ]; then
+	echo "SKIP: Could not run test without tcpdump tool"
+	exit $ksft_skip
+fi
+
+# start clean
+cleanup &> /dev/null
+
+test_unsolicited_na_combinations
+
+printf "\nTests passed: %3d\n" ${nsuccess}
+printf "Tests failed: %3d\n"   ${nfail}
+
+exit $ret
-- 
2.27.0
---
Changes from v5:
Fixed simple table syntax in ip-sysctl.rst to include the missing tab.
Ran "make htmldocs SPHINXDIRS=networking" and verified the generated ip-sysctl.html to ensure that the table is rendered correctly.

