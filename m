Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5D6193EFF
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgCZMjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:39:02 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:45121 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727841AbgCZMjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:39:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id t17so6191776ljc.12
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:39:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b7cQ1mUwjClMcnW2KJfB2V/P1yslQqev1HDDWXTCiCA=;
        b=OcXLvCC+WGi200SHaXvISmDntR2vbf0j5XF0rpixzeHSyVR52RbN84KrUnsQLxkBRk
         n2oJy/kPKqDwyAiC46tAOn1uQF35FoE22Guen4h92tcsPP/svaCsED4QGhOasn28PRFA
         H2wtZWIXYvH1YcdjA1vcxgXN/QuqzG0cYoMFo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b7cQ1mUwjClMcnW2KJfB2V/P1yslQqev1HDDWXTCiCA=;
        b=szvL1UR7HUzXg0X+qbkGpPDV2KnS23d5IfBE0LtNpfjKRlpadhWvhLq+mvqObW4Rim
         ZgVi+UvU7JSfOwdyXQINHwZFqF2LuBCZXQwXSRJRpQaYKtj2Ls9fLSY3kOJPDERRIGRk
         hIzJomnXpHPNpDNmyZZaz51pGN4FA8R1n/0ueBA3CbrMBPDU92N2RQuBVUTZCMZM4zJm
         YVX6ZzvRrsT63Yn7AAeJQjcoffyNPs6DJg5h5zQTSfdKtm2dwwj23JWa3eyepzRRXPoR
         dtBddATrvtW9cOzgbg8tBNZGBqGKLm8+mKvH23hA/26ehwMAlz7rWyta+531C1OAHzpU
         L8pg==
X-Gm-Message-State: AGi0PubdRkOUz8OZF+XTOyKDxU4huSagkEilpB2VTALYOuVCPf/BXdSE
        zAtoG6AstxmnpLFKwY2NkidXrRmo0mA=
X-Google-Smtp-Source: ADFU+vsZq6+jULhbKBKSKeNQGfg1MbT0z8JgKmeVoV52XewKddrasW48PBIUvTRD+XUkLXqPWSDZHQ==
X-Received: by 2002:a2e:8911:: with SMTP id d17mr5193573lji.16.1585226339455;
        Thu, 26 Mar 2020 05:38:59 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id v22sm1367237ljc.79.2020.03.26.05.38.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:38:58 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 10/10] net: bridge: implement
 auto-normalization of MTU for hardware datapath
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, Andrew Lunn <andrew@lunn.ch>,
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
 <83375385-7881-53b7-c685-e166c8bdeba4@cumulusnetworks.com>
 <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com>
 <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
 <CA+h21hp3LWA79WwAGhrL_SiaqZ=81=1P6HVO2a3WeLjcaTFgAg@mail.gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <e68cbeb2-f8db-319c-9c4c-32eb3b91a7b9@cumulusnetworks.com>
Date:   Thu, 26 Mar 2020 14:38:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hp3LWA79WwAGhrL_SiaqZ=81=1P6HVO2a3WeLjcaTFgAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2020 14:25, Vladimir Oltean wrote:
> On Thu, 26 Mar 2020 at 14:19, Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
>>
>> On 26/03/2020 14:18, Vladimir Oltean wrote:
>>> On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
>>> <nikolay@cumulusnetworks.com> wrote:
>>>>
>>>> On 26/03/2020 13:35, Ido Schimmel wrote:
>>>>> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
>>>>>> Hi Ido,
>>>>>>
>>>>>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
>>>>>>>
>>> [snip]
>>>>>
>>>>> I think you should be more explicit about it. Did you consider listening
>>>>> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
>>>>> unsupported configurations with an appropriate extack message? If you
>>>>> can't veto (in order not to break user space), you can still emit an
>>>>> extack message.
>>>>>
>>>>
>>>> +1, this sounds more appropriate IMO
>>>>
>>>
>>> And what does vetoing gain me exactly? The practical inability to
>>> change the MTU of any interface that is already bridged and applies
>>> length check on RX?
>>>
>>
>> I was referring to moving the logic to NETDEV_PRECHANGEMTU, the rest is up to you.
>>
> 
> If I'm not going to veto, then I don't see a lot of sense in listening
> on this particular notifier either. I can do the normalization just
> fine on NETDEV_CHANGEMTU.
> 

I should've been more explicit - I meant I agree that this change doesn't belong in
the bridge, and handling it in a notifier in the driver seems like a better place.
Yes - if it's not going to be a vetto, then CHANGEMTU is fine.


