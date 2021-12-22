Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA06047D4BB
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237469AbhLVP7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:59:01 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:39883 "EHLO
        relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344065AbhLVP62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:28 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay4-d.mail.gandi.net (Postfix) with ESMTPSA id 22DF6E001A;
        Wed, 22 Dec 2021 15:58:24 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-tools 6/7] iwpan: Add full scan support
Date:   Wed, 22 Dec 2021 16:58:15 +0100
Message-Id: <20211222155816.256405-7-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155816.256405-1-miquel.raynal@bootlin.com>
References: <20211222155816.256405-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

Bring support for different scanning operations, such as starting or
aborting a scan operation with a given configuration, dumping the list
of discovered PANs, and flushing the list.

It also brings support for a couple of semi-debug features, such as a
manual beacon request to ask sending or stopping beacons out of a
particular interface. This is particularly useful when trying to
validate the scanning support without proper hardware.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 DEST/usr/local/bin/iwpan      | Bin 0 -> 178448 bytes
 DEST/usr/local/bin/wpan-hwsim | Bin 0 -> 45056 bytes
 DEST/usr/local/bin/wpan-ping  | Bin 0 -> 47840 bytes
 src/Makefile.am               |   1 +
 src/scan.c                    | 471 ++++++++++++++++++++++++++++++++++
 5 files changed, 472 insertions(+)
 create mode 100755 DEST/usr/local/bin/iwpan
 create mode 100755 DEST/usr/local/bin/wpan-hwsim
 create mode 100755 DEST/usr/local/bin/wpan-ping
 create mode 100644 src/scan.c

diff --git a/DEST/usr/local/bin/iwpan b/DEST/usr/local/bin/iwpan
new file mode 100755
index 0000000000000000000000000000000000000000..7d88e09c06b14551274b268d26c60f8eded90849
GIT binary patch
literal 178448
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

literal 0
HcmV?d00001

diff --git a/DEST/usr/local/bin/wpan-hwsim b/DEST/usr/local/bin/wpan-hwsim
new file mode 100755
index 0000000000000000000000000000000000000000..69618b04577a62d89f17f19c30a1a0b5fa8cc101
GIT binary patch
literal 45056
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
Pzvgzyzb=9y0@VHw0_(6h

literal 0
HcmV?d00001

diff --git a/DEST/usr/local/bin/wpan-ping b/DEST/usr/local/bin/wpan-ping
new file mode 100755
index 0000000000000000000000000000000000000000..8b14ce20a717c7f56ea1d55063211758f85e2e5b
GIT binary patch
literal 47840
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
E4^R&)TL1t6

literal 0
HcmV?d00001

diff --git a/src/Makefile.am b/src/Makefile.am
index 2d54576..18b3569 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -9,6 +9,7 @@ iwpan_SOURCES = \
 	interface.c \
 	phy.c \
 	mac.c \
+	scan.c \
 	nl_extras.h \
 	nl802154.h
 
diff --git a/src/scan.c b/src/scan.c
new file mode 100644
index 0000000..ec91c7c
--- /dev/null
+++ b/src/scan.c
@@ -0,0 +1,471 @@
+#include <net/if.h>
+#include <errno.h>
+#include <string.h>
+#include <stdbool.h>
+#include <inttypes.h>
+
+#include <netlink/genl/genl.h>
+#include <netlink/genl/family.h>
+#include <netlink/genl/ctrl.h>
+#include <netlink/msg.h>
+#include <netlink/attr.h>
+
+#include "nl802154.h"
+#include "nl_extras.h"
+#include "iwpan.h"
+
+static char scantypebuf[100];
+
+static const char *scantype_name(enum nl802154_scan_types scantype)
+{
+	switch (scantype) {
+	case NL802154_SCAN_ED:
+		return "ed";
+	case NL802154_SCAN_ACTIVE:
+		return "active";
+	case NL802154_SCAN_PASSIVE:
+		return "passive";
+	case NL802154_SCAN_ENHANCED_ACTIVE:
+		return "enhanced";
+	case NL802154_SCAN_RIT_PASSIVE:
+		return "rit";
+	default:
+		sprintf(scantypebuf, "Invalid scantype (%d)", scantype);
+		return scantypebuf;
+	}
+}
+
+/* for help */
+#define SCAN_TYPES "Valid scanning types are: ed, active, passive, enhanced, rit."
+
+/* return 0 if ok, internal error otherwise */
+static int get_scan_type(int *argc, char ***argv, enum nl802154_scan_types *type)
+{
+	char *tpstr;
+
+	if (*argc < 2)
+		return 1;
+
+	if (strcmp((*argv)[0], "type"))
+		return 1;
+
+	tpstr = (*argv)[1];
+	*argc -= 2;
+	*argv += 2;
+
+	if (strcmp(tpstr, "ed") == 0) {
+		*type = NL802154_SCAN_ED;
+		return 0;
+	} else if (strcmp(tpstr, "active") == 0) {
+		*type = NL802154_SCAN_ACTIVE;
+		return 0;
+	} else if (strcmp(tpstr, "passive") == 0) {
+		*type = NL802154_SCAN_PASSIVE;
+		return 0;
+	} else if (strcmp(tpstr, "enhanced") == 0) {
+		*type = NL802154_SCAN_ENHANCED_ACTIVE;
+		return 0;
+	} else if (strcmp(tpstr, "rit") == 0) {
+		*type = NL802154_SCAN_RIT_PASSIVE;
+		return 0;
+	}
+
+	fprintf(stderr, "invalid interface type %s\n", tpstr);
+	return 2;
+}
+
+static int get_option_value(int *argc, char ***argv, const char *marker, unsigned long *result, bool *valid)
+{
+	unsigned long value;
+	char *tpstr, *end;
+
+	*valid = false;
+
+	if (*argc < 2)
+		return 0;
+
+	if (strcmp((*argv)[0], marker))
+		return 0;
+
+	tpstr = (*argv)[1];
+	*argc -= 2;
+	*argv += 2;
+
+	value = strtoul(tpstr, &end, 10);
+	if (*end != '\0')
+		return 1;
+
+	*result = value;
+	*valid = true;
+
+	return 0;
+}
+
+static int scan_trigger_handler(struct nl802154_state *state,
+				struct nl_cb *cb,
+				struct nl_msg *msg,
+				int argc, char **argv,
+				enum id_input id)
+{
+	enum nl802154_scan_types type;
+	unsigned long page, channels, duration;
+	int tpset;
+	bool valid_page, valid_channels, valid_duration;
+
+	if (argc < 2)
+		return 1;
+
+	tpset = get_scan_type(&argc, &argv, &type);
+	if (tpset)
+		return tpset;
+
+	tpset = get_option_value(&argc, &argv, "page", &page, &valid_page);
+	if (tpset)
+		return tpset;
+	if (valid_page && page > UINT8_MAX)
+		return 1;
+
+	tpset = get_option_value(&argc, &argv, "channels", &channels, &valid_channels);
+	if (tpset)
+		return tpset;
+	if (valid_channels && channels > UINT32_MAX)
+		return 1;
+
+	tpset = get_option_value(&argc, &argv, "duration", &duration, &valid_duration);
+	if (tpset)
+		return tpset;
+	if (valid_duration && duration > UINT8_MAX)
+		return 1;
+
+	if (argc)
+		return 1;
+
+	/* Mandatory argument */
+	NLA_PUT_U8(msg, NL802154_ATTR_SCAN_TYPE, type);
+	/* Optional arguments */
+	if (valid_duration)
+		NLA_PUT_U8(msg, NL802154_ATTR_SCAN_DURATION, duration);
+	if (valid_page)
+		NLA_PUT_U8(msg, NL802154_ATTR_PAGE, page);
+	if (valid_channels)
+		NLA_PUT_U32(msg, NL802154_ATTR_SCAN_CHANNELS, channels);
+
+	/* TODO: support IES parameters for active scans */
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int scan_abort_handler(struct nl802154_state *state,
+			      struct nl_cb *cb,
+			      struct nl_msg *msg,
+			      int argc, char **argv,
+			      enum id_input id)
+{
+	return 0;
+}
+
+
+static int parse_scan_result_pan(struct nlattr *nestedpan, struct nlattr *ifattr)
+{
+	struct nlattr *pan[NL802154_PAN_MAX + 1];
+	static struct nla_policy pan_policy[NL802154_PAN_MAX + 1] = {
+		[NL802154_PAN_PANID] = { .type = NLA_U16, },
+		[NL802154_PAN_COORD_ADDR] = { .minlen = 2, .maxlen = 8, }, /* 2 or 8 */
+		[NL802154_PAN_CHANNEL] = { .type = NLA_U8, },
+		[NL802154_PAN_PAGE] = { .type = NLA_U8, },
+		[NL802154_PAN_SUPERFRAME_SPEC] = { .type = NLA_U16, },
+		[NL802154_PAN_LINK_QUALITY] = { .type = NLA_U8, },
+		[NL802154_PAN_GTS_PERMIT] = { .type = NLA_FLAG, },
+		[NL802154_PAN_STATUS] = { .type = NLA_U32, },
+		[NL802154_PAN_SEEN_MS_AGO] = { .type = NLA_U32, },
+	};
+	char dev[20];
+	int ret;
+
+	ret = nla_parse_nested(pan, NL802154_PAN_MAX, nestedpan, pan_policy);
+	if (ret < 0) {
+		fprintf(stderr, "failed to parse nested attributes! (ret = %d)\n",
+			ret);
+		return NL_SKIP;
+	}
+	if (!pan[NL802154_PAN_PANID])
+		return NL_SKIP;
+
+	printf("PAN 0x%04x", le16toh(nla_get_u16(pan[NL802154_PAN_PANID])));
+	if (ifattr) {
+		if_indextoname(nla_get_u32(ifattr), dev);
+		printf(" (on %s)", dev);
+	}
+	printf("\n");
+	if (pan[NL802154_PAN_COORD_ADDR]) {
+		struct nlattr *coord = pan[NL802154_PAN_COORD_ADDR];
+		if (nla_len(coord) == 2) {
+			uint16_t addr = nla_get_u16(coord);
+			printf("\tcoordinator 0x%04x\n", le16toh(addr));
+		} else {
+			uint64_t addr = nla_get_u64(coord);
+			printf("\tcoordinator 0x%016" PRIx64 "\n", le64toh(addr));
+		}
+	}
+	if (pan[NL802154_PAN_PAGE]) {
+		printf("\tpage %u\n", nla_get_u8(pan[NL802154_PAN_PAGE]));
+	}
+	if (pan[NL802154_PAN_CHANNEL]) {
+		printf("\tchannel %u\n", nla_get_u8(pan[NL802154_PAN_CHANNEL]));
+	}
+	if (pan[NL802154_PAN_SUPERFRAME_SPEC]) {
+		printf("\tsuperframe spec. 0x%x\n", nla_get_u16(
+				pan[NL802154_PAN_SUPERFRAME_SPEC]));
+	}
+	if (pan[NL802154_PAN_LINK_QUALITY]) {
+		printf("\tLQI %x\n", nla_get_u8(
+				pan[NL802154_PAN_LINK_QUALITY]));
+	}
+	if (pan[NL802154_PAN_GTS_PERMIT]) {
+		printf("\tGTS permitted\n");
+	}
+	if (pan[NL802154_PAN_STATUS]) {
+		printf("\tstatus 0x%x\n", nla_get_u32(
+				pan[NL802154_PAN_STATUS]));
+	}
+	if (pan[NL802154_PAN_SEEN_MS_AGO]) {
+		printf("\tseen %ums ago\n", nla_get_u32(
+				pan[NL802154_PAN_SEEN_MS_AGO]));
+	}
+
+	/* TODO: Beacon IES display/decoding */
+
+	return NL_OK;
+}
+
+static int print_scan_dump_handler(struct nl_msg *msg, void *arg)
+{
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct nlattr *tb[NL802154_ATTR_MAX + 1];
+	struct nlattr *nestedpan;
+
+	nla_parse(tb, NL802154_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+		  genlmsg_attrlen(gnlh, 0), NULL);
+	nestedpan = tb[NL802154_ATTR_PAN];
+	if (!nestedpan) {
+		fprintf(stderr, "pan info missing!\n");
+		return NL_SKIP;
+	}
+	return parse_scan_result_pan(nestedpan, tb[NL802154_ATTR_IFINDEX]);
+}
+
+struct scan_done
+{
+	volatile int done;
+	int devidx;
+};
+
+static int wait_scan_done_handler(struct nl_msg *msg, void *arg)
+{
+	struct genlmsghdr *gnlh = nlmsg_data(nlmsg_hdr(msg));
+	struct scan_done *sd = (struct scan_done *)arg;
+	if (gnlh->cmd != NL802154_CMD_SCAN_DONE)
+		return 0;
+	else if (sd->devidx != -1) {
+		struct nlattr *tb[NL802154_ATTR_MAX + 1];
+		nla_parse(tb, NL802154_ATTR_MAX, genlmsg_attrdata(gnlh, 0),
+			genlmsg_attrlen(gnlh, 0), NULL);
+		if (!tb[NL802154_ATTR_IFINDEX] ||
+			nla_get_u32(tb[NL802154_ATTR_IFINDEX]) != sd->devidx)
+			return 0;
+	}
+	sd->done = 1;
+	return 0;
+}
+
+static int no_seq_check(struct nl_msg *msg, void *arg)
+{
+	return NL_OK;
+}
+
+static int scan_done_handler(struct nl802154_state *state,
+			     struct nl_cb *cb,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	struct nl_cb *s_cb;
+	struct scan_done sd;
+	int ret, group;
+
+	/* Configure socket to receive messages in Scan multicast group */
+	group = genl_ctrl_resolve_grp(state->nl_sock, "nl802154", "scan");
+	if (group < 0)
+		return group;
+	ret = nl_socket_add_membership(state->nl_sock, group);
+	if (ret)
+		return ret;
+	/* Init netlink callbacks as if we run a command */
+	cb = nl_cb_alloc(iwpan_debug ? NL_CB_DEBUG : NL_CB_DEFAULT);
+	if (!cb) {
+		fprintf(stderr, "failed to allocate netlink callbacks\n");
+		return 2;
+	}
+	nl_socket_set_cb(state->nl_sock, cb);
+	/* no sequence checking for multicast messages */
+	nl_socket_disable_seq_check(state->nl_sock);
+	/* install scan done message handler */
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, wait_scan_done_handler, &sd);
+	/* set net device filter */
+	sd.devidx = if_nametoindex(*argv);
+	if (sd.devidx == 0)
+		sd.devidx = -1;
+	sd.done = 0;
+	/* loop waiting */
+	while (sd.done == 0)
+		nl_recvmsgs(state->nl_sock, cb);
+	/* restore seq & leave multicast group */
+	ret = nl_socket_drop_membership(state->nl_sock, group);
+	nl_cb_put(cb);
+	return ret;
+}
+
+static int scan_combined_handler(struct nl802154_state *state,
+				 struct nl_cb *cb,
+				 struct nl_msg *msg,
+				 int argc, char **argv,
+				 enum id_input id)
+{
+	char **trig_argv;
+	static char *done_argv[] = {
+		NULL,
+		"scan",
+		"done",
+	};
+	static char *dump_argv[] = {
+		NULL,
+		"pans",
+		"dump",
+	};
+	int trig_argc, err;
+	int i;
+
+	/* dev wpan0 scan trigger ... */
+	trig_argc = 3 + (argc - 2);
+	trig_argv = calloc(trig_argc, sizeof(*trig_argv));
+	if (!trig_argv)
+		return -ENOMEM;
+	trig_argv[0] = argv[0];
+	trig_argv[1] = "scan";
+	trig_argv[2] = "trigger";
+	for (i = 0; i < argc - 2; i++)
+		trig_argv[i + 3] = argv[i + 2];
+	err = handle_cmd(state, id, trig_argc, trig_argv);
+	free(trig_argv);
+	if (err)
+		return err;
+
+	/* dev wpan0 scan done */
+	done_argv[0] = argv[0];
+	err = handle_cmd(state, id, 3, done_argv);
+	if (err)
+		return err;
+
+	/* dev wpan0 scan dump */
+	dump_argv[0] = argv[0];
+	return handle_cmd(state, id, 3, dump_argv);
+}
+TOPLEVEL(scan, "type <type> [page <page>] [channels <bitfield>] [duration <duration-order>]",
+	0, 0, CIB_NETDEV, scan_combined_handler,
+	"Scan on this virtual interface with the given configuration.\n"
+	SCAN_TYPES);
+COMMAND(scan, abort, NULL, NL802154_CMD_ABORT_SCAN, 0, CIB_NETDEV, scan_abort_handler,
+	"Abort ongoing scanning on this virtual interface");
+COMMAND(scan, done, NULL, 0, 0, CIB_NETDEV, scan_done_handler,
+	"Wait scan terminated on this virtual interface");
+COMMAND(scan, trigger,
+	"type <type> [page <page>] [channels <bitfield>] [duration <duration-order>]",
+	NL802154_CMD_TRIGGER_SCAN, 0, CIB_NETDEV, scan_trigger_handler,
+	"Launch scanning on this virtual interface with the given configuration.\n"
+	SCAN_TYPES);
+
+SECTION(pans);
+
+static unsigned int scan_dump_offset;
+
+static int pans_dump_handler(struct nl802154_state *state,
+			     struct nl_cb *cb,
+			     struct nl_msg *msg,
+			     int argc, char **argv,
+			     enum id_input id)
+{
+	int ret;
+	scan_dump_offset = 0;
+	/* Configure socket to receive messages in scan multicast group */
+	ret = genl_ctrl_resolve_grp(state->nl_sock, "nl802154", "scan");
+	if (ret < 0)
+		return ret;
+	ret = nl_socket_add_membership(state->nl_sock, ret);
+	if (ret)
+		return ret;
+	/* Set custom callback to decode received message on scan group */
+	nl_cb_set(cb, NL_CB_VALID, NL_CB_CUSTOM, print_scan_dump_handler, &scan_dump_offset);
+	return 0;
+}
+
+static int pans_flush_handler(struct nl802154_state *state,
+			      struct nl_cb *cb,
+			      struct nl_msg *msg,
+			      int argc, char **argv,
+			      enum id_input id)
+{
+	return 0;
+}
+
+COMMAND(pans, flush, NULL, NL802154_CMD_FLUSH_PANS, 0, CIB_NETDEV,
+	pans_flush_handler,
+	"Flush list of known PANs on this virtual interface");
+COMMAND(pans, dump, NULL, NL802154_CMD_DUMP_PANS, NLM_F_DUMP, CIB_NETDEV,
+	pans_dump_handler,
+	"Dump list of known PANs on this virtual interface");
+
+SECTION(beacons);
+
+static int send_beacons_handler(struct nl802154_state *state, struct nl_cb *cb,
+				struct nl_msg *msg, int argc, char **argv,
+				enum id_input id)
+{
+	unsigned long interval;
+	bool valid_interval;
+	int tpset;
+
+	tpset = get_option_value(&argc, &argv, "interval", &interval, &valid_interval);
+	if (tpset)
+		return tpset;
+	if (valid_interval && interval > UINT8_MAX)
+		return 1;
+
+	if (argc)
+		return 1;
+
+	/* Optional arguments */
+	if (valid_interval)
+		NLA_PUT_U8(msg, NL802154_ATTR_BEACON_INTERVAL, interval);
+
+	return 0;
+
+nla_put_failure:
+	return -ENOBUFS;
+}
+
+static int stop_beacons_handler(struct nl802154_state *state, struct nl_cb *cb,
+				struct nl_msg *msg, int argc, char **argv,
+				enum id_input id)
+{
+	return 0;
+}
+
+COMMAND(beacons, stop, NULL,
+	NL802154_CMD_STOP_BEACONS, 0, CIB_NETDEV, stop_beacons_handler,
+	"Stop sending beacons on this interface.");
+COMMAND(beacons, send, "[interval <interval-order>]",
+	NL802154_CMD_SEND_BEACONS, 0, CIB_NETDEV, send_beacons_handler,
+	"Send beacons on this virtual interface at a regular pace.");
-- 
2.27.0

