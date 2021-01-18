Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D5B2FA821
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406155AbhARR6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407359AbhARR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:58:32 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18889C061574
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:57:52 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id l23so10327915pjg.1
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 09:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r7+peNZrhVWheFEyFYLxx5OCfLMXMpbRdjOH6+BJSBY=;
        b=Yz7q8eKkiWJiP36b8ql7sTNXs8Y2wFSNMELs7YZlc7skth52Vkh3qn48Q6nIHHtBla
         pKtr+eDrWlPCzoBgIk/iQShqR/1wYDTg77zLWO9xx00TSszRB6wH+1p5r+fuaqXQ/nHf
         4r9W6xK2e5SpKbElh6ZTf3o2cs9WzlQLbvmXL1nweCllNYxgrFHv+ZHGMsXM0azo1kJV
         VGfQn2HUdmwik8Pspu0i+I/kTpOagVfs8VC9QyFLvMSgoSEoS4Zn4P4BevRsNdYG8bji
         e+2sgB21siGisCsc3Q8S+7VYTrni4xXX4IfXlHFUVmbzrlTb5s3OZjjWzXJgBi86B55M
         WW+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r7+peNZrhVWheFEyFYLxx5OCfLMXMpbRdjOH6+BJSBY=;
        b=AkOhzE0eFO2Tr3hYdeRzgUZ1/xbpkKXnWR9/mWz52wQaSIITWbKr9z4abV3XPwRZop
         sc6k+2vrkiiXdsX5LT6wMucvmU0MUACwHV63nF9IIIprHXCjsAoSL5HIM60MPQMSOPAg
         xCWvMoEAU2IdKqu5yoAhSR1nWOa7+kfp1TR+3+mhhrTx99FavcsjIuOd184ZuvxAE75Q
         OgNAFBcRZcQcwbRUdbOtvtbn2McqDAF0JJrcdQRzhPi+OXrcatVNSOru4gPTLwQ7Bb6e
         dB89XcBpgyYOhcCrux2I2zQsZoqOPSW6xFJnsP92qCjnev5SNKPgdd4HQiTcWL9H4lVI
         zpNg==
X-Gm-Message-State: AOAM530OecJqoF45PzBrmsZH2UW4lmwK+zcuvDoHGnRe7dGV6O9saYcz
        rI83AD1mDRHAadM9cVgx4FM=
X-Google-Smtp-Source: ABdhPJxp+ojzT5W92L29hJcoBKGqjnEwzsPI3UK9/ikjPnbZbgDSWHrjsH9QPFL1KIMfo/Wlf0u0HA==
X-Received: by 2002:a17:902:f686:b029:de:18c7:41f8 with SMTP id l6-20020a170902f686b02900de18c741f8mr585202plg.65.1610992671527;
        Mon, 18 Jan 2021 09:57:51 -0800 (PST)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id z23sm17581652pfj.143.2021.01.18.09.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:57:50 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/15] net: dsa: tag_8021q: add helpers to
 deduce whether a VLAN ID is RX or TX VLAN
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>, UNGLinuxDriver@microchip.com
References: <20210118161731.2837700-1-olteanv@gmail.com>
 <20210118161731.2837700-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a1c9862e-23cd-b3b0-14a7-1a225f32c99e@gmail.com>
Date:   Mon, 18 Jan 2021 09:57:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210118161731.2837700-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 8:17 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The sja1105 implementation can be blind about this, but the felix driver
> doesn't do exactly what it's being told, so it needs to know whether it
> is a TX or an RX VLAN, so it can install the appropriate type of TCAM
> rule.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
