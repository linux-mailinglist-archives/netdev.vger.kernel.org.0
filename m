Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7D74BE1B5
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377190AbiBUOAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 09:00:03 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377180AbiBUOAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 09:00:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 987E71A3A8
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645451978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RSVIW7WKSNU5PqfuEaIi9kuilnpf4QQg552O4p0c0vg=;
        b=GmXgH17TGHhSENGq8WSjHIERRMW94uF46QTGiPsYUaCvDG5YLTsWKQ29aGQWWUGzZ/kIMx
        AfzUFCQuJ01MdcpQ8L6ILh6plK83JZQPOZbJ8Vi+8S53wvM1+Iorrbqnc1DVwXQVDrOgAp
        kLqG/W7l3quEm38TELyoysrYUCVyfIk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-muKXmUxDMlKaqrq07DivSQ-1; Mon, 21 Feb 2022 08:59:36 -0500
X-MC-Unique: muKXmUxDMlKaqrq07DivSQ-1
Received: by mail-wm1-f70.google.com with SMTP id j39-20020a05600c1c2700b0037becd18addso4476635wms.4
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 05:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RSVIW7WKSNU5PqfuEaIi9kuilnpf4QQg552O4p0c0vg=;
        b=wFqDoo56M2Co1OB5u8Dut6jX/U12eb/rDfaubo9nBQd8+PQVrlXqcpZWze6rHd2+ZH
         3eUReg3JRUBmc19MQs3lP090ulRYlZnxPIQp0bTG5IDtXP7HTrVbEZwvZ6InpOL7awgS
         WyIiKAR2dJTKB8daPW2tfhmweCS9/YYG34tfqnpC/6WV2PvJcSYmhCmYx8PbR+aa+HfW
         HxhH0Y/yTQDQZJAhqSY6Hx3F04swAhXfDUQZoen57ONUMwduDmHBHPgnjnIwcJQCCE0y
         Y/lfzuIWQZKUulB/Govb9Rxm6BIvkLkvqxLyirUPRmLucKJN3Zw7+cF+kdwUMHzwS8tM
         +x6A==
X-Gm-Message-State: AOAM530Y+3Y1pvDxyu9VWnGmIbb/QMFPamTeNHuCZZy/6HFXg12xRKrJ
        4czu8cbBwY4v5rOV+GS7oHMWqV8/LM71PxCWPpJ/29qF8/2bkFNonl/yzILRofJVX7pT72eon6G
        /1cK0qcr1E3Ro+o1h
X-Received: by 2002:adf:9f4a:0:b0:1e3:1c28:c298 with SMTP id f10-20020adf9f4a000000b001e31c28c298mr15464348wrg.233.1645451975136;
        Mon, 21 Feb 2022 05:59:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxFnMEd+AorTKgUxxWlJ80t1TpsoeHG7oT0Zc9X8kQornxrzt1FVqy8lGYBIKPsefgfErXU1w==
X-Received: by 2002:adf:9f4a:0:b0:1e3:1c28:c298 with SMTP id f10-20020adf9f4a000000b001e31c28c298mr15464328wrg.233.1645451974972;
        Mon, 21 Feb 2022 05:59:34 -0800 (PST)
Received: from sgarzare-redhat (host-95-248-229-156.retail.telecomitalia.it. [95.248.229.156])
        by smtp.gmail.com with ESMTPSA id i13sm13512139wrp.87.2022.02.21.05.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Feb 2022 05:59:34 -0800 (PST)
Date:   Mon, 21 Feb 2022 14:59:30 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kernel list <linux-kernel@vger.kernel.org>,
        Mike Christie <michael.christie@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        kvm <kvm@vger.kernel.org>, Hillf Danton <hdanton@sina.com>
Subject: Re: [PATCH] vhost/vsock: don't check owner in vhost_vsock_stop()
 while releasing
Message-ID: <CAGxU2F6aMqTaNaeO7xChtf=veDJYtBjDRayRRYkZ_FOq4CYJWQ@mail.gmail.com>
References: <20220221114916.107045-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221114916.107045-1-sgarzare@redhat.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 12:49 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> vhost_vsock_stop() calls vhost_dev_check_owner() to check the device
> ownership. It expects current->mm to be valid.
>
> vhost_vsock_stop() is also called by vhost_vsock_dev_release() when
> the user has not done close(), so when we are in do_exit(). In this
> case current->mm is invalid and we're releasing the device, so we
> should clean it anyway.
>
> Let's check the owner only when vhost_vsock_stop() is called
> by an ioctl.
>
> Fixes: 433fc58e6bf2 ("VSOCK: Introduce vhost_vsock.ko")
> Cc: stable@vger.kernel.org
> Reported-by: syzbot+1e3ea63db39f2b4440e0@syzkaller.appspotmail.com
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vhost/vsock.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)

Reported-and-tested-by: syzbot+0abd373e2e50d704db87@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+3140b17cb44a7b174008@syzkaller.appspotmail.com

