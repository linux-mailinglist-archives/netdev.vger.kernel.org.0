Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A66A345183
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 22:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhCVVKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 17:10:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:4966 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhCVVJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 17:09:16 -0400
IronPort-SDR: fHlgNqIf96+U/Uam7/nMS51Jc8rVOaVKlcu4LlK/UGIVYPf74mlQfkQjmzmvGSbSA5R3tf+vda
 4B9E2NEoL+aA==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="210423734"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="210423734"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 14:09:16 -0700
IronPort-SDR: RrCioYKYDavtEhFbquPXzgF2LXLJu+KQeG8ByWOJcNxI3sxUehOM2gj+5jT4WWbzNrKj5lY9R1
 1bkwDWBBU1rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="513448828"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga001.fm.intel.com with ESMTP; 22 Mar 2021 14:09:14 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v3 bpf-next 08/17] selftests: xsk: remove thread for netns switch
Date:   Mon, 22 Mar 2021 21:58:07 +0100
Message-Id: <20210322205816.65159-9-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
References: <20210322205816.65159-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there is a dedicated thread for following remote ns operations:
- grabbing the ifindex of the interface moved to remote netns
- removing xdp prog from that interface

With bpf_link usage in place, this can be simply omitted, so remove
mentioned thread, as BPF resources will be managed by bpf_link itself,
so there's no further need for creating the thread that will switch to
remote netns and do the cleanup.

Keep most of the logic for switching the ns, though, but make
switch_namespace() return the fd so that it will be possible to close it
at the process termination time. Get rid of logic around making sure
that it's possible to switch ns in validate_interfaces().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 123 +++--------------------
 tools/testing/selftests/bpf/xdpxceiver.h |  10 +-
 2 files changed, 14 insertions(+), 119 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index cf30c7943ac0..2e5f536563e4 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -355,12 +355,15 @@ static void usage(const char *prog)
 	ksft_print_msg(str, prog);
 }
 
-static bool switch_namespace(int idx)
+static int switch_namespace(const char *nsname)
 {
 	char fqns[26] = "/var/run/netns/";
 	int nsfd;
 
-	strncat(fqns, ifdict[idx]->nsname, sizeof(fqns) - strlen(fqns) - 1);
+	if (!nsname || strlen(nsname) == 0)
+		return -1;
+
+	strncat(fqns, nsname, sizeof(fqns) - strlen(fqns) - 1);
 	nsfd = open(fqns, O_RDONLY);
 
 	if (nsfd == -1)
@@ -369,26 +372,9 @@ static bool switch_namespace(int idx)
 	if (setns(nsfd, 0) == -1)
 		exit_with_error(errno);
 
-	return true;
-}
-
-static void *nsswitchthread(void *args)
-{
-	struct targs *targs = args;
+	print_verbose("NS switched: %s\n", nsname);
 
-	targs->retptr = false;
-
-	if (switch_namespace(targs->idx)) {
-		ifdict[targs->idx]->ifindex = if_nametoindex(ifdict[targs->idx]->ifname);
-		if (!ifdict[targs->idx]->ifindex) {
-			ksft_test_result_fail("ERROR: [%s] interface \"%s\" does not exist\n",
-					      __func__, ifdict[targs->idx]->ifname);
-		} else {
-			print_verbose("Interface found: %s\n", ifdict[targs->idx]->ifname);
-			targs->retptr = true;
-		}
-	}
-	pthread_exit(NULL);
+	return nsfd;
 }
 
 static int validate_interfaces(void)
@@ -400,33 +386,6 @@ static int validate_interfaces(void)
 			ret = false;
 			ksft_test_result_fail("ERROR: interfaces: -i <int>,<ns> -i <int>,<ns>.");
 		}
-		if (strcmp(ifdict[i]->nsname, "")) {
-			struct targs *targs;
-
-			targs = malloc(sizeof(*targs));
-			if (!targs)
-				exit_with_error(errno);
-
-			targs->idx = i;
-			if (pthread_create(&ns_thread, NULL, nsswitchthread, targs))
-				exit_with_error(errno);
-
-			pthread_join(ns_thread, NULL);
-
-			if (targs->retptr)
-				print_verbose("NS switched: %s\n", ifdict[i]->nsname);
-
-			free(targs);
-		} else {
-			ifdict[i]->ifindex = if_nametoindex(ifdict[i]->ifname);
-			if (!ifdict[i]->ifindex) {
-				ksft_test_result_fail
-				    ("ERROR: interface \"%s\" does not exist\n", ifdict[i]->ifname);
-				ret = false;
-			} else {
-				print_verbose("Interface found: %s\n", ifdict[i]->ifname);
-			}
-		}
 	}
 	return ret;
 }
@@ -843,8 +802,7 @@ static void *worker_testapp_validate(void *arg)
 		if (bufs == MAP_FAILED)
 			exit_with_error(errno);
 
-		if (strcmp(ifobject->nsname, ""))
-			switch_namespace(ifobject->ifdict_index);
+		ifobject->ns_fd = switch_namespace(ifobject->nsname);
 	}
 
 	if (ifobject->fv.vector == tx) {
@@ -1059,60 +1017,6 @@ static void init_iface(struct ifobject *ifobj, const char *dst_mac,
 	ifobj->src_port = src_port;
 }
 
-static void *nsdisablemodethread(void *args)
-{
-	struct targs *targs = args;
-
-	targs->retptr = false;
-
-	if (switch_namespace(targs->idx)) {
-		targs->retptr = bpf_set_link_xdp_fd(ifdict[targs->idx]->ifindex, -1, targs->flags);
-	} else {
-		targs->retptr = errno;
-		print_verbose("Failed to switch namespace to %s\n", ifdict[targs->idx]->nsname);
-	}
-
-	pthread_exit(NULL);
-}
-
-static void disable_xdp_mode(int mode)
-{
-	int err = 0;
-	__u32 flags = XDP_FLAGS_UPDATE_IF_NOEXIST | mode;
-	char *mode_str = mode & XDP_FLAGS_SKB_MODE ? "skb" : "drv";
-
-	for (int i = 0; i < MAX_INTERFACES; i++) {
-		if (strcmp(ifdict[i]->nsname, "")) {
-			struct targs *targs;
-
-			targs = malloc(sizeof(*targs));
-			memset(targs, 0, sizeof(*targs));
-			if (!targs)
-				exit_with_error(errno);
-
-			targs->idx = i;
-			targs->flags = flags;
-			if (pthread_create(&ns_thread, NULL, nsdisablemodethread, targs))
-				exit_with_error(errno);
-
-			pthread_join(ns_thread, NULL);
-			err = targs->retptr;
-			free(targs);
-		} else {
-			err = bpf_set_link_xdp_fd(ifdict[i]->ifindex, -1, flags);
-		}
-
-		if (err) {
-			print_verbose("Failed to disable %s mode on interface %s\n",
-						mode_str, ifdict[i]->ifname);
-			exit_with_error(err);
-		}
-
-		print_verbose("Disabled %s mode for interface: %s\n", mode_str, ifdict[i]->ifname);
-		configured_mode = mode & XDP_FLAGS_SKB_MODE ? TEST_MODE_DRV : TEST_MODE_SKB;
-	}
-}
-
 static void run_pkt_test(int mode, int type)
 {
 	test_type = type;
@@ -1132,13 +1036,9 @@ static void run_pkt_test(int mode, int type)
 
 	switch (mode) {
 	case (TEST_MODE_SKB):
-		if (configured_mode == TEST_MODE_DRV)
-			disable_xdp_mode(XDP_FLAGS_DRV_MODE);
 		xdp_flags |= XDP_FLAGS_SKB_MODE;
 		break;
 	case (TEST_MODE_DRV):
-		if (configured_mode == TEST_MODE_SKB)
-			disable_xdp_mode(XDP_FLAGS_SKB_MODE);
 		xdp_flags |= XDP_FLAGS_DRV_MODE;
 		break;
 	default:
@@ -1185,8 +1085,6 @@ int main(int argc, char **argv)
 	ifdict[1]->fv.vector = rx;
 	init_iface(ifdict[1], MAC2, MAC1, IP2, IP1, UDP_PORT2, UDP_PORT1);
 
-	disable_xdp_mode(XDP_FLAGS_DRV_MODE);
-
 	ksft_set_plan(TEST_MODE_MAX * TEST_TYPE_MAX);
 
 	for (i = 0; i < TEST_MODE_MAX; i++) {
@@ -1194,8 +1092,11 @@ int main(int argc, char **argv)
 			run_pkt_test(i, j);
 	}
 
-	for (int i = 0; i < MAX_INTERFACES; i++)
+	for (int i = 0; i < MAX_INTERFACES; i++) {
+		if (ifdict[i]->ns_fd != -1)
+			close(ifdict[i]->ns_fd);
 		free(ifdict[i]);
+	}
 
 	ksft_exit_pass();
 
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 8f9308099318..493f7498d40e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -126,7 +126,7 @@ struct generic_data {
 };
 
 struct ifobject {
-	int ifindex;
+	int ns_fd;
 	int ifdict_index;
 	char ifname[MAX_INTERFACE_NAME_CHARS];
 	char nsname[MAX_INTERFACES_NAMESPACE_CHARS];
@@ -150,15 +150,9 @@ pthread_mutex_t sync_mutex;
 pthread_mutex_t sync_mutex_tx;
 pthread_cond_t signal_rx_condition;
 pthread_cond_t signal_tx_condition;
-pthread_t t0, t1, ns_thread;
+pthread_t t0, t1;
 pthread_attr_t attr;
 
-struct targs {
-	u8 retptr;
-	int idx;
-	u32 flags;
-};
-
 TAILQ_HEAD(head_s, pkt) head = TAILQ_HEAD_INITIALIZER(head);
 struct head_s *head_p;
 struct pkt {
-- 
2.20.1

