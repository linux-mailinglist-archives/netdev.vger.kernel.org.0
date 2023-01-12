Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867436674F5
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 15:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbjALOQI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 09:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234805AbjALOPd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 09:15:33 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E854D8A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673532416;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bc4MH9gSH4A9sVuPt5vzeujHazYmopcQscWwIhT/mu4=;
        b=E1DUPWISYW7GBbmbZd0IQq3EkEVWuO0JoxDiIpaRT3bQrckI8Pzc7ymJQQVOmQkF53EJ1a
        wvVPjyoccm19290VxBrwl7YKk8XwEOGRrFUfmEqpWTWCZMgim7TU43/xQld4x/cliW/6rj
        ZAWBog0KoY+DaTki9Cdl2QZxovv5iuY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-623-gAtp7NTSMEKOh1PsXjP7Iw-1; Thu, 12 Jan 2023 09:06:55 -0500
X-MC-Unique: gAtp7NTSMEKOh1PsXjP7Iw-1
Received: by mail-wr1-f69.google.com with SMTP id o5-20020adfba05000000b0029064ccbe46so3471427wrg.9
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 06:06:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bc4MH9gSH4A9sVuPt5vzeujHazYmopcQscWwIhT/mu4=;
        b=WPLO4rJcHjz9A7Ugctj4J0TLtCnHHhU/D9+8aOLbFEJr8Rtyy0/+YwVxV7ys3k+lUd
         /VVuifIhcvO8O6kxkHKJ3r+9XomR8TOQu8Z+RW7Omrwu19uCbp9do96MHRBhlSYyhDk9
         DXdwl5SgvjvDtP1kqEulJfSk/WEvEngEqXzGRzrVDinhpW0M+XWWcLi4fOM/QQ+S9Jwk
         G3n+X2iTEgkojy7SIdXdytrh2ImO+VCZfDAoEgXCE0FdjeSN6GkQzNbZrvqrF0uY3c5y
         ZuZWuWiokSvb12y8gcg/A9WHfwyfasS7JFbvRwVB/kNTBgzi0pnFStZNUrxrfyKk/1mT
         RaJA==
X-Gm-Message-State: AFqh2kpVTmPeT+/dEP2Y+RAs+b3M/Ed0gKyq3YfqLCw85a6gHgTRJ1QM
        AIDknrAwUvB1XLtTmjAJFB9D6v/bRuYPjlP3Rwaqflrx6HXz4UlCKx0DNw4ZDAMK+wNevdhLEVn
        3iESeI+nwoSGDV3s=
X-Received: by 2002:a05:600c:35cc:b0:3d3:3c93:af34 with SMTP id r12-20020a05600c35cc00b003d33c93af34mr66344770wmq.2.1673532413405;
        Thu, 12 Jan 2023 06:06:53 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuEt8zNgUQNpMiLc+g3OtEPMR6NYsI6mMq8SlYl+k0EuA0s5e4dBt3/qHK52Cq2Cxf5pfhIpg==
X-Received: by 2002:a05:600c:35cc:b0:3d3:3c93:af34 with SMTP id r12-20020a05600c35cc00b003d33c93af34mr66344746wmq.2.1673532413104;
        Thu, 12 Jan 2023 06:06:53 -0800 (PST)
Received: from [192.168.122.188] (hellmouth.gulag.org.uk. [85.158.153.62])
        by smtp.gmail.com with ESMTPSA id j6-20020a05600c42c600b003b492753826sm20486502wme.43.2023.01.12.06.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 06:06:52 -0800 (PST)
From:   Jeremy Harris <jeharris@redhat.com>
X-Google-Original-From: Jeremy Harris <jgh@redhat.com>
Message-ID: <2ff79a56-bf32-731b-a6ab-94654b8a3b31@redhat.com>
Date:   Thu, 12 Jan 2023 14:06:50 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [RFC PATCH net-next 0/7] NIC driver Rx ring ECN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20230111143427.1127174-1-jgh@redhat.com>
 <20230111104618.74022e83@kernel.org>
Content-Language: en-GB
In-Reply-To: <20230111104618.74022e83@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/01/2023 18:46, Jakub Kicinski wrote:
> Do you have any reason to believe that it actually helps anything?

I've not measured actual drop-rates, no.

> NAPI with typical budget of 64 is easily exhausted (you just need
> two TSO frames arriving at once with 1500 MTU).

I see typical systems with 300, not 64 - but it's a valid point.
It's not the right measurement to try to control.
Perhaps I should work harder to locate the ring size within
the bnx2 and bnx2x drivers.

If I managed that (it being already the case for the xgene example)
would your opinions change?

> Host level congestion is better detected using time / latency signals.
> Timestamp the packet at the NIC and compare the Rx time to current time
> when processing by the driver.
> 
> Google search "Google Swift congestion control".

Nice, but
- requires we wait for timestamping-NICs
- does not address Rx drops due to Rx ring-buffer overflow

-- 
Cheers,
   Jeremy

