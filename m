Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D23B6A83C2
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 14:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjCBNrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 08:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjCBNrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 08:47:12 -0500
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D5B046162;
        Thu,  2 Mar 2023 05:47:09 -0800 (PST)
Received: from [IPV6:2003:e9:d718:cfbb:38f2:5c92:aa89:2f41] (p200300e9d718cfbb38f25c92aa892f41.dip0.t-ipconnect.de [IPv6:2003:e9:d718:cfbb:38f2:5c92:aa89:2f41])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id 4F72EC088A;
        Thu,  2 Mar 2023 14:47:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1677764827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fuyQAIWt1VuUI5kprpyj9yc6kf6JtidZSAzTugUTnLM=;
        b=WKCMPAE+bvOj6mY6wxcPp01EBegZAkl9eVfisd0SKm+Hqd1oGTtl7fr2/G/3AQJSxMUE7I
        SB/9aiKa9aj1BtX9zvuFJMTgWRIP/oK8U/jjKfbdxUROjYFvSDtp1F7SDkLeh2MOMT46qH
        vsppMF4QD0sLUwHzXrALeXORPmJVjGqF8jbeaJ/p33GDjKPM1ynWk8wL6J+6SPyZhuVVvm
        Uv/njgCVXyDirRs5V1qAji9HX7Wg9AL/CBf6BwiePFESeKqX4l0e5A7964Tt1/pSepuSsI
        cM/Tqz0lU4ipiUBoWtjYKkIqNukE5O/FWtbEu4GeKbsB3KFnzEVdCqRRzt79Og==
Message-ID: <dae4c5c8-38a2-9134-c8bb-604537f94f6d@datenfreihafen.org>
Date:   Thu, 2 Mar 2023 14:47:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net] ieee802154: Prevent user from crashing the host
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Cc:     Alexander Aring <alex.aring@gmail.com>, linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Sanan Hasanov <sanan.hasanov@Knights.ucf.edu>
References: <20230301154450.547716-1-miquel.raynal@bootlin.com>
 <20230302094848.206f35ae@xps-13>
 <ac92a5f3e553e35a50119918ea0f2a833c124333.camel@redhat.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <ac92a5f3e553e35a50119918ea0f2a833c124333.camel@redhat.com>
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

Hello Paolo.

On 02.03.23 11:20, Paolo Abeni wrote:
> Hello,
> 
> On Thu, 2023-03-02 at 09:48 +0100, Miquel Raynal wrote:
>> miquel.raynal@bootlin.com wrote on Wed,  1 Mar 2023 16:44:50 +0100:
>>
>>> Avoid crashing the machine by checking
>>> info->attrs[NL802154_ATTR_SCAN_TYPE] presence before de-referencing it,
>>> which was the primary intend of the blamed patch.
>>
>> Subject should have been wpan instead of net, sorry for the confusion.
> 
> I read the above as you intend this patch to go through
> Alexander/Stefan tree, thus dropping from netdev PW.

That is correct. I just applied it and will send a pull request for net 
later today once it passed all my tests here.

regards
Stefan Schmidt
