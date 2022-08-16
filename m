Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB8959577D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbiHPKGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiHPKFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:05:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 929ADD5DE2
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660639269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JhzHSnD8m6MoYMeJjcaDLkKFr2qic5jMfN3mxxe71ZQ=;
        b=V5ByG6EAFpiHhRlgjuUQiMpsk5FjYElr3Uliv5q45uwZuFkpczDpruz9GZ1Ju0XEuec46M
        e7/dBuzatM/fXEl9FwLM87PJOXx7JlDrdgUTgmJOU14qBTxkl07TzmV4t+cs5us4irTulc
        zFyJ/ilkxZXPmAZ4XI0iUxrU5VnOFlo=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-518-aVZnqfCbMgK24FWRhbziEw-1; Tue, 16 Aug 2022 04:41:08 -0400
X-MC-Unique: aVZnqfCbMgK24FWRhbziEw-1
Received: by mail-wr1-f69.google.com with SMTP id t12-20020adfba4c000000b0021e7440666bso1668553wrg.22
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 01:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=JhzHSnD8m6MoYMeJjcaDLkKFr2qic5jMfN3mxxe71ZQ=;
        b=G3q53OuCYCGfmvp/7gkT8+Q95XWAm9MwWOHvb+hEMlhguI6TCX9l5QBakQYNLUOsWy
         lhFOPLzOELEjl/rXkL0gCzNA9ZX9GTVWdI1OXLF1x0MDyqj1AKM43Hmr3WrjxoRqIZM8
         sNlEUi/raVEixGo5XbERPRKZht1aXdOWq99zIcvPXQyqc1zn59sNQhpYVhSHYhaBqDxX
         dUsLCTYElAVw7sRePQgwBBF6c5ZqnF5OmzTj8KYwfPmxnxo+iKOL6hxlfNBy7eObYp5d
         nS3kvn+6h6Vwg74hOFIXksU/4Rd9GplYCnOe7nZNFWD78O0afBIOs73BNCTrKUlpbnnT
         5A1A==
X-Gm-Message-State: ACgBeo0Yzgzqeqz6+t7KQ7KhCCzTVlBxWgAx5lCzhneyeyWnQuY2ibXw
        bqXdyGc9QtPQG+f9+Iq295DCUYds6Lkk0dMQNvRt4nfcdQc5mKxWQLBIgljbEeuhP7yBwgrkStu
        tW9qGswwHly+KvK6H
X-Received: by 2002:a05:6000:1682:b0:221:599b:a41e with SMTP id y2-20020a056000168200b00221599ba41emr10782097wrd.522.1660639267033;
        Tue, 16 Aug 2022 01:41:07 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7hrdq7Ri8Q9AJDYs6MtPPkgKJ3b2KGzM97zG859G9nTVxxin8BZSl5mWCVhZdEFvHN2HuLFA==
X-Received: by 2002:a05:6000:1682:b0:221:599b:a41e with SMTP id y2-20020a056000168200b00221599ba41emr10782082wrd.522.1660639266740;
        Tue, 16 Aug 2022 01:41:06 -0700 (PDT)
Received: from redhat.com ([2.55.4.37])
        by smtp.gmail.com with ESMTPSA id p185-20020a1c29c2000000b003a4f1385f0asm12704773wmp.24.2022.08.16.01.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 01:41:06 -0700 (PDT)
Date:   Tue, 16 Aug 2022 04:41:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com, jasowang@redhat.com
Subject: Re: [PATCH V5 4/6] vDPA: !FEATURES_OK should not block querying
 device config space
Message-ID: <20220816044007-mutt-send-email-mst@kernel.org>
References: <20220812104500.163625-1-lingshan.zhu@intel.com>
 <20220812104500.163625-5-lingshan.zhu@intel.com>
 <e99e6d81-d7d5-e1ff-08e0-c22581c1329a@oracle.com>
 <f2864c96-cddd-129e-7dd8-a3743fe7e0d0@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f2864c96-cddd-129e-7dd8-a3743fe7e0d0@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 04:29:04PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 8/16/2022 3:41 PM, Si-Wei Liu wrote:
> 
>     Hi Michael,
> 
>     I just noticed this patch got pulled to linux-next prematurely without
>     getting consensus on code review, am not sure why. Hope it was just an
>     oversight.
> 
>     Unfortunately this introduced functionality regression to at least two
>     cases so far as I see:
> 
>     1. (bogus) VDPA_ATTR_DEV_NEGOTIATED_FEATURES are inadvertently exposed and
>     displayed in "vdpa dev config show" before feature negotiation is done.
>     Noted the corresponding features name shown in vdpa tool is called
>     "negotiated_features" rather than "driver_features". I see in no way the
>     intended change of the patch should break this user level expectation
>     regardless of any spec requirement. Do you agree on this point?
> 
> I will post a patch for iptour2, doing:
> 1) if iprout2 does not get driver_features from the kernel, then don't show
> negotiated features in the command output
> 2) process and decoding the device features.
> 
> 
>     2. There was also another implicit assumption that is broken by this patch.
>     There could be a vdpa tool query of config via vdpa_dev_net_config_fill()->
>     vdpa_get_config_unlocked() that races with the first vdpa_set_features()
>     call from VMM e.g. QEMU. Since the S_FEATURES_OK blocking condition is
>     removed, if the vdpa tool query occurs earlier than the first
>     set_driver_features() call from VMM, the following code will treat the
>     guest as legacy and then trigger an erroneous vdpa_set_features_unlocked
>     (... , 0) call to the vdpa driver:
> 
>      374         /*
>      375          * Config accesses aren't supposed to trigger before features
>     are set.
>      376          * If it does happen we assume a legacy guest.
>      377          */
>      378         if (!vdev->features_valid)
>      379                 vdpa_set_features_unlocked(vdev, 0);
>      380         ops->get_config(vdev, offset, buf, len);
> 
>     Depending on vendor driver's implementation, L380 may either return invalid
>     config data (or invalid endianness if on BE) or only config fields that are
>     valid in legacy layout. What's more severe is that, vdpa tool query in
>     theory shouldn't affect feature negotiation at all by making confusing
>     calls to the device, but now it is possible with the patch. Fixing this
>     would require more delicate work on the other paths involving the cf_lock
>     reader/write semaphore.
> 
>     Not sure what you plan to do next, post the fixes for both issues and get
>     the community review? Or simply revert the patch in question? Let us know.
> 
> The spec says:
> The device MUST allow reading of any device-specific configuration field before
> FEATURES_OK is set by
> the driver. This includes fields which are conditional on feature bits, as long
> as those feature bits are offered
> by the device.
> 
> so whether FEATURES_OK should not block reading the device config space. 
> vdpa_get_config_unlocked() will read the features, I don't know why it has a
> comment:
>         /*
>          * Config accesses aren't supposed to trigger before features are set.
>          * If it does happen we assume a legacy guest.
>          */
> 
> This conflicts with the spec.

Yea well. On the other hand the spec also calls for features to be
used to detect legacy versus modern driver.
This part of the spec needs work generally.


> vdpa_get_config_unlocked() checks vdev->features_valid, if not valid, it will
> set the drivers_features 0, I think this intends to prevent reading random
> driver_features. This function does not hold any locks, and didn't change
> anything.
> 
> So what is the race?
> 
> Thanks
> 
> 
> 
>     Thanks,
>     -Siwei
> 
> 
>     On 8/12/2022 3:44 AM, Zhu Lingshan wrote:
> 
>         Users may want to query the config space of a vDPA device,
>         to choose a appropriate one for a certain guest. This means the
>         users need to read the config space before FEATURES_OK, and
>         the existence of config space contents does not depend on
>         FEATURES_OK.
> 
>         The spec says:
>         The device MUST allow reading of any device-specific configuration
>         field before FEATURES_OK is set by the driver. This includes
>         fields which are conditional on feature bits, as long as those
>         feature bits are offered by the device.
> 
>         Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>         ---
>           drivers/vdpa/vdpa.c | 8 --------
>           1 file changed, 8 deletions(-)
> 
>         diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
>         index 6eb3d972d802..bf312d9c59ab 100644
>         --- a/drivers/vdpa/vdpa.c
>         +++ b/drivers/vdpa/vdpa.c
>         @@ -855,17 +855,9 @@ vdpa_dev_config_fill(struct vdpa_device *vdev,
>         struct sk_buff *msg, u32 portid,
>           {
>               u32 device_id;
>               void *hdr;
>         -    u8 status;
>               int err;
>                 down_read(&vdev->cf_lock);
>         -    status = vdev->config->get_status(vdev);
>         -    if (!(status & VIRTIO_CONFIG_S_FEATURES_OK)) {
>         -        NL_SET_ERR_MSG_MOD(extack, "Features negotiation not
>         completed");
>         -        err = -EAGAIN;
>         -        goto out;
>         -    }
>         -
>               hdr = genlmsg_put(msg, portid, seq, &vdpa_nl_family, flags,
>                         VDPA_CMD_DEV_CONFIG_GET);
>               if (!hdr) {
> 
> 
> 
> 

