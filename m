Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376D660F25A
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 10:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbiJ0Iby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 04:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiJ0Ibw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 04:31:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D4787FB7
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666859509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DJbylP/VQb6N45h3BR6IuxE22Y8+ba+rHJz3XPrzP5o=;
        b=KoJDaAxWgKJb8i3j4Fv0cHpJ00LEOwtINTUkObOcK/Vh+pH/gYMS4QZVVUSCtNaQpxPiTO
        OcR0TFkREk0Yn/gkAwBzrNkA/Y5djbUa16qSgWP+DURe0KMyCHrFyEP7j0xywt+yjz8srU
        cM6ijgT4aIHQugM0u2Uf4fnq6BLGtnA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-TOuI4siOOpGcbbpQ_j2u4g-1; Thu, 27 Oct 2022 04:31:42 -0400
X-MC-Unique: TOuI4siOOpGcbbpQ_j2u4g-1
Received: by mail-wr1-f72.google.com with SMTP id p7-20020adfba87000000b0022cc6f805b1so148226wrg.21
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 01:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DJbylP/VQb6N45h3BR6IuxE22Y8+ba+rHJz3XPrzP5o=;
        b=r9ehhJD63+fFvbHgpmDZoEBrW9GWVonG3UFzZmJLEKUc4F+fREEyivslapQWb2nHc/
         jPtLa0vQebH222XgFKGneo5G0JqCEeUTSlxuHiOJLESaI69RzkzDkFJUTrzB+G4yaJQn
         5PdFd+lNW2pdeFMc/fL0TgfODnx7kHtWCt5Sb3Kb5TLAMg9Y/sCOGMzdKF9bzVyQlE4G
         8RJTPV19oHp9dPC5hKt3cjx6TDPH1mdzpMoBItJF0fGDr8jPW8GtMvrgb1ZgLujtYkNU
         mPrWlyqGVHO4d/DLbTVGPjn9VZWhk/31QoGvlazS9SpNqI7BKIRTmphnpMMm+lFTvzKL
         PpHg==
X-Gm-Message-State: ACrzQf1mXKqBsVXNwi/rs5S6BQLNp3sF6tn5hqKEV6SND9XK8F8zGPZ3
        bC3IWb6A1XLY07x4YWANxDbZhTnDgioOh8Vv225N0yjIafenKiKpRdp8XvqjJxNyU5AJ3/TzRax
        oIxBx6LxCKwFYaXax
X-Received: by 2002:a5d:5410:0:b0:236:fe1:bb74 with SMTP id g16-20020a5d5410000000b002360fe1bb74mr24232524wrv.512.1666859501288;
        Thu, 27 Oct 2022 01:31:41 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Ki4rsccj5ZhVQmjjfa7CN/RrsLL/EX2Q9k+TQCiMSikyJW1Xat8nCFGGrIEg+lm4CRTtyUA==
X-Received: by 2002:a5d:5410:0:b0:236:fe1:bb74 with SMTP id g16-20020a5d5410000000b002360fe1bb74mr24232508wrv.512.1666859501033;
        Thu, 27 Oct 2022 01:31:41 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id bs5-20020a056000070500b00236674840e9sm567217wrb.59.2022.10.27.01.31.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 01:31:40 -0700 (PDT)
Message-ID: <976d76cad07696c822acd44fbd534a614b7f85fc.camel@redhat.com>
Subject: Re: [PATCH v5 net-next] net: ftmac100: support mtu > 1500
From:   Paolo Abeni <pabeni@redhat.com>
To:     Sergei Antonov <saproj@gmail.com>, netdev@vger.kernel.org
Cc:     olteanv@gmail.com, andrew@lunn.ch, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
Date:   Thu, 27 Oct 2022 10:31:39 +0200
In-Reply-To: <20221024175823.145894-1-saproj@gmail.com>
References: <20221024175823.145894-1-saproj@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Mon, 2022-10-24 at 20:58 +0300, Sergei Antonov wrote:
> The ftmac100 controller considers packets >1518 (1500 + Ethernet + FCS)
> FTL (frame too long) and drops them. That is fine with mtu 1500 or less
> and it saves CPU time. When DSA is present, mtu is bigger (for VLAN
> tagging) and the controller's built-in behavior is not desired then. We
> can make the controller deliver FTL packets to the driver by setting
> FTMAC100_MACCR_RX_FTL. Then we have to check ftmac100_rxdes_frame_length()
> (packet length sans FCS) on packets marked with FTMAC100_RXDES0_FTL flag.
> 
> Check for mtu > 1500 in .ndo_open() and set FTMAC100_MACCR_RX_FTL to let
> the driver FTL packets. Implement .ndo_change_mtu() and check for
> mtu > 1500 to set/clear FTMAC100_MACCR_RX_FTL dynamically.
> 
> Fixes: 8d77c036b57c ("net: add Faraday FTMAC100 10/100 Ethernet driver")

For the records, Vladimir explicitly asked you to drop the 'Fixes' tag.
Such tag makes little sense for a net-next commit, especially when
referring to an old change - e.g. that did not enter mainline in this
release cycle.

Cheers,

Paolo

