Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B648315C85F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 17:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgBMQhb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 11:37:31 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728055AbgBMQhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 11:37:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581611849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCOS1WTh+5YoNP9A08K63Y7Q0hZciqVvtfKTwj5+FFA=;
        b=aV3dT/y7rx/fctBPI91Jw1JAyjk/k1OC9qwiPtRxDedZc6vOi5o2sTynDXUwea6I/N5slp
        pSJ8lJ5oDu8DxMsN+tAuE7+HiJJgrAleEIUnbkPb57gTeCP9FE1CfzYp+U+n+osueTVjFc
        v+DLAfKbIz5QajY4riegMz5Z31jP2Aw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-nWgFk4-CM72Po8duaLv61A-1; Thu, 13 Feb 2020 11:37:23 -0500
X-MC-Unique: nWgFk4-CM72Po8duaLv61A-1
Received: by mail-qk1-f197.google.com with SMTP id a132so4098898qkg.5
        for <netdev@vger.kernel.org>; Thu, 13 Feb 2020 08:37:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=eCOS1WTh+5YoNP9A08K63Y7Q0hZciqVvtfKTwj5+FFA=;
        b=m/SddR75TPYt8Nq1ggRf1n3BJPo/ikHFuf1h2Uj6omCHf3x8n9rNvt4xjc50i7f+kX
         03GqcjLMvqCpZ8DZTT7QEoi5sBkgV5jZ89z+M0mlnKW8jH1+5caZZHo+v8X/n+URQo9h
         jbEuAFMwvKgpVilf85wUYobr2Tmb1SARYP6Eu0l3s6U+MD3txIhcbpebP+tNs5X5fmzh
         KHNXz5IGHVkdV5kRoyLNHFvCLPxlHKR2YVbXng1HN+zWtKpJNw1B8goK5sKsGlSvxPlM
         vUqgoxa3to0MXFqtW9pBKzc6kvMKEVpulTNfXfeCmSmKs35uSM3BuEQ9JXtptM2/0LzI
         Q6Kg==
X-Gm-Message-State: APjAAAXYT/lpied+UE/WuhBhNQe9CYB0vMXgXt1JyC0CJFRAvHGlBKyf
        LDTmpLIJ2rQx6g5Qm2EU5YZ9SPUf6Lww5ojzIcP5Wn4NpyimC0+kD+u07LqNzoPQmrx6bKYOx6c
        Dj1ORNybh3RTbV9cK
X-Received: by 2002:a05:620a:89e:: with SMTP id b30mr16113967qka.398.1581611841143;
        Thu, 13 Feb 2020 08:37:21 -0800 (PST)
X-Google-Smtp-Source: APXvYqxvgU/Go4ObHDgoqZyrNkss5Y1hUf6NDyAxdpnATEPwDonOvDUWqewU3vmkE/IllyLsw5QSgg==
X-Received: by 2002:a05:620a:89e:: with SMTP id b30mr16113944qka.398.1581611840852;
        Thu, 13 Feb 2020 08:37:20 -0800 (PST)
Received: from redhat.com (bzq-79-176-28-95.red.bezeqint.net. [79.176.28.95])
        by smtp.gmail.com with ESMTPSA id o187sm1541284qkf.26.2020.02.13.08.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Feb 2020 08:37:20 -0800 (PST)
Date:   Thu, 13 Feb 2020 11:37:16 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-um@lists.infradead.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200213113654-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <9547228b-aa93-f2b6-6fdc-8d33cde3716a@cambridgegreys.com>
 <20200213045937-mutt-send-email-mst@kernel.org>
 <94fb9656-99ee-a001-e428-9d76c3620e61@gmail.com>
 <20200213105010-mutt-send-email-mst@kernel.org>
 <35510da7-08f1-4aa5-c6d6-6bffbccaee0c@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35510da7-08f1-4aa5-c6d6-6bffbccaee0c@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 04:23:24PM +0000, Anton Ivanov wrote:
> 
> On 13/02/2020 15:53, Michael S. Tsirkin wrote:
> > On Thu, Feb 13, 2020 at 07:44:06AM -0800, Eric Dumazet wrote:
> > > 
> > > On 2/13/20 2:00 AM, Michael S. Tsirkin wrote:
> > > > On Wed, Feb 12, 2020 at 05:38:09PM +0000, Anton Ivanov wrote:
> > > > > 
> > > > > On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> > > > > > On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> > > > > > > On 11/02/2020 02:51, Jason Wang wrote:
> > > > > > > > On 2020/2/11 上午12:55, Anton Ivanov wrote:
> > > > > > > > > 
> > > > > > > > > On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> > > > > > > > > > From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > > > > > 
> > > > > > > > > > Some of the frames marked as GSO which arrive at
> > > > > > > > > > virtio_net_hdr_from_skb() have no GSO_TYPE, no
> > > > > > > > > > fragments (data_len = 0) and length significantly shorter
> > > > > > > > > > than the MTU (752 in my experiments).
> > > > > > > > > > 
> > > > > > > > > > This is observed on raw sockets reading off vEth interfaces
> > > > > > > > > > in all 4.x and 5.x kernels I tested.
> > > > > > > > > > 
> > > > > > > > > > These frames are reported as invalid while they are in fact
> > > > > > > > > > gso-less frames.
> > > > > > > > > > 
> > > > > > > > > > This patch marks the vnet header as no-GSO for them instead
> > > > > > > > > > of reporting it as invalid.
> > > > > > > > > > 
> > > > > > > > > > Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > > > > > ---
> > > > > > > > > >     include/linux/virtio_net.h | 8 ++++++--
> > > > > > > > > >     1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > > > > > > 
> > > > > > > > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > > > > > > > index 0d1fe9297ac6..d90d5cff1b9a 100644
> > > > > > > > > > --- a/include/linux/virtio_net.h
> > > > > > > > > > +++ b/include/linux/virtio_net.h
> > > > > > > > > > @@ -112,8 +112,12 @@ static inline int
> > > > > > > > > > virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > > > > > > > >                 hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> > > > > > > > > >             else if (sinfo->gso_type & SKB_GSO_TCPV6)
> > > > > > > > > >                 hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> > > > > > > > > > -        else
> > > > > > > > > > -            return -EINVAL;
> > > > > > > > > > +        else {
> > > > > > > > > > +            if (skb->data_len == 0)
> > > > > > > > > > +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> > > > > > > > > > +            else
> > > > > > > > > > +                return -EINVAL;
> > > > > > > > > > +        }
> > > > > > > > > >             if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> > > > > > > > > >                 hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> > > > > > > > > >         } else
> > > > > > > > > > 
> > > > > > > > > ping.
> > > > > > > > > 
> > > > > > > > Do you mean gso_size is set but gso_type is not? Looks like a bug
> > > > > > > > elsewhere.
> > > > > > > > 
> > > > > > > > Thanks
> > > > > > > > 
> > > > > > > > 
> > > > > > > Yes.
> > > > > > > 
> > > > > > > I could not trace it where it is coming from.
> > > > > > > 
> > > > > > > I see it when doing recvmmsg on raw sockets in the UML vector network
> > > > > > > drivers.
> > > > > > > 
> > > > > > I think we need to find the culprit and fix it there, lots of other things
> > > > > > can break otherwise.
> > > > > > Just printing out skb->dev->name should do the trick, no?
> > > > > The printk in virtio_net_hdr_from_skb says NULL.
> > > > > 
> > > > > That is probably normal for a locally originated frame.
> > > > > 
> > > > > I cannot reproduce this with network traffic by the way - it happens only if the traffic is locally originated on the host.
> > > > > 
> > > > > A,
> > > > OK so is it code in __tcp_transmit_skb that sets gso_size to non-null
> > > > when gso_type is 0?
> > > > 
> > > Correct way to determine if a packet is a gso one is by looking at gso_size.
> > > Then only it is legal looking at gso_type
> > > 
> > > 
> > > static inline bool skb_is_gso(const struct sk_buff *skb)
> > > {
> > >      return skb_shinfo(skb)->gso_size;
> > > }
> > > 
> > > /* Note: Should be called only if skb_is_gso(skb) is true */
> > > static inline bool skb_is_gso_v6(const struct sk_buff *skb)
> > > ...
> > > 
> > > 
> > > There is absolutely no relation between GSO and skb->data_len, skb can be linearized
> > > for various orthogonal reasons.
> > The reported problem is that virtio gets a packet where gso_size
> > is !0 but gso_type is 0.
> > 
> > It currently drops these on the assumption that it's some type
> > of a gso packet it does not know how to handle.
> > 
> > 
> > So you are saying if skb_is_gso we can still have gso_type set to 0,
> > and that's an expected configuration?
> > 
> > So the patch should just be:
> > 
> > 
> > -        if (skb_is_gso(skb)) {
> > +        if (skb_is_gso(skb) && sinfo->gso_type) {
> > 
> Yes, provided that skb_is_gso(skb) and sinfo->gso_type == 0 is a valid state.
> 
> I agree with Jason, there may be something wrong going on here and we need to find the source which creates these packets.
> 
> A.

Well Eric will know for sure. Eric is skb_is_gso(skb) and
sinfo->gso_type == 0 a valid state?

> > 
> > ?
> > 
> > 
> > _______________________________________________
> > linux-um mailing list
> > linux-um@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-um
> 
> -- 
> Anton R. Ivanov
> Cambridgegreys Limited. Registered in England. Company Number 10273661
> https://www.cambridgegreys.com/

