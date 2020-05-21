Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B3E1DD92E
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730653AbgEUVLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:11:39 -0400
Received: from mga03.intel.com ([134.134.136.65]:10733 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730281AbgEUVLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 17:11:39 -0400
IronPort-SDR: PGkmwM+dAtlRrTlmBqGWLy58a6dvZ4HGMwttHfWuTeZTW8ad3+MLEXQO49sMf4ywTe0cafkOs+
 o6+Q44gXIJYA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 14:11:37 -0700
IronPort-SDR: Jh1v7HKAfd8jKy0bHCeNMafKLcMp4AGbqdqHdwPNNsNZOFTvDSOxv+GfMGhcezD2Euzm1q/Uo2
 Dx1JkYJvz1hQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,419,1583222400"; 
   d="scan'208";a="255416085"
Received: from dclifton-mobl.amr.corp.intel.com ([10.251.134.247])
  by fmsmga008.fm.intel.com with ESMTP; 21 May 2020 14:11:37 -0700
Message-ID: <08fa562783e8a47f857d7f96859ab3617c47e81c.camel@linux.intel.com>
Subject: Re: [net-next v4 10/12] ASoC: SOF: Introduce descriptors for SOF
 client
From:   Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     davem@davemloft.net, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Date:   Thu, 21 May 2020 14:11:37 -0700
In-Reply-To: <20200520125437.GH31189@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
         <20200520070227.3392100-11-jeffrey.t.kirsher@intel.com>
         <20200520125437.GH31189@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-05-20 at 09:54 -0300, Jason Gunthorpe wrote:
> On Wed, May 20, 2020 at 12:02:25AM -0700, Jeff Kirsher wrote:
> > From: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
> > 
> > A client in the SOF (Sound Open Firmware) context is a
> > device that needs to communicate with the DSP via IPC
> > messages. The SOF core is responsible for serializing the
> > IPC messages to the DSP from the different clients. One
> > example of an SOF client would be an IPC test client that
> > floods the DSP with test IPC messages to validate if the
> > serialization works as expected. Multi-client support will
> > also add the ability to split the existing audio cards
> > into multiple ones, so as to e.g. to deal with HDMI with a
> > dedicated client instead of adding HDMI to all cards.
> > 
> > This patch introduces descriptors for SOF client driver
> > and SOF client device along with APIs for registering
> > and unregistering a SOF client driver, sending IPCs from
> > a client device and accessing the SOF core debugfs root entry.
> > 
> > Along with this, add a couple of new members to struct
> > snd_sof_dev that will be used for maintaining the list of
> > clients.
> 
> If you want to use sound as the rational for virtual bus then drop
> the
> networking stuff and present a complete device/driver pairing based
> on
> this sound stuff instead.
> 
> > +int sof_client_dev_register(struct snd_sof_dev *sdev,
> > +			    const char *name)
> > +{
> > +	struct sof_client_dev *cdev;
> > +	struct virtbus_device *vdev;
> > +	unsigned long time, timeout;
> > +	int ret;
> > +
> > +	cdev = kzalloc(sizeof(*cdev), GFP_KERNEL);
> > +	if (!cdev)
> > +		return -ENOMEM;
> > +
> > +	cdev->sdev = sdev;
> > +	init_completion(&cdev->probe_complete);
> > +	vdev = &cdev->vdev;
> > +	vdev->match_name = name;
> > +	vdev->dev.parent = sdev->dev;
> > +	vdev->release = sof_client_virtdev_release;
> > +
> > +	/*
> > +	 * Register virtbus device for the client.
> > +	 * The error path in virtbus_register_device() calls
> > put_device(),
> > +	 * which will free cdev in the release callback.
> > +	 */
> > +	ret = virtbus_register_device(vdev);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	/* make sure the probe is complete before updating client list
> > */
> > +	timeout = msecs_to_jiffies(SOF_CLIENT_PROBE_TIMEOUT_MS);
> > +	time = wait_for_completion_timeout(&cdev->probe_complete,
> > timeout);
> 
> This seems bonkers - the whole point of something like virtual bus is
> to avoid madness like this.

Thanks for your review, Jason. The idea of the times wait here is to
make the registration of the virtbus devices synchronous so that the
SOF core device has knowledge of all the clients that have been able to
probe successfully. This part is domain-specific and it works very well
in the audio driver case.

Could you please elaborate on why you think this is a bad idea?

Thanks,
Ranjani

