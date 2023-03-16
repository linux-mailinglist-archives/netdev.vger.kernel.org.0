Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5756D6BD5CD
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 17:34:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjCPQeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 12:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231136AbjCPQeA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 12:34:00 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183A8E63C9;
        Thu, 16 Mar 2023 09:33:18 -0700 (PDT)
Received: from [192.168.2.51] (p5dd0da05.dip0.t-ipconnect.de [93.208.218.5])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id DE3E6C027C;
        Thu, 16 Mar 2023 17:33:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1678984396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UrWrpPv+/3slKvIAuehiHkc06CKCMU5Vv1SKl92JOdI=;
        b=asCQEiNQyYuBa69dpfM8dBU9fdWuoUqoECwB0zPjNUGlO2ZxHUKZgPlvt8hwPiKRrWIbQL
        nUsH9QYNeWgNlYye7uDnhZRY3xKLI1Zzdtas23f0DLf/NSiTHgOmYnBmmyitCQ2tSX+st/
        Hp4yl61tabPffzYMtTPc885E1Zp+aD7kgzvGZ3cfYb1dGIMlrju4hbvwBvg64IEn78JuXX
        2knUuGTc0JV3nitxs93VfJ/7RjKah2a38Z8o3QN0+49LK7EZgu0m9zg+s4Xzc+ZFQYcK/W
        WVLgD43pndNZ+dtuPYah1HLgPdZX+EPOEbMZNQ41kGPDytTLu8KB0QUZmPuOzg==
Message-ID: <93bc1f0a-d1ed-e0cf-30ec-a3b59a1ec678@datenfreihafen.org>
Date:   Thu, 16 Mar 2023 17:33:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH next] ca8210: Fix unsigned mac_len comparison with zero in
 ca8210_skb_tx()
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     Dan Carpenter <error27@gmail.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Harry Morris <harrymorris12@gmail.com>,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230306191824.4115839-1-harshit.m.mogalapalli@oracle.com>
 <ZAb5BlS+OgFfJM6t@corigine.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <ZAb5BlS+OgFfJM6t@corigine.com>
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

Hello Simon.

On 07.03.23 09:42, Simon Horman wrote:
> On Mon, Mar 06, 2023 at 11:18:24AM -0800, Harshit Mogalapalli wrote:
>> mac_len is of type unsigned, which can never be less than zero.
>>
>> 	mac_len = ieee802154_hdr_peek_addrs(skb, &header);
>> 	if (mac_len < 0)
>> 		return mac_len;
>>
>> Change this to type int as ieee802154_hdr_peek_addrs() can return negative
>> integers, this is found by static analysis with smatch.
>>
>> Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
>> Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
> 
> I discussed this briefly with Harshit offline.
> 
> The commit referenced above tag does add the call to
> ieee802154_hdr_peek_addrs(), an there is a sign miss match between
> the return value and the variable.
> 
> The code to check the mac_len was added more recently, by the following
> commit. However the fixes tag is probably fine as-is, because it's fixing
> error handling of a call made in that commit.
> 
> 6c993779ea1d ("ca8210: fix mac_len negative array access")
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

I agree that the commit above is the better Fixes tag as it makes clear 
it only comes after this change. I amended the commit message 
accordingly when applying this to wpan.

regards
Stefan Schmidt
