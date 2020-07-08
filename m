Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D67621918B
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726220AbgGHUcp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgGHUco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 16:32:44 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C12BC061A0B;
        Wed,  8 Jul 2020 13:32:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o2so4518907wmh.2;
        Wed, 08 Jul 2020 13:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BWHchiefPK+XOTzjJQ+4nudfM6T1kJ3R4r+KV6BHsM0=;
        b=lcODy2Gu+QWAnBnAkIOmzziVbPMqUlV/u08v4JxX6n59setch3cdOg7Hq+L8IoooSh
         jXaGfkSnRN6t5NwIYkX5gUoz5mrxUsAVHP1nI7u+D4gP/+qvFtVqrFEOyI14nenT6NBt
         J+fFm6j1eC1x2TPqFEZSJ+6/G/hT48VopmGoQN+vvy/qLeeUGb93iZJ6rxDRfiRQDFjh
         8f+o8AHY4j2nja/A6o3xHl2SXUyN0YGTXP56b9l0cc9InbsIMRxb22a4K1h4iIs24V/V
         yLK/QNE0U1lGO6mdD5Dr3642DwlnZ3dAdkFWJwg53Hd3Kw3NnUL9DSanL+RajIvBnf3a
         QLGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BWHchiefPK+XOTzjJQ+4nudfM6T1kJ3R4r+KV6BHsM0=;
        b=VE3OnmbpU50CfDfxEgzUScRTEFvIivor+JwvUQfakTTOXDcOgppbuFKdXjcrjBiOR3
         8mDZAWJSRtHwgTKNN3D7UnbxfJ9jIJM063j1cjGZi8bbiH/TTkDtZnINSFlivQoOTiAO
         bn6fOrbdYU1ShVqupp5ThMsnNexUCS3OGZfM4xQsUgED+B/uz0BhmzowutHnD4q5vLhe
         V7lACPMciqoCBCNWKiCavw04KGDsWlLOZ08SsDLh9WcN9p1OkptLzUcbqdVAg0YeLEG1
         kAf/9LWRyFrK4z9vCEoG7BBNG4kFy4KtbUMsGMiuW8WCMETnpGIQhV7zIHLpolyffJqq
         8g2A==
X-Gm-Message-State: AOAM533hS4BcHT2l6zUHcqVLUwjA6N+7F1rzCSh+5m/U2c/clDhsS4LL
        Zzowphl+wlOz0NE1RrwACLbdiQGi
X-Google-Smtp-Source: ABdhPJxvTN6Wu8aBc/hXBxREqaAtUlzZSvk/MJVq7oOYj/XUSs/Kn0NZKzfin8g+fvkp4bQRtUmOiA==
X-Received: by 2002:a7b:cb92:: with SMTP id m18mr9057074wmi.94.1594240362948;
        Wed, 08 Jul 2020 13:32:42 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s10sm1428653wme.31.2020.07.08.13.32.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 13:32:41 -0700 (PDT)
Subject: Re: [PATCH][next] net: systemport: fix double shift of a vlan_tci by
 VLAN_PRIO_SHIFT
To:     Colin King <colin.king@canonical.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200708183723.1212652-1-colin.king@canonical.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3e581bfd-7447-881f-1e0b-9ab1ccd4496d@gmail.com>
Date:   Wed, 8 Jul 2020 13:32:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708183723.1212652-1-colin.king@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2020 11:37 AM, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Currently the u16 skb->vlan_tci is being right  shifted twice by
> VLAN_PRIO_SHIFT, once in the macro skb_vlan_tag_get_pri and explicitly
> by VLAN_PRIO_SHIFT afterwards. The combined shift amount is larger than
> the u16 so the end result is always zero.  Remove the second explicit
> shift as this is extraneous.
> 
> Fixes: 6e9fdb60d362 ("net: systemport: Add support for VLAN transmit acceleration")
> Addresses-Coverity: ("Operands don't affect result")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

The change was forward ported from a 4.9 kernel where the shift is not
done, I should have checked the helper usage, thanks!
-- 
Florian
