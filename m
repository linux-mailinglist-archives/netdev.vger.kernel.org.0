Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F443746E0
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhEERcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:32:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23292 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238058AbhEER3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 13:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620235693;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aNXhgUDVA9SEW7V5/BcN19LQy3bheL8S+WiGXESqRk8=;
        b=RBult4CIHHoVcbwE16EbgZoQQeZBeQhf6nG6MNTk2KYN2be86K8PkF38xxkgjWkqZ1rl09
        TlADasm4DhNPcwOHFTthQf9+zao0JkXJ5/JIXfSNpCWTNE5rqJZn/DbbvcjVhajHJ/9WRh
        PhwuJPmNooXEsWOySpixbb5gi/zRzKQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-tji4wlcoNCy0Tw9-Sl3B0A-1; Wed, 05 May 2021 13:28:11 -0400
X-MC-Unique: tji4wlcoNCy0Tw9-Sl3B0A-1
Received: by mail-wr1-f72.google.com with SMTP id 93-20020adf93e60000b029010d9bb1923eso984564wrp.4
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 10:28:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aNXhgUDVA9SEW7V5/BcN19LQy3bheL8S+WiGXESqRk8=;
        b=RdVGECrdWiUwliz0JzZ4oFm8hGOS83/MFMagx7ZExOCXeltYciz7l3KGVY5wgze6dA
         /kO5cknWpFPHI9ab9u1+nlQ29HncBCzTmZonydUyYGPEWnZtrUNfbvWh4xq4sLvpCW8A
         c4O2bMW+cE/V33OkrI3xSvQpVRTMEg9YGWl5rsjjiwqfwT7fryTDW0ppTEc71N8gxwsZ
         BONqL4qzeCI5KGfqQsypuzzEpHsX6dovyuHdq3+Km65VW+FdlvhE0V71CRzrkSLnk5/3
         Jxm/GA1Bdk9jcL8VBrbprFTPZRNVqAKm+ZODNsKsJrSbm3Rw6sg3ZleAap50+HaA+uv2
         J/+w==
X-Gm-Message-State: AOAM532qlRg3Rr2/9Vhpz5fdBjZVzMopyohnvWM2yT9TQ5xEfJq8kMOf
        Uhidh0n59JKzgevmhO6Hx6WPgMwEK11Ss29ucF5/wiRIlz7IZYg9sidkxvMhgUSvmEoVHmvjZB+
        XMt0A+iBImvHetvKj
X-Received: by 2002:adf:d1e8:: with SMTP id g8mr191381wrd.80.1620235690125;
        Wed, 05 May 2021 10:28:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxsuUd1jfyQJY/ur1HqJHJSag5SRCd4lwqrEmCIpjusoETf6n4Tltw6V47xCWGkwJRTIkoguw==
X-Received: by 2002:adf:d1e8:: with SMTP id g8mr191366wrd.80.1620235689948;
        Wed, 05 May 2021 10:28:09 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-108-140.dyn.eolo.it. [146.241.108.140])
        by smtp.gmail.com with ESMTPSA id l5sm6579335wmh.0.2021.05.05.10.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:28:09 -0700 (PDT)
Message-ID: <d6665869966936b79305de87aaddd052379038c4.camel@redhat.com>
Subject: Re: [PATCH net 1/4] net: fix double-free on fraglist GSO skbs
From:   Paolo Abeni <pabeni@redhat.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Date:   Wed, 05 May 2021 19:28:08 +0200
In-Reply-To: <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
References: <cover.1620223174.git.pabeni@redhat.com>
         <e5d4bacef76ef439b6eb8e7f4973161ca131dfee.1620223174.git.pabeni@redhat.com>
         <CAF=yD-+BAMU+ETz9MV--MR5NuCE9VrtNezDB3mAiBQR+5puZvQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-05-05 at 12:13 -0400, Willem de Bruijn wrote:
> On Wed, May 5, 2021 at 11:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
> > While segmenting a SKB_GSO_FRAGLIST GSO packet, if the destructor
> > callback is available, the skb destructor is invoked on each
> > aggregated packet via skb_release_head_state().
> > 
> > Such field (and the pairer skb->sk) is left untouched, so the same
> > destructor is invoked again when the segmented skbs are freed, leading
> > to double-free/UaF of the relevant socket.
> 
> Similar to skb_segment, should the destructor be swapped with the last
> segment and callback delayed, instead of called immediately as part of
> segmentation?
> 
>         /* Following permits correct backpressure, for protocols
>          * using skb_set_owner_w().
>          * Idea is to tranfert ownership from head_skb to last segment.
>          */
>         if (head_skb->destructor == sock_wfree) {
>                 swap(tail->truesize, head_skb->truesize);
>                 swap(tail->destructor, head_skb->destructor);
>                 swap(tail->sk, head_skb->sk);
>         }

My understanding is that one assumption in the original
SKB_GSO_FRAGLIST implementation was that SKB_GSO_FRAGLIST skbs are not
owned by any socket. 

AFAICS the above assumption was true until:

commit c75fb320d482a5ce6e522378d137fd2c3bf79225
Author: Paolo Abeni <pabeni@redhat.com>
Date:   Fri Apr 9 13:04:37 2021 +0200

    veth: use skb_orphan_partial instead of skb_orphan

after that, if the skb is owned, skb->destructor is sock_efree(), so
the above code should not trigger.

More importantly SKB_GSO_FRAGLIST can only be applied if the inner-
most protocol is UDP, so
commit 432c856fcf45c468fffe2e5029cb3f95c7dc9475
and d6a4a10411764cf1c3a5dad4f06c5ebe5194488b should not be relevant. 

Thanks!

Paolo

