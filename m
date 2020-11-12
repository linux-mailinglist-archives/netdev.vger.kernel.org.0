Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E7F2B06F8
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728438AbgKLNtz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbgKLNty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:49:54 -0500
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BD2C0617A6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:49:54 -0800 (PST)
Received: by mail-qk1-x741.google.com with SMTP id q5so5191658qkc.12
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Eg/RjAIZKwAbJrMIrbrRdkEGP27Yqte35m8OKOzH3B0=;
        b=DFRG3uh9srwcvUG7AdAKgEet8jCSEWusYDlt6asbzD4TH5DL8lm0dKKLsXZo8GP/4o
         wU0LGFXeuWEW69E84n+bIq8bGLGlLjQh3+eGLwy6oP3y3diCtIWd8zpxDSimsbsyr0IM
         XFAG8hVgEFl05eBB1QyvHVgYsT/oKCkSq+9zLxaFcPaqCws3GrQVhhL9m5rsmKUh2WYH
         tPkASd42zRcx92wm3BYYOdMpcfieGKGfPss/D0c/wN0Lbx19RlRuYXYzoZBBG/+fXESq
         Q41k0dGYyCE1NVDPuMUyDA5huljco1w0nO0MH4KnL0AwzlJRzX4Fp969BkIs/2SpZct9
         WRpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Eg/RjAIZKwAbJrMIrbrRdkEGP27Yqte35m8OKOzH3B0=;
        b=gwRoyZFwWKmSKu9BupNXybyi7l9yHbApH7K4Fg/Brx6iTt4OE9W7PerIFduuILWxw8
         pchqKUXRQxi+yU2FV7N/aqA6/ru75i+g+KVmNrxIcPnWsy6K1+SCIU9c304D3QMNj5n9
         bwomuhtirCBaXmDPglYzRNrEJ1/BM1u+72dzux5sislRTkfm6JsDT7EMaEv/R5udtu3o
         q8Ah6eMqEqxnJ6Yjxq1gNaoVohnsZI4Lw4YIuI77K5ruyzZg4KmCa2hmTGrqOTvhdX+G
         ++mKJmiLIXH++V2NNhPn4sKc2IMiO5StWzdCA0gNuLbC7zlnA5zrY/XevdZ/6cswet+2
         DjsA==
X-Gm-Message-State: AOAM533t2m5Ug9ntRV6jAInjV8yJIY62EFcP8XGa8z3U5USboyTDZ1m7
        +Y7e2eRkFRWPCv12mNk/hojexQ==
X-Google-Smtp-Source: ABdhPJyiG+AWMVllInSFkDTazT0TjS77XHNnGJMdZGOKj8oXGaskcS+Y2DphXPV4+iJ0BQ/4jmIc5w==
X-Received: by 2002:a05:620a:1539:: with SMTP id n25mr15856223qkk.258.1605188993531;
        Thu, 12 Nov 2020 05:49:53 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id k11sm4930974qtu.45.2020.11.12.05.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:49:52 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kdCz2-003gor-0U; Thu, 12 Nov 2020 09:49:52 -0400
Date:   Thu, 12 Nov 2020 09:49:52 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Doug Ledford <dledford@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        David Miller <davem@davemloft.net>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Igor Mitsyanko <imitsyanko@quantenna.com>,
        Sergey Matyukevich <geomatsi@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Oliver Neukum <oneukum@suse.com>,
        Peter Korsgaard <jacmet@sunsite.dk>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] IB/hfi1: switch to core handling of rx/tx
 byte/packet counters
Message-ID: <20201112134952.GS244516@ziepe.ca>
References: <5fbe3a1f-6625-eadc-b1c9-f76f78debb94@gmail.com>
 <5093239e-2d3b-a716-3039-790abdb7a5ba@gmail.com>
 <20201111090355.63fe3898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201111090355.63fe3898@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 11, 2020 at 09:03:55AM -0800, Jakub Kicinski wrote:
> On Tue, 10 Nov 2020 20:47:34 +0100 Heiner Kallweit wrote:
> > Use netdev->tstats instead of a member of hfi1_ipoib_dev_priv for storing
> > a pointer to the per-cpu counters. This allows us to use core
> > functionality for statistics handling.
> > 
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> RDMA folks, ack for merging via net-next?

Yes OK

Ack-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
