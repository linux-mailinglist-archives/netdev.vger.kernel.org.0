Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D00D3D340F
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 07:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbhGWEre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 00:47:34 -0400
Received: from zeniv-ca.linux.org.uk ([142.44.231.140]:41832 "EHLO
        zeniv-ca.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbhGWErc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 00:47:32 -0400
Received: from viro by zeniv-ca.linux.org.uk with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m6ncc-0034np-I3; Fri, 23 Jul 2021 05:21:18 +0000
Date:   Fri, 23 Jul 2021 05:21:18 +0000
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Boris Pismenny <borispismenny@gmail.com>,
        Boris Pismenny <borisp@nvidia.com>, dsahern@gmail.com,
        kuba@kernel.org, davem@davemloft.net, saeedm@nvidia.com,
        sagi@grimberg.me, axboe@fb.com, kbusch@kernel.org,
        edumazet@google.com, smalin@marvell.com, boris.pismenny@gmail.com,
        linux-nvme@lists.infradead.org, netdev@vger.kernel.org,
        benishay@nvidia.com, ogerlitz@nvidia.com, yorayz@nvidia.com,
        Boris Pismenny <borisp@mellanox.com>,
        Ben Ben-Ishay <benishay@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Yoray Zack <yorayz@mellanox.com>
Subject: Re: [PATCH v5 net-next 02/36] iov_iter: DDP copy to iter/pages
Message-ID: <YPpRziMHmeatfAw2@zeniv-ca.linux.org.uk>
References: <20210722110325.371-1-borisp@nvidia.com>
 <20210722110325.371-3-borisp@nvidia.com>
 <YPlzHTnoxDinpOsP@infradead.org>
 <6f7f96dc-f1e6-99d9-6ab4-920126615302@gmail.com>
 <20210723050302.GA30841@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723050302.GA30841@lst.de>
Sender: Al Viro <viro@ftp.linux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 07:03:02AM +0200, Christoph Hellwig wrote:
> On Thu, Jul 22, 2021 at 11:23:38PM +0300, Boris Pismenny wrote:
> > This routine, like other changes in this file, replicates the logic in
> > memcpy_to_page. The only difference is that "ddp" avoids copies when the
> > copy source and destinations buffers are one and the same.
> 
> Now why can't we just make that change to the generic routine?

Doable... replace memcpy(base, addr + off, len) with
	base != addr + off && memcpy(base, addr + off, len)
in _copy_to_iter() and be done with that...
