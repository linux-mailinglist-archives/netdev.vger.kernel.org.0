Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1665B00CD
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiIGJpU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGJpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:45:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABA652AE05;
        Wed,  7 Sep 2022 02:45:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 383DB61838;
        Wed,  7 Sep 2022 09:45:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D303C433D6;
        Wed,  7 Sep 2022 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662543917;
        bh=moYaIWyTH0PrGLcXgdc2hkFyxnF7rAqmR3Brap4vbTw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Czdeha7KZv5oBH020ovZTniM/Dd7PiZe4TUSDAEr4bILLiUx3b+JFohHl8AX/Tfvf
         l/iZnHBfzIlPFBkKykhpgFwBW4mylKwO5rUrXCAHtdQ82TVPRdVmsBPkfKw92h4DoD
         sHLbWClIGFfuhXJpeXSdVc3b4TestRWjnb9wLMOE3YK2JEjTf6E/Te3oF1dk0AxVLZ
         Yv47Za2gZrGUwaT0NX/Oc7JSf3qnHcwgCz9yi0lssJt4w4314kM78R4GDB45BVeLdb
         V0bi/vWbJMF5pcMRL/eIHq+MJ57kRVOEv+8eGFAULFFN1D/ErLKVVc0qq7KgsxxIiR
         EOOI7UZdtjucw==
Date:   Wed, 7 Sep 2022 12:45:13 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, joao.m.martins@oracle.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V6 vfio 05/10] vfio: Introduce the DMA logging feature
 support
Message-ID: <YxhoKWfnwiLqxyQX@unreal>
References: <20220905105852.26398-1-yishaih@nvidia.com>
 <20220905105852.26398-6-yishaih@nvidia.com>
 <20220906164154.756e26aa.alex.williamson@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906164154.756e26aa.alex.williamson@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 04:41:54PM -0600, Alex Williamson wrote:
> On Mon, 5 Sep 2022 13:58:47 +0300
> Yishai Hadas <yishaih@nvidia.com> wrote:
> > diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> > index e05ddc6fe6a5..b17f2f454389 100644
> > --- a/include/linux/vfio.h
> > +++ b/include/linux/vfio.h
> > @@ -108,6 +110,21 @@ struct vfio_migration_ops {
> >  				   enum vfio_device_mig_state *curr_state);
> >  };
> >  
> > +/**
> > + * @log_start: Optional callback to ask the device start DMA logging.
> > + * @log_stop: Optional callback to ask the device stop DMA logging.
> > + * @log_read_and_clear: Optional callback to ask the device read
> > + *         and clear the dirty DMAs in some given range.
> 
> I don't see anywhere in the core that we track the device state
> relative to the DEVICE_FEATURE_DMA_LOGGING features, nor do we
> explicitly put the responsibility on the driver implementation to
> handle invalid user requests.  The mlx5 driver implementation appears
> to do this, but maybe we should at least include a requirement here, ex.
> 
>    The vfio core implementation of the DEVICE_FEATURE_DMA_LOGGING_ set
>    of features does not track logging state relative to the device,
>    therefore the device implementation of vfio_log_ops must handle
>    arbitrary user requests.  This includes rejecting subsequent calls
>    to log_start without an intervening log_stop, as well as graceful
>    handling of log_stop and log_read_and_clear from invalid states.
> 
> With something like that.
> 
> Acked-by: Alex Williamson <alex.williamson@redhat.com>
> 
> You can also add my Ack on 3, 4, and (fwiw) 6-10 as I assume this would
> be a PR from Leon.  Thanks,

Yes, it is.
I sent PR based on clean 6.0-rc4.

Thanks

> 
> Alex
> 
> > + */
> > +struct vfio_log_ops {
> > +	int (*log_start)(struct vfio_device *device,
> > +		struct rb_root_cached *ranges, u32 nnodes, u64 *page_size);
> > +	int (*log_stop)(struct vfio_device *device);
> > +	int (*log_read_and_clear)(struct vfio_device *device,
> > +		unsigned long iova, unsigned long length,
> > +		struct iova_bitmap *dirty);
> > +};
> > +
> >  /**
> >   * vfio_check_feature - Validate user input for the VFIO_DEVICE_FEATURE ioctl
> >   * @flags: Arg from the device_feature op
> 
