Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814F352549F
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357562AbiELSVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 14:21:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357571AbiELSVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 14:21:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CCB6E50465
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 11:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652379694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JQehALh0Jx7o9GOk+RBlCmR7brUtli8lBPEjRk+xLZ4=;
        b=NpO9ogdyTrCOCG6JB9Zj7gd9ZRqbBZJT7wesrBl9o9AqFn6xyg6JVUUCKtk8XphmvcwZZt
        B7W2xUVdNOcJp8SKsgGIzCJWL1yBzIcS8Nl1ltDdwK5/yvlefIzfyTDCQReEOu9t2KgPCJ
        79C3FNzNZJ+y9cXmfSdKBvnXJbdkhPk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-2rwWp6PmNa2cL8gZrLsBHg-1; Thu, 12 May 2022 14:21:33 -0400
X-MC-Unique: 2rwWp6PmNa2cL8gZrLsBHg-1
Received: by mail-il1-f197.google.com with SMTP id d9-20020a056e02214900b002d0f136e101so593417ilv.11
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 11:21:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JQehALh0Jx7o9GOk+RBlCmR7brUtli8lBPEjRk+xLZ4=;
        b=gOC2gwmFLrLXhfndawoJFnfS82ZdDS1h5hN3ZaUTyscUX5WDKhQRuqAqArpjmDE+do
         KXXwfWwvNZEg3i3NtZhY3yNzScUEWN4lV/S0WPAtFcwvnsyiLGYcFtha4GiFkCiWQbDI
         rVxXvUdQ6bXVYjG1f6csDAk4d2Y/uXym1qFTR5P4NTmohJ9hPtVQRhEoMXYIq05LjhLT
         ARIKuL8EwZ0WNLrem/d8ifYU7vglKnT8ozD1KAlmyaydGOa+FpbQTjLD/YGap3lbsu6Z
         FNdoOar9s7MSd0yWiBI/uuE81v6j2/M1eYW/lZCrwEcH2ye8SFVyRg5zduG6gqr5Kc6k
         88mQ==
X-Gm-Message-State: AOAM5333cbyRolhtQEQCzj0Dvt3MbMAA4v90AJW+b4INvbxQqLrlCKuM
        fN/XKUOabhwy/+LK4J+/4BtsswkopRE6vJLptt2WEUnEajGlMtx/i0iH5oVp+4tZUi2iEOOA71A
        edHNw0Y13vvTk+/W0
X-Received: by 2002:a05:6e02:2162:b0:2cf:2f70:e8e with SMTP id s2-20020a056e02216200b002cf2f700e8emr712608ilv.148.1652379692145;
        Thu, 12 May 2022 11:21:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyDOG3POaOwmN7RPhnD3yF1II+ZnJefBH0XMNF01/MUw/8Bjjr9whEtDHPh+Malkf+KCAyZSw==
X-Received: by 2002:a05:6e02:2162:b0:2cf:2f70:e8e with SMTP id s2-20020a056e02216200b002cf2f700e8emr712592ilv.148.1652379691904;
        Thu, 12 May 2022 11:21:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id f21-20020a02b795000000b0032b3a781771sm64668jam.53.2022.05.12.11.21.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 11:21:31 -0700 (PDT)
Date:   Thu, 12 May 2022 12:21:30 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 mlx5-next 0/4] Improve mlx5 live migration driver
Message-ID: <20220512122130.48181ada.alex.williamson@redhat.com>
In-Reply-To: <YntaZcd+Qv5UiQRN@unreal>
References: <20220510090206.90374-1-yishaih@nvidia.com>
        <YnploMZRI9jXMXAi@unreal>
        <20220510090053.56efd550.alex.williamson@redhat.com>
        <YntaZcd+Qv5UiQRN@unreal>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 09:40:37 +0300
Leon Romanovsky <leon@kernel.org> wrote:

> On Tue, May 10, 2022 at 09:00:53AM -0600, Alex Williamson wrote:
> > On Tue, 10 May 2022 16:16:16 +0300
> > Leon Romanovsky <leon@kernel.org> wrote:
> >   
> > > On Tue, May 10, 2022 at 12:02:02PM +0300, Yishai Hadas wrote:  
> > > > This series improves mlx5 live migration driver in few aspects as of
> > > > below.
> > > > 
> > > > Refactor to enable running migration commands in parallel over the PF
> > > > command interface.
> > > > 
> > > > To achieve that we exposed from mlx5_core an API to let the VF be
> > > > notified before that the PF command interface goes down/up. (e.g. PF
> > > > reload upon health recovery).
> > > > 
> > > > Once having the above functionality in place mlx5 vfio doesn't need any
> > > > more to obtain the global PF lock upon using the command interface but
> > > > can rely on the above mechanism to be in sync with the PF.
> > > > 
> > > > This can enable parallel VFs migration over the PF command interface
> > > > from kernel driver point of view.
> > > > 
> > > > In addition,
> > > > Moved to use the PF async command mode for the SAVE state command.
> > > > This enables returning earlier to user space upon issuing successfully
> > > > the command and improve latency by let things run in parallel.
> > > > 
> > > > Alex, as this series touches mlx5_core we may need to send this in a
> > > > pull request format to VFIO to avoid conflicts before acceptance.    
> > > 
> > > The PR was sent.
> > > https://lore.kernel.org/netdev/20220510131236.1039430-1-leon@kernel.org/T/#u  
> > 
> > For patches 2-4, please add:
> > 
> > Reviewed-by: Alex Williamson <alex.williamson@redhat.com>  
> 
> Done, I force pushed same branch and tag, so previous PR is still valid
> to be pulled.
> https://lore.kernel.org/kvm/20220510131236.1039430-1-leon@kernel.org/T/#u

Merged to vfio next branch for v5.19.  Thanks,

Alex

