Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49172318449
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 05:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbhBKEUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 23:20:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbhBKEUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 23:20:01 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A73C061574;
        Wed, 10 Feb 2021 20:19:21 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id gb24so2643040pjb.4;
        Wed, 10 Feb 2021 20:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fXM+kDR6BMksJL+pl1kUFKSGzKtPwwl+jc1moEjdY04=;
        b=kRxTN6iGUtZeTLnxMAj6jnynBo6moA+GZjz+GGag4kj1YdOvKYcfzYBwCj+hTr5KHE
         EjtdOmI4LIEqPndFUKUtLqk29l5U9m//mfUu4lvGOTcch2/WqFYkY/OLztEbPKWcII5X
         IOek3ztKicfMd9S7oDpYVd/teDz+RgovyZrqrSm/HKzS9U7MawrVdMje4PZ8w0MG0oqM
         B2eU8T3XKBc6ubiwik6DAFlaf7ZW1RwmvoW2ei3HKWVb5JlaFKNNAzLeR0RF2Qyaup29
         DDKOae++8UqzX/lvAakgchIhYVfAN9qycnU5HjuaqNMhmw7RCBRESzO3GmncadjUVNqn
         T+yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fXM+kDR6BMksJL+pl1kUFKSGzKtPwwl+jc1moEjdY04=;
        b=qINrJi65qR/vAH1atjDfEoa2YC+ODTdHv6qHv3edbvv4Dlh4punIg7vwhxhWb7WzvN
         Q9CZbMOsIa0JVw0XkytT6wRgmzFIjT6+YuWo+dGPdcOtZawYpSh6u7g/WaLOQFyG/F3s
         Fc/Delo7Xf9e+fIGMRm4Ndf9YqaflX9MUkKWtvpcKzIKySJvh6mEyBUA8ll6qrRJNyjY
         x2NbsipEkOZs4lqlNEur3oOuoEeNAqrgORmHu0grhuOZslOMobCqBgswnQRQEwHx7k02
         vwsv5aIcgDZ5d2/iV+xsmxfIWlLzNHSfPaBBPyRA6Foj10cTRBxEDk3DNZwLlsw8emZY
         Cdgg==
X-Gm-Message-State: AOAM531LYZO6lQ+wxIhrilTE0vovNwu3SKeVJllonVimL49gjAB+kXEI
        ybvog9ZeSl80aymuPO//4L2wPrQjlV4=
X-Google-Smtp-Source: ABdhPJzGHOEcUhK7dZiP8TrzyMO3vJtARe+4TdMAe4r03TsiPJAZY+vfXyMaiZ7r41o1JA1a6bm+VA==
X-Received: by 2002:a17:902:bc4c:b029:e1:2c56:c743 with SMTP id t12-20020a170902bc4cb02900e12c56c743mr6073508plz.66.1613017160276;
        Wed, 10 Feb 2021 20:19:20 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 123sm3772560pge.88.2021.02.10.20.19.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Feb 2021 20:19:19 -0800 (PST)
Subject: Re: [PATCH v3 net-next 09/11] net: mscc: ocelot: use separate
 flooding PGID for broadcast
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
References: <20210210091445.741269-1-olteanv@gmail.com>
 <20210210091445.741269-10-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <62b8a59d-7856-ba7a-aac5-4b792a2a4a3b@gmail.com>
Date:   Wed, 10 Feb 2021 20:19:16 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210091445.741269-10-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/10/2021 1:14 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> In preparation of offloading the bridge port flags which have
> independent settings for unknown multicast and for broadcast, we should
> also start reserving one destination Port Group ID for the flooding of
> broadcast packets, to allow configuring it individually.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
