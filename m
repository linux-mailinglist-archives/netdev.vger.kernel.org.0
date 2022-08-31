Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1218D5A87D2
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 22:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiHaU7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 16:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232283AbiHaU7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 16:59:20 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4543F2C86;
        Wed, 31 Aug 2022 13:59:16 -0700 (PDT)
Received: from [IPV6:2003:e9:d720:85aa:808b:c60d:ed1c:7084] (p200300e9d72085aa808bc60ded1c7084.dip0.t-ipconnect.de [IPv6:2003:e9:d720:85aa:808b:c60d:ed1c:7084])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 80D12C0253;
        Wed, 31 Aug 2022 22:59:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1661979554;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gBHjfiQIski5MtF0vRHo2Im/EFazYp9Zs587xZvZOZA=;
        b=YHz2UTZ1QIjcNjWGlMeO0dst0Yx8sn95R35bGqqCZHcmyDizMPk2u9506w1sry4RDqPqwF
        VBnPIUsVnItmw7og1TLjCnU5NmkFDk40iVzAGya+T02iOPLdU4EhoqoL32t867NEjKA686
        Fyvvk6S0atl2I3SIF6ji9lr8EWmwC07y5p/dwhQYxi5agthtolM2Q5v6hfcBdac4EAeJ4a
        iRVsND7SpNk4HFTiFSXGRi091vCpd7v1xgskECiJ9EvOxgD/RH+c4zaw7SfiebEc/O3Hqx
        VRS6pCg4IpjDBW7zJvb+pxC09sY/5MygKuIkjQzkOoqzhUb9K2ONdCy544vHYA==
Message-ID: <36f09967-b211-ef48-7360-b6dedfda73e3@datenfreihafen.org>
Date:   Wed, 31 Aug 2022 22:59:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: ieee802154: Fix compilation error when
 CONFIG_IEEE802154_NL802154_EXPERIMENTAL is disabled
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-wpan@vger.kernel.org, Alexander Aring <alex.aring@gmail.com>
References: <20220830101237.22782-1-gal@nvidia.com>
 <20220830231330.1c618258@kernel.org>
 <4187e35d-0965-cf65-bff5-e4f71a04d272@nvidia.com>
 <20220830233124.2770ffc2@kernel.org> <20220831112150.36e503bd@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20220831112150.36e503bd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub.

On 31.08.22 20:21, Jakub Kicinski wrote:
> On Tue, 30 Aug 2022 23:31:24 -0700 Jakub Kicinski wrote:
>> Hm, let me add 802154 folks.
>>
>> Either we should treat the commands as reserved in terms of uAPI
>> even if they get removed the IDs won't be reused, or they are for
>> testing purposes only.
>>
>> In the former case we should just remove the #ifdef around the values
>> in the enum, it just leads to #ifdef proliferation while having no
>> functional impact.
>>
>> In the latter case we should start error checking from the last
>> non-experimental command, as we don't care about breaking the
>> experimental ones.
> 
> I haven't gone thru all of my inbox yet, but I see no reply from Stefan
> or Alexander. My vote is to un-hide the EXPERIMENTAL commands.

I was swamped today and I am only now finding time to go through mail.

Given the problem these ifdef are raising I am ok with having these 
commands exposed without them.

Our main reason for having this feature marked as experimental is that 
it does not have much exposure and we fear that some of it needs rewrites.

If that really is going to happen we will simply treat the current 
commands as reserved/burned and come up with other ones if needed. While 
I hope this will not be needed it is a fair plan for mitigating this.

regards
Stefan Schmidt
