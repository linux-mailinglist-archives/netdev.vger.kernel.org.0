Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A59E35A85A
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 23:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234701AbhDIV3k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 17:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234079AbhDIV3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 17:29:39 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259A2C061762
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 14:29:26 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id w23so8130671edx.7
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 14:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NbQ5OHJkQq3lcaaXlPsMo0yBnZzKrdANPlIvFKQVD7w=;
        b=Tjmqcs9+FudGnc8Gxs0HDi9jxakoIntJZLn/exZ39I+UP8L3PAbcaX1IYabMCqDimB
         g+E+ZMOeqWPeKsjz+d6rWmFdRBh7UrTIwOaeIdBoqLUFtRem8PBE6BQpnCgOFEKmhUbB
         LkQu2sTYkx9f5Bpazo9AjBGSY7qyTAlTeDiUfexUD1uSeAxZlhOHjxuSO0b/o3qM4IlG
         Mlly32AUJkD2XkqnEMkm1UaeukUMBaK2MRDwZ+ypaaTbAP2M2WoZecp5lrP2c46+sb7G
         B9CwyeuPUm0Jh55WuKB+PrbEL+XXEW8ntuLTevOg9bZD/EgmlEHJ4QVTuxt0h2A5y60G
         02Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NbQ5OHJkQq3lcaaXlPsMo0yBnZzKrdANPlIvFKQVD7w=;
        b=GPc4BwY7Abmo8Dh0muPn69qKTtY1ct4tobLdKadeTJUJKDskPDaAlvPUZrGlvlXgwP
         0Z15zUcaPosV5ok5Yl3sfCf2pQY20qxfJRzYHzF05PybpQ7bbipogEiZVikpCLIICR1s
         8uHNh+3S7dLMDtfFcF4Qytnw8/m/5s70iuTLSB7/vED3BoJO+eUcnfTY4aGjujbN4+uJ
         w9tUJpzcVM+EUKk7JfBACqqOHnH0X95XH+njP5bE+dzIwFGEHaBXah6KESzVtge85Xj6
         nPz8pxtThvchRSblGtAdWXCjPEUox+2dzGdcV/xJsWiBA5Jh0QPXJRmX1RAFZwX2mGfm
         b+JQ==
X-Gm-Message-State: AOAM5313SKUOdICqfZSXRYhvlmPYKsqxlGFTir3VMtYH9g8V3a1hgW2d
        DUormlTEbybC8vtynVRGh78=
X-Google-Smtp-Source: ABdhPJyhMZ0ktl8KuPv9dAuLttqNq4xk5Z7NCNsH6TeIB3DQNX5eGrIOVTyd7lbH5K/7A17nEjHCiw==
X-Received: by 2002:a05:6402:518:: with SMTP id m24mr16036554edv.170.1618003764964;
        Fri, 09 Apr 2021 14:29:24 -0700 (PDT)
Received: from [192.168.0.108] ([82.137.32.50])
        by smtp.gmail.com with ESMTPSA id f10sm1998383edd.29.2021.04.09.14.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 14:29:24 -0700 (PDT)
Subject: Re: [PATCH net-next] net: enetc: fix TX ring interrupt storm
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210409192759.3895104-1-olteanv@gmail.com>
From:   Claudiu Manoil <claudiu.manoil@gmail.com>
Message-ID: <734e7b08-9f2e-587f-1e47-35be6a191364@gmail.com>
Date:   Sat, 10 Apr 2021 00:29:23 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210409192759.3895104-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.04.2021 22:27, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The blamed commit introduced a bit in the TX software buffer descriptor
> structure for determining whether a BD is final or not; we rearm the TX
> interrupt vector for every frame (hence final BD) transmitted.
> 
> But there is a problem with the patch: it replaced a condition whose
> expression is a bool which was evaluated at the beginning of the "while"
> loop with a bool expression that is evaluated on the spot: tx_swbd->is_eof.
> 
> The problem with the latter expression is that the tx_swbd has already
> been incremented at that stage, so the tx_swbd->is_eof check is in fact
> with the _next_ software BD. Which is _not_ final.
> 
> The effect is that the CPU is in 100% load with ksoftirqd because it
> does not acknowledge the TX interrupt, so the handler keeps getting
> called again and again.
> 
> The fix is to restore the code structure, and keep the local bool is_eof
> variable, just to assign it the tx_swbd->is_eof value instead of
> !!tx_swbd->skb.
> 
> Fixes: d504498d2eb3 ("net: enetc: add a dedicated is_eof bit in the TX software BD")
> Reported-by: Alex Marginean <alexandru.marginean@nxp.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Claudiu Manoil <claudiu.manoil@nxp.com>
