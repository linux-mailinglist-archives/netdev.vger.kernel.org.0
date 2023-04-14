Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E2A6E254E
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 16:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbjDNOJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 10:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbjDNOJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 10:09:20 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8A9B759
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 07:08:44 -0700 (PDT)
Received: from [192.168.1.137] (unknown [213.194.153.37])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: rcn)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 6AAB8660321F;
        Fri, 14 Apr 2023 15:08:28 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1681481309;
        bh=I+aHzA+Q4ne4xfBmJkGe2Y0X33bIvFmF69y9bnWuVcQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Fi2ZjYIAcu7jqxL95ctMMCV4n/D+ocJfsLyTMmwc/3arbxRYiga0wltghFMnIjanD
         6zh2URKn/GWRn5DdqXtXGg9RkQX3hC3l2HUFOg4pstgQCjmwkyswc8E/zdyjdTUkWP
         QY74JSdTyMG2ihTL02ADdN5+R2A9FQ1DJy9Y8F5dYqNnwk5QGXADF2xQmZ1ierLhW3
         oUPhnSIvT3kDYJFis5yeBa/rIaJaZLsm/IZut1esgQHaLBeEVqQrH02TB8Tj9XSUyq
         dxTTbptKkKtd6nSuXQ+u7BUKyHv+byhvzxdbF7vpzdqgaXbi38lHr0gmKWGWly6SRH
         cTKaxd/HzRlTQ==
Message-ID: <569c0f2f-ff7b-9367-e33e-ddf37a13232b@collabora.com>
Date:   Fri, 14 Apr 2023 16:08:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net] bgmac: fix *initial* chip reset to support BCM5358
Content-Language: en-US
To:     Linux regressions mailing list <regressions@lists.linux.dev>,
        Florian Fainelli <f.fainelli@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Jon Mason <jdmason@kudzu.us>
References: <20230227091156.19509-1-zajec5@gmail.com>
 <20230404134613.wtikjp6v63isofoc@rcn-XPS-13-9305>
 <002c1f96-b82f-6be7-2530-68c5ae1d962d@milecki.pl>
 <b7b11a57-9512-cda9-1b15-5dd5aa12f162@gmail.com>
 <d6990d00-6fd5-cd89-755d-d7f566c574fa@leemhuis.info>
From:   =?UTF-8?Q?Ricardo_Ca=c3=b1uelo?= <ricardo.canuelo@collabora.com>
In-Reply-To: <d6990d00-6fd5-cd89-755d-d7f566c574fa@leemhuis.info>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thorsten,

On 14/4/23 16:04, Linux regression tracking (Thorsten Leemhuis) wrote:
> What happened to this? It seems there wasn't any progress since above
> mail week. But well, seems to be a odd issue anyway (is that one of
> those issues that CI systems find, but don't cause practical issues in
> the field?). Hence: can somebody with more knowledge about this please
> tell if it this is something I can likely drop from the list of tacked
> regressions?

 From Rafał's answer, I think we can consider this a false positive and move on.

Cheers,
Ricardo
