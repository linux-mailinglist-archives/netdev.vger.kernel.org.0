Return-Path: <netdev+bounces-7260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF8A71F5E6
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 00:23:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67E4C281920
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 22:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C7C48222;
	Thu,  1 Jun 2023 22:23:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FDA2414E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 22:23:54 +0000 (UTC)
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DBE193
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:23:51 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
	id 654DB586D1ACF; Fri,  2 Jun 2023 00:23:50 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 62DCE60C2AFF1;
	Fri,  2 Jun 2023 00:23:50 +0200 (CEST)
Date: Fri, 2 Jun 2023 00:23:50 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Sam Edwards <cfsworks@gmail.com>
cc: Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
    "David S. Miller" <davem@davemloft.net>
Subject: Re: Regression in IPv6 autoconf, maybe "ipv6/addrconf: fix timing
 bug in tempaddr regen"
In-Reply-To: <s5n6r540-o061-3n7o-28qo-16r6s4354ns0@vanv.qr>
Message-ID: <nr14o635-577n-n3s4-np6n-rp8367ss9n24@vanv.qr>
References: <4n64q633-94rr-401n-s779-pqp2q0599438@vanv.qr> <7ea57097-b458-c30b-bb53-517b901d3751@gmail.com> <s5n6r540-o061-3n7o-28qo-16r6s4354ns0@vanv.qr>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Thursday 2023-06-01 13:51, Jan Engelhardt wrote:
>>> 
>>> I am observing that between kernel 5.19 and 6.0, a change was introduced
>>> that makes the system just stop generating IPv6 Privacy Addresses after
>>> some time.
>>
>> I'd been encountering this exact problem very reliably since at
>> least the early 4.x days [...] but that my patch is evidently
>> making the problem happen *more* frequently in your case!

The Arris/Vodafone TG3442DE router, for unknown and undiagnosable
reasons (blackbox), issues RAs where the prefix is de-advertised
with a lifetime of 0 for a window of about 10-15 seconds. (tcpdump
below)

After the prefix is re-advertised with 86400s lifetime, Linux
clients do not resume address generation. The investigation continues.


2023-06-01 23:15:20.630778 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 128) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 128
	hop limit 64, Flags [managed, other stateful], pref medium, router lifetime 1800s, reachable time 3600000ms, retrans timer 0ms
	  rdnss option (25), length 24 (3):  lifetime 300s, addr: 2a02:8108:96bf:f1c4:f2af:85ff:fe9a:33ec
	    0x0000:  0000 0000 012c 2a02 8108 96bf f1c4 f2af
	    0x0010:  85ff fe9a 33ec
	  prefix info option (3), length 32 (4): 2a02:8108:96bf:f1c4::/64, Flags [onlink, auto], valid time 86400s, pref. time 43200s
	    0x0000:  40c0 0001 5180 0000 a8c0 0000 0000 2a02
	    0x0010:  8108 96bf f1c4 0000 0000 0000 0000
	  route info option (24), length 24 (3):  2a02:8108:96bf:f1c4::/62, pref=medium, lifetime=86400s
	    0x0000:  3e00 0001 5180 2a02 8108 96bf f1c4 0000
	    0x0010:  0000 0000 0000
	  route info option (24), length 24 (3):  ::/0, pref=medium, lifetime=1800s
	    0x0000:  0000 0000 0708 0000 0000 0000 0000 0000
	    0x0010:  0000 0000 0000
	  source link-address option (1), length 8 (1): f0:af:85:9a:33:ec
	    0x0000:  f0af 859a 33ec
2023-06-01 23:15:22.001430 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 104) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 104
	hop limit 64, Flags [managed, other stateful], pref medium, router lifetime 1800s, reachable time 3600000ms, retrans timer 0ms
	  rdnss option (25), length 24 (3):  lifetime 300s, addr: 2a02:8108:96bf:f1c4:f2af:85ff:fe9a:33ec
	    0x0000:  0000 0000 012c 2a02 8108 96bf f1c4 f2af
	    0x0010:  85ff fe9a 33ec
	  prefix info option (3), length 32 (4): 2a02:8108:96bf:f1c4::/64, Flags [onlink, auto], valid time 0s, pref. time 0s
	    0x0000:  40c0 0000 0000 0000 0000 0000 0000 2a02
	    0x0010:  8108 96bf f1c4 0000 0000 0000 0000
	  route info option (24), length 24 (3):  ::/0, pref=medium, lifetime=1800s
	    0x0000:  0000 0000 0708 0000 0000 0000 0000 0000
	    0x0010:  0000 0000 0000
	  source link-address option (1), length 8 (1): f0:af:85:9a:33:ec
	    0x0000:  f0af 859a 33ec
2023-06-01 23:15:25.003317 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 104) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 104
 [same]
2023-06-01 23:15:28.006222 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 104) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 104
 [same]
2023-06-01 23:15:31.010397 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 104) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 104
 [same]
2023-06-01 23:15:32.576848 IP6 (flowlabel 0x0452b, hlim 255, next-header ICMPv6 (58) payload length: 128) fe80::f2af:85ff:fe9a:33ec > ff02::1: [icmp6 sum ok] ICMP6, router advertisement, length 128
	hop limit 64, Flags [managed, other stateful], pref medium, router lifetime 1800s, reachable time 3600000ms, retrans timer 0ms
	  rdnss option (25), length 24 (3):  lifetime 300s, addr: 2a02:8108:96bf:f1c4:f2af:85ff:fe9a:33ec
	    0x0000:  0000 0000 012c 2a02 8108 96bf f1c4 f2af
	    0x0010:  85ff fe9a 33ec
	  prefix info option (3), length 32 (4): 2a02:8108:96bf:f1c4::/64, Flags [onlink, auto], valid time 86400s, pref. time 43200s
	    0x0000:  40c0 0001 5180 0000 a8c0 0000 0000 2a02
	    0x0010:  8108 96bf f1c4 0000 0000 0000 0000
	  route info option (24), length 24 (3):  2a02:8108:96bf:f1c4::/62, pref=medium, lifetime=86400s
	    0x0000:  3e00 0001 5180 2a02 8108 96bf f1c4 0000
	    0x0010:  0000 0000 0000
	  route info option (24), length 24 (3):  ::/0, pref=medium, lifetime=1800s
	    0x0000:  0000 0000 0708 0000 0000 0000 0000 0000
	    0x0010:  0000 0000 0000
	  source link-address option (1), length 8 (1): f0:af:85:9a:33:ec
	    0x0000:  f0af 859a 33ec

