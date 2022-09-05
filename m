Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE9BA5AC949
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 05:55:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiIEDz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Sep 2022 23:55:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236138AbiIEDzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 23:55:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEAA1B7A2
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 20:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662350106;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yijFtAf+YTC51EM3w6zBuLMVKqELohoZHP/loODJ7kI=;
        b=NjxNMmXKLSRdvzWi/ttGixwhm8CadjwIRZhESwY8NelEHM3re75Ciu2OTJqJFxB8HI3cjq
        5YCwco262IuonEcaBrnya6IunPSbKsfgnUNFZxVgG0BKajCCwfk0WL8mWV0WreUvn5DLW1
        V75Pc9fu+V0a9Pk/y2JriRZpwI+UZFE=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-164-a66TwvohMZKnWjZA9WVCqw-1; Sun, 04 Sep 2022 23:55:05 -0400
X-MC-Unique: a66TwvohMZKnWjZA9WVCqw-1
Received: by mail-vs1-f71.google.com with SMTP id j65-20020a676e44000000b00390ddd97683so2235345vsc.5
        for <netdev@vger.kernel.org>; Sun, 04 Sep 2022 20:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=yijFtAf+YTC51EM3w6zBuLMVKqELohoZHP/loODJ7kI=;
        b=l76G/IwJdEGgMY9VL8S8104pfyrPX1T5IwXtuLbwDpLcqAYSb8IxcVZq7929FjheBB
         5pOxqFceTXFvpQh0dPj8I5afIYGAW0ofm0LkuZdQdLIJTRYxSthjdXaY8WpoGnY6fRxp
         +i4QA91eNHDPjHMQoBx6T8FEuAIQ+yc0NJ40AnN3+v1euVyzT7XTNPxe/exFyQerXj0K
         1AOnKJWjw+J2XRaP+j3Vmfi5YqijMFSkqOWuez7ND9Q5jRYLTVEatOzCyhFSHse0SLya
         wtS9V1EgvVKtp23pkw8rAKnq61nQiaz1drQ2MgASf0oRiXCATmHARA/77X5mw3aG2uqC
         Uebw==
X-Gm-Message-State: ACgBeo0T+n5yCM0kMoIm86w8Kde+l0dZBUgWvEsM5V2ahb01Y51h7WGR
        bvhND42SG2j1YJMZA+ZwDOz0XoZO6IsiE0XrFvqvknKESe/Am02BdEYLzJQnI2qrANGf6ESbnqy
        AEIsOJg6jKg1KkdefQIOPOrpdqbBPzSxy
X-Received: by 2002:a1f:2109:0:b0:394:5a0f:4402 with SMTP id h9-20020a1f2109000000b003945a0f4402mr11497597vkh.32.1662350104529;
        Sun, 04 Sep 2022 20:55:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6riWPLJjdkM13zvbC0UwUNyhDs0vrKGUkBDNiP4sDbBRfS2doYrVCr+YiP9rz3fFGQXsB0WqJejZsJUEFajpk=
X-Received: by 2002:a1f:2109:0:b0:394:5a0f:4402 with SMTP id
 h9-20020a1f2109000000b003945a0f4402mr11497594vkh.32.1662350104147; Sun, 04
 Sep 2022 20:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com>
 <20220817063450-mutt-send-email-mst@kernel.org> <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com>
 <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com> <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
 <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com> <e06d1f6d-3199-1b75-d369-2e5d69040271@intel.com>
 <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com>
 <a6ac322c-636f-1826-5c65-b51cc5464999@oracle.com> <CACGkMEvYGz_L+mYzvycYDLuMUAup9XdU1-cdpy=9sTmSLYXNSA@mail.gmail.com>
 <20220902021054-mutt-send-email-mst@kernel.org>
In-Reply-To: <20220902021054-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 5 Sep 2022 11:54:52 +0800
Message-ID: <CACGkMEv4U=Z2eusAr41CxyDFDy3JR18UuXzZJAFMA9EqnV+tmg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 2:14 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Fri, Sep 02, 2022 at 02:03:22PM +0800, Jason Wang wrote:
> > On Fri, Aug 26, 2022 at 2:24 PM Si-Wei Liu <si-wei.liu@oracle.com> wrot=
e:
> > >
> > >
> > >
> > > On 8/22/2022 8:26 PM, Jason Wang wrote:
> > > > On Mon, Aug 22, 2022 at 1:08 PM Zhu, Lingshan <lingshan.zhu@intel.c=
om> wrote:
> > > >>
> > > >>
> > > >> On 8/20/2022 4:55 PM, Si-Wei Liu wrote:
> > > >>>
> > > >>> On 8/18/2022 5:42 PM, Jason Wang wrote:
> > > >>>> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.co=
m>
> > > >>>> wrote:
> > > >>>>>
> > > >>>>> On 8/17/2022 9:15 PM, Jason Wang wrote:
> > > >>>>>> =E5=9C=A8 2022/8/17 18:37, Michael S. Tsirkin =E5=86=99=E9=81=
=93:
> > > >>>>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote=
:
> > > >>>>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> > > >>>>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wro=
te:
> > > >>>>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> > > >>>>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan w=
rote:
> > > >>>>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSIO=
N_1
> > > >>>>>>>>>>>> because of
> > > >>>>>>>>>>>> transitional devices, so maybe this is the best we can d=
o for
> > > >>>>>>>>>>>> now
> > > >>>>>>>>>>> I think vhost generally needs an API to declare config sp=
ace
> > > >>>>>>>>>>> endian-ness
> > > >>>>>>>>>>> to kernel. vdpa can reuse that too then.
> > > >>>>>>>>>> Yes, I remember you have mentioned some IOCTL to set the
> > > >>>>>>>>>> endian-ness,
> > > >>>>>>>>>> for vDPA, I think only the vendor driver knows the endian,
> > > >>>>>>>>>> so we may need a new function vdpa_ops->get_endian().
> > > >>>>>>>>>> In the last thread, we say maybe it's better to add a comm=
ent for
> > > >>>>>>>>>> now.
> > > >>>>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I=
 can
> > > >>>>>>>>>> work
> > > >>>>>>>>>> on it for sure!
> > > >>>>>>>>>>
> > > >>>>>>>>>> Thanks
> > > >>>>>>>>>> Zhu Lingshan
> > > >>>>>>>>> I think QEMU has to set endian-ness. No one else knows.
> > > >>>>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
> > > >>>>>>>> the device & driver knows the endian, I think we can not
> > > >>>>>>>> "set" a hardware's endian.
> > > >>>>>>> QEMU knows the guest endian-ness and it knows that
> > > >>>>>>> device is accessed through the legacy interface.
> > > >>>>>>> It can accordingly send endian-ness to the kernel and
> > > >>>>>>> kernel can propagate it to the driver.
> > > >>>>>> I wonder if we can simply force LE and then Qemu can do the en=
dian
> > > >>>>>> conversion?
> > > >>>>> convert from LE for config space fields only, or QEMU has to fo=
rcefully
> > > >>>>> mediate and covert endianness for all device memory access incl=
uding
> > > >>>>> even the datapath (fields in descriptor and avail/used rings)?
> > > >>>> Former. Actually, I want to force modern devices for vDPA when
> > > >>>> developing the vDPA framework. But then we see requirements for
> > > >>>> transitional or even legacy (e.g the Ali ENI parent). So it
> > > >>>> complicates things a lot.
> > > >>>>
> > > >>>> I think several ideas has been proposed:
> > > >>>>
> > > >>>> 1) Your proposal of having a vDPA specific way for
> > > >>>> modern/transitional/legacy awareness. This seems very clean sinc=
e each
> > > >>>> transport should have the ability to do that but it still requir=
es
> > > >>>> some kind of mediation for the case e.g running BE legacy guest =
on LE
> > > >>>> host.
> > > >>> In theory it seems like so, though practically I wonder if we can=
 just
> > > >>> forbid BE legacy driver from running on modern LE host. For those=
 who
> > > >>> care about legacy BE guest, they mostly like could and should tal=
k to
> > > >>> vendor to get native BE support to achieve hardware acceleration,
> > > > The problem is the hardware still needs a way to know the endian of=
 the guest?
> > > Hardware doesn't need to know. VMM should know by judging from VERSIO=
N_1
> > > feature bit negotiation and legacy interface access (with new code), =
and
> > > the target architecture endianness (the latter is existing QEMU code)=
.
> > > >
> > > >>> few
> > > >>> of them would count on QEMU in mediating or emulating the datapat=
h
> > > >>> (otherwise I don't see the benefit of adopting vDPA?). I still fe=
el
> > > >>> that not every hardware vendor has to offer backward compatibilit=
y
> > > >>> (transitional device) with legacy interface/behavior (BE being ju=
st
> > > >>> one),
> > > > Probably, I agree it is a corner case, and dealing with transitiona=
l
> > > > device for the following setups is very challenge for hardware:
> > > >
> > > > - driver without IOMMU_PLATFORM support, (requiring device to send
> > > > translated request which have security implications)
> > > Don't get better suggestion for this one, but I presume this is
> > > something legacy guest users should be aware of ahead in term of
> > > security implications.
> >
> > Probably but I think this assumption will prevent the device from
> > being used in a production environment.
> >
> > >
> > > > - BE legacy guest on LE host, (requiring device to have a way to kn=
ow
> > > > the endian)
> > > Yes. device can tell apart with the help from VMM (judging by VERSION=
_1
> > > acknowledgement and if legacy interface is used during negotiation).
> > >
> > > > - device specific requirement (e.g modern virtio-net mandate minima=
l
> > > > header length to contain mrg_rxbuf even if the device doesn't offer
> > > > it)
> > > This one seems to be spec mandated transitional interface requirement=
?
> >
> > Yes.
> >
> > > Which vDPA hardware vendor should take care of rather (if they do off=
er
> > > a transitional device)?
> >
> > Right but this is not the only one. Section 7.4 summaries the
> > transitional device conformance which is a very long list for vendor
> > to follow.
> >
> > > >
> > > > It is not obvious for the hardware vendor, so we may end up defecti=
ng
> > > > in the implementation. Dealing with compatibility for the transitio=
nal
> > > > devices is kind of a nightmare which there's no way for the spec to
> > > > rule the behavior of legacy devices.
> > > The compatibility detection part is tedious I agree. That's why I
> > > suggested starting from the very minimal and practically feasible (fo=
r
> > > e.g. on x86), but just don't prohibit the possibility to extend to bi=
g
> > > endian or come up with quirk fixes for various cases in QEMU.
> >
> > This is somehow we've already been done, e.g ali ENI is limited to x86.
> >
> > >
> > > >
> > > >>>   this is unlike the situation on software virtio device, which
> > > >>> has legacy support since day one. I think we ever discussed it be=
fore:
> > > >>> for those vDPA vendors who don't offer legacy guest support, mayb=
e we
> > > >>> should mandate some feature for e.g. VERSION_1, as these devices
> > > >>> really don't offer functionality of the opposite side (!VERSION_1=
)
> > > >>> during negotiation.
> > > > I've tried something similar here (a global mandatory instead of pe=
r device).
> > > >
> > > > https://urldefense.com/v3/__https://lkml.org/lkml/2021/6/4/26__;!!A=
CWV5N9M2RV99hQ!NRQPfj5o9o3MKE12ze1zfXMC-9SqwOWqF26g8RrIyUDbUmwDIwl5WQCaNiDe=
6aZ2yR83j-NEqRXQNXcNyOo$
> > > >
> > > > But for some reason, it is not applied by Michael. It would be a gr=
eat
> > > > relief if we support modern devices only. Maybe it's time to revisi=
t
> > > > this idea then we can introduce new backend features and then we ca=
n
> > > > mandate VERSION_1
> > > Probably, mandating per-device should be fine I guess.
> > >
> > > >
> > > >>> Having it said, perhaps we should also allow vendor device to
> > > >>> implement only partial support for legacy. We can define "reverse=
d"
> > > >>> backend feature to denote some part of the legacy
> > > >>> interface/functionality not getting implemented by device. For
> > > >>> instance, VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONF=
IG,
> > > >>> VHOST_BACKEND_F_NO_ALIGNED_VRING,
> > > >>> VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, and et al. Not all of these
> > > >>> missing features for legacy would be easy for QEMU to make up for=
, so
> > > >>> QEMU can selectively emulate those at its best when necessary and
> > > >>> applicable. In other word, this design shouldn't prevent QEMU fro=
m
> > > >>> making up for vendor device's partial legacy support.
> > > > This looks too heavyweight since it tries to provide compatibility =
for
> > > > legacy drivers.
> > > That's just for the sake of extreme backward compatibility, but you c=
an
> > > say that's not even needed if we mandate transitional device to offer
> > > all required interfaces for both legacy and modern guest.
> > >
> > > >   Considering we've introduced modern devices for 5+
> > > > years, I'd rather:
> > > >
> > > > - Qemu to mediate the config space stuffs
> > > > - Shadow virtqueue to mediate the datapath (AF_XDP told us shadow r=
ing
> > > > can perform very well if we do zero-copy).
> > > This is one way to achieve, though not sure we should stick the only
> > > hope to zero-copy, which IMHO may take a long way to realize and
> > > optimize to where a simple datapath passthrough can easily get to (wi=
th
> > > hardware acceleration of coz).
> >
> > Note that, current shadow virtqueue is zerocopy, Qemu just need to
> > forward the descriptors.
> >
> > >
> > > >
> > > >>>> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means =
we
> > > >>>> need a new config ops for vDPA bus, but it doesn't solve the iss=
ue for
> > > >>>> config space (at least from its name). We probably need a new io=
ctl
> > > >>>> for both vring and config space.
> > > >>> Yep adding a new ioctl makes things better, but I think the key i=
s not
> > > >>> the new ioctl. It's whether or not we should enforce every vDPA v=
endor
> > > >>> driver to implement all transitional interfaces to be spec compli=
ant.
> > > > I think the answer is no since the spec allows transitional device.
> > > > And we know things will be greatly simplified if vDPA support non
> > > > transitional device only.
> > > >
> > > > So we can change the question to:
> > > >
> > > > 1) do we need (or is it too late) to enforce non transitional devic=
e?
> > > We already have Alibaba ENI which is sort of a quasi-transitional
> > > device, right? In the sense it doesn't advertise VERSION_1. I know th=
e
> > > other parts might not qualify it to be fully transitional, but code n=
ow
> > > doesn't prohibit it from supporting VERSION_1 modern interface depend=
ing
> > > on whatever future need.
> >
> > We can ask ENI developer for their future plan, it looks to me a
> > legacy only device wouldn't be interested in the future.
> >
> > Zongyong, do you have the plan to implement device with VERSION_1 suppo=
rt?
> >
> > > > 2) if yes, can transitional device be mediate in an efficient way?
> > > >
> > > > For 1), it's probably too late but we can invent new vDPA features =
as
> > > > you suggest to be non transitional. Then we can:
> > > >
> > > > 1.1) extend the netlink API to provision non-transitonal device
> > > Define non-transitional: device could be either modern-only or legacy=
-only?
> >
> > According to the spec, non-transitional should be modern only.
> >
> > > > 1.2) work on the non-transtional device in the future
> > > > 1.3) presenting transitional device via mediation
> > > presenting transitional on top of a modern device with VERSION_1, rig=
ht?
> >
> > Yes, I mean presenting/mediating a transitional device on top of a
> > non-transitional device.
> >
> > > What if the hardware device can support legacy-compatible datapath
> > > natively that doesn't need mediation? Can it be done with direct
> > > datapath passthrough without svq involvement?
> >
> > I'd like to avoid supporting legacy-only device like ENI in the
> > future. The major problem is that it's out of the spec thus the
> > behaviour is defined by the code not the spec.
> >
> > >
> > > >
> > > > The previous transitional vDPA work as is, it's probably too late t=
o
> > > > fix all the issue we suffer.
> > > What do you mean work as-is,
> >
> > See above, basically I mean the behaviour is defined by the vDPA code
> > not (or can't) by the spec.
> >
> > For example, for virtio-pci, we have:
> >
> > legacy interface: BAR
> > modern interface: capability
> >
> > So a transitional device can simple provide both of those interfaces:
> > E.g for device configuration space, if it is accessed via legacy
> > interface device know it needs to provide the config with native
> > endian otherwise little endian when accessing via modern interface.
> >
> > For virtio-mmio, it looks to me it doesn't provide a way for
> > transitional device.
> >
> > For vDPA, we actually don't define whether config_ops is a modern or
> > legacy interface. This is very tricky for the transitional device
> > since it tries to reuse the same interface for both legacy and modern
> > which make it very hard to be correct. E.g:
> >
> > 1) VERSION_1 trick won't work, e.g the spec allows to read device
> > configuration space before FEATURE_OK. So legacy driver may assume a
> > native endian.
>
> I am trying to address this in the spec. There was a fairly narrow
> window during which guests accessed config space before
> writing out features. Yes before FEATURES_OK but I think
> asking that guests send the features to device
> before poking at config space that depends on those
> features is reasonable.

I'm not sure I get this. For transitional devices, we have legacy
interfaces so legacy drivers should work anyhow even without the fix.

>
> Similarly, we can also change QEMU to send
> features to vdpa on config access that happens before
> FEATURES_OK.

This only works when the guest driver sets a feature before config
space accessing. And then vDPA presents LE if VERSION_1 is negotiated?
But at the API level, vhost-vDPA still needs to handle the case when
VHOST_VDPA_GET_CONFIG is called before VHOST_SET_FEATURES.

Mandating a LE looks a better way then QEMU can mediate in the middle,
e.g converting to BE when necessary.

>
>
>
> > 2) SET_VRING_ENDIAN doesn't fix all the issue, there's still a
> > question what endian it is before SET_VRING_ENDIAN (or we need to
> > support userspace without SET_VRING_ENDIAN)
> > ...
> >
> > Things will be simplified if we mandate the config_ops as the modern
> > interface and provide the necessary mediation in the hypervisor.
> >
> > > what's the nomenclature for that,
> > > quasi-transitional or broken-transitional?
> >
> > If we invent new API to clarify the modern/legacy and focus on the
> > modern in the future, we probably don't need a name?
>
> OK. What will that API be like? Maybe a bit in PROTOCOL_FEATURES?

Something like this, a bit via VHOST_GET_BACKEND_FEATURES.

Thanks

>
> > > and what are the outstanding
> > > issues you anticipate remaining?
> >
> > Basically we need to check the conformance listed in section 7.4 of the=
 spec.
> >
> > > If it is device specific or vendor
> > > driver specific, let it be. But I wonder if there's any generic one t=
hat
> > > has to be fixed in vdpa core to support a truly transitional model.
> >
> > Two set of config_ops? E.g
> >
> > legacy_config_ops
> > modern_config_ops
> >
> > But I'm not sure whether or not it's worthwhile.
> >
> > > >
> > > > For 2), the key part is the datapath mediation, we can use shadow v=
irtqueue.
> > > Sure. For our use case, we'd care more in providing transitional rath=
er
> > > than being non-transitional. So, one device fits all.
> > >
> > > Thanks for all the ideas. This discussion is really useful.
> >
> > Appreciate for the discussion.
> >
> > Thanks
> >
> > >
> > > Best,
> > > -Siwei
> > > >
> > > >>> If we allow them to reject the VHOST_SET_VRING_ENDIAN  or
> > > >>> VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still en=
d up
> > > >>> with same situation of either fail the guest, or trying to
> > > >>> mediate/emulate, right?
> > > >>>
> > > >>> Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhos=
t
> > > >>> today - few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY en=
abled
> > > >>> and QEMU just ignores the result. vhost doesn't necessarily depen=
d on
> > > >>> it to determine endianness it looks.
> > > >> I would like to suggest to add two new config ops get/set_vq_endia=
n()
> > > >> and get/set_config_endian() for vDPA. This is used to:
> > > >> a) support VHOST_GET/SET_VRING_ENDIAN as MST suggested, and add
> > > >> VHOST_SET/GET_CONFIG_ENDIAN for vhost_vdpa.
> > > >> If the device has not implemented interface to set its endianess, =
then
> > > >> no matter success or failure of SET_ENDIAN, QEMU knows the endian-=
ness
> > > >> anyway.
> > > > How can Qemu know the endian in this way? And if it can, there's no
> > > > need for the new API?
> > > >
> > > >> In this case, if the device endianess does not match the guest,
> > > >> there needs a mediation layer or fail.
> > > >> b) ops->get_config_endian() can always tell the endian-ness of the
> > > >> device config space after the vendor driver probing the device. So=
 we
> > > >> can use this ops->get_config_endian() for
> > > >> MTU, MAC and other fields handling in vdpa_dev_net_config_fill() a=
nd we
> > > >> don't need to set_features in vdpa_get_config_unlocked(), so no ra=
ce
> > > >> conditions.
> > > >> Every time ops->get_config() returned, we can tell the endian by
> > > >> ops-config_>get_endian(), we don't need set_features(xxx, 0) if fe=
atures
> > > >> negotiation not done.
> > > >>
> > > >> The question is: Do we need two pairs of ioctls for both vq and co=
nfig
> > > >> space? Can config space endian-ness differ from the vqs?
> > > >> c) do we need a new netlink attr telling the endian-ness to user s=
pace?
> > > > Generally, I'm not sure this is a good design consider it provides =
neither:
> > > >
> > > > Compatibility with the virtio spec
> > > >
> > > > nor
> > > >
> > > > Compatibility with the existing vhost API (VHOST_SET_VRING_ENDIAN)
> > > >
> > > > Thanks
> > > >
> > > >> Thanks,
> > > >> Zhu Lingshan
> > > >>>> or
> > > >>>>
> > > >>>> 3) revisit the idea of forcing modern only device which may simp=
lify
> > > >>>> things a lot
> > > >>> I am not actually against forcing modern only config space, given=
 that
> > > >>> it's not hard for either QEMU or individual driver to mediate or
> > > >>> emulate, and for the most part it's not conflict with the goal of
> > > >>> offload or acceleration with vDPA. But forcing LE ring layout IMO
> > > >>> would just kill off the potential of a very good use case. Curren=
tly
> > > >>> for our use case the priority for supporting 0.9.5 guest with vDP=
A is
> > > >>> slightly lower compared to live migration, but it is still in our=
 TODO
> > > >>> list.
> > > >>>
> > > >>> Thanks,
> > > >>> -Siwei
> > > >>>
> > > >>>> which way should we go?
> > > >>>>
> > > >>>>> I hope
> > > >>>>> it's not the latter, otherwise it loses the point to use vDPA f=
or
> > > >>>>> datapath acceleration.
> > > >>>>>
> > > >>>>> Even if its the former, it's a little weird for vendor device t=
o
> > > >>>>> implement a LE config space with BE ring layout, although still
> > > >>>>> possible...
> > > >>>> Right.
> > > >>>>
> > > >>>> Thanks
> > > >>>>
> > > >>>>> -Siwei
> > > >>>>>> Thanks
> > > >>>>>>
> > > >>>>>>
> > > >>>>>>>> So if you think we should add a vdpa_ops->get_endian(),
> > > >>>>>>>> I will drop these comments in the next version of
> > > >>>>>>>> series, and work on a new patch for get_endian().
> > > >>>>>>>>
> > > >>>>>>>> Thanks,
> > > >>>>>>>> Zhu Lingshan
> > > >>>>>>> Guests don't get endian-ness from devices so this seems point=
less.
> > > >>>>>>>
> > >
>

