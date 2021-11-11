Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 810F144D91D
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 16:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhKKPXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 10:23:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhKKPXi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 10:23:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 722D8610D0;
        Thu, 11 Nov 2021 15:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636644049;
        bh=lHL5BysVR2OzwoaprjNGs9Nb/KHLN+fSl6riUkreLz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MyPUIeFXfdYu6kuNx8Fxo7aEHkRawm8SefGJyNylOdvyokpXMYHuOhkxUxx+B4IG8
         FiUs+vxz+eYACHIEUyqYBv+9cXOWPdXl6+scbmIrLc61GrWgUn52EbXI4qBVcs4zP8
         Y5rmPRBy233IuPnVjAFkMcyzi0iBb2ZJUnXfCmAL5O/y5VZ2ntpvFcfEdCdCCtgIJj
         nta3HwGn3hFIvCedzWWtDfDuePBdlrArcP3xsHCp2k+WTe+cpcqUjhdoHeY3jZAJqf
         aaVIOJkebXToFIYp5uQqGPzcXbLkQH39TasdCyXFKZZ7Njwhl84QBwMpVfJ13JNfkA
         tfCE5KtPXlV6w==
Date:   Thu, 11 Nov 2021 07:20:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: net: properly support IPv6 in GSO GRE test
Message-ID: <20211111072048.00852448@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211104104613.17204-1-andrea.righi@canonical.com>
References: <20211104104613.17204-1-andrea.righi@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 11:46:13 +0100 Andrea Righi wrote:
> Explicitly pass -6 to netcat when the test is using IPv6 to prevent
> failures.
> 
> Also make sure to pass "-N" to netcat to close the socket after EOF on
> the client side, otherwise we would always hit the timeout and the test
> would fail.
> 
> Without this fix applied:
> 
>  TEST: GREv6/v4 - copy file w/ TSO                                   [FAIL]
>  TEST: GREv6/v4 - copy file w/ GSO                                   [FAIL]
>  TEST: GREv6/v6 - copy file w/ TSO                                   [FAIL]
>  TEST: GREv6/v6 - copy file w/ GSO                                   [FAIL]
> 
> With this fix applied:
> 
>  TEST: GREv6/v4 - copy file w/ TSO                                   [ OK ]
>  TEST: GREv6/v4 - copy file w/ GSO                                   [ OK ]
>  TEST: GREv6/v6 - copy file w/ TSO                                   [ OK ]
>  TEST: GREv6/v6 - copy file w/ GSO                                   [ OK ]
> 
> Fixes: 025efa0a82df ("selftests: add simple GSO GRE test")
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>

This breaks the test for me on Fedora now :(

nc: invalid option -- 'N'
Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
    TEST: GREv6/v4 - copy file w/ TSO                                   [FAIL]
nc: invalid option -- 'N'
Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
    TEST: GREv6/v4 - copy file w/ GSO                                   [FAIL]
nc: invalid option -- 'N'
Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
    TEST: GREv6/v6 - copy file w/ TSO                                   [FAIL]
nc: invalid option -- 'N'
Ncat: Try `--help' or man(1) ncat for more information, usage options and help. QUITTING.
    TEST: GREv6/v6 - copy file w/ GSO                                   [FAIL]

Tests passed:   0
Tests failed:   4


Can you please test this on your distro?

--->8-----

diff --git a/tools/testing/selftests/net/gre_gso.sh b/tools/testing/selftests/net/gre_gso.sh
index fdeb44d621eb..3224651db97b 100755
--- a/tools/testing/selftests/net/gre_gso.sh
+++ b/tools/testing/selftests/net/gre_gso.sh
@@ -118,16 +118,18 @@ gre_gst_test_checks()
 	local addr=$2
 	local proto=$3
 
-	$NS_EXEC nc $proto -kl $port >/dev/null &
+	[ "$proto" == 6 ] && addr="[$addr]"
+
+	$NS_EXEC socat - tcp${proto}-listen:$port,reuseaddr,fork >/dev/null &
 	PID=$!
 	while ! $NS_EXEC ss -ltn | grep -q $port; do ((i++)); sleep 0.01; done
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ TSO"
 
 	ethtool -K veth0 tso off
 
-	cat $TMPFILE | timeout 1 nc $proto -N $addr $port
+	cat $TMPFILE | timeout 1 socat -u STDIN TCP:$addr:$port
 	log_test $? 0 "$name - copy file w/ GSO"
 
 	ethtool -K veth0 tso on
@@ -155,8 +157,8 @@ gre6_gso_test()
 
 	sleep 2
 
-	gre_gst_test_checks GREv6/v4 172.16.2.2
-	gre_gst_test_checks GREv6/v6 2001:db8:1::2 -6
+	gre_gst_test_checks GREv6/v4 172.16.2.2 4
+	gre_gst_test_checks GREv6/v6 2001:db8:1::2 6
 
 	cleanup
 }
@@ -212,8 +214,8 @@ if [ ! -x "$(command -v ip)" ]; then
 	exit $ksft_skip
 fi
 
-if [ ! -x "$(command -v nc)" ]; then
-	echo "SKIP: Could not run test without nc tool"
+if [ ! -x "$(command -v socat)" ]; then
+	echo "SKIP: Could not run test without socat tool"
 	exit $ksft_skip
 fi
 
