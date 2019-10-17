Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149FBDB2EF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:04:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440554AbfJQRE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:04:26 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34560 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732079AbfJQRE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:04:26 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 6AC1A2836BC
Message-ID: <c04a2fbd630e91435eab985abfaf3bcb6a8d60d5.camel@collabora.com>
Subject: Re: [net-next 2/7] igb: add rx drop enable attribute
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Aaron Brown <aaron.f.brown@intel.com>
Date:   Thu, 17 Oct 2019 18:04:22 +0100
In-Reply-To: <20191017084433.18bce3d4@cakuba.netronome.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
         <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
         <20191016165531.26854b0e@cakuba.netronome.com>
         <a575469d3b2a12d24161d0c6b0a6bff538e066b6.camel@collabora.com>
         <20191017084433.18bce3d4@cakuba.netronome.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2019-10-17 at 08:44 -0700, Jakub Kicinski wrote:
> On Thu, 17 Oct 2019 12:24:03 +0100, Robert Beckett wrote:
> > On Wed, 2019-10-16 at 16:55 -0700, Jakub Kicinski wrote:
> > > On Wed, 16 Oct 2019 16:47:06 -0700, Jeff Kirsher wrote:  
> > > > From: Robert Beckett <bob.beckett@collabora.com>
> > > > 
> > > > To allow userland to enable or disable dropping packets when
> > > > descriptor
> > > > ring is exhausted, add RX_DROP_EN private flag.
> > > > 
> > > > This can be used in conjunction with flow control to mitigate
> > > > packet storms
> > > > (e.g. due to network loop or DoS) by forcing the network
> > > > adapter to
> > > > send
> > > > pause frames whenever the ring is close to exhaustion.
> > > > 
> > > > By default this will maintain previous behaviour of enabling
> > > > dropping of
> > > > packets during ring buffer exhaustion.
> > > > Some use cases prefer to not drop packets upon exhaustion, but
> > > > instead
> > > > use flow control to limit ingress rates and ensure no dropped
> > > > packets.
> > > > This is useful when the host CPU cannot keep up with packet
> > > > delivery,
> > > > but data delivery is more important than throughput via
> > > > multiple
> > > > queues.
> > > > 
> > > > Userland can set this flag to 0 via ethtool to disable packet
> > > > dropping.
> > > > 
> > > > Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> > > > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > > > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>  
> > > 
> > > How is this different than enabling/disabling flow control..
> > > 
> > > ethtool -a/-A  
> > 
> > Enabling flow control enables the advertisement of flow control
> > capabilites and allows negotiation with link partner.
> 
> More or less. If autoneg is on it controls advertised bits,
> if autoneg is off it controls the enabled/disable directly.
> 
> > It does not dictate under which circumstances those pause frames
> > will
> > be emitted.
> 
> So you're saying even with pause frames on igb by default will not
> backpressure all the way to the wire if host RX ring is full/fill
> ring
> is empty?

Correct.
Honestly I personally considered it a bug when I first saw it.

see e6bdb6fefc590

Specifically it enables dropping of frames if multiple queues are in
use, ostensibly to prevent head of line blocking between the different
rx queues.

This patch says that that should be a user choice, defaulting to the
old behaviour.


> 
> > This patch enables an igb specific feature that can cause flow
> > control
> > to be used. The default behaviour is to drop packets if the rx ring
> > buffer fills. This flag tells the driver instead to emit pause
> > frames
> > and not drop packets, which is useful when reliable data delivery
> > is
> > more important than throughput.
> 
> The feature looks like something easily understood with a standard
> NIC
> model in mind. Therefore it should have a generic config knob not a
> private flag.

I have no particular opinion on whether this should be a generic flag
or a priv flag. It could be argued that it is a priv flag to handle a
particular quirk of the igb driver that others likely won't share
(though Ive not vetted other drivers to check).

It could also be argued that if flow control is successfully enabled
(either forced or via autoneg) that dropping packets should not be
enabled, however I'm not enough of a networking expert to say whether
the flow control being enabled dictates which circumstances should
generate the pause frames or whether it is implementation defined.

If it is decided that the kernel in general should support a new set of
flags for flow control causes, over the top of the the enable/disable,
then I could see that being a generic flag that each nic decides how to
implement. I would rather wait for more consensus before tackling that
though.


