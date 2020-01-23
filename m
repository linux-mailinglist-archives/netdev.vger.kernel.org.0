Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 371FA1472FA
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgAWVKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:10:16 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:37992 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgAWVKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:10:16 -0500
Received: by mail-ed1-f66.google.com with SMTP id i16so4852243edr.5
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 13:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/tAMaiitw1PyxFIS0OriuIYG+lTM5de1QiU8nvpGZ4U=;
        b=S9nQS5M8GRxqDnKBmZCpo/gItUgfZy/2LR/PUWL3LW9ZHOl1HDQm9yQNydKZsdTly4
         H+O6N6OoL0hGioUxzz76ffE6NdEh+tpUSXyHYFYrOVRBTkC22Ump2rR2NUFp2LVsWmvs
         qtPaUH9edp7gfYpGKBmQwWcwSoBph6tZ9c3/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/tAMaiitw1PyxFIS0OriuIYG+lTM5de1QiU8nvpGZ4U=;
        b=LkBbJh0TC7Ge+Jxs+nF0Ic6VdJ1t3Oyf0OCa/IK7E1CUPfSqofgRhivoCkSrv55urt
         f1fx0xTmatI/SWVGnsrCgtr0DppBsyXb7erHKYzggvlKpth7T5ZSzPw42W3jDty5wMZe
         qFTl2IgXxNiAamB5DGbaudhMA67shY8U9ut+NdmHzwGsZ+eCVw3oSCu/ql7A0iOC0ktJ
         3WAtcRcxn14S2j0QncWfAq+1svvFjLybEGeWsXQHQBtDDWaEfvfRb4UQQIGbi7AWjw7o
         LGJ2S7mUYW0PmATkmtnjxKDCNhjSizJnGDljeluRLWwcPHtwzOb5eF2MwOZQuHqIYP1D
         OU1g==
X-Gm-Message-State: APjAAAU+0WA5GOtjiUhdFxZUjbFF2k06pItocah/Mww2Kf6sVtKWT2YN
        CEYat9TsRayrOMCie0bMhbpzsOJwoWE=
X-Google-Smtp-Source: APXvYqyRn+MqAW0Zit1T7cZUHvA6hnhflt11PNiiZTzXjiH6/IAJoUEvHTLi4VuR/7E4pBsKFaM9DQ==
X-Received: by 2002:a05:6402:b71:: with SMTP id cb17mr8893554edb.125.1579813814598;
        Thu, 23 Jan 2020 13:10:14 -0800 (PST)
Received: from [192.168.0.110] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id ay24sm47153edb.29.2020.01.23.13.10.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:10:14 -0800 (PST)
Subject: Re: [PATCH net-next 0/4] net: bridge: add per-vlan state option
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20200123132807.613-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <f67c2960-89ff-a6e6-14eb-27f6e4996a4a@cumulusnetworks.com>
Date:   Thu, 23 Jan 2020 23:10:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200123132807.613-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/23/20 3:28 PM, Nikolay Aleksandrov wrote:
> Hi,
> This set adds the first per-vlan option - state, which uses the new vlan
> infrastructure that was recently added. It gives us forwarding control on
> per-vlan basis. The first 3 patches prepare the vlan code to support option
> dumping and modification. We still compress vlan ranges which have equal
> options, each new option will have to add its own equality check to
> br_vlan_opts_eq(). The vlans are created in forwarding state by default to
> be backwards compatible and vlan state is considered only when the port
> state is forwarding (more info in patch 4).
> I'll send the selftest for the vlan state with the iproute2 patch-set.
> 
> Thanks,
>   Nik
> 
> Nikolay Aleksandrov (4):
>    net: bridge: check port state before br_allowed_egress
>    net: bridge: vlan: add basic option dumping support
>    net: bridge: vlan: add basic option setting support
>    net: bridge: vlan: add per-vlan state
> 
>   include/uapi/linux/if_bridge.h |   2 +
>   net/bridge/Makefile            |   2 +-
>   net/bridge/br_device.c         |   3 +-
>   net/bridge/br_forward.c        |   2 +-
>   net/bridge/br_input.c          |   7 +-
>   net/bridge/br_private.h        |  58 +++++++++++++-
>   net/bridge/br_vlan.c           |  99 ++++++++++++++++++-----
>   net/bridge/br_vlan_options.c   | 142 +++++++++++++++++++++++++++++++++
>   8 files changed, 287 insertions(+), 28 deletions(-)
>   create mode 100644 net/bridge/br_vlan_options.c
> 

Hm, actually I just noticed that we send port notifications even if only changing options
which should be avoided since now we have per-vlan notifications. We should be sending
only those when changing options without create/delete.
I'll make that change and send v2 after some tests tomorrow.

Cheers,
  Nik
