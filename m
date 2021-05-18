Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375DE386F63
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 03:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240367AbhERBkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 21:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236042AbhERBkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 21:40:41 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856B9C061573
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:39:23 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id h9so8306527oih.4
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 18:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4MKGPjzhh9zaxGSK0rlP+VqlLixVODJCCCcsmSLpnro=;
        b=ojsjR7cTZ7FW9l9wBgRfKXaYncd6R2UhgbrHpTq9/eoKlJb8aX2yEDV58p/4DRKnUd
         tW5AyJI3FjO/t7mBzaE8dqDrG4g2jr4qRyVukI7vO07i0n4yAwdzwbZvKAKsx8YxOPzQ
         dtzIHwz5n8KO7K8dU4tdHMjyjPMcXxMRaC5+5bKIbCndrmo2vgcieTQGjLigTytbL5YW
         OJAx7zL1kG8i/ocp8qzL83kUo+dnBJjeF+AXHH0c8M1F7IvqukZ5IH57K0AnMkjIt6OA
         /Q9hRZ8mpNAu8VkeqjosVsWvra/fP7d+vhe8sQ+SrKDaLEXGUThdf9sxAy4+o3WERN3w
         7tnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4MKGPjzhh9zaxGSK0rlP+VqlLixVODJCCCcsmSLpnro=;
        b=DbiQWfsUENXVVg9GkOD/xysUBN0K049ndPb/3yVgm3s68QWN2e5S/yt9hkcY8QEK1i
         +HCzPBfRBX6FpmNDGGngejeL8C0aYZZIQq2313Qd9a9lDKpSQKPu2+cY4dnkcCfFPVy+
         BT9DD9gZZMXZmR0os/7MLfO7N99UCrRaam2T+aetIu5CFS/zmRmWbZ1I0sblWRgQaMVZ
         83UHkBi7VoCJhJupl2gN9ml2OF/D7IzHNxV8EQny7ff+WIdIHvpr5e5jR59cUG0yAYX4
         CAMlfwXNXYDZZ9AaHflPnECDja+JSq/45KXu0Gh6B4TE5RLNnXnQX09ILKOA1h0PZftP
         hQig==
X-Gm-Message-State: AOAM5304AHc8QeTBi6+uec9j1wt4VL3hZe2YKF+fgmtEW0EJUiL5oFE2
        lQQ5aR943zlY3veihMDbJzhpCd1mQpzdlg==
X-Google-Smtp-Source: ABdhPJyHz70Ca23wRcRSw0qYip+QfsLExpPRln6+y+R5Cch5OcLu4Ud/M/8JjSrqySSRco6uZ25w/A==
X-Received: by 2002:aca:a8d6:: with SMTP id r205mr2022223oie.68.1621301963063;
        Mon, 17 May 2021 18:39:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id x141sm3110744oif.13.2021.05.17.18.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 May 2021 18:39:22 -0700 (PDT)
Subject: Re: [PATCH net-next 01/10] ipv4: Calculate multipath hash inside
 switch statement
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com
References: <20210517181526.193786-1-idosch@nvidia.com>
 <20210517181526.193786-2-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cdf38631-7caa-2291-fd2b-bb1e829a42f9@gmail.com>
Date:   Mon, 17 May 2021 19:39:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210517181526.193786-2-idosch@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/21 12:15 PM, Ido Schimmel wrote:
> A subsequent patch will add another multipath hash policy where the
> multipath hash is calculated directly by the policy specific code and
> not outside of the switch statement.
> 
> Prepare for this change by moving the multipath hash calculation inside
> the switch statement.
> 
> No functional changes intended.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv4/route.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

