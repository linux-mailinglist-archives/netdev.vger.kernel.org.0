Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E6D1396BB
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 17:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgAMQsw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 11:48:52 -0500
Received: from mail-qt1-f179.google.com ([209.85.160.179]:34002 "EHLO
        mail-qt1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbgAMQsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 11:48:51 -0500
Received: by mail-qt1-f179.google.com with SMTP id 5so9677449qtz.1
        for <netdev@vger.kernel.org>; Mon, 13 Jan 2020 08:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zT1ACHXDAGcCFCbYH2+lWy63svaPFGdb0dXNcilJ+Zw=;
        b=mz4C4bYMI1gyoKNzGs6atsHIaghu4IPDrgqzaMF1WEyO6sUoN4fbfSe2Pz0/8BjCst
         FCpFAsGEq710ZHYiEbOruNEn/rkiBNoFa0itVetnxvWJ4KMLs743/hLsRd1dLBGMCQCM
         AapUB4wO1qMNKgBgeWsgXTUM1rJkXjSrsMi8lUACe2/ysHcSHkUT55er9qLaL7ASwKmH
         BBfzS6aVZPOrn9HX+LUk+vwOSQDbL+WYtpRLqFgSy1bHfePYzNwhe+gSGC00sY7a6pHd
         3W5IQqSZcdX8R3m1XL3tJTxdm0fy/pv8y6b7f42Mu+fH6x9fIeCLCkJDcc2hON/a2zXE
         SMMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zT1ACHXDAGcCFCbYH2+lWy63svaPFGdb0dXNcilJ+Zw=;
        b=refxYQnLrg2vHjvvtTevf5fexxAFjWucYEMUCxePMYPWWhHYdECCgiV10wY/BuXk7X
         I8h1lMX7f2DlQnhui5yODv4mK2M7V2YweyYqTTIVtpQTwFclgPz0b3IOOoWcLC+mx9Pf
         DGG9HogXpS/U9GyvqG/CiXvmJ+yfhhaLfpiCVs/9O9PBZu/WNMRfvu9+HNg1gAoswS6K
         rXRAgATUb+ock8mxRI4/frC0ALImrb3hWreype8EhhGSw/QhOIqka2yThI/M1DqXDwUY
         UguqWdBKlPMSnOnYb0ctfPxvar1DMXM96220kKtDNObpjE8fEim5VdEny+JBW6S5lz6l
         lpKQ==
X-Gm-Message-State: APjAAAXEf07vcDWTot8AgH+X59XZphIpxAypDHRJfnqzPTPJCRFEVO4u
        9Wd4sebMXAEu03ll1YqSpuYfkF/JPMM=
X-Google-Smtp-Source: APXvYqyEZytK5pwhwRpDY0Hl62q5n6qDD6bC6isixd4kNIeTe0hue7thkB1bsoxjD8F7JMjlLSZAwg==
X-Received: by 2002:aed:2ac5:: with SMTP id t63mr10726167qtd.315.1578934130537;
        Mon, 13 Jan 2020 08:48:50 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:ad53:3eb0:98a5:6359? ([2601:282:800:7a:ad53:3eb0:98a5:6359])
        by smtp.googlemail.com with ESMTPSA id h34sm6009320qtc.62.2020.01.13.08.48.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Jan 2020 08:48:49 -0800 (PST)
Subject: Re: VRF + ip xfrm, egress ESP packet looping when qdisc configured
To:     Ben Greear <greearb@candelatech.com>, Trev Larock <trev@larock.ca>
Cc:     netdev@vger.kernel.org
References: <CAHgT=KfpKenfzn3+uiVdF-B3mGv30Ngu70y6Zn+wH0GcGcDFYQ@mail.gmail.com>
 <ff36e5d0-0b01-9683-1698-474468067402@gmail.com>
 <CAHgT=KcQb4ngBmhU82cc+XbW_2RvYfi0OwH5ROstkw9DD8G3mA@mail.gmail.com>
 <5e8522fb-d383-c0ea-f013-8625f204c4ce@gmail.com>
 <CAHgT=KdW3hNy4pE+prSA1WyKNu0Ni8qg0SSbxWQ_Dx0RjcPLdA@mail.gmail.com>
 <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fe7ec5d0-73ed-aa8b-3246-39894252fec7@gmail.com>
Date:   Mon, 13 Jan 2020 09:48:48 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <9777beb0-0c9c-ef8b-22f0-81373b635e50@candelatech.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/7/20 3:59 PM, Ben Greear wrote:
> 
> As luck would have it, I am investigating problems that sound very similar
> today.

Trev's problem is looping due to the presence of the qdisc. The vrf
driver needs to detect that it has seen the packet and not redirect it
again.

> 
> In my case, I'm not using network name spaces.  For instance:

use of the namespaces is solely for a standalone (single node) test. It
has no bearing on the problem.

> 
> eth1 is the un-encrypted interface
> x_eth1 is the xfrm network device on top of eth1
> both belong to _vrf1
> 
> What I see is that packets coming in eth1 from the VPN are encrypted and
> received
> on x_eth1.
> 
> But, UDP frames that I am trying very hard to send on x_eth1
> (SO_BINDTODEVICE is called)
> are not actually sent from there but instead go out of eth1 un-encrypted.

have you added debugs to the udp code to check that device binding? What
about the fib_table_lookup tracepoint?
