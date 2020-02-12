Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECB315A627
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgBLKT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:19:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31257 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725887AbgBLKT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:19:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581502796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pkNV/KaDwN6AKmUOQ5xnMqy8J0aNzbNDziugjPZsXyc=;
        b=KY84ElQB3g5+CtWCJMgA0xKce7366fni3KaBJeEymxomCevTh8bmfwHGUForH5eGhvAL9U
        UZ0DSqJBoO9eLFPoYuc+zLSBN+4XipnLiDi/uZ5JM6TbFl9j3T76m+WonJ2cVMhFVWj3oL
        L96GI+7zoV9ddku9VCZ3m4oJswhiZiM=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-179-a4dinS4SODqh_n8n9D_S3w-1; Wed, 12 Feb 2020 05:19:50 -0500
X-MC-Unique: a4dinS4SODqh_n8n9D_S3w-1
Received: by mail-qk1-f200.google.com with SMTP id n126so1009339qkc.18
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 02:19:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=pkNV/KaDwN6AKmUOQ5xnMqy8J0aNzbNDziugjPZsXyc=;
        b=MciWl5MBnCL3TchHh6FoibU5wESka+9R7fZfU5EgVCrhKZqx11312gMuoAxv5UZX1W
         Xy36G5K/xf6exbUxobPcP1mQjBDc01n+0qWeqca+V4lVJItM98A0/ukStrcTg/QfxuII
         ImhrT/M/WynrpT1AJOO9TpISAXDq+iNCbA1YLnZ2/1+DmzUr98qPaOppJyg7mF2BbCoy
         4Zc0ZpnpVOaRVKtzgtYbxCHZbfpA2e809Jb6BsVbTP7BA7RbmH5qQY2T3cCakNR7TDGs
         WV9rwFa+sqXeuHTPiHIJT5LTVYf5brtK0DVvSLnHK3vFs9ww6bKOLfeX0AmodG59tC/X
         CVHg==
X-Gm-Message-State: APjAAAVzHVe4XQmrz7u1buv3eko8jflwwCz/dn1MYF4r+GzXWmdRjI1h
        ApeN5jVbutZjzPH9Of2/TExq1fVtAiD4Kl7vQCWTZ+KC8dvbRzw/HYcFhvFPX2erwAOYduh5Y1F
        BU/Wpg+RnSy4Jn5Ga
X-Received: by 2002:ac8:498f:: with SMTP id f15mr6359535qtq.123.1581502789849;
        Wed, 12 Feb 2020 02:19:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8bIfk3B81LZ2B3XHLSDkzZ+2r6RRQancRdP1l7oFpUpC4EeBkeHbMVGxD5yYdqkLQc9G2DA==
X-Received: by 2002:ac8:498f:: with SMTP id f15mr6359509qtq.123.1581502789462;
        Wed, 12 Feb 2020 02:19:49 -0800 (PST)
Received: from redhat.com (bzq-79-176-41-183.red.bezeqint.net. [79.176.41.183])
        by smtp.gmail.com with ESMTPSA id s6sm1435263qth.16.2020.02.12.02.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2020 02:19:48 -0800 (PST)
Date:   Wed, 12 Feb 2020 05:19:44 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        linux-um@lists.infradead.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio: Work around frames incorrectly marked as gso
Message-ID: <20200212051913-mutt-send-email-mst@kernel.org>
References: <20191209104824.17059-1-anton.ivanov@cambridgegreys.com>
 <57230228-7030-c65f-a24f-910ca52bbe9e@cambridgegreys.com>
 <f78bfe6e-2ffc-3734-9618-470f1afea0c6@redhat.com>
 <918222d9-816a-be70-f8af-b8dfcb586240@cambridgegreys.com>
 <20200211053502-mutt-send-email-mst@kernel.org>
 <8e730fe1-3129-de8d-bcb6-d5e10695238a@cambridgegreys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e730fe1-3129-de8d-bcb6-d5e10695238a@cambridgegreys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 10:03:31AM +0000, Anton Ivanov wrote:
> 
> 
> On 11/02/2020 10:37, Michael S. Tsirkin wrote:
> > On Tue, Feb 11, 2020 at 07:42:37AM +0000, Anton Ivanov wrote:
> > > On 11/02/2020 02:51, Jason Wang wrote:
> > > > 
> > > > On 2020/2/11 上午12:55, Anton Ivanov wrote:
> > > > > 
> > > > > 
> > > > > On 09/12/2019 10:48, anton.ivanov@cambridgegreys.com wrote:
> > > > > > From: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > 
> > > > > > Some of the frames marked as GSO which arrive at
> > > > > > virtio_net_hdr_from_skb() have no GSO_TYPE, no
> > > > > > fragments (data_len = 0) and length significantly shorter
> > > > > > than the MTU (752 in my experiments).
> > > > > > 
> > > > > > This is observed on raw sockets reading off vEth interfaces
> > > > > > in all 4.x and 5.x kernels I tested.
> > > > > > 
> > > > > > These frames are reported as invalid while they are in fact
> > > > > > gso-less frames.
> > > > > > 
> > > > > > This patch marks the vnet header as no-GSO for them instead
> > > > > > of reporting it as invalid.
> > > > > > 
> > > > > > Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> > > > > > ---
> > > > > >    include/linux/virtio_net.h | 8 ++++++--
> > > > > >    1 file changed, 6 insertions(+), 2 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
> > > > > > index 0d1fe9297ac6..d90d5cff1b9a 100644
> > > > > > --- a/include/linux/virtio_net.h
> > > > > > +++ b/include/linux/virtio_net.h
> > > > > > @@ -112,8 +112,12 @@ static inline int
> > > > > > virtio_net_hdr_from_skb(const struct sk_buff *skb,
> > > > > >                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV4;
> > > > > >            else if (sinfo->gso_type & SKB_GSO_TCPV6)
> > > > > >                hdr->gso_type = VIRTIO_NET_HDR_GSO_TCPV6;
> > > > > > -        else
> > > > > > -            return -EINVAL;
> > > > > > +        else {
> > > > > > +            if (skb->data_len == 0)
> > > > > > +                hdr->gso_type = VIRTIO_NET_HDR_GSO_NONE;
> > > > > > +            else
> > > > > > +                return -EINVAL;
> > > > > > +        }
> > > > > >            if (sinfo->gso_type & SKB_GSO_TCP_ECN)
> > > > > >                hdr->gso_type |= VIRTIO_NET_HDR_GSO_ECN;
> > > > > >        } else
> > > > > > 
> > > > > 
> > > > > ping.
> > > > > 
> > > > 
> > > > Do you mean gso_size is set but gso_type is not? Looks like a bug
> > > > elsewhere.
> > > > 
> > > > Thanks
> > > > 
> > > > 
> > > Yes.
> > > 
> > > I could not trace it where it is coming from.
> > > 
> > > I see it when doing recvmmsg on raw sockets in the UML vector network
> > > drivers.
> > > 
> > 
> > I think we need to find the culprit and fix it there, lots of other things
> > can break otherwise.
> > Just printing out skb->dev->name should do the trick, no?
> 
> I will rebuild my rig and retest (it's been a while since I worked on this bug).
> 
> In theory, it should be veth - the test is over a vEth pair and all frames are locally originated by iperf.
> 
> In practice - I will retest and post the results sometimes later today.
> 
> Brgds,


ok if it's veth then you need to add a similar printk patch to veth
and re-run to see where does it come from originally.

> >
> > 
> > 
> > > -- 
> > > Anton R. Ivanov
> > > Cambridgegreys Limited. Registered in England. Company Number 10273661
> > > https://www.cambridgegreys.com/
> > 
> > 
> > _______________________________________________
> > linux-um mailing list
> > linux-um@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-um
> > 
> 
> -- 
> Anton R. Ivanov
> Cambridgegreys Limited. Registered in England. Company Number 10273661
> https://www.cambridgegreys.com/

