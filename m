Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5176160CCE1
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 15:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbiJYNDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 09:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232600AbiJYNCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 09:02:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 757FBA8356;
        Tue, 25 Oct 2022 06:00:45 -0700 (PDT)
Date:   Tue, 25 Oct 2022 15:00:40 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Michael Lilja <michael.lilja@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] Periodically flow expire from flow offload tables
Message-ID: <Y1fd+DEPZ8xM2x5B@salvia>
References: <20221023171658.69761-1-michael.lilja@gmail.com>
 <Y1fC5K0EalIYuB7Y@salvia>
 <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1rcC1yEX000eNPzk"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <381FF5B6-4FEF-45E9-92D6-6FE927A5CC2D@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--1rcC1yEX000eNPzk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On Tue, Oct 25, 2022 at 02:36:35PM +0200, Michael Lilja wrote:
> Hi,
> 
> No problem. Here is a snippet of the rulesets in play. I simplified it because there are a lot of devices and a lot of schedules per device. The ‘mark’ is set by userspace so not all flow types are offloaded, that is controlled by userspace:
> 
> - - - - snip start - - - - 
> table inet fw4 {
> 	flowtable ft {
> 	hook ingress priority filter
> 	devices = { lan1, lan2, wan }
> 	flags offload
> }
> 
>  chain mangle_forward {
> 	type filter hook forward priority mangle; policy
> 	meta mark set ct mark
> 	meta mark 0x00000000/16 queue flags bypass to 0
>  }
> 
> 
> chain my_devices_rules {
> 	ether saddr 96:68:97:a7:e8:a7 jump fw_p0_dev0 comment “Device match”
> }
> 
> chain fw_p0_dev0 {
> 	meta time >= "2022-10-09 18:46:50" meta time < "2022-10-09 19:16:50" counter packets 0 bytes 0 drop comment "!Schedule OFFLINE override"
> 	meta day “Tuesday" meta hour >= "06:00" meta hour < "07:00" drop
> }
> 
> chain forward {
> 	 type filter hook forward priority filter; policy accept;
> 	jump my_devices_rules
> }
> 
> chain my_forward_offload {
> 	type filter hook forward priority filter + 1; policy accept;
> 	meta mark != 0x00000000/16 meta l4proto { tcp, udp } flow add @ft
> }
> 
> chain mangle_postrouting {
> 	type filter hook postrouting priority mangle; policy accept;
> 	ct mark set meta mark
> }
> - - - - snip end - - - -
> 
> The use case is that I have schedules per device to control when
> they are allowed access to the internet and if the flows are
> offloaded they will not get dropped once the schedule kicks in.

Thanks for explaining.

I suggest to move your 'forward' chain to netdev/ingress using priority

      filter - 1

so the time schedule evaluation is always done before the flowtable
lookup, that is, schedules rules will be always evaluated.

In your example, you are using a linear ruleset, which might defeat
the purpose of the flowtable. So I'm attaching a new ruleset
transformed to use maps and the ingress chain as suggested.

--1rcC1yEX000eNPzk
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="schedules.nft"

table netdev filter {
	map ether_to_chain {
		typeof ether saddr : verdict
		elements = { 96:68:97:a7:e8:a7 comment "Device match" : jump fw_p0_dev0 }
	}

	map schedule_time {
		typeof meta time : verdict
		flags interval
		counter
		elements = { "2022-10-09 18:46:50" - "2022-10-09 19:16:50" comment "!Schedule OFFLINE override" : drop }
	}

	map schedule_day {
		typeof meta day . meta hour : verdict
		flags interval
		counter
		elements = { "Tuesday" . "06:00" - "07:00" : drop }
	}

	chain fw_p0_dev0 {
		meta time vmap @schedule_time
		meta day . meta hour vmap @schedule_day
	}

	chain my_devices_rules {
		ether saddr vmap @ether_to_chain
	}

	chain ingress {
		type filter hook ingress device eth0 priority filter; policy accept;
		jump my_devices_rules
	}
}

--1rcC1yEX000eNPzk--
