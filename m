Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A22CAF40
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 21:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731493AbfJCT3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 15:29:30 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44615 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfJCT3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 15:29:30 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so2349204pfn.11
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 12:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g4UL4onqz5pYceZnevRFUIiTmXXOG8WGHDes2a6KY54=;
        b=SKwh4Goersvbgy1coE2ebtTcg3EwuZe1idqnpjcODI5Z7Fbz5idRPETS4OoN1FNoh0
         40/3SX9h6UP8f869geDU+Qw07nacJlHIqkX4kb3f+7YOTZZ3aRcwEgvd1+41YI6l0xJW
         PoEUTwJdG1XKxcvO7nITqG/Y8rCgeAcO4Es1XGM9UTk/7kvaOZ02irT9xVM9VmH2TFm/
         pWjdwgJhZJZu/H4ihgskZlcj0ABR81woD1mCXfJ0bvt/h+IO1XkvWzTnwZKrSStCPZBP
         6gm5yJAZVN3EvFbfKaxqPgMrw5mFj4rAgAvnowdHK6sGhhyjRF2p9tTM68Omq4aOmRRl
         b1EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g4UL4onqz5pYceZnevRFUIiTmXXOG8WGHDes2a6KY54=;
        b=Az56jAJYx8h3+/vlGyXcBmK10H0O609rEMQ/3z1uHa6ld5ndb108ApUfWWkI8tP1nI
         tyEMRzBSa/7AnaEfeSQ5tEB4ltowv+/yw6CHgI1jIjwHXA5ouIr38K9D91uYeGSL2Fnb
         RruOXLXxlkdAJk7V/dbec+XqNraKzfqilCN7cShITVj5k3k/uaFyNTjOiWgTut7fgtoS
         rF5r/vOfMszKCXdkiUqCmWPgUaQa6TFH8Bp70Geux6ydW+YqF2fOabuNdP1JW1UT17oZ
         RXTN1X3VYRZ0lQUA0Uj+RHpJN1cx69And9jI1majjOYtrpRqO5iHR5G8YQehoAm40s5r
         xC8Q==
X-Gm-Message-State: APjAAAWvdfiuw5W+d8uqm+MKJPVxORQx+r1HkUWNUcw6hq8Wtyj5ap7p
        22Nm1H1H1eQCmmEDNaj169E=
X-Google-Smtp-Source: APXvYqz87T0yP6XUsSVRZCZf4dSaeFPNpxBlIztpSOW3jmwxnhJejgIb1ZHmYGyFM9fOpDxo5Gnqbg==
X-Received: by 2002:a65:6105:: with SMTP id z5mr11191151pgu.241.1570130968130;
        Thu, 03 Oct 2019 12:29:28 -0700 (PDT)
Received: from [172.27.227.189] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id w5sm3850381pfn.96.2019.10.03.12.29.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 12:29:26 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <4c896029-882f-1a4f-c0cc-4553a9429da3@gmail.com>
 <43e2c04f-a601-3363-1f98-26fd007be960@gmail.com>
 <0471f2fd-c472-34c1-5dab-0aa01c837322@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4613d57f-9396-7469-51fd-c7499805e75f@gmail.com>
Date:   Thu, 3 Oct 2019 13:29:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <0471f2fd-c472-34c1-5dab-0aa01c837322@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/3/19 11:19 AM, Eric Dumazet wrote:
> 
> On 10/3/19 9:32 AM, Eric Dumazet wrote:
>> Still no luck for me :/
>>
> One of the failing test was :
> 
> unshare -n
> ./traceroute_test.sh -I icmp
> 

thanks for the test. I need to chase down a few more code paths, but I
am thinking the proper next step is to revert the patch and I will come
up with an alternative solution for the problem Rajendra reported.
