Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C950B6024B3
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 08:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiJRGo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 02:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbiJRGo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 02:44:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E71915FF
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666075487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I20aA+WWYWIOWbVmcckEV2OoluAADGlb7gDJdyOmGv4=;
        b=bM0beFAMe6BPsYsSoenhNhYI2ppnjPGbpCXSqv3EPd3a5q8S7U9XRZyl7HlNLKyk21RM41
        QxV3vwrLqa3ZgCvJnRLcOm5RgjFhog/ZBukZJ5RLQXbuCXORyLhpAeC+sLWPnGbsAcCUVY
        e3MDNmxbgHd6gyj0zPfIR1R7AsQaH7s=
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com
 [209.85.160.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-516-amdxxCbhMD6TxVhcCFW8cA-1; Tue, 18 Oct 2022 02:44:45 -0400
X-MC-Unique: amdxxCbhMD6TxVhcCFW8cA-1
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-132693a4072so5555233fac.4
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 23:44:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I20aA+WWYWIOWbVmcckEV2OoluAADGlb7gDJdyOmGv4=;
        b=ikSqj68UXXhWExmMFKMl8uNK6IeVpRbzcf0at6mo5W4AlhX/wlx5RoQy26OLexH9ta
         egLU/DLoydT7GlK6yD3LLixhskW+bn355qvhwNXDI8lgzQOKHPx/ziklbsWuRc99UPP0
         JYmEqY4GuSJRco3ejUPrNdjAwYA1rXU2zOSN83G4VE5vrsJ2MT/9P50/eDmOBqs5YES2
         n2LEm6GCEVCWtuKo5UY3kkpcbUMMGzTbmvU8jFyZqfafmYkQLPzOTGyET1VjTPnoqi2X
         xcZOCfhVOlSaMInAtGo2mqJ5uVmndRG5p/58OOtCo1hCdvnVcr+RqmimEsviqhaOQXyK
         /Q1w==
X-Gm-Message-State: ACrzQf1U8m6ZIPbk4EFdtTgHN2galQKm23BKYsiuB+69Lw/W1GhjWvt4
        9qU9kbuqJ9qeTM3sUiOVZqzHFDiI1KYjotroGbFpfG60AQBtytHB1aDihzln3e1s6KCKtEgLDU8
        n7z8fIylp2IeYmBPfFQflSXvHWQt+2+LR
X-Received: by 2002:a05:6870:c1d3:b0:136:c4f6:53af with SMTP id i19-20020a056870c1d300b00136c4f653afmr17065975oad.35.1666075485138;
        Mon, 17 Oct 2022 23:44:45 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4Cddk2B14GoitomYNOIONW9L2vfvfkvMP3xytxXmrJjJ9vLK/u7E0HXBnkRfUKjbFx6dQdGWL0XHyM3dmll+Q=
X-Received: by 2002:a05:6870:c1d3:b0:136:c4f6:53af with SMTP id
 i19-20020a056870c1d300b00136c4f653afmr17065968oad.35.1666075484945; Mon, 17
 Oct 2022 23:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <20221014094152.5570-1-lingshan.zhu@intel.com> <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
 <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com> <954aa373-11a9-5cad-0ed7-4b97688720ba@intel.com>
In-Reply-To: <954aa373-11a9-5cad-0ed7-4b97688720ba@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 18 Oct 2022 14:44:33 +0800
Message-ID: <CACGkMEt=dOwSHB+gJ1wJjwR51wWZgVG561wcWWZqp-Upt5kYGA@mail.gmail.com>
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 10:20 AM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 10/17/2022 3:13 PM, Jason Wang wrote:
> > On Mon, Oct 17, 2022 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
> >> On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>> This commit implements support for reading vdpa device
> >>> features in iproute2.
> >>>
> >>> Example:
> >>> $ vdpa dev config show vdpa0
> >>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
> >>>    negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
> >>>    dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
> >>>
> >>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >> Note that Si Wei proposed to unify the two new attributes:
> > https://patchew.org/linux/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/
> I think we have discussed this before, there should be two netlink
> attributes to report management device features and vDPA device features,
> they are different type of devices, this unification introduces
> unnecessary couplings

I suggest going through the above patch, both attributes are for the
vDPA device only.

Thanks

>
> Thanks
> >
> > Thanks
> >
> >>
> >>> ---
> >>>   vdpa/vdpa.c | 15 +++++++++++++--
> >>>   1 file changed, 13 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> >>> index b73e40b4..89844e92 100644
> >>> --- a/vdpa/vdpa.c
> >>> +++ b/vdpa/vdpa.c
> >>> @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >>>          [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >>>          [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> >>>          [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >>> +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
> >>> +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >>>   };
> >>>
> >>>   static int attr_cb(const struct nlattr *attr, void *data)
> >>> @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
> >>>
> >>>   #define NUM_FEATURE_BITS 64
> >>>
> >>> -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >>> +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
> >>>                             uint16_t dev_id)
> >>>   {
> >>>          const char * const *feature_strs = NULL;
> >>> @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >>>          if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> >>>                  feature_strs = dev_to_feature_str[dev_id];
> >>>
> >>> -       if (mgmtdevf)
> >>> +       if (devf)
> >>>                  pr_out_array_start(vdpa, "dev_features");
> >>>          else
> >>>                  pr_out_array_start(vdpa, "negotiated_features");
> >>> @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >>>                  val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> >>>                  print_features(vdpa, val_u64, false, dev_id);
> >>>          }
> >>> +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
> >>> +               uint16_t dev_id = 0;
> >>> +
> >>> +               if (tb[VDPA_ATTR_DEV_ID])
> >>> +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> >>> +
> >>> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
> >>> +               print_features(vdpa, val_u64, true, dev_id);
> >>> +       }
> >>>   }
> >>>
> >>>   static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> >>> --
> >>> 2.31.1
> >>>
>

