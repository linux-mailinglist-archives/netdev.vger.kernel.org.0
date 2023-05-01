Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCF1B6F3031
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbjEAK2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbjEAK22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:28:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB71A136
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 03:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682936860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GRtuEtk1Agus0i9a6G5WkwqsQ87YPTcPf/QGDRjhWqA=;
        b=H5EZSN2ko9LRDsD7BdDWQztbHQeXTj4PNMhw5IwRCWZXE403Oj0fHVNOvkz1UmNT8D3zBN
        szCVwN/+I0l8fcTfWq+N/ffoiRX8VopkKavya4bJKnp3PyxxKW4CjeBehRd6hretTAX+0y
        hQC+zJQD5DRRkX1zEeNxhtC8ZO6cfa4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-167-mTKrlS-wNRu8MIfodOdiPw-1; Mon, 01 May 2023 06:27:39 -0400
X-MC-Unique: mTKrlS-wNRu8MIfodOdiPw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f32b3835e9so6996885e9.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 03:27:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682936858; x=1685528858;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GRtuEtk1Agus0i9a6G5WkwqsQ87YPTcPf/QGDRjhWqA=;
        b=Zh+GTACgombri38dx2gx0I6uJdMB4y8yY2W8HX7fmNCejiDmLA5tWNKM8w9HTX8ZuX
         /Q0/XgidxmDrVCduDfpCoFFCkMKXODeQci7inZXQl8KNyYnTUPfKHLfROVcQXQ7iCEXr
         XrQ4uRGJK/49PdITzROCNl8nVvIB/+UAoifemPEL4ftSMYrM/P07dye9Z8W1pjkvTqnu
         4Y8Kv2kn9YX6LkaG2vTDAqFcY/E76VieVxeFI3dE053VSubxPUaDBF18rKubpIebliEM
         1NBQ+KYfo2YRq3TtPDNRspgE6Ov20ersVCHE/TlMDyV1R2MGTUaNEZL7d5HyW3gqkHSV
         fX2Q==
X-Gm-Message-State: AC+VfDxQJTbWYM6OvSuAiZ9tXt1R7QF2x+HblqkjqAUauB/rnmaRdqY3
        kZ50LTTBKkxkBaIPnCW0a1NtPku+lLK1zLGWTPNjI2eCVgI0+z5Njv699M4v9z5kn3lz0U4He0w
        CKq7+xTkl4kq69Bfr
X-Received: by 2002:a05:600c:24cd:b0:3f1:92e8:a6fe with SMTP id 13-20020a05600c24cd00b003f192e8a6femr9959576wmu.31.1682936858083;
        Mon, 01 May 2023 03:27:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UGe6rKgDK9J0Fv3OD1362dMlDO30XbwBLq2L7tXBmbUGS4RqXkA11U0RdxloRzim2DjKI3Q==
X-Received: by 2002:a05:600c:24cd:b0:3f1:92e8:a6fe with SMTP id 13-20020a05600c24cd00b003f192e8a6femr9959562wmu.31.1682936857810;
        Mon, 01 May 2023 03:27:37 -0700 (PDT)
Received: from redhat.com ([2a06:c701:742c:c300:3695:a81b:6f0b:8940])
        by smtp.gmail.com with ESMTPSA id f15-20020a7bcd0f000000b003f182cc55c4sm32005051wmj.12.2023.05.01.03.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 03:27:37 -0700 (PDT)
Date:   Mon, 1 May 2023 06:27:34 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Alvaro Karsz <alvaro.karsz@solid-run.com>
Cc:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xuanzhuo@linux.alibaba.com" <xuanzhuo@linux.alibaba.com>
Subject: Re: [RFC PATCH net 0/3] virtio-net: allow usage of small vrings
Message-ID: <20230501062107-mutt-send-email-mst@kernel.org>
References: <20230430131518.2708471-1-alvaro.karsz@solid-run.com>
 <20230430100535-mutt-send-email-mst@kernel.org>
 <AM0PR04MB4723C479C388266434DE415ED4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4723C479C388266434DE415ED4699@AM0PR04MB4723.eurprd04.prod.outlook.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 30, 2023 at 06:15:03PM +0000, Alvaro Karsz wrote:
> 
> > > This patchset follows a discussion in the mailing list [1].
> > >
> > > This fixes only part of the bug, rings with less than 4 entries won't
> > > work.
> > 
> > Why the difference?
> > 
> 
> Because the RING_SIZE < 4 case requires much more adjustments.
> 
> * We may need to squeeze the virtio header into the headroom.
> * We may need to squeeze the GSO header into the headroom, or block the features.

We alread do this though no?
I think we'll need to tweak hard_header_len to guarantee it's there
as opposed to needed_headroom ...

> * At the moment, without NETIF_F_SG, we can receive a skb with 2 segments, we may need to reduce it to 1.

You are saying clearing NETIF_F_SG does not guarantee a linear skb?

> * We may need to change all the control commands, so class,  command and command specific data will fit in a single segment.
> * We may need to disable the control command and all the features depending on it.

well if we don't commands just fail as we can't add them right?
no corruption or stalls ...

> * We may need to disable NAPI?

hmm why napi?

> There may be more changes..
> 
> I was thinking that it may be easier to start with the easier case RING_SIZE >= 4, make sure everything is working fine, then send a follow up patchset with the required adjustments for RING_SIZE < 4.


it's ok but I'm just trying to figure out where does 4 come from.

