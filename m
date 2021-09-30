Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B34D41DCA8
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 16:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351492AbhI3Oti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 10:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351324AbhI3Oth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 10:49:37 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A723C06176E
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 07:47:55 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id x9so5959714qtv.0
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 07:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YC0+VwHZzPhl2SPrhh657f3U1hNtJ/JCUlCIJ6KQy3I=;
        b=ndkH5/wAJI5PynIxh8c+p/oo88o+89k9dDxUk0xgxTZH1LvmZlzhjwAYV5yYXxu8Tc
         wF0b1+mqCRPb2q/JGI46tYxrDNiGY50UHsbAp5ybEiNhAuSCVrmbCFYYSTF+YVA8Lb2i
         RNC/uWCyRsbHh0WfFsp84BG+2eUZ0pgHc0H8uL178Bhd1gBDUAbbajQcamvMX3huzkUD
         aP3v1hLmRwUuPgKE94SsoEjkOam5Mg8f9HC89RAr5ESag+i9r4c94bS7FXpNtvDim4as
         8ms8GAC7MnYNcuMW2hEhBxMcUSv7rCxsoOFh2C5HKiwIQWURyNdZOC0/nLAg+p3J0aKU
         8iBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YC0+VwHZzPhl2SPrhh657f3U1hNtJ/JCUlCIJ6KQy3I=;
        b=bfFAer4Uitq6+2d4ne+shETpSDLHdP6PCU5KTEzZ2Wgslik5Omsf4o2xBwTe9n7pkF
         XkL5ILBrALH77P8aHd0Mr9a1cGv0OE1cci7z2stBV0p8ryOT21nbRciMQ2iyhsCQdgmi
         Vsf65h1nd4gf816oFKLirny+8RqfoD4aqsMlWZqFjiPqr1wNsAWzv8eZHnbsyuW+iLv3
         ail4BrkuKc7ZdUfEHP0tmVdayhc3m55IszMs5s+Y3f8vRTbfmKKtDCKrg+HDsCG1Xvg/
         AAzit/CaF3y/sg9ZyMplN0AimroyH+rUq2v2pmewBqaklWAhov1htLGR4Mz3MRHLGwWo
         PBmQ==
X-Gm-Message-State: AOAM530PQU2yVB/CesbTgp16n0YIVUgiodLSJkRsPhm1rcyIInn9uGgF
        MvdP3WI4b7sRd+Xm8zIHnx8uZQ==
X-Google-Smtp-Source: ABdhPJxpuImR9KBUcfzATGTbSy0hBfBvmQhVEZSB9uz66LdCIDV/x85f7S999tzTSOGxHvl1SPYIMQ==
X-Received: by 2002:ac8:6703:: with SMTP id e3mr6746279qtp.307.1633013274161;
        Thu, 30 Sep 2021 07:47:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id f10sm1691905qtm.15.2021.09.30.07.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 07:47:53 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mVxLk-000HbX-9P; Thu, 30 Sep 2021 11:47:52 -0300
Date:   Thu, 30 Sep 2021 11:47:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210930144752.GA67618@ziepe.ca>
References: <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
 <20210929232109.GC3544071@ziepe.ca>
 <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d8324d96-c897-b914-16c6-ad0bbb9b13a5@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:34:19PM +0300, Max Gurtovoy wrote:

> > When we add the migration extension this cannot change, so after
> > open_device() the device should be operational.
> 
> if it's waiting for incoming migration blob, it is not running.

It cannot be waiting for a migration blob after open_device, that is
not backwards compatible.

Just prior to open device the vfio pci layer will generate a FLR to
the function so we expect that post open_device has a fresh from reset
fully running device state.

> > The reported state in the migration region should accurately reflect
> > what the device is currently doing. If the device is operational then
> > it must report running, not stopped.
> 
> STOP in migration meaning.

As Alex and I have said several times STOP means the internal state is
not allowed to change.

> > driver will see RESUMING toggle off so it will trigger a
> > de-serialization
> 
> You mean stop serialization ?

No, I mean it will take all the migration data that has been uploaded
through the migration region and de-serialize it into active device
state.

> > driver will see SAVING toggled on so it will serialize the new state
> > (either the pre-copy state or the post-copy state dpending on the
> > running bit)
> 
> lets leave the bits and how you implement the state numbering aside.

You've missed the point. This isn't a FSM. It is a series of three
control bits that we have assigned logical meaning their combinatoins.

The algorithm I gave is a control centric algorithm not a state
centric algorithm and matches the direction Alex thought this was
being designed for.
 
> If you finish resuming you can move to a new state (that we should add) =>
> RESUMED.

It is not a state machine. Once you stop prentending this is
implementing a FSM Alex's position makes perfect sense.

Jason
