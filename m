Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0314F2ACDB8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733268AbgKJEEe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:04:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733185AbgKJEER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 23:04:17 -0500
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9743DC0613D3;
        Mon,  9 Nov 2020 20:04:17 -0800 (PST)
Received: by mail-il1-x142.google.com with SMTP id n5so10490505ile.7;
        Mon, 09 Nov 2020 20:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sBu1hrR+iEJufcemJ2emJd9xFC60p5FCu0431kHwAT0=;
        b=amMNTrzi3vw7eunKB3n+N2X0yC/qRkMSiFX1sIfzReAgXkVBV4dS++n9O6aVZgYCsi
         UF6ifGBFbW+q1EV6uvCkpNosWLWwS4GwoA75I8WJKu8SzHVJa7a5KcXCTKTHr18X3xs7
         7BqDP4+4zHGjhCmFYxZqjQ/sRMq1D6ntAWqa1Z9IWWfXnJzW+tLo/XJ4cEXm3QEfKPTQ
         ylXPh+fQIdEMWQ8kuu5PMjAKYyjk3vEHh7aoR+p9L/49TeaPkFwTx1qX6Rnof//qH3XX
         R6hy8UkSWkciwro5EPN7a0tbxW00t4bayRTCGx9zPt194QVQtNZq/02+mjWBHcBgaILS
         nMQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sBu1hrR+iEJufcemJ2emJd9xFC60p5FCu0431kHwAT0=;
        b=WNTbx+4tvIMkJlbBb4c0Jr+UqINuiYoCkSXkmesHsulouJaq7NAdTTTK5S5nCQIQLn
         PdJS83I2klaxHmBHQuP5zFsgsXsbwv7aVE/e7QLqZ493yKpIHJr//Aztu17ygj9zrKIZ
         fG22FUsjwiyZmfQecfW3Sofmgl4aVFixCUQDIT37Lc9ghK1A8uIygrDb20CfgKui3Nus
         mUpyo8y/aQOdIfYTREUP2xhpjgYJTNJE3c4TNKYBv+C+WuN8oy4XbZaQ5mJxUFrTrmo2
         ZrDw1DAUAZS2mMzi4I9DAxcMb2h3I8X9z2FO4ZL1wEI2aKw2KnixQiYHPitRrejtOaj2
         tLxQ==
X-Gm-Message-State: AOAM533Dxc/eTZtlOSODQ6T5z951Xm97Qfq2RvfJ+blxR2Piyorp96s5
        yArSYu+L7sHEueMW/CrHXO/3lv8GK/g=
X-Google-Smtp-Source: ABdhPJyL9H2AaOSFP9/Yp8RQ+LXrYMR4VCl09wYd4CSL3AdNFk2XGutQwf3ZF3ToiX1LvEJ+GPrDLg==
X-Received: by 2002:a92:ac0a:: with SMTP id r10mr12874486ilh.205.1604981056948;
        Mon, 09 Nov 2020 20:04:16 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:7980:a277:20c7:aa44])
        by smtp.googlemail.com with ESMTPSA id u18sm6632863iob.53.2020.11.09.20.04.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 20:04:16 -0800 (PST)
Subject: Re: [PATCH net] vrf: Fix fast path output packet handling with async
 Netfilter rules
To:     Jakub Kicinski <kuba@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     Martin Willi <martin@strongswan.org>,
        Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <20201106073030.3974927-1-martin@strongswan.org>
 <20201109154456.0d19e6c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <685d299a-fbaf-7393-300e-774bde294174@gmail.com>
Date:   Mon, 9 Nov 2020 21:04:13 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <20201109154456.0d19e6c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/9/20 4:44 PM, Jakub Kicinski wrote:
> On Fri,  6 Nov 2020 08:30:30 +0100 Martin Willi wrote:
>> VRF devices use an optimized direct path on output if a default qdisc
>> is involved, calling Netfilter hooks directly. This path, however, does
>> not consider Netfilter rules completing asynchronously, such as with
>> NFQUEUE. The Netfilter okfn() is called for asynchronously accepted
>> packets, but the VRF never passes that packet down the stack to send
>> it out over the slave device. Using the slower redirect path for this
>> seems not feasible, as we do not know beforehand if a Netfilter hook
>> has asynchronously completing rules.
>>
>> Fix the use of asynchronously completing Netfilter rules in OUTPUT and
>> POSTROUTING by using a special completion function that additionally
>> calls dst_output() to pass the packet down the stack. Also, slightly
>> adjust the use of nf_reset_ct() so that is called in the asynchronous
>> case, too.
>>
>> Fixes: dcdd43c41e60 ("net: vrf: performance improvements for IPv4")
>> Fixes: a9ec54d1b0cd ("net: vrf: performance improvements for IPv6")
>> Signed-off-by: Martin Willi <martin@strongswan.org>
> 
> David, can we get an ack?
> 

It would be good to get a netfilter maintainer to review; I think it is ok.
