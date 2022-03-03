Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1A594CC77E
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 22:01:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236404AbiCCVCB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 16:02:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233301AbiCCVCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 16:02:00 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 385871CFD1
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 13:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646341274;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8b61j3jDxeMLMcRITP39wLh0mrGAS4obX7IDIQWgUAI=;
        b=YNnh1OhdM1oUSjBFEm/v4BTuq2F6Ygfg1rbQVNPuSeShj115l2nQG3XwN6A4EgBf4vnJ0D
        s9SAqvNnM0cCL7ak8pt95pzyfu2Pyc3SLhIz+TYCdJFhQX5KFtGvlIQXSL6ixGiXckuWXy
        abu7lNGbt4gBPN0rsqCgRlfcAZQst+0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-xb-dB3HVMGS2gBtQBEkELQ-1; Thu, 03 Mar 2022 16:01:13 -0500
X-MC-Unique: xb-dB3HVMGS2gBtQBEkELQ-1
Received: by mail-wr1-f72.google.com with SMTP id e6-20020a5d4e86000000b001f045d4a962so2295582wru.21
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 13:01:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8b61j3jDxeMLMcRITP39wLh0mrGAS4obX7IDIQWgUAI=;
        b=tUG7w2E4KJjgn+Xr4f6mGfn0Iu6terLhsUnxXy+UUqnIqJv57J5R9awbkjdnd/B9Ym
         b0AcGV49eZqYp+MNK7L309toFYhYhAHsmVS2Zr7x2Vc0Y5ZmcXZ1LVlpiyR3PkXfLPDV
         4r34RDNFKN6tarLvN/XED4ldbQZiCU4LpqrlSgrfYqQw/gmHV8sUACcsvZXol5oHS53k
         h3oUBGNFc8zOvE5OCo+rsTeMHYSPyH8j6HTNJ1AZayTmRDagVBuaQ2XqWsGm5vIYJbJv
         5RRUpOgy8DFfLqGHHL9mCsCPSmkm9ipoz5sDvNzGuqMuqaHuWRDtXnVc7/xbO8Qk6syi
         kQVA==
X-Gm-Message-State: AOAM530VQLg3j5DgpmoPSbZbBTUQNawkWNHSMeih5cg9m+OTA0PNyVxT
        VTj0c2i0uRlI0GkviBtr9j5fsZCW2yu3gTwBLn0tQQvXJpBtiFHyntiklLW2x9DrM8OnQWCUrcY
        MwKHZtE2k39/D3UCy
X-Received: by 2002:a05:600c:4f8f:b0:383:d0b:3706 with SMTP id n15-20020a05600c4f8f00b003830d0b3706mr5231468wmq.117.1646341271846;
        Thu, 03 Mar 2022 13:01:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyKK9jWjBGTEf4CQ2VVlOjCLLsVb5H0JIMs+Muv46FA+kUpNhvpttoraxVDN8+XxYn68U3LdA==
X-Received: by 2002:a05:600c:4f8f:b0:383:d0b:3706 with SMTP id n15-20020a05600c4f8f00b003830d0b3706mr5231451wmq.117.1646341271510;
        Thu, 03 Mar 2022 13:01:11 -0800 (PST)
Received: from redhat.com ([2.55.143.133])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d460e000000b001edc107e4f7sm4365551wrq.81.2022.03.03.13.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 13:01:10 -0800 (PST)
Date:   Thu, 3 Mar 2022 16:01:06 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Lee Jones <lee.jones@linaro.org>, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1] vhost: Provide a kernel warning if mutex is held
 whilst clean-up in progress
Message-ID: <20220303155645-mutt-send-email-mst@kernel.org>
References: <20220303151929.2505822-1-lee.jones@linaro.org>
 <YiETnIcfZCLb63oB@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YiETnIcfZCLb63oB@unreal>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 03, 2022 at 09:14:36PM +0200, Leon Romanovsky wrote:
> On Thu, Mar 03, 2022 at 03:19:29PM +0000, Lee Jones wrote:
> > All workers/users should be halted before any clean-up should take place.
> > 
> > Suggested-by:  Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/vhost/vhost.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index bbaff6a5e21b8..d935d2506963f 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -693,6 +693,9 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >  	int i;
> >  
> >  	for (i = 0; i < dev->nvqs; ++i) {
> > +		/* Ideally all workers should be stopped prior to clean-up */
> > +		WARN_ON(mutex_is_locked(&dev->vqs[i]->mutex));
> > +
> >  		mutex_lock(&dev->vqs[i]->mutex);
> 
> I know nothing about vhost, but this construction and patch looks
> strange to me.
> 
> If all workers were stopped, you won't need mutex_lock(). The mutex_lock
> here suggests to me that workers can still run here.
> 
> Thanks


"Ideally" here is misleading, we need a bigger detailed comment
along the lines of:

/* 
 * By design, no workers can run here. But if there's a bug and the
 * driver did not flush all work properly then they might, and we
 * encountered such bugs in the past.  With no proper flush guest won't
 * work correctly but avoiding host memory corruption in this case
 * sounds like a good idea.
 */

> >  		if (dev->vqs[i]->error_ctx)
> >  			eventfd_ctx_put(dev->vqs[i]->error_ctx);
> > -- 
> > 2.35.1.574.g5d30c73bfb-goog
> > 

