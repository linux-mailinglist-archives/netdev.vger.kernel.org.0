Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE6D158CCE
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 11:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgBKKiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 05:38:00 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50227 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727805AbgBKKh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 05:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581417478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ShA6gshvRnZ0GGC3w/T/LthefFbDChD5+kxR6pT+rSA=;
        b=amFDSnTSO00PfReLhLkVBfcjluljXM5RQqGwPhndL7c2OqTNaMgRAGi/aFpS0WB5pX/Ymi
        OeUfm2pRtJsR6WXlEsdp7ANg/55w1MAbQcpqRwhnpPtT6IDgEpSHWxRTYwGKv40egGySjo
        /b/JSYMNdb1pxmLZDFzFveHyAOHG10E=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-XeK1FiYtN6u2SS6c8Xa2Nw-1; Tue, 11 Feb 2020 05:37:55 -0500
X-MC-Unique: XeK1FiYtN6u2SS6c8Xa2Nw-1
Received: by mail-qk1-f197.google.com with SMTP id v81so3998478qkb.11
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 02:37:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ShA6gshvRnZ0GGC3w/T/LthefFbDChD5+kxR6pT+rSA=;
        b=detoDPmqge5skt/If/zzZNTl+o5QpeI6xfKf9ZaUaphscW8UrNNxHTJ6DwRbz8UMse
         PfRhAtsluxGzE+MiktrAI6cvb7Il7B6F/xIgv+L4i4Gp9AAkExR/wdxDyCv1HLzm6Yrq
         hAgBWfLB8gRVc9rH7AFehDTpFDrj1HJ75ufj3Zof5L5FTzx79SmVenSPWmASLBGDV7YY
         ESGGWiK0GE7IrbWlbmzePiOvJe296HczKuLAXIxwcFbCLFTifzyA26CA18Kcji+GN073
         PfxyHLph6fWb6qjhp/ypa81Z/9qZ6yaHPIjYXEXu0756NNzJEgb4vxTYL/s4KgQ10IL6
         Ectw==
X-Gm-Message-State: APjAAAVs7HOfxwO/dq91HxYOXL3mV1I1heNvGeQwBX8SEdJOCxJSxKex
        Mvc5RV0a44MKmfvoRv/Ltz3cmkEKyzvD0o1zJJvQQCzd7TE7pNZU6QQwAJ7z2MA5kyPcT6wM3co
        s+w6GngE/JIoglibi
X-Received: by 2002:a0c:ea50:: with SMTP id u16mr14484813qvp.110.1581417475251;
        Tue, 11 Feb 2020 02:37:55 -0800 (PST)
X-Google-Smtp-Source: APXvYqy8CBMwITEeHUVRHIfIioI1sZv68eWt44VxQnsBgQVT6VXW8NhtMwPENj6EvZ4Ioukyy/gL1g==
X-Received: by 2002:a0c:ea50:: with SMTP id u16mr14484803qvp.110.1581417475041;
        Tue, 11 Feb 2020 02:37:55 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id v55sm1987057qtc.1.2020.02.11.02.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 02:37:54 -0800 (PST)
Date:   Tue, 11 Feb 2020 05:37:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200211053502-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> On 11/02/2020 02:51, Jason Wang wrote:
> > 
> > On 2020/2/11 上午12:55, Anton Ivanov wrote:
> > > 
> > > 
> > > On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> > > > From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > 
> > > > Some of the frames marked as GSO which arrive at
> > > > virtio_net_hdr_from_skb() have no GSO_TYPE, no
> > > > fragments (data_len = 0) and length significantly shorter
> > > > than the MTU (752 in my experiments).
> > > > 
> > > > This is observed on raw sockets reading off vEth interfaces
> > > > in all 4.x and 5.x kernels I tested.
> > > > 
> > > > These frames are reported as invalid while they are in fact
> > > > gso-less frames.
> > > > 
> > > > This patch marks the vnet header as no-GSO for them instead
> > > > of reporting it as invalid.
> > > > 
> > > > Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > ---
> > > >   include/linux/virtio_net.h | 8 ++++++--
> > > >   1 file changed, 6 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > index 0d1fe9297ac6..d90d5cff1b9a 100644
> > > > --- a/include/linux/virtio_net.h
> > > > +++ b/include/linux/virtio_net.h
> > > > @@ -112,8 +112,12 @@ static inline int
> > > > virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > >               hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> > > >           else if (sinfo->gso_type & SKB_GSO_TCPV6)
> > > >               hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> > > > -        else
> > > > -            return -EINVAL;
> > > > +        else {
> > > > +            if (skb->data_len == 0)
> > > > +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> > > > +            else
> > > > +                return -EINVAL;
> > > > +        }
> > > >           if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> > > >               hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> > > >       } else
> > > > 
> > > 
> > > ping.
> > > 
> > 
> > Do you mean gso_size is set but gso_type is not? Looks like a bug
> > elsewhere.
> > 
> > Thanks
> > 
> > 
> Yes.
> 
> I could not trace it where it is coming from.
> 
> I see it when doing recvmmsg on raw sockets in the UML vector network
> drivers.
> 

I think we need to find the culprit and fix it there, lots of other things
can break otherwise.
Just printing out skb->dev->name should do the trick, no?


> -- 
> Anton R. Ivanov
> Cambridgegreys Limited. Registered in England. Company Number 10273661
> https://www.cambridgegreys.com/

