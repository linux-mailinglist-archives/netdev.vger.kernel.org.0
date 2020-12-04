Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEBA2CF4D2
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 20:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbgLDTeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 14:34:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726276AbgLDTeI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 14:34:08 -0500
Message-ID: <b761c676af87a4a82e3ea4f6f5aff3d1159c63e7.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607110407;
        bh=Ryr2XsIQiD948YhOaSVBLwQgsAzSS1chmBwzEl7WC84=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EKww2J1NCMPC1DPaQNgqR6jTVvB7eZNBCFBqoB3rgO6CGcyLr5GDzUJASAxN4ZDzB
         ayMz48pCcSUheWwTr3rSHEeFYLIxWUtdS4bQU6rf2moTj9NV2O8BuaM8MKqfr4w6tu
         lXQRulCbIrJj4ch1ydB6GHIRw9TRsfVdlREByBH19fPNGeTb7BuUwtTY3w1Quu0TRk
         j1ahRlXJRVPbp9Q8S3+TWhc70h96EG/AxKVXypXswcy253fnKuu5vFYzg9Hk0uwMAw
         aTcp1R+sXSEftMHGpPMXeTV32+nE3a0qPTxFZrINjrEh5pCOUBK3WGs0BFIpbL6Pcv
         sEUz2OBGLO0EA==
Subject: Re: [net-next V2 08/15] net/mlx5e: Add TX PTP port object support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Fri, 04 Dec 2020 11:33:26 -0800
In-Reply-To: <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
         <20201203042108.232706-9-saeedm@nvidia.com>
         <20201203182908.1d25ea3f@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-12-03 at 18:29 -0800, Jakub Kicinski wrote:
> On Wed, 2 Dec 2020 20:21:01 -0800 Saeed Mahameed wrote:
> > Add TX PTP port object support for better TX timestamping accuracy.
> > Currently, driver supports CQE based TX port timestamp. Device
> > also offers TX port timestamp, which has less jitter and better
> > reflects the actual time of a packet's transmit.
> 
> How much better is it?
> 
> Is the new implementation is standard compliant or just a "better
> guess"?
> 

It is not a guess for sure, the closer to the output port you take the
stamp the more accurate you get, this is why we need the HW timestamp
in first place, i don't have the exact number though, but we target to
be compliant with G.8273.2 class C, (30 nsec), and this code allow
Linux systems to be deployed in the 5G telco edge. Where this standard
is needed.

> > Define new driver layout called ptpsq, on which driver will create
> > SQs that will support TX port timestamp for their transmitted
> > packets.
> > Driver to identify PTP TX skbs and steer them to these dedicated
> > SQs
> > as part of the select queue ndo.
> > 
> > Driver to hold ptpsq per TC and report them at
> > netif_set_real_num_tx_queues().
> > 
> > Add support for all needed functionality in order to xmit and poll
> > completions received via ptpsq.
> > 
> > Add ptpsq to the TX reporter recover, diagnose and dump methods.
> > 
> > Creation of ptpsqs is disabled by default, and can be enabled via
> > tx_port_ts private flag.
> 
> This flag is pretty bad user experience.
> 

Yeah, nothing i  could do about this, there is a large memory foot
print i want to avoid, and we don't want to complicate PTP ctrl API of
the HW operating mode, so until we improve the HW, we prefer to keep
this feature as a private flag.

> > This patch steer all timestamp related packets to a ptpsq, but it
> > does not open the port timestamp support for it. The support will
> > be added in the following patch.
> 
> Overall I'm a little shocked by this, let me sleep on it :)
> 
> More info on the trade offs and considerations which led to the
> implementation would be useful.

To get the Improved accuracy we need a special type of SQs attached to
special HW objects that will provide more accurate stamping.

Trade-offs are :

options 1) convert ALL regular txqs (SQs) to work in this port stamping
mode.

Pros: no need for any special mode in driver, no additional memory,
other than the new HW objects we create for the special stamping.

Cons: significant performance hit for non PTP traffic, (the hw stamps
all packets in the slow but more accurate mode)

option 2) route PTP traffic to a special SQs per ring, this SQ will be
PTP port accurate, Normal traffic will continue through regular SQs

Pros: Regular non PTP traffic not affected.
Cons: High memory footprint for creating special SQs


So we prefer (2) + private flag to avoid the performance hit and the
redundant memory usage out of the box.




