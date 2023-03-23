Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32D26C6706
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbjCWLpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCWLpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:45:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B97B1E1DA
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679571889;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BMD7H2kp0eSKoSxfq1PhoExu63Twb+QYc8ILXExIOt0=;
        b=R7dWtzTpD9n2TfgKI/ljFG79xAoZjHEiZfih/5Nz4fBDxChSGZg6lso0FW9ke8c9LLXA6L
        60yE0xFbUT0UGgcFpLXD1JoE4jquUjf5h81cu1qLLrwQrWsx0HUWKLA0h7vayl+Qegjkls
        WGl8W9ZyXDtpEp8AFMEnbmSqXZefkvM=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-hsXAWgJuOZOA7nuqAMEkfg-1; Thu, 23 Mar 2023 07:44:48 -0400
X-MC-Unique: hsXAWgJuOZOA7nuqAMEkfg-1
Received: by mail-ed1-f71.google.com with SMTP id y24-20020aa7ccd8000000b004be3955a42eso32337399edt.22
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:44:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679571887;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BMD7H2kp0eSKoSxfq1PhoExu63Twb+QYc8ILXExIOt0=;
        b=O4kkfM9eefk2hVm4sRliN8qhEZkywsNKcJ/am1ZjMN9XvXN70xdganNYXwZgjdGFot
         oP1DphJdfOj55QqTE45Pn1aJy3Y+nnCG3X9oTiqbozWgNeGvmJiR4p4jw+OKwswvioBy
         yCWyHQpTY8X+o2rOUy2jVeKbmwPm8ephZS6GMxNjDCg1aSpS6NRyGU+JeTtJ1TD1NX8J
         j5eVI7oqWLKP6wUSDczOKujc59RBasDp5zBveqgLVoO2sppWP6mkpQZ5vS+vj4ZkP+12
         iqNADe11tacSJKR2kOYnrZ6tUD0fICjO9WT6kpSoR9byHfXhtyr5wJ5pZCGHfTCrAJTL
         gWzA==
X-Gm-Message-State: AO0yUKUQefpPXf7zCfrl0Bolk3VrS31MMJYOR4sqFqbnSrnVVp/kAjnG
        rqSalFD5waCfKvqxbj1r1G0txcEZsfAqDC/51RblJ3OCR/HvpbeTVR0wv1c48i22llwx54gLMKV
        XQx40uy46zcBs1bs/
X-Received: by 2002:a05:6402:2920:b0:500:2cc6:36d5 with SMTP id ee32-20020a056402292000b005002cc636d5mr5727068edb.8.1679571887368;
        Thu, 23 Mar 2023 04:44:47 -0700 (PDT)
X-Google-Smtp-Source: AK7set8uU0070bRsyBjQjpSi08yAtED4W63tVlm60HDGu5Op0XDHfVKzvp9t3BqE4omUQn4yYVC+6A==
X-Received: by 2002:a05:6402:2920:b0:500:2cc6:36d5 with SMTP id ee32-20020a056402292000b005002cc636d5mr5727043edb.8.1679571887109;
        Thu, 23 Mar 2023 04:44:47 -0700 (PDT)
Received: from redhat.com ([2.52.143.71])
        by smtp.gmail.com with ESMTPSA id w3-20020a50c443000000b004ac54d4da22sm9165128edf.71.2023.03.23.04.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Mar 2023 04:44:46 -0700 (PDT)
Date:   Thu, 23 Mar 2023 07:44:43 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        stefanha@redhat.com, linux-kernel@vger.kernel.org,
        eperezma@redhat.com,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 8/8] vdpa_sim: add support for user VA
Message-ID: <20230323074427-mutt-send-email-mst@kernel.org>
References: <20230321154804.184577-1-sgarzare@redhat.com>
 <20230321154804.184577-4-sgarzare@redhat.com>
 <CACGkMEtbrt3zuqy9YdhNyE90HHUT1R=HF-YRAQ6b4KnW_SdZ-w@mail.gmail.com>
 <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230323095006.jvbbdjvkdvhzcehz@sgarzare-redhat>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 10:50:06AM +0100, Stefano Garzarella wrote:
> On Thu, Mar 23, 2023 at 11:42:07AM +0800, Jason Wang wrote:
> > On Tue, Mar 21, 2023 at 11:48 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
> > > 
> > > The new "use_va" module parameter (default: true) is used in
> > > vdpa_alloc_device() to inform the vDPA framework that the device
> > > supports VA.
> > > 
> > > vringh is initialized to use VA only when "use_va" is true and the
> > > user's mm has been bound. So, only when the bus supports user VA
> > > (e.g. vhost-vdpa).
> > > 
> > > vdpasim_mm_work_fn work is used to serialize the binding to a new
> > > address space when the .bind_mm callback is invoked, and unbinding
> > > when the .unbind_mm callback is invoked.
> > > 
> > > Call mmget_not_zero()/kthread_use_mm() inside the worker function
> > > to pin the address space only as long as needed, following the
> > > documentation of mmget() in include/linux/sched/mm.h:
> > > 
> > >   * Never use this function to pin this address space for an
> > >   * unbounded/indefinite amount of time.
> > 
> > I wonder if everything would be simplified if we just allow the parent
> > to advertise whether or not it requires the address space.
> > 
> > Then when vhost-vDPA probes the device it can simply advertise
> > use_work as true so vhost core can use get_task_mm() in this case?
> 
> IIUC set user_worker to true, it also creates the kthread in the vhost
> core (but we can add another variable to avoid this).
> 
> My biggest concern is the comment in include/linux/sched/mm.h.
> get_task_mm() uses mmget(), but in the documentation they advise against
> pinning the address space indefinitely, so I preferred in keeping
> mmgrab() in the vhost core, then call mmget_not_zero() in the worker
> only when it is running.
> 
> In the future maybe mm will be used differently from parent if somehow
> it is supported by iommu, so I would leave it to the parent to handle
> this.
> 
> Thanks,
> Stefano

I think iommufd is supposed to handle all this detail, yes.

