Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 414295A86AB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 21:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiHaTV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 15:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbiHaTVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 15:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B0CDF085
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:21:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661973683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yF8xpIjbJkDyLQ9AyWpEptq6gDkUAvO7MhTPbwPO8UA=;
        b=SgNYFYIKGWZUafw8CcX3icB3DH9GkqMsnszELzYuCnA7CY2DKKugE6u0hTxyb4RUgceaCE
        2rFQq6OfR4OE1cMhiY0KN1O/yw9gRPtlKGNNjemlb4Dj/mI8n0XXcNuDNBfgt6DWUgMWut
        GBewSmnb8tyYQlJGb5Z0uWkFu7+mrLo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-611-ZQSWYEgVOl6RDG2jUTBIeQ-1; Wed, 31 Aug 2022 15:21:21 -0400
X-MC-Unique: ZQSWYEgVOl6RDG2jUTBIeQ-1
Received: by mail-qk1-f199.google.com with SMTP id bs43-20020a05620a472b00b006bb56276c94so12543254qkb.10
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 12:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=yF8xpIjbJkDyLQ9AyWpEptq6gDkUAvO7MhTPbwPO8UA=;
        b=4tJXNNa/89Vv62brhEYsqdUuqyUx5bUD7I9wyNsadGWDQP0F3B2UZl0lSStp2AHgc/
         NZnvoegwuvSDSWzSfE6phY7uTOVLiR3STQSvC5D9y2PxWnaoiXfXFvPSqVZ65HcALjiy
         W5Fh71swxPYLJoO3AXUNWPyaaigiQJK6t2rjJT6l+A4smCkSceiQ/WYnksl5rPia07aG
         fvER4fsGkLjdK2wV3dUp9//aNuVOL/6h9geUvKX8dnFbwweqsQ76PlKn3xLfFcsXhv7v
         b/MXvSd+D3oCG2K1nWx4OMX7bveo3jcL8r1SCQDTiYkK8uXYA8jU3LiM6KVtlyvK08aN
         Zu2g==
X-Gm-Message-State: ACgBeo2XtrkWlexJ3LL3QDi3eqrjCm+33MzaWts1cUkzU+6FfTQvvVc5
        EHIZNEKd1kvhVvIp46Estmw7W6L7UjvHL97h6vYeLAq1HqyKEkXTNB+52+uhZlA/HBZjUAjkJcz
        oOzqJP+RfK+MQ8ILkDHW6ui/ksLmdxsEl
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id q13-20020a05622a04cd00b0034365a4e212mr20107331qtx.526.1661973681280;
        Wed, 31 Aug 2022 12:21:21 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7xIQZCuzjEBO83EeqZPPeoUkm4TcOBb1dvuDkO/uFIWmg1CB7aBIW8LGO6MCvW95DUtT5IJQNTv1bIfu0qSqM=
X-Received: by 2002:a05:622a:4cd:b0:343:65a4:e212 with SMTP id
 q13-20020a05622a04cd00b0034365a4e212mr20107318qtx.526.1661973681112; Wed, 31
 Aug 2022 12:21:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220830101237.22782-1-gal@nvidia.com> <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com> <20220830233124.2770ffc2@kernel.org>
 <20220831112150.36e503bd@kernel.org>
In-Reply-To: <20220831112150.36e503bd@kernel.org>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Wed, 31 Aug 2022 15:21:10 -0400
Message-ID: <CAK-6q+jy5f7PSAh1pZe3M6LM-ySLfUpBAjqS48mBKEVKgXPCUw@mail.gmail.com>
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Gal Pressman <gal@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        Alexander Aring <alex.aring@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Aug 31, 2022 at 2:26 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 30 Aug 2022 23:31:24 -0700 Jakub Kicinski wrote:
> > Hm, let me add 802154 folks.
> >
> > Either we should treat the commands as reserved in terms of uAPI
> > even if they get removed the IDs won't be reused, or they are for
> > testing purposes only.
> >
> > In the former case we should just remove the #ifdef around the values
> > in the enum, it just leads to #ifdef proliferation while having no
> > functional impact.
> >
> > In the latter case we should start error checking from the last
> > non-experimental command, as we don't care about breaking the
> > experimental ones.
>
> I haven't gone thru all of my inbox yet, but I see no reply from Stefan
> or Alexander. My vote is to un-hide the EXPERIMENTAL commands.
>

fine for me if it's still in nl802154 and ends in error if somebody
tries to use it and it's not compiled. But users should still consider
it's not a stable API yet and we don't care about breaking it for
now...

- Alex

