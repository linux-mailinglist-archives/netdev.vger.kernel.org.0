Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C845C94A2
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfJBXLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:11:53 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44762 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfJBXLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:11:53 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so437179pfn.11
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6kNiFCH3JgjxIFhjG6y6pkZ/pgq7UmRP7WpUk8Zpko=;
        b=upwO/39PZBtvT3QGZxXXLoy06OiZmdNz9AsplKg2wkmNBpMXLhyDqykqGk4/whT3YA
         Q+WQ8WWmKLC12gxy0b3NvEzR2njvIW7NSa1/nIyjuTZlaThAP3ykO4h0f8lGGQWjR5IF
         dQuHdGDbOhIQEQOF0A3+1FdavedU6DvtW4GWEqWAepMV7eZHuHse6IqnL1lIIdunQFhf
         OCdK+dc1Wat1CKO/4ggbxvLXKWUJ6S4tyYKYyBmlHf1wBQAjuSjnr8CmG8Tf6HHg9d/R
         FqpuJUifIbLTljXGNvg1lCwiuMOz3QKdZqm+spmVECwG8vT/q0Xde48DTqTmUGib8R/k
         TI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6kNiFCH3JgjxIFhjG6y6pkZ/pgq7UmRP7WpUk8Zpko=;
        b=hm2rQcgrdoUg4LvGxFPkvP1aLNYIKA9DRHAkMpLyXbFlONa8mNaE4pOKG4TR3CQQdG
         +xBd+eqG20wvLJXbisAEWjDoSsLA0z375QlnJRouurDbNsVEIRJIXOgJzMNCYVdZV/vS
         cVOpT36MDHJMm1xVqfwmX7SEYhEifoyS8ZjNoe+LzclEEna9yBTQjYpu7Z7i5Q03mEJx
         kampzhTvoI9TWbZgp45iV6dIH25l+AiFPgGP+h/BY5Hn43EsNLDH3DmSrLMcnXNb1WMp
         PVmPBu5shz+AtpOLHcEG9iXk5aWFYRt+1ergmwu47Ap+7WhtvZUGePllEue9mj3HkFxa
         +Nag==
X-Gm-Message-State: APjAAAXBUI1u37l0iVsU7AvCBOhx+/y/az2TEFd6+m9GAU9ir9kdamB+
        YSwiE1Wj1AOzY1CAP2GCscU=
X-Google-Smtp-Source: APXvYqwiQjqdiNOH5vxve8bO6c4wR2VWS0TEdMl2YokXaFD9xTvidfme0Sz/QlhsaAOIqFAXOESeFQ==
X-Received: by 2002:a62:fc8c:: with SMTP id e134mr7667007pfh.132.1570057912763;
        Wed, 02 Oct 2019 16:11:52 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id y4sm393205pga.60.2019.10.02.16.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Oct 2019 16:11:51 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <8d13d82c-6a91-1434-f1af-a2f39ecadbfb@gmail.com>
 <3dc05826-4661-8a8e-0c15-1a711ec84d07@gmail.com>
 <45e62fee-1580-4c5d-7cac-5f0db935fa9e@gmail.com>
 <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <68b04493-1792-e6b9-e248-365f889d0964@gmail.com>
Date:   Wed, 2 Oct 2019 16:11:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <7bd928cb-1abf-bbae-e1db-505788254e5b@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/2/19 3:36 PM, Eric Dumazet wrote:
> 
> 
> On 10/2/19 3:33 PM, David Ahern wrote:

>>
>> I flipped to IF_READY based on addrconf_ifdown and idev checks seeming
>> more appropriate.
>>
> 

Note that IF_READY is set in ipv6_add_dev() if all these conditions are true :

if (netif_running(dev) && addrconf_link_ready(dev))
     ndev->if_flags |= IF_READY;

So maybe in my setup IF_READY is set later from a notifier event ?

