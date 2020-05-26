Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FF71E3113
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:21:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404106AbgEZVVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403878AbgEZVVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:21:07 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27551C061A0F;
        Tue, 26 May 2020 14:21:07 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id t7so9220884plr.0;
        Tue, 26 May 2020 14:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9e7zRLMzNq/x1BGKUV0mn/K6dZ3az4Zy+mcQtoNMafA=;
        b=eoFBqH/AQ0E4X7yCnHQ8MoW/i1BTlnbEgIBz2Lknu9rV/O4HFs1oUmhbOOBQelNKhB
         YX0FfNkEssPzgbUEks/HlN5y8n7NZTPjcl8MLE/AnQLL8eSN7gs5Ffblrnjg+aq2VxOx
         ZQtU/ZEEHg5SAuoHS7uq4/+lu/UyDdsS1ytvVhBG/EwBuSZdlvArCQxzm/WqK8vTsDzp
         7/uwjK4zcDUKGp49kuBzqomZwtqivtsyNxEEM9En6BviTKB7Ebwy+qsw1AqBWPT4Fhfk
         +NY8+j05rWF4x7pxWSNKCj+xsLIvpLIsvK9fADurUsRiypwbN/cPdlPXxaIWQWwxDm8o
         5isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9e7zRLMzNq/x1BGKUV0mn/K6dZ3az4Zy+mcQtoNMafA=;
        b=qr23mrTh+Jz6eDUkX11Z16fsOFux6gojJWNGPVwJktX3mn4Qu/wv9aBihT0pE1ItHD
         y6XmfsHZnVKk3K+iNT9gmq5w1dntxqpfPOdyGBU5wdsGeFTGBVL/7vRhcVANvTD6im8C
         GLdXjW6hEUbU5hH1TDT0Kt6IIfAd3n2l6GC54hABpoRd5iwx/zmdBDfwab4uTI/rU1jv
         o0j7hkVluaKQuVoFC9nNN/A3e13juNZm24SoZm+rmGiivI0VA0WZDstQK72QsvXLwqSq
         jPNFQ4d30SkbW+vnXxtsz+A/5j8IddG1chZdinagwyKFgNmO4jHUshqiMvZSQ6TQ3xLv
         c2SQ==
X-Gm-Message-State: AOAM530QG+8X3OF0DM6fS0P1AIlnI3yMsjPOGimi44hpWTpYGuFrLEZr
        i4F9bHYmodDhtMz3yVEBx84=
X-Google-Smtp-Source: ABdhPJwd+h4PK0wIiAwCv9BH8svKlMsdtBLPEELzbzMg2J7PSu7h37XqaJt6OQjEv88lmCVNxeijjA==
X-Received: by 2002:a17:90a:8a08:: with SMTP id w8mr1238375pjn.53.1590528066671;
        Tue, 26 May 2020 14:21:06 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id gt10sm362028pjb.30.2020.05.26.14.21.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:21:05 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: phy: mscc-miim: improve waiting logic
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-4-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e01f8f13-ca7f-0dd2-cace-2cb28f97522f@gmail.com>
Date:   Tue, 26 May 2020 14:21:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526162256.466885-4-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 9:22 AM, Antoine Tenart wrote:
> The MSCC MIIM MDIO driver uses a waiting logic to wait for the MDIO bus
> to be ready to accept next commands. It does so by polling the BUSY
> status bit which indicates the MDIO bus has completed all pending
> operations. This can take time, and the controller supports writing the
> next command as soon as there are no pending commands (which happens
> while the MDIO bus is busy completing its current command).
> 
> This patch implements this improved logic by adding an helper to poll
> the PENDING status bit, and by adjusting where we should wait for the
> bus to not be busy or to not be pending.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
