Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E87B42550D
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241970AbhJGOMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241812AbhJGOMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 10:12:12 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 498F6C061570
        for <netdev@vger.kernel.org>; Thu,  7 Oct 2021 07:10:19 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z184so6928697iof.5
        for <netdev@vger.kernel.org>; Thu, 07 Oct 2021 07:10:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MFikU40VcZQoBz5zOJafhbTBv9rfb96bsh1zzPej8ho=;
        b=PnJCnOweMfvbGBiDUXG2BMwGLRz+6see+gQWLkjI5lzHavH57BrSlVMZCaivbsRQdv
         rPsSMjMWFnPhBga0w5I4rg3nTwExIPmoKEZP2ZS0el01rOsqrH0fPAkLjTAO5LDnruh6
         yJJCJ8EeuRrq9bRLvfCKycbSJu1NTYSNcFTo0RaHAX5UktsSa2gDaFfxHExHD+WEKIDs
         aX3iucj6mqSGONwByMeURlZ0KTfeFmh2U9skVTTX5/FHZ15yMbZV2IQLGLMJvfPb9CWd
         uskHajmTpsoh4SRv+GU8K3ZwwE5JXJA3HCBnfsWw3ncYD3Q/gY0gH6aoKOrpCTh+hYh9
         bAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MFikU40VcZQoBz5zOJafhbTBv9rfb96bsh1zzPej8ho=;
        b=H56KoqWI/qvNd95qLRO2qXSopepxLIMQor6Ox8eFpBbK/5ofD0zzGJufh8Lr5pfQBd
         lr/adnA0gZK85U1UaMh7utahce90VTYgkw5tqtRWSunKe9VMTrRClWG5WWYW1XFDyFkd
         RI6FkqUs8AH5m5182/8KtTJZOUQTN4FSs8xTs92iSKTCB47Eh8aRa+YGSuTrOopY2B4y
         88DENsDuTPtqQDVl7bVDPco+TqkNwJFdKyK0XFUza0WH8o5aGnfQhDFNB+uRRtEN8azC
         SVLwfSJ2+CYH/5zFSh3qxx0Y8TktyXwIhCowLRhM885X50PTf0Xv0gtZm2uYf3AaNM42
         huXw==
X-Gm-Message-State: AOAM530nPQzB5wBhaIkWeLYQ/yxL9Fcp1JUC1XXYXR4PWQlQIjUeyuNu
        DTrQvu5O7aFbB3XTWEPXlKk=
X-Google-Smtp-Source: ABdhPJzblgKIrPdmV5QCOgWEDg1goMkgo+2LwB34qk4Ck5ETwvPLwiEEqP5obfqR+WP04+6KEbYsxQ==
X-Received: by 2002:a6b:8fc8:: with SMTP id r191mr3345041iod.130.1633615818717;
        Thu, 07 Oct 2021 07:10:18 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a8sm4999796iok.36.2021.10.07.07.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 07:10:18 -0700 (PDT)
Subject: Re: [PATCH] net: prefer socket bound to interface when not in VRF
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Mike Manning <mvrmanning@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        Saikrishna Arcot <sarcot@microsoft.com>
References: <cf0a8523-b362-1edf-ee78-eef63cbbb428@gmail.com>
 <20211007070720.31dd17bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9907e6ff-3904-fa66-6562-c3b885eebd34@gmail.com>
Date:   Thu, 7 Oct 2021 08:10:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211007070720.31dd17bc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 8:07 AM, Jakub Kicinski wrote:
> On Tue, 5 Oct 2021 14:03:42 +0100 Mike Manning wrote:
>> The commit 6da5b0f027a8 ("net: ensure unbound datagram socket to be
>> chosen when not in a VRF") modified compute_score() so that a device
>> match is always made, not just in the case of an l3mdev skb, then
>> increments the score also for unbound sockets. This ensures that
>> sockets bound to an l3mdev are never selected when not in a VRF.
>> But as unbound and bound sockets are now scored equally, this results
>> in the last opened socket being selected if there are matches in the
>> default VRF for an unbound socket and a socket bound to a dev that is
>> not an l3mdev. However, handling prior to this commit was to always
>> select the bound socket in this case. Reinstate this handling by
>> incrementing the score only for bound sockets. The required isolation
>> due to choosing between an unbound socket and a socket bound to an
>> l3mdev remains in place due to the device match always being made.
>> The same approach is taken for compute_score() for stream sockets.
>>
>> Fixes: 6da5b0f027a8 ("net: ensure unbound datagram socket to be chosen when not in a VRF")
>> Fixes: e78190581aff ("net: ensure unbound stream socket to be chosen when not in a VRF")
>> Signed-off-by: Mike Manning <mmanning@vyatta.att-mail.com>
> 
> David A, Ack?
> 

yep, sorry, forgot about this one.

Reviewed-by: David Ahern <dsahern@kernel.org>
