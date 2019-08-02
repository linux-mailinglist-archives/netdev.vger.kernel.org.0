Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0333B8024F
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 23:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395176AbfHBVsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 17:48:50 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34700 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfHBVsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 17:48:50 -0400
Received: by mail-pg1-f195.google.com with SMTP id n9so30469539pgc.1
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 14:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=Gp85C8AWFsWiaefKV6EcteDHqO0OeHpa8uVlgLlZ268=;
        b=jLuZMJVMukJ/B3YPkq/1wBHLUiVAQyPeDy0OC7navIW32yAUCiar5G/+aUFuXUrdoh
         gzyp88wxoe9zLciFzYj5nPEwHYHKTHSOiOmX7lfl/yTV92QkIJBRs6zOQF8E8t++sE3K
         nb6CEC7HJb68DUQMLviZTFXNadJnHtjkJku3BoxrVwmlKF8wpILq9QKfZlwmBs3ujmYU
         tfWh6qGjQVTk+KR4o+JA1TqQKkMJydUWSz+2BH3yPf9v/QdZUDOKUk/OFujeChyUh0BW
         gvTPXW1HcB3YA3bX9z/7sKZBXRPM+8mv5hydv8hWAeopwUtM1idjmZXyE6qKmv4PG8aQ
         0zNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Gp85C8AWFsWiaefKV6EcteDHqO0OeHpa8uVlgLlZ268=;
        b=n/rFJmDP7tFHmw1cLRmlhN+XwGTVOVISHzSLls6hYXdNrwPzqV6dbAZ+ehSp5oAEiL
         0uPe4sKOOMBIqLJK9tNO/cTSPtxqJlU9u1wiWRilG3On4gf4Zisqns5FaUYHkkd/W1Wc
         taHPynxjYOo+yi9HWjmyeoUVx0b/tJ6bx3Ra4rzIOHpJzV+zBdsWBRBQfxPy2QvC+BwQ
         oHFYimr9n8Y7Xfpxwvhbcf+WAKzWd/tG84zN2M8er5c0+IMPbc8vf6R1T3ghcyrGQUMz
         UN6NkgMvpd2Bozp6QPar/1DaKnWi2ST6tb0thcwUVvEdvMoWVXnTU1nYuVBIjAVvDPPw
         /Tuw==
X-Gm-Message-State: APjAAAXK6XqDkKlyN4sl5bI4P3tlPE9+Yc0zB+wnvoXJ1mHkzYyxPNdH
        S9cSVi+X/CyW0k0h0zSUg4/o9A==
X-Google-Smtp-Source: APXvYqwharujiEH6SpfpH2YkIiub6QhD3+V/boxvPCgI9cDJY6MtlV3ECa0Uze0L94Y2lvYPfH+XJQ==
X-Received: by 2002:a63:de07:: with SMTP id f7mr24012728pgg.213.1564782529730;
        Fri, 02 Aug 2019 14:48:49 -0700 (PDT)
Received: from Shannons-MBP.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id o14sm8578660pjp.29.2019.08.02.14.48.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 14:48:48 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 18/19] ionic: Add coalesce and other features
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <20190722214023.9513-1-snelson@pensando.io>
 <20190722214023.9513-19-snelson@pensando.io>
 <84f9a5438585a2274df162f6554504138e276d71.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <ee9e32ca-14ce-9893-8257-0e7eac0c42d3@pensando.io>
Date:   Fri, 2 Aug 2019 14:48:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <84f9a5438585a2274df162f6554504138e276d71.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/25/19 5:13 PM, Saeed Mahameed wrote:
> On Mon, 2019-07-22 at 14:40 -0700, Shannon Nelson wrote:

>> +static void ionic_tx_timeout_work(struct work_struct *ws)
>> +{
>> +	struct lif *lif = container_of(ws, struct lif,
>> tx_timeout_work);
>> +
>> +	netdev_info(lif->netdev, "Tx Timeout recovery\n");
>> +	ionic_reset_queues(lif);
> missing rtnl_lock ?
>
>> +}
>> +
>>   static void ionic_tx_timeout(struct net_device *netdev)
>>   {
>> -	netdev_info(netdev, "%s: stubbed\n", __func__);
>> +	struct lif *lif = netdev_priv(netdev);
>> +
>> +	schedule_work(&lif->tx_timeout_work);
>>   }
> missing cancel work ? be careful when combined with the rtnl_lockthough ..
>
>

Yep, good catch on both.  I'll take care of those.

sln

