Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFC4F795D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242831AbiDGIUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242795AbiDGIUe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:20:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6D70121E50A
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649319513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jW/rk7FENs40EnB0uCA1bBOqTjnDJxLTwFnAX1mGka8=;
        b=hw+2QpvcYeynyKijXuBGS4oZeUjC2PVRxAdT1LuEe17Tvbmwg2gST0YST5qWyo8KN6jB9A
        YlP1d68XPbEnYM5Sz4Y8XKoMewjyGFsdAPkIUeMKkQByr1DeyHy5iS2kvKv/8YmboRzzME
        1tA6bEiuKGulKRkJ8vIstfkxRWmtuZg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-672-q94zE0FmPCCpqVHu74zVig-1; Thu, 07 Apr 2022 04:18:32 -0400
X-MC-Unique: q94zE0FmPCCpqVHu74zVig-1
Received: by mail-wr1-f71.google.com with SMTP id u30-20020adfa19e000000b00206153b3cceso1025597wru.1
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 01:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=jW/rk7FENs40EnB0uCA1bBOqTjnDJxLTwFnAX1mGka8=;
        b=mu98O/lk4hhrV5eKMSWlRACL3eq4fRQa+FKd+2GKRdgPIjbOzIDvhRQhy0ZmbKclGC
         6xEoZeKb5/S0/wOpLiJx5TSPGkBGAV3ZffbGQfkq4wGEX/UtgwqDtgJxRACeTjxdE6me
         rOO1OVw7wA2XyR2yjSMp0Z1O4fMlR8dEXdZZxWJDEZ+iyO4kpBENU/bdcnHexvu1bRk0
         SodN/nbYJuS50fEHXW3o/No/BV9BTbpfoPbQqbQIfLgRhOdOEFBy+1SXQixFTbxd/pTI
         Mzm+2ep0IOHmKN70IKbEfux68OoRUZkMQkG5NEURlpR0gOqqkIDkc+5M+ir1eM8sgzgb
         pqIQ==
X-Gm-Message-State: AOAM5319pHXnfIZpk3cP48ZzSx6Wh3lxkNgCwq1g80eZHMkqAoIpFaJ6
        d1t2Ug9RzYud0Mbdu1i5aO4eXTCGtrl3PQAauWpN/APtv98j7iWg7VTreZOAPpuhIVsNX1Klapb
        oUhM6bX1/I0q/baKT
X-Received: by 2002:a5d:6812:0:b0:203:f854:c380 with SMTP id w18-20020a5d6812000000b00203f854c380mr9677202wru.235.1649319511259;
        Thu, 07 Apr 2022 01:18:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxClxX14TbXWBIOJlDwZ06lVilSCrfAbdShQ6nkODxUZiE+GQP/JhL48g6k/Zr7Z+5NJx1VgQ==
X-Received: by 2002:a5d:6812:0:b0:203:f854:c380 with SMTP id w18-20020a5d6812000000b00203f854c380mr9677191wru.235.1649319511074;
        Thu, 07 Apr 2022 01:18:31 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-96-237.dyn.eolo.it. [146.241.96.237])
        by smtp.gmail.com with ESMTPSA id y6-20020a05600015c600b00203fa70b4ebsm20316538wry.53.2022.04.07.01.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 01:18:30 -0700 (PDT)
Message-ID: <62711467c3990d38ed8a11bf1c7c2594e8e1b436.camel@redhat.com>
Subject: Re: [PATCH 0/2] dt-bindings: net: Fix ave descriptions
From:   Paolo Abeni <pabeni@redhat.com>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
Date:   Thu, 07 Apr 2022 10:18:29 +0200
In-Reply-To: <1649145181-30001-1-git-send-email-hayashi.kunihiko@socionext.com>
References: <1649145181-30001-1-git-send-email-hayashi.kunihiko@socionext.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, 2022-04-05 at 16:52 +0900, Kunihiko Hayashi wrote:
> This series fixes dt-schema descriptions for ave4 controller.
> 
> Kunihiko Hayashi (2):
>   dt-bindings: net: ave: Clean up clocks, resets, and their names using
>     compatible string
>   dt-bindings: net: ave: Use unevaluatedProperties
> 
>  .../bindings/net/socionext,uniphier-ave4.yaml | 57 +++++++++++++------
>  1 file changed, 39 insertions(+), 18 deletions(-)

@Rob: since you acked this series, I guess you prefer/except this will
go via net net-next tree, is that correct?

Thanks!

Paolo

