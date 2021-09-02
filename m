Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB373FF151
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 18:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346160AbhIBQ1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 12:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbhIBQ1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 12:27:13 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30322C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 09:26:15 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mLpXY-00072f-I5; Thu, 02 Sep 2021 18:26:12 +0200
Date:   Thu, 2 Sep 2021 18:26:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     folkert <folkert@vanheusden.com>
Cc:     netdev@vger.kernel.org
Subject: Re: masquerading AFTER first packet
Message-ID: <20210902162612.GA23554@breakpoint.cc>
References: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

folkert <folkert@vanheusden.com> wrote:
> Hi,
> 
> I'm seeing something strange. I'm doing an snmpwalk on an snmp server of
> mine (behing DNAT) , and after the first response it goes into a timeout.
> I did a tcpdump and saw this:
> 
> 1630528031.843264 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(23)  .1.3.6.1
> 1630528031.843924 IP 37.34.63.177.161 > 185.243.112.54.38377: GetResponse(34)  .1.3.6.1.2=0   <-- ok
> 1630528031.846950 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
> 1630528031.847415 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail
> 1630528032.847649 IP 185.243.112.54.38377 > 37.34.63.177.161: GetNextRequest(24)  .1.3.6.1.2
> 1630528032.848081 IP 192.168.4.2.161 > 185.243.112.54.38377: GetResponse(35)  .1.3.6.1.2.1=0  <-- fail

Looks like a kernel bug, but you did not include kernel version.

Please also show 'ethtool -k' for in and out interfaces.

You might want to try and disable udp releated offload settings to see
if that helps.

e.g.
c3df39ac9b0e3747bf8233ea9ce4ed5ceb3199d3,
"udp: ipv4: manipulate network header of NATed UDP GRO fraglist"
which fixed a bug where only first packet of GRO'd udp train would
have nat applied, (was broken between 5.6 and 5.11)

Other explanation is that conntrack thinks only first packet is valid,
you can check this for example via

sysctl net.netfilter.nf_conntrack_acct=1

and then checking if 'conntrack -L' shows increasing packet/byte
counters or is stuck at '1'.

If the remaining packets are indeed invalid, try setting
sysctl net.netfilter.nf_conntrack_log_invalid=17

(17 == udp).

and see if that shows something relevant.
