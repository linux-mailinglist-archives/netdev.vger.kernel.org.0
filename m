Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB61153A3
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 15:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfLFOuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 09:50:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46572 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfLFOuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 09:50:17 -0500
Received: from 1.general.cascardo.us.vpn ([10.172.70.58] helo=calabresa)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <cascardo@canonical.com>)
        id 1idEvu-00034D-OY; Fri, 06 Dec 2019 14:50:15 +0000
Date:   Fri, 6 Dec 2019 11:50:10 -0300
From:   Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        posk@google.com
Subject: Re: [PATCH] selftests: net: ip_defrag: increase netdev_max_backlog
Message-ID: <20191206145010.GE5083@calabresa>
References: <20191204195321.406365-1-cascardo@canonical.com>
 <483097a3-92ec-aedd-60d9-ab7f58b9708d@gmail.com>
 <20191206121707.GC5083@calabresa>
 <d2dddb34-f126-81f8-cbf7-04635f04795a@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2dddb34-f126-81f8-cbf7-04635f04795a@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 05:41:01AM -0800, Eric Dumazet wrote:
> 
> 
> On 12/6/19 4:17 AM, Thadeu Lima de Souza Cascardo wrote:
> > On Wed, Dec 04, 2019 at 12:03:57PM -0800, Eric Dumazet wrote:
> >>
> >>
> >> On 12/4/19 11:53 AM, Thadeu Lima de Souza Cascardo wrote:
> >>> When using fragments with size 8 and payload larger than 8000, the backlog
> >>> might fill up and packets will be dropped, causing the test to fail. This
> >>> happens often enough when conntrack is on during the IPv6 test.
> >>>
> >>> As the larger payload in the test is 10000, using a backlog of 1250 allow
> >>> the test to run repeatedly without failure. At least a 1000 runs were
> >>> possible with no failures, when usually less than 50 runs were good enough
> >>> for showing a failure.
> >>>
> >>> As netdev_max_backlog is not a pernet setting, this sets the backlog to
> >>> 1000 during exit to prevent disturbing following tests.
> >>>
> >>
> >> Hmmm... I would prefer not changing a global setting like that.
> >> This is going to be flaky since we often run tests in parallel (using different netns)
> >>
> >> What about adding a small delay after each sent packet ?
> >>
> >> diff --git a/tools/testing/selftests/net/ip_defrag.c b/tools/testing/selftests/net/ip_defrag.c
> >> index c0c9ecb891e1d78585e0db95fd8783be31bc563a..24d0723d2e7e9b94c3e365ee2ee30e9445deafa8 100644
> >> --- a/tools/testing/selftests/net/ip_defrag.c
> >> +++ b/tools/testing/selftests/net/ip_defrag.c
> >> @@ -198,6 +198,7 @@ static void send_fragment(int fd_raw, struct sockaddr *addr, socklen_t alen,
> >>                 error(1, 0, "send_fragment: %d vs %d", res, frag_len);
> >>  
> >>         frag_counter++;
> >> +       usleep(1000);
> >>  }
> >>  
> >>  static void send_udp_frags(int fd_raw, struct sockaddr *addr,
> >>
> > 
> > That won't work because the issue only shows when we using conntrack, as the
> > packet will be reassembled on output, then fragmented again. When this happens,
> > the fragmentation code is transmitting the fragments in a tight loop, which
> > floods the backlog.
> 
> Interesting !
> 
> So it looks like the test is correct, and exposed a long standing problem in this code.
> 
> We should not adjust the test to some kernel-of-the-day-constraints, and instead fix the kernel bug ;)
> 
> Where is this tight loop exactly ?
> 
> If this is feeding/bursting ~1000 skbs via netif_rx() in a BH context, maybe we need to call a variant
> that allows immediate processing instead of (ab)using the softnet backlog.
> 
> Thanks !

This is the loopback interface, so its xmit calls netif_rx. I suppose we would
have the same problem with veth, for example.

So net/ipv6/ip6_output.c:ip6_fragment has this:

		for (;;) {
			/* Prepare header of the next frame,
			 * before previous one went down. */
			if (iter.frag)
				ip6_fraglist_prepare(skb, &iter);

			skb->tstamp = tstamp;
			err = output(net, sk, skb);
			if (!err)
				IP6_INC_STATS(net, ip6_dst_idev(&rt->dst),
					      IPSTATS_MIB_FRAGCREATES);

			if (err || !iter.frag)
				break;

			skb = ip6_fraglist_next(&iter);
		}

output is ip6_finish_output2, which will call neigh_output, which ends up
calling dev_queue_xmit.

In this case, ip6_fragment is being called probably from rawv6_send_hdrinc ->
dst_output -> ip6_output -> ip6_finish_output -> __ip6_finish_output ->
ip6_fragment.

dst_output at rawv6_send_hdrinc is being called after netfilter
NF_INET_LOCAL_OUT hook. That one is gathering the fragments and only accepting
that last, reassembled skb, which causes ip6_fragment enter that loop.

So, basically, the easiest way to reproduce this is using this test with
loopback and netfilter doing the reassembly during conntrack. I see some BH
locks here and there, but I think this is just filling up the backlog too fast
to give any chance for softirq to kick in.

I will see if I can reproduce this using routed veths.

Cascardo.

Cascardo.
