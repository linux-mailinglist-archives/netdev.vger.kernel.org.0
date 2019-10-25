Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE189E4F30
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 16:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439319AbfJYOdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 10:33:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45702 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438994AbfJYOdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 10:33:44 -0400
Received: by mail-io1-f67.google.com with SMTP id c25so2619466iot.12
        for <netdev@vger.kernel.org>; Fri, 25 Oct 2019 07:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KxUs5NeisYl/OHl4GwKN5DZw52YT1rZjvUuYP0c680s=;
        b=OaFgBRkXOY+2kTLLNSCAaY3/dAOzm0arK3uSi4hbL9jSbhFcdZHbd8CVCs8k95n+Yv
         ogH4TUc+y1E/zKa8Dy/S/zOXh8ohUBNYsvBspj/s3vcbjYvzAOHGmtg5Gf1owX6314TG
         OLMq6Ian0HkLvDWFiFoDLuyQW+3BmRH+MtmZLYVafpjIFGNh0kYdbahveSVw0sVWL/98
         sstGHfK5ovL60e28Q6EVzEzc/XEOwjfTPuckQSqU+LsZP4KoPklJa1Oodhd+OQ1r3WI7
         zVBlJrkkamnTGpHqeldAgd8u06foVzapO9TjgaF/+QVJB9f4Iqlzr6WwBC/lxxt3a8+v
         BEJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KxUs5NeisYl/OHl4GwKN5DZw52YT1rZjvUuYP0c680s=;
        b=gyP8cABHPHtMi3gGOiXajCDIJNUNDvOWDpI5IOd7F4BrsyQs7r1Wxe4NVY453BLTLQ
         yIn1PIqmM0Gy4mzlTI6ZWSt4reAkFY6SGr8gJcFgh1rK8iOjPPstruP48RIAs0uIjOUL
         7NC0BYaZcAAmF7EhLK8l44+eKw7mOgJVCuSv/4boBSTe12LSSzjG608ryM9J7MLRXNr0
         JpLwkEd4htfHXDxzRDqx4PwjLaXpX2q7o0vaYUx0Yo3oGrIfQiuCPcjFGiXObkJlfZhD
         ZfKcWfTkAxlH00PHv9+RjHd4/+ZTWZ0u13MYQnKGIfdr2Q/kA5QE/0EhFvhjw7N/6CTL
         sIGw==
X-Gm-Message-State: APjAAAVxNstCs7GxE+DE/KQQCjhWEdXmyHP1Tqg4K0bgPzEmJvMp3f8H
        9pdqOHw/mSYIzWDLwNhuj415Ttq+
X-Google-Smtp-Source: APXvYqyHMveEcd9Q93CougUQBZQedMKHtRDMN9YkrFRFgBXUARFMzSdLZvOg7bLhSNlHrYw6IVGBWw==
X-Received: by 2002:a05:6638:2b1:: with SMTP id d17mr4239816jaq.60.1572014023949;
        Fri, 25 Oct 2019 07:33:43 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b19c:9c8b:8bde:d55c? ([2601:282:800:fd80:b19c:9c8b:8bde:d55c])
        by smtp.googlemail.com with ESMTPSA id 9sm352532ilt.16.2019.10.25.07.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Oct 2019 07:33:43 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: fix route update on metric change.
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Beniamino Galvani <bgalvani@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
References: <84623b02bd882d91555b9bf76ea58d6cff29cd2a.1571908701.git.pabeni@redhat.com>
 <a93347d4-b363-23c8-75e4-d5d0c8ad4592@gmail.com>
 <e73c5f4e91c194a35fcb07a824dec3b0335494b3.camel@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <52ee3355-7d05-54d9-c9b3-b0fa54c6e0f1@gmail.com>
Date:   Fri, 25 Oct 2019 08:33:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <e73c5f4e91c194a35fcb07a824dec3b0335494b3.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/25/19 4:24 AM, Paolo Abeni wrote:
> On Thu, 2019-10-24 at 09:50 -0600, David Ahern wrote:
>> On 10/24/19 3:19 AM, Paolo Abeni wrote:
>>> Since commit af4d768ad28c ("net/ipv4: Add support for specifying metric
>>> of connected routes"), when updating an IP address with a different metric,
>>> the associated connected route is updated, too.
>>>
>>> Still, the mentioned commit doesn't handle properly some corner cases:
>>>
>>> $ ip addr add dev eth0 192.168.1.0/24
>>> $ ip addr add dev eth0 192.168.2.1/32 peer 192.168.2.2
>>> $ ip addr add dev eth0 192.168.3.1/24
>>> $ ip addr change dev eth0 192.168.1.0/24 metric 10
>>> $ ip addr change dev eth0 192.168.2.1/32 peer 192.168.2.2 metric 10
>>> $ ip addr change dev eth0 192.168.3.1/24 metric 10
>>> $ ip -4 route
>>> 192.168.1.0/24 dev eth0 proto kernel scope link src 192.168.1.0
>>> 192.168.2.2 dev eth0 proto kernel scope link src 192.168.2.1
>>> 192.168.3.0/24 dev eth0 proto kernel scope link src 192.168.2.1 metric 10
>>
>> Please add this test and route checking to
>> tools/testing/selftests/net/fib_tests.sh. There is a
>> ipv4_addr_metric_test function that handles permutations and I guess the
>> above was missed.
> 
> Do you prefer a net-next patch for that, or a repost on -net with a
> separate patch for the self-test appended?

As I recall I added the test cases when I added the feature. IMHO, it
would be best to add the new tests with the bug fix.

> 
>> Also, does a similar sequence for IPv6 work as expected?
> 
> Just tested, it works without issue, It looks like IPv6 has not special
> handing connected route with peers/128 bit masks.
> 

thanks for checking.
