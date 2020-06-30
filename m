Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986DA20FBBF
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390804AbgF3SdF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbgF3SdE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:33:04 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93253C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:04 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so19757679wmh.4
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9TpFhYVvX+FPrJFyzChlHdNyBo6UlPonNTpKUjRdTLU=;
        b=csQUkraqrZdMY895EuPNzhaYL7Ka81nPoGMNtXpD7+7bJRKd6/FrZmUbhZ9ldfGLZ6
         Aekigj6O1K7C5wUs3xc11DiA4PraoXSU8i5p9A4CFADyT11qecfwA/ROWGZmliYYbBCD
         5H+Pjt5BHKVVVpNv/nqli6YSwkIn++h9+YkrXYtRIINeoyCMBI/T2jTA8uXqfSXw6WEq
         zVaR0uSJTwdg/dxBN/jkiurRthts4ttWB45L55PCmhTi572b7wCCUGtu9tZmZE6E1bLq
         m0iN2QmBG+Oh5OZaoPi2LozxcnnniEkO7kFL1OcmOTyuekrFiZ5VZoKUDuYq4CAQ+wgD
         Capw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9TpFhYVvX+FPrJFyzChlHdNyBo6UlPonNTpKUjRdTLU=;
        b=HlsoQ71UFrmKqklerye9siS0DpwAen91c9pjwGYQW4LLJgAjm03FvQ3mmGOExTvO52
         Av+Jy36kpV+KZH0IKf56gTuqxsbz8c3mJXT6UZW6F86rbIpHrbqzZmEnA4E0Lu99E2p5
         qq84gLj3L+nvtqUj6o6thtcYcmLThmZHfEsdoLgvDf/ZbWa9Gw4EDTDdycKPqs48ykNZ
         PSALrXhlMf25GxIajLkt18J1DpW4bgCkrr2fcK2twHjhmS+o7m+zLXw6yY9/l0uqe5sO
         3luA4Z1DFxDVOv0nM0ro1W75VAhSS/cmMSHwWWpnxy9cFP1PFXxSeMu5QbvjdcVARmIf
         my9Q==
X-Gm-Message-State: AOAM533t+LmxCRDBvQL7E4eOzQoTf3jUE2ZiAYp0kKjeOt5vR+SGQ7cZ
        RIZ92VgVR10L6RXsbJq2Zonf/xhE
X-Google-Smtp-Source: ABdhPJzivrA0Ie+x4pi2/c3qaMSxo4jWk06116w3hlf/Ua4WZioFWlp74I44XED6383vHuiDqFIaAA==
X-Received: by 2002:a05:600c:249:: with SMTP id 9mr18201241wmj.80.1593541983074;
        Tue, 30 Jun 2020 11:33:03 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d10sm4666380wrx.66.2020.06.30.11.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:33:02 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 04/13] net: phylink: ensure link is down when
 changing interface
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFj-0006Og-5E@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a919aaf1-346a-8bdc-6db5-0cc8f088c7cd@gmail.com>
Date:   Tue, 30 Jun 2020 11:32:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFj-0006Og-5E@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:28 AM, Russell King wrote:
> The only PHYs that are used with phylink which change their interface
> are the BCM84881 and MV88X3310 family, both of which only change their
> interface modes on link-up events.  However, rather than relying upon
> this behaviour by the PHY, we should give a stronger guarantee when
> resolving that the link will be down whenever we change the interface
> mode.  This patch implements that stronger guarantee for resolve.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
