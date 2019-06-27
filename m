Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D42958800
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 19:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfF0RIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 13:08:54 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41794 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfF0RIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 13:08:53 -0400
Received: by mail-io1-f66.google.com with SMTP id w25so6353160ioc.8
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mX6LM/grtaDjR8oNd7oOcF8gzofdiZE44jxdMZ2CBbs=;
        b=Ql8J5leW16qqBgrUXZTmNa1CBVLrGHTSOOf69XE0ckgmWH4kSLWckOdTmx4f2iHYef
         qib7v2BQk/9dj1r1vDjpc8Pp+Sa7OL4kOoJoDXL5WadBulDe6EsNa3jorAG9D6iLRZsq
         Fara1/0ZM6ELDKu03VLURDf4f0341OErRnQHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mX6LM/grtaDjR8oNd7oOcF8gzofdiZE44jxdMZ2CBbs=;
        b=XWSSvl1HFNNEzcbhee0N0BuO9csB4WastHjSrJMQ6iUvmfeuypPHZHIBIXCbLRXNs2
         iOg9zmifrVhMohQ3aDqYKnHttEagYO6hiFk8YOxwm3WvBgVoZs1f55zDgpOaw1JhEGOX
         qAF3EA3vFtiP67qoTrSKvoX8iEVi7qN9I1sAtbTvVmQ2Rime56MmI7KdApcHfy2P9yT+
         /E0PF68odoiPQxuMh3WvSCgvfqX6JHygMETWe5T2KGX+6GSpqQDN650ZArecyh8XGJFu
         zseAHQOUUu3IVo3CCIP3v8P9z+v3WgK/JAD6QomlLpaJwFejMIv6bO9vZZHjJnAWzdD4
         30uw==
X-Gm-Message-State: APjAAAU4tY+UjL12MO+YXl2OvcLgvq4/kN9UOxWjENopv6e7KlBnwn6M
        g1F56OgOeYGXIOE2JSD5Gfsd8w==
X-Google-Smtp-Source: APXvYqyXYQHIushrlD9suJUNOnZwY0KZrv3XkCLjKSJhTjyjfpK6MHokSzUy96I9oh2JTKj+Bkr9HA==
X-Received: by 2002:a5d:9251:: with SMTP id e17mr543228iol.21.1561655332962;
        Thu, 27 Jun 2019 10:08:52 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id c1sm1957842ioc.43.2019.06.27.10.08.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 10:08:52 -0700 (PDT)
Subject: Re: [Linux-kernel-mentees][PATCH v2] packet: Fix undefined behavior
 in bit shift
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>, c0d1n61at3@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20190627010137.5612-1-c0d1n61at3@gmail.com>
 <20190627032532.18374-2-c0d1n61at3@gmail.com>
 <7f6f44b2-3fe4-85f6-df3c-ad59f2eadba2@linuxfoundation.org>
 <20190627.092253.1878691006683087825.davem@davemloft.net>
 <9687ddc6-3bdb-5b2a-2934-ed9c6921551d@linuxfoundation.org>
 <CAADnVQLxrwkgHY6sg98NVfAsG3EYeJLxAevskOUdB=gNQugfSg@mail.gmail.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <7c3d7390-caff-ca2f-760e-9bb72ada90dd@linuxfoundation.org>
Date:   Thu, 27 Jun 2019 11:08:51 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLxrwkgHY6sg98NVfAsG3EYeJLxAevskOUdB=gNQugfSg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/27/19 11:05 AM, Alexei Starovoitov wrote:
> On Thu, Jun 27, 2019 at 9:54 AM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 6/27/19 10:22 AM, David Miller wrote:
>>> From: Shuah Khan <skhan@linuxfoundation.org>
>>> Date: Wed, 26 Jun 2019 21:32:52 -0600
>>>
>>>> On 6/26/19 9:25 PM, Jiunn Chang wrote:
>>>>> Shifting signed 32-bit value by 31 bits is undefined.  Changing most
>>>>> significant bit to unsigned.
>>>>> Changes included in v2:
>>>>>      - use subsystem specific subject lines
>>>>>      - CC required mailing lists
>>>>>
>>>>
>>>> These version change lines don't belong in the change log.
>>>
>>> For networking changes I actually like the change lines to be in the
>>> commit log.  So please don't stray people this way, thanks.
>>>
>>
>> As a general rule, please don't include change lines in the commit log.
>> For networking changes that get sent to David and netdev, as David
>> points out here, he likes them in the commit log, please include them
>> in the commit log.
>>
>> I am working on FAQ (Frequently Answered Questions) section for mentees.
>> I will add this to it.
> 
> Same for bpf trees.
> We prefer developers put as much as info as possible into commit logs
> and cover letters.
> Explanation of v1->v2->v3 differences is invaluable not only at
> the point of code review, but in the future.
> 

Thanks Alex. I will add that to the FAQ.

-- Shuah
