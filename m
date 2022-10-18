Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC6AF602626
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 09:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbiJRHuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 03:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJRHt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 03:49:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943CC4F1AB
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666079395;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vRh41W0p6wgS8aUz+pcIKRc5TuBXWZLASuuxasU5Wtc=;
        b=C8NL1I14MddwDfLcgXN+qKb/aHvLfruL063ghwDgN2W1ZZFmFZAYfBawR3655t5pOofZ8B
        WuXElh+7y8wOfhVPQxgk7BagYU4TGuyGytGov3vJdFwWaV50ND7dqFzlMwVYsJq0KrWxZT
        PZ0MBC9zKYUXZk+1NWJuACvIvdBxkSs=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-269-RJAWgA8OOyuE8AMa5VBCtg-1; Tue, 18 Oct 2022 03:49:54 -0400
X-MC-Unique: RJAWgA8OOyuE8AMa5VBCtg-1
Received: by mail-oo1-f71.google.com with SMTP id t10-20020a4a760a000000b004809c721ac0so5691918ooc.4
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 00:49:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vRh41W0p6wgS8aUz+pcIKRc5TuBXWZLASuuxasU5Wtc=;
        b=notI4XFb+uf5dioT5Q+hu2scYSnOxywZTdwNHe0qCyY+Okfy0z37+girPwDPbg+Z0Q
         8dNLLJVQGA5dmb9P7s468Ly+HSXuILuXyrehfu6nxjDZPCsLOioF6OanZZ1kDTfimuEw
         H/VnNOYYqWoNHRjtwUyD3cHIDvX8mIuzFdy8dLyglc4dGIoiB3BG46wyj+OwQjeRhycI
         AqUzJMyrVuVuu8nIb1s8KPuxK7qMRKjw+UU80G0Czta5Nx1qu8O/6XA9IlSRWO+FNEMu
         meAfdeH9BG9gBhWDB4q/CsDLl5+rz3LTMURXX8gF+pAUFTNXdXuAyJeUP2lqbaN4miTO
         GcJA==
X-Gm-Message-State: ACrzQf3y9kDHk1lwZ441cOZl1/+nZO8Xyl0aPr0fHilx7/1cwZuG9RWZ
        yav7mcS7A5kPoUaYL5ITpsKO8SaduNtJwbdcgDewWwVWK4kSV5BWlcseHx/uLDy0sn7nGOWqdKw
        ZkNFHj2XCBUxjZv7kk7WK7d1UcDpEJglc
X-Received: by 2002:a05:6870:c1d3:b0:136:c4f6:53af with SMTP id i19-20020a056870c1d300b00136c4f653afmr17168043oad.35.1666079393800;
        Tue, 18 Oct 2022 00:49:53 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7CZ/POHfxa7P4D4V3Z0ppOI3n6PrdUk6j+3MR9atBP0ebqNqKjdst4QpmFZ6wxXFSRH17zWlPcT0uQFcKmhko=
X-Received: by 2002:a05:6870:c1d3:b0:136:c4f6:53af with SMTP id
 i19-20020a056870c1d300b00136c4f653afmr17168038oad.35.1666079393570; Tue, 18
 Oct 2022 00:49:53 -0700 (PDT)
MIME-Version: 1.0
References: <20221014094152.5570-1-lingshan.zhu@intel.com> <CACGkMEu_pKJukgKuPbTksfemRrfFCb9qbu0iVDKx0O8HL-8q1w@mail.gmail.com>
 <CACGkMEsCbpCBtABW4qhpZhQ4Dg=tt4ZTiL=_WpUXehcPT+e4qQ@mail.gmail.com>
 <954aa373-11a9-5cad-0ed7-4b97688720ba@intel.com> <CACGkMEt=dOwSHB+gJ1wJjwR51wWZgVG561wcWWZqp-Upt5kYGA@mail.gmail.com>
 <91af1513-f3c7-9d25-ed0c-0639c7395f6a@intel.com> <CACGkMEtRd3pmN-rYj1LMsckTkNaqHFH7xkdccBK1Z9xzRo9KZw@mail.gmail.com>
 <aca0930e-4599-d3a6-fb5c-74f7223f07a9@intel.com>
In-Reply-To: <aca0930e-4599-d3a6-fb5c-74f7223f07a9@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Tue, 18 Oct 2022 15:49:42 +0800
Message-ID: <CACGkMEt=cidT7ioC7jMa8qQjPb9UKHLStB+jZyUks_SWoYhmDw@mail.gmail.com>
Subject: Re: [PATCH] iproute2/vdpa: Add support for reading device features
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     mst@redhat.com, stephen@networkplumber.org, dsahern@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        hang.yuan@intel.com, Si-Wei Liu <si-wei.liu@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLACK autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 3:46 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
>
>
>
> On 10/18/2022 3:30 PM, Jason Wang wrote:
> > On Tue, Oct 18, 2022 at 3:28 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>
> >>
> >> On 10/18/2022 2:44 PM, Jason Wang wrote:
> >>> On Tue, Oct 18, 2022 at 10:20 AM Zhu, Lingshan <lingshan.zhu@intel.com> wrote:
> >>>>
> >>>> On 10/17/2022 3:13 PM, Jason Wang wrote:
> >>>>> On Mon, Oct 17, 2022 at 3:13 PM Jason Wang <jasowang@redhat.com> wrote:
> >>>>>> On Fri, Oct 14, 2022 at 5:50 PM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
> >>>>>>> This commit implements support for reading vdpa device
> >>>>>>> features in iproute2.
> >>>>>>>
> >>>>>>> Example:
> >>>>>>> $ vdpa dev config show vdpa0
> >>>>>>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 4 mtu 1500
> >>>>>>>      negotiated_features MRG_RXBUF CTRL_VQ MQ VERSION_1 ACCESS_PLATFORM
> >>>>>>>      dev_features MTU MAC MRG_RXBUF CTRL_VQ MQ ANY_LAYOUT VERSION_1 ACCESS_PLATFORM
> >>>>>>>
> >>>>>>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>>>>> Note that Si Wei proposed to unify the two new attributes:
> >>>>> https://patchew.org/linux/1665422823-18364-1-git-send-email-si-wei.liu@oracle.com/
> >>>> I think we have discussed this before, there should be two netlink
> >>>> attributes to report management device features and vDPA device features,
> >>>> they are different type of devices, this unification introduces
> >>>> unnecessary couplings
> >>> I suggest going through the above patch, both attributes are for the
> >>> vDPA device only.
> >> It seems not vDPA device only, from above patch, we see it re-uses
> >> VDPA_ATTR_DEV_FEATURES for reporting vDPA device features
> > Yes, anything wrong with this? The device features could be
> > provisioned via netlink.
> I think the best netlink practice is to let every attr has its own
> and unique purpose, to prevent potential bugs. I think we have discussed
> this before that re-using
> an attr does not save any resource.

They have exactly the same semantic which is the device features for vDPA.

VDPA_ATTR_DEV_FEATURES is introduced by my features provisioning
series, which is used for the userspace to "set" the device features.
VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES is introduced in one of your
previous patches, which is used for userspace to "get" the device
features.

>
> And iprout2 has already updated the uapi header.

Yes, but iproute2 has the same schedule as kernel release, so it's not
too late to fix.

Thanks

>
> Thanks
> >
> > Thanks
> >
> >> Thanks
> >>> Thanks
> >>>
> >>>> Thanks
> >>>>> Thanks
> >>>>>
> >>>>>>> ---
> >>>>>>>     vdpa/vdpa.c | 15 +++++++++++++--
> >>>>>>>     1 file changed, 13 insertions(+), 2 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> >>>>>>> index b73e40b4..89844e92 100644
> >>>>>>> --- a/vdpa/vdpa.c
> >>>>>>> +++ b/vdpa/vdpa.c
> >>>>>>> @@ -87,6 +87,8 @@ static const enum mnl_attr_data_type vdpa_policy[VDPA_ATTR_MAX + 1] = {
> >>>>>>>            [VDPA_ATTR_DEV_NEGOTIATED_FEATURES] = MNL_TYPE_U64,
> >>>>>>>            [VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] = MNL_TYPE_U32,
> >>>>>>>            [VDPA_ATTR_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >>>>>>> +       [VDPA_ATTR_DEV_FEATURES] = MNL_TYPE_U64,
> >>>>>>> +       [VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES] = MNL_TYPE_U64,
> >>>>>>>     };
> >>>>>>>
> >>>>>>>     static int attr_cb(const struct nlattr *attr, void *data)
> >>>>>>> @@ -482,7 +484,7 @@ static const char * const *dev_to_feature_str[] = {
> >>>>>>>
> >>>>>>>     #define NUM_FEATURE_BITS 64
> >>>>>>>
> >>>>>>> -static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >>>>>>> +static void print_features(struct vdpa *vdpa, uint64_t features, bool devf,
> >>>>>>>                               uint16_t dev_id)
> >>>>>>>     {
> >>>>>>>            const char * const *feature_strs = NULL;
> >>>>>>> @@ -492,7 +494,7 @@ static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> >>>>>>>            if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> >>>>>>>                    feature_strs = dev_to_feature_str[dev_id];
> >>>>>>>
> >>>>>>> -       if (mgmtdevf)
> >>>>>>> +       if (devf)
> >>>>>>>                    pr_out_array_start(vdpa, "dev_features");
> >>>>>>>            else
> >>>>>>>                    pr_out_array_start(vdpa, "negotiated_features");
> >>>>>>> @@ -771,6 +773,15 @@ static void pr_out_dev_net_config(struct vdpa *vdpa, struct nlattr **tb)
> >>>>>>>                    val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_DEV_NEGOTIATED_FEATURES]);
> >>>>>>>                    print_features(vdpa, val_u64, false, dev_id);
> >>>>>>>            }
> >>>>>>> +       if (tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]) {
> >>>>>>> +               uint16_t dev_id = 0;
> >>>>>>> +
> >>>>>>> +               if (tb[VDPA_ATTR_DEV_ID])
> >>>>>>> +                       dev_id = mnl_attr_get_u32(tb[VDPA_ATTR_DEV_ID]);
> >>>>>>> +
> >>>>>>> +               val_u64 = mnl_attr_get_u64(tb[VDPA_ATTR_VDPA_DEV_SUPPORTED_FEATURES]);
> >>>>>>> +               print_features(vdpa, val_u64, true, dev_id);
> >>>>>>> +       }
> >>>>>>>     }
> >>>>>>>
> >>>>>>>     static void pr_out_dev_config(struct vdpa *vdpa, struct nlattr **tb)
> >>>>>>> --
> >>>>>>> 2.31.1
> >>>>>>>
>

