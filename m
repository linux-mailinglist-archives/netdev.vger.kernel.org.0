Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D8346EAF9
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 21:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbfGSTRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 15:17:47 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:35043 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727734AbfGSTRr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 15:17:47 -0400
Received: by mail-io1-f67.google.com with SMTP id m24so60683055ioo.2
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 12:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYom2UNS2ShD8Awg1j+2vPvOzfMncD5P0dbl6lOVAWg=;
        b=G7eiEZPm94DMIAj76dY/HN5osv1vTtRiNyFIRoFGh0cz1AZZu/wglBa+bMFNejRw/G
         d/iP5O6XqvtQyeevF6eobrduN0RbEJ3J4b6YmyB6RsUG1ECX8sCSSf7SBvKcyIQHTf1b
         3+rNoBHOK/e7lXJExw/mQqDdF6KuwKfOZ6rOA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYom2UNS2ShD8Awg1j+2vPvOzfMncD5P0dbl6lOVAWg=;
        b=MxlOATMW536+MC3M4Nj5pmf0tiBzjinkMH523VJ4hTR5xWfwbPFQbsNA8bNcZxO8zR
         Nb22nrO7gdgdUxuOLIWNF1UEc0CapF0BBMB2zyML/R5RjxjktOGTclaiAdSdfkWE8y//
         duOnOQlBJd6iUSIQHqWaRbeV5FxD6tQlWE/8oSCuuMOWKYp8Mka/aHzRDix4C3MGtTcX
         AyFsTKGmSMFaPyIc96mctEUuKNbMH0fw4CrJNO0ebYoTp2Befyxb1vDvTMgpKsjJ06Yd
         +senA6dfV52lTpyc0tfW/G7D0+82jA+kVtHvXzku1/crdHDaE0PRqlqjgg+4V3R8X2wN
         zsIA==
X-Gm-Message-State: APjAAAUf6eK86MUybej/93hYbDOZ6RGrNwNZFUyYIVqKKMmIhaTmc4yc
        vNofSlTn4jeokK7bekpcYs3CxA==
X-Google-Smtp-Source: APXvYqxPx/csCPoEteEKD5DXzCwYUPKKeK/r+Onk709tFFqkvFUYYCySkJXUAVM52VHyRzRmBFGkeA==
X-Received: by 2002:a6b:6a01:: with SMTP id x1mr11902637iog.77.1563563866410;
        Fri, 19 Jul 2019 12:17:46 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b559:3352:82ff:93d8? ([2601:282:800:fd80:b559:3352:82ff:93d8])
        by smtp.googlemail.com with ESMTPSA id n7sm23662470ioo.79.2019.07.19.12.17.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 12:17:45 -0700 (PDT)
Subject: Re: [PATCH v2] vrf: make sure skb->data contains ip header to make
 routing
To:     Peter Kosyh <p.kosyh@gmail.com>
Cc:     davem@davemloft.net, Shrijeet Mukherjee <shrijeet@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <213bada2-fe81-3c14-1506-11abf0f3ca22@cumulusnetworks.com>
 <20190719081148.11512-1-p.kosyh@gmail.com>
From:   David Ahern <dsa@cumulusnetworks.com>
Message-ID: <8874f5a2-b86f-6c85-525f-534381daa8a3@cumulusnetworks.com>
Date:   Fri, 19 Jul 2019 13:17:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190719081148.11512-1-p.kosyh@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/19 2:11 AM, Peter Kosyh wrote:
> vrf_process_v4_outbound() and vrf_process_v6_outbound() do routing
> using ip/ipv6 addresses, but don't make sure the header is available
> in skb->data[] (skb_headlen() is less then header size).
> 
> Case:
> 
> 1) igb driver from intel.
> 2) Packet size is greater then 255.
> 3) MPLS forwards to VRF device.
> 
> So, patch adds pskb_may_pull() calls in vrf_process_v4/v6_outbound()
> functions.
> 
> Signed-off-by: Peter Kosyh <p.kosyh@gmail.com>
> ---
>  drivers/net/vrf.c | 58 +++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 35 insertions(+), 23 deletions(-)
> 

Reviewed-by: David Ahern <dsa@cumulusnetworks.com>
