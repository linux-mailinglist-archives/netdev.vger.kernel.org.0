Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59DF5278C52
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 17:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729138AbgIYPP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 11:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728858AbgIYPP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 11:15:27 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E3FC0613CE;
        Fri, 25 Sep 2020 08:15:26 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so3972749wrm.9;
        Fri, 25 Sep 2020 08:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JVxu4r2WfZ7y1LJf1lPXgUWmvqhhajFSJ/ifVaATdHo=;
        b=DdSHe4i1OVUn7d80PT6kX2GPcvaa0zGrPv9fqjlAXJQ45zybYqzYVBdnPI+V2eq7Yn
         gj1fsEJuUyC6HEXsj8DH6rjm5k8bUD+rZfS6jr1ki8d25N0Z41x8Cjf09/CnDT/bvgPq
         UOwl9+GnCLzuyHMkgPhpyJa2avgRJVheKfUqueeEvK8DX4jKCQ6saat6IznEOKSxfhwo
         OVuzDjhTlLqCluB5qNOTbW6XRiT8N7TGyfiLNavImH5upmbSQtRFwCztmAz2JtoDPBAa
         him6IHWzexRUyClABTEKywmEka62PNAWOqA63ebNwZelgVRoj3dGZrpd1KZLaXCbn8b0
         zCkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JVxu4r2WfZ7y1LJf1lPXgUWmvqhhajFSJ/ifVaATdHo=;
        b=t5uVDo3buMR0ge20H5xvmu06PDTBM85Y+X2McBcBNCctJ0sQs6z7YD6FWZ9ypTTXdy
         acJyz5N0IhoJE9kULOvIY6VGfjsOAqtEZ65VAVjMkAjkpIe9OiZWwLnru/9Q9GQif1RC
         C98oanxB/r0PEO3NCwDII7dGqv46qCeW7W1KqponfVza/uEzHshN/8y8tmB0TsHQudpJ
         gev4WFaboc8jfyqNj4FAVwELpjnBnelS2aGzYzxVPYFiE7BiM3+vHT/MtleUsXnPXBR/
         /74WSqtkOmtS07JAKGOXO1UA14+sU6jd/Jm8IjhXMozH0RVmDm7IlEYbzHrI1DHeaQsC
         b9lw==
X-Gm-Message-State: AOAM530fKHdNSUtTLmgutmu5MXheNtQck/b3ynSqv+sbur+ySjU4lTl0
        ys4hVgSUNNNlnWWP1+FGws+TKH+ay2Q=
X-Google-Smtp-Source: ABdhPJxpDkuiyFrjZGYvg4PEXQxV5HKOA8Mnu7I3KFbeTGgh2b8LDngftD3yoNpNKnMPjYnegx560g==
X-Received: by 2002:adf:eb04:: with SMTP id s4mr5412634wrn.81.1601046925503;
        Fri, 25 Sep 2020 08:15:25 -0700 (PDT)
Received: from [192.168.8.147] ([37.173.173.126])
        by smtp.gmail.com with ESMTPSA id h186sm3258995wmf.24.2020.09.25.08.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 08:15:24 -0700 (PDT)
Subject: Re: [PATCH bpf-next 2/6] bpf, net: rework cookie generator as per-cpu
 one
To:     Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, ast@kernel.org,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <cover.1600967205.git.daniel@iogearbox.net>
 <d4150caecdbef4205178753772e3bc301e908355.1600967205.git.daniel@iogearbox.net>
 <e854149f-f3a6-a736-9d33-08b2f60eb3a2@gmail.com>
 <dc5dd027-256d-598a-2f89-a45bb30208f8@iogearbox.net>
 <20200925080020.013165a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <c9fee768-4f35-e596-001b-2e2a0e4f48a1@gmail.com>
Date:   Fri, 25 Sep 2020 17:15:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200925080020.013165a0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/25/20 5:00 PM, Jakub Kicinski wrote:
                    unlikely((val & (COOKIE_LOCAL_BATCH - 1)) == 0)) {
> 
> Can we reasonably assume we won't have more than 4k CPUs and just
> statically divide this space by encoding CPU id in top bits?

This might give some food to side channel attacks, since this would
give an indication of cpu that allocated the id.

Also, I hear that some distros enabled 8K cpus.

