Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF79583D87
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 13:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiG1Lf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 07:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234668AbiG1Lf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 07:35:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BC6784A827
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659008154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3glIxZaqq5f+8fsJCyQrd3AE4XUDNsGL8GSWslp2h18=;
        b=TcEYBaHig8JvFzwLhsdyCRpbG6V049TDu57JErxMi1nYcgBOHPOxrbBmOkm66oEzvyQxrs
        +FvdmA3bI4Qvp5qb3FKGThfMRe9ADBKj0UbxLgQ7e11NHJnaH8Xlov84kl5yVG/B6F7BVC
        +2EFU9R0/b0vUzQ6BgCPaixv2IHWBQ8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-99-kAubCjjxNYaNXKh-zUs5lw-1; Thu, 28 Jul 2022 07:35:51 -0400
X-MC-Unique: kAubCjjxNYaNXKh-zUs5lw-1
Received: by mail-wr1-f70.google.com with SMTP id q17-20020adfab11000000b0021e4c9ca970so310137wrc.20
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 04:35:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=3glIxZaqq5f+8fsJCyQrd3AE4XUDNsGL8GSWslp2h18=;
        b=oErordgQy82wxnhRN6LC/xsZ4g2yCyh233ISYzjKB7udIL+ow1Fp+YDFQ0CxuK6SoX
         jC+MlKRetWUPhtSOfPld9OZHaYpa1fPEaGeSGNoTjd3SEgiajI/y2stH78+5nJH18LhP
         NotJTqfzIPLDUMRVrbKN+4GRcgIagmehkAwazFWPRAwh2X2I7VyQvb+CwVfZQDiH+mxz
         OmXBC12eiZX0CJZAJTNT6v9+AjRmT5dGH4br03wciGP5/L3T+9vraChxXvn2Oc0MGz4Y
         L9kmbNDGxI3S9KAPiuO96Y4UbfAfwzzgkG7FwLJaxr9AYuwOyl9+6wD/9FXzmSjYcsgE
         6OZg==
X-Gm-Message-State: AJIora8x2R499bB960eErLOUav1eRPZuJypUHVTZUMyJX4348d0tNlIo
        o/9jC44wMb85wroI7V08Ene0oWiS7KOZ5mRAbJ1GufpRM8yK9u87t4QW24CY0eU/bGsmm9OYYUL
        Rpw2oZ00WGsXnEkRc
X-Received: by 2002:a5d:4a51:0:b0:21e:f85c:822 with SMTP id v17-20020a5d4a51000000b0021ef85c0822mr1837898wrs.453.1659008150524;
        Thu, 28 Jul 2022 04:35:50 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vx0lU2KLqoCgJu+RxA1icVdh+IT2crfqWruai2VCjvh6nenoVX9Rt/UwSpQ38O/enkBZPAoQ==
X-Received: by 2002:a5d:4a51:0:b0:21e:f85c:822 with SMTP id v17-20020a5d4a51000000b0021ef85c0822mr1837872wrs.453.1659008150209;
        Thu, 28 Jul 2022 04:35:50 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d594e000000b0021ec503075fsm811648wri.31.2022.07.28.04.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:35:49 -0700 (PDT)
Date:   Thu, 28 Jul 2022 07:35:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        Parav Pandit <parav@nvidia.com>, Eli Cohen <elic@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH V3 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220728070409-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-5-lingshan.zhu@intel.com>
 <PH0PR12MB548190DE76CC64E56DA2DF13DCBD9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <00889067-50ac-d2cd-675f-748f171e5c83@oracle.com>
 <63242254-ba84-6810-dad8-34f900b97f2f@intel.com>
 <8002554a-a77c-7b25-8f99-8d68248a741d@oracle.com>
 <c8bd5396-84f2-e782-79d7-f493aca95781@redhat.com>
 <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3fd203d-a3ad-4c36-ddbc-01f061f4f99e@oracle.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 12:08:53AM -0700, Si-Wei Liu wrote:
> 
> 
> On 7/27/2022 7:06 PM, Jason Wang wrote:
> > 
> > 在 2022/7/28 08:56, Si-Wei Liu 写道:
> > > 
> > > 
> > > On 7/27/2022 4:47 AM, Zhu, Lingshan wrote:
> > > > 
> > > > 
> > > > On 7/27/2022 5:43 PM, Si-Wei Liu wrote:
> > > > > Sorry to chime in late in the game. For some reason I
> > > > > couldn't get to most emails for this discussion (I only
> > > > > subscribed to the virtualization list), while I was taking
> > > > > off amongst the past few weeks.
> > > > > 
> > > > > It looks to me this patch is incomplete. Noted down the way
> > > > > in vdpa_dev_net_config_fill(), we have the following:
> > > > >          features = vdev->config->get_driver_features(vdev);
> > > > >          if (nla_put_u64_64bit(msg,
> > > > > VDPA_ATTR_DEV_NEGOTIATED_FEATURES, features,
> > > > >                                VDPA_ATTR_PAD))
> > > > >                  return -EMSGSIZE;
> > > > > 
> > > > > Making call to .get_driver_features() doesn't make sense
> > > > > when feature negotiation isn't complete. Neither should
> > > > > present negotiated_features to userspace before negotiation
> > > > > is done.
> > > > > 
> > > > > Similarly, max_vqp through vdpa_dev_net_mq_config_fill()
> > > > > probably should not show before negotiation is done - it
> > > > > depends on driver features negotiated.
> > > > I have another patch in this series introduces device_features
> > > > and will report device_features to the userspace even features
> > > > negotiation not done. Because the spec says we should allow
> > > > driver access the config space before FEATURES_OK.
> > > The config space can be accessed by guest before features_ok doesn't
> > > necessarily mean the value is valid.
> > 
> > 
> > It's valid as long as the device offers the feature:
> > 
> > "The device MUST allow reading of any device-specific configuration
> > field before FEATURES_OK is set by the driver. This includes fields
> > which are conditional on feature bits, as long as those feature bits are
> > offered by the device."
> I guess this statement only conveys that the field in config space can be
> read before FEATURES_OK is set, though it does not *explicitly* states the
> validity of field.
> 
> And looking at:
> 
> "The mac address field always exists (though is only valid if
> VIRTIO_NET_F_MAC is set), and status only exists if VIRTIO_NET_F_STATUS is
> set."
> 
> It appears to me there's a border line set between "exist" and "valid". If I
> understand the spec wording correctly, a spec-conforming device
> implementation may or may not offer valid status value in the config space
> when VIRTIO_NET_F_STATUS is offered, but before the feature is negotiated.
> On the other hand, config space should contain valid mac address the moment
> VIRTIO_NET_F_MAC feature is offered, regardless being negotiated or not. By
> that, there seems to be leeway for the device implementation to decide when
> config space field may become valid, though for most of QEMU's software
> virtio devices, valid value is present to config space the very first moment
> when feature is offered.
> 
> "If the VIRTIO_NET_F_MAC feature bit is set, the configuration space mac
> entry indicates the “physical” address of the network card, otherwise the
> driver would typically generate a random local MAC address."
> "If the VIRTIO_NET_F_STATUS feature bit is negotiated, the link status comes
> from the bottom bit of status. Otherwise, the driver assumes it’s active."
> 
> And also there are special cases where the read of specific configuration
> space field MUST be deferred to until FEATURES_OK is set:
> 
> "If the VIRTIO_BLK_F_CONFIG_WCE feature is negotiated, the cache mode can be
> read or set through the writeback field. 0 corresponds to a writethrough
> cache, 1 to a writeback cache11. The cache mode after reset can be either
> writeback or writethrough. The actual mode can be determined by reading
> writeback after feature negotiation."
> "The driver MUST NOT read writeback before setting the FEATURES_OK device
> status bit."
> "If VIRTIO_BLK_F_CONFIG_WCE is negotiated but VIRTIO_BLK_F_FLUSH is not, the
> device MUST initialize writeback to 0."
> 
> Since the spec doesn't explicitly mandate the validity of each config space
> field when feature of concern is offered, to be safer we'd have to live with
> odd device implementation. I know for sure QEMU software devices won't for
> 99% of these cases, but that's not what is currently defined in the spec.


Thanks for raising this subject. I started working on this in April:

https://lists.oasis-open.org/archives/virtio-comment/202201/msg00068.html

working now to address the comments.


> > 
> > 
> > > You may want to double check with Michael for what he quoted earlier:
> > > > Nope:
> > > > 
> > > > 2.5.1  Driver Requirements: Device Configuration Space
> > > > 
> > > > ...
> > > > 
> > > > For optional configuration space fields, the driver MUST check
> > > > that the corresponding feature is offered
> > > > before accessing that part of the configuration space.
> > > 
> > > and how many driver bugs taking wrong assumption of the validity of
> > > config space field without features_ok. I am not sure what use case
> > > you want to expose config resister values for before features_ok, if
> > > it's mostly for live migration I guess it's probably heading a wrong
> > > direction.
> > 
> > 
> > I guess it's not for migration.
> Then what's the other possible use case than live migration, were to expose
> config space values? Troubleshooting config space discrepancy between vDPA
> and the emulated virtio device in userspace? Or tracking changes in config
> space across feature negotiation, but for what? It'd be beneficial to the
> interface design if the specific use case can be clearly described...
> 
> 
> > For migration, a provision with the correct features/capability would be
> > sufficient.
> Right, that's what I thought too. It doesn't need to expose config space
> values, simply exporting all attributes for vdpa device creation will do the
> work.
> 
> -Siwei
> 
> > 
> > Thanks
> > 
> > 
> > > 
> > > 
> > > > > 
> > > > > 
> > > > > Last but not the least, this "vdpa dev config" command was
> > > > > not designed to display the real config space register
> > > > > values in the first place. Quoting the vdpa-dev(8) man page:
> > > > > 
> > > > > > vdpa dev config show - Show configuration of specific
> > > > > > device or all devices.
> > > > > > DEV - specifies the vdpa device to show its
> > > > > > configuration. If this argument is omitted all devices
> > > > > > configuration is listed.
> > > > > It doesn't say anything about configuration space or
> > > > > register values in config space. As long as it can convey
> > > > > the config attribute when instantiating vDPA device
> > > > > instance, and more importantly, the config can be easily
> > > > > imported from or exported to userspace tools when trying to
> > > > > reconstruct vdpa instance intact on destination host for
> > > > > live migration, IMHO in my personal interpretation it
> > > > > doesn't matter what the config space may present. It may be
> > > > > worth while adding a new debug command to expose the real
> > > > > register value, but that's another story.
> > > > I am not sure getting your points. vDPA now reports device
> > > > feature bits(device_features) and negotiated feature
> > > > bits(driver_features), and yes, the drivers features can be a
> > > > subset of the device features; and the vDPA device features can
> > > > be a subset of the management device features.
> > > What I said is after unblocking the conditional check, you'd have to
> > > handle the case for each of the vdpa attribute when feature
> > > negotiation is not yet done: basically the register values you got
> > > from config space via the vdpa_get_config_unlocked() call is not
> > > considered to be valid before features_ok (per-spec). Although in
> > > some case you may get sane value, such behavior is generally
> > > undefined. If you desire to show just the device_features alone
> > > without any config space field, which the device had advertised
> > > *before feature negotiation is complete*, that'll be fine. But looks
> > > to me this is not how patch has been implemented. Probably need some
> > > more work?
> > > 
> > > Regards,
> > > -Siwei
> > > 
> > > > > 
> > > > > Having said, please consider to drop the Fixes tag, as
> > > > > appears to me you're proposing a new feature rather than
> > > > > fixing a real issue.
> > > > it's a new feature to report the device feature bits than only
> > > > negotiated features, however this patch is a must, or it will
> > > > block the device feature bits reporting. but I agree, the fix
> > > > tag is not a must.
> > > > > 
> > > > > Thanks,
> > > > > -Siwei
> > > > > 
> > > > > On 7/1/2022 3:12 PM, Parav Pandit via Virtualization wrote:
> > > > > > > From: Zhu Lingshan<lingshan.zhu@intel.com>
> > > > > > > Sent: Friday, July 1, 2022 9:28 AM
> > > > > > > 
> > > > > > > Users may want to query the config space of a vDPA
> > > > > > > device, to choose a
> > > > > > > appropriate one for a certain guest. This means the
> > > > > > > users need to read the
> > > > > > > config space before FEATURES_OK, and the existence of config space
> > > > > > > contents does not depend on FEATURES_OK.
> > > > > > > 
> > > > > > > The spec says:
> > > > > > > The device MUST allow reading of any device-specific
> > > > > > > configuration field
> > > > > > > before FEATURES_OK is set by the driver. This
> > > > > > > includes fields which are
> > > > > > > conditional on feature bits, as long as those
> > > > > > > feature bits are offered by the
> > > > > > > device.
> > > > > > > 
> > > > > > > Fixes: 30ef7a8ac8a07 (vdpa: Read device
> > > > > > > configuration only if FEATURES_OK)
> > > > > > Fix is fine, but fixes tag needs correction described below.
> > > > > > 
> > > > > > Above commit id is 13 letters should be 12.
> > > > > > And
> > > > > > It should be in format
> > > > > > Fixes: 30ef7a8ac8a0 ("vdpa: Read device configuration
> > > > > > only if FEATURES_OK")
> > > > > > 
> > > > > > Please use checkpatch.pl script before posting the
> > > > > > patches to catch these errors.
> > > > > > There is a bot that looks at the fixes tag and
> > > > > > identifies the right kernel version to apply this fix.
> > > > > > 
> > > > > > > Signed-off-by: Zhu Lingshan<lingshan.zhu@intel.com>
> > > > > > > ---
> > > > > > >   drivers/vdpa/vdpa.c | 8 --------
> > > > > > >   1 file changed, 8 deletions(-)
> > > > > > > 
> > > > > > > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> > > > > > > 9b0e39b2f022..d76b22b2f7ae 100644
> > > > > > > --- a/drivers/vdpa/vdpa.c
> > > > > > > +++ b/drivers/vdpa/vdpa.c
> > > > > > > @@ -851,17 +851,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
> > > > > > > struct sk_buff *msg, u32 portid,  {
> > > > > > >       u32 device_id;
> > > > > > >       void *hdr;
> > > > > > > -    u8 status;
> > > > > > >       int err;
> > > > > > > 
> > > > > > >       down_read(&vdev->cf_lock);
> > > > > > > -    status = vdev->config->get_status(vdev);
> > > > > > > -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
> > > > > > > -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
> > > > > > > completed");
> > > > > > > -        err = -EAGAIN;
> > > > > > > -        goto out;
> > > > > > > -    }
> > > > > > > -
> > > > > > >       hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
> > > > > > >                 VDPA_CMD_DEV_CONFIG_GET);
> > > > > > >       if (!hdr) {
> > > > > > > -- 
> > > > > > > 2.31.1
> > > > > > _______________________________________________
> > > > > > Virtualization mailing list
> > > > > > Virtualization@lists.linux-foundation.org
> > > > > > https://urldefense.com/v3/__https://lists.linuxfoundation.org/mailman/listinfo/virtualization__;!!ACWV5N9M2RV99hQ!Pkwym7OAjoDucUqs2fAwchxqL8-BGd6wOl-51xcgB_yCNwPJ_cs8A1y-cYmrLTB4OBNsimnZuqJPcvQIl3g$
> > > > > 
> > > > > 
> > > > 
> > > 
> > 

