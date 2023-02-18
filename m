Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EC169BB35
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBRRUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjBRRU3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:20:29 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADFFE15C95;
        Sat, 18 Feb 2023 09:20:28 -0800 (PST)
Received: from [IPV6:2003:e9:d720:e7fa:38ae:b66a:d415:7793] (p200300e9d720e7fa38aeb66ad4157793.dip0.t-ipconnect.de [IPv6:2003:e9:d720:e7fa:38ae:b66a:d415:7793])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 6D5B4C01A9;
        Sat, 18 Feb 2023 18:20:24 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1676740824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sveXIeQr7Qq7VZuY4CA8UeCBPYAXxkE3n7+vx7weAeQ=;
        b=AyFlRqE/Uy427q55HkhwbswbDznbZg0otuHvb4bzVyBRrGwkOxjzhEYfmjQuMbcnXMo1GX
        08bTzPui/uQgX8q8TVFEIRnrQ0MRz2/ecf8Qr142ZHvksY6CH/sejhabO/1XEpVerJYXOW
        vd8L6SCd+4bCyE4ypRs/KksBJO7PBLAbZF7eVSFXtn2IZWoK+TLtza5XZbflae2fGc1QiE
        hX2pXCmizPYKFMvtdAeC3JdNgdxa7j5vhe67GtfgArZCxUdR6+1Iww05xyCugjPF07c7cp
        5DdpSHmJ5mL35divTYsd6wAW7p24cA6fiEhV4diBwULCpe6rQRGnOCMj8LIEsg==
Message-ID: <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
Date:   Sat, 18 Feb 2023 18:20:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Content-Language: en-US
To:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
References: <20230214135035.1202471-1-miquel.raynal@bootlin.com>
 <20230217101058.0bb5df34@xps-13>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230217101058.0bb5df34@xps-13>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Miquel.

On 17.02.23 10:10, Miquel Raynal wrote:
> Hello Jakub, Stefan, Alexander,
> 
> miquel.raynal@bootlin.com wrote on Tue, 14 Feb 2023 14:50:29 +0100:
> 
>> Hello,
>>
>> Following Jakub's review on Stefan's MR, a number of changes were
>> requested for him in order to pull the patches in net. In the mean time,
>> a couple of discussions happened with Alexander (return codes for
>> monitor scans and transmit helper used for beacons).
>>
>> Hopefully this series addresses everything.
> 
> I know it's only been 3 working days since I sent this series but as we
> are approaching the closing of net-next and Stefan's MR was paused
> until these fixes arrived, I wanted to check whether these changes
> might be satisfying enough, in particular Jakub, if you found the
> answers you asked for.
> 
> I mainly want to avoid the "Stefan waits for Alexander who waits for
> Jakub who waits for Stefan" dependency chain :)

I just reviewed and tested them and have no problem to take them in. For 
patches 1 and 2 I would prefer an ack from Jakub to make sure we covered 
all of this review feedback before. Let's hope we can get these on 
Monday or Tuesday. Once we have them in I will re-spin a new pull 
request for all the changes.

regards
Stefan Schmidt
