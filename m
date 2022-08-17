Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC56596C36
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbiHQJjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiHQJjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA596CD1B
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660729147;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uCWFnHQ16wzAyfLqhgH3u92LY8Ti6Pimk17aa5yv5fA=;
        b=dDJIW+mZTvGcBDYx7+Syk+zhJnWJKEcWdBULZzU3HnEhw3gqg+BSMGj6QnLlRCnXAl6As1
        VfT2/yntrhY2iZfMy2Ig0CrDVV+uny4lUFTM+fOdKIK1ox8iIEnXHEqxgeaZwKD5BtbRu9
        Lg2oJ9zwjYqH0M/x0N8gHAkOAg90PwA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-397-JwgA1tFPOEiIGUWYuBJxlg-1; Wed, 17 Aug 2022 05:39:06 -0400
X-MC-Unique: JwgA1tFPOEiIGUWYuBJxlg-1
Received: by mail-wr1-f72.google.com with SMTP id m2-20020adfc582000000b0021e28acded7so2284095wrg.13
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:39:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uCWFnHQ16wzAyfLqhgH3u92LY8Ti6Pimk17aa5yv5fA=;
        b=YS5ImZx3q6J+6aDnu0Yw602cDczEg3Fg6SkeaGSFoWd8XaMDbnTp5CoJoY6rNwJAA+
         CmR9Ab9GL77XrLioxgvVHORbIw5KuIWxjn0p94sesUxXPbJIorioPInFr4IXpTuiNemS
         XMO5CuNOrMPpajA66AsWGTewXTdQd5z1CC0Jm7uqxs20cnib7wN+6aGnmJ6yx7Qs6mGr
         LzmWuI2dod9/b3QovwE8nEFfCRdfnh7OfTsw1ytljFAJCl7F9vsoj2/f+dfoefTK7k7/
         +O3sbbAFY6jxsAK2Rv9fPirg6CKYCfay3LXqMyJxu1kInat5WAW0qNNOKl+boZg+VSaT
         QmRA==
X-Gm-Message-State: ACgBeo07jtXEhq87lihShdH2OMSIWOOzu9IG/qNK2JDIXFmLgfHOcKxT
        jKmlG5TXUD+mNg4r2D2876agBcWq/QHTvXLBa3OmvXJi6sLgVc04OcVEcUsij+3unM/dnKEtRdx
        fyjSjBrDy5egwjwEj
X-Received: by 2002:a05:600c:4f43:b0:3a6:16ca:8da4 with SMTP id m3-20020a05600c4f4300b003a616ca8da4mr1046870wmq.80.1660729145423;
        Wed, 17 Aug 2022 02:39:05 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4cPA7l/7H4bPIK6iO/7Zz25XZgkwFi9eBr3P75wwIDPTk0z86KyHtRlguCWqedGIUY46T51Q==
X-Received: by 2002:a05:600c:4f43:b0:3a6:16ca:8da4 with SMTP id m3-20020a05600c4f4300b003a616ca8da4mr1046849wmq.80.1660729145162;
        Wed, 17 Aug 2022 02:39:05 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id h82-20020a1c2155000000b003a319bd3278sm1559876wmh.40.2022.08.17.02.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 02:39:04 -0700 (PDT)
Date:   Wed, 17 Aug 2022 05:39:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220817053821-mutt-send-email-mst@kernel.org>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com>
 <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com>
 <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com>
 <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> > On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
> > > Yes it is a little messy, and we can not check _F_VERSION_1 because of
> > > transitional devices, so maybe this is the best we can do for now
> > I think vhost generally needs an API to declare config space endian-ness
> > to kernel. vdpa can reuse that too then.
> Yes, I remember you have mentioned some IOCTL to set the endian-ness,
> for vDPA, I think only the vendor driver knows the endian,
> so we may need a new function vdpa_ops->get_endian().
> In the last thread, we say maybe it's better to add a comment for now.
> But if you think we should add a vdpa_ops->get_endian(), I can work
> on it for sure!
> 
> Thanks
> Zhu Lingshan

I think QEMU has to set endian-ness. No one else knows.

> > 

