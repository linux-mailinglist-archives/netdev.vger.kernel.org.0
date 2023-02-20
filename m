Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B926969CB78
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjBTM43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjBTM42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:56:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DAF6583
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 04:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676897740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t5T9bZZKt8QsdieBTdNvr7iToD1QjAmvloZaVLt8Qlc=;
        b=ACQGhoK/Rs9xZWf2yOeZuzbjIYdM0y+qcHMbNFg+Nv0xuMb//9SQ/d0iE4NT0sW/fwCIuQ
        O5CakJ8zRtZGj2xYb5N2oG2SqsSW6b/QcEGlTLSkRL/0SNb+eYe/mq1x+KpUmk4dcd2liv
        8ioY7NNjkPkGtQ++XMZDYV5ljKMs8ZY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-13-chw42eynNviJF31k1V144g-1; Mon, 20 Feb 2023 07:55:38 -0500
X-MC-Unique: chw42eynNviJF31k1V144g-1
Received: by mail-wm1-f70.google.com with SMTP id p22-20020a7bcc96000000b003e2036a1516so510618wma.7
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 04:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5T9bZZKt8QsdieBTdNvr7iToD1QjAmvloZaVLt8Qlc=;
        b=Y4A+hmibiGuv9CeBRZ1ekSY9q81ZUpJZfVwKxlJNkPHMMz8IpvLOhu7jjUQOPSK0pO
         1rQbQ6tOVVBuAbTMcrx7HZz5OuzfvLZpBoMGP/3aWqUAcCfRdPhZlv+Fqurhmk0Gaecx
         zZDDfQnTpAXUwTdhayXKjKF1COaiyA2tO70pW8jBIgcb2XPVUaxFQTxhHy1TG4CJFYBi
         VZ1FleoJjxggysj4Jva9mwh8btVJpF1boRp4zSb1Sy8lmpXGQwp5pjzuUVTUSou+A1eZ
         TDdgpYFiW01PK+ulDMY9NBIkrIcx6TRZwqL/leanDCo47CdGnlV9tJHUpAO++Bh3Dd6g
         tNGA==
X-Gm-Message-State: AO0yUKXijPcD2ajVQGaqZ5cYSaU8e9yCVXA24bJHdO9Iu53QaGChK9mQ
        CQiLgIJymnqFFSh1yZ9PVU7MzbZM9qlNtXKPuF83k/+R73Ap4MIGPHOB6jS3W+aWGnMISeTsS8k
        s5svvhh9wNxvrSFNY
X-Received: by 2002:a05:600c:319a:b0:3df:d431:cf64 with SMTP id s26-20020a05600c319a00b003dfd431cf64mr225437wmp.39.1676897737814;
        Mon, 20 Feb 2023 04:55:37 -0800 (PST)
X-Google-Smtp-Source: AK7set9MI/dsrz3E0sVvpzNF+oMUF9C/eNq3ChWdTY2lAFidx7zFfAjZqw7+KQ0K84Mn2XSwoT0xmg==
X-Received: by 2002:a05:600c:319a:b0:3df:d431:cf64 with SMTP id s26-20020a05600c319a00b003dfd431cf64mr225427wmp.39.1676897737450;
        Mon, 20 Feb 2023 04:55:37 -0800 (PST)
Received: from redhat.com ([2.52.5.34])
        by smtp.gmail.com with ESMTPSA id p8-20020a1c7408000000b003b47b80cec3sm151899wmc.42.2023.02.20.04.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Feb 2023 04:55:36 -0800 (PST)
Date:   Mon, 20 Feb 2023 07:55:33 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Vitaly Mireyno <vmireyno@marvell.com>
Subject: Re: [patch net-next] net: virtio_net: implement exact header length
 guest feature
Message-ID: <20230220074947-mutt-send-email-mst@kernel.org>
References: <20230217121547.3958716-1-jiri@resnulli.us>
 <20230217072032-mutt-send-email-mst@kernel.org>
 <Y+94418p73aUQyIn@nanopsycho>
 <20230217083915-mutt-send-email-mst@kernel.org>
 <Y/MwtAGru3yAY7r3@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/MwtAGru3yAY7r3@nanopsycho>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 09:35:00AM +0100, Jiri Pirko wrote:
> Fri, Feb 17, 2023 at 02:47:36PM CET, mst@redhat.com wrote:
> >On Fri, Feb 17, 2023 at 01:53:55PM +0100, Jiri Pirko wrote:
> >> Fri, Feb 17, 2023 at 01:22:01PM CET, mst@redhat.com wrote:
> >> >On Fri, Feb 17, 2023 at 01:15:47PM +0100, Jiri Pirko wrote:
> >> >> From: Jiri Pirko <jiri@nvidia.com>
> >> >> 
> >> >> virtio_net_hdr_from_skb() fills up hdr_len to skb_headlen(skb).
> >> >> 
> >> >> Virtio spec introduced a feature VIRTIO_NET_F_GUEST_HDRLEN which when
> >> >> set implicates that the driver provides the exact size of the header.
> >> >> 
> >> >> The driver already complies to fill the correct value. Introduce the
> >> >> feature and advertise it.
> >> >> 
> >> >> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> >> >
> >> >Could you add a bit of motivation just for the record?
> >> >Does this improve performance for some card? By how much?
> >> >Expected to help some future card?
> >> 
> >> I can get that info, but isn't that rather something to be appended to
> >> the virtio-spec patch? I mean, the feature is there, this is just
> >> implementing it in one driver.
> >
> >It is more like using it in the driver.  It's not like we have to use
> >everything - it could be useful for e.g. dpdk but not linux.
> >Implementing it in the Linux driver has support costs - for example what
> >if there's a bug and sometimes the length is incorrect?
> >We'll be breaking things.
> 
> I understand. To my understanding this feature just fixes the original
> ambiguity in the virtio spec.
> 
> Quoting the original virtio spec:
> "hdr_len is a hint to the device as to how much of the header needs to
>  be kept to copy into each packet"
> 
> "a hint" might not be clear for the reader what does it mean, if it is
> "maybe like that" of "exactly like that". This feature just makes it
> crystal clear.
> 
> If you look at the tap implementation, it uses hdr_len to alloc
> skb linear part. No hint, it counts with the provided value.
> So if the driver is currently not precise, it breaks tap.

Well that's only for gso though right?
And making it bigger than necessary works fine ...

> I will add this to the patch description and send v2.
> 

I feel this does not answer the question yet, or maybe I am being dense.
My point was not about making hdr_len precise.  My point was that we are
making a change here for no apparent reason. I am guessing you are not
doing it for fun - so why? Is there a device with this feature bit
you are aware of?



> 
> >
> >The patch was submitted by Marvell but they never bothered with
> >using it in Linux. I guess they are using it for something else?
> >CC Vitaly who put this in.
> >
> >> 
> >> >
> >> >thanks!
> >> >
> >> >
> >> >> ---
> >> >>  drivers/net/virtio_net.c        | 6 ++++--
> >> >>  include/uapi/linux/virtio_net.h | 1 +
> >> >>  2 files changed, 5 insertions(+), 2 deletions(-)
> >> >> 
> >> >> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> >> >> index fb5e68ed3ec2..e85b03988733 100644
> >> >> --- a/drivers/net/virtio_net.c
> >> >> +++ b/drivers/net/virtio_net.c
> >> >> @@ -62,7 +62,8 @@ static const unsigned long guest_offloads[] = {
> >> >>  	VIRTIO_NET_F_GUEST_UFO,
> >> >>  	VIRTIO_NET_F_GUEST_CSUM,
> >> >>  	VIRTIO_NET_F_GUEST_USO4,
> >> >> -	VIRTIO_NET_F_GUEST_USO6
> >> >> +	VIRTIO_NET_F_GUEST_USO6,
> >> >> +	VIRTIO_NET_F_GUEST_HDRLEN
> >> >>  };
> >> >>  
> >> >>  #define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
> >> >> @@ -4213,7 +4214,8 @@ static struct virtio_device_id id_table[] = {
> >> >>  	VIRTIO_NET_F_CTRL_MAC_ADDR, \
> >> >>  	VIRTIO_NET_F_MTU, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS, \
> >> >>  	VIRTIO_NET_F_SPEED_DUPLEX, VIRTIO_NET_F_STANDBY, \
> >> >> -	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL
> >> >> +	VIRTIO_NET_F_RSS, VIRTIO_NET_F_HASH_REPORT, VIRTIO_NET_F_NOTF_COAL, \
> >> >> +	VIRTIO_NET_F_GUEST_HDRLEN
> >> >>  
> >> >>  static unsigned int features[] = {
> >> >>  	VIRTNET_FEATURES,
> >> >> diff --git a/include/uapi/linux/virtio_net.h b/include/uapi/linux/virtio_net.h
> >> >> index b4062bed186a..12c1c9699935 100644
> >> >> --- a/include/uapi/linux/virtio_net.h
> >> >> +++ b/include/uapi/linux/virtio_net.h
> >> >> @@ -61,6 +61,7 @@
> >> >>  #define VIRTIO_NET_F_GUEST_USO6	55	/* Guest can handle USOv6 in. */
> >> >>  #define VIRTIO_NET_F_HOST_USO	56	/* Host can handle USO in. */
> >> >>  #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
> >> >> +#define VIRTIO_NET_F_GUEST_HDRLEN  59	/* Guest provides the exact hdr_len value. */
> >> >>  #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
> >> >>  #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
> >> >>  #define VIRTIO_NET_F_STANDBY	  62	/* Act as standby for another device
> >> >> -- 
> >> >> 2.39.0
> >> >
> >

