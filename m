Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 410032C7B42
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 21:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbgK2U7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 15:59:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726293AbgK2U7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Nov 2020 15:59:38 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76FB4C0613D2;
        Sun, 29 Nov 2020 12:58:58 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id j23so9783693iog.6;
        Sun, 29 Nov 2020 12:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JSHVC83f9zQxL2ofrrqfIzwQKPtC6+odZmbyX4hFo0Q=;
        b=Aw2v6owuj3vvapFlLLv+r6JrXHf/uZvq6rsxgA25XH6VSNSj1BaIA9hg+9N1iWLUbm
         OqkJEc7OVpmNMAAT83FNmceMbsTrYCj/S674rq37GQFrqz+n9XWlwAeWaUmYkMt4LMo3
         0O+JBNVJFGnKvSsA6Myvux8hluxcCuCynKNO15dOyKWQA/TPY3LF3u+/8uA1ARqJ/nMP
         K9Yp4I51Nt2gUmUf24Tgh1DxNCn72cke81Be7TiI4ucDlyXvWUMP/EeY/sCbDEt12jLT
         Pqd1pklpVQCscPw1gXz2u6ziqU3W84pWkY1Cj6fZoLPE02oOjzNtU04mGNxuQSMcR5j6
         7Ykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JSHVC83f9zQxL2ofrrqfIzwQKPtC6+odZmbyX4hFo0Q=;
        b=pDpdmOo6CIM9Uc3llHHkQCtDFg8V76/0RlSwZyeTfMpw37wG+KQwD75yOpyqxX1qgf
         idY45i50lxh6DLMmgM9L5YOE5Q7qZsrjPhspwBU4GJsqtvn5UogBddAmPKDOFmmnbaKi
         4Eb+fAUiMa7hA0FtSvWsi7dHbjVKMMyxDKLzBh9dXcdPz3dAbTGbXW6Wj7acJnyjRyfz
         3atiZIJyJNohhBlNf8gel9rsWzMbVXKChXnOPTQHonWZpWs9G3Jf3v2Ca7esFwGw0QI3
         JUGZDoRptBREBHLo+NGRW4mp9qUAlvQ6LZ+QQMS7qlpTL+RNePiIPzIGKLZ8RXuLiwUW
         zD+g==
X-Gm-Message-State: AOAM530Kd9zZqcnb+WlGm/I30ulQmp5DTQ0LBWgVm5AewxQheGOt7YBE
        GZWfArQddGiZxhVb1sTWU5Y=
X-Google-Smtp-Source: ABdhPJxyXAEYjokf9NPONgKHW9p9mIJEGrj0AzUfPYIZmDE/YiXq1KnzKtX6gpvnAVTZBiQK8MfIZA==
X-Received: by 2002:a5d:939a:: with SMTP id c26mr334702iol.63.1606683537789;
        Sun, 29 Nov 2020 12:58:57 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:4896:3e20:e1a7:6425])
        by smtp.googlemail.com with ESMTPSA id x23sm7276273ioh.28.2020.11.29.12.58.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Nov 2020 12:58:57 -0800 (PST)
Subject: Re: [PATCH v3 iproute2] bridge: add support for L2 multicast groups
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, jiri@resnulli.us,
        idosch@idosch.org
References: <20201125143639.3587854-1-vladimir.oltean@nxp.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5b4172c8-33a2-49d8-fd9f-17174242a384@gmail.com>
Date:   Sun, 29 Nov 2020 13:58:56 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125143639.3587854-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/25/20 7:36 AM, Vladimir Oltean wrote:
> Extend the 'bridge mdb' command for the following syntax:
> bridge mdb add dev br0 port swp0 grp 01:02:03:04:05:06 permanent
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v3:
> - Using rt_addr_n2a_r instead of inet_ntop/ll_addr_n2a directly.
> - Updated the bridge manpage.
> 
> Changes in v2:
> - Removed the const void casts.
> - Removed MDB_FLAGS_L2 from the UAPI to be in sync with the latest
>   kernel patch:
>   https://patchwork.ozlabs.org/project/netdev/patch/20201028233831.610076-1-vladimir.oltean@nxp.com/
> 
>  bridge/mdb.c                   | 54 ++++++++++++++++++++++++++--------
>  include/uapi/linux/if_bridge.h |  1 +
>  man/man8/bridge.8              |  8 ++---
>  3 files changed, 46 insertions(+), 17 deletions(-)
> 

applied to iproute2-next

