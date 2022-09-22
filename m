Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 289DE5E5E89
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiIVJ1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiIVJ1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:27:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CE5AA365
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663838819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yj3DJI23V+LSbLbOkpD05qbfoHmBLlLfe1GL1sqUY0E=;
        b=IRyPwu936sJ192whWF2OX/TnFmybeQCG1Iq5B/KWozFU2ZHSDsNkqh0gXAfZohqA0JeBWe
        H9HE+SrA2TAxYMzhSQAdOOHTYKj0gMDV2Drs0cgteYg0U/woIsjX1kfAQ8JCrQGlkHGkiz
        BNEWAYDDih8BDjcpYRO/ySfXl6/TeeI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-77-cx1oZd8AMiyaRsykTmZuVA-1; Thu, 22 Sep 2022 05:26:58 -0400
X-MC-Unique: cx1oZd8AMiyaRsykTmZuVA-1
Received: by mail-wm1-f69.google.com with SMTP id v62-20020a1cac41000000b003b4fca0e80cso1701648wme.0
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:26:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=yj3DJI23V+LSbLbOkpD05qbfoHmBLlLfe1GL1sqUY0E=;
        b=J7ueC+CQqGyB1RomsXUhy2wAD159VppYIgtoLoBtDl9cRCnpDsdtOK1yHMBX9atGHO
         OiSjsv61Dg7JL0oBJwr68haWNI7HyARxFBOEJZSJUeKfm1NB+vAzLtxze1ZLXTq5qwLB
         rP+fiyJzYG/y8ipwkjqK6oGSghEKAb9z1HjM+NBCe1JS1OrCt6AwMZp2M/9T+xvFIKrZ
         m5UTIquLBwhRb5AOQbsd9IyHOS4F2di6rckAU/GfScWGLQKnmnccb9IoPK6K5EDGYxiE
         JoPxuUAEWHdVr3XB1Xh1ssUqRMzqAbGz0Pq4eAGkapnLp38PWSqoacBSNs8rByhd9tXW
         a+TQ==
X-Gm-Message-State: ACrzQf2B+ys3pl00LRzbUbOPZQaDJMAJ9fv452q9DdvzzQ3P5SPyv96n
        WAbGG8GjSqN1r2eEbAySUEwaiJ3Fefep1AolqW10qjI6wplqBOfyG8tPMZER+w5OY6aHvpT0rSm
        au6N8RI2B283ZdqUJ
X-Received: by 2002:a5d:64ab:0:b0:226:d997:ad5c with SMTP id m11-20020a5d64ab000000b00226d997ad5cmr1341543wrp.602.1663838816933;
        Thu, 22 Sep 2022 02:26:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6w8zI1PSOatdXcP+bXy3/Br5lytITKBUKb/YxbFrzsjnCQAQ3nJh7CECAIbmV5DzXtXp2xAQ==
X-Received: by 2002:a5d:64ab:0:b0:226:d997:ad5c with SMTP id m11-20020a5d64ab000000b00226d997ad5cmr1341524wrp.602.1663838816660;
        Thu, 22 Sep 2022 02:26:56 -0700 (PDT)
Received: from redhat.com ([2.55.16.18])
        by smtp.gmail.com with ESMTPSA id a1-20020a5d5701000000b00228de58ae2bsm4759663wrv.12.2022.09.22.02.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 02:26:55 -0700 (PDT)
Date:   Thu, 22 Sep 2022 05:26:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Gavin Li <gavinl@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sridhar.samudrala@intel.com" <sridhar.samudrala@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "loseweigh@gmail.com" <loseweigh@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>,
        Gavi Teitz <gavi@nvidia.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>
Subject: Re: [PATCH v5 2/2] virtio-net: use mtu size as buffer length for big
 packets
Message-ID: <20220922052233-mutt-send-email-mst@kernel.org>
References: <20220907103420-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481066A18907753997A6F0CDC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907141447-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481C6E39AB31AB445C714A1DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907151026-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54811F1234CB7822F47DD1B9DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907152156-mutt-send-email-mst@kernel.org>
 <PH0PR12MB5481291080EBEC54C82A5641DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220907153425-mutt-send-email-mst@kernel.org>
 <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB54815E541D435DDC9339CA02DC419@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 07, 2022 at 07:51:38PM +0000, Parav Pandit wrote:
> 
> > From: Michael S. Tsirkin <mst@redhat.com>
> > Sent: Wednesday, September 7, 2022 3:36 PM
> > 
> > On Wed, Sep 07, 2022 at 07:27:16PM +0000, Parav Pandit wrote:
> > >
> > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > Sent: Wednesday, September 7, 2022 3:24 PM
> > > >
> > > > On Wed, Sep 07, 2022 at 07:18:06PM +0000, Parav Pandit wrote:
> > > > >
> > > > > > From: Michael S. Tsirkin <mst@redhat.com>
> > > > > > Sent: Wednesday, September 7, 2022 3:12 PM
> > > > >
> > > > > > > Because of shallow queue of 16 entries deep.
> > > > > >
> > > > > > but why is the queue just 16 entries?
> > > > > I explained the calculation in [1] about 16 entries.
> > > > >
> > > > > [1]
> > > > >
> > > >
> > https://lore.kernel.org/netdev/PH0PR12MB54812EC7F4711C1EA4CAA119DC
> > > > 419@
> > > > > PH0PR12MB5481.namprd12.prod.outlook.com/
> > > > >
> > > > > > does the device not support indirect?
> > > > > >
> > > > > Yes, indirect feature bit is disabled on the device.
> > > >
> > > > OK that explains it.
> > >
> > > So can we proceed with v6 to contain
> > > (a) updated commit message and
> > > (b) function name change you suggested to drop _fields suffix?
> > 
> > (c) replace mtu = 0 with sensibly not calling the function when mtu is
> > unknown.
> 
> > 
> > 
> > And I'd like commit log to include results of perf testing
> > - with indirect feature on
> Which device do you suggest using for this test?

AFAIK most devices support INDIRECT, e.g. don't nvidia cards do this?


> > - with mtu feature off
> Why is this needed when it is not touching the area of mtu being not offered?

I don't really like it that instead of checking the MTU feature bit
everywhere the patch sets mtu variable to 0. Because of this
it wasn't all that obvious that the patch did not affect !MTU
performance (the code does change).

Rereading it afresh I think it's ok. But explicit check for !MTU
would be better imho making it obvious we do not need to test !MTU.

-- 
MST

