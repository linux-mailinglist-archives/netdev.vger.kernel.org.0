Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D8ADAB1F
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 13:24:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408919AbfJQLYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 07:24:08 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:32780 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408897AbfJQLYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 07:24:08 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: bbeckett)
        with ESMTPSA id 7C138285294
Message-ID: <a575469d3b2a12d24161d0c6b0a6bff538e066b6.camel@collabora.com>
Subject: Re: [net-next 2/7] igb: add rx drop enable attribute
From:   Robert Beckett <bob.beckett@collabora.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Aaron Brown <aaron.f.brown@intel.com>
Date:   Thu, 17 Oct 2019 12:24:03 +0100
In-Reply-To: <20191016165531.26854b0e@cakuba.netronome.com>
References: <20191016234711.21823-1-jeffrey.t.kirsher@intel.com>
         <20191016234711.21823-3-jeffrey.t.kirsher@intel.com>
         <20191016165531.26854b0e@cakuba.netronome.com>
Organization: Collabora
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-10-16 at 16:55 -0700, Jakub Kicinski wrote:
> On Wed, 16 Oct 2019 16:47:06 -0700, Jeff Kirsher wrote:
> > From: Robert Beckett <bob.beckett@collabora.com>
> > 
> > To allow userland to enable or disable dropping packets when
> > descriptor
> > ring is exhausted, add RX_DROP_EN private flag.
> > 
> > This can be used in conjunction with flow control to mitigate
> > packet storms
> > (e.g. due to network loop or DoS) by forcing the network adapter to
> > send
> > pause frames whenever the ring is close to exhaustion.
> > 
> > By default this will maintain previous behaviour of enabling
> > dropping of
> > packets during ring buffer exhaustion.
> > Some use cases prefer to not drop packets upon exhaustion, but
> > instead
> > use flow control to limit ingress rates and ensure no dropped
> > packets.
> > This is useful when the host CPU cannot keep up with packet
> > delivery,
> > but data delivery is more important than throughput via multiple
> > queues.
> > 
> > Userland can set this flag to 0 via ethtool to disable packet
> > dropping.
> > 
> > Signed-off-by: Robert Beckett <bob.beckett@collabora.com>
> > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> 
> How is this different than enabling/disabling flow control..
> 
> ethtool -a/-A

Enabling flow control enables the advertisement of flow control
capabilites and allows negotiation with link partner. It does not
dictate under which circumstances those pause frames will be emitted.

This patch enables an igb specific feature that can cause flow control
to be used. The default behaviour is to drop packets if the rx ring
buffer fills. This flag tells the driver instead to emit pause frames
and not drop packets, which is useful when reliable data delivery is
more important than throughput.


