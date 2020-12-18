Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3B82DEA0E
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 21:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgLRUOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 15:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgLRUOv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 15:14:51 -0500
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246D5C0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:14:11 -0800 (PST)
Received: by mail-qv1-xf2a.google.com with SMTP id d11so1486144qvo.11
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 12:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+6dOcXCZmIRThv69enwRAoT3Ssvc0OhfvILN9vdlg4o=;
        b=jHvWhOqW9gjdg6bCt0oq8HPNAPiqjsnvVkc2ZUdCGpEZNIdSLT+GDPCECJElwUYAxA
         Y1pIExXfv/DBr7VTF+bFuxD1/qc48sp4jjZGVoGH32YbTQAwsodVlyqEal+TFhSvUReR
         bQH7LL5BN51mLTZ7XWLywXYOanGqutzAK76tB+8PuUq+RbgeAnOhwHP+K4O7eHiCyJ6Z
         PbkZyuovTuop9ttweKxiab8tuHcdQfnii8DrxMLWuGsSk2o7ieWZHMk1nqidqmHDP5kd
         mRvodxQKAx0bRwGOtG28y4RrryymGsGvvkNhr00Frg6N6/bpTYHvKS3sn6joFWSellTo
         IV4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+6dOcXCZmIRThv69enwRAoT3Ssvc0OhfvILN9vdlg4o=;
        b=jxnMlSR28nUaW7LBSz6Dv0P7tJ49UmmjDjtfhjAbth4+03YH/pBewK0LR1pESbVnVo
         JEKE+GscJTQJ82PLC4niHhrFuurk13T5izZPvLxBVag4PtKJ066IZQsonn7UdpDySVDA
         iSZk5oa61hc1fHhTyUramsyjhXM5ea6b6CbKGxgQerKrZoVgg049Jj8+msa0oo3sEuLx
         YrS+eM6H/U5v92MO44mHTmmWWKY6ndCHfzN7SH6/vpXSvK18NwsrwcoKIPdBBkjsdQxN
         nvfIIpoU+8DBPjTsWIs7etOPA4TDOeNr3cvMh9tQe42v8xi3J+rugGDP8Pue6a1p/1Qi
         +W2Q==
X-Gm-Message-State: AOAM531+xHwPHjaXW03FJ/WJB6fuSg+PsHidC6pzMIgUP1fhUeuf5EPf
        rMhXIufrXh+aJLdN+DFdB0FGrA==
X-Google-Smtp-Source: ABdhPJz7x65BC/4X9IrtWfhOoatGUO93t2Fz3LqYQnC1yk/9wcYLKCu/MCpGx2+lmEtdYxTq7GxBsw==
X-Received: by 2002:a05:6214:15c1:: with SMTP id p1mr6432035qvz.8.1608322450319;
        Fri, 18 Dec 2020 12:14:10 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id p15sm6479556qke.11.2020.12.18.12.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 12:14:09 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kqM8e-00CtcB-SK; Fri, 18 Dec 2020 16:14:08 -0400
Date:   Fri, 18 Dec 2020 16:14:08 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Mark Brown <broonie@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        alsa-devel@alsa-project.org, Kiran Patil <kiran.patil@intel.com>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Martin Habets <mhabets@solarflare.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Message-ID: <20201218201408.GP5487@ziepe.ca>
References: <X8usiKhLCU3PGL9J@kroah.com>
 <20201217211937.GA3177478@piout.net>
 <X9xV+8Mujo4dhfU4@kroah.com>
 <20201218131709.GA5333@sirena.org.uk>
 <20201218140854.GW552508@nvidia.com>
 <20201218155204.GC5333@sirena.org.uk>
 <20201218162817.GX552508@nvidia.com>
 <20201218180310.GD5333@sirena.org.uk>
 <20201218184150.GY552508@nvidia.com>
 <20201218190911.GT207743@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201218190911.GT207743@dell>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 18, 2020 at 07:09:11PM +0000, Lee Jones wrote:

> ACPI, DT and MFD are not busses.  

And yet ACPI and PNP have a bus:
  extern struct bus_type acpi_bus_type;
  extern struct bus_type pnp_bus_type;

Why? Because in the driver core if you subclass struct device and want
to bind drivers, as both PNP and ACPI do, you must place those devices
on a bus with a bus_type matching the device type. Thus subclassing
the device means subclassing the bus as well.

The purpose of the bus_type is to match drivers to devices and provide
methods to the driver core. The bus_type also defines the unique name
space of the device names.

It is confusing because the word bus immediately makes people think of
physical objects like I2C, PCI, etc, but that is not what bus_type
does in the object model of the driver core, IMHO.

So, if you subclass struct device for MFD's usage, then you must also
create a bus_type to handle driver binding. The MFD bus_type. Just
like auxillary does.

Making a mfd subclass is the logical thing for a subsystem to do,
co-opting another subsystem's bus_type is just really weird/abusive.

auxillary bus shows how all these parts work, and it is simple enough
to see the pieces clearly.

Jason
