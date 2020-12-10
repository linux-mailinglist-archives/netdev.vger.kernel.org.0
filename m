Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264432D4F8B
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:37:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729640AbgLJAgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:36:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbgLJAgN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 19:36:13 -0500
Date:   Thu, 10 Dec 2020 01:35:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607560531;
        bh=wxKmgiGIrwLEcdTmpOgRsS6brQkIjR6i0roFhZgQd00=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=eNhUlY1a89y3/hLwIfehqbBqFa3pnvos98n9uoPdX3KG4osuphOd1KVE12xrT15O2
         kd83k+jRDX14bqBjhDrpip841n588IR8gGNhcPh96gLo68KvSZd66AoMMYBJ/eFouH
         QAiQ5fEUYkRImAMY4MnWk8S+T9vjC2N01XgwmfDGZXxa/0YK2JTjKRhERwda9fPy9O
         3w25Kdz3RPrNMfKsnc5WYtJSa80GU7wt6DR0laUS7ckdk2ZEKXGPmYPr8z2uaEqpfb
         bj8or1L+5fzHh4gEowbkEgzE258pv48Ib1IcRORtjsjNHF4Ps9mBsU3+sGWb+TUhyX
         CVnykaIzXbBNA==
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Trent Piepho <tpiepho@gmail.com>
Cc:     Joseph Hwang <josephsih@google.com>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        chromeos-bluetooth-upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        Alain Michaud <alainm@chromium.org>,
        Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Bluetooth: btusb: define HCI packet sizes of USB
 Alts
Message-ID: <20201210003528.3pmaxvubiwegxmhl@pali>
References: <20200910060403.144524-1-josephsih@chromium.org>
 <9810329.nUPlyArG6x@zen.local>
 <20201209011336.4qdnnehnz3kdlqid@pali>
 <5703442.lOV4Wx5bFT@zen.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5703442.lOV4Wx5bFT@zen.local>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wednesday 09 December 2020 16:19:39 Trent Piepho wrote:
> On Tuesday, December 8, 2020 5:13:36 PM PST Pali Rohár wrote:
> > On Tuesday 08 December 2020 15:04:29 Trent Piepho wrote:
> > > Does this also give userspace a clear point at which to determine MTU 
> setting, 
> > > _before_ data is sent over SCO connection?  It will not work if sco_mtu 
> is not 
> > > valid until after userspace sends data to SCO connection with incorrect 
> mtu.
> > 
> > IIRC connection is established after sync connection (SCO) complete
> > event. And sending data is possible after connection is established. So
> > based on these facts I think that userspace can determinate MTU settings
> > prior sending data over SCO socket.
> > 
> > Anyway, to whole MTU issue for SCO there is a nice workaround which
> > worked fine with more tested USB adapters and headsets. As SCO socket is
> > synchronous and most bluetooth headsets have own clocks, you can
> > synchronize sending packets to headsets based on time events when you
> > received packets from other side and also send packets of same size as
> > you received. I.e. for every received packet send own packet of the same
> > size.
> 
> As I understand it, the RX side from the headset is not guaranteed, so in 
> the TX only case this will not work and we still need to be told what MTU 
> kernel has selected for the SCO link.

I'm not sure if TX-only SCO link is possible. I always thought that SCO
is synchronous bidirectional link.

As I said, this "workaround" is useful for classic bluetooth headsets
and is it possible to use it immediately without any kernel changes.

And I agree that kernel should tell userspace correct MTU value. And
this should be fixed. "Workaround" is useful for immediate action to
deliver at least something which works with most bluetooth headsets.

> It seems also it would add some latency to start up, since it would be 
> necessary to wait for packets to arrive before knowing what size packet to 
> send.

I think this startup latency is negligible in HFP profile where start
needs non-trivial exchange of AT commands.

> Would timing based on matching TX to RX in the case of packet loss on RX 
> side?

That is a good question for some research. I remember that e.g.
pulseaudio used this technique for synchronizing bluetooth SCO RX and TX
streams.
