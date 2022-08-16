Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99B8659643D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbiHPVKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 17:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbiHPVKC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 17:10:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E277E013
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:10:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660684200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0xae14lVeh2kNhNnwg1cZQHDZVItFs4GvsbtmRqUK8w=;
        b=Hoyd0dBWhbq7nhURAv6sFmQaDmCkcvrgGysin13/l1GnwjSyL//InFa5NeMqySmm9Kxu0K
        iXqBUrrVVaYe61NhbJmQN0B0VwlBJSXj2V4FUaUIRPCqVCE9htaKgP8SMLZfMS04stkCWr
        zM4I2rpeMIjyqpZGJrQNiRrjhq/BC+Y=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-517-6NRk65srP6q1jW18Na5Bqg-1; Tue, 16 Aug 2022 17:09:59 -0400
X-MC-Unique: 6NRk65srP6q1jW18Na5Bqg-1
Received: by mail-wm1-f69.google.com with SMTP id p19-20020a05600c1d9300b003a5c3141365so8183652wms.9
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 14:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=0xae14lVeh2kNhNnwg1cZQHDZVItFs4GvsbtmRqUK8w=;
        b=fbeCLXq+EUdTuyly0TuvmNj7hTGNl7A1mywYiQzyeXH+XTsOT/RdJaG0f4tkBzyZUl
         ppWI0X0+4F2LFz27KBYQJFwP8vlB0Bt0ym00OklcsDqVTujUZz4kjxlm4/jPJHY3T7MW
         Imp4mkNHi5lyrD+VnTM+uptTGUq6zfreCrxvBy5q8GqAVB2QSrfdL2SJUAUZRHTaS3VR
         nOAjr3cYxEGyzEDFkgryhgqAF8QdqRNSsSCcxVqvdaT3LJrNlgbS0BBD+/2ik9wbvvR9
         t42pKXN+4NdhuY5PUNhq+a+Oq1/W1RlU61FkqyN2sO7qTAZCY+slPr0NikCDJDAw8ugA
         WcSw==
X-Gm-Message-State: ACgBeo3OLJuEjwpRLFAa33GhTRsk642IR16NixcUCjgA+1KblP/viGyU
        qPbVaX3OnZR47F0xmWnOWsv2jIEdbSIpybOyCYL476JfdzN8+YJ/oKabI2NoD4WNTbqj6D7Kkp9
        wgKg0KQeGHROYu0hy
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr12680070wrg.634.1660684197861;
        Tue, 16 Aug 2022 14:09:57 -0700 (PDT)
X-Google-Smtp-Source: AA6agR61GD6vmCsdhe0o/qF+vr5ZjerDcFyH4c3E/BWOKkmWXYXsvQWoq7RyRXoltM0F4/hZDJyhVA==
X-Received: by 2002:a05:6000:178e:b0:220:635f:eb13 with SMTP id e14-20020a056000178e00b00220635feb13mr12680061wrg.634.1660684197625;
        Tue, 16 Aug 2022 14:09:57 -0700 (PDT)
Received: from redhat.com ([2.55.43.215])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b003a319b67f64sm5902435wms.0.2022.08.16.14.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 14:09:56 -0700 (PDT)
Date:   Tue, 16 Aug 2022 17:09:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
Message-ID: <20220816170753-mutt-send-email-mst@kernel.org>
References: <20220815092638.504528-1-lingshan.zhu@intel.com>
 <20220815092638.504528-3-lingshan.zhu@intel.com>
 <PH0PR12MB54815EF8C19F70072169FA56DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <4184a943-f1c0-a57b-6411-bdd21e0bc710@intel.com>
 <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PH0PR12MB5481EBA9E08963DEF0743063DC6B9@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 09:02:17PM +0000, Parav Pandit wrote:
> 
> > From: Zhu, Lingshan <lingshan.zhu@intel.com>
> > Sent: Tuesday, August 16, 2022 12:19 AM
> > 
> > 
> > On 8/16/2022 10:32 AM, Parav Pandit wrote:
> > >> From: Zhu Lingshan <lingshan.zhu@intel.com>
> > >> Sent: Monday, August 15, 2022 5:27 AM
> > >>
> > >> Some fields of virtio-net device config space are conditional on the
> > >> feature bits, the spec says:
> > >>
> > >> "The mac address field always exists
> > >> (though is only valid if VIRTIO_NET_F_MAC is set)"
> > >>
> > >> "max_virtqueue_pairs only exists if VIRTIO_NET_F_MQ or
> > >> VIRTIO_NET_F_RSS is set"
> > >>
> > >> "mtu only exists if VIRTIO_NET_F_MTU is set"
> > >>
> > >> so we should read MTU, MAC and MQ in the device config space only
> > >> when these feature bits are offered.
> > > Yes.
> > >
> > >> For MQ, if both VIRTIO_NET_F_MQ and VIRTIO_NET_F_RSS are not set,
> > the
> > >> virtio device should have one queue pair as default value, so when
> > >> userspace querying queue pair numbers, it should return mq=1 than zero.
> > > No.
> > > No need to treat mac and max_qps differently.
> > > It is meaningless to differentiate when field exist/not-exists vs value
> > valid/not valid.
> > as we discussed before, MQ has a default value 1, to be a functional virtio-
> > net device, while MAC has no default value, if no VIRTIO_NET_F_MAC set,
> > the driver should generate a random MAC.
> > >
> > >> For MTU, if VIRTIO_NET_F_MTU is not set, we should not read MTU from
> > >> the device config sapce.
> > >> RFC894 <A Standard for the Transmission of IP Datagrams over Ethernet
> > >> Networks> says:"The minimum length of the data field of a packet sent
> > >> Networks> over
> > >> an Ethernet is 1500 octets, thus the maximum length of an IP datagram
> > >> sent over an Ethernet is 1500 octets.  Implementations are encouraged
> > >> to support full-length packets"
> > > This line in the RFC 894 of 1984 is wrong.
> > > Errata already exists for it at [1].
> > >
> > > [1] https://www.rfc-editor.org/errata_search.php?rfc=894&rec_status=0
> > OK, so I think we should return nothing if _F_MTU not set, like handling the
> > MAC
> > >
> > >> virtio spec says:"The virtio network device is a virtual ethernet
> > >> card", so the default MTU value should be 1500 for virtio-net.
> > >>
> > > Practically I have seen 1500 and highe mtu.
> > > And this derivation is not good of what should be the default mtu as above
> > errata exists.
> > >
> > > And I see the code below why you need to work so hard to define a default
> > value so that _MQ and _MTU can report default values.
> > >
> > > There is really no need for this complexity and such a long commit
> > message.
> > >
> > > Can we please expose feature bits as-is and report config space field which
> > are valid?
> > >
> > > User space will be querying both.
> > I think MAC and MTU don't have default values, so return nothing if the
> > feature bits not set, 
> 
> > for MQ, it is still max_vq_paris == 1 by default.
> 
> I have stressed enough to highlight the fact that we don’t want to start digging default/no default, valid/no-valid part of the spec.
> I prefer kernel to reporting fields that _exists_ in the config space and are valid.
> I will let MST to handle the maintenance nightmare that this kind of patch brings in without any visible gain to user space/orchestration apps.
> 
> A logic that can be easily build in user space, should be written in user space.
> I conclude my thoughts here for this discussion.
> 
> I will let MST to decide how he prefers to proceed.
> 
> >
> > >> +	if ((features & BIT_ULL(VIRTIO_NET_F_MTU)) == 0)
> > >> +		val_u16 = 1500;
> > >> +	else
> > >> +		val_u16 = __virtio16_to_cpu(true, config->mtu);
> > >> +
> > > Need to work hard to find default values and that too turned out had
> > errata.
> > > There are more fields that doesn’t have default values.
> > >
> > > There is no point in kernel doing this guess work, that user space can figure
> > out of what is valid/invalid.
> > It's not guest work, when guest finds no feature bits set, it can decide what
> > to do. 
> 
> Above code of doing 1500 was probably an honest attempt to find a legitimate default value, and we saw that it doesn’t work.
> This is second example after _MQ that we both agree should not return default.
> 
> And there are more fields coming in this area.
> Hence, I prefer to not avoid returning such defaults for MAC, MTU, MQ and rest all fields which doesn’t _exists_.
> 
> I will let MST to decide how he prefers to proceed for every field to come next.
> Thanks.
> 


If MTU does not return a value without _F_MTU, and MAC does not return
a value without _F_MAC then IMO yes, number of queues should not return
a value without _F_MQ.


-- 
MST

