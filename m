Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED842A355A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 21:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbgKBUqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 15:46:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgKBUpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 15:45:21 -0500
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD7CC0617A6
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 12:45:21 -0800 (PST)
Received: by mail-pl1-x642.google.com with SMTP id 1so7446195ple.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 12:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9USa59Sl1sSDbogb/g/I6VRPX0+3kmuw5B4Mat2Kz5g=;
        b=tKtdfJ3SYIUhyh8j3JUHHm28ortf2mgPdhwpMQ1eiUOWG9LQOrrTfQhPnu5oVWhKop
         JE8w5VPt1P6sw777I9pb2BROeGMWWbyYfAfUAPbxm1KPEKrFHK93oQ8J3Hc6YUplgNb0
         zVNOvLfex1LLE00uyZqTDi8h8qlW7wxfZMI3LNdFxPNc3xFwRBds0Rb54UyxFB+TUgQZ
         ZMI529fVneDhVkFdA1hJZXxSQLjhapdqbdYRx8xdj3pgUgIAJVbHKNw2t4bDg56K7KVR
         488qwjXwQYZjqufo6Flrjjdy8oM7qw4YIueSslOCd8F04j29CTpYR3yfjVeS3cC10HkW
         UR3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9USa59Sl1sSDbogb/g/I6VRPX0+3kmuw5B4Mat2Kz5g=;
        b=sSe92JKbQKI4IAybk68sw57DmeHsqF3V7wTXUtVfwmiCDqU5P2Vkhb+chGuePxBI5a
         JJZ0vVeHKga8oRuTwDer+U+Cj3J8yDOIi4V2diqhMAXlOwq4Xu11w9BDT2RUEbDkX4Hm
         8URJORQ1XgbTOgo4gBdNvGvoKYm0ikYckV7FfbA8XuPocd7Mdub7oNt6HptmGW9X3fFQ
         UaTRyrwD945ZhyxF02V4y50znW8s46uNTkTt/pEfpUW+bh+F1xUp4f3zYiLUi1ExYd7e
         480+eSsCIn+TYKXxdWwET4NOAf8zrWfTVENbZdC/NhiU1aChqSJzcEGwB3Lvwu3xIn5O
         QdHA==
X-Gm-Message-State: AOAM530xh7iVZiCgvm9VeIKq8YIyl/yYP+fbE3isyXdnpNGBOZIaoZ7J
        3oOZ6nHCN6E4MciulWXE8Vk=
X-Google-Smtp-Source: ABdhPJwoHkXU5N7zbgPPM3kWAn3XsYYXC+migFQWi9upFy86a3KLlCThVuUJlrx9zPeLp1GS5u+eGQ==
X-Received: by 2002:a17:902:23:b029:d5:b88a:c782 with SMTP id 32-20020a1709020023b02900d5b88ac782mr22316806pla.5.1604349921397;
        Mon, 02 Nov 2020 12:45:21 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w66sm5512734pfb.48.2020.11.02.12.45.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2020 12:45:20 -0800 (PST)
Subject: Re: [PATCH v3 net-next 05/12] net: dsa: tag_ocelot: let DSA core deal
 with TX reallocation
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, kuba@kernel.org,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20201101191620.589272-1-vladimir.oltean@nxp.com>
 <20201101191620.589272-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11b05a66-f68b-e17e-306f-250498721d54@gmail.com>
Date:   Mon, 2 Nov 2020 12:45:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201101191620.589272-6-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/1/2020 11:16 AM, Vladimir Oltean wrote:
> Now that we have a central TX reallocation procedure that accounts for
> the tagger's needed headroom in a generic way, we can remove the
> skb_cow_head call.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
