Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C803E56A1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238856AbhHJJS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 05:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238845AbhHJJSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 05:18:54 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5643C0613D3
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:18:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id bo18so10118831pjb.0
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 02:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v8VU2uZmUqa+PMMSqcMTFc0424Szmbif+UVopKT3BZQ=;
        b=iEtRj/xFHAPUhC/E/+pn9Wq+tt+3B8idJG+odwK8VeDELuGsRIB8qNRclQBkRhA3Hz
         5fHZ2Jiv9KJoNVMfnLAULhL83J6AvHHQfDcF+HkOE20+CXXVdFIkybUtvPyosJXP4wxE
         y7D8EYeMVQEaNJr0llapyO55yujQf0XgGrZOTeaynwuq4jyJb/vBmlFVyBmgWWnZaZgc
         An0yy7sVtOiu+yNJ7vtxUfYSKxl0xSigR+02ZQQV6l2ZF4dWdcqgSKbZIDHjF8XoRYQa
         AI94ccAfFk/JxofLp0SB9Ty1bdZUxiEBdiiXRehAqFyuHH7SWikQBCUpUjiPmfhv4sOx
         G7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8VU2uZmUqa+PMMSqcMTFc0424Szmbif+UVopKT3BZQ=;
        b=cOns5YaIhxNZr1NMVvKLyfkA4lfHVugHO5Qlp+E62fXQ28dGlMR6xulk1ep1FivJ/l
         18BQCQkEHxWDCTuiMRt+juOwxCHnmYc1ZpvxmEa97sSZO5S50yxLjZ7vXqHbo3h/iogh
         9iM+2r9jdSp57FV7fzAYEMTAgWTb//rs5G/VHahBnMD6Ud6oAdRpBXFrhRbqQRP4DTS3
         OqF0+fI9qFdnXUm+igNoOXhBFq1z6A8IfMcqZqY7jJSzEPkQNNbby4Ci1MWbezdCoB1x
         X/mjpvn4VbeIWMOl0L60oBxcHCK4NrX6/VjGnnQYT6RGyy0pomXdN/kLmzLD27apDD7C
         sMzw==
X-Gm-Message-State: AOAM532F3ZrBFUwgO9ZycFxcaUJto0E1jjrRdIbGdt/GftvNcw9TxhwR
        HZJ0p3yU43gufB/yoy0p7AA=
X-Google-Smtp-Source: ABdhPJy7W7Y8yP6ts9Oygyaj5k37zXRQhUtmgcXkAxYIGu+MkuluAfpkUiRrri8ATFtutaSsG7P/RA==
X-Received: by 2002:a17:90b:f83:: with SMTP id ft3mr3908078pjb.173.1628587112411;
        Tue, 10 Aug 2021 02:18:32 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l185sm15638685pfd.62.2021.08.10.02.18.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:18:31 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/4] net: dsa: create a helper that strips
 EtherType DSA headers on RX
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        DENG Qingfang <dqfext@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>
References: <20210809115722.351383-1-vladimir.oltean@nxp.com>
 <20210809115722.351383-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <519797ac-9765-6fd3-020d-3918df1cbce8@gmail.com>
Date:   Tue, 10 Aug 2021 02:18:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210809115722.351383-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/9/2021 4:57 AM, Vladimir Oltean wrote:
> All header taggers open-code a memmove that is fairly not all that
> obvious, and we can hide the details behind a helper function, since the
> only thing specific to the driver is the length of the header tag.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
