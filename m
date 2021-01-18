Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69FE82FA6E4
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406669AbhARQ7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 11:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406678AbhARQ5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:57:43 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6016C061573;
        Mon, 18 Jan 2021 08:57:02 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id x23so18904317lji.7;
        Mon, 18 Jan 2021 08:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H5NJ8sH3NDo1F7wtN53lpRELsBXzlqXCn+zXsqDChz0=;
        b=Jd+W88OejS24ATJq7Livgnvx0qDCjxmj2lTuHA79fUnOZkN2b4Fhu5w6rnEZhwn+nF
         1O+no7Cow4Ce02xbyHiH3iMGU4R9hYxD0Wma39DR1WllZmDnfXbUl+LykPARnXrB/jui
         kMn7s0CuAGw3mhi244zluPKEmLD6WBHad+Gu9EhiAHKe52pOT7ST1EBPeZwGYhCK+d6p
         WYlO6M/J2A2TzFfHUts/4ILTvrgMm8977SMUmGnScxtkF44oSlPMQ2WwZip4LNC3mLKY
         5VQ/cFr3fQpZfTIbBDiECnmBbwFk/vgYPc0inIhSdcnpH/MwYANQ3N5q9D4M27F0sUbO
         3iQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H5NJ8sH3NDo1F7wtN53lpRELsBXzlqXCn+zXsqDChz0=;
        b=r2sQ9hpxvr55we8Bxgi7HTQXY/h1HBolfjoDsvXJYlUf7uU234UUR2nVPU/brKa4DH
         GJivpwO4egFMjxrT5ClDG+AQ5aZzfFLMJkoOVETTcCwUIyMj0nUgPObVdn6hEZauoPce
         Yn93gv/Gh/PhcynLY1J00TqgCKIvULKAPxUms/hYKdo9bNDZQPzZS2QpZhdUrQuXIFGJ
         yWR3FwoM/yGt5Liq1cZl3HbNvyv4qY1WzE4RexIlMKs7Fjxtuy6j7SYYaNCdNv6ZO1CC
         DGgSE/jNBO7eQguqUltcJ2PS0Hg+Cy/llZcD3I8cI542rjMIY0jK7qSLcbA5+P55GmNJ
         tFTQ==
X-Gm-Message-State: AOAM530jIq1xcXjutbylbBD7bIOZENoTbjBClyhrnpkmubK49Ppo57di
        /u7BeB5H8yr6WL6nQ5r/EjDeIuCFTnUrHg==
X-Google-Smtp-Source: ABdhPJxlrOJfNvDul0egf16AJAj1ENZeOu0xyW50cQdWGuEmkLN8FAtIPJV5lHRh9xRWSxVOmuRyUw==
X-Received: by 2002:a2e:b558:: with SMTP id a24mr225356ljn.328.1610989020982;
        Mon, 18 Jan 2021 08:57:00 -0800 (PST)
Received: from [192.168.1.101] ([178.176.77.149])
        by smtp.gmail.com with ESMTPSA id 206sm2010084lfd.180.2021.01.18.08.56.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 08:57:00 -0800 (PST)
Subject: Re: [PATCH] sh_eth: Fix power down vs. is_opened flag ordering
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210118150812.796791-1-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Message-ID: <64509c94-3742-19ce-a918-cc2cfe49b506@gmail.com>
Date:   Mon, 18 Jan 2021 19:56:58 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210118150812.796791-1-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/21 6:08 PM, Geert Uytterhoeven wrote:

> sh_eth_close() does a synchronous power down of the device before
> marking it closed.  Revert the order, to make sure the device is never
> marked opened while suspended.
> 
> While at it, use pm_runtime_put() instead of pm_runtime_put_sync(), as
> there is no reason to do a synchronous power down.
> 
> Fixes: 7fa2955ff70ce453 ("sh_eth: Fix sleeping function called from invalid context")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
