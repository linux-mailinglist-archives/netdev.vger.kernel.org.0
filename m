Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC27D1AD048
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 21:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729260AbgDPTWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 15:22:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727844AbgDPTW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 15:22:29 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B40EC061A0C;
        Thu, 16 Apr 2020 12:22:28 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id z6so1691365plk.10;
        Thu, 16 Apr 2020 12:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u735V9HHFXqgUnn+jYHUVF/KBe71XKmd0C1DJzJ/jm0=;
        b=W2ktpi/SDTw8TMDFSJZ/zDu6AgJz/o/lQDlgBHyxfpS6M0kdrnOV9HhMIsB33D4oxz
         WkkoBzxmVABXTyb1MNK33/9L0RGn71GLlgiOAn98NGKGoSliEfX2EsjDVyA8aS+HyAnq
         bsbUFICd3O/TtkeHgElSKP4rOjWd43cz6xGuAJELa0pGOUPg9WDyf2L+naAU3wqqNzfn
         fB87FeiUJFP776rRtewpUaPf/2Z9AGBAKP237bD5B1BPTg1owzPB8TNycnu9DGf+NcJV
         +qlFAgnYgcP/yLOYkSIZGmUIy3+h3i+CEzIsSkv8qgOxHbk1pCg64Uz/XITUG0DsBIrf
         LtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u735V9HHFXqgUnn+jYHUVF/KBe71XKmd0C1DJzJ/jm0=;
        b=NwgNkrurI5qUmzs3zf8bBVdnRpS3Ybmo6OLZyHcEENveEHSZQ820GiWWGtqtAG4klO
         9CAspL3JzFSy/rP4fDa5RGa8fcdeqBmUwTgDoHvmNvl3izQ6Jh63ID/crNyxvBtJz5Bw
         LWs9uVgQRbYp3AMnfh+87sejq1Rty3Z7Zy0NpJbKWF2y00RaUyZyxDPdzud0OHfrdfoS
         CQSg9+Awuovqqhc6RFsd+EbAFtZ1/UUq7DPhGlz/4cHoceCqbnzBS4aaiq17ZCXw2xBF
         OgqvFj3u5irPFNFCQoIKiTxIw0ZmBbvq5Wm4x16zq3oQ6Mut4jqJl1UscZZMJWjXHu8v
         HVRw==
X-Gm-Message-State: AGi0PuZDb3CKgkTUKPgKuWubsTlpxIzsJM5au6tfiJLd2KzP3ToGyQ5d
        IkNfgbc8bfdaeIgKVYdRz0E=
X-Google-Smtp-Source: APiQypJ8niiaX2gOmgAlrlT9yIzDtccBKMj5GL23IXsnka0sPYbvBAkpvNhvyp9Myo+aHy4zdMm0dQ==
X-Received: by 2002:a17:902:868d:: with SMTP id g13mr10853361plo.317.1587064947693;
        Thu, 16 Apr 2020 12:22:27 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o40sm3544636pjb.18.2020.04.16.12.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 12:22:26 -0700 (PDT)
Subject: Re: [PATCH 3/5] net: macb: fix macb_get/set_wol() when moving to
 phylink
To:     nicolas.ferre@microchip.com, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        harini.katakam@xilinx.com
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        pthombar@cadence.com, sergio.prado@e-labworks.com,
        antoine.tenart@bootlin.com, linux@armlinux.org.uk, andrew@lunn.ch,
        michal.simek@xilinx.com, Rafal Ozieblo <rafalo@cadence.com>
References: <cover.1587058078.git.nicolas.ferre@microchip.com>
 <897ab8f112d0b82f807e83c6f9e7425d1321fa09.1587058078.git.nicolas.ferre@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <8d51c4af-1e00-f33c-0f88-10afc837e46b@gmail.com>
Date:   Thu, 16 Apr 2020 12:22:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <897ab8f112d0b82f807e83c6f9e7425d1321fa09.1587058078.git.nicolas.ferre@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/16/2020 10:44 AM, nicolas.ferre@microchip.com wrote:
> From: Nicolas Ferre <nicolas.ferre@microchip.com>
> 
> Keep previous function goals and integrate phylink actions to them.
> 
> phylink_ethtool_get_wol() is not enough to figure out if Ethernet driver
> supports Wake-on-Lan.
> Initialization of "supported" and "wolopts" members is done in phylink
> function, no need to keep them in calling function.
> 
> phylink_ethtool_set_wol() return value is not enough to determine
> if WoL is enabled for the calling Ethernet driver. Call if first
> but don't rely on its return value as most of simple PHY drivers
> don't implement a set_wol() function.
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> Cc: Claudiu Beznea <claudiu.beznea@microchip.com>
> Cc: Harini Katakam <harini.katakam@xilinx.com>
> Cc: Rafal Ozieblo <rafalo@cadence.com>
> Cc: Antoine Tenart <antoine.tenart@bootlin.com>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
