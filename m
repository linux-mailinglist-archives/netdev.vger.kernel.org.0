Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDF06DE9D5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDLDRu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDLDRs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:17:48 -0400
Received: from www381.your-server.de (www381.your-server.de [78.46.137.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3523E10F1
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=metafoo.de;
        s=default2002; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID;
        bh=C8PLgfsE/17J/3CTPs5jjY1mz9p//d45Q/Q7uj/5EnY=; b=Scni/EesXCmiFeFORgYN2gMnC5
        K+8fGQ7kK11ylx3ryozCUY4jWx/rjCa3F2z/zKqvrj17RgJsCq2tP3Ut353u8Keu92GNeNx4dAnj/
        c5wJUPReH5niMgtTyUyIscbBQGkUqmbBeUAe5tle0h1XchHbTvPjWwOvENHzgryu5XGRQEKR2oHWt
        eXSKrETD8uSQPWlO5qv167wvSZ4261U2IlBsqanBhm9DSlsNdu4F+KtvMZlPi1nAqIp/4RKC1/Oyv
        3uDPQRiOjXD6+mUWQKFfjaComsAw+AESZTzkrDoVHPRQQMPnK2mv0MRAZykY+D56fs/CBQOydqeNo
        uq9y6xdg==;
Received: from sslproxy06.your-server.de ([78.46.172.3])
        by www381.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <lars@metafoo.de>)
        id 1pmQzP-000321-Um; Wed, 12 Apr 2023 05:17:43 +0200
Received: from [2604:5500:c0e5:eb00:da5e:d3ff:feff:933b]
        by sslproxy06.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <lars@metafoo.de>)
        id 1pmQzP-000B7E-Fl; Wed, 12 Apr 2023 05:17:43 +0200
Message-ID: <54c433e0-1707-7427-b43a-3d2840375a07@metafoo.de>
Date:   Tue, 11 Apr 2023 20:17:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/1] Alternative, restart tx after tx used bit read
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Ingo Rohloff <ingo.rohloff@lauterbach.com>,
        Roman Gushchin <roman.gushchin@linux.dev>
Cc:     robert.hancock@calian.com, Nicolas.Ferre@microchip.com,
        claudiu.beznea@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, tomas.melin@vaisala.com
References: <244d34f9e9fd2b948d822e1dffd9dc2b0c8b336c.camel@calian.com>
 <20230407213349.8013-1-ingo.rohloff@lauterbach.com>
 <20230411190715.6eefb4fa@kernel.org>
From:   Lars-Peter Clausen <lars@metafoo.de>
In-Reply-To: <20230411190715.6eefb4fa@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: lars@metafoo.de
X-Virus-Scanned: Clear (ClamAV 0.103.8/26872/Tue Apr 11 09:26:30 2023)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 19:07, Jakub Kicinski wrote:
> On Fri,  7 Apr 2023 23:33:48 +0200 Ingo Rohloff wrote:
>> Analysis:
>> Commit 404cd086f29e867f ("net: macb: Allocate valid memory for TX and RX BD
>> prefetch") mentions:
>>
>>      GEM version in ZynqMP and most versions greater than r1p07 supports
>>      TX and RX BD prefetch. The number of BDs that can be prefetched is a
>>      HW configurable parameter. For ZynqMP, this parameter is 4.
>>
>> I think what happens is this:
>> Example Scenario (SW == linux kernel, HW == cadence ethernet IP).
>> 1) SW has written TX descriptors 0..7
>> 2) HW is currently transmitting TX descriptor 6.
>>     HW has already prefetched TX descriptors 6,7,8,9.
>> 3) SW writes TX descriptor 8 (clearing TX_USED)
>> 4) SW writes the TSTART bit.
>>     HW ignores this, because it is still transmitting.
>> 5) HW transmits TX descriptor 7.
>> 6) HW reaches descriptor 8; because this descriptor
>>     has already been prefetched, HW sees a non-active
>>     descriptor (TX_USED set) and stops transmitting.
> This sounds broken, any idea if this is how the IP is supposed to work
> or it may be an integration issue in Zynq?  The other side of this
> question is how expensive the workaround is - a spin lock and two extra
> register reads on completion seems like a lot.
>
> Roman, Lars, have you seen Tx stalls on your macb setups?

We haven't seen that one yet. We are also using ZynqMP and have done 
iperf3 stress testing in the past, but maybe just got lucky.

