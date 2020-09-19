Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45EB6271030
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 21:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726653AbgISTWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 15:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726528AbgISTWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Sep 2020 15:22:38 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB28C0613D0
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 12:22:38 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f142so10514328qke.13
        for <netdev@vger.kernel.org>; Sat, 19 Sep 2020 12:22:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IfjJMShMAYEFKN5YLXC6yZVzsTKuAmJMrDmWZpivwoY=;
        b=Tx7WEG+h7F8CDjBu/jlOiysl3JQczwwLMYKLACitzc0UuMfh/mFPRT69zR9TY7H7Y8
         nRAsWx6u92MdLzYVKoSx5YIx4mt2rFOhQDzMPgq8dyo85LutFSqYJPxlyMr370qVWQPh
         H9FeOWLwKF4zY4yKCuV+VGlC11W6EsuvkqvRVvXLEIkJO+TPJe+zoiNQjaGzFOpY/2Pv
         0N2qI5aTyiz4H09KoLRv5WBBGvKV0pGaUI32g5Xey8ZEe9I9PREMEmdZyHtniJQlMHhM
         vMq3MaatsAiEqhudJATetXS0Osaw8bIme03wLXpLmlJHKa+tt0fWG+C8mmjNMTlYaN/O
         IogA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IfjJMShMAYEFKN5YLXC6yZVzsTKuAmJMrDmWZpivwoY=;
        b=F0GfBLtBU6Vq1mSqIg98Fbs35r2E/jh2RdKSBT8xSznJtCbSjUaLmAEvRwHcuOIPv3
         RlqvtVEuGjzxNjd4vfKh9IyBG+gb+lTqpum4XG/kRzNZHxLXYEKrkRKBAXUtgscoKbQY
         7UtyTi5gvUdazpZ9OVn4zv85vWuWya+BGFCcNg8Q91yL367WONRCgWgAiEtOg71rkuSx
         1oqslqWVQKz35k8E4f2eQMqTHu4LN0g4RUCgxq9bgrIIlfsbQFVXvSs5pyMzwutTeBfm
         4hs3Ne3PsDf08NSCxoziDg1DxRaXP2MZDOTgxqYbvkfgQxQsyvHMiCtBGXEGyPCWudcL
         6wQg==
X-Gm-Message-State: AOAM531rOgpkcAJg+SPDkMDFwXRgFy04fhm+pYfYiJopcOKFhr4e5Bwo
        aWup+SLMAD4Q7XHCylLJ002CdA==
X-Google-Smtp-Source: ABdhPJxk5odPvPQ8xzh4HdByt+rV02OFXI2X/xCfsTAiUmLUSkpZ3MTa9p4Iad69Vfo49XEZDj73Cw==
X-Received: by 2002:a37:9bd8:: with SMTP id d207mr41437784qke.100.1600543356975;
        Sat, 19 Sep 2020 12:22:36 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id b43sm5299375qtk.84.2020.09.19.12.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2020 12:22:36 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1kJiRP-0027Dz-Nf; Sat, 19 Sep 2020 16:22:35 -0300
Date:   Sat, 19 Sep 2020 16:22:35 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Oded Gabbay <oded.gabbay@gmail.com>,
        Leon Romanovsky <leon@kernel.org>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200919192235.GB8409@ziepe.ca>
References: <20200918115227.GR869610@unreal>
 <CAFCwf10C1zm91e=tqPVGOX8kZD7o=AR2EW-P9VwCF4rcvnEJnA@mail.gmail.com>
 <20200918120340.GT869610@unreal>
 <CAFCwf12VPuyGFqFJK5D19zcKFQJ=fmzjwscdPG82tfR_v_h3Kg@mail.gmail.com>
 <20200918121905.GU869610@unreal>
 <20200919064020.GC439518@kroah.com>
 <20200919082003.GW869610@unreal>
 <20200919083012.GA465680@kroah.com>
 <CAFCwf122V-ep44Kqk1DgRJN+tq3ctxE9uVbqYL07apLkLe2Z7g@mail.gmail.com>
 <20200919172730.GC2733595@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919172730.GC2733595@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 07:27:30PM +0200, Greg Kroah-Hartman wrote:
> > It's probably heresy, but why do I need to integrate into the RDMA subsystem ?
> > I understand your reasoning about networking (Ethernet) as the driver
> > connects to the kernel networking stack (netdev), but with RDMA the
> > driver doesn't use or connect to anything in that stack. If I were to
> > support IBverbs and declare that I support it, then of course I would
> > need to integrate to the RDMA subsystem and add my backend to
> > rdma-core.
> 
> IBverbs are horrid and I would not wish them on anyone.  Seriously.

I'm curious what drives this opinion? Did you have it since you
reviewed the initial submission all those years ago?

> I think the general rdma apis are the key here, not the userspace api.

Are you proposing that habana should have uAPI in drivers/misc and
present a standard rdma-core userspace for it? This is the only
userspace programming interface for RoCE HW. I think that would be
much more work.

If not, what open source userspace are you going to ask them to
present to merge the kernel side into misc?

> Note, I do not know exactly what they are, but no, IBverbs are not ok.

Should we stop merging new drivers and abandon the RDMA subsystem? Is
there something you'd like to see fixed?

Don't really understand your position, sorry.

Jason
