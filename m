Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83D2048B2F6
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbiAKRLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:11:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43096 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244210AbiAKRLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:11:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641921067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8zWK4tN+9sCHLKxamK/wjM5K43GyYWdN/7hQupmm6IE=;
        b=HGgJi0MxH4OEKaMBF1cgIem2z9hvj6DukcreX0Jbswj7cxJqw3x/rW3Ryc4HEQ8FjHETyB
        kuxRTGHgllOk07zi1cif/Y+pkS1rtMn1ccDASm163fnOTBlxU+EKwjtcYz/xjEHZfe0HwO
        ogYNhJ64gYVz+xJq+c9cU07KZnZn9qg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-k-BwRD8XMLqt634tf77eTA-1; Tue, 11 Jan 2022 12:11:06 -0500
X-MC-Unique: k-BwRD8XMLqt634tf77eTA-1
Received: by mail-wr1-f71.google.com with SMTP id w25-20020adf8bd9000000b001a255212b7cso4961903wra.18
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 09:11:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8zWK4tN+9sCHLKxamK/wjM5K43GyYWdN/7hQupmm6IE=;
        b=o5O2B8+JdUrkwuDggGHuUJFAAWvDkLDEVfMDhKuP3+zFSqJHzFIukUCg6YJZELpccd
         OR0VaXg7y7Tr3OqzQL4fhJRfMv4RrMRajC8J+82eTKSQM4DxtVv6xJhrxC+Bfh0F4CCu
         k4VGCoI8ob36D6Nkzvp5GQDkhQ1LRZRN3ytmDIvxuLv+rcOszDV+m5IVGzoLK3xphMwB
         VcaBcd+Y9cLQfJjjwpkyvN2c5sxTYVQWZ5cF/UZXFLDcTMhavr5cle7Its+meEqb8fzB
         yZ5CoEkS9lwRNCpSx6SPeNIGbr+JCcdDEq9ETqjz69wY59iz4ZY6pObgYbYQfPG0yY5j
         pTBA==
X-Gm-Message-State: AOAM530BD2drixm2on65ykGYsL4T4xcNp5Wh3QHEysAU4wIpnJPSG3Nv
        VJA+cPEBPSJXQ9l9uenkTfTOT6oJAq6qh+KGtSF63D5FcAoTPYX2n+VWQDTL8wkHYn+/S7kWywm
        3NIywGRXu16p3bCsk
X-Received: by 2002:adf:d222:: with SMTP id k2mr4451520wrh.332.1641921065237;
        Tue, 11 Jan 2022 09:11:05 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyXpslAh5ADGc3957eLtWJpzW3P/MighujLUPuX4ruiB8rgSb0yOAB/BZQ8T7j19gWqojV1vQ==
X-Received: by 2002:adf:d222:: with SMTP id k2mr4451503wrh.332.1641921065031;
        Tue, 11 Jan 2022 09:11:05 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-96-254.dyn.eolo.it. [146.241.96.254])
        by smtp.gmail.com with ESMTPSA id z4sm2116440wmf.44.2022.01.11.09.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:11:04 -0800 (PST)
Message-ID: <48293134f179d643e9ec7bcbd7bca895df7611ac.camel@redhat.com>
Subject: Re: [PATCH 09/14] ipv6: hand dst refs to cork setup
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Date:   Tue, 11 Jan 2022 18:11:03 +0100
In-Reply-To: <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
References: <cover.1641863490.git.asml.silence@gmail.com>
         <07031c43d3e5c005fbfc76b60a58e30c66d7c620.1641863490.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-01-11 at 01:21 +0000, Pavel Begunkov wrote:
> During cork->dst setup, ip6_make_skb() gets an additional reference to
> a passed in dst. However, udpv6_sendmsg() doesn't need dst after calling
> ip6_make_skb(), and so we can save two additional atomics by passing
> dst references to ip6_make_skb(). udpv6_sendmsg() is the only caller, so
> it's enough to make sure it doesn't use dst afterwards.

What about the corked path in udp6_sendmsg()? I mean:

udp6_sendmsg(MSG_MORE) -> ip6_append_data() -> ip6_setup_cork() 

what if ip6_setup_cork() errors out in that path?

Thanks!

Paolo

