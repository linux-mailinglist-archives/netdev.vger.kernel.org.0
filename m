Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3ACD5F3ED7
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 10:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJDIwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 04:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiJDIwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 04:52:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1214919033
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 01:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664873561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEuH3SIPmaaGgJpqhFBpdv6WFVgwU4WLYDd6qjhG9EM=;
        b=OutrVWmZbR+oTKZMTn4lPXY1HjyZT77J6hU79Sn8vG7AxGxm6P2uIXET4QthE/h7fSwTpu
        RT/4JdAlnXIYFQ/U8sx6R6tVh7AAIh20ktPgGyscr5qDmqye/yZbXAzrY8z8OLRZSC5z6V
        fvEBMstMT3c3rF+fCFOWjo3sfMlY2/0=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-591-NqpNbF-OOhWLHdlBQdTAyA-1; Tue, 04 Oct 2022 04:52:39 -0400
X-MC-Unique: NqpNbF-OOhWLHdlBQdTAyA-1
Received: by mail-wr1-f70.google.com with SMTP id w11-20020adfbacb000000b0022e4273f1a9so1358485wrg.20
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 01:52:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=aEuH3SIPmaaGgJpqhFBpdv6WFVgwU4WLYDd6qjhG9EM=;
        b=eouejRT2bWhSjLPdbGaAzpqF6YYF4CI5jG9tKnYQlhW/lrLI61L7z0Ho7iP6zb2CdW
         sR6qPbM4OEPIPWre9ZFT7T+UxDEPuXkegAvRtMj5liXDbYasN/GEP88O7lg7NnreJY3A
         Z5kZ2oRClw0dS6T4zyqBrW2qeKL9bIknv8QnUPZAmP8SVDLZyPICt/YJVn9FIDzijDGB
         MWvPVhHtdsF173c93cSsZr0UV+q96aKnYxzLjk5tM6gZQZ3OvVcmwO35mMNB+9J/S/kz
         GjCk8naj0+Lls16DAcd9QRPKZ+rULI0Tv2eX66MgkbP1RYi7DjCkO76bf+FNDyVrm8nF
         zmPA==
X-Gm-Message-State: ACrzQf2NB9Vvp+jGyqlwW7DFk+NaaAx59AhaaoXiqq/+3rHo85T21LM5
        Y16IdxM168kDKktihs5HWwIpzOvZVaHpWmXWn8AuYOEIm89KDERJ8Ce4K52dK3HFz8TzTGByrXG
        M20plVpupW0PCGcJ3
X-Received: by 2002:adf:e112:0:b0:21d:7195:3a8d with SMTP id t18-20020adfe112000000b0021d71953a8dmr16070529wrz.371.1664873558526;
        Tue, 04 Oct 2022 01:52:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5ydQge434vccoSf1EMgdm4qjUZ6q+ksKYC2TC9xtXJvEbSDgvcBXQFjnPccAmiL0w1ROhmIw==
X-Received: by 2002:adf:e112:0:b0:21d:7195:3a8d with SMTP id t18-20020adfe112000000b0021d71953a8dmr16070508wrz.371.1664873558206;
        Tue, 04 Oct 2022 01:52:38 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-71.dyn.eolo.it. [146.241.97.71])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d55cd000000b0022ae59d472esm11595471wrw.112.2022.10.04.01.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 01:52:37 -0700 (PDT)
Message-ID: <207fa5f52b00836df6dd03af470d85926747079b.camel@redhat.com>
Subject: Re: [PATCH v2] net: mv643xx_eth: support MII/GMII/RGMII modes
From:   Paolo Abeni <pabeni@redhat.com>
To:     David Yang <mmyangfl@gmail.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 04 Oct 2022 10:52:36 +0200
In-Reply-To: <20220930203926.958776-1-mmyangfl@gmail.com>
References: <YzdRdC1qgZY+8gQk@lunn.ch>
         <20220930203926.958776-1-mmyangfl@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Sat, 2022-10-01 at 04:39 +0800, David Yang wrote:
> Support mode switch properly, which is not available before.
> 
> If SoC has two Ethernet controllers, by setting both of them into MII
> mode, the first controller enters GMII mode, while the second
> controller is effectively disabled. This requires configuring (and
> maybe enabling) the second controller in the device tree, even though
> it cannot be used.
> 
> Signed-off-by: David Yang <mmyangfl@gmail.com>

It looks like that despite the subj change, this is superseded by:

https://patchwork.kernel.org/project/netdevbpf/patch/20221001174524.2007912-1-mmyangfl@gmail.com/

I'm updating the PW accordingly. Please let me know if you intended
otherwise.

Thanks,

Paolo

