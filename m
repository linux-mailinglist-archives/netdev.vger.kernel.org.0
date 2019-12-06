Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFCF115037
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 13:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726234AbfLFMRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 07:17:15 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43255 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfLFMRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 07:17:15 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1idCXo-00079d-9v; Fri, 06 Dec 2019 12:17:12 +0000
Date:   Fri, 6 Dec 2019 09:17:07 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        posk@google.com
Subject: Re: [PATCH] selftests: net: ip_defrag: increase netdev_max_backlog
Message-ID: <20191206121707.GC5083@calabresa>
References: <20191204195321.406365-1-cascardo@canonical.com>
 <483097a3-92ec-aedd-60d9-ab7f58b9708d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483097a3-92ec-aedd-60d9-ab7f58b9708d@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 04, 2019 at 12:03:57PM -0800, Eric Dumazet wrote:
> 
> 
> On 12/4/19 11:53 AM, Thadeu Lima de Souza Cascardo wrote:
> > When using fragments with size 8 and payload larger than 8000, the backlog
> > might fill up and packets will be dropped, causing the test to fail. This
> > happens often enough when conntrack is on during the IPv6 test.
> > 
> > As the larger payload in the test is 10000, using a backlog of 1250 allow
> > the test to run repeatedly without failure. At least a 1000 runs were
> > possible with no failures, when usually less than 50 runs were good enough
> > for showing a failure.
> > 
> > As netdev_max_backlog is not a pernet setting, this sets the backlog to
> > 1000 during exit to prevent disturbing following tests.
> > 
> 
> Hmmm... I would prefer not changing a global setting like that.
> This is going to be flaky since we often run tests in parallel (using different netns)
> 
> What about adding a small delay after each sent packet ?
> 
> diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
> index c0c9ecb891e1d78585e0db95fd8783be31bc563a..24d0723d2e7e9b94c3e365ee2ee30e9445deafa8 100644
> --- a/tools/testing/selftests/net/ip_defrag.c
> +++ b/tools/testing/selftests/net/ip_defrag.c
> @@ -198,6 +198,7 @@ static void send_fragment(int fd_raw, struct sockaddr *addr, socklen_t alen,
>                 error(1, 0, "send_fragment: %d vs %d", res, frag_len);
>  
>         frag_counter++;
> +       usleep(1000);
>  }
>  
>  static void send_udp_frags(int fd_raw, struct sockaddr *addr,
> 

That won't work because the issue only shows when we using conntrack, as the
packet will be reassembled on output, then fragmented again. When this happens,
the fragmentation code is transmitting the fragments in a tight loop, which
floods the backlog.

One other option is limit the number of fragments to a 1000, like the following
patch:

diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
index c0c9ecb891e1..f4086ba9d16c 100644
--- a/tools/testing/selftests/net/ip_defrag.c
+++ b/tools/testing/selftests/net/ip_defrag.c
@@ -16,6 +16,9 @@
 #include <time.h>
 #include <unistd.h>
 
+#define ALIGN(x, sz) ((x + (sz-1)) & ~(sz-1))
+#define MAX(a, b) ((a < b) ? b : a)
+
 static bool		cfg_do_ipv4;
 static bool		cfg_do_ipv6;
 static bool		cfg_verbose;
@@ -362,6 +365,7 @@ static void run_test(struct sockaddr *addr, socklen_t alen, bool ipv6)
 
 	for (payload_len = min_frag_len; payload_len < MSG_LEN_MAX;
 			payload_len += (rand() % 4096)) {
+		min_frag_len = MAX(8, ALIGN(payload_len / 1000, 8));
 		if (cfg_verbose)
 			printf("payload_len: %d\n", payload_len);
 
