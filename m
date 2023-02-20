Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF63D69D3FE
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 20:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbjBTTPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 14:15:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbjBTTPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 14:15:30 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6714B2102;
        Mon, 20 Feb 2023 11:15:06 -0800 (PST)
Received: from [IPV6:2003:e9:d746:344d:8e4a:ccf0:3715:218] (p200300e9d746344d8e4accf037150218.dip0.t-ipconnect.de [IPv6:2003:e9:d746:344d:8e4a:ccf0:3715:218])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4199FC0747;
        Mon, 20 Feb 2023 20:15:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1676920503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s8Up4kczUGpw9sRhienLgrgDLl+Nf5jSMMfVDCTpzlw=;
        b=RvDglz3cZg4WtplWUrQ0JyxWxcWQXLzeHWfU22qKNmKkhq+4dltdgqQGc6GM0t/87913Gj
        Vx+wzahgjcsCYDX4vgDeXnzs9B0nC3A/4cfxxk36n0Q0tNM7BSuYN9mnyo4i/Hu8NDcYaN
        3zvqmITANCXvnEuNDjA1s3tK4sqCpJPayC/WxdKBBgd0sDSXQgDtIswQYhA7JCkFIEVBTE
        wGv7BW7RJR9A3hm1MUcsRddO7Yd9kbv298hNE7h6JLYTU6Gc02dEwdp6qEAyXRGYKSzsGj
        wNyq4/TarzlPLwdVftk6flqhfRSP0aeF6SWspUeGhhN8EAVQkI8k26XawAx63A==
Message-ID: <e88250e5-5943-3fe1-0183-0412f7965fd2@datenfreihafen.org>
Date:   Mon, 20 Feb 2023 20:15:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH wpan v2 0/6] ieee802154: Scan/Beacon fixes
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Alexander Aring <alex.aring@gmail.com>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
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
 <736c9250-ecfc-f9ce-7367-bd79e930f5c3@datenfreihafen.org>
 <20230220095908.7b6946d5@kernel.org>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <20230220095908.7b6946d5@kernel.org>
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

Hello Jakub.

On 20.02.23 18:59, Jakub Kicinski wrote:
> On Sat, 18 Feb 2023 18:20:22 +0100 Stefan Schmidt wrote:
>> I just reviewed and tested them and have no problem to take them in. For
>> patches 1 and 2 I would prefer an ack from Jakub to make sure we covered
>> all of this review feedback before.
> 
> Sorry I was away, yes, patches 1 and 2 LGTM!

Thanks. Patches are applied now and will come in an updated pull request 
later today or tomorrow.

regards
Stefan Schmidt
