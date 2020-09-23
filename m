Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E387276391
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIWWIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIWWIw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:08:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F31B2C0613CE;
        Wed, 23 Sep 2020 15:08:51 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn7so434713pjb.5;
        Wed, 23 Sep 2020 15:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=igkaoTq8Q4pa7MN7uFg0cs2HkDcYmRgjz4l9oYZBDqs=;
        b=Ycfx0OJkD9y3KYmBiOGGerxmHyGjzbBLYDo/IQJG6E75urk35q5zKDSugwsTAVkVSv
         P4o4JpQ0qXP1YXb1g4Y0TQfZNUFiZ1hckmk1rWSCRZOCh+hnNV1jz4Hob4YS4uhluMhg
         NIC6MXTbbZhrbgNlGJZ9kwmW5L22FRf/s3aHZoaS+11UbTTj7A8o0OjwG1xyM+gaa4es
         k2jHixUUxZLLf/DBB+vNCXp0/dcZQRiCLTNG64qpkcz68ybQdbt9SOoVm8z2dIMAvyor
         vM3/BybJf+yoOo7Kjx57tYrwPw88HTn38L1hdGr19WwqELBhcRHZ73x2BSnG2ua8V3Vh
         6u2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=igkaoTq8Q4pa7MN7uFg0cs2HkDcYmRgjz4l9oYZBDqs=;
        b=JT9hS9oTKKdBqWp+c/s2RC98i7367WZY3GIRJPGWQF9XLBFdinvnH7IxkL8junn0sO
         zY54XlCXlJ2VxCZLzZs4FREDgn6Ps6bD4By4eFOKFO+bkTIkL08yo6ukg9pWIVBvXED0
         MeWVdqrF9Qk4ierNtlF73fuH9Z3P71wVf0sd25b/vw4nblqRsOFs4DXWBoSaakRTQ740
         +sHtvy9rv2MoAdL2XsTEZD16XieY/TB3qC9ujPIiw+JrqJaNGz9jwxzCwgTzkKIElRze
         c2lS5LlQWlG+mJR8p/Q/AYWN3NZENZ5rOLz60sS4R5mGtNxJ5OlSL9McoZonMWxsMf9z
         TyZA==
X-Gm-Message-State: AOAM533kiH+lB0AT53EbxwMOtxm1Mg2hiYiFSs26Ui80MnFcpwh0yGGB
        avn3TIV51g+gpWuW0l2PQXYC3/6EIjPW4g==
X-Google-Smtp-Source: ABdhPJyCwWdNbAgsAd0WVo0cdnqD+ufPfxRAs9+Nyuyobq6jgJ6tI56bnLcMqMD3BnlAF+r5AWnj1A==
X-Received: by 2002:a17:902:6a89:b029:d1:f38b:3dbc with SMTP id n9-20020a1709026a89b02900d1f38b3dbcmr1690168plk.43.1600898931508;
        Wed, 23 Sep 2020 15:08:51 -0700 (PDT)
Received: from [10.67.49.188] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 134sm695624pgf.55.2020.09.23.15.08.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 15:08:50 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/2] net: dsa: untag the bridge pvid from rx
 skbs
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>
References: <20200923214038.3671566-1-f.fainelli@gmail.com>
 <20200923214038.3671566-2-f.fainelli@gmail.com>
 <20200923214852.x2z5gb6pzaphpfvv@skbuf>
 <7fce7ddd-14a3-8301-d927-1dd4b4431ffb@gmail.com>
 <20200923220121.phnctzovjkiw2qiz@skbuf>
 <c8ca2861-44b2-4333-d63e-638dfe2f06a0@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <2601834a-2cf2-f0f4-3775-2a5ebccad40a@gmail.com>
Date:   Wed, 23 Sep 2020 15:08:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <c8ca2861-44b2-4333-d63e-638dfe2f06a0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/23/20 3:06 PM, Florian Fainelli wrote:
> On 9/23/20 3:01 PM, Vladimir Oltean wrote:
>> On Wed, Sep 23, 2020 at 02:51:09PM -0700, Florian Fainelli wrote:
>>> Speaking of that part of the code, I was also wondering whether you
>>> wanted this to be netdev_for_each_upper_dev_rcu(br, upper_dev, iter) and
>>> catch a bridge device upper as opposed to a switch port upper? Either
>>> way is fine and there are possibly use cases for either.
>>
>> So, yeah, both use cases are valid, and I did in fact mean uppers of the
>> bridge, but now that you're raising the point, do we actually support
>> properly the use case with an 8021q upper of a bridged port? My
>> understanding is that this VLAN-tagged traffic should not be switched on
>> RX. So without some ACL rule on ingress that the driver must install, I
>> don't see how that can work properly.
> 
> Is not this a problem only if the DSA master does VLAN receive filtering
> though? In a bridge with vlan_filtering=0 the switch port is supposed to
> accept any VLAN tagged frames because it does not do ingress VLAN ID
> checking.
> 
> Prior to your patch, I would always install a br0.1 upper to pop the
> default_pvid and that would work fine because the underlying DSA master
> does not do VLAN filtering.

This is kind of a bad example, because the switch port has been added to
the default_pvid VLAN entry, but I believe the rest to be correct though.
-- 
Florian
