Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8210A6C5
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 23:45:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfKZWpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 17:45:52 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35359 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfKZWpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 17:45:51 -0500
Received: by mail-pf1-f193.google.com with SMTP id q13so9927812pff.2
        for <netdev@vger.kernel.org>; Tue, 26 Nov 2019 14:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8jaUJ3QPq2etRgsBTSSmK9sLKNX1h3/6MEV4KFedamM=;
        b=tLhjrcQR1SAGhQANDRlxSMKHV8hp4VKYkYMFpiFX5fyabKK7td+saONske+VmYIceS
         oGZgDbbMaC7bfZwkg14sjTqKbEsGX1wBYDc10LFx1z5s/vzkZUPgfz8XIJLCNXZV/2NH
         FuopdqR4PYhTpaNAb49Fe2j6ClQ3KdynGP14aHJl/jkH58bxpQYyuulMM+7ZUnpWzNdR
         hTfodnbbsmGR3xYjbT9a//kJw4PWYHoKrwal2bc/YgwfT2WgffBaEud0LuIBDbXjjBnp
         rJtnWDaMXKJmwWQ6okqybcNuONDstODBfsyhtA3GgNwZkRnweypP6Vu4eNccaA1UleaG
         wafA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8jaUJ3QPq2etRgsBTSSmK9sLKNX1h3/6MEV4KFedamM=;
        b=WbC4gwU16dTDzzmbqSBh3pUIpmiNe41n/mYBrCYAifm03pgabFVeP/hVdjdxS8RAZX
         82bvlGbBB3QTsKfdYR8ghIE4/P5UtPl+15rsV9Z4HknIt/HkC8whoO8kY+0B3DWXdKIM
         PVihZqnCu0Vrr3jGrzV2PAT+XnVNs3t3Xvl+ttfxMZpqIa6BbCtxQG2gvtBtcTqOqPH9
         4u2QsATtK4qDVPBWZ3JDETzSQrCdDx9Q2C9IXa1IRFD2lHxkwAAJ51svBO9SWb2PqxpM
         dWDICqffRH7sohGz+FCOfrNmnZM7/mOA+WtzmMvEBYNygQ9AvNoqj4L0w8dmPnRzSyyz
         qKkw==
X-Gm-Message-State: APjAAAVuxtDkQPe9p9go+TFuBgLy06bNRWc3oQ5LCO+cJwkFO3t2UXqb
        YNhph/zYyuLTyaDKr7ulX8aK1jMY
X-Google-Smtp-Source: APXvYqy6NIbJ65BW+f9qA8KAF05pQwnrrBe5GwzsRt7w5WV2quZ1ZAtVPDnNyAkN6ei5rhRu6drlOA==
X-Received: by 2002:a63:354e:: with SMTP id c75mr1007420pga.325.1574808350709;
        Tue, 26 Nov 2019 14:45:50 -0800 (PST)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id k17sm13230326pgb.64.2019.11.26.14.45.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 14:45:49 -0800 (PST)
Subject: Re: [PATCH v2] net: ip/tnl: Set iph->id only when don't fragment is
 not set
To:     Oliver Herms <oliver.peter.herms@gmail.com>,
        David Miller <davem@davemloft.net>
Cc:     yoshfuji@linux-ipv6.org, kuznet@ms2.inr.ac.ru,
        netdev@vger.kernel.org
References: <20191124132418.GA13864@fuckup>
 <20191125.144139.1331751213975518867.davem@davemloft.net>
 <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <10e81a17-6b38-3cfa-8bd2-04ff43a30541@gmail.com>
Date:   Tue, 26 Nov 2019 14:45:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4e964168-2c83-24bb-8e44-f5f47555e589@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/26/19 11:10 AM, Oliver Herms wrote:
> 
> What do you think about making this configurable via sysctl and make the current
> behavior the default? I would also like to make this configurable for other 
> payload types like TCP and UDP. IMHO there the ID is unnecessary, too, when DF is set.
>

Certainly not.

I advise you to look at GRO layer (at various stages, depending on linux version)

You can not 'optimize [1]' the sender and break receivers ( including old ones )

[1] Look at ip_select_ident_segs() : the per-socket id generator makes
ID generation quite low cost, there is no real issue here.

