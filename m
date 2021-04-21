Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 461173672C3
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:45:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245257AbhDUSqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233038AbhDUSqK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:46:10 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A62F4C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 11:45:36 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w10so30772322pgh.5
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 11:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RoMLuLeE8ymmqG+V/4g0DWTteDWJRUcARgPas9OZ0kg=;
        b=V5G7GGKlybcA/Rz8mUFndDohmA8RqzycmnuuBQFLEmm0CIfXp7xjkIfNc80rP44V0I
         tw/xDzb19G5ldH4LlhS6DTmW7Qzk429Ho9cRuCdE0Ta22m5bEerhY27VUecLBocdTILk
         a16PbGkVNNbOActfyQC/N7gqLinQwss2Ah1qaBPTRm6PH7f7SQgnRiLk1xMgjGrxwlCl
         vCfg0RwCuODmQcjKv0oRkXLS47qG64bAgVUw598MNygYl2sUQaafEWrS4ExIjlDRihjh
         spmeBfjrUufumSUW3Wps1MT0IaQZY5T9ZGlkoE/GWYjAPVYsdvnBZYiEebDLdSqckspF
         +xiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RoMLuLeE8ymmqG+V/4g0DWTteDWJRUcARgPas9OZ0kg=;
        b=HokSSYuK8dc0zsrue5yZ7HhZN1QTxPV9FVaDPZxqwG48VCK8CYmrCOBcRcsNSle1QX
         f8j/TKdqFftA8djojzxnpOKsfn3Z8UC2wCNtoCHewnrd4w22/xXgMqDBOyuAMd2ogSGJ
         iZ5FUdPZnKqknOD0KQ+mEEYUM/WghZntghhF0yDL6h2Eqn58SosR7Ka97HaeErLQyk94
         VriydlWNlKEtcw5sFgMhAxqcyvelMPQ+4s2xkFNAuYJRSafcNcRpu4cS968n9mhK6Bmb
         IldpA9owYiLyNH8l2T/bt//Qvb2DoOC1YM4/1SbSirbAWLQcbJLjHfJ1VMpxZXs6y2jC
         fOiw==
X-Gm-Message-State: AOAM533ty18H639s4mbRIXYHKH4LzsD8N3LBytC/IxgBydHes1p/SKcf
        UT2LiZY3r5GpPCm/+t7CJqU=
X-Google-Smtp-Source: ABdhPJy93NAZ+dpar7pet9NTvxyxAlEc+eWvHqrgdbK9semzzcxCxtEnsxVWr7T+U7u/WAL4Gch3Iw==
X-Received: by 2002:a62:1b97:0:b029:24e:44e9:a8c1 with SMTP id b145-20020a621b970000b029024e44e9a8c1mr31842802pfb.19.1619030736169;
        Wed, 21 Apr 2021 11:45:36 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id mw12sm87837pjb.51.2021.04.21.11.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 11:45:35 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: fix error in br_multicast_add_port
 when CONFIG_NET_SWITCHDEV=n
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210421184420.1584100-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ea652b22-791f-06f9-0281-e89fb21ac90b@gmail.com>
Date:   Wed, 21 Apr 2021 11:45:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421184420.1584100-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2021 11:44 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> When CONFIG_NET_SWITCHDEV is disabled, the shim for switchdev_port_attr_set
> inside br_mc_disabled_update returns -EOPNOTSUPP. This is not caught,
> and propagated to the caller of br_multicast_add_port, preventing ports
> from joining the bridge.
> 
> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Fixes: ae1ea84b33da ("net: bridge: propagate error code and extack from br_mc_disabled_update")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

That was quick, thanks!
-- 
Florian
