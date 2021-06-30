Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5FD53B827C
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234784AbhF3MyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:54:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:32662 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234804AbhF3MyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:54:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625057514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=84cTndThNFAP1cz9xpPfYSoGM0TMxENWRGeocdlBP7E=;
        b=c6VvIsAQSFA9kXlZs29RM0gR3Rv33R7Po+Ou3Yp1irEQk5qi0P/A6ksfvqpjPB+sFn+xJl
        G1iYilMpgAmVaVPgl+n2H4uk38k+6DVT707eWM6GEbBIWbqOYJ6Hoe/J7lbD8B/zYmesmP
        I8ehniI+idtB7p/3TuAG4DcOECrHb4U=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-67U17UdGNTiaTAoUPDsb8w-1; Wed, 30 Jun 2021 08:51:52 -0400
X-MC-Unique: 67U17UdGNTiaTAoUPDsb8w-1
Received: by mail-wm1-f71.google.com with SMTP id y14-20020a1c7d0e0000b02901edd7784928so2797193wmc.2
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:51:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=84cTndThNFAP1cz9xpPfYSoGM0TMxENWRGeocdlBP7E=;
        b=Ynq03QtsKtT3iSFweJRkrjagipxAmERja1DjSSS+PQ1LeF44fooEfGCfQRqg4Ubhcs
         BMCZ2WH9DZRSc4jbGnmVZfUni9loTmbzM8snrdHD4BGVSYFrDcFReDB0GnA2HQDspctP
         U7N/q5qZi7x3yiPLw2jUQ4HbhmzlxA7pZxHOi6NC/xyJHmC+79gXM2Zwoc+sgazwHNK8
         cMgkU5a940NnRdGrwC7GE9OzY8ovuq9SpRiOwrP9sDFogw8E/uBOz6rPifWcswGvA9ZU
         m61PYgESsxadeaowy/AavwSSrOfwvyY6k1Tud7FMTUlnEPDc67/9O88lKXQQOajs0tZ8
         p2hA==
X-Gm-Message-State: AOAM5308+6LxTdasHO4yfsvepMtxpyuMKPv5zk0zRMG/FqwD7BTB/YyP
        TklFtXiGT6eQBA1jbNdS6gGuND7NDvphpsozC1QnhHnCfg4rri1YdpWuC8xostjdJHW21wLwr7T
        qw+ZvkddDvSMTPqZ3
X-Received: by 2002:a05:600c:2243:: with SMTP id a3mr4509984wmm.86.1625057511796;
        Wed, 30 Jun 2021 05:51:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJtHA1JpXRvoSoeZX/KpRktkcHYi/igAmdcBzVYumDkUdf7bojHz46vt8JXkhH0vapodEjcA==
X-Received: by 2002:a05:600c:2243:: with SMTP id a3mr4509967wmm.86.1625057511624;
        Wed, 30 Jun 2021 05:51:51 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id n8sm21822762wrt.95.2021.06.30.05.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:51:51 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:51:49 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 4/4] selftests: forwarding: Test redirecting vxlan
 and bareudp packets to Ethernet
Message-ID: <340d1bce299c23e3f7e97d8b71b0f38a2ce0a7e3.1625056665.git.gnault@redhat.com>
References: <cover.1625056665.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1625056665.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for the following commit:
  * 99c8719b7981 ("bareudp: allow redirecting bareudp packets to eth
    devices").
(no commit for VXLAN-GPE, which has always worked in this configuration).

Only test collect-md mode as both bareudp and vxlan-gpe devices don't
currently implement classical mode.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/forwarding/config |  2 +
 .../net/forwarding/tc_redirect_l2l3.sh        | 55 +++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/config b/tools/testing/selftests/net/forwarding/config
index 5d3ab2b63c53..ec49660ee808 100644
--- a/tools/testing/selftests/net/forwarding/config
+++ b/tools/testing/selftests/net/forwarding/config
@@ -21,3 +21,5 @@ CONFIG_NET_IPIP=m
 CONFIG_IPV6_SIT=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_TUNNEL=m
+CONFIG_VXLAN=m
+CONFIG_BAREUDP=m
diff --git a/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
index 207b92775a6c..db8ccef9a334 100755
--- a/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
+++ b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
@@ -27,6 +27,8 @@ ALL_TESTS="
 	redir_sit
 	redir_ip6gre
 	redir_ip6tnl
+	redir_vxlan_gpe
+	redir_bareudp
 "
 
 NUM_NETIFS=0
@@ -354,6 +356,59 @@ redir_ip6tnl()
 	cleanup_tunnel
 }
 
+redir_vxlan_gpe()
+{
+	local IP
+
+	# As of Linux 5.13, VXLAN-GPE only supports collect-md mode
+	for UNDERLAY_IPVERS in 4 6; do
+		IP="IPv${UNDERLAY_IPVERS}"
+
+		setup_tunnel "${IP}" "collect_md" "vxlan" "gpe external" "id 10"
+		ping_test ipv4 "VXLAN-GPE, external mode: ${IP} / UDP / VXLAN-GPE / IPv4"
+		ping_test ipv6 "VXLAN-GPE, external mode: ${IP} / UDP / VXLAN-GPE / IPv6"
+		ping_test ipv4-mpls "VXLAN-GPE, external mode: ${IP} / UDP / VXLAN-GPE / MPLS / IPv4"
+		ping_test ipv6-mpls "VXLAN-GPE, external mode: ${IP} / UDP / VXLAN-GPE / MPLS / IPv6"
+		cleanup_tunnel
+	done
+}
+
+redir_bareudp()
+{
+	local IP
+
+	# As of Linux 5.13, Bareudp only supports collect-md mode
+	for UNDERLAY_IPVERS in 4 6; do
+		IP="IPv${UNDERLAY_IPVERS}"
+
+		# IPv4 overlay
+		setup_tunnel "${IP}" "collect_md" "bareudp" \
+			"dstport 6635 ethertype ipv4"
+		ping_test ipv4 "Bareudp, external mode: ${IP} / UDP / IPv4"
+		cleanup_tunnel
+
+		# IPv6 overlay
+		setup_tunnel "${IP}" "collect_md" "bareudp" \
+			"dstport 6635 ethertype ipv6"
+		ping_test ipv6 "Bareudp, external mode: ${IP} / UDP / IPv6"
+		cleanup_tunnel
+
+		# Combined IPv4/IPv6 overlay (multiproto mode)
+		setup_tunnel "${IP}" "collect_md" "bareudp" \
+			"dstport 6635 ethertype ipv4 multiproto"
+		ping_test ipv4 "Bareudp, external mode: ${IP} / UDP / IPv4 (multiproto)"
+		ping_test ipv6 "Bareudp, external mode: ${IP} / UDP / IPv6 (multiproto)"
+		cleanup_tunnel
+
+		# MPLS overlay
+		setup_tunnel "${IP}" "collect_md" "bareudp" \
+			"dstport 6635 ethertype mpls_uc"
+		ping_test ipv4-mpls "Bareudp, external mode: ${IP} / UDP / MPLS / IPv4"
+		ping_test ipv6-mpls "Bareudp, external mode: ${IP} / UDP / MPLS / IPv6"
+		cleanup_tunnel
+	done
+}
+
 exit_cleanup()
 {
 	if [ "${TESTS_COMPLETED}" = "no" ]; then
-- 
2.21.3

