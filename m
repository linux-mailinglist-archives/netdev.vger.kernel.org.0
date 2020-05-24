Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 545151DFD73
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 08:35:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbgEXGfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 02:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:32818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726796AbgEXGfX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 02:35:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CE332070A;
        Sun, 24 May 2020 06:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590302122;
        bh=54TMJgyWckMIDQqATxCvcueAykL3W0OIRCLEOdihgYI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZMRji7+RCT3DuFbVUBrE/kDbTKGx5eqqpkvR7fQZ495PAmkjnMmpCNxMuMsWzvAVH
         bSnKKmfFUywzudIoJoe+9fIRQ9ctHSYAvZMexuH7oYpbjnUhO/9tn870Jmb+7Wj2fW
         sS+8loDk6LxMn+YU5AQRUhaTB7AnWp0X3HtZ1Qtg=
Date:   Sun, 24 May 2020 08:35:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
Message-ID: <20200524063519.GB1369260@kroah.com>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
 <20200520125437.GH31189@ziepe.ca>
 <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
 <20200521233437.GF17583@ziepe.ca>
 <7abfbda8-2b4b-5301-6a86-1696d4898525@linux.intel.com>
 <20200523062351.GD3156699@kroah.com>
 <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57185aae-e1c9-4380-7801-234a13deebae@linux.intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 23, 2020 at 02:41:51PM -0500, Pierre-Louis Bossart wrote:
> 
> 
> On 5/23/20 1:23 AM, Greg KH wrote:
> > On Fri, May 22, 2020 at 09:29:57AM -0500, Pierre-Louis Bossart wrote:
> > > This is not an hypothetical case, we've had this recurring problem when a
> > > PCI device creates an audio card represented as a platform device. When the
> > > card registration fails, typically due to configuration issues, the PCI
> > > probe still completes.
> > 
> > Then fix that problem there.  The audio card should not be being created
> > as a platform device, as that is not what it is.  And even if it was,
> > the probe should not complete, it should clean up after itself and error
> > out.
> 
> Did you mean 'the PCI probe should not complete and error out'?

Yes.

> If yes, that's yet another problem... During the PCI probe, we start a
> workqueue and return success to avoid blocking everything.

That's crazy.

> And only 'later' do we actually create the card. So that's two levels
> of probe that cannot report a failure. I didn't come up with this
> design, IIRC this is due to audio-DRM dependencies and it's been used
> for 10+ years.

Then if the probe function fails, it needs to unwind everything itself
and unregister the device with the PCI subsystem so that things work
properly.  If it does not do that today, that's a bug.

What kind of crazy dependencies cause this type of "requirement"?

thanks,

greg k-h
