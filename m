Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF89320BF1C
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbgF0HCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:02:39 -0400
Received: from verein.lst.de ([213.95.11.211]:53802 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgF0HCj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 03:02:39 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9E9AF68B02; Sat, 27 Jun 2020 09:02:36 +0200 (CEST)
Date:   Sat, 27 Jun 2020 09:02:36 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: the XSK buffer pool needs be to reverted
Message-ID: <20200627070236.GA11854@lst.de>
References: <20200626074725.GA21790@lst.de> <20200626205412.xfe4lywdbmh3kmri@bsd-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626205412.xfe4lywdbmh3kmri@bsd-mbp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 01:54:12PM -0700, Jonathan Lemon wrote:
> On Fri, Jun 26, 2020 at 09:47:25AM +0200, Christoph Hellwig wrote:
> >
> > Note that this is somewhat urgent, as various of the APIs that the code
> > is abusing are slated to go away for Linux 5.9, so this addition comes
> > at a really bad time.
> 
> Could you elaborate on what is upcoming here?

Moving all these calls out of line, and adding a bypass flag to avoid
the indirect function call for IOMMUs in direct mapped mode.

> Also, on a semi-related note, are there limitations on how many pages
> can be left mapped by the iommu?  Some of the page pool work involves
> leaving the pages mapped instead of constantly mapping/unmapping them.

There are, but I think for all modern IOMMUs they are so big that they
don't matter.  Maintaines of the individual IOMMU drivers might know
more.

> On a heavily loaded box with iommu enabled, it seems that quite often
> there is contention on the iova_lock.  Are there known issues in this
> area?

I'll have to defer to the IOMMU maintainers, and for that you'll need
to say what code you are using.  Current mainlaine doesn't even have
an iova_lock anywhere.
