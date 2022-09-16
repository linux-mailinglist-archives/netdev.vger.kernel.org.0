Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603415BB149
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 18:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiIPQu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 12:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiIPQuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 12:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117DC86FC9;
        Fri, 16 Sep 2022 09:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FBB5B82882;
        Fri, 16 Sep 2022 16:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9866AC433D6;
        Fri, 16 Sep 2022 16:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663347020;
        bh=yycVGinXhAQj/B6lw2iCL7uGdFzgjWT//2xXGijCZ0w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WMEY0KYnlhcneHCw8J5mBpEFNjYQuby70tDzqktv9pDXjqg1RjKnLaoW9GJzMly0o
         +R8W7yH4uHSmkbCaDUCp4bPI7dhTdUcw5dzuGoMPgQ1z4U0Zc68lTs88RRPhS8MZc5
         JkuLATi8nyQgbxGQ1kcd2q0Iafe2pvoH0mkZ5+LqOswXVKgVCZVwMowtbKRtYZlL+l
         pkdmwaQYLVOHT3v/so+Kc6QNCAT+IetKprWUSd0iMojVVlOkWk8+P0b2B8LypYfOOM
         A6X8y60G0tIK6KPl76sA1PxfGvudT+SUspgzHL5mWG56Kf/y/x+7/AgEVkXwkJKFaw
         9fGgmDcCrZ8VA==
Message-ID: <ec81e01d-7e91-386c-b6a2-0f32ccd09750@kernel.org>
Date:   Fri, 16 Sep 2022 10:50:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [net-next v2 3/3] selftests: seg6: add selftest for NEXT-C-SID
 flavor in SRv6 End behavior
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20220912171619.16943-1-andrea.mayer@uniroma2.it>
 <20220912171619.16943-4-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220912171619.16943-4-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/12/22 11:16 AM, Andrea Mayer wrote:
> This selftest is designed for testing the support of NEXT-C-SID flavor
> for SRv6 End behavior. It instantiates a virtual network composed of
> several nodes: hosts and SRv6 routers. Each node is realized using a
> network namespace that is properly interconnected to others through veth
> pairs.
> The test considers SRv6 routers implementing IPv4/IPv6 L3 VPNs leveraged
> by hosts for communicating with each other. Such routers i) apply
> different SRv6 Policies to the traffic received from connected hosts,
> considering the IPv4 or IPv6 protocols; ii) use the NEXT-C-SID
> compression mechanism for encoding several SRv6 segments within a single
> 128-bit SID address, referred to as a Compressed SID (C-SID) container.
> 
> The NEXT-C-SID is provided as a "flavor" of the SRv6 End behavior,
> enabling it to properly process the C-SID containers. The correct
> execution of the enabled NEXT-C-SID SRv6 End behavior is verified
> through reachability tests carried out between hosts belonging to the
> same VPN.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  tools/testing/selftests/net/Makefile          |    1 +
>  .../net/srv6_end_next_csid_l3vpn_test.sh      | 1145 +++++++++++++++++
>  2 files changed, 1146 insertions(+)
>  create mode 100755 tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh
> 
> diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
> index f5ac1433c301..d87e8739bb30 100644
> --- a/tools/testing/selftests/net/Makefile
> +++ b/tools/testing/selftests/net/Makefile
> @@ -37,6 +37,7 @@ TEST_PROGS += srv6_end_dt4_l3vpn_test.sh
>  TEST_PROGS += srv6_end_dt6_l3vpn_test.sh
>  TEST_PROGS += srv6_hencap_red_l3vpn_test.sh
>  TEST_PROGS += srv6_hl2encap_red_l2vpn_test.sh
> +TEST_PROGS += srv6_end_next_csid_l3vpn_test.sh
>  TEST_PROGS += vrf_strict_mode_test.sh
>  TEST_PROGS += arp_ndisc_evict_nocarrier.sh
>  TEST_PROGS += ndisc_unsolicited_na_test.sh
> diff --git a/tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh b/tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh
> new file mode 100755
> index 000000000000..87e414cc417c
> --- /dev/null
> +++ b/tools/testing/selftests/net/srv6_end_next_csid_l3vpn_test.sh
> @@ -0,0 +1,1145 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# author: Andrea Mayer <andrea.mayer@uniroma2.it>
> +#
> +# This script is designed for testing the support of NEXT-C-SID flavor for SRv6
> +# End behavior.
> +# A basic knowledge of SRv6 architecture [1] and of the compressed SID approach
> +# [2] is assumed for the reader.
> +#
> +# The network topology used in the selftest is depicted hereafter, composed by
> +# two hosts and four routers. Hosts hs-1 and hs-2 are connected through an
> +# IPv4/IPv6 L3 VPN service, offered by routers rt-1, rt-2, rt-3 and rt-4 using
> +# the NEXT-C-SID flavor. The key components for such VPNs are:
> +#
> +#    i) The SRv6 H.Encaps/H.Encaps.Red behaviors [1] apply SRv6 Policies on
> +#       traffic received by connected hosts, initiating the VPN tunnel;
> +#
> +#   ii) The SRv6 End behavior [1] advances the active SID in the SID List
> +#       carried by the SRH;
> +#
> +#  iii) The NEXT-C-SID mechanism [2] offers the possibility of encoding several
> +#       SRv6 segments within a single 128-bit SID address, referred to as a
> +#       Compressed SID (C-SID) container. In this way, the length of the SID
> +#       List can be drastically reduced.
> +#       The NEXT-C-SID is provided as a "flavor" of the SRv6 End behavior
> +#       which advances the current C-SID (i.e. the Locator-Node Function defined
> +#       in [2]) with the next one carried in the Argument, if available.
> +#       When no more C-SIDs are available in the Argument, the SRv6 End behavior
> +#       will apply the End function selecting the next SID in the SID List.
> +#
> +#   iv) The SRv6 End.DT46 behavior [1] is used for removing the SRv6 Policy and,
> +#       thus, it terminates the VPN tunnel. Such a behavior is capable of
> +#       handling, at the same time, both tunneled IPv4 and IPv6 traffic.
> +#
> +# [1] https://datatracker.ietf.org/doc/html/rfc8986
> +# [2] https://datatracker.ietf.org/doc/html/draft-ietf-spring-srv6-srh-compression
> +#
> +#
> +#               cafe::1                      cafe::2
> +#              10.0.0.1                     10.0.0.2
> +#             +--------+                   +--------+
> +#             |        |                   |        |
> +#             |  hs-1  |                   |  hs-2  |
> +#             |        |                   |        |
> +#             +---+----+                   +----+---+
> +#    cafe::/64    |                             |      cafe::/64
> +#  10.0.0.0/24    |                             |    10.0.0.0/24
> +#             +---+----+                   +----+---+
> +#             |        |  fcf0:0:1:2::/64  |        |
> +#             |  rt-1  +-------------------+  rt-2  |
> +#             |        |                   |        |
> +#             +---+----+                   +----+---+
> +#                 |      .               .      |
> +#                 |  fcf0:0:1:3::/64   .        |
> +#                 |          .       .          |
> +#                 |            .   .            |
> +# fcf0:0:1:4::/64 |              .              | fcf0:0:2:3::/64
> +#                 |            .   .            |
> +#                 |          .       .          |
> +#                 |  fcf0:0:2:4::/64   .        |
> +#                 |      .               .      |
> +#             +---+----+                   +----+---+
> +#             |        |                   |        |
> +#             |  rt-4  +-------------------+  rt-3  |
> +#             |        |  fcf0:0:3:4::/64  |        |
> +#             +---+----+                   +----+---+
> +#
> +# Every fcf0:0:x:y::/64 network interconnects the SRv6 routers rt-x with rt-y in
> +# the selftest network.
> +#
> +# Local SID/C-SID table
> +# =====================
> +#
> +# Each SRv6 router is configured with a Local SID/C-SID table in which
> +# SIDs/C-SIDs are stored. Considering an SRv6 router rt-x, SIDs/C-SIDs are
> +# configured in the Local SID/C-SIDs table as follows:
> +#
> +#   Local SID/C-SID table for SRv6 router rt-x
> +#   +-----------------------------------------------------------+
> +#   |fcff:x::d46 is associated with the non-compressed SRv6     |
> +#   |   End.DT46 behavior                                       |
> +#   +-----------------------------------------------------------+
> +#   |fcbb:0:0x00::/48 is associated with the NEXT-C-SID flavor  |
> +#   |   of SRv6 End behavior                                    |
> +#   +-----------------------------------------------------------+
> +#   |fcbb:0:0x00:d46::/64 is associated with the SRv6 End.DT46  |
> +#   |   behavior when NEXT-C-SID compression is turned on       |
> +#   +-----------------------------------------------------------+
> +#
> +# The fcff::/16 prefix is reserved for implementing SRv6 services with regular
> +# (non compressed) SIDs. Reachability of SIDs is ensured by proper configuration
> +# of the IPv6 routing tables in the routers.
> +# Similarly, the fcbb:0::/32 prefix is reserved for implementing SRv6 VPN
> +# services leveraging the NEXT-C-SID compression mechanism. Indeed, the
> +# fcbb:0::/32 is used for encoding the Locator-Block while the Locator-Node
> +# Function is encoded with 16 bits.
> +#
> +# Incoming traffic classification and application of SRv6 Policies
> +# ================================================================
> +#
> +# An SRv6 ingress router applies different SRv6 Policies to the traffic received
> +# from a connected host, considering the IPv4 or IPv6 destination address.
> +# SRv6 policy enforcement consists of encapsulating the received traffic into a
> +# new IPv6 packet with a given SID List contained in the SRH.
> +# When the SID List contains only one SID, the SRH could be omitted completely
> +# and that SID is stored directly in the IPv6 Destination Address (DA) (this is
> +# called "reduced" encapsulation).
> +#
> +# Test cases for NEXT-C-SID
> +# =========================
> +#
> +# We consider two test cases for NEXT-C-SID: i) single SID and ii) double SID.
> +#
> +# In the single SID test case we have a number of segments that are all
> +# contained in a single Compressed SID (C-SID) container. Therefore the
> +# resulting SID List has only one SID. Using the reduced encapsulation format
> +# this will result in a packet with no SRH.
> +#
> +# In the double SID test case we have one segment carried in a Compressed SID
> +# (C-SID) container, followed by a regular (non compressed) SID. The resulting
> +# SID List has two segments and it is possible to test the advance to the next
> +# SID when all the C-SIDs in a C-SID container have been processed. Using the
> +# reduced encapsulation format this will result in a packet with an SRH
> +# containing 1 segment.
> +#
> +# For the single SID test case, we use the IPv4 addresses of hs-1 and hs-2, for
> +# the double SID test case, we use their IPv6 addresses. This is only done to
> +# simplify the test setup and avoid adding other hosts or multiple addresses on
> +# the same interface of a host.
> +#
> +# Traffic from hs-1 to hs-2
> +# -------------------------
> +#
> +# Packets generated from hs-1 and directed towards hs-2 are handled by rt-1
> +# which applies the SRv6 Policies as follows:
> +#
> +#   i) IPv6 DA=cafe::2, H.Encaps.Red with SID List=fcbb:0:0400:0300:0200:d46::
> +#  ii) IPv4 DA=10.0.0.2, H.Encaps.Red with SID List=fcbb:0:0300::,fcff:2::d46
> +#
> +# ### i) single SID
> +#
> +# The router rt-1 is configured to enforce the given Policy through the SRv6
> +# H.Encaps.Red behavior which avoids the presence of the SRH at all, since it
> +# pushes the single SID directly in the IPv6 DA. Such a SID encodes a whole
> +# C-SID container carrying several C-SIDs (e.g. 0400, 0300, etc).
> +#
> +# As the packet reaches the router rt-4, the enabled NEXT-C-SID SRv6 End
> +# behavior (associated with fcbb:0:0400::/48) is triggered. This behavior
> +# analyzes the IPv6 DA and checks whether the Argument of the C-SID container
> +# is zero or not. In this case, the Argument is *NOT* zero and the IPv6 DA is
> +# updated as follows:
> +#
> +# +---------------------------------------------------------------+
> +# | Before applying the rt-4 enabled NEXT-C-SID SRv6 End behavior |
> +# +---------------------------------------------------------------+
> +# |                            +---------- Argument               |
> +# |                     vvvvvvvvvvvvvvvv                          |
> +# | IPv6 DA fcbb:0:0400:0300:0200:d46::                           |
> +# |                ^^^^    <-- shifting                           |
> +# |                  |                                            |
> +# |          Locator-Node Function                                |
> +# +---------------------------------------------------------------+
> +# | After applying the rt-4 enabled NEXT-C-SID SRv6 End behavior  |
> +# +---------------------------------------------------------------+
> +# |                          +---------- Argument                 |
> +# |                    vvvvvvvvvvvv                               |
> +# | IPv6 DA fcbb:0:0300:0200:d46::                                |
> +# |                ^^^^                                           |
> +# |                  |                                            |
> +# |          Locator-Node Function                                |
> +# +---------------------------------------------------------------+
> +#
> +# After having applied the enabled NEXT-C-SID SRv6 End behavior, the packet is
> +# sent to the next node, i.e. rt-3.
> +#
> +# The enabled NEXT-C-SID SRv6 End behavior on rt-3 is executed as the packet is
> +# received. This behavior processes the packet and updates the IPv6 DA with
> +# fcbb:0:0200:d46::, since the Argument is *NOT* zero. Then, the packet is sent
> +# to the router rt-2.
> +#
> +# The router rt-2 is configured for decapsulating the inner IPv6 packet and,
> +# for this reason, it applies the SRv6 End.DT46 behavior on the received
> +# packet. It is worth noting that the SRv6 End.DT46 behavior does not require
> +# the presence of the SRH: it is fully capable to operate properly on
> +# IPv4/IPv6-in-IPv6 encapsulations.
> +# At the end of the decap operation, the packet is sent to the
> +# host hs-2.
> +#
> +# ### ii) double SID
> +#
> +# The router rt-1 is configured to enforce the given Policy through the SRv6
> +# H.Encaps.Red. As a result, the first SID fcbb:0:0300:: is stored into the
> +# IPv6 DA, while the SRH pushed into the packet is made of only one SID, i.e.
> +# fcff:2::d46. Hence, the packet sent by hs-1 to hs-2 is encapsulated in an
> +# outer IPv6 header plus the SRH.
> +#
> +# As the packet reaches the node rt-3, the router applies the enabled NEXT-C-SID
> +# SRv6 End behavior.
> +#
> +# +---------------------------------------------------------------+
> +# | Before applying the rt-3 enabled NEXT-C-SID SRv6 End behavior |
> +# +---------------------------------------------------------------+
> +# |                            +---------- Argument               |
> +# |                      vvvv (Argument is all filled with zeros) |
> +# | IPv6 DA fcbb:0:0300::                                         |
> +# |                ^^^^                                           |
> +# |                  |                                            |
> +# |          Locator-Node Function                                |
> +# +---------------------------------------------------------------+
> +# | After applying the rt-3 enabled NEXT-C-SID SRv6 End behavior  |
> +# +---------------------------------------------------------------+
> +# |                                                               |
> +# | IPv6 DA fcff:2::d46                                           |
> +# |         ^^^^^^^^^^^                                           |
> +# |              |                                                |
> +# |        SID copied from the SID List contained in the SRH      |
> +# +---------------------------------------------------------------+
> +#
> +# Since the Argument of the C-SID container is zero, the behavior can not
> +# update the Locator-Node function with the next C-SID carried in the Argument
> +# itself. Thus, the enabled NEXT-C-SID SRv6 End behavior operates as the
> +# traditional End behavior: it updates the IPv6 DA by copying the next
> +# available SID in the SID List carried by the SRH. After that, the packet is
> +# sent to the node rt-2.
> +#
> +# Once the packet is received by rt-2, the router decapsulates the inner IPv6
> +# packet using the SRv6 End.DT46 behavior (associated with the SID fcff:2::d46)
> +# and sends it to the host hs-2.
> +#
> +# Traffic from hs-2 to hs-1
> +# -------------------------
> +#
> +# Packets generated from hs-2 and directed towards hs-1 are handled by rt-2
> +# which applies the SRv6 Policies as follows:
> +#
> +#   i) IPv6 DA=cafe::1, SID List=fcbb:0:0300:0400:0100:d46::
> +#  ii) IPv4 DA=10.0.0.1, SID List=fcbb:0:0300::,fcff:1::d46
> +#
> +# For simplicity, such SRv6 Policies were chosen so that, in both use cases (i)
> +# and (ii), the network paths crossed by traffic from hs-2 to hs-1 are the same
> +# as those taken by traffic from hs-1 to hs-2.
> +# In this way, traffic from hs-2 to hs-1 is processed similarly to traffic from
> +# hs-1 to hs-2. So, the traffic processing scheme turns out to be the same as
> +# that adopted in the use cases already examined (of course, it is necessary to
> +# consider the different SIDs/C-SIDs).
> +

Thanks for the verbose description of the tests.

Acked-by: David Ahern <dsahern@kernel.org>


