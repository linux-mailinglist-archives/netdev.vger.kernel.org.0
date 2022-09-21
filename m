Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E116E5BF35B
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 04:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIUCPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 22:15:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIUCO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 22:14:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E16F30F62
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663726495;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=j9P+rGLJHapFEFbIQqvk7PpMo3XqXvFcVFCgGvvB/1Q=;
        b=ieKe3MWm86we9gaMJTRqKUJXkZ3qdRSW2RdgWQQ/6GyTBn3NWA6QwqQIFo/dpUJO7sBpYw
        kScHLsUHpjmLf08sy+MF4D2ur20rJcE/QXljPmudyFIa+1hiZrT7NxogeFd8ruj+5tPUug
        ylPgjxz8xp4jeLYP+JnBZvTUhYDsy1Y=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-649-Q9L_rFFmPRW4yyC48MlUxg-1; Tue, 20 Sep 2022 22:14:53 -0400
X-MC-Unique: Q9L_rFFmPRW4yyC48MlUxg-1
Received: by mail-ot1-f72.google.com with SMTP id t4-20020a9d7484000000b006585c2ad6a0so2293151otk.9
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 19:14:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=j9P+rGLJHapFEFbIQqvk7PpMo3XqXvFcVFCgGvvB/1Q=;
        b=F/fuKDBXTCWKwWUg4mYPYaAClcpL9LICNRI0XxWLpqGAYE8LRGpjBmCeoGUY2ztnpV
         GUU8fJsMJD/QY+2gatDxcJdBnNdvnTswQRoRWG/+RvNQl9TFCCTMOV7ZuQ5VPD5hPDC/
         R2UX+M7LfdzIcRstg0upSAwquLfeBs4xivA2x5m1f8NPBQzvRrg9srfKl5Q+aZLVQ3Jm
         eumURGLtObf7bIrp+T0Lz/YyvKT7GHi20NmS4GtHBze5QQDxDc5iFyv5grxWNysQCWL5
         WtBkXBU0Jqe1gPWVim1uRjBHFXtFpDqitvXH6LQKM/Uf68yjf23+ir0JNR5UOsJcRjYg
         PFtQ==
X-Gm-Message-State: ACrzQf3UgVcZyzrPFvlfCEcxBf+4mSrsMIZqDU5GM0kgxuk2FCSctDQD
        2co1ljbpUhW3y5kKI8Zt6CU1mdkLoVaB/emYxyGOQdYquuxoAKWfxcXE0mCJnGTqmMQGVVJYK3a
        oNhx6yW1DfWJ0JCUgaGMgHyZWZPUqbNs3
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id bx34-20020a0568081b2200b00350c0f670ffmr2863380oib.35.1663726493132;
        Tue, 20 Sep 2022 19:14:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4OeG5pl5c1sj5sNO3PI4GwxWvbIOCE9z6qMMFenIcaCHhKx9wT6EV+LsxBQsF9TM10MuzNear2uxgAJeKNqAA=
X-Received: by 2002:a05:6808:1b22:b0:350:c0f6:70ff with SMTP id
 bx34-20020a0568081b2200b00350c0f670ffmr2863373oib.35.1663726492903; Tue, 20
 Sep 2022 19:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220909085712.46006-1-lingshan.zhu@intel.com>
 <20220909085712.46006-3-lingshan.zhu@intel.com> <CACGkMEsYARr3toEBTxVcwFi86JxK0D-w4OpNtvVdhCEbAnc8ZA@mail.gmail.com>
 <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com>
In-Reply-To: <6fd1f8b3-23b1-84cc-2376-ee04f1fa8438@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 21 Sep 2022 10:14:41 +0800
Message-ID: <CACGkMEuusM3EMmWW6+q8V1fZscfjM2R9n7jGefUnSY59UnZDYQ@mail.gmail.com>
Subject: Re: [PATCH 2/4] vDPA: only report driver features if FEATURES_OK is set
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 20, 2022 at 1:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 9/20/2022 10:16 AM, Jason Wang wrote:
> > On Fri, Sep 9, 2022 at 5:05 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >> vdpa_dev_net_config_fill() should only report driver features
> >> to userspace after features negotiation is done.
> >>
> >> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >> ---
> >>   drivers/vdpa/vdpa.c | 13 +++++++++----
> >>   1 file changed, 9 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> >> index 798a02c7aa94..29d7e8858e6f 100644
> >> --- a/drivers/vdpa/vdpa.c
> >> +++ b/drivers/vdpa/vdpa.c
> >> @@ -819,6 +819,7 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>          struct virtio_net_config config = {};
> >>          u64 features_device, features_driver;
> >>          u16 val_u16;
> >> +       u8 status;
> >>
> >>          vdev->config->get_config(vdev, 0, &config, sizeof(config));
> >>
> >> @@ -834,10 +835,14 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> >>          if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >>                  return -EMSGSIZE;
> >>
> >> -       features_driver = vdev->config->get_driver_features(vdev);
> >> -       if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >> -                             VDPA_ATTR_PAD))
> >> -               return -EMSGSIZE;
> >> +       /* only read driver features after the feature negotiation is done */
> >> +       status = vdev->config->get_status(vdev);
> >> +       if (status & VIRTIO_CONFIG_S_FEATURES_OK) {
> > Any reason this is not checked in its caller as what it used to do before?
> will check the existence of vdev->config->get_status before calling it in V2

Just to clarify, I meant to check FEAUTRES_OK in the caller -
vdpa_dev_config_fill() otherwise each type needs to repeat this in
their specific codes.

Thanks

>
> Thanks,
> Zhu Lingshan
> >
> > Thanks
> >
> >> +               features_driver = vdev->config->get_driver_features(vdev);
> >> +               if (nla_put_u64_64bit(msg, VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features_driver,
> >> +                                     VDPA_ATTR_PAD))
> >> +                       return -EMSGSIZE;
> >> +       }
> >>
> >>          features_device = vdev->config->get_device_features(vdev);
> >>
> >> --
> >> 2.31.1
> >>
>

