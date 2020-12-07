Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D1F2D0A67
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 06:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgLGFvA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 00:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:46022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725799AbgLGFvA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 00:51:00 -0500
Message-ID: <f7dead39f1fb882f752a31daa2bcbbcc2101e422.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607320219;
        bh=urPYCW4DcbTsFKodt+mJMdeHSL9XRYfIR+Ew8+LQ1Bk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H4SLrsTfKTE/UoKHouJkm4dt5oMU9qx0OmmlDfTvPE8jWTjKWJbZlp/kRB6ik9afL
         vOga2fnwNr9YPRZs+1hvYvbIzuzdy7IPLOhS2t/31B+N+UIIUGjohvhrvxuxfqWRR0
         cXFsIXNi6yPkrDzPfB5xkrZwGRtWkodDIRq2/Iff7gKyGrEN0TI2uJdfjPRhwlixnq
         j6qhzmwslxiHlG7d1FCXNDIBHKXxnc9MJs4lDkCjeSx+AdokJ/6Egla1eZhU58sN8p
         JPljTHrp4d38SDPDv8ClY/VObJES1eysctodFQdDATYZV29t3C6twwxpDUjGcMCrzR
         TX8QASTssvKeg==
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 06 Dec 2020 21:50:17 -0800
In-Reply-To: <20201205014927.bna4nib4jelwkxe7@skbuf>
References: <20201203042108.232706-1-saeedm@nvidia.com>
         <20201203042108.232706-9-saeedm@nvidia.com>
         <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
         <20201204122613.542c2362@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <20201205014927.bna4nib4jelwkxe7@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2020-12-05 at 03:49 +0200, Vladimir Oltean wrote:
> On Fri, Dec 04, 2020 at 12:26:13PM -0800, Jakub Kicinski wrote:
> > On Fri, 04 Dec 2020 11:33:26 -0800 Saeed Mahameed wrote:
> > > On Thu, 2020-12-03 at 18:29 -0800, Jakub Kicinski wrote:
> > > > On Wed, 2 Dec 2020 20:21:01 -0800 Saeed Mahameed wrote:
> > > > > Add TX PTP port object support for better TX timestamping
> > > > > accuracy.
> > > > > Currently, driver supports CQE based TX port timestamp.
> > > > > Device
> > > > > also offers TX port timestamp, which has less jitter and
> > > > > better
> > > > > reflects the actual time of a packet's transmit.
> > > > 
> > > > How much better is it?
> > > > 
> > > > Is the new implementation is standard compliant or just a
> > > > "better
> > > > guess"?
> > > 
> > > It is not a guess for sure, the closer to the output port you
> > > take the
> > > stamp the more accurate you get, this is why we need the HW
> > > timestamp
> > > in first place, i don't have the exact number though, but we
> > > target to
> > > be compliant with G.8273.2 class C, (30 nsec), and this code
> > > allow
> > > Linux systems to be deployed in the 5G telco edge. Where this
> > > standard
> > > is needed.
> > 
> > I see. IIRC there was also an IEEE standard which specified the
> > exact
> > time stamping point (i.e. SFD crosses layer X). If it's class C
> > that
> > answers the question, I think.
> 
> The ITU-T G.8273.2 specification just requires a Class C clock to
> have a
> maximum absolute time error under steady state of 30 ns. And taking
> timestamps closer to the wire eliminates some clock domain crossings
> from what is measured in the path delay, this is probably the reason
> why
> timestamping is more accurate, and it helps to achieve the required
> jitter figure.
> 
> The IEEE standard that you're thinking of is clause "7.3.4 Generation
> of
> event message timestamps" of IEEE 1588.
> 
> -----------------------------[cut here]-----------------------------
> 7.3.4.1 Event message timestamp point
> 
> Unless otherwise specified in a transport-specific annex to this
> standard, the message timestamp point for an event message shall be
> the
> beginning of the first symbol after the Start of Frame (SOF)
> delimiter.
> 
> 7.3.4.2 Event timestamp generation
> 
> All PTP event messages are timestamped on egress and ingress. The
> timestamp shall be the time at which the event message timestamp
> point
> passes the reference plane marking the boundary between the PTP node
> and
> the network.
> 
> NOTE 1— If an implementation generates event message timestamps using
> a
> point other than the message timestamp point, then the generated
> timestamps should be appropriately corrected by the time interval
> between the actual time of detection and the time the message
> timestamp
> point passed the reference plane. Failure to make these corrections
> results in a time offset between the slave and master clocks.
> -----------------------------[cut here]-----------------------------
> 
> So there you go, it just says "the reference plane marking the
> boundary
> between the PTP node and the network". So it depends on how you draw
> the
> borders. I cannot seem to find any more precise definition.
> 
> Regardless of the layer at which the timestamp is taken, it is the
> jitter that matters more than the reduced path delay. The latter is
> just
> a side effect.
> 

SO the closer to the wire you take the stamp the less potential for
jitter, since this is after ALL HW pipeline variable delays.

> "How much better" is an interesting question though.


