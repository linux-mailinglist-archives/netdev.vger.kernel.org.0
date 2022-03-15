Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64284D97D0
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 10:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346732AbiCOJja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 05:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346713AbiCOJjW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 05:39:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B17881AF2E
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647337089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=K47SKj8REwLbfMI9yH8wvkO0kp+/XEGwzSW8IdK+acE=;
        b=c1A0l369zQdmVbC2Yltu3jIHeUdZSSwx/Wx9FNWxFfsCI1f6MyD0ikY0tAgAAnJwhLkeNN
        39JSCClQNjdJsvVNtwec0yDqJucCbd3iF12AmQFqV56ONmxyqIU/RP3OjpIit1YihheP+T
        pNquQGsce4m11vzpcn7kmahoTFa6RDM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-30-NwtFEt7eP4GpyhThrk-VBg-1; Tue, 15 Mar 2022 05:38:08 -0400
X-MC-Unique: NwtFEt7eP4GpyhThrk-VBg-1
Received: by mail-qk1-f199.google.com with SMTP id 68-20020a370847000000b0067e0cd1c855so461535qki.4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 02:38:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K47SKj8REwLbfMI9yH8wvkO0kp+/XEGwzSW8IdK+acE=;
        b=QyzND6TN92hoRFmrkM/tjubFij/UnNxZJiVy5yr0fBaLzmAZvRt9eAXrQB0e2o6JZh
         wDV8tomy3vDHgelHJcI6DFS28p4R3X+jP2fMHFuY6CbJVcJ7PCad3gAVZDn74ozsaLr9
         Unktc+hx+uRfLuKUmeuyoyOQ3EBcu71mknUJ9U3riTRepVxxw3d/jBUkI/h45+R/OLFU
         nFBL10xS8lECgF+PI8m7NAPgk5loXHspWTTj+9fd9FGh60cbmGbIERJnb2l+tjK55gpW
         EZg9gR1NwtJ5PcC8B820KeeXdwRCqykxK7RtDVoFKrUWcXeNUFSzPiSgvY5R0kKPCWgX
         9Azg==
X-Gm-Message-State: AOAM531+gGEdfMyDOydPzvukXbHjoLY6q6lv1bY32WpVS9dNplzN06Xv
        iK9VWze5SlVztoUtx+Cd6h4EdpNAed0/ohETqcvwgaPF/1SUPNpVROiFBVG8BdL4cYtrVAIHjtT
        wequuRws4uI+P378K
X-Received: by 2002:a05:6214:1c87:b0:42d:20cb:e484 with SMTP id ib7-20020a0562141c8700b0042d20cbe484mr19923067qvb.10.1647337087870;
        Tue, 15 Mar 2022 02:38:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhF9QDkgfvW6/9vLgmCoy3wh/Jj8hmyEKNU4aC+B4FAY1JaTiHxB1dMqDy5xYqVzFmJloaeA==
X-Received: by 2002:a05:6214:1c87:b0:42d:20cb:e484 with SMTP id ib7-20020a0562141c8700b0042d20cbe484mr19923055qvb.10.1647337087684;
        Tue, 15 Mar 2022 02:38:07 -0700 (PDT)
Received: from sgarzare-redhat (host-212-171-187-184.pool212171.interbusiness.it. [212.171.187.184])
        by smtp.gmail.com with ESMTPSA id s21-20020a05620a16b500b0067b1205878esm8908043qkj.7.2022.03.15.02.38.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 02:38:07 -0700 (PDT)
Date:   Tue, 15 Mar 2022 10:38:01 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Longpeng(Mike)" <longpeng2@huawei.com>
Cc:     stefanha@redhat.com, mst@redhat.com, jasowang@redhat.com,
        arei.gonglei@huawei.com, yechuan@huawei.com,
        huangzhichao@huawei.com, virtualization@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 1/3] vdpa: support exposing the config size to
 userspace
Message-ID: <20220315093801.ngyizwf7blkhutug@sgarzare-redhat>
References: <20220315032553.455-1-longpeng2@huawei.com>
 <20220315032553.455-2-longpeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220315032553.455-2-longpeng2@huawei.com>
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 15, 2022 at 11:25:51AM +0800, Longpeng(Mike) wrote:
>From: Longpeng <longpeng2@huawei.com>
>
>- GET_CONFIG_SIZE: return the size of the virtio config space.
>
>The size contains the fields which are conditional on feature
>bits.
>
>Acked-by: Jason Wang <jasowang@redhat.com>
>Signed-off-by: Longpeng <longpeng2@huawei.com>
>---
> drivers/vhost/vdpa.c       | 17 +++++++++++++++++
> include/linux/vdpa.h       |  3 ++-
> include/uapi/linux/vhost.h |  4 ++++
> 3 files changed, 23 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>index ec5249e..605c7ae 100644
>--- a/drivers/vhost/vdpa.c
>+++ b/drivers/vhost/vdpa.c
>@@ -355,6 +355,20 @@ static long vhost_vdpa_get_iova_range(struct vhost_vdpa *v, u32 __user *argp)
> 	return 0;
> }
>
>+static long vhost_vdpa_get_config_size(struct vhost_vdpa *v, u32 __user *argp)
>+{
>+	struct vdpa_device *vdpa = v->vdpa;
>+	const struct vdpa_config_ops *ops = vdpa->config;
>+	u32 size;
>+
>+	size = ops->get_config_size(vdpa);

get_config_size() returns a size_t, perhaps we could have a comment here 
where we say we don't expect there to be an overflow.

I don't have a strong opinion on this, and I wouldn't want to get you to 
repin just for that, so:

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

