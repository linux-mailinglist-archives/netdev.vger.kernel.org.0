Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC45193EA1
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgCZMHD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:07:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:41961 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728330AbgCZMHA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:07:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id n17so6100197lji.8
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6ng3SPX/qfDqukCt5264tLv58cO83BIg+tti6WXKabg=;
        b=TYEL3eOjSuTud6Kklk3FyPkoJoir24bpThqOqEkNqHlt2FSKObT6IX7AuNyB6iUcun
         KhMIsvdyM1jVh+yrg/Ic5r+tL0rRqfaCPmI85+EB6I+8G2eBIK9hDKn/iay2YY4SEeky
         e3vYyF8S3VUzJgqlAY3fAMFn+MDpBbRY25b7A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6ng3SPX/qfDqukCt5264tLv58cO83BIg+tti6WXKabg=;
        b=GpYHz1CTEu4q3j9U0dFs+qfDIvgMZ7rf6PJNR592vP8oM1jQMMKHp1XUlLnaPjn1Cb
         JRUmGRlgBlLy/fZKS0otg2gcX6wFw5ps2ba6GvkisW5SUTur2WPPmi3WFsGkA//RD9Mg
         RPIAtTak+kWttIIL+JFDdpCZO/J3CjHw9JgJ/SIFjl5QWIxKGTpjAFlqk+zEEPHjktlS
         FqyPBi5wUxpr+1DkU4m+WzRKKpK37SKCIVSRJpp0I5gwaYyfSHNs1hwK+N36eoGP8jMw
         wyTkq9pjt09jL+CMKkCD6FaDkyvxVBIY4ObKQYiPTLDGVqE3K5R7D0ouz8hs2MUpzzst
         KxYQ==
X-Gm-Message-State: AGi0PuazMTO5Y0RGyfeVE2TsKJH5eK83TXtxl4Uz+5aYr2d/hbiWkdDN
        zJqe4uT9wfDrYGTBQjszKoZRsbL2cyI=
X-Google-Smtp-Source: APiQypJDgBgfC1rJly6tXY9O3LKm47QK2cg5rXoABsQs8VaLNFHcLWniHoA9gePNLY9aI1HAfZ4Sbg==
X-Received: by 2002:a2e:9ed5:: with SMTP id h21mr5180834ljk.78.1585224415290;
        Thu, 26 Mar 2020 05:06:55 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v9sm1362592lji.11.2020.03.26.05.06.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:06:53 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Ido Schimmel <idosch@idosch.org>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        murali.policharla@broadcom.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <20200325152209.3428-1-olteanv@gmail.com>
 <20200325152209.3428-11-olteanv@gmail.com>
 <20200326101752.GA1362955@splinter>
 <CA+h21hq2K__kY9Pi4-23x7aA+4TPXAV4evfi1tR=0bZRcZDiQA@mail.gmail.com>
 <20200326113542.GA1383155@splinter>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
Date:   Thu, 26 Mar 2020 14:06:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200326113542.GA1383155@splinter>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2020 13:35, Ido Schimmel wrote:
> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
>> Hi Ido,
>>
>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
>>>
>>> Hi Vladimir,
>>>
>>> On Wed, Mar 25, 2020 at 05:22:09PM +0200, Vladimir Oltean wrote:
>>>> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>>>>
>>>> In the initial attempt to add MTU configuration for DSA:
>>>>
>>>> https://patchwork.ozlabs.org/cover/1199868/
>>>>
>>>> Florian raised a concern about the bridge MTU normalization logic (when
>>>> you bridge an interface with MTU 9000 and one with MTU 1500). His
>>>> expectation was that the bridge would automatically change the MTU of
>>>> all its slave ports to the minimum MTU, if those slaves are part of the
>>>> same hardware bridge. However, it doesn't do that, and for good reason,
>>>> I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
>>>> bridge net device itself, and not that of any slave port.  If it were to
>>>> modify the MTU of the slave ports, the effect would be that the user
>>>> wouldn't be able to increase the MTU of any bridge slave port as long as
>>>> it was part of the bridge, which would be a bit annoying to say the
>>>> least.
>>>>
>>>> The idea behind this behavior is that normal termination from Linux over
>>>> the L2 forwarding domain described by DSA should happen over the bridge
>>>> net device, which _is_ properly limited by the minimum MTU. And
>>>> termination over individual slave device is possible even if those are
>>>> bridged. But that is not "forwarding", so there's no reason to do
>>>> normalization there, since only a single interface sees that packet.
>>>>
>>>> The real problem is with the offloaded data path, where of course, the
>>>> bridge net device MTU is ignored. So a packet received on an interface
>>>> with MTU 9000 would still be forwarded to an interface with MTU 1500.
>>>> And that is exactly what this patch is trying to prevent from happening.
>>>
>>> How is that different from the software data path where the CPU needs to
>>> forward the packet between port A with MTU X and port B with MTU X/2 ?
>>>
>>> I don't really understand what problem you are trying to solve here. It
>>> seems like the user did some misconfiguration and now you're introducing
>>> a policy to mitigate it? If so, it should be something the user can
>>> disable. It also seems like something that can be easily handled by a
>>> user space application. You get netlink notifications for all these
>>> operations.
>>>
>>
>> Actually I think the problem can be better understood if I explain
>> what the switches I'm dealing with look like.
>> None of them really has a 'MTU' register. They perform length-based
>> admission control on RX.
> 
> IIUC, by that you mean that these switches only perform length-based
> filtering on RX, but not on TX?
> 
>> At this moment in time I don't think anybody wants to introduce an MRU
>> knob in iproute2, so we're adjusting that maximum ingress length
>> through the MTU. But it becomes an inverted problem, since the 'MTU'
>> needs to be controlled for all possible sources of traffic that are
>> going to egress on this port, in order for the real MTU on the port
>> itself to be observed.
> 
> Looking at your example from the changelog:
> 
> ip link set dev sw0p0 master br0
> ip link set dev sw0p1 mtu 1400
> ip link set dev sw0p1 master br0
> 
> Without your patch, after these commands sw0p0 has an MTU of 1500 and
> sw0p1 has an MTU of 1400. Are you saying that a frame with a length of
> 1450 bytes received on sw0p0 will be able to egress sw0p1 (assuming it
> should be forwarded there)?
> 
> If so, then I think I understand the problem. However, I don't think
> such code belongs in the bridge driver as this restriction does not
> apply to all switches. Also, I think that having the kernel change MTU
> of port A following MTU change of port B is a bit surprising and not
> intuitive.
> 
> I think you should be more explicit about it. Did you consider listening
> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
> unsupported configurations with an appropriate extack message? If you
> can't veto (in order not to break user space), you can still emit an
> extack message.
> 

+1, this sounds more appropriate IMO

