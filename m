Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68A22BF368
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfIZMxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:53:50 -0400
Received: from www62.your-server.de ([213.133.104.62]:59078 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfIZMxt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:53:49 -0400
Received: from [178.197.248.15] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iDTHH-0003JM-TH; Thu, 26 Sep 2019 14:53:48 +0200
Date:   Thu, 26 Sep 2019 14:53:47 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: Are BPF tail calls only supposed to work with pinned maps?
Message-ID: <20190926125347.GB6563@pc-63.home>
References: <874l0z2tdx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <874l0z2tdx.fsf@toke.dk>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25584/Thu Sep 26 10:24:31 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Thu, Sep 26, 2019 at 01:23:38PM +0200, Toke Høiland-Jørgensen wrote:
[...]
> While working on a prototype of the XDP chain call feature, I ran into
> some strange behaviour with tail calls: If I create a userspace program
> that loads two XDP programs, one of which tail calls the other, the tail
> call map would appear to be empty even though the userspace program
> populates it as part of the program loading.
> 
> I eventually tracked this down to this commit:
> c9da161c6517 ("bpf: fix clearing on persistent program array maps")

Correct.

> Which clears PROG_ARRAY maps whenever the last uref to it disappears
> (which it does when my loader exits after attaching the XDP program).
> 
> This effectively means that tail calls only work if the PROG_ARRAY map
> is pinned (or the process creating it keeps running). And as far as I
> can tell, the inner_map reference in bpf_map_fd_get_ptr() doesn't bump
> the uref either, so presumably if one were to create a map-in-map
> construct with tail call pointer in the inner map(s), each inner map
> would also need to be pinned (haven't tested this case)?

There is no map in map support for tail calls today.

> Is this really how things are supposed to work? From an XDP use case PoV
> this seems somewhat surprising...
> 
> Or am I missing something obvious here?

The way it was done like this back then was in order to break up cyclic
dependencies as otherwise the programs and maps involved would never get
freed as they reference themselves and live on in the kernel forever
consuming potentially large amount of resources, so orchestration tools
like Cilium typically just pin the maps in bpf fs (like most other maps
it uses and accesses from agent side) in order to up/downgrade the agent
while keeping BPF datapath intact.

Thanks,
Daniel
