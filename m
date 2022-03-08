Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D584D1E63
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:18:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348735AbiCHRS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiCHRSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:18:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5ED9C1705B
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 09:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646759874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XS0ZDRJdbTaFXTIodebwWZ2Zs2A9XDPYU7p1D6O1mf0=;
        b=dIjGTYSRPyf8AKazEXlpGRVbebGC4btXDfmoHeC6Jbfb4GwJKy6OTd0MbJrNk3IXt7ZHIN
        t6hK+yMw9CuSIWM0adhzdFOofgGPMwX9hSfJ1P7dS+utshUS0kBaXTWP2CZLf12kIfbtQE
        Fgh4bVS8xZ6RSnA9G1ApWvI7QHwsKeY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-353-Pr6Z-DfWPjeSO1h547uKmA-1; Tue, 08 Mar 2022 12:17:53 -0500
X-MC-Unique: Pr6Z-DfWPjeSO1h547uKmA-1
Received: by mail-wr1-f72.google.com with SMTP id f9-20020a5d58e9000000b001f0247e5e96so5698763wrd.15
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 09:17:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XS0ZDRJdbTaFXTIodebwWZ2Zs2A9XDPYU7p1D6O1mf0=;
        b=atn+zLDBZ/KuMKHUJcpGevLb+Z71xeFvixiaQheChJiBM873olD0Q8GzpAdrF0TdNY
         JuaAsZ4z2kl1lzbRekQQ0CM36NtqX/s4Rd6OMAACKXoAwuYDCoqKqbTLWJy9Fnf11xuO
         eWva+AbLUxche4/PKy9BDUzvPuxt0zXh6FX6Nn6OO/iGFdssxNMXwu3NH1y80p2PL/Yn
         cnbNVawMnSn6TsccJbwd0YkgEhbam0ZplXg7mDbfUTYhExuF8Szi4/OEfrZX9yiZzR2Q
         yM9NwFTdPF0vpS/UPGpdk8E6vkVOUVgjfUHNNQZELkZcxAVwcNpepTIZWk/DFdPdnX6n
         lO+w==
X-Gm-Message-State: AOAM532X0yqzVeRGeBY30jaT0JFWaMgYhDNqkQ7AD7JdlgFVLJxhts2V
        23DYfq/JlGwVWT/MqcJyKTNi8MYJkaezdRp9Dcf3B4Dvl5LVrP0j4DAQsi6jo68LgpFassy9sMy
        4YS6R/ANXdCdgXxhD
X-Received: by 2002:a5d:6d88:0:b0:1e3:37c1:3633 with SMTP id l8-20020a5d6d88000000b001e337c13633mr13694516wrs.484.1646759870729;
        Tue, 08 Mar 2022 09:17:50 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzaK2eVHRi2q7VHFxDpXED+f3vKvPZuHUTcfgXWJzM+PfGD7TWOts3SCW6T6OiVKQsiFqgzBw==
X-Received: by 2002:a5d:6d88:0:b0:1e3:37c1:3633 with SMTP id l8-20020a5d6d88000000b001e337c13633mr13694505wrs.484.1646759870390;
        Tue, 08 Mar 2022 09:17:50 -0800 (PST)
Received: from redhat.com ([2.55.24.184])
        by smtp.gmail.com with ESMTPSA id u18-20020adfdd52000000b001f04e9f215fsm13950204wrm.53.2022.03.08.09.17.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 09:17:49 -0800 (PST)
Date:   Tue, 8 Mar 2022 12:17:45 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/1] vhost: Protect the virtqueue from being cleared
 whilst still in use
Message-ID: <20220308120858-mutt-send-email-mst@kernel.org>
References: <20220307191757.3177139-1-lee.jones@linaro.org>
 <YiZeB7l49KC2Y5Gz@kroah.com>
 <YicPXnNFHpoJHcUN@google.com>
 <Yicalf1I6oBytbse@kroah.com>
 <Yicer3yGg5rrdSIs@google.com>
 <YicolvcbY9VT6AKc@kroah.com>
 <20220308055003-mutt-send-email-mst@kernel.org>
 <YidBz7SxED2ii1Lh@kroah.com>
 <20220308071718-mutt-send-email-mst@kernel.org>
 <YidXT6zP1QN5KZUs@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YidXT6zP1QN5KZUs@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 01:17:03PM +0000, Lee Jones wrote:
> On Tue, 08 Mar 2022, Michael S. Tsirkin wrote:
> 
> > On Tue, Mar 08, 2022 at 12:45:19PM +0100, Greg KH wrote:
> > > On Tue, Mar 08, 2022 at 05:55:58AM -0500, Michael S. Tsirkin wrote:
> > > > On Tue, Mar 08, 2022 at 10:57:42AM +0100, Greg KH wrote:
> > > > > On Tue, Mar 08, 2022 at 09:15:27AM +0000, Lee Jones wrote:
> > > > > > On Tue, 08 Mar 2022, Greg KH wrote:
> > > > > > 
> > > > > > > On Tue, Mar 08, 2022 at 08:10:06AM +0000, Lee Jones wrote:
> > > > > > > > On Mon, 07 Mar 2022, Greg KH wrote:
> > > > > > > > 
> > > > > > > > > On Mon, Mar 07, 2022 at 07:17:57PM +0000, Lee Jones wrote:
> > > > > > > > > > vhost_vsock_handle_tx_kick() already holds the mutex during its call
> > > > > > > > > > to vhost_get_vq_desc().  All we have to do here is take the same lock
> > > > > > > > > > during virtqueue clean-up and we mitigate the reported issues.
> > > > > > > > > > 
> > > > > > > > > > Also WARN() as a precautionary measure.  The purpose of this is to
> > > > > > > > > > capture possible future race conditions which may pop up over time.
> > > > > > > > > > 
> > > > > > > > > > Link: https://syzkaller.appspot.com/bug?extid=279432d30d825e63ba00
> > > > > > > > > > 
> > > > > > > > > > Cc: <stable@vger.kernel.org>
> > > > > > > > > > Reported-by: syzbot+adc3cb32385586bec859@syzkaller.appspotmail.com
> > > > > > > > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > > > > > > > > ---
> > > > > > > > > >  drivers/vhost/vhost.c | 10 ++++++++++
> > > > > > > > > >  1 file changed, 10 insertions(+)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > > > > > > > index 59edb5a1ffe28..ef7e371e3e649 100644
> > > > > > > > > > --- a/drivers/vhost/vhost.c
> > > > > > > > > > +++ b/drivers/vhost/vhost.c
> > > > > > > > > > @@ -693,6 +693,15 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > > > > > > > >  	int i;
> > > > > > > > > >  
> > > > > > > > > >  	for (i = 0; i < dev->nvqs; ++i) {
> > > > > > > > > > +		/* No workers should run here by design. However, races have
> > > > > > > > > > +		 * previously occurred where drivers have been unable to flush
> > > > > > > > > > +		 * all work properly prior to clean-up.  Without a successful
> > > > > > > > > > +		 * flush the guest will malfunction, but avoiding host memory
> > > > > > > > > > +		 * corruption in those cases does seem preferable.
> > > > > > > > > > +		 */
> > > > > > > > > > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > > > > > > > > 
> > > > > > > > > So you are trading one syzbot triggered issue for another one in the
> > > > > > > > > future?  :)
> > > > > > > > > 
> > > > > > > > > If this ever can happen, handle it, but don't log it with a WARN_ON() as
> > > > > > > > > that will trigger the panic-on-warn boxes, as well as syzbot.  Unless
> > > > > > > > > you want that to happen?
> > > > > > > > 
> > > > > > > > No, Syzbot doesn't report warnings, only BUGs and memory corruption.
> > > > > > > 
> > > > > > > Has it changed?  Last I looked, it did trigger on WARN_* calls, which
> > > > > > > has resulted in a huge number of kernel fixes because of that.
> > > > > > 
> > > > > > Everything is customisable in syzkaller, so maybe there are specific
> > > > > > builds which panic_on_warn enabled, but none that I'm involved with
> > > > > > do.
> > > > > 
> > > > > Many systems run with panic-on-warn (i.e. the cloud), as they want to
> > > > > drop a box and restart it if anything goes wrong.
> > > > > 
> > > > > That's why syzbot reports on WARN_* calls.  They should never be
> > > > > reachable by userspace actions.
> > > > > 
> > > > > > Here follows a topical example.  The report above in the Link: tag
> > > > > > comes with a crashlog [0].  In there you can see the WARN() at the
> > > > > > bottom of vhost_dev_cleanup() trigger many times due to a populated
> > > > > > (non-flushed) worker list, before finally tripping the BUG() which
> > > > > > triggers the report:
> > > > > > 
> > > > > > [0] https://syzkaller.appspot.com/text?tag=CrashLog&x=16a61fce700000
> > > > > 
> > > > > Ok, so both happens here.  But don't add a warning for something that
> > > > > can't happen.  Just handle it and move on.  It looks like you are
> > > > > handling it in this code, so please drop the WARN_ON().
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > Hmm. Well this will mean if we ever reintroduce the bug then
> > > > syzkaller will not catch it for us :( And the bug is there,
> > > > it just results in a hard to reproduce error for userspace.
> > > 
> > > Is this an error you can recover from in the kernel?
> > >  What is userspace
> > > supposed to know with this information when it sees it?
> > 
> > IIUC we are talking about a use after free here since we somehow
> > managed to have a pointer to the device in a worker while
> > device is being destroyed.
> > 
> > That's the point of the warning as use after free is hard to debug. You
> > ask can we recover from a use after free? 
> > 
> > As regards to the added lock, IIUC it kind of shifts the use after free
> > window to later and since we zero out some of the memory just before we
> > free it, it's a bit more likely to recover.  I would still like to see
> > some more analysis on why the situation is always better than it was
> > before though.
> 
> With the locks in place, the UAF should not occur.

This really depends which UAF. Yes use of vq->private_data is protected
by a lock inside the VQ.

However, we are talking about vhost_net_release, which ends up doing

        kfree(n->dev.vqs);
...
        kvfree(n);

if someone is holding a pointer to a vq or the device itself at this
point, no locks that are part of one of said structures will be
effective in preventing a use after free, and using a lock to delay such
accesses to this point just might make it more likely there's a use
after free.


All of the above is why we didn't rush to apply the locking patch in the
first place, for all that it seemed to fix the sysboz crash.



> The issue here is that you have 2 different tasks processing the
> same area of memory (via pointers to structs).  In these scenarios you
> should always provide locking and/or reference counting to prevent
> memory corruption or UAF.

But we should not have 2 tasks doing that, and if we do then lock
just might be ineffective since the lock itself is released.

Again maybe in this case it makes sense but it needs a more detailed
analysis to show it's a net win than just "we have two tasks ergo we
need locking".

> -- 
> Lee Jones [李琼斯]
> Principal Technical Lead - Developer Services
> Linaro.org │ Open source software for Arm SoCs
> Follow Linaro: Facebook | Twitter | Blog

