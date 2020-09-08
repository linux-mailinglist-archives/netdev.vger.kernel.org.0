Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 953FF261725
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgIHRZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731272AbgIHQRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:17:12 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AFB5C0617A1
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 05:12:20 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id b124so10761646pfg.13
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 05:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4cTTNM2LfB0ZKQtokAlGtAKTl5Gj9gXx4yYPrBUZ2LI=;
        b=FSjMfGshmgfnWWC3U1YIBx7DE7b7W/6phz3fnwef0gKYOPsk8l7rM9PaF1LdGQy6XF
         WmriscNv+tWq3wLFbD3vC0aszsLJds7gWEYwfq3AfjZz1C6EWnzGFboWt+UsVWUFseaj
         1sBDmcRmbvonzTJacW/pB9DmX3xU4DO3FX3ko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4cTTNM2LfB0ZKQtokAlGtAKTl5Gj9gXx4yYPrBUZ2LI=;
        b=KzcUUe2btOaf/ZGY8NHt0ksdFsMWhZEfTDKZIbZCyIL/O4jGtEqAouHMAHW74xi7JJ
         GBNIBd/7Td1PnkDJngp+qJw0mjCSLqgAFnvJ4yPE3d4w0EeoDdmAYYMmg7NzvKvQmJrr
         6YZaXHelIgtPGhtY0uG2GYkZu9bsLH19wVVzGvAuaYeZn0jaT9v4mtentrol2/QEOcUw
         98C/rsryZzIb51okdvWzHbjlYW+/rsU7TyAWvgy/gwPeJanK4vZkDQudH4xODvDEFxLO
         hTmji9kw8PM7EuoZSe6T/XcJM9Jrt36ckmZofdBc1+qp1WKF0pVWqInF+Dm7AJj5rvgX
         jIWg==
X-Gm-Message-State: AOAM531VpVGq3i/SrBgNz5bLAs5aTGeXW1BnHVDjZ1TfbH2Ot9USugia
        Kc3ZlUZ55+8++2Q6Pj37SkhinvCjmDlH7WVL
X-Google-Smtp-Source: ABdhPJzaP8k6OK/iQH1v2SvEVSnGPEtqyLPkJUIOp6ScETEYqxTNqDc4Tope5wDw9XDBQ7aoitAf2Q==
X-Received: by 2002:a17:902:d702:: with SMTP id w2mr24215594ply.53.1599567139350;
        Tue, 08 Sep 2020 05:12:19 -0700 (PDT)
Received: from [10.230.32.194] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id z9sm12049463pfk.118.2020.09.08.05.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 05:12:18 -0700 (PDT)
Subject: Re: [PATCH] brcmsmac: fix memory leak in wlc_phy_attach_lcnphy
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     Takafumi Kubota <takafumi@sslab.ics.keio.ac.jp>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list@cypress.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <bad4e33a-af2f-b44f-63e5-56386c312a91@broadcom.com>
 <20200908001324.8215-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
 <c13ee142-d69d-6d21-6373-acb56507c9ec@broadcom.com>
 <CAEYrHjmG-R4RHn=59AGK8E0jKDXE5sbxQj49VpBvDMvBuBGiig@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <2a11074f-e155-0af1-aa37-108c8cd120e7@broadcom.com>
Date:   Tue, 8 Sep 2020 14:12:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <CAEYrHjmG-R4RHn=59AGK8E0jKDXE5sbxQj49VpBvDMvBuBGiig@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/2020 2:02 PM, Keita Suzuki wrote:
> Thank you for your comment. I am relatively new to the Linux
> kernel community, so I am more than happy to receive comments.
> Please let me know if I'm violating any other rules.

Sure ;-)

Here a useful link that Kalle (wireless drivers maintainer) is always 
sharing in his email signature:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

Regards,
Arend
