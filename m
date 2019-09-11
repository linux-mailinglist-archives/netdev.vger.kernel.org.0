Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45EAFD75
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 15:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfIKNMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 09:12:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:45572 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbfIKNMi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 09:12:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0B042B687;
        Wed, 11 Sep 2019 13:12:36 +0000 (UTC)
Date:   Wed, 11 Sep 2019 15:12:35 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] vhost: block speculation of translated descriptors
Message-ID: <20190911131235.GZ4023@dhcp22.suse.cz>
References: <20190911120908.28410-1-mst@redhat.com>
 <20190911121628.GT4023@dhcp22.suse.cz>
 <20190911082236-mutt-send-email-mst@kernel.org>
 <20190911123316.GX4023@dhcp22.suse.cz>
 <20190911085807-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911085807-mutt-send-email-mst@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed 11-09-19 09:03:10, Michael S. Tsirkin wrote:
> On Wed, Sep 11, 2019 at 02:33:16PM +0200, Michal Hocko wrote:
> > On Wed 11-09-19 08:25:03, Michael S. Tsirkin wrote:
> > > On Wed, Sep 11, 2019 at 02:16:28PM +0200, Michal Hocko wrote:
> > > > On Wed 11-09-19 08:10:00, Michael S. Tsirkin wrote:
> > > > > iovec addresses coming from vhost are assumed to be
> > > > > pre-validated, but in fact can be speculated to a value
> > > > > out of range.
> > > > > 
> > > > > Userspace address are later validated with array_index_nospec so we can
> > > > > be sure kernel info does not leak through these addresses, but vhost
> > > > > must also not leak userspace info outside the allowed memory table to
> > > > > guests.
> > > > > 
> > > > > Following the defence in depth principle, make sure
> > > > > the address is not validated out of node range.
> > > > > 
> > > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > > > Acked-by: Jason Wang <jasowang@redhat.com>
> > > > > Tested-by: Jason Wang <jasowang@redhat.com>
> > > > 
> > > > no need to mark fo stable? Other spectre fixes tend to be backported
> > > > even when the security implications are not really clear. The risk
> > > > should be low and better to be covered in case.
> > > 
> > > This is not really a fix - more a defence in depth thing,
> > > quite similar to e.g.  commit b3bbfb3fb5d25776b8e3f361d2eedaabb0b496cd
> > > x86: Introduce __uaccess_begin_nospec() and uaccess_try_nospec
> > > in scope.
> > >
> > > That one doesn't seem to be tagged for stable. Was it queued
> > > there in practice?
> > 
> > not marked for stable but it went in. At least to 4.4.
> 
> So I guess the answer is I don't know. If you feel it's
> justified, then sure, feel free to forward.

Well, that obviously depends on you as a maintainer but the point is
that spectre gatgets are quite hard to find. There is a smack check
AFAIK but that generates quite some false possitives and it is PITA to
crawl through those. If you want an interesting (I am not saying
vulnerable on purpose) gatget then it would be great to mark it for
stable so all stable consumers (disclaimer: I am not one of those) and
add that really great feeling of safety ;)

So take this as my 2c
-- 
Michal Hocko
SUSE Labs
