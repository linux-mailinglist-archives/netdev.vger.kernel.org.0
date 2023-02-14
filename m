Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47783695998
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 08:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbjBNHFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 02:05:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbjBNHFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 02:05:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 190CD1DBB2
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:05:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676358303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K4q3ZOUtLgcz08YCMzP/3RHQNhlZSfQVVlPbPjliwbo=;
        b=HlY+CFKOTx7wS9sOVXr4LNqI1cugqo3RPjMRss8xhTguSJFjmEiO8DAsUjR+BrS1zAsS++
        +IRv189Xewe7B14cBbNs95GgjT6HetKEdCn4nXuzm0EbWg09gF6HR0jb9arCUY/O40jZne
        YQVaaPvlIM1uQA3LSe0qq+IA6CfuwVM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-596-8jgRenrqOCa0N0BG0VJB5g-1; Tue, 14 Feb 2023 02:05:01 -0500
X-MC-Unique: 8jgRenrqOCa0N0BG0VJB5g-1
Received: by mail-wm1-f71.google.com with SMTP id bi16-20020a05600c3d9000b003dfeeaa8143so7331024wmb.6
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 23:05:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K4q3ZOUtLgcz08YCMzP/3RHQNhlZSfQVVlPbPjliwbo=;
        b=PLxH2bOksX4LZ5c+6cZ4HqWS4mb3m7LOMthWrlSHELl7AXr1aabGNYbOwVXZNGi0xk
         ghumeDPsd/xxtCneNh1AnjZ2ImXzWZyBEq7He7NCVEhi/cduaSjx+i1vMWx0naDaRI+2
         kPzVAv6stkONgF6L7s2uoFYxOKCVOTT5As9LzWmtgUx5n8AgtLngxsdHheEdfKOU/r/I
         Ns856I6YuL0tQqBMK6lHszTXUvWjmzLQpEuQkQoCMjWGoMp5/mjXVkcV4EU8OeZqNK/O
         ACgRy8dE3iWcq8iW4sSIQLYqNhcDtHSlSlKrKDobe8UJGqd+IPKZRHxAq2mxCLODQwPg
         EJJA==
X-Gm-Message-State: AO0yUKWiSizR8Go6rF/WxFrZT3vZD0oI8yu3P+aGCms/o8rSsp6iKqrA
        klEJ7lhYDRzoFIPYPg7tWT1seEBncKP+HQtyDOoRJp9+dgz8Qipjw/Ykv3AF24lPVeyxp5+ixW1
        Ji90Ixw++dQgbFPTfBedg2BqXvdPu1KxW
X-Received: by 2002:a5d:6687:0:b0:2c5:4c7d:b32e with SMTP id l7-20020a5d6687000000b002c54c7db32emr28270wru.111.1676358300811;
        Mon, 13 Feb 2023 23:05:00 -0800 (PST)
X-Google-Smtp-Source: AK7set9NwwUZJZcSgMe5GePtOrKP0+CEYzCYjvgzm6gRH8DV0a5JQH/LCJZ/vHtMrACTUdKsHqwFs3ysk8rsxU98qBo=
X-Received: by 2002:a5d:6687:0:b0:2c5:4c7d:b32e with SMTP id
 l7-20020a5d6687000000b002c54c7db32emr28268wru.111.1676358300510; Mon, 13 Feb
 2023 23:05:00 -0800 (PST)
MIME-Version: 1.0
References: <20230214061743.114257-1-lulu@redhat.com> <CACGkMEtFbxRqJZiho+kxZqziTXLFm5ySfubdAKJf-+eE-wprvw@mail.gmail.com>
In-Reply-To: <CACGkMEtFbxRqJZiho+kxZqziTXLFm5ySfubdAKJf-+eE-wprvw@mail.gmail.com>
From:   Cindy Lu <lulu@redhat.com>
Date:   Tue, 14 Feb 2023 15:04:21 +0800
Message-ID: <CACLfguWLhO3r91CSfORN3ZStezdfEOBHxCRNp_qxcuyo7JyFYQ@mail.gmail.com>
Subject: Re: [PATCH] vp_vdpa: fix the crash in hot unplug with vp_vdpa
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 at 14:24, Jason Wang <jasowang@redhat.com> wrote:
>
> On Tue, Feb 14, 2023 at 2:17 PM Cindy Lu <lulu@redhat.com> wrote:
> >
> > While unplugging the vp_vdpa device, the kernel will crash
> > The root cause is the function vp_modern_get_status() called following the
> > vp_modern_remove().
>
> This needs some tweaking, maybe it's better to say
> vdpa_mgmtdev_unregister() will access modern devices which will cause
> a use after free.
>
> >So need to change the sequence in vp_vdpa_remove
> >
> > [  195.016001] Call Trace:
>
> Let's paste the full log with the reason for the calltrace (e.g
> general protection fault or whatever else).
>
sure, will post a new version
Thanks
Cindy
> > [  195.016233]  <TASK>
> > [  195.016434]  vp_modern_get_status+0x12/0x20
> > [  195.016823]  vp_vdpa_reset+0x1b/0x50 [vp_vdpa]
> > [  195.017238]  virtio_vdpa_reset+0x3c/0x48 [virtio_vdpa]
> > [  195.017709]  remove_vq_common+0x1f/0x3a0 [virtio_net]
> > [  195.018178]  virtnet_remove+0x5d/0x70 [virtio_net]
> > [  195.018618]  virtio_dev_remove+0x3d/0x90
> > [  195.018986]  device_release_driver_internal+0x1aa/0x230
> > [  195.019466]  bus_remove_device+0xd8/0x150
> > [  195.019841]  device_del+0x18b/0x3f0
> > [  195.020167]  ? kernfs_find_ns+0x35/0xd0
> > [  195.020526]  device_unregister+0x13/0x60
> > [  195.020894]  unregister_virtio_device+0x11/0x20
> > [  195.021311]  device_release_driver_internal+0x1aa/0x230
> > [  195.021790]  bus_remove_device+0xd8/0x150
> > [  195.022162]  device_del+0x18b/0x3f0
> > [  195.022487]  device_unregister+0x13/0x60
> > [  195.022852]  ? vdpa_dev_remove+0x30/0x30 [vdpa]
> > [  195.023270]  vp_vdpa_dev_del+0x12/0x20 [vp_vdpa]
> > [  195.023694]  vdpa_match_remove+0x2b/0x40 [vdpa]
> > [  195.024115]  bus_for_each_dev+0x78/0xc0
> > [  195.024471]  vdpa_mgmtdev_unregister+0x65/0x80 [vdpa]
> > [  195.024937]  vp_vdpa_remove+0x23/0x40 [vp_vdpa]
> > [  195.025353]  pci_device_remove+0x36/0xa0
> > [  195.025719]  device_release_driver_internal+0x1aa/0x230
> > [  195.026201]  pci_stop_bus_device+0x6c/0x90
> > [  195.026580]  pci_stop_and_remove_bus_device+0xe/0x20
> > [  195.027039]  disable_slot+0x49/0x90
> > [  195.027366]  acpiphp_disable_and_eject_slot+0x15/0x90
> > [  195.027832]  hotplug_event+0xea/0x210
> > [  195.028171]  ? hotplug_event+0x210/0x210
> > [  195.028535]  acpiphp_hotplug_notify+0x22/0x80
> > [  195.028942]  ? hotplug_event+0x210/0x210
> > [  195.029303]  acpi_device_hotplug+0x8a/0x1d0
> > [  195.029690]  acpi_hotplug_work_fn+0x1a/0x30
> > [  195.030077]  process_one_work+0x1e8/0x3c0
> > [  195.030451]  worker_thread+0x50/0x3b0
> > [  195.030791]  ? rescuer_thread+0x3a0/0x3a0
> > [  195.031165]  kthread+0xd9/0x100
> > [  195.031459]  ? kthread_complete_and_exit+0x20/0x20
> > [  195.031899]  ret_from_fork+0x22/0x30
> > [  195.032233]  </TASK>
> >
> > Fixes: ffbda8e9df10 ("vdpa/vp_vdpa : add vdpa tool support in vp_vdpa")
> > Tested-by: Lei Yang <leiyang@redhat.com>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Cindy Lu <lulu@redhat.com>
>
> Other than above,
>
> Acked-by: Jason Wang <jasowang@redhat.com>
>
> Thanks
>
> > ---
> >  drivers/vdpa/virtio_pci/vp_vdpa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> > index 8fe267ca3e76..281287fae89f 100644
> > --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> > +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> > @@ -645,8 +645,8 @@ static void vp_vdpa_remove(struct pci_dev *pdev)
> >         struct virtio_pci_modern_device *mdev = NULL;
> >
> >         mdev = vp_vdpa_mgtdev->mdev;
> > -       vp_modern_remove(mdev);
> >         vdpa_mgmtdev_unregister(&vp_vdpa_mgtdev->mgtdev);
> > +       vp_modern_remove(mdev);
> >         kfree(vp_vdpa_mgtdev->mgtdev.id_table);
> >         kfree(mdev);
> >         kfree(vp_vdpa_mgtdev);
> > --
> > 2.34.3
> >
>

