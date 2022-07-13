Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF526572CFF
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 07:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiGMFXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 01:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiGMFXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 01:23:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0667BD4459
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657689807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=mx2Am9gFTCNI9BaWsLgkeiQH68t9VBPnMVGfxTXXM9A=;
        b=I/7UAQi+Nht6UBLAmSVlWR5aFECWKugWZ9TEU4UGsQovJlatkDp8NckstD3eugv436H8qd
        lAVqWx9ma4DtM8aGRdstrGeQLQtu93IYKZR9aARcnXL3jbnRsyDWslQ/EJQ511BP24W8Op
        ciCftpJuATonFGnS7LTHYjyJO2wCwPU=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-yI6IUJzXPZ23pSNPvRTgbA-1; Wed, 13 Jul 2022 01:23:26 -0400
X-MC-Unique: yI6IUJzXPZ23pSNPvRTgbA-1
Received: by mail-ed1-f70.google.com with SMTP id z20-20020a05640240d400b0043a82d9d65fso7548788edb.0
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 22:23:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mx2Am9gFTCNI9BaWsLgkeiQH68t9VBPnMVGfxTXXM9A=;
        b=qsq54JSvDHDBTd19K7LinPdPV0HpH0PSsVl1qJrPRTxGTa0PnLPeICqLDpvdTj7nh4
         ZA6FYXhAFcAiZQngO7V7BKe21HR5SVCsBmTcsacZfvv/TY5/ktCgGLEhlQD0Mvp0KX+M
         LESxTHsMt797Uu4pkhW2xoAVO/4eBi8uffRdn8ZZrJ4i68Vpukr5RTM5ywtJfuEFo2ze
         2A1XVM8iYpySshomaOMmm7rxRQTvUsaYuxw1lhrgCsyVQgHs1+jaN50hFTC7kRuzNf+4
         EU1p1m9dqW+E/aDahCI27w4AH3zKqyGwRDLCnViXLBB5pH4yiV1IGjidH0qoNJxSfE2D
         XmnA==
X-Gm-Message-State: AJIora9lJyeKNfTXE6sUE18M43rIoqaj2mBQed/wwc/kSKCqDXHTio3t
        SZbAx9NZZN1jbjjlG91N4w0geYFZ+ghCdA9XwNWlg40iE1jsXEVZ9jHoVT2gNcq+s5uYd1FZefV
        DmF/oVvuFZGSlbAr9
X-Received: by 2002:a05:6402:2404:b0:437:d11f:b9c7 with SMTP id t4-20020a056402240400b00437d11fb9c7mr2445829eda.176.1657689805117;
        Tue, 12 Jul 2022 22:23:25 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ulI8KDZUKTkP1k/mb9cJbdGBS7J5mail0dNkB2X4x2IaCDX5VdTO5ksVFYiZ6954aIE61/NQ==
X-Received: by 2002:a05:6402:2404:b0:437:d11f:b9c7 with SMTP id t4-20020a056402240400b00437d11fb9c7mr2445806eda.176.1657689804869;
        Tue, 12 Jul 2022 22:23:24 -0700 (PDT)
Received: from redhat.com ([2.52.24.42])
        by smtp.gmail.com with ESMTPSA id r17-20020a1709061bb100b0072b616ade26sm2473478ejg.216.2022.07.12.22.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 22:23:23 -0700 (PDT)
Date:   Wed, 13 Jul 2022 01:23:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220713012048-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 01, 2022 at 10:12:49PM +0000, Parav Pandit wrote:
> 
> 
> > From: Zhu Lingshan <lingshan.zhu@intel.com>
> > Sent: Friday, July 1, 2022 9:28 AM
> > 
> > Users may want to query the config space of a vDPA device, to choose a
> > appropriate one for a certain guest. This means the users need to read the
> > config space before FEATURES_OK, and the existence of config space
> > contents does not depend on FEATURES_OK.
> > 
> > The spec says:
> > The device MUST allow reading of any device-specific configuration field
> > before FEATURES_OK is set by the driver. This includes fields which are
c> > conditional on feature bits, as long as those feature bits are offered by the
> > device.
> > 
> > Fixes: 30ef7a8ac8a07 (vdpa: Read device configuration only if FEATURES_OK)
> Fix is fine, but fixes tag needs correction described below.
> 
> Above commit id is 13 letters should be 12.
> And 
> It should be in format
> Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration only if FEATURES_OK")

Yea you normally use

--format='Fixes: %h (\"%s\")'


> Please use checkpatch.pl script before posting the patches to catch these errors.
> There is a bot that looks at the fixes tag and identifies the right kernel version to apply this fix.


I don't think checkpatch complains about this if for no other reason
that sometimes the 6 byte hash is not enough.

> > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > ---
> >  drivers/vdpa/vdpa.c | 8 --------
> >  1 file changed, 8 deletions(-)
> > 
> > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> > 9b0e39b2f022..d76b22b2f7ae 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
> > struct sk_buff *msg, u32 portid,  {
> >  	u32 device_id;
> >  	void *hdr;
> > -	u8 status;
> >  	int err;
> > 
> >  	down_read(&vdev->cf_lock);
> > -	status = vdev->config->get_status(vdev);
> > -	if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> > -		NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
> > completed");
> > -		err = -EAGAIN;
> > -		goto out;
> > -	}
> > -
> >  	hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
> >  			  VDPA_CMD_DEV_CONFIG_GET);
> >  	if (!hdr) {
> > --
> > 2.31.1

