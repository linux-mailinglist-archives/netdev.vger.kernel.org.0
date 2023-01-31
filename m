Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B4668262D
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230172AbjAaIMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbjAaIML (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:12:11 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0961CF6D;
        Tue, 31 Jan 2023 00:12:08 -0800 (PST)
Received: from [IPV6:2003:e9:d70f:e321:93b5:b690:4c5a:7ba9] (p200300e9d70fe32193b5b6904c5a7ba9.dip0.t-ipconnect.de [IPv6:2003:e9:d70f:e321:93b5:b690:4c5a:7ba9])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id F3A21C05C5;
        Tue, 31 Jan 2023 09:12:05 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1675152726;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N6fHKbNyAuu3NT3+J3rUEqgwxmsgoIpDY8F/JL0e918=;
        b=Ne4kMvDNm246q90EqWvHMrlDTpJpNLlPVOhyby/PEA1SRThikekRmSfBCDqz4HnQmXWmPQ
        CU3a0mZXWRqwvPTtHzsEnzpRJxKCKVwRJTSz+mSl71qexM1wSUJ8OE/teU+/Wss7vYXOqh
        9deieRRNX4azbtlHJIm51Ze00GUUPFYIoRrRepizyUXu6hvCp9KPN5jaFPvZhBDLNV9Lfy
        QWYiOYXiHrdYJ5KKC+fi3bGzkGaemYLHOQqEsuCqnebd237FXqAlzxZYuoSmMQxjf5KXqd
        Lr0YtehEKeUaRfeiwA6Q9V03lV4TdcjhB+9b20T51MJe2otw632FzAhNIN6dXQ==
Message-ID: <d25400ef-6706-3dff-7f40-23ae561ff7f3@datenfreihafen.org>
Date:   Tue, 31 Jan 2023 09:12:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] cc2520: move to gpio descriptors
Content-Language: en-US
To:     Arnd Bergmann <arnd@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>
Cc:     linux-gpio@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
References: <20230126161658.2983292-1-arnd@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230126161658.2983292-1-arnd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 26.01.23 17:15, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> cc2520 supports both probing from static platform_data and
> from devicetree, but there have never been any definitions
> of the platform data in the mainline kernel, so it's safe
> to assume that only the DT path is used.
> 
> After folding cc2520_platform_data into the driver itself,
> the GPIO handling can be simplified by moving to the modern
> gpiod interface.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   MAINTAINERS                     |   1 -
>   drivers/net/ieee802154/cc2520.c | 136 +++++++++-----------------------
>   include/linux/spi/cc2520.h      |  21 -----
>   3 files changed, 37 insertions(+), 121 deletions(-)
>   delete mode 100644 include/linux/spi/cc2520.h

This patch has been applied to the wpan-next tree and will be
part of the next pull request to net-next. Thanks!

regards
Stefan Schmidt
