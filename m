Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCA06798EE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 14:09:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbjAXNJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 08:09:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233396AbjAXNJB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 08:09:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A96EC164;
        Tue, 24 Jan 2023 05:08:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D60B811C2;
        Tue, 24 Jan 2023 13:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6A7C433D2;
        Tue, 24 Jan 2023 13:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674565736;
        bh=XDIMLRsxYDgPUsMcHtS5t0Tewfj6lJYjdZOmmtGJMEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ApoDOHLo8xo1EYtV0F9T5c6ryM+Akjmz4/m8Ssha4HefSMo5nDQkPvJPNpUU6q0xp
         d5iBCMHXWFu3K6cRO5iDSejGnW9aWk1NgTPqBD3mM0gev5s0rK1wgp78dpg38fCdgS
         Q9DfQtcYRfHNl8cCoKCZR/Nw4CcKyr+QkKlINMmppZ5mjkrd+J2FtKXi0kUC0MrE8Y
         91/6teGMJi6HXOQJvi5HosiJ1p9tGuqCTsLM23jwVhwNMIhw3q/LKK6Axt6Cokb0BD
         kfzjDV8Pr6Bu15E/xnHTuAIAmN8CtTXHdPSDFAuuTABtPGtICSqjT2CcjmGE3ZN+Fc
         gqII/hx5t4WRA==
Date:   Tue, 24 Jan 2023 15:04:32 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Neal Cardwell <ncardwell@google.com>, selinux@vger.kernel.org,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, kernel-team@cloudflare.com,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH net-next v5 1/2] inet: Add IP_LOCAL_PORT_RANGE socket
 option
Message-ID: <Y8/XYBtzMzKyIZjo@unreal>
References: <20221221-sockopt-port-range-v5-0-9fb2c00ad293@cloudflare.com>
 <20221221-sockopt-port-range-v5-1-9fb2c00ad293@cloudflare.com>
 <Y8/NrXosvah67bUg@unreal>
 <87fsc0w1hp.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fsc0w1hp.fsf@cloudflare.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 01:33:07PM +0100, Jakub Sitnicki wrote:
> On Tue, Jan 24, 2023 at 02:23 PM +02, Leon Romanovsky wrote:
> > On Tue, Jan 24, 2023 at 11:05:26AM +0100, Jakub Sitnicki wrote:
> >> Users who want to share a single public IP address for outgoing connections
> >> between several hosts traditionally reach for SNAT. However, SNAT requires
> >> state keeping on the node(s) performing the NAT.
> >> 
> >> A stateless alternative exists, where a single IP address used for egress
> >> can be shared between several hosts by partitioning the available ephemeral
> >> port range. In such a setup:
> >> 
> >> 1. Each host gets assigned a disjoint range of ephemeral ports.
> >> 2. Applications open connections from the host-assigned port range.
> >> 3. Return traffic gets routed to the host based on both, the destination IP
> >>    and the destination port.
> >> 
> >> An application which wants to open an outgoing connection (connect) from a
> >> given port range today can choose between two solutions:
> >> 
> >> 1. Manually pick the source port by bind()'ing to it before connect()'ing
> >>    the socket.
> >> 
> >>    This approach has a couple of downsides:
> >> 
> >>    a) Search for a free port has to be implemented in the user-space. If
> >>       the chosen 4-tuple happens to be busy, the application needs to retry
> >>       from a different local port number.
> >> 
> >>       Detecting if 4-tuple is busy can be either easy (TCP) or hard
> >>       (UDP). In TCP case, the application simply has to check if connect()
> >>       returned an error (EADDRNOTAVAIL). That is assuming that the local
> >>       port sharing was enabled (REUSEADDR) by all the sockets.
> >> 
> >>         # Assume desired local port range is 60_000-60_511
> >>         s = socket(AF_INET, SOCK_STREAM)
> >>         s.setsockopt(SOL_SOCKET, SO_REUSEADDR, 1)
> >>         s.bind(("192.0.2.1", 60_000))
> >>         s.connect(("1.1.1.1", 53))
> >>         # Fails only if 192.0.2.1:60000 -> 1.1.1.1:53 is busy
> >>         # Application must retry with another local port
> >> 
> >>       In case of UDP, the network stack allows binding more than one socket
> >>       to the same 4-tuple, when local port sharing is enabled
> >>       (REUSEADDR). Hence detecting the conflict is much harder and involves
> >>       querying sock_diag and toggling the REUSEADDR flag [1].
> >> 
> >>    b) For TCP, bind()-ing to a port within the ephemeral port range means
> >>       that no connecting sockets, that is those which leave it to the
> >>       network stack to find a free local port at connect() time, can use
> >>       the this port.
> >> 
> >>       IOW, the bind hash bucket tb->fastreuse will be 0 or 1, and the port
> >>       will be skipped during the free port search at connect() time.
> >> 
> >> 2. Isolate the app in a dedicated netns and use the use the per-netns
> >>    ip_local_port_range sysctl to adjust the ephemeral port range bounds.
> >> 
> >>    The per-netns setting affects all sockets, so this approach can be used
> >>    only if:
> >> 
> >>    - there is just one egress IP address, or
> >>    - the desired egress port range is the same for all egress IP addresses
> >>      used by the application.
> >> 
> >>    For TCP, this approach avoids the downsides of (1). Free port search and
> >>    4-tuple conflict detection is done by the network stack:
> >> 
> >>      system("sysctl -w net.ipv4.ip_local_port_range='60000 60511'")
> >> 
> >>      s = socket(AF_INET, SOCK_STREAM)
> >>      s.setsockopt(SOL_IP, IP_BIND_ADDRESS_NO_PORT, 1)
> >>      s.bind(("192.0.2.1", 0))
> >>      s.connect(("1.1.1.1", 53))
> >>      # Fails if all 4-tuples 192.0.2.1:60000-60511 -> 1.1.1.1:53 are busy
> >> 
> >>   For UDP this approach has limited applicability. Setting the
> >>   IP_BIND_ADDRESS_NO_PORT socket option does not result in local source
> >>   port being shared with other connected UDP sockets.
> >> 
> >>   Hence relying on the network stack to find a free source port, limits the
> >>   number of outgoing UDP flows from a single IP address down to the number
> >>   of available ephemeral ports.
> >> 
> >> To put it another way, partitioning the ephemeral port range between hosts
> >> using the existing Linux networking API is cumbersome.
> >> 
> >> To address this use case, add a new socket option at the SOL_IP level,
> >> named IP_LOCAL_PORT_RANGE. The new option can be used to clamp down the
> >> ephemeral port range for each socket individually.
> >> 
> >> The option can be used only to narrow down the per-netns local port
> >> range. If the per-socket range lies outside of the per-netns range, the
> >> latter takes precedence.
> >> 
> >> UAPI-wise, the low and high range bounds are passed to the kernel as a pair
> >> of u16 values in host byte order packed into a u32. This avoids pointer
> >> passing.
> >> 
> >>   PORT_LO = 40_000
> >>   PORT_HI = 40_511
> >> 
> >>   s = socket(AF_INET, SOCK_STREAM)
> >>   v = struct.pack("I", PORT_HI << 16 | PORT_LO)
> >>   s.setsockopt(SOL_IP, IP_LOCAL_PORT_RANGE, v)
> >>   s.bind(("127.0.0.1", 0))
> >>   s.getsockname()
> >>   # Local address between ("127.0.0.1", 40_000) and ("127.0.0.1", 40_511),
> >>   # if there is a free port. EADDRINUSE otherwise.
> >> 
> >> [1] https://github.com/cloudflare/cloudflare-blog/blob/232b432c1d57/2022-02-connectx/connectx.py#L116
> >> 
> >> v4 -> v5:
> >>  * Use the fact that netns port range starts at 1 when clamping. (Kuniyuki)
> >> 
> >> v3 -> v4:
> >>  * Clarify that u16 values are in host byte order (Neal)
> >> 
> >> v2 -> v3:
> >>  * Make SCTP bind()/bind_add() respect IP_LOCAL_PORT_RANGE option (Eric)
> >> 
> >> v1 -> v2:
> >>  * Fix the corner case when the per-socket range doesn't overlap with the
> >>    per-netns range. Fallback correctly to the per-netns range. (Kuniyuki)
> >
> > You silently ignored my review comment.
> > Let's repeat it again. Please put changelog after --- marker. Changelog
> > doesn't belong to commit message.
> 
> I did not. I'm under the impression that you might have missed my follow
> up question if the changelog-above-trailer convention is still in place
> [1] and the clarification from Jakub K. [2].

Yes, I missed it.

There is no value in seeing changelog in git log history as there is
only one version of patches is applied at the end.

Users don't care how many revisions you (or any developer) sent till the
patches were accepted.

> 
> I'm happy to adjust the changelog in whichever way that will make
> everyone content. However, ATM we don't have one, it seems.

We have, just some of us don't care. It doesn't mean they prefer to see
changelog before ---.

> 
> [1] https://lore.kernel.org/all/87sfg1vuqj.fsf@cloudflare.com/
> [2] https://lore.kernel.org/all/20230123193526.065a9879@kernel.org/ 
