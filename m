Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C246B1E1C8D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731551AbgEZHyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 03:54:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:41416 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726048AbgEZHyT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 03:54:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 952B8ACA1;
        Tue, 26 May 2020 07:54:21 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EE7C76032A; Tue, 26 May 2020 09:54:17 +0200 (CEST)
Date:   Tue, 26 May 2020 09:54:17 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     =?utf-8?B?6rCV7Jyg6rG0?= <yugun819@pumpkinnet.com>
Subject: Re: With regard to processing overlapping fragment packet
Message-ID: <20200526075417.n2xdtzpwnpu3vzxx@lion.mk-sys.cz>
References: <CALMTMJJG7-VmS7pa2bgH=YsmgUJzi=YSnO8OtKpW=VyjyXWTkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALMTMJJG7-VmS7pa2bgH=YsmgUJzi=YSnO8OtKpW=VyjyXWTkQ@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 02:47:25PM +0900, 강유건 wrote:
> Hello
> 
> Actually, I'm not sure if it's right to send mail here.
> 
> I'm testing ipv6ready Self Test 5.0.4 using linux-4.19.118 kernel.
> ( https://www.ipv6ready.org.cn/home/views/default/resource/logo/phase2-core/index.htm
> )
> 
> Test failed in 82. Part B: Reverse Order Fragments ( Link-Local ) in
> Section 1. spec
> 
> In test 82, source transmits 3 fragment packets in reverse order that
> are originally a icmpv6 packet.
> There is an overlapping interval between the 2nd and 3rd packet.
> 
> The test requires the destination MUST drop all packets and respond nothing,
> but the dest replies Time Exceeded / Reassembly Timeout.
> 
> I've read some /net/ipv6 codes and think when the kernel receives the
> 2nd packet ( overlapping occurs ), it drops 3rd and 2nd packets and
> recognizes the 1st packet as a new fragment packet.
> ( Is it right ? )
> 
> In RFC5722, when a node receives the overlapping fragment, it MUST
> discard those not yet received. (  In this case, I think it applies to
> 1st packet )
> 
> Please let me know if I misunderstood RFC or if it wasn't implemented
> in the kernel.

You understood the requirement of the RFC correctly but the problem is
that implementing it would be too complicated, would make the
implementation susceptible to DoS attacks and could even result in
dropping legitimate (new) fragments. Therefore an erratum to RFC 5722
was accepted which drops the requirement to also drop fragments not
received yet:

  https://www.rfc-editor.org/errata/eid3089

Michal
