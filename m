Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC4A3B0D2
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 10:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388103AbfFJIlk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 04:41:40 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:39957 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388042AbfFJIlj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 04:41:39 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id E61A420C69;
        Mon, 10 Jun 2019 04:41:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 10 Jun 2019 04:41:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Nae0wN/WvGYsSFDNfturK68E2+JseFdGlne9Be59VX8=; b=B0bHvPr6
        CTzHMoj4xtyNPGGq+orKtbouidWcgrwsgnuJbQQ0DiuL7sa7fN2/JTYWxYhic03f
        o4+AJcGw2P5RG9gnk2P+QIY3zrgJlJDkXCEHXQa1LfAx6YDIrmL8LUGkPrwjjmQg
        syBK7CD6AqYctTsfJZ08XqP/L13JhrJQkjo97wb0bCNl/uO/PMZNOpLiyHqNPPm6
        mfW2Cjdb+n9Cw1ihbJuhc4EBEcCIedax/Jg5VRs4mmnleu6Dfg0ZflCNZVtMbcgC
        lpYtLZt5TIiRJZuBvz9hS+JXtK8+XERlA+EIFWxYnw3klOQAZaCvG9tB4lhDpa3N
        UHGDea6yJJINuw==
X-ME-Sender: <xms:whf-XLwUvtt4WzXSCq5o9_mWJLkuyC5aaw0MsJ9RPH7X60rqch4erQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehvddgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:whf-XJafanlaVAyokXpwy7CpYQjULQqHjKlWKCMyRxxp0nItrzKLbA>
    <xmx:whf-XL1oQHoVeddJSsoLLDhblRGxejN3CuuE_5XTO6fjrQliFvJHUA>
    <xmx:whf-XPj7WjAiMhb8XAfU-xkb2h3Ekx7gfx4-q3EQCgixcBCLxCdstQ>
    <xmx:whf-XDeGcDjWCAghD5r1HFa-boRCy1kyOH0bpZgAJYNOzcsAM3eHFQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9ABD980065;
        Mon, 10 Jun 2019 04:41:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, amitc@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] selftests: mlxsw: Add ethtool_lib.sh
Date:   Mon, 10 Jun 2019 11:40:43 +0300
Message-Id: <20190610084045.6029-2-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190610084045.6029-1-idosch@idosch.org>
References: <20190610084045.6029-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Functions:
1. ethtool_set:
	params: cmd
	The function runs ethtool by cmd (ethtool -s cmd) and checks if there
	 was an error in configuration

2. speeds_get:
	params: dev, with_mode (0 or 1)
	return value: Array of supported link modes with/without mode.

	* Example 1:
	speeds_get swp1 0
	return: 1000 10000 40000
	* Example 2:
	speeds_get swp1 1
	return: 1000baseKX/Full 10000baseKR/Full 40000baseCR4/Full 40000baseSR4/Full

3. common_speeds_get:
	params: dev1, dev2, with_mode (0 or 1)
	return value: Array of common speeds of dev1 and dev2.

	* Example:
	common_speeds_get swp1 swp2 0
	return: 1000 10000
	(assume that swp1 supports 1000 10000 40000 and swp2 supports 1000 10000)

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../selftests/net/forwarding/ethtool_lib.sh   | 91 +++++++++++++++++++
 1 file changed, 91 insertions(+)
 create mode 100755 tools/testing/selftests/net/forwarding/ethtool_lib.sh

diff --git a/tools/testing/selftests/net/forwarding/ethtool_lib.sh b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
new file mode 100755
index 000000000000..6dcbbd228047
--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/ethtool_lib.sh
@@ -0,0 +1,91 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+declare -A speed_values
+
+speed_values=(	[10baseT/Half]=0x001
+		[10baseT/Full]=0x002
+		[100baseT/Half]=0x004
+		[100baseT/Full]=0x008
+		[1000baseT/Half]=0x010
+		[1000baseT/Full]=0x020
+		[1000baseKX/Full]=0x20000
+		[1000baseX/Full]=0x20000000000
+		[2500baseT/Full]=0x800000000000
+		[2500baseX/Full]=0x8000
+		[5000baseT/Full]=0x1000000000000
+		[10000baseT/Full]=0x1000
+		[10000baseKX4/Full]=0x40000
+		[10000baseKR/Full]=0x80000
+		[10000baseCR/Full]=0x40000000000
+		[10000baseSR/Full]=0x80000000000
+		[10000baseLR/Full]=0x100000000000
+		[10000baseLRM/Full]=0x200000000000
+		[10000baseER/Full]=0x400000000000
+		[20000baseMLD2/Full]=0x200000
+		[20000baseKR2/Full]=0x400000
+		[25000baseCR/Full]=0x80000000
+		[25000baseKR/Full]=0x100000000
+		[25000baseSR/Full]=0x200000000
+		[40000baseKR4/Full]=0x800000
+		[40000baseCR4/Full]=0x1000000
+		[40000baseSR4/Full]=0x2000000
+		[40000baseLR4/Full]=0x4000000
+		[50000baseCR2/Full]=0x400000000
+		[40000baseSR4/Full]=0x2000000
+		[40000baseLR4/Full]=0x4000000
+		[50000baseCR2/Full]=0x400000000
+		[50000baseKR2/Full]=0x800000000
+		[50000baseSR2/Full]=0x10000000000
+		[56000baseKR4/Full]=0x8000000
+		[56000baseCR4/Full]=0x10000000
+		[56000baseSR4/Full]=0x20000000
+		[56000baseLR4/Full]=0x40000000
+		[100000baseKR4/Full]=0x1000000000
+		[100000baseSR4/Full]=0x2000000000
+		[100000baseCR4/Full]=0x4000000000
+		[100000baseLR4_ER4/Full]=0x8000000000)
+
+ethtool_set()
+{
+	local cmd="$@"
+	local out=$(ethtool -s $cmd 2>&1 | wc -l)
+	check_err $out "error in configuration. $cmd"
+}
+
+speeds_get()
+{
+	local dev=$1; shift
+	local with_mode=$1; shift
+
+	local speeds_str=$(ethtool "$dev" | \
+		# Snip everything before the link modes section.
+		sed -n '/Supported link modes:/,$p' | \
+		# Quit processing the rest at the start of the next section.
+		# When checking, skip the header of this section (hence the 2,).
+		sed -n '2,${/^[\t][^ \t]/q};p' | \
+		# Drop the section header of the current section.
+		cut -d':' -f2)
+
+	local -a speeds_arr=($speeds_str)
+	if [[ $with_mode -eq 0 ]]; then
+		for ((i=0; i<${#speeds_arr[@]}; i++)); do
+			speeds_arr[$i]=${speeds_arr[$i]%base*}
+		done
+	fi
+	echo ${speeds_arr[@]}
+}
+
+common_speeds_get()
+{
+	dev1=$1; shift
+	dev2=$1; shift
+	with_mode=$1; shift
+
+	local -a dev1_speeds=($(speeds_get $dev1 $with_mode))
+	local -a dev2_speeds=($(speeds_get $dev2 $with_mode))
+
+	comm -12 \
+		<(printf '%s\n' "${dev1_speeds[@]}" | sort -u) \
+		<(printf '%s\n' "${dev2_speeds[@]}" | sort -u)
+}
-- 
2.20.1

