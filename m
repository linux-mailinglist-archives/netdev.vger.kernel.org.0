Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE8926F3046
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 12:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjEAKog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 06:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjEAKof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 06:44:35 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F31312C
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 03:44:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1682937850; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Qoa9L9n16IZoUnol2BD3HKspYRZYO80VkLAs2W2WUgGP7f+UNasvtvhCdb6kKgtYurDy8FWbP13T4R0EMD2KmQD7C58pA8kbulfo1Q049nnm6Vca4uT7g9dzo46mFdrUtzhfhxYvFuVhdV8kDAJzoa5m6Fwx9lHFPITi1fNqEao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1682937850; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3qIfss0YSwkYMR4Z/pRzD9yaJhDgHp1AbhxtY2m8N2E=; 
        b=nHIi6ZmoAjGoQxpldSE8qp3HqM3m1G5QFXa+6nJpxVh2qWqznQxVQjehSun+30bdbryQwFyx/RVGVeubNlsbu1+wYUrhWxkbYfW6wQdD82QXuWBNvNZdX0Sg/UH5ERVbalyN79u6PJ2JcBHVZwxcL/W9y9YMvr3dVZW9Uv69C7o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1682937850;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=3qIfss0YSwkYMR4Z/pRzD9yaJhDgHp1AbhxtY2m8N2E=;
        b=NnTwTy0AZK/IVwAJhMq0yxO+l5PX2nkVV0IDqkln/xbC1FI0N+/jegrXeEse5t3X
        rurACUTiJGygDFQ3Ymdw7k6FvhgLVjblQtR7hPSR3mTt0IKYsCNHWFyo3OnNRrUeHUO
        PVnP59wB3BzzgosL/jGPrtK+yIXILaW+WnuWhzq0=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1682937848841481.03617701277017; Mon, 1 May 2023 03:44:08 -0700 (PDT)
Message-ID: <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
Date:   Mon, 1 May 2023 13:43:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
To:     Daniel Golle <daniel@makrotopia.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     DENG Qingfang <dqfext@gmail.com>, Greg Ungerer <gerg@kernel.org>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        mithat.guner@xeront.com, erkin.bozoglu@xeront.com,
        bartel.eerdekens@constell8.be, netdev <netdev@vger.kernel.org>
References: <8a955c34-5724-af9d-d828-a8786bcc08b0@arinc9.com>
 <20230426205450.kez5m5jr4xch7hql@skbuf>
 <0183eb91-8517-f40f-c2bb-b229e45d6fa5@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <8d6a46a7-a769-4532-dd44-f230b705a675@arinc9.com>
 <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf> <ZE-VEuhiPygZYGPe@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZE-VEuhiPygZYGPe@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1.05.2023 13:31, Daniel Golle wrote:
> On Mon, May 01, 2023 at 01:09:30PM +0300, Vladimir Oltean wrote:
>> On Sat, Apr 29, 2023 at 10:52:12PM +0300, Arınç ÜNAL wrote:
>>> On 29.04.2023 21:56, Vladimir Oltean wrote:
>>>> On Sat, Apr 29, 2023 at 09:39:41PM +0300, Arınç ÜNAL wrote:
>>>>> Are you fine with the preferred port patch now that I mentioned port 6
>>>>> would be preferred for MT7531BE since it's got 2.5G whilst port 5 has
>>>>> got 1G? Would you like to submit it or leave it to me to send the diff
>>>>> above and this?
>>>>
>>>> No, please tell me: what real life difference would it make to a user
>>>> who doesn't care to analyze which CPU port is used?
>>>
>>> They would get 2.5 Gbps download/upload bandwidth in total to the CPU,
>>> instead of 1 Gbps. 3 computers connected to 3 switch ports would each get
>>> 833 Mbps download/upload speed to/from the CPU instead of 333 Mbps.
>>
>> In theory, theory and practice are the same. In practice, they aren't.
>> Are you able to obtain 833 Mbps concurrently over 3 user ports?
> 
> Probably the 2.5 GBit/s won't saturate, but I do manage to get more
> than 1 Gbit/s total (using the hardware flow offloading capability to
> NAT-route WAN<->LAN and simultanously have a WiFi client access a NAS
> device which also connects to a LAN port. I use MT7915E+MT7975D mPCIe
> module with BPi-R2)
> 
> Using PHY muxing to directly map the WAN port to GMAC2 is also an
> option, but would be limiting the bandwidth for those users who just
> want all 5 ports to be bridged. Hence I do agree with Arınç that the
> best would be to use the TRGMII link on GMAC1 for the 4 WAN ports and
> prefer using RGMII link on GMAC2 for the WAN port, but keep using DSA.

You seem to be rather talking about MT7530 while I think preferring port 6
would benefit MT7531BE the most.

Can you test the actual speed with SGMII on MT7531? Route between two ports and
do a bidirectional iperf3 speed test.

SGMII should at least provide you with 2 Gbps bandwidth in total in a
router-on-a-stick scenario which is the current situation until the changing
DSA conduit support is added.

If we were to use port 5, download and upload speed would be capped at 500
Mbps. With SGMII you should get 1000 Mbps on each.

Arınç
