Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84FD50D3AF
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 18:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235969AbiDXQ4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Apr 2022 12:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235943AbiDXQ4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Apr 2022 12:56:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8829630572;
        Sun, 24 Apr 2022 09:53:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id i27so25395878ejd.9;
        Sun, 24 Apr 2022 09:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E/OTIziF21IGiWzMKLyPsct2kcu1rIbNXYvk533K74w=;
        b=Z3po+VDlg7C0OulHSlqjB4UvMFNtCkB9qKsODSdo7rsuduEV/jP+cbcP8kIdSeEIwY
         vJkl5CjkgKGqYJP4kXzGTaP1LTQ0KIfNOjAwYPv36Tf57Imk/PXS21pUHKGnK18dhR0h
         dU02xVckFVk854aNq4SMIfS0w1wlhkalWb/WfOXKhgnJkl0H2x7MKxKK9d9y0WeMdkp8
         SBBLo7ZeE283hWG60pDBo6LNnb8wWBMH0hvb3C860hwC2zqZNt4VzupC5bNj9tCkqcuv
         1JXYYwczVub3CSzuqCWgWkEe596S0e3r/QfTGPnvHiQuro0lvGZad1zZ4xA9FOgzyBeN
         x9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E/OTIziF21IGiWzMKLyPsct2kcu1rIbNXYvk533K74w=;
        b=dKlc0Jt/BHuDyWHinuK9psZ7yEfk22dTyzOyVLHzBa9fo+kwpQUOfNsUG7F4rm3+c/
         3l8JiRKI8be8IeJO98FfU6CgASknCgGV+yBFf/eFGTc2KxUoUw8ioRo0HJtI8gz1aMKs
         4zaGQ2tzLZ+FrzPcEqBYtir7kQUVrialQJ9qxd+H1/+joIhAyCKK4K2yvx3K+n7Z1KyQ
         rNA7fZvqSZX2gt184GheAct3d6SZVnTJPyxnD1zGzpD26xNaC/udmK4n3TpMnAyj8I3M
         d9vxp9UO/a2SafD4vK+LSnuBvMy+L/JvAJGyaGlg1M54/IhWRrw185505fQokjRPZjG/
         3ZxQ==
X-Gm-Message-State: AOAM531svawS3yC974Vki8PqSI8BvbRNiabI4GcbtP6mdhSq3AFoS+R2
        mn0KT/YukxH0DoVjQO5LC48=
X-Google-Smtp-Source: ABdhPJxqfYoLmrQoC/tztY/Pyo93vCpC7ciMjY00IIZA/riau3oyV+zrDZh4BL60z/Eh4s5D26esoQ==
X-Received: by 2002:a17:907:6e18:b0:6e8:c408:1bfe with SMTP id sd24-20020a1709076e1800b006e8c4081bfemr12840693ejc.467.1650819206735;
        Sun, 24 Apr 2022 09:53:26 -0700 (PDT)
Received: from localhost.localdomain ([213.57.189.88])
        by smtp.gmail.com with ESMTPSA id g15-20020a170906520f00b006cd07ba40absm2743819ejm.160.2022.04.24.09.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Apr 2022 09:53:26 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, posk@google.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Eyal Birger <eyal.birger@gmail.com>
Subject: [PATCH bpf] selftests/bpf: test setting tunnel key from lwt xmit
Date:   Sun, 24 Apr 2022 19:53:09 +0300
Message-Id: <20220424165309.241796-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit adds test_egress_md() tests which perform a similar flow as
test_egress() only that they use gre devices in collect_md mode and set
the tunnel key from lwt bpf xmit.

VRF scenarios are not checked since it is currently not possible to set
the underlying device or vrf from bpf_set_tunnel_key().

This introduces minor changes to the existing setup for consistency with
the new tests:

- GRE key must exist as bpf_set_tunnel_key() explicitly sets the
  TUNNEL_KEY flag

- Source address for GRE traffic is set to IPv*_5 instead of IPv*_1 since
  GRE traffic is sent via veth5 so its address is selected when using
  bpf_set_tunnel_key()

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 .../selftests/bpf/progs/test_lwt_ip_encap.c   | 51 ++++++++++-
 .../selftests/bpf/test_lwt_ip_encap.sh        | 85 ++++++++++++++++++-
 2 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
index d6cb986e7533..39c6bd5402ae 100644
--- a/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
+++ b/tools/testing/selftests/bpf/progs/test_lwt_ip_encap.c
@@ -10,8 +10,11 @@
 struct grehdr {
 	__be16 flags;
 	__be16 protocol;
+	__be32 key;
 };
 
+#define GRE_KEY	0x2000
+
 SEC("encap_gre")
 int bpf_lwt_encap_gre(struct __sk_buff *skb)
 {
@@ -28,10 +31,10 @@ int bpf_lwt_encap_gre(struct __sk_buff *skb)
 	hdr.iph.ttl = 0x40;
 	hdr.iph.protocol = 47;  /* IPPROTO_GRE */
 #if __BYTE_ORDER__ == __ORDER_LITTLE_ENDIAN__
-	hdr.iph.saddr = 0x640110ac;  /* 172.16.1.100 */
+	hdr.iph.saddr = 0x640510ac;  /* 172.16.5.100 */
 	hdr.iph.daddr = 0x641010ac;  /* 172.16.16.100 */
 #elif __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__
-	hdr.iph.saddr = 0xac100164;  /* 172.16.1.100 */
+	hdr.iph.saddr = 0xac100564;  /* 172.16.5.100 */
 	hdr.iph.daddr = 0xac101064;  /* 172.16.16.100 */
 #else
 #error "Fix your compiler's __BYTE_ORDER__?!"
@@ -39,6 +42,7 @@ int bpf_lwt_encap_gre(struct __sk_buff *skb)
 	hdr.iph.tot_len = bpf_htons(skb->len + sizeof(struct encap_hdr));
 
 	hdr.greh.protocol = skb->protocol;
+	hdr.greh.flags = bpf_htons(GRE_KEY);
 
 	err = bpf_lwt_push_encap(skb, BPF_LWT_ENCAP_IP, &hdr,
 				 sizeof(struct encap_hdr));
@@ -63,9 +67,9 @@ int bpf_lwt_encap_gre6(struct __sk_buff *skb)
 	hdr.ip6hdr.payload_len = bpf_htons(skb->len + sizeof(struct grehdr));
 	hdr.ip6hdr.nexthdr = 47;  /* IPPROTO_GRE */
 	hdr.ip6hdr.hop_limit = 0x40;
-	/* fb01::1 */
+	/* fb05::1 */
 	hdr.ip6hdr.saddr.s6_addr[0] = 0xfb;
-	hdr.ip6hdr.saddr.s6_addr[1] = 1;
+	hdr.ip6hdr.saddr.s6_addr[1] = 5;
 	hdr.ip6hdr.saddr.s6_addr[15] = 1;
 	/* fb10::1 */
 	hdr.ip6hdr.daddr.s6_addr[0] = 0xfb;
@@ -73,6 +77,7 @@ int bpf_lwt_encap_gre6(struct __sk_buff *skb)
 	hdr.ip6hdr.daddr.s6_addr[15] = 1;
 
 	hdr.greh.protocol = skb->protocol;
+	hdr.greh.flags = bpf_htons(GRE_KEY);
 
 	err = bpf_lwt_push_encap(skb, BPF_LWT_ENCAP_IP, &hdr,
 				 sizeof(struct encap_hdr));
@@ -82,4 +87,42 @@ int bpf_lwt_encap_gre6(struct __sk_buff *skb)
 	return BPF_LWT_REROUTE;
 }
 
+SEC("encap_gre_md")
+int bpf_lwt_encap_gre_md(struct __sk_buff *skb)
+{
+	struct bpf_tunnel_key key;
+	int err;
+
+	__builtin_memset(&key, 0x0, sizeof(key));
+	key.remote_ipv4 = 0xac101064; /* 172.16.16.100 - always in host order */
+	key.tunnel_ttl = 0x40;
+	err = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
+				     BPF_F_ZERO_CSUM_TX | BPF_F_SEQ_NUMBER);
+	if (err)
+		return BPF_DROP;
+
+	return BPF_OK;
+}
+
+SEC("encap_gre6_md")
+int bpf_lwt_encap_gre6_md(struct __sk_buff *skb)
+{
+	struct bpf_tunnel_key key;
+	int err;
+
+	__builtin_memset(&key, 0x0, sizeof(key));
+
+	/* fb10::1 */
+	key.remote_ipv6[0] = bpf_htonl(0xfb100000);
+	key.remote_ipv6[3] = bpf_htonl(0x01);
+	key.tunnel_ttl = 0x40;
+	err = bpf_skb_set_tunnel_key(skb, &key, sizeof(key),
+				     BPF_F_ZERO_CSUM_TX | BPF_F_SEQ_NUMBER |
+				     BPF_F_TUNINFO_IPV6);
+	if (err)
+		return BPF_DROP;
+
+	return BPF_OK;
+}
+
 char _license[] SEC("license") = "GPL";
diff --git a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
index 6c69c42b1d60..86c4a172f90c 100755
--- a/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
+++ b/tools/testing/selftests/bpf/test_lwt_ip_encap.sh
@@ -37,6 +37,14 @@
 #
 #       ping: SRC->[encap at veth2:ingress]->GRE:decap->DST
 #       ping replies go DST->SRC directly
+#
+#   2c. in an egress_md test, a bpf LWT_XMIT program is installed on a
+#	route towards a collect_md gre{,6} device and sets the tunnel key
+#	such that packets are encapsulated with an IP/GRE header to route
+#	to IPv*_GRE
+#
+#       ping: SRC->[encap at gre{,6}_md:xmit]->GRE:decap->DST
+#       ping replies go DST->SRC directly
 
 if [[ $EUID -ne 0 ]]; then
 	echo "This script must be run as root"
@@ -238,7 +246,7 @@ setup()
 	ip -netns ${NS3} -6 route add ${IPv6_6}/128 dev veth8 via ${IPv6_7}
 
 	# configure IPv4 GRE device in NS3, and a route to it via the "bottom" route
-	ip -netns ${NS3} tunnel add gre_dev mode gre remote ${IPv4_1} local ${IPv4_GRE} ttl 255
+	ip -netns ${NS3} tunnel add gre_dev mode gre remote ${IPv4_5} local ${IPv4_GRE} ttl 255 key 0
 	ip -netns ${NS3} link set gre_dev up
 	ip -netns ${NS3} addr add ${IPv4_GRE} dev gre_dev
 	ip -netns ${NS1} route add ${IPv4_GRE}/32 dev veth5 via ${IPv4_6} ${VRF}
@@ -246,7 +254,7 @@ setup()
 
 
 	# configure IPv6 GRE device in NS3, and a route to it via the "bottom" route
-	ip -netns ${NS3} -6 tunnel add name gre6_dev mode ip6gre remote ${IPv6_1} local ${IPv6_GRE} ttl 255
+	ip -netns ${NS3} -6 tunnel add name gre6_dev mode ip6gre remote ${IPv6_5} local ${IPv6_GRE} ttl 255 key 0
 	ip -netns ${NS3} link set gre6_dev up
 	ip -netns ${NS3} -6 addr add ${IPv6_GRE} nodad dev gre6_dev
 	ip -netns ${NS1} -6 route add ${IPv6_GRE}/128 dev veth5 via ${IPv6_6} ${VRF}
@@ -291,13 +299,16 @@ test_ping()
 {
 	local readonly PROTO=$1
 	local readonly EXPECTED=$2
+	local readonly NOBIND=$3
 	local RET=0
 
+	BINDTODEV=$([ -z ${NOBIND} ] && echo -I veth1)
+
 	if [ "${PROTO}" == "IPv4" ] ; then
-		ip netns exec ${NS1} ping  -c 1 -W 1 -I veth1 ${IPv4_DST} 2>&1 > /dev/null
+		ip netns exec ${NS1} ping  -c 1 -W 1 ${BINDTODEV} ${IPv4_DST} 2>&1 > /dev/null
 		RET=$?
 	elif [ "${PROTO}" == "IPv6" ] ; then
-		ip netns exec ${NS1} ping6 -c 1 -W 1 -I veth1 ${IPv6_DST} 2>&1 > /dev/null
+		ip netns exec ${NS1} ping6 -c 1 -W 1 ${BINDTODEV} ${IPv6_DST} 2>&1 > /dev/null
 		RET=$?
 	else
 		echo "    test_ping: unknown PROTO: ${PROTO}"
@@ -409,6 +420,70 @@ test_egress()
 	process_test_results
 }
 
+test_egress_md()
+{
+	local readonly ENCAP=$1
+	echo "starting egress_md ${ENCAP} encap test"
+	setup
+
+	# by default, pings work
+	test_ping IPv4 0
+	test_ping IPv6 0
+
+	# remove NS2->DST routes, ping fails
+	ip -netns ${NS2}    route del ${IPv4_DST}/32  dev veth3
+	ip -netns ${NS2} -6 route del ${IPv6_DST}/128 dev veth3
+	test_ping IPv4 1
+	test_ping IPv6 1
+
+	# install replacement routes (LWT/eBPF), pings succeed
+	if [ "${ENCAP}" == "IPv4" ] ; then
+		ip -net ${NS1} link add gre_md type gre external
+		ip -netns ${NS1}    addr add ${IPv4_1}/24  dev gre_md
+		ip -netns ${NS1} -6 addr add ${IPv6_1}/128 nodad dev gre_md
+		ip -netns ${NS1} link set gre_md up
+
+		ip -netns ${NS1} route add ${IPv4_DST} encap bpf xmit obj \
+			test_lwt_ip_encap.o sec encap_gre_md dev gre_md
+		ip -netns ${NS1} -6 route add ${IPv6_DST} encap bpf xmit obj \
+			test_lwt_ip_encap.o sec encap_gre_md dev gre_md
+	elif [ "${ENCAP}" == "IPv6" ] ; then
+		ip -net ${NS1} link add gre6_md type ip6gre external
+		ip -netns ${NS1}    addr add ${IPv4_1}/24  dev gre6_md
+		ip -netns ${NS1} -6 addr add ${IPv6_1}/128 nodad dev gre6_md
+		ip -netns ${NS1} link set gre6_md up
+
+		ip -netns ${NS1} route add ${IPv4_DST} encap bpf xmit obj \
+			test_lwt_ip_encap.o sec encap_gre6_md dev gre6_md
+		ip -netns ${NS1} -6 route add ${IPv6_DST} encap bpf xmit obj \
+			test_lwt_ip_encap.o sec encap_gre6_md dev gre6_md
+	else
+		echo "    unknown encap ${ENCAP}"
+		TEST_STATUS=1
+	fi
+
+	# Due to the asymmetry of the traffic flow we do not bind to device
+
+	test_ping IPv4 0 nobind
+	test_ping IPv6 0 nobind
+
+	test_gso IPv4
+	test_gso IPv6
+
+	# a negative test: remove routes to GRE devices: ping fails
+	remove_routes_to_gredev
+	test_ping IPv4 1 nobind
+	test_ping IPv6 1 nobind
+
+	# another negative test
+	add_unreachable_routes_to_gredev
+	test_ping IPv4 1 nobind
+	test_ping IPv6 1 nobind
+
+	cleanup
+	process_test_results
+}
+
 test_ingress()
 {
 	local readonly ENCAP=$1
@@ -465,6 +540,8 @@ test_egress IPv4
 test_egress IPv6
 test_ingress IPv4
 test_ingress IPv6
+test_egress_md IPv4
+test_egress_md IPv6
 
 VRF="vrf red"
 test_egress IPv4
-- 
2.34.1

