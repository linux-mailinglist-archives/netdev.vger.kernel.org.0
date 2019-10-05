Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45358CC86B
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 08:28:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726125AbfJEG2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 02:28:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfJEG2K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Oct 2019 02:28:10 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0211222BE;
        Sat,  5 Oct 2019 06:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570256889;
        bh=Fv7oDguoTz5ZkqeXjMvNuINSSxU92ogY5oisfQOHrCc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SQ/2TB40NQN5vm5zu9AD2kzoIN+sQQAogAxEdplietHBZoUfF2+sSKlCMfTkfkKfx
         uBCF1EGOamM454FiGgYPXULLxCSvxveP2j+JYE9mYZh4VpGSH5TfZILbFwPi9+/x2V
         QFV9xxmQSCBp6SWul2Yj2O33l8V1GRry6Fa8Rck0=
Date:   Sat, 5 Oct 2019 09:28:05 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Message-ID: <20191005062805.GP5855@unreal>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926173046.GB14368@unreal>
 <04e8a95837ba8f6a0b1d001dff2e905f5c6311b4.camel@intel.com>
 <20191004234519.GF13974@mellanox.com>
 <cd1712dc03721a01ac786ec878701a1823027434.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd1712dc03721a01ac786ec878701a1823027434.camel@intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 04, 2019 at 05:46:15PM -0700, Jeff Kirsher wrote:
> On Fri, 2019-10-04 at 23:45 +0000, Jason Gunthorpe wrote:
> > On Fri, Oct 04, 2019 at 01:12:22PM -0700, Jeff Kirsher wrote:
> >
> > > > > +	if (ldev->version.major != I40E_CLIENT_VERSION_MAJOR ||
> > > > > +	    ldev->version.minor != I40E_CLIENT_VERSION_MINOR) {
> > > > > +		pr_err("version mismatch:\n");
> > > > > +		pr_err("expected major ver %d, caller specified
> > > > > major
> > > > > ver %d\n",
> > > > > +		       I40E_CLIENT_VERSION_MAJOR, ldev-
> > > > > >version.major);
> > > > > +		pr_err("expected minor ver %d, caller specified
> > > > > minor
> > > > > ver %d\n",
> > > > > +		       I40E_CLIENT_VERSION_MINOR, ldev-
> > > > > >version.minor);
> > > > > +		return -EINVAL;
> > > > > +	}
> > > >
> > > > This is can't be in upstream code, we don't support out-of-tree
> > > > modules,
> > > > everything else will have proper versions.
> > >
> > > Who is the "we" in this context?
> >
> > Upstream sensibility - if we start doing stuff like this then we will
> > end up doing it everwhere.
>
> I see you cut out the part of my response about Linux distributions
> disagreeing with this stance.
>
> >
> > > you support out-of-tree drivers, they do exist and this code would
> > > ensure that if a "out-of-tree" driver is loaded, the driver will do a
> > > sanity check to ensure the RDMA driver will work.
> >
> > I don't see how this is any different from any of the other myriad of
> > problems out of tree modules face.
> >
> > Someone providing out of tree modules has to provide enough parts of
> > their driver so that it only consumes the stable ABI from the distro
> > kernel.
> >
> > Pretty normal stuff really.
>
> Your right, if the dependency was reversed and the out-of-tree (OOT) driver
> was dependent upon the RDMA driver, but in this case it is not.  The LAN
> driver does not "need" the RDMA driver to work.  So the RDMA driver should
> at least check that the LAN driver loaded has the required version to work.

Not in upstream code, there is an expectation that kernel and modules are aligned.

>
> This line of thinking, "marries" the in-kernel RDMA driver with the in-
> kernel LAN driver(s) so the end users and Linux distro's can not choose to
> upgrade or use any other driver than what comes with the kernel.  I totally
> agree that any out-of-tree (OOT) driver needs to make sure they have all
> kernel ABI's figured out for whatever kernel they are being installed on.
> But what is the problem with the in-kernel RDMA driver to do it's own
> checks to ensure the driver it is dependent upon meets its minimum
> requirements?

It is packaging problem to ensure that those minimum requirements are in
place.

>
> Similar checks are done in the Intel LAN driver to ensure the firmware is
> of a certain level, which is no different than what is being done here.

It doesn't say that it is correct way of doing things. FW is not part
of the kernel hence needs to be checked. Modules are different from
FW because they are part of the distributed kernel.

Thanks
