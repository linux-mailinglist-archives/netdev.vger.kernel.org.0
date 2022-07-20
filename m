Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EB357C103
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 01:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbiGTXmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 19:42:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGTXmo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 19:42:44 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE74459B4
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:42:43 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id h22so191303qta.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 16:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JTN7ZVeOnWslme/nIGUbcXBER65BIf1xxrYu80x7ubE=;
        b=Yfh0pa/N7ehhSiwja7yJnnJMyukG0R/vB6XStRTqHrVpbF+3YITqkrmgNGVAeyIMGe
         ECCKcMWPzGH94J46v4Zv5zmkDtzgkxPqtcbtauAt8m2HhBsbPVVOQ9PWhC8SiUCiEygV
         CjeJgfsLTnQvyntGlsqBwFQm3dt+A06+rvTlsVzv81Fwc8emJK+8O1ztUbcR4Wyloga3
         nlXWCqeSPqW9DCEgBgJe4uRHr5uIqf2tB4Nnqsaw1w6DrEWgQ265/dLzKj3VFHvCVZ6o
         lYijgD1NFWnkBE4CFyOajvvykfqM8JGHkLP0lkqm67EduJV3QxXnvW8R4EHFWwNZ30gx
         6GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JTN7ZVeOnWslme/nIGUbcXBER65BIf1xxrYu80x7ubE=;
        b=gjMTUrhnrCWXDFM1jjSpuTgUAOcsvQPP7BkscGnWAynXNXY7GFDvsKlC7GQTtFF3LD
         1HjODTkF5CNpNcM73f4W4UBJi67UoULfmXfw/v9p2tMBAZMHlChR6lSDa+pZQeJqFLo6
         rfYpWuWu27aldxLTA6bMnk/xWJ0pmnMb2pw9duD3sSlC8ZiIHaMN1Eg6ExQpj3J9L65t
         0PA7+n3RiobHuMlXys3eX96SkSwike5hbv9CvzYbfIM7qjfdwlgfxPp5sMTMaxbgy/XY
         tqb0qLD5TH1FbLLuDAGTB0+yUy4eqeAMnqiwUa1HHXbed633NFWgy7bPxsHeu2nt0h4M
         aFHg==
X-Gm-Message-State: AJIora9kPKLbm2sc92jwa9KxYI57SaiI0ZyDp4N96onYzGFBrh4A9RGY
        8q5YvW7l2r2v3Di3RBTnFM/cPA==
X-Google-Smtp-Source: AGRyM1vtp/fQoKLD3PgZV9bGCP5LOjKOGCqxWeGYBEQtEMgSHxp9RaFbqImuOdRl8cdkXl+HjV+lKw==
X-Received: by 2002:a05:622a:d5:b0:31e:eb65:e832 with SMTP id p21-20020a05622a00d500b0031eeb65e832mr15441277qtw.92.1658360562890;
        Wed, 20 Jul 2022 16:42:42 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id f5-20020ac859c5000000b0031eef540614sm354168qtf.51.2022.07.20.16.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 16:42:42 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1oEJKz-001hjm-Q7; Wed, 20 Jul 2022 20:42:41 -0300
Date:   Wed, 20 Jul 2022 20:42:41 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Long Li <longli@microsoft.com>, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [Patch v4 04/12] net: mana: Add functions for allocating
 doorbell page from GDMA
Message-ID: <20220720234241.GQ5049@ziepe.ca>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
 <1655345240-26411-5-git-send-email-longli@linuxonhyperv.com>
 <SN6PR2101MB13270BC0DF7A9FA17582822FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR2101MB13270BC0DF7A9FA17582822FBF879@SN6PR2101MB1327.namprd21.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 11, 2022 at 01:13:50AM +0000, Dexuan Cui wrote:
> > From: longli@linuxonhyperv.com <longli@linuxonhyperv.com>
> > Sent: Wednesday, June 15, 2022 7:07 PM
> > ...
> > +EXPORT_SYMBOL(mana_gd_destroy_doorbell_page);
> Can this be EXPORT_SYMBOL_GPL?
> 
> > +EXPORT_SYMBOL(mana_gd_allocate_doorbell_page);
> EXPORT_SYMBOL_GPL?

Can you think about using the symbol namespaces here?

Nobody else has done it yet, but I think we should be...

Jason
