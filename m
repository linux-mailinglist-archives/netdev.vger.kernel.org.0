Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 828FB193EBB
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 13:19:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgCZMTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 08:19:32 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41366 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbgCZMTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 08:19:32 -0400
Received: by mail-lf1-f68.google.com with SMTP id z23so4619570lfh.8
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 05:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2Oxl8RbYwTpZ/gOLvMl9BnnFknBpsGUWXiaJDhErJBs=;
        b=ep4Y1Q/HLOHUIKHZ+X4l9DkCjY6OFyacVWkJZTFl39zyEVhGIApId4N86v9NoFsm0Y
         371ctDWvhhC/Vs73GH4xIEQKuZg+uAnSKnbu2xY81lp8cmjqfNJmKoDSRTTrQy3wlE18
         v+tEh5kXOrEfVHHzv6U7xe81CpeHzaqcEBlf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2Oxl8RbYwTpZ/gOLvMl9BnnFknBpsGUWXiaJDhErJBs=;
        b=PuafjpAvMqr4K+HrpoLFoo7LFjjtWepSXkkc7lHsU923URcex35qKWwzpKeZFUhCEy
         ZrGiBtWf02scDJD2Xt9vze7MV4zsaIaEyF0mElS/k92Yw4wT68wr8n82YhGummfwaKP3
         gcxr7mxarhDpa75EQ4qeRfw0nQg1WsQbTOd2ggLUivR5OQm19hEY7SjVOp6Z93ec3QbD
         /jX1sbg5svElsZe0kvF82uwjCi5ED+GVE4Kt82Njodu/N7LsWtGYViZ0+ZpPFgykuOfo
         d9KNEvBWyryD/linHMIoYJ9PtFRxvALVsT79PaqES/uHFVOthdLqoAuL1UBtBeoKhDEP
         zaaw==
X-Gm-Message-State: ANhLgQ1dIu+HloAY0PA4S3RlKY8f9t9lCbLgHyhUVRJ0fuxSlglYOxZG
        qEpXreJPiigrdrEyIRNQv+nFbt/6P40=
X-Google-Smtp-Source: ADFU+vsZUov0dXtahGFXeM+oV5XeJyMkV3TB19LszIYDKb949GzB92zwm6kle9LKMKFECy1r0HgcHg==
X-Received: by 2002:ac2:51bc:: with SMTP id f28mr5506252lfk.112.1585225168669;
        Thu, 26 Mar 2020 05:19:28 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id k19sm1344903lfm.47.2020.03.26.05.19.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 05:19:28 -0700 (PDT)
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
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <25bc3bf2-0dea-5667-8aae-c57a2a693bec@cumulusnetworks.com>
Date:   Thu, 26 Mar 2020 14:19:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CA+h21hoYUqWxVTHKixOKvtOebjC84AxcjoiDHXK75n+TpTL3Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/03/2020 14:18, Vladimir Oltean wrote:
> On Thu, 26 Mar 2020 at 14:06, Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
>>
>> On 26/03/2020 13:35, Ido Schimmel wrote:
>>> On Thu, Mar 26, 2020 at 12:25:20PM +0200, Vladimir Oltean wrote:
>>>> Hi Ido,
>>>>
>>>> On Thu, 26 Mar 2020 at 12:17, Ido Schimmel <idosch@idosch.org> wrote:
>>>>>
> [snip]
>>>
>>> I think you should be more explicit about it. Did you consider listening
>>> to 'NETDEV_PRECHANGEMTU' notifications in relevant drivers and vetoing
>>> unsupported configurations with an appropriate extack message? If you
>>> can't veto (in order not to break user space), you can still emit an
>>> extack message.
>>>
>>
>> +1, this sounds more appropriate IMO
>>
> 
> And what does vetoing gain me exactly? The practical inability to
> change the MTU of any interface that is already bridged and applies
> length check on RX?
> 

I was referring to moving the logic to NETDEV_PRECHANGEMTU, the rest is up to you.

