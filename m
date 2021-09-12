Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2DE407E94
	for <lists+netdev@lfdr.de>; Sun, 12 Sep 2021 18:25:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhILQ0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Sep 2021 12:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhILQ0L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Sep 2021 12:26:11 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E4CC061574
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:24:57 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id m21so7920402qkm.13
        for <netdev@vger.kernel.org>; Sun, 12 Sep 2021 09:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xlE9ov6Lv+V6dKaV0aYfwkZ5xi6lkFq8yfeIkbYqfoI=;
        b=KKsQcMQjicBf/vGmWJDIfZn5STj09WNHZr7wwSY+K0bl5Nq0km16+98OqoCuF4Baok
         wcNk9fqXnIJ0Y1qvrMMzSrcn1/1V4fmptLYiZh14voRet9AE9YHSOpa0lT/zCvBMfoPu
         ZQn8xnA6YCzWdHSE6x6FlGgg5I/xRFJK9c7rGG2tyEKbCmLuTY+wDugQ+gnRJw6KtN04
         otR0ROeWTskavUP+BGkCxYB1ii8dl5ctWDgTF2JbXy+zu8qLjKMFaMDwLSTIbNQ76/uC
         L9bhrddqwJPD7p4P40hjTJn502oam5apnMgTfmaSKgrhW//2C+84gzobOdt89Sdmr5Jv
         xzrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xlE9ov6Lv+V6dKaV0aYfwkZ5xi6lkFq8yfeIkbYqfoI=;
        b=hiLOTZ+v/BX/0Ua5gGF0SqVLXy5bC7tnwxKychHS0y3rrYFK/9hNm0CEI++rFjcXNT
         FpUQ5RoS2YWC5/CZ59tTtq5ppOedWdc02WoM7H8j6fTp002qEFsNMaWBq36aROgYMXzZ
         PakVBSo49zTLDJSpv0GIlBUGuRvj0g9fW/06l2183fLUVU0Oby9o/TyP9ESgFjyHkigV
         qRuBk3N3bihtHdOfh/FCXtIAg9q5YvIJa/IGoSg9wGJqLe1Z0lTnrWGtTZWaDjw81tCT
         BhddTe5vsCcVLgjhclafLN5KOMUpHSacTsjpalUXbLHFrnlXjCsSHKMmkwUaeoTol3O4
         XX0A==
X-Gm-Message-State: AOAM532t/mRAyGucQmme+RKZaQP59G6bJsM9zRur8OB76agQhOosXQSo
        4xylHxJ2tdDLI1GHkfMyKA0=
X-Google-Smtp-Source: ABdhPJxSctwyQ9lSBvPR9US99KTloatiIj8Veuj02zo7kRfBwbC3tDrJncLtl3ani+V0JvzvGCP8WA==
X-Received: by 2002:a05:620a:29c7:: with SMTP id s7mr6168862qkp.186.1631463896423;
        Sun, 12 Sep 2021 09:24:56 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:b198:60c0:9fe:66c9? ([2600:1700:dfe0:49f0:b198:60c0:9fe:66c9])
        by smtp.gmail.com with ESMTPSA id d129sm3449099qkf.136.2021.09.12.09.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Sep 2021 09:24:55 -0700 (PDT)
Message-ID: <6af5c67f-db27-061c-3a33-fbc4cede98d1@gmail.com>
Date:   Sun, 12 Sep 2021 09:24:53 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [RFC PATCH net] net: dsa: flush switchdev workqueue before
 tearing down CPU/DSA ports
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210912160015.1198083-1-vladimir.oltean@nxp.com>
 <5223b1d0-b55b-390c-b3d3-f6e6fa24d6d8@gmail.com>
 <20210912161913.sqfcmff77ldc3m5e@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210912161913.sqfcmff77ldc3m5e@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/12/2021 9:19 AM, Vladimir Oltean wrote:
> On Sun, Sep 12, 2021 at 09:13:36AM -0700, Florian Fainelli wrote:
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>>
>> Did you post this as a RFC for a particular reason, or just to give
>> reviewers some time?
> 
> Both.
> 
> In principle there's nothing wrong with what this patch does, only
> perhaps maybe something with what it doesn't do.
> 
> We keep saying that a network interface should be ready to pass traffic
> as soon as it's registered, but that "walk dst->ports linearly when
> calling dsa_port_setup" might not really live up to that promise.

That promise most definitively existed back when Lennert wrote this code 
and we had an array of ports and the switch drivers brought up their 
port in their ->setup() method, nowadays, not so sure anymore because of 
the .port_enable() as much as the list.

This is making me wonder whether the occasional messages I am seeing on 
system suspend from __dev_queue_xmit: Virtual device %s asks to queue 
packet! might have something to do with that and/or the inappropriate 
ordering between suspending the switch and the DSA master.

> 
> So while we do end up bringing all ports up at the end of
> dsa_tree_setup_switches, I think for consistency we should do the same
> thing there, i.e. bring the shared ports up first, then the user ports.
> That way, the user ports should really be prepared to pass traffic as
> soon as they get registered.
> 
> But I don't really know what kind of story to build around that to
> include it as part of this patch, other than consistency. For teardown,
> I think it is much more obvious to see an issue.
> 

-- 
Florian
