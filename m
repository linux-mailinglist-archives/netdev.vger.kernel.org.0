Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41AED322F25
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 17:55:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbhBWQz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 11:55:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:49578 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232252AbhBWQzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 11:55:18 -0500
IronPort-SDR: gMEPrr0Jc13jW2O6vJKpbKVHbOfB7WVgAEV3z2boP9AkZpDM6GEdy8NGLG+IDLctABRSj3Pb0x
 V216Wf8R4bBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9904"; a="181435261"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="181435261"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 08:54:35 -0800
IronPort-SDR: RVbQlsE/TZf7SbrSgvOqD91j/aqCBQtYYFZ7QywyHvxzuSkoad906rXlPAVl8a0FonnhdIT/CH
 gJpcUoiokVcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="441792263"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga001.jf.intel.com with ESMTP; 23 Feb 2021 08:53:55 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        weqaar.a.janjua@intel.com, maciej.fijalkowski@intel.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH bpf-next v3 1/4] selftest/bpf: make xsk tests less verbose
Date:   Tue, 23 Feb 2021 16:23:01 +0000
Message-Id: <20210223162304.7450-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210223162304.7450-1-ciara.loftus@intel.com>
References: <20210223162304.7450-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Make the xsk tests less verbose by only printing the
essentials. Currently, it is hard to see if the tests passed or not
due to all the printouts. Move the extra printouts to a verbose
option, if further debugging is needed when a problem arises.

To run the xsk tests with verbose output:
./test_xsk.sh -v

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/test_xsk.sh    | 27 ++++++++++++++-----
 tools/testing/selftests/bpf/xdpxceiver.c   | 31 +++++++++++++---------
 tools/testing/selftests/bpf/xdpxceiver.h   | 13 +++++----
 tools/testing/selftests/bpf/xsk_prereqs.sh |  9 +++----
 4 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_xsk.sh b/tools/testing/selftests/bpf/test_xsk.sh
index 88a7483eaae4..f4cedf4c2718 100755
--- a/tools/testing/selftests/bpf/test_xsk.sh
+++ b/tools/testing/selftests/bpf/test_xsk.sh
@@ -71,13 +71,17 @@
 #
 # Run (full output without color-coding):
 #   sudo ./test_xsk.sh
+#
+# Run with verbose output:
+#   sudo ./test_xsk.sh -v
 
 . xsk_prereqs.sh
 
-while getopts c flag
+while getopts "cv" flag
 do
 	case "${flag}" in
 		c) colorconsole=1;;
+		v) verbose=1;;
 	esac
 done
 
@@ -95,13 +99,17 @@ NS1=af_xdp${VETH1_POSTFIX}
 MTU=1500
 
 setup_vethPairs() {
-	echo "setting up ${VETH0}: namespace: ${NS0}"
+	if [[ $verbose -eq 1 ]]; then
+	        echo "setting up ${VETH0}: namespace: ${NS0}"
+	fi
 	ip netns add ${NS1}
 	ip link add ${VETH0} type veth peer name ${VETH1}
 	if [ -f /proc/net/if_inet6 ]; then
 		echo 1 > /proc/sys/net/ipv6/conf/${VETH0}/disable_ipv6
 	fi
-	echo "setting up ${VETH1}: namespace: ${NS1}"
+	if [[ $verbose -eq 1 ]]; then
+	        echo "setting up ${VETH1}: namespace: ${NS1}"
+	fi
 	ip link set ${VETH1} netns ${NS1}
 	ip netns exec ${NS1} ip link set ${VETH1} mtu ${MTU}
 	ip link set ${VETH0} mtu ${MTU}
@@ -125,7 +133,10 @@ echo "${VETH0}:${VETH1},${NS1}" > ${SPECFILE}
 
 validate_veth_spec_file
 
-echo "Spec file created: ${SPECFILE}"
+if [[ $verbose -eq 1 ]]; then
+        echo "Spec file created: ${SPECFILE}"
+	VERBOSE_ARG="-v"
+fi
 
 test_status $retval "${TEST_NAME}"
 
@@ -136,12 +147,16 @@ statusList=()
 ### TEST 1
 TEST_NAME="XSK KSELFTEST FRAMEWORK"
 
-echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Generic mode"
+if [[ $verbose -eq 1 ]]; then
+        echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Generic mode"
+fi
 vethXDPgeneric ${VETH0} ${VETH1} ${NS1}
 
 retval=$?
 if [ $retval -eq 0 ]; then
-	echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Native mode"
+        if [[ $verbose -eq 1 ]]; then
+	        echo "Switching interfaces [${VETH0}, ${VETH1}] to XDP Native mode"
+	fi
 	vethXDPnative ${VETH0} ${VETH1} ${NS1}
 fi
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index f4a96d5ff524..8af746c9a6b6 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -341,6 +341,7 @@ static struct option long_options[] = {
 	{"tear-down", no_argument, 0, 'T'},
 	{"bidi", optional_argument, 0, 'B'},
 	{"debug", optional_argument, 0, 'D'},
+	{"verbose", no_argument, 0, 'v'},
 	{"tx-pkt-count", optional_argument, 0, 'C'},
 	{0, 0, 0, 0}
 };
@@ -359,6 +360,7 @@ static void usage(const char *prog)
 	    "  -T, --tear-down      Tear down sockets by repeatedly recreating them\n"
 	    "  -B, --bidi           Bi-directional sockets test\n"
 	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
+	    "  -v, --verbose        Verbose output\n"
 	    "  -C, --tx-pkt-count=n Number of packets to send\n";
 	ksft_print_msg(str, prog);
 }
@@ -392,7 +394,7 @@ static void *nsswitchthread(void *args)
 			ksft_test_result_fail("ERROR: [%s] interface \"%s\" does not exist\n",
 					      __func__, ifdict[targs->idx]->ifname);
 		} else {
-			ksft_print_msg("Interface found: %s\n", ifdict[targs->idx]->ifname);
+			print_verbose("Interface found: %s\n", ifdict[targs->idx]->ifname);
 			targs->retptr = true;
 		}
 	}
@@ -422,7 +424,7 @@ static int validate_interfaces(void)
 			pthread_join(ns_thread, NULL);
 
 			if (targs->retptr)
-				ksft_print_msg("NS switched: %s\n", ifdict[i]->nsname);
+				print_verbose("NS switched: %s\n", ifdict[i]->nsname);
 
 			free(targs);
 		} else {
@@ -432,7 +434,7 @@ static int validate_interfaces(void)
 				    ("ERROR: interface \"%s\" does not exist\n", ifdict[i]->ifname);
 				ret = false;
 			} else {
-				ksft_print_msg("Interface found: %s\n", ifdict[i]->ifname);
+				print_verbose("Interface found: %s\n", ifdict[i]->ifname);
 			}
 		}
 	}
@@ -446,7 +448,7 @@ static void parse_command_line(int argc, char **argv)
 	opterr = 0;
 
 	for (;;) {
-		c = getopt_long(argc, argv, "i:q:pSNcTBDC:", long_options, &option_index);
+		c = getopt_long(argc, argv, "i:q:pSNcTBDC:v", long_options, &option_index);
 
 		if (c == -1)
 			break;
@@ -497,6 +499,9 @@ static void parse_command_line(int argc, char **argv)
 		case 'C':
 			opt_pkt_count = atoi(optarg);
 			break;
+		case 'v':
+			opt_verbose = 1;
+			break;
 		default:
 			usage(basename(argv[0]));
 			ksft_exit_xfail();
@@ -714,7 +719,7 @@ static void worker_pkt_dump(void)
 		int payload = *((uint32_t *)(pkt_buf[iter]->payload + PKT_HDR_SIZE));
 
 		if (payload == EOT) {
-			ksft_print_msg("End-of-transmission frame received\n");
+			print_verbose("End-of-transmission frame received\n");
 			fprintf(stdout, "---------------------------------------\n");
 			break;
 		}
@@ -746,7 +751,7 @@ static void worker_pkt_validate(void)
 			}
 
 			if (payloadseqnum == EOT) {
-				ksft_print_msg("End-of-transmission frame received: PASS\n");
+				print_verbose("End-of-transmission frame received: PASS\n");
 				sigvar = 1;
 				break;
 			}
@@ -836,7 +841,7 @@ static void *worker_testapp_validate(void *arg)
 			usleep(USLEEP_MAX);
 		}
 
-		ksft_print_msg("Interface [%s] vector [Tx]\n", ifobject->ifname);
+		print_verbose("Interface [%s] vector [Tx]\n", ifobject->ifname);
 		for (int i = 0; i < num_frames; i++) {
 			/*send EOT frame */
 			if (i == (num_frames - 1))
@@ -850,7 +855,7 @@ static void *worker_testapp_validate(void *arg)
 			gen_eth_frame(ifobject->umem, i * XSK_UMEM__DEFAULT_FRAME_SIZE);
 		}
 
-		ksft_print_msg("Sending %d packets on interface %s\n",
+		print_verbose("Sending %d packets on interface %s\n",
 			       (opt_pkt_count - 1), ifobject->ifname);
 		tx_only_all(ifobject);
 	} else if (ifobject->fv.vector == rx) {
@@ -860,7 +865,7 @@ static void *worker_testapp_validate(void *arg)
 		if (!bidi_pass)
 			thread_common_ops(ifobject, bufs, &sync_mutex_tx, &spinning_rx);
 
-		ksft_print_msg("Interface [%s] vector [Rx]\n", ifobject->ifname);
+		print_verbose("Interface [%s] vector [Rx]\n", ifobject->ifname);
 		xsk_populate_fill_ring(ifobject->umem);
 
 		TAILQ_INIT(&head);
@@ -890,11 +895,11 @@ static void *worker_testapp_validate(void *arg)
 				break;
 		}
 
-		ksft_print_msg("Received %d packets on interface %s\n",
+		print_verbose("Received %d packets on interface %s\n",
 			       pkt_counter, ifobject->ifname);
 
 		if (opt_teardown)
-			ksft_print_msg("Destroying socket\n");
+			print_verbose("Destroying socket\n");
 	}
 
 	if (!opt_bidi || bidi_pass) {
@@ -914,7 +919,7 @@ static void testapp_validate(void)
 	if (opt_bidi && bidi_pass) {
 		pthread_init_mutex();
 		if (!switching_notify) {
-			ksft_print_msg("Switching Tx/Rx vectors\n");
+			print_verbose("Switching Tx/Rx vectors\n");
 			switching_notify++;
 		}
 	}
@@ -974,7 +979,7 @@ static void testapp_sockets(void)
 		pkt_counter = 0;
 		prev_pkt = -1;
 		sigvar = 0;
-		ksft_print_msg("Creating socket\n");
+		print_verbose("Creating socket\n");
 		testapp_validate();
 		opt_bidi ? bidi_pass++ : bidi_pass;
 	}
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 0e9f9b7e61c2..f66f399dfb2d 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -42,6 +42,8 @@
 #define POLL_TMOUT 1000
 #define NEED_WAKEUP true
 
+#define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
+
 typedef __u32 u32;
 typedef __u16 u16;
 typedef __u8 u8;
@@ -51,11 +53,11 @@ enum TESTS {
 	ORDER_CONTENT_VALIDATE_XDP_DRV = 1,
 };
 
-u8 uut;
-u8 debug_pkt_dump;
-u32 num_frames;
-u8 switching_notify;
-u8 bidi_pass;
+static u8 uut;
+static u8 debug_pkt_dump;
+static u32 num_frames;
+static u8 switching_notify;
+static u8 bidi_pass;
 
 static u32 opt_xdp_flags = XDP_FLAGS_UPDATE_IF_NOEXIST;
 static int opt_queue;
@@ -64,6 +66,7 @@ static int opt_poll;
 static int opt_teardown;
 static int opt_bidi;
 static u32 opt_xdp_bind_flags = XDP_USE_NEED_WAKEUP;
+static u8 opt_verbose;
 static u8 pkt_data[XSK_UMEM__DEFAULT_FRAME_SIZE];
 static u32 pkt_counter;
 static u32 prev_pkt = -1;
diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh b/tools/testing/selftests/bpf/xsk_prereqs.sh
index 9d54c4645127..ef8c5b31f4b6 100755
--- a/tools/testing/selftests/bpf/xsk_prereqs.sh
+++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
@@ -82,24 +82,21 @@ clear_configs()
 {
 	if [ $(ip netns show | grep $3 &>/dev/null; echo $?;) == 0 ]; then
 		[ $(ip netns exec $3 ip link show $2 &>/dev/null; echo $?;) == 0 ] &&
-			{ echo "removing link $1:$2"; ip netns exec $3 ip link del $2; }
-		echo "removing ns $3"
+			{ ip netns exec $3 ip link del $2; }
 		ip netns del $3
 	fi
 	#Once we delete a veth pair node, the entire veth pair is removed,
 	#this is just to be cautious just incase the NS does not exist then
 	#veth node inside NS won't get removed so we explicitly remove it
 	[ $(ip link show $1 &>/dev/null; echo $?;) == 0 ] &&
-		{ echo "removing link $1"; ip link del $1; }
+		{ ip link del $1; }
 	if [ -f ${SPECFILE} ]; then
-		echo "removing spec file:" ${SPECFILE}
 		rm -f ${SPECFILE}
 	fi
 }
 
 cleanup_exit()
 {
-	echo "cleaning up..."
 	clear_configs $1 $2 $3
 }
 
@@ -131,5 +128,5 @@ execxdpxceiver()
 			copy[$index]=${!current}
 		done
 
-	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS}
+	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C ${NUMPKTS} ${VERBOSE_ARG}
 }
-- 
2.17.1

