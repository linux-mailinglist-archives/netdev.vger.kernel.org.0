Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64E0513DCE1
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 15:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgAPODB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 09:03:01 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41380 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbgAPODB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 09:03:01 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so19266101wrw.8
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 06:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jSw+b3+50nNWul2LoTs98/UeBpWipub+s6jkbjBJlWc=;
        b=cPrG5B50XxbvakIJwDmyPCR9BAUnm32j6T+QXxylvlySAXya4qufnseuA9o86oRSLP
         DTKd50UnEGKX0jDj552Y0Zg1gIemFGz04xVQImwlccrDEhCQ8+jCB9eSlv8vkweQ5qgo
         g3ntdkL0ALRltQzlKP54aNxA2C2No5x7qxYm6DrY6LtrDDS9IOeIvr/dIU9jOzG4LKy0
         frg1rTSTFkpNDvgxH1Xh45lLIKWoUP2F9i8PevhzkgVrtvQ96sFrfgsDkTKtMvrvxkFI
         mQ0rz7tvn+qMQAbGnGnkkBHKlcYzTCH5ECc/VNOVQnqbUFf2dj9kJaZVB4/7mvMBmBiY
         xP1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=jSw+b3+50nNWul2LoTs98/UeBpWipub+s6jkbjBJlWc=;
        b=cjVKH+1OpYXwgSImc25li2AY1+VDos59QNYpwi3LLUL6Gj+/JxfJpqpMQj9UfAYGpJ
         jFNFa1sSAtc0SLts0gHCJCRBpyHslVMMP2nTnVDuYWdlvNsKvCsyhOJ5T9A6wjEEa0R8
         VWyk554u/jq0HjSqstTpUVjPEQFhryrTTSqmcIP+ifokmLklhQk0cl6dFkaH4EQAUd7M
         V/TqSx/t6ww3xJifmBSMpPPgU9VXRsME8JRdRPhAQkZ2MS3DG/hro1rxD1hV18LRPyOu
         Y4h9a4licv2IXTAT3uKafycy+B25rdv9pPKhO2k0sJeSOkc3Lpvq2dIiOImQ+8fyAu28
         0omg==
X-Gm-Message-State: APjAAAXbFcee+Im0j6yqVQAVSiVF/E45ACpEu7l+65bXcIZxEe7L+CTT
        FLS2ZWOhzmdjLhMHyXNqpTP2vzwCgDo=
X-Google-Smtp-Source: APXvYqx7QKWKvsztZTHAQKFqshfFKX1ChKCQgWL2DPMXo+Daa3THfKq97tX0IdIsv+yJN/Wxk2/tKw==
X-Received: by 2002:adf:f052:: with SMTP id t18mr3463684wro.192.1579183379819;
        Thu, 16 Jan 2020 06:02:59 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f? ([2a01:e0a:410:bb00:ed9f:e0c6:a41a:de2f])
        by smtp.gmail.com with ESMTPSA id t190sm2940340wmt.44.2020.01.16.06.02.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2020 06:02:59 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] net: ip6_gre: fix moving ip6gre between namespaces
To:     Niko Kortstrom <niko.kortstrom@nokia.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org
References: <20200116094327.11747-1-niko.kortstrom@nokia.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <8c5be34b-c201-108e-9701-e51fc31fa3de@6wind.com>
Date:   Thu, 16 Jan 2020 15:02:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200116094327.11747-1-niko.kortstrom@nokia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 16/01/2020 à 10:43, Niko Kortstrom a écrit :
> Support for moving IPv4 GRE tunnels between namespaces was added in
> commit b57708add314 ("gre: add x-netns support"). The respective change
> for IPv6 tunnels, commit 22f08069e8b4 ("ip6gre: add x-netns support")
> did not drop NETIF_F_NETNS_LOCAL flag so moving them from one netns to
> another is still denied in IPv6 case. Drop NETIF_F_NETNS_LOCAL flag from
> ip6gre tunnels to allow moving ip6gre tunnel endpoints between network
> namespaces.
> 
> Signed-off-by: Niko Kortstrom <niko.kortstrom@nokia.com>
LGTM.
Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Did you test real x-vrf cases with the three kinds of gre interfaces
(gre/collect_md, gretap and erspan)?
