Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A57DC1E521B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 02:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725267AbgE1AMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 20:12:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgE1AMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 20:12:14 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC16DC03E96E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:12:12 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id h3so3387167ilh.13
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 17:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EZ5OmQ9S/j0BkOm/hjMRMHbK3BDLmC+jsiwSGq9LQNU=;
        b=oO2rCFM7/qw/eQTVVG9GExo0Z6RYjNx7a76i1zWd2FkIrFbjDyNJyAXD79lQjIWcpW
         e4Gc57aBPNKabVXMWuXD4oK5Ne92lfpSrq8GAzpXAj21ZhlxkeX07lkuozNIp0X3HWyF
         dvPPQ3Jtu4R/+6NlTf/Ylr6eZ4w1FL102ZU5Kd4YI//3jD6kzfSxf2/FVxZ826aKypH/
         iWGAaj/1hBbS6DPmYXUj+nseq0m2xleLOY9vxncstz3SNaWGTkFuovdh+F4P3JD0TsZ0
         +/nMJC+40DfVgH74P2XQJ27IvoJjLIRXBvukJa8solRxXZcvkZowp2OC8k8QNrWnvdJA
         HTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=EZ5OmQ9S/j0BkOm/hjMRMHbK3BDLmC+jsiwSGq9LQNU=;
        b=kBNktU8dq6085CUX1bRfr0pgcpA587q9cimPQojg12kcdrVKzAvJreauFqEWJyKYzU
         up+kGy0KSScpjCgA5oxxSPX5DuGFFp5tds9ZDpeNroHOMl8wYCBE/iEqQUjuEpqaHbY/
         uMd43NjgCqpNWAeGjcm5hAWY+uZTul+D9uLoqPtaW2CYuZG1bUECIseMf9CgYufRVn9w
         +zGRKXDdehahDpeEcvuAe42mybfgaWdVlSj1uotZQbDo3ihV+8XfDAAwwZLOPDf9sTcC
         ttnE5rp5WqMYSQg90EnvHGmRWJfl8UiWY7HEkGFewjxcdhdRQsaBkcZnlZM5A9oU5cV+
         yhkw==
X-Gm-Message-State: AOAM53350jEPSKOICbkmxqX4Le76j3k+bRXcp7QZfP82lQ1k8VKfO92Y
        9ICqiWAsjdLt8qvNpdTrWs4mvQ==
X-Google-Smtp-Source: ABdhPJwxIa+iF7NOAA4V1wZCknoI9q3H8HjHrA2YalnS7KpcAeI/d9JitBKZvF+qN7yytR2qGcxPCA==
X-Received: by 2002:a05:6e02:13e2:: with SMTP id w2mr762029ilj.264.1590624732091;
        Wed, 27 May 2020 17:12:12 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id s71sm2392688ilc.32.2020.05.27.17.12.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 27 May 2020 17:12:08 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1je69X-0002vd-Nz; Wed, 27 May 2020 21:12:07 -0300
Date:   Wed, 27 May 2020 21:12:07 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, pierre-louis.bossart@linux.intel.com,
        Fred Oh <fred.oh@linux.intel.com>
Subject: Re: [net-next v4 11/12] ASoC: SOF: Create client driver for IPC test
Message-ID: <20200528001207.GR744@ziepe.ca>
References: <20200520070227.3392100-1-jeffrey.t.kirsher@intel.com>
 <20200520070227.3392100-12-jeffrey.t.kirsher@intel.com>
 <20200520125611.GI31189@ziepe.ca>
 <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b51ee1d61dbfbb8914d29338918ba49bff1b4b75.camel@linux.intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 01:18:35PM -0700, Ranjani Sridharan wrote:
> On Wed, 2020-05-20 at 09:56 -0300, Jason Gunthorpe wrote:
> > On Wed, May 20, 2020 at 12:02:26AM -0700, Jeff Kirsher wrote:
> > > +static const struct virtbus_dev_id sof_ipc_virtbus_id_table[] = {
> > > +	{"sof-ipc-test"},
> > > +	{},
> > > +};
> > > +
> > > +static struct sof_client_drv sof_ipc_test_client_drv = {
> > > +	.name = "sof-ipc-test-client-drv",
> > > +	.type = SOF_CLIENT_IPC,
> > > +	.virtbus_drv = {
> > > +		.driver = {
> > > +			.name = "sof-ipc-test-virtbus-drv",
> > > +		},
> > > +		.id_table = sof_ipc_virtbus_id_table,
> > > +		.probe = sof_ipc_test_probe,
> > > +		.remove = sof_ipc_test_remove,
> > > +		.shutdown = sof_ipc_test_shutdown,
> > > +	},
> > > +};
> > > +
> > > +module_sof_client_driver(sof_ipc_test_client_drv);
> > > +
> > > +MODULE_DESCRIPTION("SOF IPC Test Client Driver");
> > > +MODULE_LICENSE("GPL v2");
> > > +MODULE_IMPORT_NS(SND_SOC_SOF_CLIENT);
> > > +MODULE_ALIAS("virtbus:sof-ipc-test");
> > 
> > Usually the MODULE_ALIAS happens automatically rhough the struct
> > virtbus_dev_id - is something missing in the enabling patches?
> Hi Jason,
> 
> Without the MODULE_ALIAS,  the driver never probes when the virtual bus
> device is registered. The MODULE_ALIAS is not different from the ones
> we typically have in the platform drivers. Could you please give me
> some pointers on what you think might be missing?

Look at how the stuff in include/linux/mod_devicetable.h works and do
the same for virtbus

Looks like you push a MODALIAS= uevent when creating the device and
the generic machinery does the rest based on the matching table, once
mod_devicetable.h and related is updated. But it has been a long time
since I looked at this..

Jason
