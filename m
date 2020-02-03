Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E69150103
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 05:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgBCEx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 23:53:57 -0500
Received: from dpmailmta01-22.doteasy.com ([65.61.219.2]:37068 "EHLO
        dpmailmta01.doteasy.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727165AbgBCEx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Feb 2020 23:53:57 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=192.168.101.83;
Received: from dpmailrp03.doteasy.com (unverified [192.168.101.83]) 
        by dpmailmta01.doteasy.com (DEO) with ESMTP id 54391293-1394429 
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 20:53:56 -0800
Received: from dpmail22.doteasy.com (dpmail22.doteasy.com [192.168.101.22])
        by dpmailrp03.doteasy.com (8.14.4/8.14.4/Debian-8+deb8u2) with ESMTP id 0134ruvA032592
        for <netdev@vger.kernel.org>; Sun, 2 Feb 2020 20:53:56 -0800
X-SmarterMail-Authenticated-As: trev@larock.ca
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54]) by dpmail22.doteasy.com with SMTP;
   Sun, 2 Feb 2020 20:53:43 -0800
Received: by mail-ed1-f54.google.com with SMTP id g19so14599522eds.11
        for <netdev@vger.kernel.org>; Sun, 02 Feb 2020 20:53:30 -0800 (PST)
X-Gm-Message-State: APjAAAU3TQHQIX35zkFn1j9vv0BvxtHVXYDaZ/W7vbwP4xWxz0uBE8Jh
        5dywGdLcjcH0hjwLhum1bfAnH6lZiK7aQiu4tWE=
X-Google-Smtp-Source: APXvYqyMJp/ciwGVJeHlI8WoK8JZSwrUQYYvgEYvweKrdTjsrrZFfzHIw/aveB18pqAJ0WiSodLFYkTiLI0J5t6Ryrc=
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr12251397ljk.13.1580699622324;
 Sun, 02 Feb 2020 19:13:42 -0800 (PST)
MIME-Version: 1.0
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com> <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com> <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
 <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com> <fe7ec5d0-73ed-aa8b-3246-39894252fec7@gmail.com>
In-Reply-To: <fe7ec5d0-73ed-aa8b-3246-39894252fec7@gmail.com>
From:   Trev Larock <trev@larock.ca>
Date:   Sun, 2 Feb 2020 22:13:30 -0500
X-Gmail-Original-Message-ID: <CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA@mail.gmail.com>
Message-ID: <CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA@mail.gmail.com>
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     David Ahern <dsahern@gmail.com>
Cc:     Ben Greear <greearb@candelatech.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Exim-Id: CAHgT=KePvNSg9uU7SdG-9LwmwZZJkH7_FSXW+Yd5Y8G-Bd3gtA
X-Bayes-Prob: 0.0001 (Score 0, tokens from: base:default, @@RPTN)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: No geolocation information available for 192.168.101.22
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 011W4RUSf - aac1de17e286 - 20200202
X-Scanned-By: CanIt (www . roaringpenguin . com) on 192.168.101.83
X-To-Not-Matched: true
X-Originating-IP: 192.168.101.83
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 11:51 AM David Ahern <dsahern@gmail.com> wrote:
> Trev's problem is looping due to the presence of the qdisc. The vrf
> driver needs to detect that it has seen the packet and not redirect it
> again.
Yes note it was when specifying no dev on the xfrm policy/state.
For the non-qdisc case the policy triggered from the __ip4_datagram_connect->
xfrm_lookup and the vrf "direct" route sent it out without any xfrm_lookup call.
It appears to work but it's not really a "xfrm vrf specific " policy.

For qdisc the policy matched again on the vrf->xfrm_lookup call.

When specifying "dev vrf0" I don't see the policy get matched at all.
Should that be triggered in the vrf.c -> xfrm_lookup  call from
vrf_process_v4_outbound or elsewhere?

(The qdisc case seems more like the older / pre dcdd43c41e commit flow.)

From ftrace stack trace with qdisc and sending UDP packet with netcat
   nc-4391  [001] .... 11663.551103: xfrm_lookup <-xfrm_lookup_route
   nc-4391  [001] .... 11663.551104: <stack trace>
 => xfrm_lookup
 => xfrm_lookup_route
 => vrf_xmit
 => dev_hard_start_xmit
 => sch_direct_xmit
 => __qdisc_run
 => __dev_queue_xmit
 => vrf_finish_output
 => vrf_output
 => ip_send_skb
 => udp_send_skb
 => udp_sendmsg
 => sock_sendmsg
 => SYSC_sendto
 => do_syscall_64
 => entry_SYSCALL_64_after_hwframe

Full flow from vrf_xmit:
vrf_xmit
 -->is_ip_tx_frame
   -->vrf_process_v4_outbound
     -->ip_route_output_flow
       -->xfrm_lookup_route
         --> xfrm_lookup

In vrf_process_v4_outbound the flow sets ".flowi4_oif = vrf_dev->ifindex",
should that match the vrf ifindex or the network interface enslaved to the vrf?
I observe it's = network interface so matching a policy with dev vrf0
won't trigger, but not sure if it's missing config or some other issue.
Is there any reference/test sample configs for vrf+xfrm use case where
that matched policy as expected? (even on older kernel).

Thanks,
Trev

