Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C6725516B
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 00:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728067AbgH0W6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 18:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgH0W6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 18:58:38 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C13AC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:58:38 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id z18so3420763pjr.2
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 15:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=AucB4HoH5yT0wHllUii+LFfBm/3P2Io3CKZKtUNaRjk=;
        b=uMJE9TuvUhdZvHMgR59eGOa3tcgjwpPWJ5sCDuG5QiGXPgYrapA8S8acSzueVwTY7X
         PkQvyYbLOgo5AtumZezT138GFgy0Rz7R5qJ3ej85GGVwG/5gDElMVzioRRD4m24qH5gW
         u8AYyTzRq/KLPQkU+6LJmGWfHmcgnGqpgHDadS89WeHOTOkuMNo+uNK98yBeDDMyXA4q
         GD6OZ1sUKyVDTxDJdeaRU8tPVWpYxIJWNOHQDZcfasB06YM9/kbcJsbayf1LQpRLjO5a
         fgF982NshRiEqsT6G87MQkKAJOG12ezKzfawruOOkdmJ3hvuJsULHkfvwp5b8KiPYWRD
         yb8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=AucB4HoH5yT0wHllUii+LFfBm/3P2Io3CKZKtUNaRjk=;
        b=XhRRFfby7kYGCp6ZP+RugzFwrEwVKncIDi6s73pYe2k8hkzZTGeJNKUVCVrV4zCZfp
         70YLl/3CzCAGACK6dQGSkYtmAUEh2htRQa4b78EcGNn9Nfb+f8iBW76rjvukmGk2iTM7
         5+IztHfF9Of6h5xoNlZEngD5pWPkHTvlcPtSu4fNcBByIabjHgwqk1eJYH8KgbHO5xYu
         e938/bMNyqvjPfJcPnpS9JYUxjJp5v+L8GWhxZAkWO7XJ4CsQvTsA/ufQUvGRQqLcULm
         S98U1WUd3m273tN0cBwijf6aRFu5O68+JCRQgjpNmgPwgHVTkFbs1gVQlUos5wViwe1h
         mgtg==
X-Gm-Message-State: AOAM530q3ZI03N87o15riYpAcwUI+xWziajDXtlLog03SxDffJJcy1dF
        mBD0GpDUh/3F7M2xAVLlrDx10HdnWRQrfg==
X-Google-Smtp-Source: ABdhPJz4M2Bx0OkDZOYIeW7er05YzjWnx2ZlC0PAiMwUbYt9XxhrVf17jR/YCWoLFZR1tYbqj5xXRg==
X-Received: by 2002:a17:90b:4397:: with SMTP id in23mr945717pjb.102.1598569118102;
        Thu, 27 Aug 2020 15:58:38 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id s8sm107171pfc.167.2020.08.27.15.58.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Aug 2020 15:58:37 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 07/12] ionic: reduce contiguous memory
 allocation requirement
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200827180735.38166-1-snelson@pensando.io>
 <20200827180735.38166-8-snelson@pensando.io>
 <20200827124625.511ef647@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <bd9b0427-6772-068e-d7bd-b1aabf1ac6ed@pensando.io>
 <20200827142536.587f0ecc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <87e8b976-b495-d989-25ab-ecd871f9dc16@pensando.io>
Date:   Thu, 27 Aug 2020 15:58:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200827142536.587f0ecc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/27/20 2:25 PM, Jakub Kicinski wrote:
> On Thu, 27 Aug 2020 12:53:17 -0700 Shannon Nelson wrote:
>> On 8/27/20 12:46 PM, Jakub Kicinski wrote:
>>> On Thu, 27 Aug 2020 11:07:30 -0700 Shannon Nelson wrote:
>>>> +	q_base = (void *)PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
>>> The point of PTR_ALIGN is to make the casts unnecessary. Does it not
>>> work?
>> Here's what I see from two different compiler versions:
>>
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning:
>> assignment makes pointer from integer without a cast [-Wint-conversion]
>>     q_base = PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
>>
>>
>> drivers/net/ethernet/pensando/ionic/ionic_lif.c:514:9: warning:
>> assignment to 'void *' from 'long unsigned int' makes pointer from
>> integer without a cast [-Wint-conversion]
>>     q_base = PTR_ALIGN((uintptr_t)new->q_base, PAGE_SIZE);
> Just
>
> 	q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);

Got it
sln
