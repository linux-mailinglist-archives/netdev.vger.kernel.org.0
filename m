Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 431B62CAF06
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 22:44:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728023AbgLAVmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 16:42:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgLAVmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 16:42:04 -0500
Received: from lt-jalone-7480.mtl.com (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C854720709;
        Tue,  1 Dec 2020 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606858883;
        bh=qiAFd5DPKNGfai3BkRWqoAtxyW3izHinBVCj0PUx0Og=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vt11ZMrLaFFWzaHkY5b6B97GELB4tCu/QXFrgL0Eulyh3NY/5mOVruk7RAnmnUZHn
         lYmsZzZ12XusFoCb5FBH2DgMbpP6cbti3pcegxvnPFCq6RaxVwXYDfS9S0zxVQG6gX
         Zcq1ear9iYaxFJw2yCxfhI7aEDr6rRwLs/u8PzsY=
Message-ID: <9b24cd270def8ea5432fc117e4fd1ed9c756a58d.camel@kernel.org>
Subject: Re: [net-next V2 09/15] net/mlx5e: CT: Use the same counter for
 both directions
From:   Saeed Mahameed <saeed@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ariel Levkovich <lariel@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@nvidia.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>
Date:   Tue, 01 Dec 2020 13:41:21 -0800
In-Reply-To: <20201127140128.GC3555@localhost.localdomain>
References: <20200923224824.67340-1-saeed@kernel.org>
         <20200923224824.67340-10-saeed@kernel.org>
         <20201127140128.GC3555@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-27 at 11:01 -0300, Marcelo Ricardo Leitner wrote:
> On Wed, Sep 23, 2020 at 03:48:18PM -0700, saeed@kernel.org wrote:
> > From: Oz Shlomo <ozsh@mellanox.com>
> 
> Sorry for reviving this one, but seemed better for the context.
> 
> > A connection is represented by two 5-tuple entries, one for each
> > direction.
> > Currently, each direction allocates its own hw counter, which is
> > inefficient as ct aging is managed per connection.
> > 
> > Share the counter that was allocated for the original direction
> > with the
> > reverse direction.
> 
> Yes, aging is done per connection, but the stats are not. With this
> patch, with netperf TCP_RR test, I get this: (mangled for
> readability)
> 
> # grep 172.0.0.4 /proc/net/nf_conntrack
> ipv4     2 tcp      6
>   src=172.0.0.3 dst=172.0.0.4 sport=34018 dport=33396 packets=3941992
> bytes=264113427
>   src=172.0.0.4 dst=172.0.0.3 sport=33396 dport=34018 packets=4
> bytes=218 [HW_OFFLOAD]
>   mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3
> 
> while without it (594e31bceb + act_ct patch to enable it posted
> yesterday + revert), I get:
> 
> # grep 172.0.0.4 /proc/net/nf_conntrack
> ipv4     2 tcp      6
>   src=172.0.0.3 dst=172.0.0.4 sport=41856 dport=32776 packets=1876763
> bytes=125743084
>   src=172.0.0.4 dst=172.0.0.3 sport=32776 dport=41856 packets=1876761
> bytes=125742951 [HW_OFFLOAD]
>   mark=0 secctx=system_u:object_r:unlabeled_t:s0 zone=0 use=3
> 
> The same is visible on 'ovs-appctl dpctl/dump-conntrack -s' then.
> Summing both directions in one like this is at least very misleading.
> Seems this change was motivated only by hw resources constrains. That
> said, I'm wondering, can this change be reverted somehow?
> 
>   Marcelo

Hi Marcelo, thanks for the report, 
Sorry i am not familiar with this /procfs
Oz, Ariel, Roi, what is your take on this, it seems that we changed the
behavior of stats incorrectly.

Thanks,
Saeed.


