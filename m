Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014503B827A
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 14:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234812AbhF3MyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 08:54:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59362 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234794AbhF3MyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Jun 2021 08:54:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625057510;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vmlEc7BRwRklazdkT1yBzgyfwWXXs4DP38lEt6D8vPg=;
        b=RriN5BorCFbaltzXyvKyl2kapy5rVuiVg2oEObSIlM6uV4N4WsIhf97nEyK6j1Zqz1Sgjw
        nwGUnOv7R8rB25mUMwz22ZKag26ZW8BINYoXCP8nuWQxo1lAT70E3ABPxsh2RWE9aJYU5k
        EgxUCFi8qDLp6msdgZVE6ljucGFi82Q=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-MaWc2LkuMeCLCxJuZCAZdw-1; Wed, 30 Jun 2021 08:51:48 -0400
X-MC-Unique: MaWc2LkuMeCLCxJuZCAZdw-1
Received: by mail-wm1-f72.google.com with SMTP id k8-20020a05600c1c88b02901b7134fb829so464486wms.5
        for <netdev@vger.kernel.org>; Wed, 30 Jun 2021 05:51:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vmlEc7BRwRklazdkT1yBzgyfwWXXs4DP38lEt6D8vPg=;
        b=GSUIC4ePtUzmwSH+kAWyo7Vz+G0CNqwOoVqctjQDYQNKilNkXmfXA/gfcZ5hpYFrOu
         IoqslPatEIuikfRc7yZdehIymEAXyIOHPi/BQaMr51DJsfSQK99GZfN+BWwIn2lz+TL/
         k4e42ZcGGzrQKIXjtA8xnOm9zMct3X9MUOPshm3uY/wxvpgukMKm3W6xCRm37ob+QZLf
         GLTiv/ZeJ7VaxyTrHlkJoqe81ieCpjbB4FBp25k3sS2zeL+QkxdRL0EvrqbJEKR2aToK
         vcmlzn2UaZno0QPtnP8i4eUIv6veLe4smtoe5oBB0dBSSxjAUkOiDVsuptVIm4yQrNh5
         Hj2Q==
X-Gm-Message-State: AOAM533weDnN7awF+laav4t3AfRu28i5sAD0UvfTTKVgeUROlTh0klLR
        /Bf+xCXSpoIPWeoFEO77C62VQd6bp4uERuSLCc7EdghyjJNm2MtE9vHM9pBh4bKgc48Yi0RDcPj
        6UczozYKULhUYgtto
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr39650845wrt.296.1625057507595;
        Wed, 30 Jun 2021 05:51:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/z0yTUQ82kcINzCdIP308oyLfib5e0SKB8ho1B0Sxjzwhdfu/d+VuFCU7w/Tx5b++OoL9Yw==
X-Received: by 2002:a5d:4d10:: with SMTP id z16mr39650835wrt.296.1625057507475;
        Wed, 30 Jun 2021 05:51:47 -0700 (PDT)
Received: from pc-23.home (2a01cb058d44a7001b6d03f4d258668b.ipv6.abo.wanadoo.fr. [2a01:cb05:8d44:a700:1b6d:3f4:d258:668b])
        by smtp.gmail.com with ESMTPSA id w9sm21654363wru.3.2021.06.30.05.51.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 05:51:47 -0700 (PDT)
Date:   Wed, 30 Jun 2021 14:51:45 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: [PATCH net-next 3/4] selftests: forwarding: Test redirecting ip6gre
 and ip6tnl packets to Ethernet
Message-ID: <a7e9114c4c091fe7a39cc4c7ab42b6c1f53b3df4.1625056665.git.gnault@redhat.com>
References: <cover.1625056665.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1625056665.git.gnault@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add selftests for the following commit:
  * da5a2e49f064 ("ip6_tunnel: allow redirecting ip6gre and ipxip6
    packets to eth devices").

Like with the previous tc_redirect_l2l3.sh tests, verify that the
following tc filter works on the ingress qdisc of ip6gre and ip6tnl
devices:
  $ tc filter add dev tunnel0 ingress matchall       \
      action vlan push_eth dst_mac 00:00:5e:00:53:01 \
                           src_mac 00:00:5e:00:53:00 \
      action mirred egress redirect dev eth0

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/forwarding/config |  2 ++
 .../net/forwarding/tc_redirect_l2l3.sh        | 36 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/config b/tools/testing/selftests/net/forwarding/config
index c543b441a8b5..5d3ab2b63c53 100644
--- a/tools/testing/selftests/net/forwarding/config
+++ b/tools/testing/selftests/net/forwarding/config
@@ -19,3 +19,5 @@ CONFIG_NET_NS=y
 CONFIG_NET_IPGRE=m
 CONFIG_NET_IPIP=m
 CONFIG_IPV6_SIT=m
+CONFIG_IPV6_GRE=m
+CONFIG_IPV6_TUNNEL=m
diff --git a/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
index fd9e15a6417b..207b92775a6c 100755
--- a/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
+++ b/tools/testing/selftests/net/forwarding/tc_redirect_l2l3.sh
@@ -25,6 +25,8 @@ ALL_TESTS="
 	redir_gre
 	redir_ipip
 	redir_sit
+	redir_ip6gre
+	redir_ip6tnl
 "
 
 NUM_NETIFS=0
@@ -318,6 +320,40 @@ redir_sit()
 	cleanup_tunnel
 }
 
+redir_ip6gre()
+{
+	setup_tunnel "ipv6" "classical" "ip6gre"
+	ping_test ipv4 "IP6GRE, classical mode: IPv6 / GRE / IPv4"
+	ping_test ipv6 "IP6GRE, classical mode: IPv6 / GRE / IPv6"
+	ping_test ipv4-mpls "IP6GRE, classical mode: IPv6 / GRE / MPLS / IPv4"
+	ping_test ipv6-mpls "IP6GRE, classical mode: IPv6 / GRE / MPLS / IPv6"
+	cleanup_tunnel
+
+	setup_tunnel "ipv6" "collect_md" "ip6gre" "external" "nocsum"
+	ping_test ipv4 "IP6GRE, external mode: IPv6 / GRE / IPv4"
+	ping_test ipv6 "IP6GRE, external mode: IPv6 / GRE / IPv6"
+	ping_test ipv4-mpls "IP6GRE, external mode: IPv6 / GRE / MPLS / IPv4"
+	ping_test ipv6-mpls "IP6GRE, external mode: IPv6 / GRE / MPLS / IPv6"
+	cleanup_tunnel
+}
+
+redir_ip6tnl()
+{
+	setup_tunnel "ipv6" "classical" "ip6tnl" "mode any"
+	ping_test ipv4 "IP6TNL, classical mode: IPv6 / IPv4"
+	ping_test ipv6 "IP6TNL, classical mode: IPv6 / IPv6"
+	ping_test ipv4-mpls "IP6TNL, classical mode: IPv6 / MPLS / IPv4"
+	ping_test ipv6-mpls "IP6TNL, classical mode: IPv6 / MPLS / IPv6"
+	cleanup_tunnel
+
+	setup_tunnel "ipv6" "collect_md" "ip6tnl" "mode any external"
+	ping_test ipv4 "IP6TNL, external mode: IPv6 / IPv4"
+	ping_test ipv6 "IP6TNL, external mode: IPv6 / IPv6"
+	ping_test ipv4-mpls "IP6TNL, external mode: IPv6 / MPLS / IPv4"
+	ping_test ipv6-mpls "IP6TNL, external mode: IPv6 / MPLS / IPv6"
+	cleanup_tunnel
+}
+
 exit_cleanup()
 {
 	if [ "${TESTS_COMPLETED}" = "no" ]; then
-- 
2.21.3

