Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D28315E16
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 05:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBJEM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 23:12:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54124 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229692AbhBJEMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 23:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612930256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nA99BmjpKt6+09OtQs5vZeW+xzoSp2W0CQzq7UWp6To=;
        b=RPR45mQ/6cNAmkpf21r4CrnlOdvzns7Mh8GilEW7XoNNB7xsyzZJ6dFkT9/XH+fdyG6i39
        5IKrpfAN5ZRhYCrM0JUmmFPl0qK7sWctJyhp4HKJzn7VBHUWsDnSqe62b6D+GMFlEgQNa3
        QVqWm7r0QyPoEZYm/BXuxMYJ+52/ofk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-hSdtbohNNJemIzmw3Q-KPw-1; Tue, 09 Feb 2021 23:10:55 -0500
X-MC-Unique: hSdtbohNNJemIzmw3Q-KPw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A592D10066F1;
        Wed, 10 Feb 2021 04:10:53 +0000 (UTC)
Received: from [10.72.12.223] (ovpn-12-223.pek2.redhat.com [10.72.12.223])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C45D60C05;
        Wed, 10 Feb 2021 04:10:48 +0000 (UTC)
Subject: Re: [PATCH RFC v2 2/4] virtio-net: support receive timestamp
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     virtualization@lists.linux-foundation.org,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Willem de Bruijn <willemb@google.com>
References: <20210208185558.995292-1-willemdebruijn.kernel@gmail.com>
 <20210208185558.995292-3-willemdebruijn.kernel@gmail.com>
 <c089cb3e-96cb-b42a-5ce1-d54d298987c4@redhat.com>
 <CAF=yD-Jkm-Cfs2tHKhC17KfPp+=18y=9_XSuY-LNgkC-2_NfLA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <7ed23e65-b6b9-c699-b9aa-69aaf07034d0@redhat.com>
Date:   Wed, 10 Feb 2021 12:10:47 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-Jkm-Cfs2tHKhC17KfPp+=18y=9_XSuY-LNgkC-2_NfLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/2/9 下午9:53, Willem de Bruijn wrote:
> On Mon, Feb 8, 2021 at 11:13 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/2/9 上午2:55, Willem de Bruijn wrote:
>>> From: Willem de Bruijn <willemb@google.com>
>>>
>>> Add optional PTP hardware rx timestamp offload for virtio-net.
>>>
>>> Accurate RTT measurement requires timestamps close to the wire.
>>> Introduce virtio feature VIRTIO_NET_F_RX_TSTAMP. If negotiated, the
>>> virtio-net header is expanded with room for a timestamp.
>>>
>>> A device may pass receive timestamps for all or some packets. Flag
>>> VIRTIO_NET_HDR_F_TSTAMP signals whether a timestamp is recorded.
>>>
>>> A driver that supports hardware timestamping must also support
>>> ioctl SIOCSHWTSTAMP. Implement that, as well as information getters
>>> ioctl SIOCGHWTSTAMP and ethtool get_ts_info (`ethtool -T $DEV`).
>>>
>>> The timestamp straddles (virtual) hardware domains. Like PTP, use
>>> international atomic time (CLOCK_TAI) as global clock base. The driver
>>> must sync with the device, e.g., through kvm-clock.
>>>
>>> Tested:
>>>     guest: ./timestamping eth0 \
>>>             SOF_TIMESTAMPING_RAW_HARDWARE \
>>>             SOF_TIMESTAMPING_RX_HARDWARE
>>>     host: nc -4 -u 192.168.1.1 319
>>>
>>> Changes RFC -> RFCv2
>>>     - rename virtio_net_hdr_v12 to virtio_net_hdr_hash_ts
>>>     - add ethtool .get_ts_info to query capabilities
>>>     - add ioctl SIOC[GS]HWTSTAMP to configure feature
>>>     - add vi->enable_rx_tstamp to store configuration
>>>     - convert virtioXX_to_cpu to leXX_to_cpu
>>>     - convert reserved to __u32
>>>
>>> Signed-off-by: Willem de Bruijn <willemb@google.com>
>>>    static const struct net_device_ops virtnet_netdev = {
>>>        .ndo_open            = virtnet_open,
>>>        .ndo_stop            = virtnet_close,
>>> @@ -2573,6 +2676,7 @@ static const struct net_device_ops virtnet_netdev = {
>>>        .ndo_features_check     = passthru_features_check,
>>>        .ndo_get_phys_port_name = virtnet_get_phys_port_name,
>>>        .ndo_set_features       = virtnet_set_features,
>>> +     .ndo_do_ioctl           = virtnet_ioctl,
>>>    };
>>>
>>>    static void virtnet_config_changed_work(struct work_struct *work)
>>> @@ -3069,6 +3173,11 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>                vi->hdr_len = sizeof(struct virtio_net_hdr_v1_hash);
>>>        }
>>>
>>> +     if (virtio_has_feature(vdev, VIRTIO_NET_F_RX_TSTAMP)) {
>>> +             vi->has_rx_tstamp = true;
>>> +             vi->hdr_len = sizeof(struct virtio_net_hdr_hash_ts);
>>
>> Does this mean even if the device doesn't pass timestamp, the header
>> still contains the timestamp fields.
> Yes. As implemented, the size of the header is constant across
> packets. If both sides negotiate the feature, then all headers reserve
> space, whether or not the specific packet has a timestamp.
>
> So far headers are fixed size. I suppose we could investigate variable
> size headers. This goes back to our discussion in the previous
> patchset, that we can always add a packed-header feature later, if the
> number of optional features reaches a size that makes the complexity
> worthwhile.


Right, so for timstamp it's probably OK but we probably need to do as 
you said here if we want to add more in the header. Let's see how 
Michael think about this.


>
>>> +     }
>>> +
>>>        if (virtio_has_feature(vdev, VIRTIO_F_ANY_LAYOUT) ||
>>>            virtio_has_feature(vdev, VIRTIO_F_VERSION_1))
>>>                vi->any_header_sg = true;
>>> @@ -3260,7 +3369,7 @@ static struct virtio_device_id id_table[] = {
>>>        VIRTIO_NET_F_CTRL_MAC_ADDR, \
>>>        VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
>>>        VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
>>> -     VIRTIO_NET_F_TX_HASH
>>> +     VIRTIO_NET_F_TX_HASH, VIRTIO_NET_F_RX_TSTAMP
>>>
>>>    static unsigned int features[] = {
>>>        VIRTNET_FEATURES,
>>> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
>>> index 273d43c35f59..a5c84410cf92 100644
>>> --- a/include/uapi/linux/virtio_net.h
>>> +++ b/include/uapi/linux/virtio_net.h
>>> @@ -57,6 +57,7 @@
>>>                                         * Steering */
>>>    #define VIRTIO_NET_F_CTRL_MAC_ADDR 23       /* Set MAC address */
>>>
>>> +#define VIRTIO_NET_F_RX_TSTAMP         55    /* Device sends TAI receive time */
>>>    #define VIRTIO_NET_F_TX_HASH          56    /* Driver sends hash report */
>>>    #define VIRTIO_NET_F_HASH_REPORT  57        /* Supports hash report */
>>>    #define VIRTIO_NET_F_RSS      60    /* Supports RSS RX steering */
>>> @@ -126,6 +127,7 @@ struct virtio_net_hdr_v1 {
>>>    #define VIRTIO_NET_HDR_F_NEEDS_CSUM 1       /* Use csum_start, csum_offset */
>>>    #define VIRTIO_NET_HDR_F_DATA_VALID 2       /* Csum is valid */
>>>    #define VIRTIO_NET_HDR_F_RSC_INFO   4       /* rsc info in csum_ fields */
>>> +#define VIRTIO_NET_HDR_F_TSTAMP              8       /* timestamp is recorded */
>>>        __u8 flags;
>>>    #define VIRTIO_NET_HDR_GSO_NONE             0       /* Not a GSO frame */
>>>    #define VIRTIO_NET_HDR_GSO_TCPV4    1       /* GSO frame, IPv4 TCP (TSO) */
>>> @@ -181,6 +183,17 @@ struct virtio_net_hdr_v1_hash {
>>>        };
>>>    };
>>>
>>> +struct virtio_net_hdr_hash_ts {
>>> +     struct virtio_net_hdr_v1 hdr;
>>> +     struct {
>>> +             __le32 value;
>>> +             __le16 report;
>>> +             __le16 flow_state;
>>> +     } hash;
>>
>> Any reason for not embedding structure virtio_net_hdr_v1_hash?
> Just that it becomes an onion of struct inside structs. I can change
> if you prefer.


Yes please (unless Michael has other opinion).


>
>> Thanks
> As always, thanks for reviewing, Jason.
>

You're welcome :)

Thanks

