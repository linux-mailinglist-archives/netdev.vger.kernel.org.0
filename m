Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91759462EF
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 17:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfFNPfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 11:35:00 -0400
Received: from verein.lst.de ([213.95.11.211]:47942 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725780AbfFNPfA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 11:35:00 -0400
Received: by newverein.lst.de (Postfix, from userid 2407)
        id DF91968AFE; Fri, 14 Jun 2019 17:34:28 +0200 (CEST)
Date:   Fri, 14 Jun 2019 17:34:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Sean Paul <sean@poorly.run>, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        devel@driverdev.osuosl.org, linux-s390@vger.kernel.org,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        intel-gfx@lists.freedesktop.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-mm@kvack.org, iommu@lists.linux-foundation.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 12/16] staging/comedi: mark as broken
Message-ID: <20190614153428.GA10008@lst.de>
References: <20190614134726.3827-1-hch@lst.de> <20190614134726.3827-13-hch@lst.de> <20190614140239.GA7234@kroah.com> <20190614144857.GA9088@lst.de> <20190614153032.GD18049@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614153032.GD18049@kroah.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 05:30:32PM +0200, Greg KH wrote:
> On Fri, Jun 14, 2019 at 04:48:57PM +0200, Christoph Hellwig wrote:
> > On Fri, Jun 14, 2019 at 04:02:39PM +0200, Greg KH wrote:
> > > Perhaps a hint as to how we can fix this up?  This is the first time
> > > I've heard of the comedi code not handling dma properly.
> > 
> > It can be fixed by:
> > 
> >  a) never calling virt_to_page (or vmalloc_to_page for that matter)
> >     on dma allocation
> >  b) never remapping dma allocation with conflicting cache modes
> >     (no remapping should be doable after a) anyway).
> 
> Ok, fair enough, have any pointers of drivers/core code that does this
> correctly?  I can put it on my todo list, but might take a week or so...

Just about everyone else.  They just need to remove the vmap and
either do one large allocation, or live with the fact that they need
helpers to access multiple array elements instead of one net vmap,
which most of the users already seem to do anyway, with just a few
using the vmap (which might explain why we didn't see blowups yet).
