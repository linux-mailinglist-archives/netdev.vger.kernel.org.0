Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749A45EEE3E
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 09:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235087AbiI2HBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 03:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235050AbiI2HB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 03:01:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F27124C01
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664434872;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AxK08tpN1f4WSm3Qo4h/uwm/D3uFgyKZ3mg/sBcp48w=;
        b=axPKG5JF/OHMaeU8ntK28fI65xj8AkTESeNqjc48Tsma5NqCvDxw/y+hUHsA5hY/Xi9Jpr
        vmQ/WeIVl/zqR2TMuwnUabz46tCDs43ypi4QicRZBIRLXjvofXvfY1+0FN6ONrIsbwNFlp
        rD/XVx+8uCqOuOiTVeKX49D+9TvEUUs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-140-ekv5NN0CPguopGffqnvBLg-1; Thu, 29 Sep 2022 03:01:09 -0400
X-MC-Unique: ekv5NN0CPguopGffqnvBLg-1
Received: by mail-wm1-f71.google.com with SMTP id p24-20020a05600c1d9800b003b4b226903dso2546917wms.4
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 00:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=AxK08tpN1f4WSm3Qo4h/uwm/D3uFgyKZ3mg/sBcp48w=;
        b=OHaWxdUsUM8u4l/EjPX/Zwk+4h00xJZTTMRjWGa572KIxfOxChykg3vdYqlTblgDcX
         P4M5M0QYj79urm1XOzH6vJGKOwuhEtdZzdpkI7Te8615kSO7nWObMwVGRRt7e/NnrR8C
         YLKZOFdUFjfy9iYe5OIZRIY8+heAhO2N3fMTsMJyfcPui2iJn2se/fEC8urebJQq+UlS
         oiOcscL7dKyPr49r/4+8RWLm5+vOdhX1hbTb/QHoSMTezylh/BI3+Xkr63k8Kev1Sygo
         rYGgnCLpvd63mpMmOdd4cEcqV+azXTLD/PK3QMv6FxXaX3skEfsE3UZnGmFre1awkC3w
         yM7g==
X-Gm-Message-State: ACrzQf2Ln9IVfPvw7HUYFpC1Q3GwpKyJLJpMjV4+TbQmiWvWSZSQyOCs
        7Y+BsYteaUIy6JE7aI/ySQBlqeF7ylCQoXR3INcjQ5/1Agv2VdZEuInnwihU7SECe2/WLR5B7fg
        GZYN1wzSfirx9vBgQ
X-Received: by 2002:adf:e4ca:0:b0:228:d8b7:48a7 with SMTP id v10-20020adfe4ca000000b00228d8b748a7mr998856wrm.300.1664434867941;
        Thu, 29 Sep 2022 00:01:07 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6ZbRji7MbNVQKoWmesvvZxQ9b3Cpq1Lt79TWy3szetsqpegw4eZnLiCCE6V5WfZSRm2OWveg==
X-Received: by 2002:adf:e4ca:0:b0:228:d8b7:48a7 with SMTP id v10-20020adfe4ca000000b00228d8b748a7mr998833wrm.300.1664434867646;
        Thu, 29 Sep 2022 00:01:07 -0700 (PDT)
Received: from redhat.com ([2.55.17.78])
        by smtp.gmail.com with ESMTPSA id n2-20020a05600c4f8200b003b27f644488sm3861501wmq.29.2022.09.29.00.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 00:01:07 -0700 (PDT)
Date:   Thu, 29 Sep 2022 03:01:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     stephen@networkplumber.org, davem@davemloft.net,
        jesse.brandeburg@intel.com, kuba@kernel.org,
        sridhar.samudrala@intel.com, jasowang@redhat.com,
        loseweigh@gmail.com, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        virtio-dev@lists.oasis-open.org
Subject: Re: [virtio-dev] [PATCH v6 0/2] Improve virtio performance for 9k mtu
Message-ID: <20220929030022-mutt-send-email-mst@kernel.org>
References: <20220914144911.56422-1-gavinl@nvidia.com>
 <68934c1a-6c75-f410-2c29-1a7edc97aeb9@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68934c1a-6c75-f410-2c29-1a7edc97aeb9@nvidia.com>
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 29, 2022 at 02:50:00PM +0800, Gavin Li wrote:
> 
> On 9/14/2022 10:49 PM, Gavin Li wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > This small series contains two patches that improves virtio netdevice
> > performance for 9K mtu when GRO/ guest TSO is disabled.
> > 
> > Gavin Li (2):
> >    virtio-net: introduce and use helper function for guest gso support
> >      checks
> > ---
> > changelog:
> > v4->v5
> > - Addressed comments from Michael S. Tsirkin
> > - Remove unnecessary () in return clause
> > v1->v2
> > - Add new patch
> > ---
> >    virtio-net: use mtu size as buffer length for big packets
> > ---
> > changelog:
> > v5->v6
> > - Addressed comments from Jason and Michael S. Tsirkin
> > - Remove wrong commit log description
> > - Rename virtnet_set_big_packets_fields with virtnet_set_big_packets
> > - Add more test results for different feature combinations
> > v4->v5
> > - Addressed comments from Michael S. Tsirkin
> > - Improve commit message
> > v3->v4
> > - Addressed comments from Si-Wei
> > - Rename big_packets_sg_num with big_packets_num_skbfrags
> > v2->v3
> > - Addressed comments from Si-Wei
> > - Simplify the condition check to enable the optimization
> > v1->v2
> > - Addressed comments from Jason, Michael, Si-Wei.
> > - Remove the flag of guest GSO support, set sg_num for big packets and
> >    use it directly
> > - Recalculate sg_num for big packets in virtnet_set_guest_offloads
> > - Replace the round up algorithm with DIV_ROUND_UP
> > ---
> > 
> >   drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++--------------
> >   1 file changed, 32 insertions(+), 16 deletions(-)
> > 
> > --
> > 2.31.1
> > 
> > 
> > ---------------------------------------------------------------------
> > To unsubscribe, e-mail: virtio-dev-unsubscribe@lists.oasis-open.org
> > For additional commands, e-mail: virtio-dev-help@lists.oasis-open.org
> Did you get a chance to pull these short series?

Not in net-next yet for some reason, I was hoping it
will get some testing here. I'll put it in my tree
for next for now so it gets tested. Thanks!

