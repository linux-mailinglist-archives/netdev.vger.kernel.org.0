Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC7E183DCD
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 01:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726913AbgCMAMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 20:12:51 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34771 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbgCMAMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 20:12:51 -0400
Received: by mail-pg1-f193.google.com with SMTP id t3so3906183pgn.1
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 17:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=k+yg6Llpmfjhe7xJxz56MsL0qbD0y4irrW71qevvME0=;
        b=F18lgvMAZEc+Yiu4gBFj5BfSgRCzsxuSxNQ2dvNhXiNLZIV11X/0LLo5XQ67UUxF0m
         iRZKruILdQY3+mH34vIAVqHBgr/4i15GiLK5XCNyKbZdcYtN/0oBpe+6RbrMU6K0QG4J
         sy72rrg/QPecUY24SosJH9w8kw2eQEf9Ym2zSrZ65iBG9DStREpfDoKQqAMJNH3ZFW7e
         p1+Ek2ckOWuJetvsFWJ2mufVO6s1MnGXAvv6MrG/WLgICQABhRlonvpfmeYjhaLgoY8R
         DcAmnWrWzX2O/3EbSeCsrn2iVZQ+IzCNGg/U35CvMbuv1LVNwOcGVDimdSk5bZ8c+BDS
         hQ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=k+yg6Llpmfjhe7xJxz56MsL0qbD0y4irrW71qevvME0=;
        b=qZ098eJO1y6QdXIr2fmFg/eHyQkzqO1QIhVPgNMPcFkcw4EZFDEVO4482bhD0w1blN
         1sr31Sxiq47q9oGKIFnsBADYPal+2/GVKY9TujUyqsAJ7zCHUjzm2Ny7D7asZZy3sY/a
         YL8A9HPEXGTSdL3SA7icqkXF+gKfnGBEFhY2eMXVRi3ve8EmoZZvxkA4pNkUmrSUM2zf
         x2dbPU7JswKRSrVG3WN+jeYg/KSu515QC97/D6LfKob0YVSrlkYURL5ZCQ9rkb5WMq1S
         KE7un1JipxYV4n7zeaUpQ+FsTHvYm8sk69Kk/SkHJEkgLv5ZzazSG2EbWGJ5xZOFTkz7
         rQjA==
X-Gm-Message-State: ANhLgQ1d6Zm4lnir6hO6E+foJDnc6B8WlAPqUVPhT9FOqo8DwSA/MtG8
        U839DF7pYuLVgT5PCZOoRae7Lnlj+yo=
X-Google-Smtp-Source: ADFU+vvnSlXqQB2+/73VoX72gWL65vYVXo9NXjkdEA7qUK8x6SFEXM3EKOi4UxAOQpb6/xRnF09bCA==
X-Received: by 2002:a63:1c4d:: with SMTP id c13mr10086432pgm.4.1584058368545;
        Thu, 12 Mar 2020 17:12:48 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id e6sm6854120pgu.44.2020.03.12.17.12.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 17:12:48 -0700 (PDT)
Subject: Re: [PATCH net-next 1/7] ionic: tx and rx queues state follows link
 state
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200312215015.69547-1-snelson@pensando.io>
 <20200312215015.69547-2-snelson@pensando.io>
 <20200312.154110.308373641367156886.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <af492e16-927e-e10f-1213-59d14634462d@pensando.io>
Date:   Thu, 12 Mar 2020 17:12:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312.154110.308373641367156886.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/12/20 3:41 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Thu, 12 Mar 2020 14:50:09 -0700
>
>> +		if (!test_bit(IONIC_LIF_F_UP, lif->state) &&
>> +		    netif_running(netdev)) {
>> +			rtnl_lock();
>> +			ionic_open(netdev);
>> +			rtnl_unlock();
>>   		}
> You're running into a major problem area here.
>
> ionic_open() can fail, particularly because it allocates resources.
>
> Yet you are doing this in an operational path that doesn't handle
> and unwind from errors.
>
> You must find a way to do this properly, because the current approach
> can result in an inoperable interface.

I don't see this as much different from how we use it in 
ionic_reset_queues(), which was modeled after some other drivers' uses 
of the open call.  In the fw reset case, though, the time between the 
close and the open is many seconds.

Yes, ionic_open() can fail, and it unwinds its own work.  There isn't 
anything here in ionic_link_status_check() to unwind, and no one to 
report the error to, so we don't catch the error here. However, it would 
be better if I move the addition of the IONIC_LIF_F_TRANS flag and a 
couple other bits from patch 7 into this patch - I can do that for a v2 
patchset.

sln

