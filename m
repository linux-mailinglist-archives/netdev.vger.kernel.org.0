Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCDD3B833
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 17:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391159AbfFJPVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 11:21:36 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:32955 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390288AbfFJPVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 11:21:36 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so9646908wru.0
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 08:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/V+F42zy5zDKXGy0YG+Ock4S+/7BVw/qPxdB1U2uGs=;
        b=RSLSKKk0Jh+zqrNJW4rQrIzFfUaR2OwteUKHFydDh+k1VWL0Gdjei10FjpMsTD6LQx
         K0D/wl1ro0m3nkYc3AFFzOyn5g5VBXMkQgaVP4RnrLgoFYX5q1W3nXnM+xDtca3Y+AXw
         7w06UdyA+BT1AON8gHw3iRKpXf6CamR2Q7hdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/V+F42zy5zDKXGy0YG+Ock4S+/7BVw/qPxdB1U2uGs=;
        b=rSrP5rREJpvyq4VgdaG8/KrrrXeq+pafNz4bcBuDtsLCITEAEnvWoQSl88V5ZX37Ip
         nDCde83PkxO6xN3cAsOSyLH7aeod2Erk8FqNf4gSM51abzWD1j3wSwmA9/2pAimrry8q
         DUAqnT48E67U9HQW7jcbZglexB8IZvan1aB657wSJnbHv+3zLDYpmKpejfd/24P/GnSa
         ohtNgD98GGkiI4PQ4zlTWd3siG9F5/dTHo3ugb+vHQ7B1eDXn/2cKj5i8lpCNgx4hvQA
         EeOI+d7/Tc/AzmEQ24A6xr47Btzj7WBxwCLPlK04b8LPMWs9UxSbClOlEWe912cK574y
         O6RQ==
X-Gm-Message-State: APjAAAXKcKXzSEcJ/9Pu9jyGla7y+iaDmxXbMP35oN1BSGVEp51cd+B2
        Bmj9iTwk5/ojkWKtdHO0+E4YjBqEBKc=
X-Google-Smtp-Source: APXvYqypApQbwGQXshxFKWF08IJiSXphABA2kZ7DNpaLAT6oBbWhwNaoYuCj33hmoJeLOHxMx8K1/Q==
X-Received: by 2002:adf:ee4a:: with SMTP id w10mr34236928wro.311.1560180094079;
        Mon, 10 Jun 2019 08:21:34 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 66sm5461960wma.11.2019.06.10.08.21.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 08:21:33 -0700 (PDT)
Subject: Re: [PATCH net-next] bridge: Set the pvid for untaged packet before
 prerouting
To:     wenxu@ucloud.cn, roopa@cumulusnetworks.com
Cc:     bridge@lists.linux-foundation.org, netdev@vger.kernel.org
References: <1560159846-29933-1-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <55b99afa-7ce5-f9e3-89fb-6f3d17985519@cumulusnetworks.com>
Date:   Mon, 10 Jun 2019 18:21:32 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1560159846-29933-1-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/06/2019 12:44, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> bridge vlan add dev veth1 vid 200 pvid untagged
> bridge vlan add dev veth2 vid 200 pvid untagged
> 
> nft add table bridge firewall
> nft add chain bridge firewall zones { type filter hook prerouting priority - 300 \; }
> nft add rule bridge firewall zones counter ct zone set vlan id map { 100 : 1, 200 : 2 }
> 
> As above set the bridge port with pvid, the received packet don't contain
> the vlan tag which means the packet should belong to vlan 200 through pvid.
> User can do conntrack base base on vlan id and map the vlan id to zone id
> in the prerouting hook.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  net/bridge/br_input.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 

Nacked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

Hi,
I don't think this is a good idea for a few reasons:
- duplicating code (pvid insertion by __allowed_ingress)
- adding 2 new tests in the fast path (even 3 in the vlan filtering case)
- issue can be solved with current state by using different config

Why do you need the vid to be set when you can assume that all the traffic from
that port belongs to the pvid vlan ? In this case you can match the port ifindex
for example and associate the zones based on that. Another approach - you can
insert the vlan by tc's vlan action on ingress, you'll get the same effect.

Overall this looks like an issue solvable by different config instead of adding new tests
in the fast path and increasing the complexity of the bridge input code for little value.

Cheers,
 Nik


