Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B535369C432
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 03:38:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBTCiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 21:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjBTCiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 21:38:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4C7E046
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 18:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676860651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Z4mF9eRLWUighxaWu/WlNqJCc0pM0J+zyyIk2SE2gxU=;
        b=fPygkbLALlk+6ukzBEvSJLsPhuqYnNPH0N7bl7BG0m0F3E6y+Pfob4gWdaTJz9lCvJobxG
        fLG5thQGVgd5lqzmTEaK+4VJqNjDNVV5AqTmIVNbM6TxWm8X8UXf6x9VIgJMcbcNqKkxoW
        PWh5hg2L2e56X4rdY32ZSAVN2Bs/ppo=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-41-Wkbi72_eMROb0DnvHo3_gg-1; Sun, 19 Feb 2023 21:37:30 -0500
X-MC-Unique: Wkbi72_eMROb0DnvHo3_gg-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-171e3493967so277583fac.10
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 18:37:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z4mF9eRLWUighxaWu/WlNqJCc0pM0J+zyyIk2SE2gxU=;
        b=s7PupfGKsyItHBQ6mCk9M1dbyc2v6tRXj//pLD3LuglcME9E3sIdCEulytlM0Y9mZs
         RjNAF9OHsZU76s7lxIVRy9qwcaLKnKz7SBveZWKzHaqT30jJ+ht7t4nfJEfpEMhqoEba
         4RjdG8YdWRKuhnrsLlpacmC6GT7Mdur+PBhBKhSeyMp7kpRKqAJsxYIX9D2Yt2aciHl7
         fws30dDnwxzeh0+Apbr0D32tDnrIwOWWzNPPOCubpEQEyvmTkcT0hWKgm8v0eMmMGKPk
         7H78LLsAZ5nq0NNsz3+CZ1YcMRifzHzV6nyEeXaPdiG42+eYEPfDjdv2OZKwy+pYBZ0d
         vUdg==
X-Gm-Message-State: AO0yUKVkaTYYYxqNIWkZuGi9rZmU4eHK+92KE+8eZhC/3qy/LIMF0KcV
        0Q/E2+Yw44O/nH0XU2mBDdLuKIbjadwAL6G0IshaM0d8jGqW3Olp94XJzlCY5bqrdGm7fnUCuxW
        NdGGVloULPxDKcEYy72PObBAyHC+h3VDc
X-Received: by 2002:a05:6870:e309:b0:16a:cfba:d187 with SMTP id z9-20020a056870e30900b0016acfbad187mr57935oad.2.1676860649431;
        Sun, 19 Feb 2023 18:37:29 -0800 (PST)
X-Google-Smtp-Source: AK7set8SJitLQ9LUE3u1syC+o7Uv38TErayt/RAfp5Ui0lrmlYgjeBjytjXtpn+4L/G0i6tLLMj766NjBhCbz614fY0=
X-Received: by 2002:a05:6870:e309:b0:16a:cfba:d187 with SMTP id
 z9-20020a056870e30900b0016acfbad187mr57932oad.2.1676860649055; Sun, 19 Feb
 2023 18:37:29 -0800 (PST)
MIME-Version: 1.0
References: <20230207120843.1580403-1-sunnanyong@huawei.com>
 <Y+7G+tiBCjKYnxcZ@nvidia.com> <20230217051158-mutt-send-email-mst@kernel.org> <Y+92c9us3HVjO2Zq@nvidia.com>
In-Reply-To: <Y+92c9us3HVjO2Zq@nvidia.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 20 Feb 2023 10:37:18 +0800
Message-ID: <CACGkMEsVBhxtpUFs7TrQzAecO8kK_NR+b1EvD2H7MjJ+2aEKJw@mail.gmail.com>
Subject: Re: [PATCH v2] vhost/vdpa: Add MSI translation tables to iommu for
 software-managed MSI
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Nanyong Sun <sunnanyong@huawei.com>, joro@8bytes.org,
        will@kernel.org, robin.murphy@arm.com, iommu@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        wangrong68@huawei.com, Cindy Lu <lulu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 17, 2023 at 8:43 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Fri, Feb 17, 2023 at 05:12:29AM -0500, Michael S. Tsirkin wrote:
> > On Thu, Feb 16, 2023 at 08:14:50PM -0400, Jason Gunthorpe wrote:
> > > On Tue, Feb 07, 2023 at 08:08:43PM +0800, Nanyong Sun wrote:
> > > > From: Rong Wang <wangrong68@huawei.com>
> > > >
> > > > Once enable iommu domain for one device, the MSI
> > > > translation tables have to be there for software-managed MSI.
> > > > Otherwise, platform with software-managed MSI without an
> > > > irq bypass function, can not get a correct memory write event
> > > > from pcie, will not get irqs.
> > > > The solution is to obtain the MSI phy base address from
> > > > iommu reserved region, and set it to iommu MSI cookie,
> > > > then translation tables will be created while request irq.
> > >
> > > Probably not what anyone wants to hear, but I would prefer we not add
> > > more uses of this stuff. It looks like we have to get rid of
> > > iommu_get_msi_cookie() :\
> > >
> > > I'd like it if vdpa could move to iommufd not keep copying stuff from
> > > it..
> >
> > Absolutely but when is that happening?
>
> Don't know, I think it has to come from the VDPA maintainers, Nicolin
> made some drafts but wasn't able to get it beyond that.

Cindy (cced) will carry on the work.

Thanks

>
> Please have people who need more iommu platform enablement to pick it
> up instead of merging hacks like this..
>
> We are very close to having nested translation on ARM so anyone who is
> serious about VDPA on ARM is going to need iommufd anyhow.
>
> Jason
>

