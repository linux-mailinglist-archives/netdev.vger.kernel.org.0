Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB1D3772B0
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhEHPnR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhEHPnQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:43:16 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68799C061574
        for <netdev@vger.kernel.org>; Sat,  8 May 2021 08:42:14 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so7071309pjn.5
        for <netdev@vger.kernel.org>; Sat, 08 May 2021 08:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fzwToF1oYf7EgLup2M2jThPzLoGxuigoO4EbUA3+LtY=;
        b=Alj70fA9yxEZPdPv6D9oF1UqE4bCyaDERRMUHAJfMdpkQ/FEdsKDQpHLNyJE2YUZcv
         g2GYF4AdxjBhQJVmHudI7zJnIWLcg8uszOuHpQi/uzi2k9Bee7gGx3AlBOxYTkbLR2Ct
         8pB9Y9TD3/KPlAC+4NWdxJR6o/Ic3qzOQdpQ6nISE3d8PNrjhKF60M01787Q13MtQnc8
         25PObnaLrc2ut9X8KLnqjJw6dxCumZvh/BYNp6th9dB4E81u0LO5Yvwd3bDa7wgGxzSj
         IKXhE3dj6veDNJ8w78iN88Zb+fgtIzzUnMslX2zqLSx794Rm6etOUH3//IzzyCQkdnkg
         7hUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fzwToF1oYf7EgLup2M2jThPzLoGxuigoO4EbUA3+LtY=;
        b=tx/O5ru1kAGG0RTqc47iU8HtbCFlS1rw7lyiT6US2shi0C1dPkaCei5f6Cz+uY7keQ
         mugPIyYriy+ZIo318XR+IpAhUbwHYzeqEEGVacV0T8Il7KgJOlz3hCa8jsrP2P7gLgJs
         4KkIUHHlYbRyCdf9xj7isbYUWUmDyjxPRKnq4ma48m+8IycvhbKUc0aXa58S+QAnDbAX
         BOL6c02T9IhsPy9mi+7qdK8nIPiA1egnUrPn2HQIjLpMkIvesAJ+j3gu4f2ydESTjcjE
         55codthLi1zncCT/hWOOh6dDtzWqJS5R1Rczh59oBGsimSHOSPnBxjQQ98DlqWPSRaEa
         vSjA==
X-Gm-Message-State: AOAM53095vtEowKuScNSHjVmNIo/A3Ms+D00EpL/I9ErFwBF0wgxROhA
        j1uALmCj/TwsEB2ilAoGD1ieVhz2BLk=
X-Google-Smtp-Source: ABdhPJzt3rY77gjSk9stpKyJ2uZSW4zk4yxz3La1ZPg+rPRaEVeDBcJzR2Zo66yzYTyav7DGT8ch9A==
X-Received: by 2002:a17:90b:78f:: with SMTP id l15mr29373832pjz.44.1620488533509;
        Sat, 08 May 2021 08:42:13 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y13sm7247390pff.163.2021.05.08.08.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:42:12 -0700 (PDT)
Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
 STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        dl-linux-imx <linux-imx@nxp.com>,
        "treding@nvidia.com" <treding@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210419115921.19219-1-qiangqing.zhang@nxp.com>
 <f00e1790-5ba6-c9f0-f34f-d8a39c355cd7@nvidia.com>
 <DB8PR04MB67954D37A59B2D91C69BF6A9E6489@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <cec17489-2ef9-7862-94c8-202d31507a0c@nvidia.com>
 <DB8PR04MB67953A499438FF3FF6BE531BE6469@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210422085648.33738d1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1732e825-dd8b-6f24-6ead-104467e70a6c@nvidia.com>
 <DB8PR04MB67952FC590FEE5A327DA4C95E6589@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <c4e64250-35d0-dde3-661d-1ee7b9fa8596@nvidia.com>
 <DB8PR04MB6795D3049415E51A15132F59E6569@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e75fee5a-0b98-58b0-4ec8-9a0646812392@gmail.com>
Date:   Sat, 8 May 2021 08:42:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB6795D3049415E51A15132F59E6569@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/2021 4:20 AM, Joakim Zhang wrote:
> 
> Hi Jakub,
> 
>> -----Original Message-----
>> From: Jon Hunter <jonathanh@nvidia.com>
>> Sent: 2021年5月7日 22:22
>> To: Joakim Zhang <qiangqing.zhang@nxp.com>; Jakub Kicinski
>> <kuba@kernel.org>
>> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
>> joabreu@synopsys.com; davem@davemloft.net;
>> mcoquelin.stm32@gmail.com; andrew@lunn.ch; f.fainelli@gmail.com;
>> dl-linux-imx <linux-imx@nxp.com>; treding@nvidia.com;
>> netdev@vger.kernel.org
>> Subject: Re: [RFC net-next] net: stmmac: should not modify RX descriptor when
>> STMMAC resume
>>
>> Hi Joakim,
>>
>> On 06/05/2021 07:33, Joakim Zhang wrote:
>>>
>>>> -----Original Message-----
>>>> From: Jon Hunter <jonathanh@nvidia.com>
>>>> Sent: 2021年4月23日 21:48
>>>> To: Jakub Kicinski <kuba@kernel.org>; Joakim Zhang
>>>> <qiangqing.zhang@nxp.com>
>>>> Cc: peppe.cavallaro@st.com; alexandre.torgue@foss.st.com;
>>>> joabreu@synopsys.com; davem@davemloft.net;
>> mcoquelin.stm32@gmail.com;
>>>> andrew@lunn.ch; f.fainelli@gmail.com; dl-linux-imx
>>>> <linux-imx@nxp.com>; treding@nvidia.com; netdev@vger.kernel.org
>>>> Subject: Re: [RFC net-next] net: stmmac: should not modify RX
>>>> descriptor when STMMAC resume
>>>>
>>>>
>>>> On 22/04/2021 16:56, Jakub Kicinski wrote:
>>>>> On Thu, 22 Apr 2021 04:53:08 +0000 Joakim Zhang wrote:
>>>>>> Could you please help review this patch? It's really beyond my
>>>>>> comprehension, why this patch would affect Tegra186 Jetson TX2 board?
>>>>>
>>>>> Looks okay, please repost as non-RFC.
>>>>
>>>>
>>>> I still have an issue with a board not being able to resume from
>>>> suspend with this patch. Shouldn't we try to resolve that first?
>>>
>>> Hi Jon,
>>>
>>> Any updates about this? Could I repost as non-RFC?
>>
>>
>> Sorry no updates from my end. Again, I don't see how we can post this as it
>> introduces a regression for us. I am sorry that I am not able to help more here,
>> but we have done some extensive testing on the current mainline without your
>> change and I don't see any issues with regard to suspend/resume. Hence, this
>> does not appear to fix any pre-existing issues. It is possible that we are not
>> seeing them.
>>
>> At this point I think that we really need someone from Synopsys to help us
>> understand that exact problem that you are experiencing so that we can
>> ensure we have the necessary fix in place and if this is something that is
>> applicable to all devices or not.
> 
> This patch only removes modification of Rx descriptors when STMMAC resume back, IMHO, it should not affect system suspend/resume function.
> Do you have any idea about Joh's issue or any acceptable solution to fix the issue I met? Thanks a lot!

Joakim, don't you have a support contact at Synopsys who would be able
to help or someone at NXP who was responsible for the MAC integration?
We also have Synopsys engineers copied so presumably they could shed
some light.
-- 
Florian
