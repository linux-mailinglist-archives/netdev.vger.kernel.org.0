Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5F113CDF
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 05:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfEEC4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 22:56:42 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:53136 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbfEEC4m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 22:56:42 -0400
Received: by mail-it1-f193.google.com with SMTP id q65so13881518itg.2;
        Sat, 04 May 2019 19:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aD/Gm+CX3+Z7BmmDX+1y9aRBjxNWSf+dT672hCgTCVs=;
        b=rUq+Wp9y1MgW6fdnk71WLB4qb92QYsLfTuqHFkBWXXaU9PeuyCD/lBhj4c/zbuVwP1
         RiABLKXpZz9VgPLz6JaCh9Ue2YQG9rebxqFPuRz+ycaWTcoIFN95hzPJiTaf3HaUCgr4
         3Q7+sJK1cPvbseiHOyR9brzhPdTexjbt4f7xvBiWPQGc6MWfgUrZfaE1HvGXY5DYBNA3
         lxOq424tbimdEnnfABCult7GBtYbqWck+dHYiD5IlBU1yssvULZ/sDJqDpbhJWNvzAkA
         YDxc7OIbf7WbeyeMMMU9lzkottKnFwABui7Kp/x0DOuRGni3p/TSifAbkvmY23gbG4Dk
         pSeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aD/Gm+CX3+Z7BmmDX+1y9aRBjxNWSf+dT672hCgTCVs=;
        b=gKpvambmoa0vOaPLt16l4iUo8SrEt1/NUV/9OAKiAPSUlZLgdtLb8ZI4cB8raxAeVj
         Su1onZabGXF+cBUhoItWGdw/cgwfYADMZCEmX9kqlENpP9IRjSITJoWIPeJbUqZsr8xL
         cU1CA/yCFZdMLtIdmCp0z8kUZKdI49ZbwGmVDSDRjLcbGurwJkbAojseqcyIXevEaITd
         zkLXjSI4bqe71s4PV88wc6bjgPVPQd0ULPlIMWbicqGcKAuNc18xTP9e2dOilPdWOouS
         LaaokudNOlfXtxcvMRXW1extW6HtkKRUX7M5DzdcLvccLcA5nIghz1YMCAQc3Dtm1DzF
         Mm/g==
X-Gm-Message-State: APjAAAUNeNQ6/zer63lL4RoHWAbEGgyaNAEP0JHyKHd5eGhMyM0C12Mz
        v6ZFzFbpm9UgLCpWwdK662E=
X-Google-Smtp-Source: APXvYqypP7+LRoGgQ5rc59oLeXUDNoXMuaJ/ZZ5Ar2OJXdC2+hoYu2dhqhulBaSB6xktongz9iiPJg==
X-Received: by 2002:a24:ad0a:: with SMTP id c10mr12845511itf.142.1557025001785;
        Sat, 04 May 2019 19:56:41 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:d454:80ae:df0a:3c? ([2601:282:800:fd80:d454:80ae:df0a:3c])
        by smtp.googlemail.com with ESMTPSA id n22sm2405080ioj.74.2019.05.04.19.56.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 19:56:41 -0700 (PDT)
Subject: Re: [PATCH v2] net: route: Fix vrf dst_entry ref count false
 increasing
To:     linmiaohe <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     mousuanming <mousuanming@huawei.com>,
        Mingfangsen <mingfangsen@huawei.com>
References: <1a4c0c31-e74c-5167-0668-328dd342005e@huawei.com>
 <dd325420-37ae-f731-1ea8-01f630820af0@gmail.com>
 <d20b12f2-129a-7055-6dec-075523458b21@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <7702f04c-648d-eed1-d6eb-20132012d29f@gmail.com>
Date:   Sat, 4 May 2019 20:56:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <d20b12f2-129a-7055-6dec-075523458b21@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/19 8:11 PM, linmiaohe wrote:
> 
> 
> On 2019/5/4 22:59, David Ahern wrote:
>> On 5/4/19 7:13 AM, linmiaohe wrote:
>>> From: Suanming.Mou <mousuanming@huawei.com>
>>>
>>> When config ip in default vrf same as the ip in specified
>>> vrf, fib_lookup will return the route from table local
>>> even if the in device is an enslaved l3mdev. Then the
>>
>> you need to move the local rule with a preference of 0 after the l3mdev
>> rule.
>>
>>
> 
> Move the local rule after l3mdev rule can get rid of this problem. And
> even if this happend, we can delete the same ip address in default vrf
> to fix it.
> But I think maybe it's still a problem because other rule with default
> vrf out device holds the specified vrf device. It looks unreasonable.
> 
> Many Thanks.
> 

VRF is implemented using policy routing. If you do not move the local
rule below the l3mdev rule, you are doing a lookup in the local table
first, then vrf table, then main table. Doing the local table first can
result in false hits - like the case of duplicate IP addresses in
default VRF and a VRF. In short, it is just wrong.

Looking at the VRF documentation in the kernel tree I do see such a
comment is missing, but I do mention in all of the VRF tutorials such as
this one (see slide 79):

http://schd.ws/hosted_files/ossna2017/fe/vrf-tutorial-oss.pdf
