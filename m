Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9367C7235D
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfGXATl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:19:41 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:46438 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726871AbfGXATl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:19:41 -0400
Received: by mail-pl1-f195.google.com with SMTP id c2so21215816plz.13
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Gxz+8xw7OEyi89WQtqSW+cfjsssvE6kfdZisv98sU0k=;
        b=j7G/1F9IcNveIWlFoyqQQehIbicdGgfZCNEAI+auGqbhmSRrey/m8qmZPDY+8sOjpi
         wpEXb6jA9xTFf7XHnDBaz29gVh9dWhCmZzFOOj0q5QCmI90xecVrQ7WGtUdK97zOkcey
         NDaoZ5+BSkYoktb9F7lQ+I+vf9v71Z5yjmjV3rXcl4UDvDwLImer1GJc/fP2GgMLTYls
         Vb/16fkY1wrHGNiGzrAs71MKSOfY6FofF5Gtn1tjWt0EKNfy5lA97gjbDjjbjSaQ6koq
         4zpKezjyjja3CwXlmizOjaaiOaLJv5SqxvuGYwHoDz2g3o0KROaQyeamJ1U47+NJa9s6
         xpng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Gxz+8xw7OEyi89WQtqSW+cfjsssvE6kfdZisv98sU0k=;
        b=hXQ1SMGXxv+lN9gE6vcTySppdi6WB6wDt7VNRoMFA30KDcyQwLKqms6c4ZsXJDFnxw
         hLeg0fJwLO18etOz7PlRpuFDj3jFpbJpBp4gmqjfISVgmK1Oem1IrVOwPnDwmUexA2up
         3uSkYLV9MCYl+mLakGhsi0V7+J2GzDyqvYda90sxLATPHzlgBc20SHyv4etByQTKcpvY
         c4vPkiSjffC/7hB8bjML4bIOcfnyZLuo57/4OWfCIHZZVaNcQW0bJHupV/MK6PTzDyvw
         ut35qCpMgq7ytub6OhNWKrnobp6nxVmQkLGB0LXyuN4zjhVGaS4ZMGbxlBzvjnpbIgBg
         0Qmw==
X-Gm-Message-State: APjAAAWNzlkXuQnqb977B60u+Kf7EF7A8CaaCgbPxZv1hR5xUh320DOt
        PX2u45iubsmZjRZIQBfQbdl6qRtkH4wyAA==
X-Google-Smtp-Source: APXvYqy3JYT1Q71a43hbpHs/K2SnkgAacGKse5jTQ9BBGAep9jBtgZRuqDo9dSGxW2g0RsUrGO9TMg==
X-Received: by 2002:a17:902:b093:: with SMTP id p19mr80252791plr.141.1563927580640;
        Tue, 23 Jul 2019 17:19:40 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id q21sm28125103pgb.48.2019.07.23.17.19.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 17:19:40 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
To:     Saeed Mahameed <saeedm@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20190722214023.9513-12-snelson@pensando.io>
 <20190723.143326.197667027838462669.davem@davemloft.net>
 <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
 <20190723.160628.20093803405793483.davem@davemloft.net>
 <ba8349adaea24d955be3e98abf9ade59b0a9f580.camel@mellanox.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <2259352c-7ff7-88b0-f5d7-c6bf36645c53@pensando.io>
Date:   Tue, 23 Jul 2019 17:19:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ba8349adaea24d955be3e98abf9ade59b0a9f580.camel@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:54 PM, Saeed Mahameed wrote:
> On Tue, 2019-07-23 at 16:06 -0700, David Miller wrote:
>> From: Shannon Nelson <snelson@pensando.io>
>> Date: Tue, 23 Jul 2019 15:50:43 -0700
>>
>>> On 7/23/19 2:33 PM, David Miller wrote:
>>>> Generally interface address changes are expected to be
>>>> synchronous.
>>> Yeah, this bothers me a bit as well, but the address change calls
>>> come
>>> in under spin_lock_bh(), and I'm reluctant to make an AdminQ call
>>> under the _bh that could block for a few seconds.
>> So it's not about memory allocation but rather the fact that the
>> device
>> might take a while to complete?
>>
>> Can you start the operation synchronously yet complete it async?
> The driver is doing busy polling on command completion, doing only busy
> polling on completion status in the deferred work will not be much
> different than what they have now..
>
> async completion will only make since if the hardware supports
> interrupt based (MSI-x) command completion.

Actually, there are two different command paths - one for basic 
low-level setup, and one for more advanced work:
- dev_cmd does indeed do polling on PCI register space, and we try to 
keep this to a minimum
- adminq does a wait_for_completion_timeout() which gets completed in an 
MSI-x handler

The rx_mode related work goes through adminq.

Yes, it could be made async, but would the extra logic needed buy us 
that much?  We already know this model works in other drivers.  We 
wouldn't get the address into the hardware any quicker, and we still 
wouldn't get any errors from the request back to the original call.

sln

