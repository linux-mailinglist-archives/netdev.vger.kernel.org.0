Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91457235E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 02:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfGXAT6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 20:19:58 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41097 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfGXAT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 20:19:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id x15so9882612pgg.8
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 17:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=EoD6FxInBFoe7XH1LbskC7Xx5qCfh/OPWUO7hTqS2Kg=;
        b=iGsmuZxGZVPiI3r3VlLwKGSzWvbJrax9/LqX4rpzHY0NNGH8ebU+YJw83BKsRNLCfA
         /H7MZdhX3BE4EWDWZrQNkCZBM4TdEpn+MzcWfnNAvdaDVVPiGsM1vERLMxhG+3beWNFa
         7qovYA2j3L634uzYXFFMhzIjQpoHfGHBzLP2VFYJFXTy3DgDiQ+GSoh6xuTukJLFUkZd
         93GcbyKOABrj8vewapjW9T4wZsXrugDDPV6u9mu/DHOFbmL/W0+BLpEJuXkaU2UTdREc
         BaLq6yMOe0PTfnDU5x2X3B8LaPicW+k1/wkyaOq0xwg2F2lPXV57oymXncuPffFI/djw
         pQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=EoD6FxInBFoe7XH1LbskC7Xx5qCfh/OPWUO7hTqS2Kg=;
        b=hf+3s8Qkr6xEOCcodaXCwv+U3cDeqeh02vkyGc4CylUySNnR1wOXYKek+wO/shDFS/
         muvubjk8Th882XENDHj3z6Vy5Ye4M4J7G9oM4aW1Rj8veY7ecLFygpD8vRuyE2Cy+EbD
         Pk8TMAL3gR58J8Dq6Q82LGzsiW0iWz0kEwr2tTVXbuLb8pJGyEK3HhSbnRb0RrGGtq8t
         7ucXXFYQrbVxY/AzOsjrQa5yYMWxarz96ysePXVeglXlkE98Esgr7mJRL2/IxanKlcCd
         38yZmYatbPWHoeXTFeXsztTVOey+qZkWOrF5f6pbCSR9IOnWGXwUosbsgP8z5JvXGAjx
         h4xg==
X-Gm-Message-State: APjAAAVBZB3xSCfvnjAVmhSbq7yp6AD86WgKwqnwGZ1YLRV/zHS4aNZx
        8aoeDrqgKUlRLHsqQGqCSpCqdZ1xQNcRYQ==
X-Google-Smtp-Source: APXvYqxpmBlF+BTk9bxhXFpBdY8slr7PhvMYmG1JxkYfVcXS7GL2aOzu75Iy7VpWGmvVZoOdetnYoQ==
X-Received: by 2002:a17:90a:17ab:: with SMTP id q40mr86220709pja.106.1563927596887;
        Tue, 23 Jul 2019 17:19:56 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id f64sm46394064pfa.115.2019.07.23.17.19.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 17:19:56 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20190722214023.9513-12-snelson@pensando.io>
 <20190723.143326.197667027838462669.davem@davemloft.net>
 <e0c8417c-75bf-837f-01b5-60df302dafa7@pensando.io>
 <20190723.160628.20093803405793483.davem@davemloft.net>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <5e3d5b42-2787-9fcf-1cd5-fb3063dfabc9@pensando.io>
Date:   Tue, 23 Jul 2019 17:19:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723.160628.20093803405793483.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/19 4:06 PM, David Miller wrote:
> From: Shannon Nelson <snelson@pensando.io>
> Date: Tue, 23 Jul 2019 15:50:43 -0700
>
>> On 7/23/19 2:33 PM, David Miller wrote:
>>> Generally interface address changes are expected to be synchronous.
>> Yeah, this bothers me a bit as well, but the address change calls come
>> in under spin_lock_bh(), and I'm reluctant to make an AdminQ call
>> under the _bh that could block for a few seconds.
> So it's not about memory allocation but rather the fact that the device
> might take a while to complete?

Memory allocation may or may not be involved, but yes, mainly we're 
doing another spin_lock on a firmware command that waits for an ACK or 
ERROR answer, and in extreme cases could possibly timeout on a dead 
firmware.  I know that i40e and ice do much the same thing, and I 
believe mlx5 as well, for the same reasons.  I suspect others do as well.

> Can you start the operation synchronously yet complete it async?

This could be possible, but would likely require a bunch more messy 
logic to track async AdminQ requests, that otherwise is unnecessary.

sln

