Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F025603B20
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 10:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJSIGO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 04:06:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJSIGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 04:06:13 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C6674CEE;
        Wed, 19 Oct 2022 01:06:12 -0700 (PDT)
Received: from [IPV6:2003:e9:d737:8af6:4fc:668d:6ab2:2a74] (p200300e9d7378af604fc668d6ab22a74.dip0.t-ipconnect.de [IPv6:2003:e9:d737:8af6:4fc:668d:6ab2:2a74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id A6E2CC0183;
        Wed, 19 Oct 2022 10:06:09 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1666166770;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wle3jPpmkZ9Q6kR0RR4IH1KKfOOsPa+u9//L4s5BVCk=;
        b=Yyi4l3mIwXmIGnp9OVvISygFVMhT9KAoKXL9rlxjH5vlnaTEJHr0S2r0yY9Qfaok4FpF6w
        CaQNvm3IDgWkfnx3Uwx4T0Be9njcb6Ysidd7ANbuc7OO7bxaivfBcInlW6UaB6gFBpTi15
        U2sYOAO3NU3MJDB9hnrUfsxwO3aGADMuNvhp3dRcj2A1vj7uzdc/CukdlFeA/Rz8w59cPD
        iMGK3SefQu9v4HrHwuj/ZfZGwPMUjTP9F5vqlY6LgIfkyCQA7/ksQqgOeeLs6oShDRbBZA
        UetGeIMBBKhuZiq6mp9vs949NaiEDQQvf63z2hgN3/NWtfd9r2cSA+XenaAScQ==
Message-ID: <154ea7ad-333e-cecd-517b-0a9cf9d1b390@datenfreihafen.org>
Date:   Wed, 19 Oct 2022 10:06:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH wpan-next v5] mac802154: Ensure proper scan-level
 filtering
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20221018183540.806471-1-miquel.raynal@bootlin.com>
 <CAK-6q+gRMG64Ra9ghAUVHXkJoGB1b5Kd6rLTiUK+UArbYhP+BA@mail.gmail.com>
 <20221019000329.2eacd502@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20221019000329.2eacd502@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 19.10.22 00:03, Miquel Raynal wrote:
> Hi Alexander,
> 
> aahringo@redhat.com wrote on Tue, 18 Oct 2022 16:54:13 -0400:
> 
>> Hi,
>>
>> On Tue, Oct 18, 2022 at 2:35 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>>>
>>> We now have a fine grained filtering information so let's ensure proper
>>> filtering in scan mode, which means that only beacons are processed.
>>>   
>>
>> Is this a fixup? Can you resend the whole series please?
> 
> Hmm no? Unless I understood things the wrong way, Stefan applied
> patches 1 to 7 of my v4, and asked me to make a change on the 8th
> patch.
> 
> This is v5 just for patch 8/8 of the previous series, I just changed
> a debug string actually...
> 
> There was a conflict when he applied it but I believe this is because
> wpan-next did not contain one of the fixes which made it to Linus' tree
> a month ago. So in my branch I still have this fix prior to this patch,
> because otherwise there will be a conflict when merging v6.1-rc1 (which
> I believe was not done yet).

You believe correctly. :-) In my workflow I normally do not merge in 
changes from net-next until after my latest pull-request was pulled in. 
I do this to avoid extra merge commits.

In case I see a merge conflict in my testing before sending the pull 
request I add merge guidance to the pull. Which is my plan this time 
around as well.

regards
Stefan Schmidt


