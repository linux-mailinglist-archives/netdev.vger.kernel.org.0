Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F0021949
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 15:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728649AbfEQNik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 09:38:40 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:32926 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbfEQNij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 09:38:39 -0400
Received: by mail-wr1-f65.google.com with SMTP id d9so7237699wrx.0
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 06:38:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FYfYmsvZpzGJo11qa/zC1x1ko43q+Tc5vV4Uz5RvRa4=;
        b=EZ+8nPosHbfD3hUmaVKHmUeciK9xDg/SVcbI2uX+unxdPWlzJjQ0KoEzyRXGZhI6Uf
         nFY4FFcfobwk6jSslZTqF83E9jxHfe6M/XN17FlBwkOJVZmFrLZFmwJ/z87VHcrVwMd9
         6obneF3OqwTjJPe1RLGJky+8lAssmzManrKs87sjupNBQnbJ9J0lNZZ0WOP16lJlVtTR
         cJjzFO7A0yaO3kVixNHcFqejRdBexG9tbgB1a/s4W4DI3zgSvO4sSm7qv5YR6/KFC43e
         LIC6eu2Ik4FHP2pDr0YMFTVnzW5rNBbH+ZU8Ney6GjR0p3ZNUlhBJcZ1Tn+8B1xpi320
         A3MA==
X-Gm-Message-State: APjAAAWO1UlZFfkxcJqYz+fmTyswMS0JzWLRg1lBRd02J5fL26JZ9kdk
        tXZyjegLlHkvvqFUmXM/446TgRgDwuI=
X-Google-Smtp-Source: APXvYqybjCv9bCdgBCyD00H6r/rjtzkcCTDGtvmPMm9boL9zy6SP26ubLG/Ziw47CXBt7676uxii9Q==
X-Received: by 2002:adf:d4ca:: with SMTP id w10mr34443080wrk.293.1558100309850;
        Fri, 17 May 2019 06:38:29 -0700 (PDT)
Received: from mcroce-redhat.mxp.redhat.com (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id i185sm14259507wmg.32.2019.05.17.06.38.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 17 May 2019 06:38:28 -0700 (PDT)
From:   Matteo Croce <mcroce@redhat.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next] treewide: refactor help messages
Date:   Fri, 17 May 2019 15:38:28 +0200
Message-Id: <20190517133828.2977-1-mcroce@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Every tool in the iproute2 package have one or more function to show
an help message to the user. Some of these functions print the help
line by line with a series of printf call, e.g. ip/xfrm_state.c does
60 fprintf calls.
If we group all the calls to a single one and just concatenate strings,
we save a lot of libc calls and thus object size. The size difference
of the compiled binaries calculated with bloat-o-meter is:

        ip/ip:
        add/remove: 0/0 grow/shrink: 5/15 up/down: 103/-4796 (-4693)
        Total: Before=672591, After=667898, chg -0.70%
        ip/rtmon:
        add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-54 (-54)
        Total: Before=48879, After=48825, chg -0.11%
        tc/tc:
        add/remove: 0/2 grow/shrink: 31/10 up/down: 882/-6133 (-5251)
        Total: Before=351912, After=346661, chg -1.49%
        bridge/bridge:
        add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-459 (-459)
        Total: Before=70502, After=70043, chg -0.65%
        misc/lnstat:
        add/remove: 0/1 grow/shrink: 1/0 up/down: 48/-486 (-438)
        Total: Before=9960, After=9522, chg -4.40%
        tipc/tipc:
        add/remove: 0/0 grow/shrink: 1/1 up/down: 18/-62 (-44)
        Total: Before=79182, After=79138, chg -0.06%

While at it, indent some strings which were starting at column 0,
and use tabs where possible, to have a consistent style across helps.

Signed-off-by: Matteo Croce <mcroce@redhat.com>
---
 bridge/link.c            |  35 +++++-----
 bridge/mdb.c             |   5 +-
 ip/ip.c                  |  26 ++++----
 ip/ip6tunnel.c           |  35 +++++-----
 ip/ipaddress.c           |  53 +++++++--------
 ip/ipaddrlabel.c         |   5 +-
 ip/ipila.c               |  10 +--
 ip/iplink.c              | 107 +++++++++++++++---------------
 ip/iplink_bridge.c       |  66 +++++++++----------
 ip/iplink_bridge_slave.c |  40 ++++++------
 ip/iplink_geneve.c       |  32 ++++-----
 ip/iplink_hsr.c          |  24 +++----
 ip/iplink_ipoib.c        |   4 +-
 ip/iplink_vlan.c         |  16 ++---
 ip/iplink_vxlan.c        |  54 +++++++--------
 ip/ipmaddr.c             |   5 +-
 ip/ipmonitor.c           |   9 +--
 ip/ipmroute.c            |  10 +--
 ip/ipneigh.c             |  17 +++--
 ip/ipnetns.c             |  23 +++----
 ip/ipntable.c            |  12 ++--
 ip/ipseg6.c              |  13 ++--
 ip/iptunnel.c            |  25 +++----
 ip/iptuntap.c            |  13 ++--
 ip/ipvrf.c               |   9 +--
 ip/link_gre.c            |  63 ++++++++----------
 ip/link_gre6.c           |  73 ++++++++++-----------
 ip/link_ip6tnl.c         |  67 ++++++++-----------
 ip/link_iptnl.c          |  63 ++++++++----------
 ip/link_vti.c            |  24 +++----
 ip/link_vti6.c           |  24 +++----
 ip/link_xfrm.c           |   7 +-
 ip/rtmon.c               |   9 +--
 ip/tcp_metrics.c         |   9 +--
 ip/xfrm_monitor.c        |   5 +-
 ip/xfrm_policy.c         |  99 +++++++++++++++-------------
 ip/xfrm_state.c          | 138 ++++++++++++++++++++++-----------------
 misc/lnstat.c            |  47 ++++++-------
 misc/nstat.c             |  24 +++----
 tc/e_bpf.c               |  28 ++++----
 tc/f_basic.c             |  16 +++--
 tc/f_bpf.c               |  62 +++++++++---------
 tc/f_flow.c              |  30 ++++-----
 tc/f_flower.c            |  90 ++++++++++++-------------
 tc/f_fw.c                |  19 ++----
 tc/f_matchall.c          |  16 +++--
 tc/f_route.c             |  12 ++--
 tc/f_rsvp.c              |  19 +++---
 tc/f_tcindex.c           |   7 +-
 tc/m_action.c            |  26 ++++----
 tc/m_bpf.c               |  54 +++++++--------
 tc/m_connmark.c          |   5 +-
 tc/m_estimator.c         |   9 +--
 tc/m_gact.c              |   3 +-
 tc/m_ife.c               |   9 ++-
 tc/m_pedit.c             |   2 +-
 tc/m_police.c            |  18 ++---
 tc/m_sample.c            |  19 +++---
 tc/m_simple.c            |   5 +-
 tc/m_tunnel_key.c        |   4 +-
 tc/q_atm.c               |   5 +-
 tc/q_cake.c              |  30 ++++-----
 tc/q_cbq.c               |  20 +++---
 tc/q_cbs.c               |   6 +-
 tc/q_choke.c             |   5 +-
 tc/q_codel.c             |   7 +-
 tc/q_etf.c               |  11 ++--
 tc/q_fq.c                |  15 +++--
 tc/q_fq_codel.c          |  11 ++--
 tc/q_gred.c              |  11 ++--
 tc/q_hhf.c               |  13 ++--
 tc/q_mqprio.c            |  13 ++--
 tc/q_netem.c             |  32 ++++-----
 tc/q_pie.c               |   7 +-
 tc/q_red.c               |   7 +-
 tc/q_sfq.c               |  13 ++--
 tc/q_taprio.c            |  15 +++--
 tc/q_tbf.c               |   7 +-
 tc/tc.c                  |  12 ++--
 tc/tc_class.c            |  17 ++---
 tc/tc_exec.c             |   9 +--
 tc/tc_qdisc.c            |  25 +++----
 tipc/bearer.c            |  44 ++++++-------
 83 files changed, 1066 insertions(+), 1022 deletions(-)

diff --git a/bridge/link.c b/bridge/link.c
index 04cfc144..074edf00 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -254,23 +254,24 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: bridge link set dev DEV [ cost COST ] [ priority PRIO ] [ state STATE ]\n");
-	fprintf(stderr, "                               [ guard {on | off} ]\n");
-	fprintf(stderr, "                               [ hairpin {on | off} ]\n");
-	fprintf(stderr, "                               [ fastleave {on | off} ]\n");
-	fprintf(stderr,	"                               [ root_block {on | off} ]\n");
-	fprintf(stderr,	"                               [ learning {on | off} ]\n");
-	fprintf(stderr,	"                               [ learning_sync {on | off} ]\n");
-	fprintf(stderr,	"                               [ flood {on | off} ]\n");
-	fprintf(stderr,	"                               [ mcast_flood {on | off} ]\n");
-	fprintf(stderr,	"                               [ mcast_to_unicast {on | off} ]\n");
-	fprintf(stderr,	"                               [ neigh_suppress {on | off} ]\n");
-	fprintf(stderr,	"                               [ vlan_tunnel {on | off} ]\n");
-	fprintf(stderr,	"                               [ isolated {on | off} ]\n");
-	fprintf(stderr, "                               [ hwmode {vepa | veb} ]\n");
-	fprintf(stderr,	"                               [ backup_port DEVICE ] [ nobackup_port ]\n");
-	fprintf(stderr, "                               [ self ] [ master ]\n");
-	fprintf(stderr, "       bridge link show [dev DEV]\n");
+	fprintf(stderr,
+		"Usage: bridge link set dev DEV [ cost COST ] [ priority PRIO ] [ state STATE ]\n"
+		"                               [ guard {on | off} ]\n"
+		"                               [ hairpin {on | off} ]\n"
+		"                               [ fastleave {on | off} ]\n"
+		"                               [ root_block {on | off} ]\n"
+		"                               [ learning {on | off} ]\n"
+		"                               [ learning_sync {on | off} ]\n"
+		"                               [ flood {on | off} ]\n"
+		"                               [ mcast_flood {on | off} ]\n"
+		"                               [ mcast_to_unicast {on | off} ]\n"
+		"                               [ neigh_suppress {on | off} ]\n"
+		"                               [ vlan_tunnel {on | off} ]\n"
+		"                               [ isolated {on | off} ]\n"
+		"                               [ hwmode {vepa | veb} ]\n"
+		"                               [ backup_port DEVICE ] [ nobackup_port ]\n"
+		"                               [ self ] [ master ]\n"
+		"       bridge link show [dev DEV]\n");
 	exit(-1);
 }
 
diff --git a/bridge/mdb.c b/bridge/mdb.c
index 59aa1764..ede3542b 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -30,8 +30,9 @@ static unsigned int filter_index, filter_vlan;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [permanent | temp] [vid VID]\n");
-	fprintf(stderr, "       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
+	fprintf(stderr,
+		"Usage: bridge mdb { add | del } dev DEV port PORT grp GROUP [permanent | temp] [vid VID]\n"
+		"       bridge mdb {show} [ dev DEV ] [ vid VID ]\n");
 	exit(-1);
 }
 
diff --git a/ip/ip.c b/ip/ip.c
index e4131714..b71ae816 100644
--- a/ip/ip.c
+++ b/ip/ip.c
@@ -45,19 +45,19 @@ static void usage(void) __attribute__((noreturn));
 static void usage(void)
 {
 	fprintf(stderr,
-"Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }\n"
-"       ip [ -force ] -batch filename\n"
-"where  OBJECT := { link | address | addrlabel | route | rule | neigh | ntable |\n"
-"                   tunnel | tuntap | maddress | mroute | mrule | monitor | xfrm |\n"
-"                   netns | l2tp | fou | macsec | tcp_metrics | token | netconf | ila |\n"
-"                   vrf | sr }\n"
-"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |\n"
-"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\n"
-"                    -f[amily] { inet | inet6 | mpls | bridge | link } |\n"
-"                    -4 | -6 | -I | -D | -M | -B | -0 |\n"
-"                    -l[oops] { maximum-addr-flush-attempts } | -br[ief] |\n"
-"                    -o[neline] | -t[imestamp] | -ts[hort] | -b[atch] [filename] |\n"
-"                    -rc[vbuf] [size] | -n[etns] name | -a[ll] | -c[olor]}\n");
+		"Usage: ip [ OPTIONS ] OBJECT { COMMAND | help }\n"
+		"       ip [ -force ] -batch filename\n"
+		"where  OBJECT := { link | address | addrlabel | route | rule | neigh | ntable |\n"
+		"                   tunnel | tuntap | maddress | mroute | mrule | monitor | xfrm |\n"
+		"                   netns | l2tp | fou | macsec | tcp_metrics | token | netconf | ila |\n"
+		"                   vrf | sr }\n"
+		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[esolve] |\n"
+		"                    -h[uman-readable] | -iec | -j[son] | -p[retty] |\n"
+		"                    -f[amily] { inet | inet6 | mpls | bridge | link } |\n"
+		"                    -4 | -6 | -I | -D | -M | -B | -0 |\n"
+		"                    -l[oops] { maximum-addr-flush-attempts } | -br[ief] |\n"
+		"                    -o[neline] | -t[imestamp] | -ts[hort] | -b[atch] [filename] |\n"
+		"                    -rc[vbuf] [size] | -n[etns] name | -a[ll] | -c[olor]}\n");
 	exit(-1);
 }
 
diff --git a/ip/ip6tunnel.c b/ip/ip6tunnel.c
index 999408ed..a1bf366b 100644
--- a/ip/ip6tunnel.c
+++ b/ip/ip6tunnel.c
@@ -46,24 +46,25 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip -f inet6 tunnel { add | change | del | show } [ NAME ]\n");
-	fprintf(stderr, "          [ mode { ip6ip6 | ipip6 | ip6gre | vti6 | any } ]\n");
-	fprintf(stderr, "          [ remote ADDR local ADDR ] [ dev PHYS_DEV ]\n");
-	fprintf(stderr, "          [ encaplimit ELIM ]\n");
-	fprintf(stderr, "          [ hoplimit TTL ] [ tclass TCLASS ] [ flowlabel FLOWLABEL ]\n");
-	fprintf(stderr, "          [ dscp inherit ]\n");
-	fprintf(stderr, "          [ [no]allow-localremote ]\n");
-	fprintf(stderr, "          [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where: NAME      := STRING\n");
-	fprintf(stderr, "       ADDR      := IPV6_ADDRESS\n");
-	fprintf(stderr, "       ELIM      := { none | 0..255 }(default=%d)\n",
-		IPV6_DEFAULT_TNL_ENCAP_LIMIT);
-	fprintf(stderr, "       TTL       := 0..255 (default=%d)\n",
+	fprintf(stderr,
+		"Usage: ip -f inet6 tunnel { add | change | del | show } [ NAME ]\n"
+		"          [ mode { ip6ip6 | ipip6 | ip6gre | vti6 | any } ]\n"
+		"          [ remote ADDR local ADDR ] [ dev PHYS_DEV ]\n"
+		"          [ encaplimit ELIM ]\n"
+		"          [ hoplimit TTL ] [ tclass TCLASS ] [ flowlabel FLOWLABEL ]\n"
+		"          [ dscp inherit ]\n"
+		"          [ [no]allow-localremote ]\n"
+		"          [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n"
+		"\n"
+		"Where: NAME      := STRING\n"
+		"       ADDR      := IPV6_ADDRESS\n"
+		"       ELIM      := { none | 0..255 }(default=%d)\n"
+		"       TTL       := 0..255 (default=%d)\n"
+		"       TCLASS    := { 0x0..0xff | inherit }\n"
+		"       FLOWLABEL := { 0x0..0xfffff | inherit }\n"
+		"       KEY       := { DOTTED_QUAD | NUMBER }\n",
+		IPV6_DEFAULT_TNL_ENCAP_LIMIT,
 		DEFAULT_TNL_HOP_LIMIT);
-	fprintf(stderr, "       TCLASS    := { 0x0..0xff | inherit }\n");
-	fprintf(stderr, "       FLOWLABEL := { 0x0..0xfffff | inherit }\n");
-	fprintf(stderr, "       KEY       := { DOTTED_QUAD | NUMBER }\n");
 	exit(-1);
 }
 
diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index b504200b..1309ac7c 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -52,32 +52,33 @@ static void usage(void)
 	if (do_link)
 		iplink_usage();
 
-	fprintf(stderr, "Usage: ip address {add|change|replace} IFADDR dev IFNAME [ LIFETIME ]\n");
-	fprintf(stderr, "                                                      [ CONFFLAG-LIST ]\n");
-	fprintf(stderr, "       ip address del IFADDR dev IFNAME [mngtmpaddr]\n");
-	fprintf(stderr, "       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]\n");
-	fprintf(stderr, "                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n");
-	fprintf(stderr, "       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n");
-	fprintf(stderr, "                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n");
-	fprintf(stderr, "                         [ label LABEL ] [up] [ vrf NAME ] ]\n");
-	fprintf(stderr, "       ip address {showdump|restore}\n");
-	fprintf(stderr, "IFADDR := PREFIX | ADDR peer PREFIX\n");
-	fprintf(stderr, "          [ broadcast ADDR ] [ anycast ADDR ]\n");
-	fprintf(stderr, "          [ label IFNAME ] [ scope SCOPE-ID ] [ metric METRIC ]\n");
-	fprintf(stderr, "SCOPE-ID := [ host | link | global | NUMBER ]\n");
-	fprintf(stderr, "FLAG-LIST := [ FLAG-LIST ] FLAG\n");
-	fprintf(stderr, "FLAG  := [ permanent | dynamic | secondary | primary |\n");
-	fprintf(stderr, "           [-]tentative | [-]deprecated | [-]dadfailed | temporary |\n");
-	fprintf(stderr, "           CONFFLAG-LIST ]\n");
-	fprintf(stderr, "CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n");
-	fprintf(stderr, "CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n");
-	fprintf(stderr, "LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n");
-	fprintf(stderr, "LFT := forever | SECONDS\n");
-	fprintf(stderr, "TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n");
-	fprintf(stderr, "          bridge | bond | ipoib | ip6tnl | ipip | sit | vxlan | lowpan |\n");
-	fprintf(stderr, "          gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan | vti |\n");
-	fprintf(stderr, "          nlmon | can | bond_slave | ipvlan | geneve | bridge_slave |\n");
-	fprintf(stderr, "          hsr | macsec | netdevsim }\n");
+	fprintf(stderr,
+		"Usage: ip address {add|change|replace} IFADDR dev IFNAME [ LIFETIME ]\n"
+		"                                                      [ CONFFLAG-LIST ]\n"
+		"       ip address del IFADDR dev IFNAME [mngtmpaddr]\n"
+		"       ip address {save|flush} [ dev IFNAME ] [ scope SCOPE-ID ]\n"
+		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
+		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
+		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
+		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
+		"       ip address {showdump|restore}\n"
+		"IFADDR := PREFIX | ADDR peer PREFIX\n"
+		"          [ broadcast ADDR ] [ anycast ADDR ]\n"
+		"          [ label IFNAME ] [ scope SCOPE-ID ] [ metric METRIC ]\n"
+		"SCOPE-ID := [ host | link | global | NUMBER ]\n"
+		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
+		"FLAG  := [ permanent | dynamic | secondary | primary |\n"
+		"           [-]tentative | [-]deprecated | [-]dadfailed | temporary |\n"
+		"           CONFFLAG-LIST ]\n"
+		"CONFFLAG-LIST := [ CONFFLAG-LIST ] CONFFLAG\n"
+		"CONFFLAG  := [ home | nodad | mngtmpaddr | noprefixroute | autojoin ]\n"
+		"LIFETIME := [ valid_lft LFT ] [ preferred_lft LFT ]\n"
+		"LFT := forever | SECONDS\n"
+		"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
+		"          bridge | bond | ipoib | ip6tnl | ipip | sit | vxlan | lowpan |\n"
+		"          gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan | vti |\n"
+		"          nlmon | can | bond_slave | ipvlan | geneve | bridge_slave |\n"
+		"          hsr | macsec | netdevsim }\n");
 
 	exit(-1);
 }
diff --git a/ip/ipaddrlabel.c b/ip/ipaddrlabel.c
index f06ed1e7..beb08da3 100644
--- a/ip/ipaddrlabel.c
+++ b/ip/ipaddrlabel.c
@@ -49,8 +49,9 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip addrlabel { add | del } prefix PREFIX [ dev DEV ] [ label LABEL ]\n");
-	fprintf(stderr, "       ip addrlabel [ list | flush | help ]\n");
+	fprintf(stderr,
+		"Usage: ip addrlabel { add | del } prefix PREFIX [ dev DEV ] [ label LABEL ]\n"
+		"       ip addrlabel [ list | flush | help ]\n");
 	exit(-1);
 }
 
diff --git a/ip/ipila.c b/ip/ipila.c
index 11fbb5fa..739ee4e1 100644
--- a/ip/ipila.c
+++ b/ip/ipila.c
@@ -28,11 +28,11 @@
 static void usage(void)
 {
 	fprintf(stderr,
-"Usage: ip ila add loc_match LOCATOR_MATCH loc LOCATOR [ dev DEV ] OPTIONS\n"
-"       ip ila del loc_match LOCATOR_MATCH [ loc LOCATOR ] [ dev DEV ]\n"
-"       ip ila list\n"
-"OPTIONS := [ csum-mode { adj-transport | neutral-map | neutral-map-auto | no-action } ]\n"
-"           [ ident-type { luid | use-format } ]\n");
+		"Usage: ip ila add loc_match LOCATOR_MATCH loc LOCATOR [ dev DEV ] OPTIONS\n"
+		"       ip ila del loc_match LOCATOR_MATCH [ loc LOCATOR ] [ dev DEV ]\n"
+		"       ip ila list\n"
+		"OPTIONS := [ csum-mode { adj-transport | neutral-map | neutral-map-auto | no-action } ]\n"
+		"           [ ident-type { luid | use-format } ]\n");
 
 	exit(-1);
 }
diff --git a/ip/iplink.c b/ip/iplink.c
index 7952cb2b..baea8967 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -54,75 +54,76 @@ void iplink_usage(void)
 	if (iplink_have_newlink()) {
 		fprintf(stderr,
 			"Usage: ip link add [link DEV] [ name ] NAME\n"
-			"                   [ txqueuelen PACKETS ]\n"
-			"                   [ address LLADDR ]\n"
-			"                   [ broadcast LLADDR ]\n"
-			"                   [ mtu MTU ] [index IDX ]\n"
-			"                   [ numtxqueues QUEUE_COUNT ]\n"
-			"                   [ numrxqueues QUEUE_COUNT ]\n"
-			"                   type TYPE [ ARGS ]\n"
+			"		    [ txqueuelen PACKETS ]\n"
+			"		    [ address LLADDR ]\n"
+			"		    [ broadcast LLADDR ]\n"
+			"		    [ mtu MTU ] [index IDX ]\n"
+			"		    [ numtxqueues QUEUE_COUNT ]\n"
+			"		    [ numrxqueues QUEUE_COUNT ]\n"
+			"		    type TYPE [ ARGS ]\n"
 			"\n"
-			"       ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
+			"	ip link delete { DEVICE | dev DEVICE | group DEVGROUP } type TYPE [ ARGS ]\n"
 			"\n"
-			"       ip link set { DEVICE | dev DEVICE | group DEVGROUP }\n"
-			"	                  [ { up | down } ]\n"
-			"	                  [ type TYPE ARGS ]\n");
+			"	ip link set { DEVICE | dev DEVICE | group DEVGROUP }\n"
+			"			[ { up | down } ]\n"
+			"			[ type TYPE ARGS ]\n");
 	} else
 		fprintf(stderr,
 			"Usage: ip link set DEVICE [ { up | down } ]\n");
 
 	fprintf(stderr,
-		"	                  [ arp { on | off } ]\n"
-		"	                  [ dynamic { on | off } ]\n"
-		"	                  [ multicast { on | off } ]\n"
-		"	                  [ allmulticast { on | off } ]\n"
-		"	                  [ promisc { on | off } ]\n"
-		"	                  [ trailers { on | off } ]\n"
-		"	                  [ carrier { on | off } ]\n"
-		"	                  [ txqueuelen PACKETS ]\n"
-		"	                  [ name NEWNAME ]\n"
-		"	                  [ address LLADDR ]\n"
-		"	                  [ broadcast LLADDR ]\n"
-		"	                  [ mtu MTU ]\n"
-		"	                  [ netns { PID | NAME } ]\n"
-		"	                  [ link-netns NAME | link-netnsid ID ]\n"
-		"			  [ alias NAME ]\n"
-		"	                  [ vf NUM [ mac LLADDR ]\n"
-		"				   [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]\n"
-		"				   [ rate TXRATE ]\n"
-		"				   [ max_tx_rate TXRATE ]\n"
-		"				   [ min_tx_rate TXRATE ]\n"
-		"				   [ spoofchk { on | off} ]\n"
-		"				   [ query_rss { on | off} ]\n"
-		"				   [ state { auto | enable | disable} ] ]\n"
-		"				   [ trust { on | off} ] ]\n"
-		"				   [ node_guid { eui64 } ]\n"
-		"				   [ port_guid { eui64 } ]\n"
-		"			  [ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
+		"		[ arp { on | off } ]\n"
+		"		[ dynamic { on | off } ]\n"
+		"		[ multicast { on | off } ]\n"
+		"		[ allmulticast { on | off } ]\n"
+		"		[ promisc { on | off } ]\n"
+		"		[ trailers { on | off } ]\n"
+		"		[ carrier { on | off } ]\n"
+		"		[ txqueuelen PACKETS ]\n"
+		"		[ name NEWNAME ]\n"
+		"		[ address LLADDR ]\n"
+		"		[ broadcast LLADDR ]\n"
+		"		[ mtu MTU ]\n"
+		"		[ netns { PID | NAME } ]\n"
+		"		[ link-netns NAME | link-netnsid ID ]\n"
+		"			[ alias NAME ]\n"
+		"			[ vf NUM [ mac LLADDR ]\n"
+		"				 [ vlan VLANID [ qos VLAN-QOS ] [ proto VLAN-PROTO ] ]\n"
+		"				 [ rate TXRATE ]\n"
+		"				 [ max_tx_rate TXRATE ]\n"
+		"				 [ min_tx_rate TXRATE ]\n"
+		"				 [ spoofchk { on | off} ]\n"
+		"				 [ query_rss { on | off} ]\n"
+		"				 [ state { auto | enable | disable} ] ]\n"
+		"				 [ trust { on | off} ] ]\n"
+		"				 [ node_guid { eui64 } ]\n"
+		"				 [ port_guid { eui64 } ]\n"
+		"			[ { xdp | xdpgeneric | xdpdrv | xdpoffload } { off |\n"
 		"				  object FILE [ section NAME ] [ verbose ] |\n"
 		"				  pinned FILE } ]\n"
-		"			  [ master DEVICE ][ vrf NAME ]\n"
-		"			  [ nomaster ]\n"
-		"			  [ addrgenmode { eui64 | none | stable_secret | random } ]\n"
-		"			  [ protodown { on | off } ]\n"
-		"			  [ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
+		"			[ master DEVICE ][ vrf NAME ]\n"
+		"			[ nomaster ]\n"
+		"			[ addrgenmode { eui64 | none | stable_secret | random } ]\n"
+		"			[ protodown { on | off } ]\n"
+		"			[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
-		"       ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n");
-
-	fprintf(stderr, "\n       ip link xstats type TYPE [ ARGS ]\n");
-	fprintf(stderr, "\n       ip link afstats [ dev DEVICE ]\n");
+		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
+		"\n"
+		"	ip link xstats type TYPE [ ARGS ]\n"
+		"\n"
+		"	ip link afstats [ dev DEVICE ]\n");
 
 	if (iplink_have_newlink()) {
 		fprintf(stderr,
 			"\n"
-			"       ip link help [ TYPE ]\n"
+			"	ip link help [ TYPE ]\n"
 			"\n"
 			"TYPE := { vlan | veth | vcan | vxcan | dummy | ifb | macvlan | macvtap |\n"
-			"          bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
-			"          gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
-			"          vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
-			"          ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
-			"          xfrm }\n");
+			"	   bridge | bond | team | ipoib | ip6tnl | ipip | sit | vxlan |\n"
+			"	   gre | gretap | erspan | ip6gre | ip6gretap | ip6erspan |\n"
+			"	   vti | nlmon | team_slave | bond_slave | bridge_slave |\n"
+			"	   ipvlan | ipvtap | geneve | vrf | macsec | netdevsim | rmnet |\n"
+			"	   xfrm }\n");
 	}
 	exit(-1);
 }
diff --git a/ip/iplink_bridge.c b/ip/iplink_bridge.c
index 10ba85f6..06f736d4 100644
--- a/ip/iplink_bridge.c
+++ b/ip/iplink_bridge.c
@@ -29,39 +29,39 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... bridge [ fdb_flush ]\n"
-		"                  [ forward_delay FORWARD_DELAY ]\n"
-		"                  [ hello_time HELLO_TIME ]\n"
-		"                  [ max_age MAX_AGE ]\n"
-		"                  [ ageing_time AGEING_TIME ]\n"
-		"                  [ stp_state STP_STATE ]\n"
-		"                  [ priority PRIORITY ]\n"
-		"                  [ group_fwd_mask MASK ]\n"
-		"                  [ group_address ADDRESS ]\n"
-		"                  [ vlan_filtering VLAN_FILTERING ]\n"
-		"                  [ vlan_protocol VLAN_PROTOCOL ]\n"
-		"                  [ vlan_default_pvid VLAN_DEFAULT_PVID ]\n"
-		"                  [ vlan_stats_enabled VLAN_STATS_ENABLED ]\n"
-		"                  [ vlan_stats_per_port VLAN_STATS_PER_PORT ]\n"
-		"                  [ mcast_snooping MULTICAST_SNOOPING ]\n"
-		"                  [ mcast_router MULTICAST_ROUTER ]\n"
-		"                  [ mcast_query_use_ifaddr MCAST_QUERY_USE_IFADDR ]\n"
-		"                  [ mcast_querier MULTICAST_QUERIER ]\n"
-		"                  [ mcast_hash_elasticity HASH_ELASTICITY ]\n"
-		"                  [ mcast_hash_max HASH_MAX ]\n"
-		"                  [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
-		"                  [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
-		"                  [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
-		"                  [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
-		"                  [ mcast_querier_interval QUERIER_INTERVAL ]\n"
-		"                  [ mcast_query_interval QUERY_INTERVAL ]\n"
-		"                  [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ]\n"
-		"                  [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ]\n"
-		"                  [ mcast_stats_enabled MCAST_STATS_ENABLED ]\n"
-		"                  [ mcast_igmp_version IGMP_VERSION ]\n"
-		"                  [ mcast_mld_version MLD_VERSION ]\n"
-		"                  [ nf_call_iptables NF_CALL_IPTABLES ]\n"
-		"                  [ nf_call_ip6tables NF_CALL_IP6TABLES ]\n"
-		"                  [ nf_call_arptables NF_CALL_ARPTABLES ]\n"
+		"		  [ forward_delay FORWARD_DELAY ]\n"
+		"		  [ hello_time HELLO_TIME ]\n"
+		"		  [ max_age MAX_AGE ]\n"
+		"		  [ ageing_time AGEING_TIME ]\n"
+		"		  [ stp_state STP_STATE ]\n"
+		"		  [ priority PRIORITY ]\n"
+		"		  [ group_fwd_mask MASK ]\n"
+		"		  [ group_address ADDRESS ]\n"
+		"		  [ vlan_filtering VLAN_FILTERING ]\n"
+		"		  [ vlan_protocol VLAN_PROTOCOL ]\n"
+		"		  [ vlan_default_pvid VLAN_DEFAULT_PVID ]\n"
+		"		  [ vlan_stats_enabled VLAN_STATS_ENABLED ]\n"
+		"		  [ vlan_stats_per_port VLAN_STATS_PER_PORT ]\n"
+		"		  [ mcast_snooping MULTICAST_SNOOPING ]\n"
+		"		  [ mcast_router MULTICAST_ROUTER ]\n"
+		"		  [ mcast_query_use_ifaddr MCAST_QUERY_USE_IFADDR ]\n"
+		"		  [ mcast_querier MULTICAST_QUERIER ]\n"
+		"		  [ mcast_hash_elasticity HASH_ELASTICITY ]\n"
+		"		  [ mcast_hash_max HASH_MAX ]\n"
+		"		  [ mcast_last_member_count LAST_MEMBER_COUNT ]\n"
+		"		  [ mcast_startup_query_count STARTUP_QUERY_COUNT ]\n"
+		"		  [ mcast_last_member_interval LAST_MEMBER_INTERVAL ]\n"
+		"		  [ mcast_membership_interval MEMBERSHIP_INTERVAL ]\n"
+		"		  [ mcast_querier_interval QUERIER_INTERVAL ]\n"
+		"		  [ mcast_query_interval QUERY_INTERVAL ]\n"
+		"		  [ mcast_query_response_interval QUERY_RESPONSE_INTERVAL ]\n"
+		"		  [ mcast_startup_query_interval STARTUP_QUERY_INTERVAL ]\n"
+		"		  [ mcast_stats_enabled MCAST_STATS_ENABLED ]\n"
+		"		  [ mcast_igmp_version IGMP_VERSION ]\n"
+		"		  [ mcast_mld_version MLD_VERSION ]\n"
+		"		  [ nf_call_iptables NF_CALL_IPTABLES ]\n"
+		"		  [ nf_call_ip6tables NF_CALL_IP6TABLES ]\n"
+		"		  [ nf_call_arptables NF_CALL_ARPTABLES ]\n"
 		"\n"
 		"Where: VLAN_PROTOCOL := { 802.1Q | 802.1ad }\n"
 	);
diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index ae9d15fc..79a1d2f5 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -23,26 +23,26 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... bridge_slave [ fdb_flush ]\n"
-		"                        [ state STATE ]\n"
-		"                        [ priority PRIO ]\n"
-		"                        [ cost COST ]\n"
-		"                        [ guard {on | off} ]\n"
-		"                        [ hairpin {on | off} ]\n"
-		"                        [ fastleave {on | off} ]\n"
-		"                        [ root_block {on | off} ]\n"
-		"                        [ learning {on | off} ]\n"
-		"                        [ flood {on | off} ]\n"
-		"                        [ proxy_arp {on | off} ]\n"
-		"                        [ proxy_arp_wifi {on | off} ]\n"
-		"                        [ mcast_router MULTICAST_ROUTER ]\n"
-		"                        [ mcast_fast_leave {on | off} ]\n"
-		"                        [ mcast_flood {on | off} ]\n"
-		"                        [ mcast_to_unicast {on | off} ]\n"
-		"                        [ group_fwd_mask MASK ]\n"
-		"                        [ neigh_suppress {on | off} ]\n"
-		"                        [ vlan_tunnel {on | off} ]\n"
-		"                        [ isolated {on | off} ]\n"
-		"                        [ backup_port DEVICE ] [ nobackup_port ]\n"
+		"			[ state STATE ]\n"
+		"			[ priority PRIO ]\n"
+		"			[ cost COST ]\n"
+		"			[ guard {on | off} ]\n"
+		"			[ hairpin {on | off} ]\n"
+		"			[ fastleave {on | off} ]\n"
+		"			[ root_block {on | off} ]\n"
+		"			[ learning {on | off} ]\n"
+		"			[ flood {on | off} ]\n"
+		"			[ proxy_arp {on | off} ]\n"
+		"			[ proxy_arp_wifi {on | off} ]\n"
+		"			[ mcast_router MULTICAST_ROUTER ]\n"
+		"			[ mcast_fast_leave {on | off} ]\n"
+		"			[ mcast_flood {on | off} ]\n"
+		"			[ mcast_to_unicast {on | off} ]\n"
+		"			[ group_fwd_mask MASK ]\n"
+		"			[ neigh_suppress {on | off} ]\n"
+		"			[ vlan_tunnel {on | off} ]\n"
+		"			[ isolated {on | off} ]\n"
+		"			[ backup_port DEVICE ] [ nobackup_port ]\n"
 	);
 }
 
diff --git a/ip/iplink_geneve.c b/ip/iplink_geneve.c
index d70b1941..9299236c 100644
--- a/ip/iplink_geneve.c
+++ b/ip/iplink_geneve.c
@@ -21,23 +21,23 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... geneve id VNI\n"
-		"                  remote ADDR\n"
-		"                  [ ttl TTL ]\n"
-		"                  [ tos TOS ]\n"
-		"                  [ df DF ]\n"
-		"                  [ flowlabel LABEL ]\n"
-		"                  [ dstport PORT ]\n"
-		"                  [ [no]external ]\n"
-		"                  [ [no]udpcsum ]\n"
-		"                  [ [no]udp6zerocsumtx ]\n"
-		"                  [ [no]udp6zerocsumrx ]\n"
+		"		remote ADDR\n"
+		"		[ ttl TTL ]\n"
+		"		[ tos TOS ]\n"
+		"		[ df DF ]\n"
+		"		[ flowlabel LABEL ]\n"
+		"		[ dstport PORT ]\n"
+		"		[ [no]external ]\n"
+		"		[ [no]udpcsum ]\n"
+		"		[ [no]udp6zerocsumtx ]\n"
+		"		[ [no]udp6zerocsumrx ]\n"
 		"\n"
-		"Where: VNI   := 0-16777215\n"
-		"       ADDR  := IP_ADDRESS\n"
-		"       TOS   := { NUMBER | inherit }\n"
-		"       TTL   := { 1..255 | auto | inherit }\n"
-		"       DF    := { unset | set | inherit }\n"
-		"       LABEL := 0-1048575\n"
+		"Where:	VNI   := 0-16777215\n"
+		"	ADDR  := IP_ADDRESS\n"
+		"	TOS   := { NUMBER | inherit }\n"
+		"	TTL   := { 1..255 | auto | inherit }\n"
+		"	DF    := { unset | set | inherit }\n"
+		"	LABEL := 0-1048575\n"
 	);
 }
 
diff --git a/ip/iplink_hsr.c b/ip/iplink_hsr.c
index c673ccf7..7d9167d4 100644
--- a/ip/iplink_hsr.c
+++ b/ip/iplink_hsr.c
@@ -24,18 +24,18 @@
 static void print_usage(FILE *f)
 {
 	fprintf(f,
-"Usage:\tip link add name NAME type hsr slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
-"\t[ supervision ADDR-BYTE ] [version VERSION]\n"
-"\n"
-"NAME\n"
-"	name of new hsr device (e.g. hsr0)\n"
-"SLAVE1-IF, SLAVE2-IF\n"
-"	the two slave devices bound to the HSR device\n"
-"ADDR-BYTE\n"
-"	0-255; the last byte of the multicast address used for HSR supervision\n"
-"	frames (default = 0)\n"
-"VERSION\n"
-"	0,1; the protocol version to be used. (default = 0)\n");
+		"Usage:\tip link add name NAME type hsr slave1 SLAVE1-IF slave2 SLAVE2-IF\n"
+		"\t[ supervision ADDR-BYTE ] [version VERSION]\n"
+		"\n"
+		"NAME\n"
+		"	name of new hsr device (e.g. hsr0)\n"
+		"SLAVE1-IF, SLAVE2-IF\n"
+		"	the two slave devices bound to the HSR device\n"
+		"ADDR-BYTE\n"
+		"	0-255; the last byte of the multicast address used for HSR supervision\n"
+		"	frames (default = 0)\n"
+		"VERSION\n"
+		"	0,1; the protocol version to be used. (default = 0)\n");
 }
 
 static void usage(void)
diff --git a/ip/iplink_ipoib.c b/ip/iplink_ipoib.c
index e69bda0e..05dba350 100644
--- a/ip/iplink_ipoib.c
+++ b/ip/iplink_ipoib.c
@@ -23,8 +23,8 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... ipoib [ pkey PKEY ]\n"
-		"                 [ mode {datagram | connected} ]\n"
-		"                 [ umcast {0|1} ]\n"
+		"		 [ mode {datagram | connected} ]\n"
+		"		 [ umcast {0|1} ]\n"
 		"\n"
 		"PKEY  := 0x8001-0xffff\n"
 	);
diff --git a/ip/iplink_vlan.c b/ip/iplink_vlan.c
index 26f6ee83..0dfb4a8d 100644
--- a/ip/iplink_vlan.c
+++ b/ip/iplink_vlan.c
@@ -22,14 +22,14 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... vlan id VLANID\n"
-		"                [ protocol VLANPROTO ]\n"
-		"                [ reorder_hdr { on | off } ]\n"
-		"                [ gvrp { on | off } ]\n"
-		"                [ mvrp { on | off } ]\n"
-		"                [ loose_binding { on | off } ]\n"
-		"                [ bridge_binding { on | off } ]\n"
-		"                [ ingress-qos-map QOS-MAP ]\n"
-		"                [ egress-qos-map QOS-MAP ]\n"
+		"		[ protocol VLANPROTO ]\n"
+		"		[ reorder_hdr { on | off } ]\n"
+		"		[ gvrp { on | off } ]\n"
+		"		[ mvrp { on | off } ]\n"
+		"		[ loose_binding { on | off } ]\n"
+		"		[ bridge_binding { on | off } ]\n"
+		"		[ ingress-qos-map QOS-MAP ]\n"
+		"		[ egress-qos-map QOS-MAP ]\n"
 		"\n"
 		"VLANID := 0-4095\n"
 		"VLANPROTO: [ 802.1Q | 802.1ad ]\n"
diff --git a/ip/iplink_vxlan.c b/ip/iplink_vxlan.c
index 1489c009..bae9d994 100644
--- a/ip/iplink_vxlan.c
+++ b/ip/iplink_vxlan.c
@@ -27,34 +27,34 @@ static void print_explain(FILE *f)
 {
 	fprintf(f,
 		"Usage: ... vxlan id VNI\n"
-		"                 [ { group | remote } IP_ADDRESS ]\n"
-		"                 [ local ADDR ]\n"
-		"                 [ ttl TTL ]\n"
-		"                 [ tos TOS ]\n"
-		"                 [ df DF ]\n"
-		"                 [ flowlabel LABEL ]\n"
-		"                 [ dev PHYS_DEV ]\n"
-		"                 [ dstport PORT ]\n"
-		"                 [ srcport MIN MAX ]\n"
-		"                 [ [no]learning ]\n"
-		"                 [ [no]proxy ]\n"
-		"                 [ [no]rsc ]\n"
-		"                 [ [no]l2miss ]\n"
-		"                 [ [no]l3miss ]\n"
-		"                 [ ageing SECONDS ]\n"
-		"                 [ maxaddress NUMBER ]\n"
-		"                 [ [no]udpcsum ]\n"
-		"                 [ [no]udp6zerocsumtx ]\n"
-		"                 [ [no]udp6zerocsumrx ]\n"
-		"                 [ [no]remcsumtx ] [ [no]remcsumrx ]\n"
-		"                 [ [no]external ] [ gbp ] [ gpe ]\n"
+		"		[ { group | remote } IP_ADDRESS ]\n"
+		"		[ local ADDR ]\n"
+		"		[ ttl TTL ]\n"
+		"		[ tos TOS ]\n"
+		"		[ df DF ]\n"
+		"		[ flowlabel LABEL ]\n"
+		"		[ dev PHYS_DEV ]\n"
+		"		[ dstport PORT ]\n"
+		"		[ srcport MIN MAX ]\n"
+		"		[ [no]learning ]\n"
+		"		[ [no]proxy ]\n"
+		"		[ [no]rsc ]\n"
+		"		[ [no]l2miss ]\n"
+		"		[ [no]l3miss ]\n"
+		"		[ ageing SECONDS ]\n"
+		"		[ maxaddress NUMBER ]\n"
+		"		[ [no]udpcsum ]\n"
+		"		[ [no]udp6zerocsumtx ]\n"
+		"		[ [no]udp6zerocsumrx ]\n"
+		"		[ [no]remcsumtx ] [ [no]remcsumrx ]\n"
+		"		[ [no]external ] [ gbp ] [ gpe ]\n"
 		"\n"
-		"Where: VNI   := 0-16777215\n"
-		"       ADDR  := { IP_ADDRESS | any }\n"
-		"       TOS   := { NUMBER | inherit }\n"
-		"       TTL   := { 1..255 | auto | inherit }\n"
-		"       DF    := { unset | set | inherit }\n"
-		"       LABEL := 0-1048575\n"
+		"Where:	VNI	:= 0-16777215\n"
+		"	ADDR	:= { IP_ADDRESS | any }\n"
+		"	TOS	:= { NUMBER | inherit }\n"
+		"	TTL	:= { 1..255 | auto | inherit }\n"
+		"	DF	:= { unset | set | inherit }\n"
+		"	LABEL := 0-1048575\n"
 	);
 }
 
diff --git a/ip/ipmaddr.c b/ip/ipmaddr.c
index 105b23a8..3400e055 100644
--- a/ip/ipmaddr.c
+++ b/ip/ipmaddr.c
@@ -39,8 +39,9 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip maddr [ add | del ] MULTIADDR dev STRING\n");
-	fprintf(stderr, "       ip maddr show [ dev STRING ]\n");
+	fprintf(stderr,
+		"Usage: ip maddr [ add | del ] MULTIADDR dev STRING\n"
+		"       ip maddr show [ dev STRING ]\n");
 	exit(-1);
 }
 
diff --git a/ip/ipmonitor.c b/ip/ipmonitor.c
index 743632cc..9ecc7fd2 100644
--- a/ip/ipmonitor.c
+++ b/ip/ipmonitor.c
@@ -29,10 +29,11 @@ int listen_all_nsid;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip monitor [ all | LISTofOBJECTS ] [ FILE ] [ label ] [all-nsid] [dev DEVICE]\n");
-	fprintf(stderr, "LISTofOBJECTS := link | address | route | mroute | prefix |\n");
-	fprintf(stderr, "                 neigh | netconf | rule | nsid\n");
-	fprintf(stderr, "FILE := file FILENAME\n");
+	fprintf(stderr,
+		"Usage: ip monitor [ all | LISTofOBJECTS ] [ FILE ] [ label ] [all-nsid] [dev DEVICE]\n"
+		"LISTofOBJECTS := link | address | route | mroute | prefix |\n"
+		"		 neigh | netconf | rule | nsid\n"
+		"FILE := file FILENAME\n");
 	exit(-1);
 }
 
diff --git a/ip/ipmroute.c b/ip/ipmroute.c
index 6cf91fe9..8b3c4c25 100644
--- a/ip/ipmroute.c
+++ b/ip/ipmroute.c
@@ -35,12 +35,14 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip mroute show [ [ to ] PREFIX ] [ from PREFIX ] [ iif DEVICE ]\n");
-	fprintf(stderr, "                      [ table TABLE_ID ]\n");
-	fprintf(stderr, "TABLE_ID := [ local | main | default | all | NUMBER ]\n");
+	fprintf(stderr,
+		"Usage: ip mroute show [ [ to ] PREFIX ] [ from PREFIX ] [ iif DEVICE ]\n"
+	"			[ table TABLE_ID ]\n"
+	"TABLE_ID := [ local | main | default | all | NUMBER ]\n"
 #if 0
-	fprintf(stderr, "Usage: ip mroute [ add | del ] DESTINATION from SOURCE [ iif DEVICE ] [ oif DEVICE ]\n");
+	"Usage: ip mroute [ add | del ] DESTINATION from SOURCE [ iif DEVICE ] [ oif DEVICE ]\n"
 #endif
+	);
 	exit(-1);
 }
 
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 27986ff7..a3869c84 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -48,13 +48,16 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip neigh { add | del | change | replace }\n"
-			"                { ADDR [ lladdr LLADDR ] [ nud STATE ] | proxy ADDR } [ dev DEV ]\n");
-	fprintf(stderr, "                [ router ] [ extern_learn ] [ protocol PROTO ]\n\n");
-	fprintf(stderr, "       ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n");
-	fprintf(stderr, "                                 [ vrf NAME ]\n\n");
-	fprintf(stderr, "STATE := { permanent | noarp | stale | reachable | none |\n"
-			"           incomplete | delay | probe | failed }\n");
+	fprintf(stderr,
+		"Usage: ip neigh { add | del | change | replace }\n"
+		"		{ ADDR [ lladdr LLADDR ] [ nud STATE ] | proxy ADDR } [ dev DEV ]\n"
+		"		[ router ] [ extern_learn ] [ protocol PROTO ]\n"
+		"\n"
+		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
+		"				  [ vrf NAME ]\n"
+		"\n"
+		"STATE := { permanent | noarp | stale | reachable | none |\n"
+		"           incomplete | delay | probe | failed }\n");
 	exit(-1);
 }
 
diff --git a/ip/ipnetns.c b/ip/ipnetns.c
index 52aefacf..db11fdb2 100644
--- a/ip/ipnetns.c
+++ b/ip/ipnetns.c
@@ -26,17 +26,18 @@
 
 static int usage(void)
 {
-	fprintf(stderr, "Usage: ip netns list\n");
-	fprintf(stderr, "       ip netns add NAME\n");
-	fprintf(stderr, "       ip netns attach NAME PID\n");
-	fprintf(stderr, "       ip netns set NAME NETNSID\n");
-	fprintf(stderr, "       ip [-all] netns delete [NAME]\n");
-	fprintf(stderr, "       ip netns identify [PID]\n");
-	fprintf(stderr, "       ip netns pids NAME\n");
-	fprintf(stderr, "       ip [-all] netns exec [NAME] cmd ...\n");
-	fprintf(stderr, "       ip netns monitor\n");
-	fprintf(stderr, "       ip netns list-id\n");
-	fprintf(stderr, "NETNSID := auto | POSITIVE-INT\n");
+	fprintf(stderr,
+		"Usage:	ip netns list\n"
+		"	ip netns add NAME\n"
+		"	ip netns attach NAME PID\n"
+		"	ip netns set NAME NETNSID\n"
+		"	ip [-all] netns delete [NAME]\n"
+		"	ip netns identify [PID]\n"
+		"	ip netns pids NAME\n"
+		"	ip [-all] netns exec [NAME] cmd ...\n"
+		"	ip netns monitor\n"
+		"	ip netns list-id\n"
+		"NETNSID := auto | POSITIVE-INT\n");
 	exit(-1);
 }
 
diff --git a/ip/ipntable.c b/ip/ipntable.c
index 50fc949f..ddee4905 100644
--- a/ip/ipntable.c
+++ b/ip/ipntable.c
@@ -47,15 +47,15 @@ static void usage(void)
 {
 	fprintf(stderr,
 		"Usage: ip ntable change name NAME [ dev DEV ]\n"
-		"          [ thresh1 VAL ] [ thresh2 VAL ] [ thresh3 VAL ] [ gc_int MSEC ]\n"
-		"          [ PARMS ]\n"
+		"	 [ thresh1 VAL ] [ thresh2 VAL ] [ thresh3 VAL ] [ gc_int MSEC ]\n"
+		"	 [ PARMS ]\n"
 		"Usage: ip ntable show [ dev DEV ] [ name NAME ]\n"
 
 		"PARMS := [ base_reachable MSEC ] [ retrans MSEC ] [ gc_stale MSEC ]\n"
-		"         [ delay_probe MSEC ] [ queue LEN ]\n"
-		"         [ app_probes VAL ] [ ucast_probes VAL ] [ mcast_probes VAL ]\n"
-		"         [ anycast_delay MSEC ] [ proxy_delay MSEC ] [ proxy_queue LEN ]\n"
-		"         [ locktime MSEC ]\n"
+		"	 [ delay_probe MSEC ] [ queue LEN ]\n"
+		"	 [ app_probes VAL ] [ ucast_probes VAL ] [ mcast_probes VAL ]\n"
+		"	 [ anycast_delay MSEC ] [ proxy_delay MSEC ] [ proxy_queue LEN ]\n"
+		"	 [ locktime MSEC ]\n"
 		);
 
 	exit(-1);
diff --git a/ip/ipseg6.c b/ip/ipseg6.c
index 33076e72..56a76996 100644
--- a/ip/ipseg6.c
+++ b/ip/ipseg6.c
@@ -32,12 +32,13 @@
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip sr { COMMAND | help }\n");
-	fprintf(stderr, "	   ip sr hmac show\n");
-	fprintf(stderr, "	   ip sr hmac set KEYID ALGO\n");
-	fprintf(stderr, "	   ip sr tunsrc show\n");
-	fprintf(stderr, "	   ip sr tunsrc set ADDRESS\n");
-	fprintf(stderr, "where  ALGO := { sha1 | sha256 }\n");
+	fprintf(stderr,
+		"Usage: ip sr { COMMAND | help }\n"
+		"	   ip sr hmac show\n"
+		"	   ip sr hmac set KEYID ALGO\n"
+		"	   ip sr tunsrc show\n"
+		"	   ip sr tunsrc set ADDRESS\n"
+		"where  ALGO := { sha1 | sha256 }\n");
 	exit(-1);
 }
 
diff --git a/ip/iptunnel.c b/ip/iptunnel.c
index d597908f..92a5cb92 100644
--- a/ip/iptunnel.c
+++ b/ip/iptunnel.c
@@ -32,18 +32,19 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip tunnel { add | change | del | show | prl | 6rd } [ NAME ]\n");
-	fprintf(stderr, "          [ mode { ipip | gre | sit | isatap | vti } ] [ remote ADDR ] [ local ADDR ]\n");
-	fprintf(stderr, "          [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n");
-	fprintf(stderr, "          [ prl-default ADDR ] [ prl-nodefault ADDR ] [ prl-delete ADDR ]\n");
-	fprintf(stderr, "          [ 6rd-prefix ADDR ] [ 6rd-relay_prefix ADDR ] [ 6rd-reset ]\n");
-	fprintf(stderr, "          [ ttl TTL ] [ tos TOS ] [ [no]pmtudisc ] [ dev PHYS_DEV ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where: NAME := STRING\n");
-	fprintf(stderr, "       ADDR := { IP_ADDRESS | any }\n");
-	fprintf(stderr, "       TOS  := { STRING | 00..ff | inherit | inherit/STRING | inherit/00..ff }\n");
-	fprintf(stderr, "       TTL  := { 1..255 | inherit }\n");
-	fprintf(stderr, "       KEY  := { DOTTED_QUAD | NUMBER }\n");
+	fprintf(stderr,
+		"Usage: ip tunnel { add | change | del | show | prl | 6rd } [ NAME ]\n"
+		"	 [ mode { ipip | gre | sit | isatap | vti } ] [ remote ADDR ] [ local ADDR ]\n"
+		"	 [ [i|o]seq ] [ [i|o]key KEY ] [ [i|o]csum ]\n"
+		"	 [ prl-default ADDR ] [ prl-nodefault ADDR ] [ prl-delete ADDR ]\n"
+		"	 [ 6rd-prefix ADDR ] [ 6rd-relay_prefix ADDR ] [ 6rd-reset ]\n"
+		"	 [ ttl TTL ] [ tos TOS ] [ [no]pmtudisc ] [ dev PHYS_DEV ]\n"
+		"\n"
+		"Where:	NAME := STRING\n"
+		"	ADDR := { IP_ADDRESS | any }\n"
+		"	TOS  := { STRING | 00..ff | inherit | inherit/STRING | inherit/00..ff }\n"
+		"	TTL  := { 1..255 | inherit }\n"
+		"	KEY  := { DOTTED_QUAD | NUMBER }\n");
 	exit(-1);
 }
 
diff --git a/ip/iptuntap.c b/ip/iptuntap.c
index 03238c3f..82e38499 100644
--- a/ip/iptuntap.c
+++ b/ip/iptuntap.c
@@ -40,12 +40,13 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip tuntap { add | del | show | list | lst | help } [ dev PHYS_DEV ]\n");
-	fprintf(stderr, "          [ mode { tun | tap } ] [ user USER ] [ group GROUP ]\n");
-	fprintf(stderr, "          [ one_queue ] [ pi ] [ vnet_hdr ] [ multi_queue ] [ name NAME ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where: USER  := { STRING | NUMBER }\n");
-	fprintf(stderr, "       GROUP := { STRING | NUMBER }\n");
+	fprintf(stderr,
+		"Usage: ip tuntap { add | del | show | list | lst | help } [ dev PHYS_DEV ]\n"
+		"	[ mode { tun | tap } ] [ user USER ] [ group GROUP ]\n"
+		"	[ one_queue ] [ pi ] [ vnet_hdr ] [ multi_queue ] [ name NAME ]\n"
+		"\n"
+		"Where:	USER  := { STRING | NUMBER }\n"
+		"	GROUP := { STRING | NUMBER }\n");
 	exit(-1);
 }
 
diff --git a/ip/ipvrf.c b/ip/ipvrf.c
index 08a0d45b..a13cf653 100644
--- a/ip/ipvrf.c
+++ b/ip/ipvrf.c
@@ -36,10 +36,11 @@ static struct link_filter vrf_filter;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip vrf show [NAME] ...\n");
-	fprintf(stderr, "       ip vrf exec [NAME] cmd ...\n");
-	fprintf(stderr, "       ip vrf identify [PID]\n");
-	fprintf(stderr, "       ip vrf pids [NAME]\n");
+	fprintf(stderr,
+		"Usage:	ip vrf show [NAME] ...\n"
+		"	ip vrf exec [NAME] cmd ...\n"
+		"	ip vrf identify [PID]\n"
+		"	ip vrf pids [NAME]\n");
 
 	exit(-1);
 }
diff --git a/ip/link_gre.c b/ip/link_gre.c
index 842fab5c..15beb737 100644
--- a/ip/link_gre.c
+++ b/ip/link_gre.c
@@ -26,41 +26,36 @@
 static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %-9s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                     [ local ADDR ]\n"
-		"                     [ [no][i|o]seq ]\n"
-		"                     [ [i|o]key KEY | no[i|o]key ]\n"
-		"                     [ [no][i|o]csum ]\n"
-		"                     [ ttl TTL ]\n"
-		"                     [ tos TOS ]\n"
-		"                     [ [no]pmtudisc ]\n"
-		"                     [ [no]ignore-df ]\n"
-		"                     [ dev PHYS_DEV ]\n"
-		"                     [ fwmark MARK ]\n"
-		"                     [ external ]\n"
-		"                     [ noencap ]\n"
-		"                     [ encap { fou | gue | none } ]\n"
-		"                     [ encap-sport PORT ]\n"
-		"                     [ encap-dport PORT ]\n"
-		"                     [ [no]encap-csum ]\n"
-		"                     [ [no]encap-csum6 ]\n"
-		"                     [ [no]encap-remcsum ]\n"
-		"                     [ erspan_ver version ]\n"
-		"                     [ erspan IDX ]\n"
-		"                     [ erspan_dir { ingress | egress } ]\n"
-		"                     [ erspan_hwid hwid ]\n"
+		"Usage: ... %-9s	[ remote ADDR ]\n"
+		"			[ local ADDR ]\n"
+		"			[ [no][i|o]seq ]\n"
+		"			[ [i|o]key KEY | no[i|o]key ]\n"
+		"			[ [no][i|o]csum ]\n"
+		"			[ ttl TTL ]\n"
+		"			[ tos TOS ]\n"
+		"			[ [no]pmtudisc ]\n"
+		"			[ [no]ignore-df ]\n"
+		"			[ dev PHYS_DEV ]\n"
+		"			[ fwmark MARK ]\n"
+		"			[ external ]\n"
+		"			[ noencap ]\n"
+		"			[ encap { fou | gue | none } ]\n"
+		"			[ encap-sport PORT ]\n"
+		"			[ encap-dport PORT ]\n"
+		"			[ [no]encap-csum ]\n"
+		"			[ [no]encap-csum6 ]\n"
+		"			[ [no]encap-remcsum ]\n"
+		"			[ erspan_ver version ]\n"
+		"			[ erspan IDX ]\n"
+		"			[ erspan_dir { ingress | egress } ]\n"
+		"			[ erspan_hwid hwid ]\n"
 		"\n"
-	);
-	fprintf(f,
-		"Where: ADDR := { IP_ADDRESS | any }\n"
-		"       TOS  := { NUMBER | inherit }\n"
-		"       TTL  := { 1..255 | inherit }\n"
-		"       KEY  := { DOTTED_QUAD | NUMBER }\n"
-		"       MARK := { 0x0..0xffffffff }\n"
-	);
+		"Where:	ADDR := { IP_ADDRESS | any }\n"
+		"	TOS  := { NUMBER | inherit }\n"
+		"	TTL  := { 1..255 | inherit }\n"
+		"	KEY  := { DOTTED_QUAD | NUMBER }\n"
+		"	MARK := { 0x0..0xffffffff }\n",
+		lu->id);
 }
 
 static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_gre6.c b/ip/link_gre6.c
index 4710b404..9d1741bf 100644
--- a/ip/link_gre6.c
+++ b/ip/link_gre6.c
@@ -33,46 +33,41 @@
 static void gre_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %-9s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                     [ local ADDR ]\n"
-		"                     [ [no][i|o]seq ]\n"
-		"                     [ [i|o]key KEY | no[i|o]key ]\n"
-		"                     [ [no][i|o]csum ]\n"
-		"                     [ hoplimit TTL ]\n"
-		"                     [ encaplimit ELIM ]\n"
-		"                     [ tclass TCLASS ]\n"
-		"                     [ flowlabel FLOWLABEL ]\n"
-		"                     [ dscp inherit ]\n"
-		"                     [ dev PHYS_DEV ]\n"
-		"                     [ fwmark MARK ]\n"
-		"                     [ [no]allow-localremote ]\n"
-		"                     [ external ]\n"
-		"                     [ noencap ]\n"
-		"                     [ encap { fou | gue | none } ]\n"
-		"                     [ encap-sport PORT ]\n"
-		"                     [ encap-dport PORT ]\n"
-		"                     [ [no]encap-csum ]\n"
-		"                     [ [no]encap-csum6 ]\n"
-		"                     [ [no]encap-remcsum ]\n"
-		"                     [ erspan_ver version ]\n"
-		"                     [ erspan IDX ]\n"
-		"                     [ erspan_dir { ingress | egress } ]\n"
-		"                     [ erspan_hwid hwid ]\n"
+		"Usage: ... %-9s	[ remote ADDR ]\n"
+		"			[ local ADDR ]\n"
+		"			[ [no][i|o]seq ]\n"
+		"			[ [i|o]key KEY | no[i|o]key ]\n"
+		"			[ [no][i|o]csum ]\n"
+		"			[ hoplimit TTL ]\n"
+		"			[ encaplimit ELIM ]\n"
+		"			[ tclass TCLASS ]\n"
+		"			[ flowlabel FLOWLABEL ]\n"
+		"			[ dscp inherit ]\n"
+		"			[ dev PHYS_DEV ]\n"
+		"			[ fwmark MARK ]\n"
+		"			[ [no]allow-localremote ]\n"
+		"			[ external ]\n"
+		"			[ noencap ]\n"
+		"			[ encap { fou | gue | none } ]\n"
+		"			[ encap-sport PORT ]\n"
+		"			[ encap-dport PORT ]\n"
+		"			[ [no]encap-csum ]\n"
+		"			[ [no]encap-csum6 ]\n"
+		"			[ [no]encap-remcsum ]\n"
+		"			[ erspan_ver version ]\n"
+		"			[ erspan IDX ]\n"
+		"			[ erspan_dir { ingress | egress } ]\n"
+		"			[ erspan_hwid hwid ]\n"
 		"\n"
-	);
-	fprintf(f,
-		"Where: ADDR      := IPV6_ADDRESS\n"
-		"       TTL       := { 0..255 } (default=%d)\n"
-		"       KEY       := { DOTTED_QUAD | NUMBER }\n"
-		"       ELIM      := { none | 0..255 }(default=%d)\n"
-		"       TCLASS    := { 0x0..0xff | inherit }\n"
-		"       FLOWLABEL := { 0x0..0xfffff | inherit }\n"
-		"       MARK      := { 0x0..0xffffffff | inherit }\n",
-		DEFAULT_TNL_HOP_LIMIT, IPV6_DEFAULT_TNL_ENCAP_LIMIT
-	);
+		"Where:	ADDR	  := IPV6_ADDRESS\n"
+		"	TTL	  := { 0..255 } (default=%d)\n"
+		"	KEY	  := { DOTTED_QUAD | NUMBER }\n"
+		"	ELIM	  := { none | 0..255 }(default=%d)\n"
+		"	TCLASS	  := { 0x0..0xff | inherit }\n"
+		"	FLOWLABEL := { 0x0..0xfffff | inherit }\n"
+		"	MARK	  := { 0x0..0xffffffff | inherit }\n",
+		lu->id,
+		DEFAULT_TNL_HOP_LIMIT, IPV6_DEFAULT_TNL_ENCAP_LIMIT);
 }
 
 static int gre_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_ip6tnl.c b/ip/link_ip6tnl.c
index 8d9feab1..c7b49b02 100644
--- a/ip/link_ip6tnl.c
+++ b/ip/link_ip6tnl.c
@@ -32,46 +32,35 @@
 static void ip6tunnel_print_help(struct link_util *lu, int argc, char **argv,
 				 FILE *f)
 {
-	const char *mode;
-
-	fprintf(f,
-		"Usage: ... %-6s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                  [ local ADDR ]\n"
-		"                  [ encaplimit ELIM ]\n"
-		"                  [ hoplimit HLIM ]\n"
-		"                  [ tclass TCLASS ]\n"
-		"                  [ flowlabel FLOWLABEL ]\n"
-		"                  [ dscp inherit ]\n"
-		"                  [ [no]allow-localremote ]\n"
-		"                  [ dev PHYS_DEV ]\n"
-		"                  [ fwmark MARK ]\n"
-		"                  [ external ]\n"
-		"                  [ noencap ]\n"
-		"                  [ encap { fou | gue | none } ]\n"
-		"                  [ encap-sport PORT ]\n"
-		"                  [ encap-dport PORT ]\n"
-		"                  [ [no]encap-csum ]\n"
-		"                  [ [no]encap-csum6 ]\n"
-		"                  [ [no]encap-remcsum ]\n"
-	);
-	mode = "{ ip6ip6 | ipip6 | any }";
-	fprintf(f,
-		"                  [ mode %s ]\n"
-		"\n",
-		mode
-	);
 	fprintf(f,
-		"Where: ADDR      := IPV6_ADDRESS\n"
-		"       ELIM      := { none | 0..255 }(default=%d)\n"
-		"       HLIM      := 0..255 (default=%d)\n"
-		"       TCLASS    := { 0x0..0xff | inherit }\n"
-		"       FLOWLABEL := { 0x0..0xfffff | inherit }\n"
-		"       MARK      := { 0x0..0xffffffff | inherit }\n",
-		IPV6_DEFAULT_TNL_ENCAP_LIMIT, DEFAULT_TNL_HOP_LIMIT
-	);
+		"Usage: ... %-6s	[ remote ADDR ]\n"
+		"			[ local ADDR ]\n"
+		"			[ encaplimit ELIM ]\n"
+		"			[ hoplimit HLIM ]\n"
+		"			[ tclass TCLASS ]\n"
+		"			[ flowlabel FLOWLABEL ]\n"
+		"			[ dscp inherit ]\n"
+		"			[ [no]allow-localremote ]\n"
+		"			[ dev PHYS_DEV ]\n"
+		"			[ fwmark MARK ]\n"
+		"			[ external ]\n"
+		"			[ noencap ]\n"
+		"			[ encap { fou | gue | none } ]\n"
+		"			[ encap-sport PORT ]\n"
+		"			[ encap-dport PORT ]\n"
+		"			[ [no]encap-csum ]\n"
+		"			[ [no]encap-csum6 ]\n"
+		"			[ [no]encap-remcsum ]\n"
+		"			[ mode { ip6ip6 | ipip6 | any } ]\n"
+		"\n"
+		"Where:	ADDR	  := IPV6_ADDRESS\n"
+		"	ELIM	  := { none | 0..255 }(default=%d)\n"
+		"	HLIM	  := 0..255 (default=%d)\n"
+		"	TCLASS    := { 0x0..0xff | inherit }\n"
+		"	FLOWLABEL := { 0x0..0xfffff | inherit }\n"
+		"	MARK	  := { 0x0..0xffffffff | inherit }\n",
+		lu->id,
+		IPV6_DEFAULT_TNL_ENCAP_LIMIT, DEFAULT_TNL_HOP_LIMIT);
 }
 
 static int ip6tunnel_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_iptnl.c b/ip/link_iptnl.c
index 2736ef89..636cdb2c 100644
--- a/ip/link_iptnl.c
+++ b/ip/link_iptnl.c
@@ -29,46 +29,39 @@ static void iptunnel_print_help(struct link_util *lu, int argc, char **argv,
 {
 	const char *mode;
 
-	fprintf(f,
-		"Usage: ... %-6s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                  [ local ADDR ]\n"
-		"                  [ ttl TTL ]\n"
-		"                  [ tos TOS ]\n"
-		"                  [ [no]pmtudisc ]\n"
-		"                  [ 6rd-prefix ADDR ]\n"
-		"                  [ 6rd-relay_prefix ADDR ]\n"
-		"                  [ 6rd-reset ]\n"
-		"                  [ dev PHYS_DEV ]\n"
-		"                  [ fwmark MARK ]\n"
-		"                  [ external ]\n"
-		"                  [ noencap ]\n"
-		"                  [ encap { fou | gue | none } ]\n"
-		"                  [ encap-sport PORT ]\n"
-		"                  [ encap-dport PORT ]\n"
-		"                  [ [no]encap-csum ]\n"
-		"                  [ [no]encap-csum6 ]\n"
-		"                  [ [no]encap-remcsum ]\n"
-	);
 	if (strcmp(lu->id, "sit") == 0) {
-		mode = "{ ip6ip | ipip | mplsip | any } ]\n"
-		"                  [ isatap";
+		mode =	"{ ip6ip | ipip | mplsip | any } ]\n"
+			"			[ isatap";
 	} else {
 		mode = "{ ipip | mplsip | any }";
 	}
+
 	fprintf(f,
-		"                  [ mode %s ]\n"
-		"\n",
-		mode
-	);
-	fprintf(f,
-		"Where: ADDR := { IP_ADDRESS | any }\n"
-		"       TOS  := { NUMBER | inherit }\n"
-		"       TTL  := { 1..255 | inherit }\n"
-		"       MARK := { 0x0..0xffffffff }\n"
-	);
+		"Usage: ... %-6s	[ remote ADDR ]\n"
+		"			[ local ADDR ]\n"
+		"			[ ttl TTL ]\n"
+		"			[ tos TOS ]\n"
+		"			[ [no]pmtudisc ]\n"
+		"			[ 6rd-prefix ADDR ]\n"
+		"			[ 6rd-relay_prefix ADDR ]\n"
+		"			[ 6rd-reset ]\n"
+		"			[ dev PHYS_DEV ]\n"
+		"			[ fwmark MARK ]\n"
+		"			[ external ]\n"
+		"			[ noencap ]\n"
+		"			[ encap { fou | gue | none } ]\n"
+		"			[ encap-sport PORT ]\n"
+		"			[ encap-dport PORT ]\n"
+		"			[ [no]encap-csum ]\n"
+		"			[ [no]encap-csum6 ]\n"
+		"			[ [no]encap-remcsum ]\n"
+		"			[ mode %s ]\n"
+		"\n"
+		"Where:	ADDR := { IP_ADDRESS | any }\n"
+		"	TOS  := { NUMBER | inherit }\n"
+		"	TTL  := { 1..255 | inherit }\n"
+		"	MARK := { 0x0..0xffffffff }\n",
+		lu->id, mode);
 }
 
 static int iptunnel_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_vti.c b/ip/link_vti.c
index b974c62b..3a52ea87 100644
--- a/ip/link_vti.c
+++ b/ip/link_vti.c
@@ -26,22 +26,16 @@
 static void vti_print_help(struct link_util *lu, int argc, char **argv, FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %-4s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                [ local ADDR ]\n"
-		"                [ [i|o]key KEY ]\n"
-		"                [ dev PHYS_DEV ]\n"
-		"                [ fwmark MARK ]\n"
+		"Usage: ... %-4s	[ remote ADDR ]\n"
+		"		[ local ADDR ]\n"
+		"		[ [i|o]key KEY ]\n"
+		"		[ dev PHYS_DEV ]\n"
+		"		[ fwmark MARK ]\n"
 		"\n"
-	);
-	fprintf(f,
-		"Where: ADDR := { IP%s_ADDRESS }\n"
-		"       KEY  := { DOTTED_QUAD | NUMBER }\n"
-		"       MARK := { 0x0..0xffffffff }\n",
-		""
-	);
+		"Where:	ADDR := { IP_ADDRESS }\n"
+		"	KEY  := { DOTTED_QUAD | NUMBER }\n"
+		"	MARK := { 0x0..0xffffffff }\n",
+		lu->id);
 }
 
 static int vti_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_vti6.c b/ip/link_vti6.c
index f13c0858..0b080fa9 100644
--- a/ip/link_vti6.c
+++ b/ip/link_vti6.c
@@ -28,22 +28,16 @@ static void vti6_print_help(struct link_util *lu, int argc, char **argv,
 			    FILE *f)
 {
 	fprintf(f,
-		"Usage: ... %-4s [ remote ADDR ]\n",
-		lu->id
-	);
-	fprintf(f,
-		"                [ local ADDR ]\n"
-		"                [ [i|o]key KEY ]\n"
-		"                [ dev PHYS_DEV ]\n"
-		"                [ fwmark MARK ]\n"
+		"Usage: ... %-4s	[ remote ADDR ]\n"
+		"		[ local ADDR ]\n"
+		"		[ [i|o]key KEY ]\n"
+		"		[ dev PHYS_DEV ]\n"
+		"		[ fwmark MARK ]\n"
 		"\n"
-	);
-	fprintf(f,
-		"Where: ADDR := { IP%s_ADDRESS }\n"
-		"       KEY  := { DOTTED_QUAD | NUMBER }\n"
-		"       MARK := { 0x0..0xffffffff }\n",
-		"V6"
-	);
+		"Where:	ADDR := { IPV6_ADDRESS }\n"
+		"	KEY  := { DOTTED_QUAD | NUMBER }\n"
+		"	MARK := { 0x0..0xffffffff }\n",
+		lu->id);
 }
 
 static int vti6_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/link_xfrm.c b/ip/link_xfrm.c
index 79a902fd..7a3285b4 100644
--- a/ip/link_xfrm.c
+++ b/ip/link_xfrm.c
@@ -16,8 +16,11 @@
 static void xfrm_print_help(struct link_util *lu, int argc, char **argv,
 			    FILE *f)
 {
-	fprintf(f, "Usage: ... %-4s dev PHYS_DEV [ if_id IF-ID ]\n", lu->id);
-	fprintf(f, "\nWhere: IF-ID := { 0x0..0xffffffff }\n");
+	fprintf(f,
+		"Usage: ... %-4s dev PHYS_DEV [ if_id IF-ID ]\n"
+		"\n"
+		"Where: IF-ID := { 0x0..0xffffffff }\n",
+		lu->id);
 }
 
 static int xfrm_parse_opt(struct link_util *lu, int argc, char **argv,
diff --git a/ip/rtmon.c b/ip/rtmon.c
index 7373443f..bccddedd 100644
--- a/ip/rtmon.c
+++ b/ip/rtmon.c
@@ -62,10 +62,11 @@ static int dump_msg2(struct nlmsghdr *n, void *arg)
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: rtmon [ OPTIONS ] file FILE [ all | LISTofOBJECTS ]\n");
-	fprintf(stderr, "OPTIONS := { -f[amily] { inet | inet6 | link | help } |\n"
-			"             -4 | -6 | -0 | -V[ersion] }\n");
-	fprintf(stderr, "LISTofOBJECTS := [ link ] [ address ] [ route ]\n");
+	fprintf(stderr,
+		"Usage: rtmon [ OPTIONS ] file FILE [ all | LISTofOBJECTS ]\n"
+		"OPTIONS := { -f[amily] { inet | inet6 | link | help } |\n"
+		"	     -4 | -6 | -0 | -V[ersion] }\n"
+		"LISTofOBJECTS := [ link ] [ address ] [ route ]\n");
 	exit(-1);
 }
 
diff --git a/ip/tcp_metrics.c b/ip/tcp_metrics.c
index 72ef3ab5..acbd745a 100644
--- a/ip/tcp_metrics.c
+++ b/ip/tcp_metrics.c
@@ -28,10 +28,11 @@
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip tcp_metrics/tcpmetrics { COMMAND | help }\n");
-	fprintf(stderr, "       ip tcp_metrics { show | flush } SELECTOR\n");
-	fprintf(stderr, "       ip tcp_metrics delete [ address ] ADDRESS\n");
-	fprintf(stderr, "SELECTOR := [ [ address ] PREFIX ]\n");
+	fprintf(stderr,
+		"Usage:	ip tcp_metrics/tcpmetrics { COMMAND | help }\n"
+		"	ip tcp_metrics { show | flush } SELECTOR\n"
+		"	ip tcp_metrics delete [ address ] ADDRESS\n"
+		"SELECTOR := [ [ address ] PREFIX ]\n");
 	exit(-1);
 }
 
diff --git a/ip/xfrm_monitor.c b/ip/xfrm_monitor.c
index 17117f41..e34b5fbd 100644
--- a/ip/xfrm_monitor.c
+++ b/ip/xfrm_monitor.c
@@ -39,8 +39,9 @@ static bool nokeys;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip xfrm monitor [ nokeys ] [ all-nsid ] [ all | OBJECTS | help ]\n");
-	fprintf(stderr, "OBJECTS := { acquire | expire | SA | aevent | policy | report }\n");
+	fprintf(stderr,
+		"Usage: ip xfrm monitor [ nokeys ] [ all-nsid ] [ all | OBJECTS | help ]\n"
+		"OBJECTS := { acquire | expire | SA | aevent | policy | report }\n");
 	exit(-1);
 }
 
diff --git a/ip/xfrm_policy.c b/ip/xfrm_policy.c
index 98984350..7c0233c1 100644
--- a/ip/xfrm_policy.c
+++ b/ip/xfrm_policy.c
@@ -52,51 +52,60 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip xfrm policy { add | update } SELECTOR dir DIR [ ctx CTX ]\n");
-	fprintf(stderr, "        [ mark MARK [ mask MASK ] ] [ index INDEX ] [ ptype PTYPE ]\n");
-	fprintf(stderr, "        [ action ACTION ] [ priority PRIORITY ] [ flag FLAG-LIST ]\n");
-	fprintf(stderr, "        [ if_id IF_ID ] [ LIMIT-LIST ] [ TMPL-LIST ]\n");
-	fprintf(stderr, "Usage: ip xfrm policy { delete | get } { SELECTOR | index INDEX } dir DIR\n");
-	fprintf(stderr, "        [ ctx CTX ] [ mark MARK [ mask MASK ] ] [ ptype PTYPE ]\n");
-	fprintf(stderr, "Usage: ip xfrm policy { deleteall | list } [ nosock ] [ SELECTOR ] [ dir DIR ]\n");
-	fprintf(stderr, "        [ index INDEX ] [ ptype PTYPE ] [ action ACTION ] [ priority PRIORITY ]\n");
-	fprintf(stderr, "        [ flag FLAG-LIST ]\n");
-	fprintf(stderr, "Usage: ip xfrm policy flush [ ptype PTYPE ]\n");
-	fprintf(stderr, "Usage: ip xfrm policy count\n");
-	fprintf(stderr, "Usage: ip xfrm policy set [ hthresh4 LBITS RBITS ] [ hthresh6 LBITS RBITS ]\n");
-	fprintf(stderr, "SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n");
-	fprintf(stderr, "UPSPEC := proto { { ");
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_TCP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_UDP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_SCTP));
-	fprintf(stderr, "%s", strxf_proto(IPPROTO_DCCP));
-	fprintf(stderr, " } [ sport PORT ] [ dport PORT ] |\n");
-	fprintf(stderr, "                  { ");
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMPV6));
-	fprintf(stderr, "%s", strxf_proto(IPPROTO_MH));
-	fprintf(stderr, " } [ type NUMBER ] [ code NUMBER ] |\n");
-	fprintf(stderr, "                  %s", strxf_proto(IPPROTO_GRE));
-	fprintf(stderr, " [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n");
-	fprintf(stderr, "DIR := in | out | fwd\n");
-	fprintf(stderr, "PTYPE := main | sub\n");
-	fprintf(stderr, "ACTION := allow | block\n");
-	fprintf(stderr, "FLAG-LIST := [ FLAG-LIST ] FLAG\n");
-	fprintf(stderr, "FLAG := localok | icmp\n");
-	fprintf(stderr, "LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n");
-	fprintf(stderr, "LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n");
-	fprintf(stderr, "         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n");
-	fprintf(stderr, "TMPL-LIST := [ TMPL-LIST ] tmpl TMPL\n");
-	fprintf(stderr, "TMPL := ID [ mode MODE ] [ reqid REQID ] [ level LEVEL ]\n");
-	fprintf(stderr, "ID := [ src ADDR ] [ dst ADDR ] [ proto XFRM-PROTO ] [ spi SPI ]\n");
-	fprintf(stderr, "XFRM-PROTO := ");
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_ESP));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_AH));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_COMP));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_ROUTING));
-	fprintf(stderr, "%s\n", strxf_xfrmproto(IPPROTO_DSTOPTS));
-	fprintf(stderr, "MODE := transport | tunnel | beet | ro | in_trigger\n");
-	fprintf(stderr, "LEVEL := required | use\n");
+	fprintf(stderr,
+		"Usage: ip xfrm policy { add | update } SELECTOR dir DIR [ ctx CTX ]\n"
+		"	[ mark MARK [ mask MASK ] ] [ index INDEX ] [ ptype PTYPE ]\n"
+		"	[ action ACTION ] [ priority PRIORITY ] [ flag FLAG-LIST ]\n"
+		"	[ if_id IF_ID ] [ LIMIT-LIST ] [ TMPL-LIST ]\n"
+		"Usage: ip xfrm policy { delete | get } { SELECTOR | index INDEX } dir DIR\n"
+		"	[ ctx CTX ] [ mark MARK [ mask MASK ] ] [ ptype PTYPE ]\n"
+		"Usage: ip xfrm policy { deleteall | list } [ nosock ] [ SELECTOR ] [ dir DIR ]\n"
+		"	[ index INDEX ] [ ptype PTYPE ] [ action ACTION ] [ priority PRIORITY ]\n"
+		"	[ flag FLAG-LIST ]\n"
+		"Usage: ip xfrm policy flush [ ptype PTYPE ]\n"
+		"Usage: ip xfrm policy count\n"
+		"Usage: ip xfrm policy set [ hthresh4 LBITS RBITS ] [ hthresh6 LBITS RBITS ]\n"
+		"SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n"
+		"UPSPEC := proto { { ");
+	fprintf(stderr, "%s | %s | %s | %s } ",
+		strxf_proto(IPPROTO_TCP),
+		strxf_proto(IPPROTO_UDP),
+		strxf_proto(IPPROTO_SCTP),
+		strxf_proto(IPPROTO_DCCP));
+	fprintf(stderr,
+		"[ sport PORT ] [ dport PORT ] |\n"
+		"                  { %s | %s | %s } ",
+		strxf_proto(IPPROTO_ICMP),
+		strxf_proto(IPPROTO_ICMPV6),
+		strxf_proto(IPPROTO_MH));
+	fprintf(stderr,
+		"[ type NUMBER ] [ code NUMBER ] |\n"
+		"                  %s",
+		strxf_proto(IPPROTO_GRE));
+	fprintf(stderr,
+		" [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
+		"DIR := in | out | fwd\n"
+		"PTYPE := main | sub\n"
+		"ACTION := allow | block\n"
+		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
+		"FLAG := localok | icmp\n"
+		"LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n"
+		"LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n"
+		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n"
+		"TMPL-LIST := [ TMPL-LIST ] tmpl TMPL\n"
+		"TMPL := ID [ mode MODE ] [ reqid REQID ] [ level LEVEL ]\n"
+		"ID := [ src ADDR ] [ dst ADDR ] [ proto XFRM-PROTO ] [ spi SPI ]\n"
+		"XFRM-PROTO := ");
+	fprintf(stderr,
+		"%s | %s | %s | %s | %s\n",
+		strxf_xfrmproto(IPPROTO_ESP),
+		strxf_xfrmproto(IPPROTO_AH),
+		strxf_xfrmproto(IPPROTO_COMP),
+		strxf_xfrmproto(IPPROTO_ROUTING),
+		strxf_xfrmproto(IPPROTO_DSTOPTS));
+	fprintf(stderr,
+		"MODE := transport | tunnel | beet | ro | in_trigger\n"
+		"LEVEL := required | use\n");
 
 	exit(-1);
 }
diff --git a/ip/xfrm_state.c b/ip/xfrm_state.c
index f2727070..b03ccc58 100644
--- a/ip/xfrm_state.c
+++ b/ip/xfrm_state.c
@@ -54,66 +54,84 @@ static void usage(void) __attribute__((noreturn));
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ip xfrm state { add | update } ID [ ALGO-LIST ] [ mode MODE ]\n");
-	fprintf(stderr, "        [ mark MARK [ mask MASK ] ] [ reqid REQID ] [ seq SEQ ]\n");
-	fprintf(stderr, "        [ replay-window SIZE ] [ replay-seq SEQ ] [ replay-oseq SEQ ]\n");
-	fprintf(stderr, "        [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]\n");
-	fprintf(stderr, "        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n");
-	fprintf(stderr, "        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n");
-	fprintf(stderr, "        [ offload [dev DEV] dir DIR ]\n");
-	fprintf(stderr, "        [ output-mark OUTPUT-MARK ]\n");
-+	fprintf(stderr, "        [ if_id IF_ID ]\n");
-	fprintf(stderr, "Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n");
-	fprintf(stderr, "        [ reqid REQID ] [ seq SEQ ] [ min SPI max SPI ]\n");
-	fprintf(stderr, "Usage: ip xfrm state { delete | get } ID [ mark MARK [ mask MASK ] ]\n");
-	fprintf(stderr, "Usage: ip xfrm state deleteall [ ID ] [ mode MODE ] [ reqid REQID ]\n");
-	fprintf(stderr, "        [ flag FLAG-LIST ]\n");
-	fprintf(stderr, "Usage: ip xfrm state list [ nokeys ] [ ID ] [ mode MODE ] [ reqid REQID ]\n");
-	fprintf(stderr, "        [ flag FLAG-LIST ]\n");
-	fprintf(stderr, "Usage: ip xfrm state flush [ proto XFRM-PROTO ]\n");
-	fprintf(stderr, "Usage: ip xfrm state count\n");
-	fprintf(stderr, "ID := [ src ADDR ] [ dst ADDR ] [ proto XFRM-PROTO ] [ spi SPI ]\n");
-	fprintf(stderr, "XFRM-PROTO := ");
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_ESP));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_AH));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_COMP));
-	fprintf(stderr, "%s | ", strxf_xfrmproto(IPPROTO_ROUTING));
-	fprintf(stderr, "%s\n", strxf_xfrmproto(IPPROTO_DSTOPTS));
-	fprintf(stderr, "ALGO-LIST := [ ALGO-LIST ] ALGO\n");
-	fprintf(stderr, "ALGO := { ");
-	fprintf(stderr, "%s | ", strxf_algotype(XFRMA_ALG_CRYPT));
-	fprintf(stderr, "%s", strxf_algotype(XFRMA_ALG_AUTH));
-	fprintf(stderr, " } ALGO-NAME ALGO-KEYMAT |\n");
-	fprintf(stderr, "        %s", strxf_algotype(XFRMA_ALG_AUTH_TRUNC));
-	fprintf(stderr, " ALGO-NAME ALGO-KEYMAT ALGO-TRUNC-LEN |\n");
-	fprintf(stderr, "        %s", strxf_algotype(XFRMA_ALG_AEAD));
-	fprintf(stderr, " ALGO-NAME ALGO-KEYMAT ALGO-ICV-LEN |\n");
-	fprintf(stderr, "        %s", strxf_algotype(XFRMA_ALG_COMP));
-	fprintf(stderr, " ALGO-NAME\n");
-	fprintf(stderr, "MODE := transport | tunnel | beet | ro | in_trigger\n");
-	fprintf(stderr, "FLAG-LIST := [ FLAG-LIST ] FLAG\n");
-	fprintf(stderr, "FLAG := noecn | decap-dscp | nopmtudisc | wildrecv | icmp | af-unspec | align4 | esn\n");
-	fprintf(stderr, "EXTRA-FLAG-LIST := [ EXTRA-FLAG-LIST ] EXTRA-FLAG\n");
-	fprintf(stderr, "EXTRA-FLAG := dont-encap-dscp\n");
-	fprintf(stderr, "SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n");
-	fprintf(stderr, "UPSPEC := proto { { ");
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_TCP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_UDP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_SCTP));
-	fprintf(stderr, "%s", strxf_proto(IPPROTO_DCCP));
-	fprintf(stderr, " } [ sport PORT ] [ dport PORT ] |\n");
-	fprintf(stderr, "                  { ");
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMP));
-	fprintf(stderr, "%s | ", strxf_proto(IPPROTO_ICMPV6));
-	fprintf(stderr, "%s", strxf_proto(IPPROTO_MH));
-	fprintf(stderr, " } [ type NUMBER ] [ code NUMBER ] |\n");
-	fprintf(stderr, "                  %s", strxf_proto(IPPROTO_GRE));
-	fprintf(stderr, " [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n");
-	fprintf(stderr, "LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n");
-	fprintf(stderr, "LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n");
-	fprintf(stderr, "         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n");
-	fprintf(stderr, "ENCAP := { espinudp | espinudp-nonike } SPORT DPORT OADDR\n");
-	fprintf(stderr, "DIR := in | out\n");
+	fprintf(stderr,
+		"Usage: ip xfrm state { add | update } ID [ ALGO-LIST ] [ mode MODE ]\n"
+		"        [ mark MARK [ mask MASK ] ] [ reqid REQID ] [ seq SEQ ]\n"
+		"        [ replay-window SIZE ] [ replay-seq SEQ ] [ replay-oseq SEQ ]\n"
+		"        [ replay-seq-hi SEQ ] [ replay-oseq-hi SEQ ]\n"
+		"        [ flag FLAG-LIST ] [ sel SELECTOR ] [ LIMIT-LIST ] [ encap ENCAP ]\n"
+		"        [ coa ADDR[/PLEN] ] [ ctx CTX ] [ extra-flag EXTRA-FLAG-LIST ]\n"
+		"        [ offload [dev DEV] dir DIR ]\n"
+		"        [ output-mark OUTPUT-MARK ]\n"
+		"        [ if_id IF_ID ]\n"
+		"Usage: ip xfrm state allocspi ID [ mode MODE ] [ mark MARK [ mask MASK ] ]\n"
+		"        [ reqid REQID ] [ seq SEQ ] [ min SPI max SPI ]\n"
+		"Usage: ip xfrm state { delete | get } ID [ mark MARK [ mask MASK ] ]\n"
+		"Usage: ip xfrm state deleteall [ ID ] [ mode MODE ] [ reqid REQID ]\n"
+		"        [ flag FLAG-LIST ]\n"
+		"Usage: ip xfrm state list [ nokeys ] [ ID ] [ mode MODE ] [ reqid REQID ]\n"
+		"        [ flag FLAG-LIST ]\n"
+		"Usage: ip xfrm state flush [ proto XFRM-PROTO ]\n"
+		"Usage: ip xfrm state count\n"
+		"ID := [ src ADDR ] [ dst ADDR ] [ proto XFRM-PROTO ] [ spi SPI ]\n"
+		"XFRM-PROTO := ");
+	fprintf(stderr,
+		"%s | %s | %s | %s | %s\n",
+		strxf_xfrmproto(IPPROTO_ESP),
+		strxf_xfrmproto(IPPROTO_AH),
+		strxf_xfrmproto(IPPROTO_COMP),
+		strxf_xfrmproto(IPPROTO_ROUTING),
+		strxf_xfrmproto(IPPROTO_DSTOPTS));
+	fprintf(stderr,
+		"ALGO-LIST := [ ALGO-LIST ] ALGO\n"
+		"ALGO := { ");
+	fprintf(stderr,
+		"%s | %s",
+		strxf_algotype(XFRMA_ALG_CRYPT),
+		strxf_algotype(XFRMA_ALG_AUTH));
+	fprintf(stderr,
+		" } ALGO-NAME ALGO-KEYMAT |\n"
+		"        %s", strxf_algotype(XFRMA_ALG_AUTH_TRUNC));
+	fprintf(stderr,
+		" ALGO-NAME ALGO-KEYMAT ALGO-TRUNC-LEN |\n"
+		"        %s", strxf_algotype(XFRMA_ALG_AEAD));
+	fprintf(stderr,
+		" ALGO-NAME ALGO-KEYMAT ALGO-ICV-LEN |\n"
+		"        %s", strxf_algotype(XFRMA_ALG_COMP));
+	fprintf(stderr,
+		" ALGO-NAME\n"
+		"MODE := transport | tunnel | beet | ro | in_trigger\n"
+		"FLAG-LIST := [ FLAG-LIST ] FLAG\n"
+		"FLAG := noecn | decap-dscp | nopmtudisc | wildrecv | icmp | af-unspec | align4 | esn\n"
+		"EXTRA-FLAG-LIST := [ EXTRA-FLAG-LIST ] EXTRA-FLAG\n"
+		"EXTRA-FLAG := dont-encap-dscp\n"
+		"SELECTOR := [ src ADDR[/PLEN] ] [ dst ADDR[/PLEN] ] [ dev DEV ] [ UPSPEC ]\n"
+		"UPSPEC := proto { { ");
+	fprintf(stderr,
+		"%s | %s | %s | %s",
+		strxf_proto(IPPROTO_TCP),
+		strxf_proto(IPPROTO_UDP),
+		strxf_proto(IPPROTO_SCTP),
+		strxf_proto(IPPROTO_DCCP));
+	fprintf(stderr,
+		" } [ sport PORT ] [ dport PORT ] |\n"
+		"                  { ");
+	fprintf(stderr,
+		"%s | %s | %s",
+		strxf_proto(IPPROTO_ICMP),
+		strxf_proto(IPPROTO_ICMPV6),
+		strxf_proto(IPPROTO_MH));
+	fprintf(stderr,
+		" } [ type NUMBER ] [ code NUMBER ] |\n");
+	fprintf(stderr,
+		"                  %s", strxf_proto(IPPROTO_GRE));
+	fprintf(stderr,
+		" [ key { DOTTED-QUAD | NUMBER } ] | PROTO }\n"
+		"LIMIT-LIST := [ LIMIT-LIST ] limit LIMIT\n"
+		"LIMIT := { time-soft | time-hard | time-use-soft | time-use-hard } SECONDS |\n"
+		"         { byte-soft | byte-hard } SIZE | { packet-soft | packet-hard } COUNT\n"
+		"ENCAP := { espinudp | espinudp-nonike } SPORT DPORT OADDR\n"
+		"DIR := in | out\n");
 
 	exit(-1);
 }
diff --git a/misc/lnstat.c b/misc/lnstat.c
index 863fd4d9..e3c84211 100644
--- a/misc/lnstat.c
+++ b/misc/lnstat.c
@@ -55,28 +55,31 @@ static struct option opts[] = {
 
 static int usage(char *name, int exit_code)
 {
-	fprintf(stderr, "%s Version %s\n", name, LNSTAT_VERSION);
-	fprintf(stderr, "Copyright (C) 2004 by Harald Welte <laforge@gnumonks.org>\n");
-	fprintf(stderr, "This program is free software licensed under GNU GPLv2\nwith ABSOLUTELY NO WARRANTY.\n\n");
-	fprintf(stderr, "Parameters:\n");
-	fprintf(stderr, "\t-V --version\t\tPrint Version of Program\n");
-	fprintf(stderr, "\t-c --count <count>\t"
-			"Print <count> number of intervals\n");
-	fprintf(stderr, "\t-d --dump\t\t"
-			"Dump list of available files/keys\n");
-	fprintf(stderr, "\t-j --json\t\t"
-			"Display in JSON format\n");
-	fprintf(stderr, "\t-f --file <file>\tStatistics file to use\n");
-	fprintf(stderr, "\t-h --help\t\tThis help message\n");
-	fprintf(stderr, "\t-i --interval <intv>\t"
-			"Set interval to 'intv' seconds\n");
-	fprintf(stderr, "\t-k --keys k,k,k,...\tDisplay only keys specified\n");
-	fprintf(stderr, "\t-s --subject [0-2]\tControl header printing:\n");
-	fprintf(stderr, "\t\t\t\t0 = never\n");
-	fprintf(stderr, "\t\t\t\t1 = once\n");
-	fprintf(stderr, "\t\t\t\t2 = every 20 lines (default))\n");
-	fprintf(stderr, "\t-w --width n,n,n,...\tWidth for each field\n");
-	fprintf(stderr, "\n");
+	fprintf(stderr,
+		"%s Version %s\n"
+		"Copyright (C) 2004 by Harald Welte <laforge@gnumonks.org>\n"
+		"This program is free software licensed under GNU GPLv2\nwith ABSOLUTELY NO WARRANTY.\n"
+		"\n"
+		"Parameters:\n"
+		"	-V --version		Print Version of Program\n"
+		"	-c --count <count>	"
+		"Print <count> number of intervals\n"
+		"	-d --dump		"
+		"Dump list of available files/keys\n"
+		"	-j --json		"
+		"Display in JSON format\n"
+		"	-f --file <file>	Statistics file to use\n"
+		"	-h --help		This help message\n"
+		"	-i --interval <intv>	"
+		"Set interval to 'intv' seconds\n"
+		"	-k --keys k,k,k,...	Display only keys specified\n"
+		"	-s --subject [0-2]	Control header printing:\n"
+		"				0 = never\n"
+		"				1 = once\n"
+		"				2 = every 20 lines (default))\n"
+		"	-w --width n,n,n,...	Width for each field\n"
+		"\n",
+		name, LNSTAT_VERSION);
 
 	exit(exit_code);
 }
diff --git a/misc/nstat.c b/misc/nstat.c
index 653580ea..23113b22 100644
--- a/misc/nstat.c
+++ b/misc/nstat.c
@@ -528,18 +528,18 @@ static void usage(void) __attribute__((noreturn));
 static void usage(void)
 {
 	fprintf(stderr,
-"Usage: nstat [OPTION] [ PATTERN [ PATTERN ] ]\n"
-"   -h, --help           this message\n"
-"   -a, --ignore         ignore history\n"
-"   -d, --scan=SECS      sample every statistics every SECS\n"
-"   -j, --json           format output in JSON\n"
-"   -n, --nooutput       do history only\n"
-"   -p, --pretty         pretty print\n"
-"   -r, --reset          reset history\n"
-"   -s, --noupdate       don't update history\n"
-"   -t, --interval=SECS  report average over the last SECS\n"
-"   -V, --version        output version information\n"
-"   -z, --zeros          show entries with zero activity\n");
+		"Usage: nstat [OPTION] [ PATTERN [ PATTERN ] ]\n"
+		"   -h, --help		this message\n"
+		"   -a, --ignore	ignore history\n"
+		"   -d, --scan=SECS	sample every statistics every SECS\n"
+		"   -j, --json		format output in JSON\n"
+		"   -n, --nooutput	do history only\n"
+		"   -p, --pretty	pretty print\n"
+		"   -r, --reset		reset history\n"
+		"   -s, --noupdate	don't update history\n"
+		"   -t, --interval=SECS	report average over the last SECS\n"
+		"   -V, --version	output version information\n"
+		"   -z, --zeros		show entries with zero activity\n");
 	exit(-1);
 }
 
diff --git a/tc/e_bpf.c b/tc/e_bpf.c
index 84f43e6c..a48393b7 100644
--- a/tc/e_bpf.c
+++ b/tc/e_bpf.c
@@ -26,19 +26,21 @@ static char *argv_default[] = { BPF_DEFAULT_CMD, NULL };
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... bpf [ import UDS_FILE ] [ run CMD ]\n");
-	fprintf(stderr, "       ... bpf [ debug ]\n");
-	fprintf(stderr, "       ... bpf [ graft MAP_FILE ] [ key KEY ]\n");
-	fprintf(stderr, "          `... [ object-file OBJ_FILE ] [ type TYPE ] [ section NAME ] [ verbose ]\n");
-	fprintf(stderr, "          `... [ object-pinned PROG_FILE ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where UDS_FILE provides the name of a unix domain socket file\n");
-	fprintf(stderr, "to import eBPF maps and the optional CMD denotes the command\n");
-	fprintf(stderr, "to be executed (default: \'%s\').\n", BPF_DEFAULT_CMD);
-	fprintf(stderr, "Where MAP_FILE points to a pinned map, OBJ_FILE to an object file\n");
-	fprintf(stderr, "and PROG_FILE to a pinned program. TYPE can be {cls, act}, where\n");
-	fprintf(stderr, "\'cls\' is default. KEY is optional and can be inferred from the\n");
-	fprintf(stderr, "section name, otherwise it needs to be provided.\n");
+	fprintf(stderr,
+		"Usage: ... bpf [ import UDS_FILE ] [ run CMD ]\n"
+		"       ... bpf [ debug ]\n"
+		"       ... bpf [ graft MAP_FILE ] [ key KEY ]\n"
+		"          `... [ object-file OBJ_FILE ] [ type TYPE ] [ section NAME ] [ verbose ]\n"
+		"          `... [ object-pinned PROG_FILE ]\n"
+		"\n"
+		"Where UDS_FILE provides the name of a unix domain socket file\n"
+		"to import eBPF maps and the optional CMD denotes the command\n"
+		"to be executed (default: \'%s\').\n"
+		"Where MAP_FILE points to a pinned map, OBJ_FILE to an object file\n"
+		"and PROG_FILE to a pinned program. TYPE can be {cls, act}, where\n"
+		"\'cls\' is default. KEY is optional and can be inferred from the\n"
+		"section name, otherwise it needs to be provided.\n",
+		BPF_DEFAULT_CMD);
 }
 
 static int bpf_num_env_entries(void)
diff --git a/tc/f_basic.c b/tc/f_basic.c
index af98c088..7b19cea6 100644
--- a/tc/f_basic.c
+++ b/tc/f_basic.c
@@ -26,13 +26,15 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... basic [ match EMATCH_TREE ]\n");
-	fprintf(stderr, "                 [ action ACTION_SPEC ] [ classid CLASSID ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where: SELECTOR := SAMPLE SAMPLE ...\n");
-	fprintf(stderr, "       FILTERID := X:Y:Z\n");
-	fprintf(stderr, "       ACTION_SPEC := ... look at individual actions\n");
-	fprintf(stderr, "\nNOTE: CLASSID is parsed as hexadecimal input.\n");
+	fprintf(stderr,
+		"Usage: ... basic [ match EMATCH_TREE ]\n"
+		"                 [ action ACTION_SPEC ] [ classid CLASSID ]\n"
+		"\n"
+		"Where:	SELECTOR := SAMPLE SAMPLE ...\n"
+		"	FILTERID := X:Y:Z\n"
+		"	ACTION_SPEC := ... look at individual actions\n"
+		"\n"
+		"NOTE: CLASSID is parsed as hexadecimal input.\n");
 }
 
 static int basic_parse_opt(struct filter_util *qu, char *handle,
diff --git a/tc/f_bpf.c b/tc/f_bpf.c
index 948d9051..135271aa 100644
--- a/tc/f_bpf.c
+++ b/tc/f_bpf.c
@@ -23,36 +23,38 @@ static const enum bpf_prog_type bpf_type = BPF_PROG_TYPE_SCHED_CLS;
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... bpf ...\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "BPF use case:\n");
-	fprintf(stderr, " bytecode BPF_BYTECODE\n");
-	fprintf(stderr, " bytecode-file FILE\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "eBPF use case:\n");
-	fprintf(stderr, " object-file FILE [ section CLS_NAME ] [ export UDS_FILE ]");
-	fprintf(stderr, " [ verbose ] [ direct-action ] [ skip_hw | skip_sw ]\n");
-	fprintf(stderr, " object-pinned FILE [ direct-action ] [ skip_hw | skip_sw ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Common remaining options:\n");
-	fprintf(stderr, " [ action ACTION_SPEC ]\n");
-	fprintf(stderr, " [ classid CLASSID ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where BPF_BYTECODE := \'s,c t f k,c t f k,c t f k,...\'\n");
-	fprintf(stderr, "c,t,f,k and s are decimals; s denotes number of 4-tuples\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where FILE points to a file containing the BPF_BYTECODE string,\n");
-	fprintf(stderr, "an ELF file containing eBPF map definitions and bytecode, or a\n");
-	fprintf(stderr, "pinned eBPF program.\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where CLS_NAME refers to the section name containing the\n");
-	fprintf(stderr, "classifier (default \'%s\').\n", bpf_prog_to_default_section(bpf_type));
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where UDS_FILE points to a unix domain socket file in order\n");
-	fprintf(stderr, "to hand off control of all created eBPF maps to an agent.\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "ACTION_SPEC := ... look at individual actions\n");
-	fprintf(stderr, "NOTE: CLASSID is parsed as hexadecimal input.\n");
+	fprintf(stderr,
+		"Usage: ... bpf ...\n"
+		"\n"
+		"BPF use case:\n"
+		" bytecode BPF_BYTECODE\n"
+		" bytecode-file FILE\n"
+		"\n"
+		"eBPF use case:\n"
+		" object-file FILE [ section CLS_NAME ] [ export UDS_FILE ]"
+		" [ verbose ] [ direct-action ] [ skip_hw | skip_sw ]\n"
+		" object-pinned FILE [ direct-action ] [ skip_hw | skip_sw ]\n"
+		"\n"
+		"Common remaining options:\n"
+		" [ action ACTION_SPEC ]\n"
+		" [ classid CLASSID ]\n"
+		"\n"
+		"Where BPF_BYTECODE := \'s,c t f k,c t f k,c t f k,...\'\n"
+		"c,t,f,k and s are decimals; s denotes number of 4-tuples\n"
+		"\n"
+		"Where FILE points to a file containing the BPF_BYTECODE string,\n"
+		"an ELF file containing eBPF map definitions and bytecode, or a\n"
+		"pinned eBPF program.\n"
+		"\n"
+		"Where CLS_NAME refers to the section name containing the\n"
+		"classifier (default \'%s\').\n"
+		"\n"
+		"Where UDS_FILE points to a unix domain socket file in order\n"
+		"to hand off control of all created eBPF maps to an agent.\n"
+		"\n"
+		"ACTION_SPEC := ... look at individual actions\n"
+		"NOTE: CLASSID is parsed as hexadecimal input.\n",
+		bpf_prog_to_default_section(bpf_type));
 }
 
 static void bpf_cbpf_cb(void *nl, const struct sock_filter *ops, int ops_len)
diff --git a/tc/f_flow.c b/tc/f_flow.c
index badeaa29..9dd50df2 100644
--- a/tc/f_flow.c
+++ b/tc/f_flow.c
@@ -21,21 +21,21 @@
 static void explain(void)
 {
 	fprintf(stderr,
-"Usage: ... flow ...\n"
-"\n"
-" [mapping mode]: map key KEY [ OPS ] ...\n"
-" [hashing mode]: hash keys KEY-LIST ... [ perturb SECS ]\n"
-"\n"
-"                 [ divisor NUM ] [ baseclass ID ] [ match EMATCH_TREE ]\n"
-"                 [ action ACTION_SPEC ]\n"
-"\n"
-"KEY-LIST := [ KEY-LIST , ] KEY\n"
-"KEY      := [ src | dst | proto | proto-src | proto-dst | iif | priority |\n"
-"              mark | nfct | nfct-src | nfct-dst | nfct-proto-src |\n"
-"              nfct-proto-dst | rt-classid | sk-uid | sk-gid |\n"
-"              vlan-tag | rxhash ]\n"
-"OPS      := [ or NUM | and NUM | xor NUM | rshift NUM | addend NUM ]\n"
-"ID       := X:Y\n"
+		"Usage: ... flow ...\n"
+		"\n"
+		" [mapping mode]: map key KEY [ OPS ] ...\n"
+		" [hashing mode]: hash keys KEY-LIST ... [ perturb SECS ]\n"
+		"\n"
+		"                 [ divisor NUM ] [ baseclass ID ] [ match EMATCH_TREE ]\n"
+		"                 [ action ACTION_SPEC ]\n"
+		"\n"
+		"KEY-LIST := [ KEY-LIST , ] KEY\n"
+		"KEY      := [ src | dst | proto | proto-src | proto-dst | iif | priority |\n"
+		"              mark | nfct | nfct-src | nfct-dst | nfct-proto-src |\n"
+		"              nfct-proto-dst | rt-classid | sk-uid | sk-gid |\n"
+		"              vlan-tag | rxhash ]\n"
+		"OPS      := [ or NUM | and NUM | xor NUM | rshift NUM | addend NUM ]\n"
+		"ID       := X:Y\n"
 	);
 }
 
diff --git a/tc/f_flower.c b/tc/f_flower.c
index 9659e894..98345c5d 100644
--- a/tc/f_flower.c
+++ b/tc/f_flower.c
@@ -42,54 +42,54 @@ enum flower_icmp_field {
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: ... flower [ MATCH-LIST ] [ verbose ]\n"
-		"                  [ skip_sw | skip_hw ]\n"
-		"                  [ action ACTION-SPEC ] [ classid CLASSID ]\n"
+		"Usage: ... flower	[ MATCH-LIST ] [ verbose ]\n"
+		"			[ skip_sw | skip_hw ]\n"
+		"			[ action ACTION-SPEC ] [ classid CLASSID ]\n"
 		"\n"
 		"Where: MATCH-LIST := [ MATCH-LIST ] MATCH\n"
-		"       MATCH      := { indev DEV-NAME |\n"
-		"                       vlan_id VID |\n"
-		"                       vlan_prio PRIORITY |\n"
-		"                       vlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
-		"                       cvlan_id VID |\n"
-		"                       cvlan_prio PRIORITY |\n"
-		"                       cvlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
-		"                       dst_mac MASKED-LLADDR |\n"
-		"                       src_mac MASKED-LLADDR |\n"
-		"                       ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
-		"                       ip_tos MASKED-IP_TOS |\n"
-		"                       ip_ttl MASKED-IP_TTL |\n"
-		"                       mpls_label LABEL |\n"
-		"                       mpls_tc TC |\n"
-		"                       mpls_bos BOS |\n"
-		"                       mpls_ttl TTL |\n"
-		"                       dst_ip PREFIX |\n"
-		"                       src_ip PREFIX |\n"
-		"                       dst_port PORT-NUMBER |\n"
-		"                       src_port PORT-NUMBER |\n"
-		"                       tcp_flags MASKED-TCP_FLAGS |\n"
-		"                       type MASKED-ICMP-TYPE |\n"
-		"                       code MASKED-ICMP-CODE |\n"
-		"                       arp_tip IPV4-PREFIX |\n"
-		"                       arp_sip IPV4-PREFIX |\n"
-		"                       arp_op [ request | reply | OP ] |\n"
-		"                       arp_tha MASKED-LLADDR |\n"
-		"                       arp_sha MASKED-LLADDR |\n"
-		"                       enc_dst_ip [ IPV4-ADDR | IPV6-ADDR ] |\n"
-		"                       enc_src_ip [ IPV4-ADDR | IPV6-ADDR ] |\n"
-		"                       enc_key_id [ KEY-ID ] |\n"
-		"                       enc_tos MASKED-IP_TOS |\n"
-		"                       enc_ttl MASKED-IP_TTL |\n"
-		"                       geneve_opts MASKED-OPTIONS |\n"
-		"                       ip_flags IP-FLAGS | \n"
-		"                       enc_dst_port [ port_number ] }\n"
-		"       FILTERID := X:Y:Z\n"
-		"       MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
-		"       ACTION-SPEC := ... look at individual actions\n"
+		"       MATCH      := {	indev DEV-NAME |\n"
+		"			vlan_id VID |\n"
+		"			vlan_prio PRIORITY |\n"
+		"			vlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
+		"			cvlan_id VID |\n"
+		"			cvlan_prio PRIORITY |\n"
+		"			cvlan_ethtype [ ipv4 | ipv6 | ETH-TYPE ] |\n"
+		"			dst_mac MASKED-LLADDR |\n"
+		"			src_mac MASKED-LLADDR |\n"
+		"			ip_proto [tcp | udp | sctp | icmp | icmpv6 | IP-PROTO ] |\n"
+		"			ip_tos MASKED-IP_TOS |\n"
+		"			ip_ttl MASKED-IP_TTL |\n"
+		"			mpls_label LABEL |\n"
+		"			mpls_tc TC |\n"
+		"			mpls_bos BOS |\n"
+		"			mpls_ttl TTL |\n"
+		"			dst_ip PREFIX |\n"
+		"			src_ip PREFIX |\n"
+		"			dst_port PORT-NUMBER |\n"
+		"			src_port PORT-NUMBER |\n"
+		"			tcp_flags MASKED-TCP_FLAGS |\n"
+		"			type MASKED-ICMP-TYPE |\n"
+		"			code MASKED-ICMP-CODE |\n"
+		"			arp_tip IPV4-PREFIX |\n"
+		"			arp_sip IPV4-PREFIX |\n"
+		"			arp_op [ request | reply | OP ] |\n"
+		"			arp_tha MASKED-LLADDR |\n"
+		"			arp_sha MASKED-LLADDR |\n"
+		"			enc_dst_ip [ IPV4-ADDR | IPV6-ADDR ] |\n"
+		"			enc_src_ip [ IPV4-ADDR | IPV6-ADDR ] |\n"
+		"			enc_key_id [ KEY-ID ] |\n"
+		"			enc_tos MASKED-IP_TOS |\n"
+		"			enc_ttl MASKED-IP_TTL |\n"
+		"			geneve_opts MASKED-OPTIONS |\n"
+		"			ip_flags IP-FLAGS | \n"
+		"			enc_dst_port [ port_number ] }\n"
+		"	FILTERID := X:Y:Z\n"
+		"	MASKED_LLADDR := { LLADDR | LLADDR/MASK | LLADDR/BITS }\n"
+		"	ACTION-SPEC := ... look at individual actions\n"
 		"\n"
-		"NOTE: CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
-		"NOTE: There can be only used one mask per one prio. If user needs\n"
-		"      to specify different mask, he has to use different prio.\n");
+		"NOTE:	CLASSID, IP-PROTO are parsed as hexadecimal input.\n"
+		"NOTE:	There can be only used one mask per one prio. If user needs\n"
+		"	to specify different mask, he has to use different prio.\n");
 }
 
 static int flower_parse_eth_addr(char *str, int addr_type, int mask_type,
diff --git a/tc/f_fw.c b/tc/f_fw.c
index adce2bdb..688364f5 100644
--- a/tc/f_fw.c
+++ b/tc/f_fw.c
@@ -25,18 +25,13 @@
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: ... fw [ classid CLASSID ] [ indev DEV ] [ action ACTION_SPEC ]\n");
-	fprintf(stderr,
-		"       CLASSID := Push matching packets to the class identified by CLASSID with format X:Y\n");
-	fprintf(stderr,
-		"                  CLASSID is parsed as hexadecimal input.\n");
-	fprintf(stderr,
-		"       DEV := specify device for incoming device classification.\n");
-	fprintf(stderr,
-		"       ACTION_SPEC := Apply an action on matching packets.\n");
-	fprintf(stderr,
-		"       NOTE: handle is represented as HANDLE[/FWMASK].\n");
-	fprintf(stderr, "             FWMASK is 0xffffffff by default.\n");
+		"Usage: ... fw [ classid CLASSID ] [ indev DEV ] [ action ACTION_SPEC ]\n"
+		"	CLASSID := Push matching packets to the class identified by CLASSID with format X:Y\n"
+		"		CLASSID is parsed as hexadecimal input.\n"
+		"	DEV := specify device for incoming device classification.\n"
+		"	ACTION_SPEC := Apply an action on matching packets.\n"
+		"	NOTE: handle is represented as HANDLE[/FWMASK].\n"
+		"		FWMASK is 0xffffffff by default.\n");
 }
 
 static int fw_parse_opt(struct filter_util *qu, char *handle, int argc, char **argv, struct nlmsghdr *n)
diff --git a/tc/f_matchall.c b/tc/f_matchall.c
index 03dd51de..253ed5ce 100644
--- a/tc/f_matchall.c
+++ b/tc/f_matchall.c
@@ -25,13 +25,15 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... matchall [skip_sw | skip_hw]\n");
-	fprintf(stderr, "                 [ action ACTION_SPEC ] [ classid CLASSID ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where: SELECTOR := SAMPLE SAMPLE ...\n");
-	fprintf(stderr, "       FILTERID := X:Y:Z\n");
-	fprintf(stderr, "       ACTION_SPEC := ... look at individual actions\n");
-	fprintf(stderr, "\nNOTE: CLASSID is parsed as hexadecimal input.\n");
+	fprintf(stderr,
+		"Usage: ... matchall [skip_sw | skip_hw]\n"
+		"                 [ action ACTION_SPEC ] [ classid CLASSID ]\n"
+		"\n"
+		"Where: SELECTOR := SAMPLE SAMPLE ...\n"
+		"       FILTERID := X:Y:Z\n"
+		"       ACTION_SPEC := ... look at individual actions\n"
+		"\n"
+		"NOTE: CLASSID is parsed as hexadecimal input.\n");
 }
 
 static int matchall_parse_opt(struct filter_util *qu, char *handle,
diff --git a/tc/f_route.c b/tc/f_route.c
index e52da644..31fa96a0 100644
--- a/tc/f_route.c
+++ b/tc/f_route.c
@@ -26,11 +26,13 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... route [ from REALM | fromif TAG ] [ to REALM ]\n");
-	fprintf(stderr, "                [ classid CLASSID ] [ action ACTION_SPEC ]\n");
-	fprintf(stderr, "       ACTION_SPEC := ... look at individual actions\n");
-	fprintf(stderr, "       CLASSID := X:Y\n");
-	fprintf(stderr, "\nNOTE: CLASSID is parsed as hexadecimal input.\n");
+	fprintf(stderr,
+		"Usage: ... route [ from REALM | fromif TAG ] [ to REALM ]\n"
+		"                [ classid CLASSID ] [ action ACTION_SPEC ]\n"
+		"       ACTION_SPEC := ... look at individual actions\n"
+		"       CLASSID := X:Y\n"
+		"\n"
+		"NOTE: CLASSID is parsed as hexadecimal input.\n");
 }
 
 static int route_parse_opt(struct filter_util *qu, char *handle, int argc, char **argv, struct nlmsghdr *n)
diff --git a/tc/f_rsvp.c b/tc/f_rsvp.c
index bddd4740..388e9ee5 100644
--- a/tc/f_rsvp.c
+++ b/tc/f_rsvp.c
@@ -25,15 +25,16 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... rsvp ipproto PROTOCOL session DST[/PORT | GPI ]\n");
-	fprintf(stderr, "                [ sender SRC[/PORT | GPI ] ]\n");
-	fprintf(stderr, "                [ classid CLASSID ] [ action ACTION_SPEC ]\n");
-	fprintf(stderr, "                [ tunnelid ID ] [ tunnel ID skip NUMBER ]\n");
-	fprintf(stderr, "Where: GPI := { flowlabel NUMBER | spi/ah SPI | spi/esp SPI |\n");
-	fprintf(stderr, "                u{8|16|32} NUMBER mask MASK at OFFSET}\n");
-	fprintf(stderr, "       ACTION_SPEC := ... look at individual actions\n");
-	fprintf(stderr, "       FILTERID := X:Y\n");
-	fprintf(stderr, "\nNOTE: CLASSID is parsed as hexadecimal input.\n");
+	fprintf(stderr,
+		"Usage:	... rsvp ipproto PROTOCOL session DST[/PORT | GPI ]\n"
+		"		[ sender SRC[/PORT | GPI ] ]\n"
+		"		[ classid CLASSID ] [ action ACTION_SPEC ]\n"
+		"		[ tunnelid ID ] [ tunnel ID skip NUMBER ]\n"
+		"Where:	GPI := { flowlabel NUMBER | spi/ah SPI | spi/esp SPI |\n"
+		"		u{8|16|32} NUMBER mask MASK at OFFSET}\n"
+		"	ACTION_SPEC := ... look at individual actions\n"
+		"	FILTERID := X:Y\n"
+		"\nNOTE: CLASSID is parsed as hexadecimal input.\n");
 }
 
 static int get_addr_and_pi(int *argc_p, char ***argv_p, inet_prefix *addr,
diff --git a/tc/f_tcindex.c b/tc/f_tcindex.c
index 159cf414..ae4cbf11 100644
--- a/tc/f_tcindex.c
+++ b/tc/f_tcindex.c
@@ -17,9 +17,10 @@
 
 static void explain(void)
 {
-	fprintf(stderr," Usage: ... tcindex [ hash SIZE ] [ mask MASK ] [ shift SHIFT ]\n");
-	fprintf(stderr, "                    [ pass_on | fall_through ]\n");
-	fprintf(stderr,"                    [ classid CLASSID ] [ action ACTION_SPEC ]\n");
+	fprintf(stderr,
+		" Usage: ... tcindex	[ hash SIZE ] [ mask MASK ] [ shift SHIFT ]\n"
+		"			[ pass_on | fall_through ]\n"
+		"			[ classid CLASSID ] [ action ACTION_SPEC ]\n");
 }
 
 static int tcindex_parse_opt(struct filter_util *qu, char *handle, int argc,
diff --git a/tc/m_action.c b/tc/m_action.c
index b5aff3ab..ab6bc0ad 100644
--- a/tc/m_action.c
+++ b/tc/m_action.c
@@ -43,20 +43,20 @@ static void act_usage(void)
 	 * does that, they would know how to fix this ..
 	 *
 	 */
-	fprintf(stderr, "usage: tc actions <ACTSPECOP>*\n");
 	fprintf(stderr,
-		"Where: \tACTSPECOP := ACR | GD | FL\n"
-			"\tACR := add | change | replace <ACTSPEC>*\n"
-			"\tGD := get | delete | <ACTISPEC>*\n"
-			"\tFL := ls | list | flush | <ACTNAMESPEC>\n"
-			"\tACTNAMESPEC :=  action <ACTNAME>\n"
-			"\tACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
-			"\tACTSPEC := action <ACTDETAIL> [INDEXSPEC]\n"
-			"\tINDEXSPEC := index <32 bit indexvalue>\n"
-			"\tACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
-			"\t\tExample ACTNAME is gact, mirred, bpf, etc\n"
-			"\t\tEach action has its own parameters (ACTPARAMS)\n"
-			"\n");
+		"usage: tc actions <ACTSPECOP>*\n"
+		"Where: 	ACTSPECOP := ACR | GD | FL\n"
+		"	ACR := add | change | replace <ACTSPEC>*\n"
+		"	GD := get | delete | <ACTISPEC>*\n"
+		"	FL := ls | list | flush | <ACTNAMESPEC>\n"
+		"	ACTNAMESPEC :=  action <ACTNAME>\n"
+		"	ACTISPEC := <ACTNAMESPEC> <INDEXSPEC>\n"
+		"	ACTSPEC := action <ACTDETAIL> [INDEXSPEC]\n"
+		"	INDEXSPEC := index <32 bit indexvalue>\n"
+		"	ACTDETAIL := <ACTNAME> <ACTPARAMS>\n"
+		"		Example ACTNAME is gact, mirred, bpf, etc\n"
+		"		Each action has its own parameters (ACTPARAMS)\n"
+		"\n");
 
 	exit(-1);
 }
diff --git a/tc/m_bpf.c b/tc/m_bpf.c
index 3e8468c6..e247da8d 100644
--- a/tc/m_bpf.c
+++ b/tc/m_bpf.c
@@ -25,32 +25,34 @@ static const enum bpf_prog_type bpf_type = BPF_PROG_TYPE_SCHED_ACT;
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... bpf ... [ index INDEX ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "BPF use case:\n");
-	fprintf(stderr, " bytecode BPF_BYTECODE\n");
-	fprintf(stderr, " bytecode-file FILE\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "eBPF use case:\n");
-	fprintf(stderr, " object-file FILE [ section ACT_NAME ] [ export UDS_FILE ]");
-	fprintf(stderr, " [ verbose ]\n");
-	fprintf(stderr, " object-pinned FILE\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where BPF_BYTECODE := \'s,c t f k,c t f k,c t f k,...\'\n");
-	fprintf(stderr, "c,t,f,k and s are decimals; s denotes number of 4-tuples\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where FILE points to a file containing the BPF_BYTECODE string,\n");
-	fprintf(stderr, "an ELF file containing eBPF map definitions and bytecode, or a\n");
-	fprintf(stderr, "pinned eBPF program.\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where ACT_NAME refers to the section name containing the\n");
-	fprintf(stderr, "action (default \'%s\').\n", bpf_prog_to_default_section(bpf_type));
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where UDS_FILE points to a unix domain socket file in order\n");
-	fprintf(stderr, "to hand off control of all created eBPF maps to an agent.\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "Where optionally INDEX points to an existing action, or\n");
-	fprintf(stderr, "explicitly specifies an action index upon creation.\n");
+	fprintf(stderr,
+		"Usage: ... bpf ... [ index INDEX ]\n"
+		"\n"
+		"BPF use case:\n"
+		" bytecode BPF_BYTECODE\n"
+		" bytecode-file FILE\n"
+		"\n"
+		"eBPF use case:\n"
+		" object-file FILE [ section ACT_NAME ] [ export UDS_FILE ]"
+		" [ verbose ]\n"
+		" object-pinned FILE\n"
+		"\n"
+		"Where BPF_BYTECODE := \'s,c t f k,c t f k,c t f k,...\'\n"
+		"c,t,f,k and s are decimals; s denotes number of 4-tuples\n"
+		"\n"
+		"Where FILE points to a file containing the BPF_BYTECODE string,\n"
+		"an ELF file containing eBPF map definitions and bytecode, or a\n"
+		"pinned eBPF program.\n"
+		"\n"
+		"Where ACT_NAME refers to the section name containing the\n"
+		"action (default \'%s\').\n"
+		"\n"
+		"Where UDS_FILE points to a unix domain socket file in order\n"
+		"to hand off control of all created eBPF maps to an agent.\n"
+		"\n"
+		"Where optionally INDEX points to an existing action, or\n"
+		"explicitly specifies an action index upon creation.\n",
+		bpf_prog_to_default_section(bpf_type));
 }
 
 static void bpf_cbpf_cb(void *nl, const struct sock_filter *ops, int ops_len)
diff --git a/tc/m_connmark.c b/tc/m_connmark.c
index 13543d33..af5ebfc4 100644
--- a/tc/m_connmark.c
+++ b/tc/m_connmark.c
@@ -27,8 +27,9 @@
 static void
 explain(void)
 {
-	fprintf(stderr, "Usage: ... connmark [zone ZONE] [CONTROL] [index <INDEX>]\n");
-	fprintf(stderr, "where :\n"
+	fprintf(stderr,
+		"Usage: ... connmark [zone ZONE] [CONTROL] [index <INDEX>]\n"
+		"where :\n"
 		"\tZONE is the conntrack zone\n"
 		"\tCONTROL := reclassify | pipe | drop | continue | ok |\n"
 		"\t           goto chain <CHAIN_INDEX>\n");
diff --git a/tc/m_estimator.c b/tc/m_estimator.c
index a2f747f4..ef62e1bb 100644
--- a/tc/m_estimator.c
+++ b/tc/m_estimator.c
@@ -27,10 +27,11 @@ static void est_help(void);
 
 static void est_help(void)
 {
-	fprintf(stderr, "Usage: ... estimator INTERVAL TIME-CONST\n");
-	fprintf(stderr, "  INTERVAL is interval between measurements\n");
-	fprintf(stderr, "  TIME-CONST is averaging time constant\n");
-	fprintf(stderr, "Example: ... est 1sec 8sec\n");
+	fprintf(stderr,
+		"Usage: ... estimator INTERVAL TIME-CONST\n"
+		"  INTERVAL is interval between measurements\n"
+		"  TIME-CONST is averaging time constant\n"
+		"Example: ... est 1sec 8sec\n");
 }
 
 int parse_estimator(int *p_argc, char ***p_argv, struct tc_estimator *est)
diff --git a/tc/m_gact.c b/tc/m_gact.c
index a0a3c33d..f48f0cbc 100644
--- a/tc/m_gact.c
+++ b/tc/m_gact.c
@@ -53,8 +53,7 @@ explain(void)
 			"\tINDEX := index value used\n"
 			"\n");
 #else
-	fprintf(stderr, "Usage: ... gact <ACTION> [INDEX]\n");
-	fprintf(stderr,
+	fprintf(stderr, "Usage: ... gact <ACTION> [INDEX]\n"
 		"Where: \tACTION := reclassify | drop | continue | pass | pipe |\n"
 		"       \t          goto chain <CHAIN_INDEX> | jump <JUMP_COUNT>\n"
 		"\tINDEX := index value used\n"
diff --git a/tc/m_ife.c b/tc/m_ife.c
index 2bf9f204..67c1df75 100644
--- a/tc/m_ife.c
+++ b/tc/m_ife.c
@@ -28,8 +28,7 @@
 static void ife_explain(void)
 {
 	fprintf(stderr,
-		"Usage:... ife {decode|encode} [{ALLOW|USE} ATTR] [dst DMAC] [src SMAC] [type TYPE] [CONTROL] [index INDEX]\n");
-	fprintf(stderr,
+		"Usage:... ife {decode|encode} [{ALLOW|USE} ATTR] [dst DMAC] [src SMAC] [type TYPE] [CONTROL] [index INDEX]\n"
 		"\tALLOW := Encode direction. Allows encoding specified metadata\n"
 		"\t\t e.g \"allow mark\"\n"
 		"\tUSE := Encode direction. Enforce Static encoding of specified metadata\n"
@@ -39,9 +38,9 @@ static void ife_explain(void)
 		"\tSMAC := optional 6 byte Source MAC address to encode\n"
 		"\tTYPE := optional 16 bit ethertype to encode\n"
 		"\tCONTROL := reclassify|pipe|drop|continue|ok\n"
-		"\tINDEX := optional IFE table index value used\n");
-	fprintf(stderr, "encode is used for sending IFE packets\n");
-	fprintf(stderr, "decode is used for receiving IFE packets\n");
+		"\tINDEX := optional IFE table index value used\n"
+		"encode is used for sending IFE packets\n"
+		"decode is used for receiving IFE packets\n");
 }
 
 static void ife_usage(void)
diff --git a/tc/m_pedit.c b/tc/m_pedit.c
index 6f8d078b..8eb15f4b 100644
--- a/tc/m_pedit.c
+++ b/tc/m_pedit.c
@@ -34,8 +34,8 @@ static int pedit_debug;
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... pedit munge [ex] <MUNGE> [CONTROL]\n");
 	fprintf(stderr,
+		"Usage: ... pedit munge [ex] <MUNGE> [CONTROL]\n"
 		"Where: MUNGE := <RAW>|<LAYERED>\n"
 		"\t<RAW>:= <OFFSETC>[ATC]<CMD>\n \t\tOFFSETC:= offset <offval> <u8|u16|u32>\n"
 		"\t\tATC:= at <atval> offmask <maskval> shift <shiftval>\n"
diff --git a/tc/m_police.c b/tc/m_police.c
index d645999b..862a39ff 100644
--- a/tc/m_police.c
+++ b/tc/m_police.c
@@ -37,15 +37,15 @@ struct action_util police_action_util = {
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: ... police rate BPS burst BYTES[/BYTES] [ mtu BYTES[/BYTES] ]\n");
-	fprintf(stderr, "                [ peakrate BPS ] [ avrate BPS ] [ overhead BYTES ]\n");
-	fprintf(stderr, "                [ linklayer TYPE ] [ CONTROL ]\n");
-
-	fprintf(stderr, "Where: CONTROL := conform-exceed <EXCEEDACT>[/NOTEXCEEDACT]\n");
-	fprintf(stderr, "                  Define how to handle packets which exceed (<EXCEEDACT>)\n");
-	fprintf(stderr, "                  or conform (<NOTEXCEEDACT>) the configured bandwidth limit.\n");
-	fprintf(stderr, "       EXCEEDACT/NOTEXCEEDACT := { pipe | ok | reclassify | drop | continue |\n");
-	fprintf(stderr, "                                   goto chain <CHAIN_INDEX> }\n");
+	fprintf(stderr,
+		"Usage: ... police rate BPS burst BYTES[/BYTES] [ mtu BYTES[/BYTES] ]\n"
+		"		[ peakrate BPS ] [ avrate BPS ] [ overhead BYTES ]\n"
+		"		[ linklayer TYPE ] [ CONTROL ]\n"
+		"Where: CONTROL := conform-exceed <EXCEEDACT>[/NOTEXCEEDACT]\n"
+		"		  Define how to handle packets which exceed (<EXCEEDACT>)\n"
+		"		  or conform (<NOTEXCEEDACT>) the configured bandwidth limit.\n"
+		"       EXCEEDACT/NOTEXCEEDACT := { pipe | ok | reclassify | drop | continue |\n"
+		"				   goto chain <CHAIN_INDEX> }\n");
 	exit(-1);
 }
 
diff --git a/tc/m_sample.c b/tc/m_sample.c
index 39a99246..3c840d3f 100644
--- a/tc/m_sample.c
+++ b/tc/m_sample.c
@@ -18,15 +18,16 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: sample SAMPLE_CONF\n");
-	fprintf(stderr, "where:\n");
-	fprintf(stderr, "\tSAMPLE_CONF := SAMPLE_PARAMS | SAMPLE_INDEX\n");
-	fprintf(stderr, "\tSAMPLE_PARAMS := rate RATE group GROUP [trunc SIZE] [SAMPLE_INDEX]\n");
-	fprintf(stderr, "\tSAMPLE_INDEX := index INDEX\n");
-	fprintf(stderr, "\tRATE := The ratio of packets observed at the data source to the samples generated.\n");
-	fprintf(stderr, "\tGROUP := the psample sampling group\n");
-	fprintf(stderr, "\tSIZE := the truncation size\n");
-	fprintf(stderr, "\tINDEX := integer index of the sample action\n");
+	fprintf(stderr,
+		"Usage: sample SAMPLE_CONF\n"
+		"where:\n"
+		"\tSAMPLE_CONF := SAMPLE_PARAMS | SAMPLE_INDEX\n"
+		"\tSAMPLE_PARAMS := rate RATE group GROUP [trunc SIZE] [SAMPLE_INDEX]\n"
+		"\tSAMPLE_INDEX := index INDEX\n"
+		"\tRATE := The ratio of packets observed at the data source to the samples generated.\n"
+		"\tGROUP := the psample sampling group\n"
+		"\tSIZE := the truncation size\n"
+		"\tINDEX := integer index of the sample action\n");
 }
 
 static void usage(void)
diff --git a/tc/m_simple.c b/tc/m_simple.c
index 886606f9..e3e1cdb1 100644
--- a/tc/m_simple.c
+++ b/tc/m_simple.c
@@ -80,8 +80,9 @@
 #endif
 static void explain(void)
 {
-	fprintf(stderr, "Usage:... simple [sdata STRING] [index INDEX] [CONTROL]\n");
-	fprintf(stderr, "\tSTRING being an arbitrary string\n"
+	fprintf(stderr,
+		"Usage:... simple [sdata STRING] [index INDEX] [CONTROL]\n"
+		"\tSTRING being an arbitrary string\n"
 		"\tINDEX := optional index value used\n"
 		"\tCONTROL := reclassify|pipe|drop|continue|ok\n");
 }
diff --git a/tc/m_tunnel_key.c b/tc/m_tunnel_key.c
index 9449287e..fd699017 100644
--- a/tc/m_tunnel_key.c
+++ b/tc/m_tunnel_key.c
@@ -21,9 +21,9 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: tunnel_key unset\n");
-	fprintf(stderr, "       tunnel_key set <TUNNEL_KEY>\n");
 	fprintf(stderr,
+		"Usage: tunnel_key unset\n"
+		"       tunnel_key set <TUNNEL_KEY>\n"
 		"Where TUNNEL_KEY is a combination of:\n"
 		"id <TUNNELID>\n"
 		"src_ip <IP> (mandatory)\n"
diff --git a/tc/q_atm.c b/tc/q_atm.c
index f8215f06..77b56825 100644
--- a/tc/q_atm.c
+++ b/tc/q_atm.c
@@ -40,8 +40,9 @@ static int atm_parse_opt(struct qdisc_util *qu, int argc, char **argv,
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... atm ( pvc ADDR | svc ADDR [ sap SAP ] ) [ qos QOS ] [ sndbuf BYTES ]\n");
-	fprintf(stderr, "  [ hdr HEX... ] [ excess ( CLASSID | clp ) ] [ clip ]\n");
+	fprintf(stderr,
+		"Usage: ... atm ( pvc ADDR | svc ADDR [ sap SAP ] ) [ qos QOS ] [ sndbuf BYTES ]\n"
+		"  [ hdr HEX... ] [ excess ( CLASSID | clp ) ] [ clip ]\n");
 }
 
 
diff --git a/tc/q_cake.c b/tc/q_cake.c
index 307a12c0..65ea07ef 100644
--- a/tc/q_cake.c
+++ b/tc/q_cake.c
@@ -71,21 +71,21 @@ static struct cake_preset *find_preset(char *argv)
 static void explain(void)
 {
 	fprintf(stderr,
-"Usage: ... cake [ bandwidth RATE | unlimited* | autorate-ingress ]\n"
-"                [ rtt TIME | datacentre | lan | metro | regional |\n"
-"                  internet* | oceanic | satellite | interplanetary ]\n"
-"                [ besteffort | diffserv8 | diffserv4 | diffserv3* ]\n"
-"                [ flowblind | srchost | dsthost | hosts | flows |\n"
-"                  dual-srchost | dual-dsthost | triple-isolate* ]\n"
-"                [ nat | nonat* ]\n"
-"                [ wash | nowash* ]\n"
-"                [ split-gso* | no-split-gso ]\n"
-"                [ ack-filter | ack-filter-aggressive | no-ack-filter* ]\n"
-"                [ memlimit LIMIT ]\n"
-"                [ fwmark MASK ]\n"
-"                [ ptm | atm | noatm* ] [ overhead N | conservative | raw* ]\n"
-"                [ mpu N ] [ ingress | egress* ]\n"
-"                (* marks defaults)\n");
+		"Usage: ... cake [ bandwidth RATE | unlimited* | autorate-ingress ]\n"
+		"                [ rtt TIME | datacentre | lan | metro | regional |\n"
+		"                  internet* | oceanic | satellite | interplanetary ]\n"
+		"                [ besteffort | diffserv8 | diffserv4 | diffserv3* ]\n"
+		"                [ flowblind | srchost | dsthost | hosts | flows |\n"
+		"                  dual-srchost | dual-dsthost | triple-isolate* ]\n"
+		"                [ nat | nonat* ]\n"
+		"                [ wash | nowash* ]\n"
+		"                [ split-gso* | no-split-gso ]\n"
+		"                [ ack-filter | ack-filter-aggressive | no-ack-filter* ]\n"
+		"                [ memlimit LIMIT ]\n"
+		"                [ fwmark MASK ]\n"
+		"                [ ptm | atm | noatm* ] [ overhead N | conservative | raw* ]\n"
+		"                [ mpu N ] [ ingress | egress* ]\n"
+		"                (* marks defaults)\n");
 }
 
 static int cake_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_cbq.c b/tc/q_cbq.c
index e7f1a3bf..6518ef46 100644
--- a/tc/q_cbq.c
+++ b/tc/q_cbq.c
@@ -25,19 +25,21 @@
 
 static void explain_class(void)
 {
-	fprintf(stderr, "Usage: ... cbq bandwidth BPS rate BPS maxburst PKTS [ avpkt BYTES ]\n");
-	fprintf(stderr, "               [ minburst PKTS ] [ bounded ] [ isolated ]\n");
-	fprintf(stderr, "               [ allot BYTES ] [ mpu BYTES ] [ weight RATE ]\n");
-	fprintf(stderr, "               [ prio NUMBER ] [ cell BYTES ] [ ewma LOG ]\n");
-	fprintf(stderr, "               [ estimator INTERVAL TIME_CONSTANT ]\n");
-	fprintf(stderr, "               [ split CLASSID ] [ defmap MASK/CHANGE ]\n");
-	fprintf(stderr, "               [ overhead BYTES ] [ linklayer TYPE ]\n");
+	fprintf(stderr,
+		"Usage: ... cbq	bandwidth BPS rate BPS maxburst PKTS [ avpkt BYTES ]\n"
+		"		[ minburst PKTS ] [ bounded ] [ isolated ]\n"
+		"		[ allot BYTES ] [ mpu BYTES ] [ weight RATE ]\n"
+		"		[ prio NUMBER ] [ cell BYTES ] [ ewma LOG ]\n"
+		"		[ estimator INTERVAL TIME_CONSTANT ]\n"
+		"		[ split CLASSID ] [ defmap MASK/CHANGE ]\n"
+		"		[ overhead BYTES ] [ linklayer TYPE ]\n");
 }
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... cbq bandwidth BPS avpkt BYTES [ mpu BYTES ]\n");
-	fprintf(stderr, "               [ cell BYTES ] [ ewma LOG ]\n");
+	fprintf(stderr,
+		"Usage: ... cbq bandwidth BPS avpkt BYTES [ mpu BYTES ]\n"
+		"               [ cell BYTES ] [ ewma LOG ]\n");
 }
 
 static void explain1(char *arg)
diff --git a/tc/q_cbs.c b/tc/q_cbs.c
index a2ffb1db..9515a1f7 100644
--- a/tc/q_cbs.c
+++ b/tc/q_cbs.c
@@ -24,9 +24,9 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... cbs hicredit BYTES locredit BYTES sendslope BPS idleslope BPS\n");
-	fprintf(stderr, "           [offload 0|1]\n");
-
+	fprintf(stderr,
+		"Usage: ... cbs hicredit BYTES locredit BYTES sendslope BPS idleslope BPS\n"
+		"	   [offload 0|1]\n");
 }
 
 static void explain1(const char *arg, const char *val)
diff --git a/tc/q_choke.c b/tc/q_choke.c
index 1353c80c..648d9ad7 100644
--- a/tc/q_choke.c
+++ b/tc/q_choke.c
@@ -26,8 +26,9 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... choke limit PACKETS bandwidth KBPS [ecn]\n");
-	fprintf(stderr, "                 [ min PACKETS ] [ max PACKETS ] [ burst PACKETS ]\n");
+	fprintf(stderr,
+		"Usage: ... choke limit PACKETS bandwidth KBPS [ecn]\n"
+		"		 [ min PACKETS ] [ max PACKETS ] [ burst PACKETS ]\n");
 }
 
 static int choke_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_codel.c b/tc/q_codel.c
index 8a2a8716..849cc040 100644
--- a/tc/q_codel.c
+++ b/tc/q_codel.c
@@ -52,9 +52,10 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... codel [ limit PACKETS ] [ target TIME ]\n");
-	fprintf(stderr, "                 [ interval TIME ] [ ecn | noecn ]\n");
-	fprintf(stderr, "                 [ ce_threshold TIME ]\n");
+	fprintf(stderr,
+		"Usage: ... codel [ limit PACKETS ] [ target TIME ]\n"
+		"		 [ interval TIME ] [ ecn | noecn ]\n"
+		"		 [ ce_threshold TIME ]\n");
 }
 
 static int codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_etf.c b/tc/q_etf.c
index 79a06ba8..76aca476 100644
--- a/tc/q_etf.c
+++ b/tc/q_etf.c
@@ -38,8 +38,9 @@ static const struct static_clockid {
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... etf delta NANOS clockid CLOCKID [offload] [deadline_mode]\n");
-	fprintf(stderr, "CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
+	fprintf(stderr,
+		"Usage: ... etf delta NANOS clockid CLOCKID [offload] [deadline_mode]\n"
+		"CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
 }
 
 static void explain1(const char *arg, const char *val)
@@ -49,8 +50,10 @@ static void explain1(const char *arg, const char *val)
 
 static void explain_clockid(const char *val)
 {
-	fprintf(stderr, "etf: illegal value for \"clockid\": \"%s\".\n", val);
-	fprintf(stderr, "It must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
+	fprintf(stderr,
+		"etf: illegal value for \"clockid\": \"%s\".\n"
+		"It must be a valid SYS-V id (i.e. CLOCK_TAI)\n",
+		val);
 }
 
 static int get_clockid(__s32 *val, const char *arg)
diff --git a/tc/q_fq.c b/tc/q_fq.c
index a4174380..caf232ec 100644
--- a/tc/q_fq.c
+++ b/tc/q_fq.c
@@ -50,13 +50,14 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... fq [ limit PACKETS ] [ flow_limit PACKETS ]\n");
-	fprintf(stderr, "              [ quantum BYTES ] [ initial_quantum BYTES ]\n");
-	fprintf(stderr, "              [ maxrate RATE  ] [ buckets NUMBER ]\n");
-	fprintf(stderr, "              [ [no]pacing ] [ refill_delay TIME ]\n");
-	fprintf(stderr, "              [ low_rate_threshold RATE ]\n");
-	fprintf(stderr, "              [ orphan_mask MASK]\n");
-	fprintf(stderr, "              [ ce_threshold TIME ]\n");
+	fprintf(stderr,
+		"Usage: ... fq	[ limit PACKETS ] [ flow_limit PACKETS ]\n"
+		"		[ quantum BYTES ] [ initial_quantum BYTES ]\n"
+		"		[ maxrate RATE  ] [ buckets NUMBER ]\n"
+		"		[ [no]pacing ] [ refill_delay TIME ]\n"
+		"		[ low_rate_threshold RATE ]\n"
+		"		[ orphan_mask MASK]\n"
+		"		[ ce_threshold TIME ]\n");
 }
 
 static unsigned int ilog2(unsigned int val)
diff --git a/tc/q_fq_codel.c b/tc/q_fq_codel.c
index 02ad2214..376ac50d 100644
--- a/tc/q_fq_codel.c
+++ b/tc/q_fq_codel.c
@@ -49,11 +49,12 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... fq_codel [ limit PACKETS ] [ flows NUMBER ]\n");
-	fprintf(stderr, "                    [ memory_limit BYTES ]\n");
-	fprintf(stderr, "                    [ target TIME ] [ interval TIME ]\n");
-	fprintf(stderr, "                    [ quantum BYTES ] [ [no]ecn ]\n");
-	fprintf(stderr, "                    [ ce_threshold TIME ]\n");
+	fprintf(stderr,
+		"Usage: ... fq_codel	[ limit PACKETS ] [ flows NUMBER ]\n"
+					"[ memory_limit BYTES ]\n"
+					"[ target TIME ] [ interval TIME ]\n"
+					"[ quantum BYTES ] [ [no]ecn ]\n"
+					"[ ce_threshold TIME ]\n");
 }
 
 static int fq_codel_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_gred.c b/tc/q_gred.c
index e297b866..8a1cecff 100644
--- a/tc/q_gred.c
+++ b/tc/q_gred.c
@@ -36,11 +36,12 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: tc qdisc { add | replace | change } ... gred setup vqs NUMBER\n");
-	fprintf(stderr, "           default DEFAULT_VQ [ grio ] [ limit BYTES ] [ecn] [harddrop]\n");
-	fprintf(stderr, "       tc qdisc change ... gred vq VQ [ prio VALUE ] limit BYTES\n");
-	fprintf(stderr, "           min BYTES max BYTES avpkt BYTES [ burst PACKETS ]\n");
-	fprintf(stderr, "           [ probability PROBABILITY ] [ bandwidth KBPS ] [ecn] [harddrop]\n");
+	fprintf(stderr,
+		"Usage: tc qdisc { add | replace | change } ... gred setup vqs NUMBER\n"
+		"           default DEFAULT_VQ [ grio ] [ limit BYTES ] [ecn] [harddrop]\n"
+		"       tc qdisc change ... gred vq VQ [ prio VALUE ] limit BYTES\n"
+		"           min BYTES max BYTES avpkt BYTES [ burst PACKETS ]\n"
+		"           [ probability PROBABILITY ] [ bandwidth KBPS ] [ecn] [harddrop]\n");
 }
 
 static int init_gred(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_hhf.c b/tc/q_hhf.c
index 21186a92..5ee6642f 100644
--- a/tc/q_hhf.c
+++ b/tc/q_hhf.c
@@ -17,12 +17,13 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... hhf [ limit PACKETS ] [ quantum BYTES]\n");
-	fprintf(stderr, "               [ hh_limit NUMBER ]\n");
-	fprintf(stderr, "               [ reset_timeout TIME ]\n");
-	fprintf(stderr, "               [ admit_bytes BYTES ]\n");
-	fprintf(stderr, "               [ evict_timeout TIME ]\n");
-	fprintf(stderr, "               [ non_hh_weight NUMBER ]\n");
+	fprintf(stderr,
+		"Usage: ... hhf	[ limit PACKETS ] [ quantum BYTES]\n"
+		"		[ hh_limit NUMBER ]\n"
+		"		[ reset_timeout TIME ]\n"
+		"		[ admit_bytes BYTES ]\n"
+		"		[ evict_timeout TIME ]\n"
+		"		[ non_hh_weight NUMBER ]\n");
 }
 
 static int hhf_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_mqprio.c b/tc/q_mqprio.c
index 7cd18ae1..0eb41308 100644
--- a/tc/q_mqprio.c
+++ b/tc/q_mqprio.c
@@ -23,13 +23,14 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... mqprio [num_tc NUMBER] [map P0 P1 ...]\n");
-	fprintf(stderr, "                  [queues count1@offset1 count2@offset2 ...] ");
-	fprintf(stderr, "[hw 1|0]\n");
-	fprintf(stderr, "                  [mode dcb|channel]\n");
-	fprintf(stderr, "                  [shaper bw_rlimit SHAPER_PARAMS]\n"
+	fprintf(stderr,
+		"Usage: ... mqprio	[num_tc NUMBER] [map P0 P1 ...]\n"
+		"			[queues count1@offset1 count2@offset2 ...] "
+		"[hw 1|0]\n"
+		"			[mode dcb|channel]\n"
+		"			[shaper bw_rlimit SHAPER_PARAMS]\n"
 		"Where: SHAPER_PARAMS := { min_rate MIN_RATE1 MIN_RATE2 ...|\n"
-		"                          max_rate MAX_RATE1 MAX_RATE2 ... }\n");
+		"			  max_rate MAX_RATE1 MAX_RATE2 ... }\n");
 }
 
 static int mqprio_parse_opt(struct qdisc_util *qu, int argc,
diff --git a/tc/q_netem.c b/tc/q_netem.c
index 6e0e8a8c..59fb8efa 100644
--- a/tc/q_netem.c
+++ b/tc/q_netem.c
@@ -30,22 +30,22 @@
 static void explain(void)
 {
 	fprintf(stderr,
-"Usage: ... netem [ limit PACKETS ]\n" \
-"                 [ delay TIME [ JITTER [CORRELATION]]]\n" \
-"                 [ distribution {uniform|normal|pareto|paretonormal} ]\n" \
-"                 [ corrupt PERCENT [CORRELATION]]\n" \
-"                 [ duplicate PERCENT [CORRELATION]]\n" \
-"                 [ loss random PERCENT [CORRELATION]]\n" \
-"                 [ loss state P13 [P31 [P32 [P23 P14]]]\n" \
-"                 [ loss gemodel PERCENT [R [1-H [1-K]]]\n" \
-"                 [ ecn ]\n" \
-"                 [ reorder PRECENT [CORRELATION] [ gap DISTANCE ]]\n" \
-"                 [ rate RATE [PACKETOVERHEAD] [CELLSIZE] [CELLOVERHEAD]]\n" \
-"                 [ slot MIN_DELAY [MAX_DELAY] [packets MAX_PACKETS]" \
-" [bytes MAX_BYTES]]\n" \
-"                 [ slot distribution" \
-" {uniform|normal|pareto|paretonormal|custom} DELAY JITTER" \
-" [packets MAX_PACKETS] [bytes MAX_BYTES]]\n");
+		"Usage: ... netem	[ limit PACKETS ]\n" \
+		"			[ delay TIME [ JITTER [CORRELATION]]]\n" \
+		"			[ distribution {uniform|normal|pareto|paretonormal} ]\n" \
+		"			[ corrupt PERCENT [CORRELATION]]\n" \
+		"			[ duplicate PERCENT [CORRELATION]]\n" \
+		"			[ loss random PERCENT [CORRELATION]]\n" \
+		"			[ loss state P13 [P31 [P32 [P23 P14]]]\n" \
+		"			[ loss gemodel PERCENT [R [1-H [1-K]]]\n" \
+		"			[ ecn ]\n" \
+		"			[ reorder PRECENT [CORRELATION] [ gap DISTANCE ]]\n" \
+		"			[ rate RATE [PACKETOVERHEAD] [CELLSIZE] [CELLOVERHEAD]]\n" \
+		"			[ slot MIN_DELAY [MAX_DELAY] [packets MAX_PACKETS]" \
+		" [bytes MAX_BYTES]]\n" \
+		"		[ slot distribution" \
+		" {uniform|normal|pareto|paretonormal|custom} DELAY JITTER" \
+		" [packets MAX_PACKETS] [bytes MAX_BYTES]]\n");
 }
 
 static void explain1(const char *arg)
diff --git a/tc/q_pie.c b/tc/q_pie.c
index 236ea31b..40982f96 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -30,9 +30,10 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... pie [ limit PACKETS ][ target TIME us]\n");
-	fprintf(stderr, "              [ tupdate TIME us][ alpha ALPHA ]");
-	fprintf(stderr, "[beta BETA ][bytemode | nobytemode][ecn | noecn ]\n");
+	fprintf(stderr,
+		"Usage: ... pie	[ limit PACKETS ][ target TIME us]\n"
+		"		[ tupdate TIME us][ alpha ALPHA ]"
+		"[beta BETA ][bytemode | nobytemode][ecn | noecn ]\n");
 }
 
 #define ALPHA_MAX 32
diff --git a/tc/q_red.c b/tc/q_red.c
index 3b3a1204..6256420f 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -27,9 +27,10 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... red limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n");
-	fprintf(stderr, "               [adaptive] [probability PROBABILITY] [bandwidth KBPS]\n");
-	fprintf(stderr, "               [ecn] [harddrop]\n");
+	fprintf(stderr,
+		"Usage: ... red	limit BYTES [min BYTES] [max BYTES] avpkt BYTES [burst PACKETS]\n"
+		"		[adaptive] [probability PROBABILITY] [bandwidth KBPS]\n"
+		"		[ecn] [harddrop]\n");
 }
 
 static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
diff --git a/tc/q_sfq.c b/tc/q_sfq.c
index eee31ec5..4998921d 100644
--- a/tc/q_sfq.c
+++ b/tc/q_sfq.c
@@ -26,12 +26,13 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... sfq [ limit NUMBER ] [ perturb SECS ] [ quantum BYTES ]\n");
-	fprintf(stderr, "               [ divisor NUMBER ] [ flows NUMBER] [ depth NUMBER ]\n");
-	fprintf(stderr, "               [ headdrop ]\n");
-	fprintf(stderr, "               [ redflowlimit BYTES ] [ min BYTES ] [ max BYTES ]\n");
-	fprintf(stderr, "               [ avpkt BYTES ] [ burst PACKETS ] [ probability P ]\n");
-	fprintf(stderr, "               [ ecn ] [ harddrop ]\n");
+	fprintf(stderr,
+		"Usage: ... sfq	[ limit NUMBER ] [ perturb SECS ] [ quantum BYTES ]\n"
+		"		[ divisor NUMBER ] [ flows NUMBER] [ depth NUMBER ]\n"
+		"		[ headdrop ]\n"
+		"		[ redflowlimit BYTES ] [ min BYTES ] [ max BYTES ]\n"
+		"		[ avpkt BYTES ] [ burst PACKETS ] [ probability P ]\n"
+		"		[ ecn ] [ harddrop ]\n");
 }
 
 static int sfq_parse_opt(struct qdisc_util *qu, int argc, char **argv, struct nlmsghdr *n, const char *dev)
diff --git a/tc/q_taprio.c b/tc/q_taprio.c
index aad055d8..62c8c591 100644
--- a/tc/q_taprio.c
+++ b/tc/q_taprio.c
@@ -47,13 +47,14 @@ static const struct static_clockid {
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... taprio clockid CLOCKID\n");
-	fprintf(stderr, "                  [num_tc NUMBER] [map P0 P1 ...] ");
-	fprintf(stderr, "                  [queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...] ");
-	fprintf(stderr, "                  [ [sched-entry index cmd gate-mask interval] ... ] ");
-	fprintf(stderr, "                  [base-time time] ");
-	fprintf(stderr, "\nCLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)");
-	fprintf(stderr, "\n");
+	fprintf(stderr,
+		"Usage: ... taprio clockid CLOCKID\n"
+		"		[num_tc NUMBER] [map P0 P1 ...] "
+		"		[queues COUNT@OFFSET COUNT@OFFSET COUNT@OFFSET ...] "
+		"		[ [sched-entry index cmd gate-mask interval] ... ] "
+		"		[base-time time] "
+		"\n"
+		"CLOCKID must be a valid SYS-V id (i.e. CLOCK_TAI)\n");
 }
 
 static void explain_clockid(const char *val)
diff --git a/tc/q_tbf.c b/tc/q_tbf.c
index b9465b20..57a9736c 100644
--- a/tc/q_tbf.c
+++ b/tc/q_tbf.c
@@ -24,9 +24,10 @@
 
 static void explain(void)
 {
-	fprintf(stderr, "Usage: ... tbf limit BYTES burst BYTES[/BYTES] rate KBPS [ mtu BYTES[/BYTES] ]\n");
-	fprintf(stderr, "               [ peakrate KBPS ] [ latency TIME ] ");
-	fprintf(stderr, "[ overhead BYTES ] [ linklayer TYPE ]\n");
+	fprintf(stderr,
+		"Usage: ... tbf limit BYTES burst BYTES[/BYTES] rate KBPS [ mtu BYTES[/BYTES] ]\n"
+		"	[ peakrate KBPS ] [ latency TIME ] "
+		"[ overhead BYTES ] [ linklayer TYPE ]\n");
 }
 
 static void explain1(const char *arg, const char *val)
diff --git a/tc/tc.c b/tc/tc.c
index eacd5c08..e08f322a 100644
--- a/tc/tc.c
+++ b/tc/tc.c
@@ -194,14 +194,14 @@ noexist:
 static void usage(void)
 {
 	fprintf(stderr,
-		"Usage: tc [ OPTIONS ] OBJECT { COMMAND | help }\n"
-		"       tc [-force] -batch filename\n"
+		"Usage:	tc [ OPTIONS ] OBJECT { COMMAND | help }\n"
+		"	tc [-force] -batch filename\n"
 		"where  OBJECT := { qdisc | class | filter | chain |\n"
-		"                   action | monitor | exec }\n"
+		"		    action | monitor | exec }\n"
 		"       OPTIONS := { -V[ersion] | -s[tatistics] | -d[etails] | -r[aw] |\n"
-		"                    -o[neline] | -j[son] | -p[retty] | -c[olor]\n"
-		"                    -b[atch] [filename] | -n[etns] name |\n"
-		"                    -nm | -nam[es] | { -cf | -conf } path }\n");
+		"		    -o[neline] | -j[son] | -p[retty] | -c[olor]\n"
+		"		    -b[atch] [filename] | -n[etns] name |\n"
+		"		     -nm | -nam[es] | { -cf | -conf } path }\n");
 }
 
 static int do_cmd(int argc, char **argv, void *buf, size_t buflen)
diff --git a/tc/tc_class.c b/tc/tc_class.c
index 7ac700d7..c7e3cfdf 100644
--- a/tc/tc_class.c
+++ b/tc/tc_class.c
@@ -43,14 +43,15 @@ static void usage(void);
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: tc class [ add | del | change | replace | show ] dev STRING\n");
-	fprintf(stderr, "       [ classid CLASSID ] [ root | parent CLASSID ]\n");
-	fprintf(stderr, "       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "       tc class show [ dev STRING ] [ root | parent CLASSID ]\n");
-	fprintf(stderr, "Where:\n");
-	fprintf(stderr, "QDISC_KIND := { prio | cbq | etc. }\n");
-	fprintf(stderr, "OPTIONS := ... try tc class add <desired QDISC_KIND> help\n");
+	fprintf(stderr,
+		"Usage: tc class [ add | del | change | replace | show ] dev STRING\n"
+		"       [ classid CLASSID ] [ root | parent CLASSID ]\n"
+		"       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n"
+		"\n"
+		"       tc class show [ dev STRING ] [ root | parent CLASSID ]\n"
+		"Where:\n"
+		"QDISC_KIND := { prio | cbq | etc. }\n"
+		"OPTIONS := ... try tc class add <desired QDISC_KIND> help\n");
 }
 
 static int tc_class_modify(int cmd, unsigned int flags, int argc, char **argv)
diff --git a/tc/tc_exec.c b/tc/tc_exec.c
index 0151af7b..9b912ceb 100644
--- a/tc/tc_exec.c
+++ b/tc/tc_exec.c
@@ -23,10 +23,11 @@ static void *BODY;
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: tc exec [ EXEC_TYPE ] [ help | OPTIONS ]\n");
-	fprintf(stderr, "Where:\n");
-	fprintf(stderr, "EXEC_TYPE := { bpf | etc. }\n");
-	fprintf(stderr, "OPTIONS := ... try tc exec <desired EXEC_KIND> help\n");
+	fprintf(stderr,
+		"Usage: tc exec [ EXEC_TYPE ] [ help | OPTIONS ]\n"
+		"Where:\n"
+		"EXEC_TYPE := { bpf | etc. }\n"
+		"OPTIONS := ... try tc exec <desired EXEC_KIND> help\n");
 }
 
 static int parse_noeopt(struct exec_util *eu, int argc, char **argv)
diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
index c5da5b5c..e573a1df 100644
--- a/tc/tc_qdisc.c
+++ b/tc/tc_qdisc.c
@@ -27,18 +27,19 @@
 
 static int usage(void)
 {
-	fprintf(stderr, "Usage: tc qdisc [ add | del | replace | change | show ] dev STRING\n");
-	fprintf(stderr, "       [ handle QHANDLE ] [ root | ingress | clsact | parent CLASSID ]\n");
-	fprintf(stderr, "       [ estimator INTERVAL TIME_CONSTANT ]\n");
-	fprintf(stderr, "       [ stab [ help | STAB_OPTIONS] ]\n");
-	fprintf(stderr, "       [ ingress_block BLOCK_INDEX ] [ egress_block BLOCK_INDEX ]\n");
-	fprintf(stderr, "       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n");
-	fprintf(stderr, "\n");
-	fprintf(stderr, "       tc qdisc show [ dev STRING ] [ ingress | clsact ] [ invisible ]\n");
-	fprintf(stderr, "Where:\n");
-	fprintf(stderr, "QDISC_KIND := { [p|b]fifo | tbf | prio | cbq | red | etc. }\n");
-	fprintf(stderr, "OPTIONS := ... try tc qdisc add <desired QDISC_KIND> help\n");
-	fprintf(stderr, "STAB_OPTIONS := ... try tc qdisc add stab help\n");
+	fprintf(stderr,
+		"Usage: tc qdisc [ add | del | replace | change | show ] dev STRING\n"
+		"       [ handle QHANDLE ] [ root | ingress | clsact | parent CLASSID ]\n"
+		"       [ estimator INTERVAL TIME_CONSTANT ]\n"
+		"       [ stab [ help | STAB_OPTIONS] ]\n"
+		"       [ ingress_block BLOCK_INDEX ] [ egress_block BLOCK_INDEX ]\n"
+		"       [ [ QDISC_KIND ] [ help | OPTIONS ] ]\n"
+		"\n"
+		"       tc qdisc show [ dev STRING ] [ ingress | clsact ] [ invisible ]\n"
+		"Where:\n"
+		"QDISC_KIND := { [p|b]fifo | tbf | prio | cbq | red | etc. }\n"
+		"OPTIONS := ... try tc qdisc add <desired QDISC_KIND> help\n"
+		"STAB_OPTIONS := ... try tc qdisc add stab help\n");
 	return -1;
 }
 
diff --git a/tipc/bearer.c b/tipc/bearer.c
index 05dc84aa..1f3a4d44 100644
--- a/tipc/bearer.c
+++ b/tipc/bearer.c
@@ -40,19 +40,19 @@ static void _print_bearer_opts(void)
 {
 	fprintf(stderr,
 		"OPTIONS\n"
-		" priority              - Bearer link priority\n"
-		" tolerance             - Bearer link tolerance\n"
-		" window                - Bearer link window\n"
-		" mtu                   - Bearer link mtu\n");
+		" priority		- Bearer link priority\n"
+		" tolerance		- Bearer link tolerance\n"
+		" window		- Bearer link window\n"
+		" mtu			- Bearer link mtu\n");
 }
 
 void print_bearer_media(void)
 {
 	fprintf(stderr,
 		"\nMEDIA\n"
-		" udp                   - User Datagram Protocol\n"
-		" ib                    - Infiniband\n"
-		" eth                   - Ethernet\n");
+		" udp			- User Datagram Protocol\n"
+		" ib			- Infiniband\n"
+		" eth			- Ethernet\n");
 }
 
 static void cmd_bearer_enable_l2_help(struct cmdl *cmdl, char *media)
@@ -60,25 +60,23 @@ static void cmd_bearer_enable_l2_help(struct cmdl *cmdl, char *media)
 	fprintf(stderr,
 		"Usage: %s bearer enable media %s device DEVICE [OPTIONS]\n"
 		"\nOPTIONS\n"
-		" domain DOMAIN         - Discovery domain\n"
-		" priority PRIORITY     - Bearer priority\n",
+		" domain DOMAIN		- Discovery domain\n"
+		" priority PRIORITY	- Bearer priority\n",
 		cmdl->argv[0], media);
 }
 
 static void cmd_bearer_enable_udp_help(struct cmdl *cmdl, char *media)
 {
 	fprintf(stderr,
-		"Usage: %s bearer enable [OPTIONS] media %s name NAME localip IP [UDP OPTIONS]\n\n",
-		cmdl->argv[0], media);
-	fprintf(stderr,
+		"Usage: %s bearer enable [OPTIONS] media %s name NAME localip IP [UDP OPTIONS]\n\n"
 		"OPTIONS\n"
-		" domain DOMAIN         - Discovery domain\n"
-		" priority PRIORITY     - Bearer priority\n\n");
-	fprintf(stderr,
+		" domain DOMAIN		- Discovery domain\n"
+		" priority PRIORITY	- Bearer priority\n\n"
 		"UDP OPTIONS\n"
-		" localport PORT        - Local UDP port (default 6118)\n"
-		" remoteip IP           - Remote IP address\n"
-		" remoteport PORT       - Remote UDP port (default 6118)\n");
+		" localport PORT	- Local UDP port (default 6118)\n"
+		" remoteip IP		- Remote IP address\n"
+		" remoteport PORT	- Remote UDP port (default 6118)\n",
+		cmdl->argv[0], media);
 }
 
 static int get_netid_cb(const struct nlmsghdr *nlh, void *data)
@@ -996,11 +994,11 @@ void cmd_bearer_help(struct cmdl *cmdl)
 		"\n"
 		"COMMANDS\n"
 		" add			- Add data to existing bearer\n"
-		" enable                - Enable a bearer\n"
-		" disable               - Disable a bearer\n"
-		" set                   - Set various bearer properties\n"
-		" get                   - Get various bearer properties\n"
-		" list                  - List bearers\n", cmdl->argv[0]);
+		" enable		- Enable a bearer\n"
+		" disable		- Disable a bearer\n"
+		" set			- Set various bearer properties\n"
+		" get			- Get various bearer properties\n"
+		" list			- List bearers\n", cmdl->argv[0]);
 }
 
 int cmd_bearer(struct nlmsghdr *nlh, const struct cmd *cmd, struct cmdl *cmdl,
-- 
2.21.0

