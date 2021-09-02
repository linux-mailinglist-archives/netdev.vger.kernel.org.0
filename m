Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57F3FF49E
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 22:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345183AbhIBUIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 16:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243737AbhIBUIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 16:08:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519D5C061575
        for <netdev@vger.kernel.org>; Thu,  2 Sep 2021 13:07:38 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mLszo-00085X-By; Thu, 02 Sep 2021 22:07:36 +0200
Date:   Thu, 2 Sep 2021 22:07:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     folkert <folkert@vanheusden.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org
Subject: Re: masquerading AFTER first packet
Message-ID: <20210902200736.GB23554@breakpoint.cc>
References: <20210901204204.GB3350910@belle.intranet.vanheusden.com>
 <20210902162612.GA23554@breakpoint.cc>
 <20210902174845.GE3350910@belle.intranet.vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902174845.GE3350910@belle.intranet.vanheusden.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

folkert <folkert@vanheusden.com> wrote:
> > You might want to try and disable udp releated offload settings to see
> > if that helps.
> 
> If offloading is the problem, wouldn't the first packet fail as well?

No, not necessarily, I recall a bug with fraglist udp where only first
packet in the batch had headers changed.

[..]
> udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=4 bytes=267 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
> udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=5 bytes=334 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
> udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=6 bytes=401 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
> udp      17 119 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=7 bytes=468 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
> udp      17 118 src=185.243.112.54 dst=37.34.63.177 sport=52775 dport=161 packets=7 bytes=468 src=192.168.4.2 dst=185.243.112.54 sport=161 dport=52775 packets=1 bytes=80 [ASSURED] mark=0 use=1
> ...
> 
> So yes, increating packet/byte counters.

[..]

> [Thu Sep  2 19:40:54 2021] nf_ct_proto_17: bad checksum IN= OUT= SRC=192.168.4.2 DST=185.243.112.54 LEN=82 TOS=0x00 PREC=0x00 TTL=64 ID=0 DF PROTO=UDP SPT=161 DPT=56523 LEN=61

So reverse direction packets are deemed invalid and are thus not reverse-translated.

This is a bug, but not sure where.  What driver/nic is feeding these
packets to stack?

sysctl net.netfilter.nf_conntrack_checksum=0

should make things "work".
