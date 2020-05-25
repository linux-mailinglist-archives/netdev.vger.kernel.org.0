Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B18941E08DC
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 10:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgEYIeW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 04:34:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbgEYIeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 04:34:22 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E62DC05BD43
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 01:34:21 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f5so7674844wmh.2
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 01:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xsaSOL3nxn5UWojYLGHf0GidZv1f0eBsy1Kan4mSPis=;
        b=WiBv6JwgwoGFabLxJtlkNV2QTT18NNEhPH3iMNUS8TNvE4V38+UFSMP4ahMe76Z26m
         3WZNnG0LPNH7VrsaC39jgTQrROurGyfDpKw9DM/HRotlOw/dSjLuFAmFmcccTchAX/FM
         JBqeHfDHPNhynj+Szb4t+GSyQIGsQ902ccVIA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xsaSOL3nxn5UWojYLGHf0GidZv1f0eBsy1Kan4mSPis=;
        b=Z8R07/E080vczh5yEdmyAG9jtVlzHMYfPNy7SF8LJ7ujGfMP1ceDZlhFAZEHWtvwgl
         29oGr+5qdryHUpHBWrIw1hGekElgNqNjbuir7CAdpyJlOcb3dvbVSbNhOI91lkieeetg
         s9RgPK2XfTDWag8Fxr1/Iqb4WxvRnOH9T6N9YHWIm2Ze5ng8s5DYo0NrXUnpJBQD2Q3g
         nbCVVoKeueiL9Ie1NZOoH9Y3783cf5zhWMGxuIYWVB4Hz95462gdQ11MD7EfFVyoNDpx
         eW1rgOoatEtuKW4rQ2IA+jgofB/3ubUQ+2kUiN862yZXWM/e4xtOX9D4EAiWFMYMRiZO
         LQ3Q==
X-Gm-Message-State: AOAM530ID4euFoZp6/Q49nL90Q2dgQ/VrIIcg134YQP8YlXbZjM6+OkM
        YYKgWmwyYLrvRXyCoORCmVyRhA==
X-Google-Smtp-Source: ABdhPJw2JzSdmK+zGATfwn4L+ZqcmuGdyIA8qCQDbzPpHHsPfwKHLuj/teLJ0K9DtYwDmAbqpesjOw==
X-Received: by 2002:a1c:808d:: with SMTP id b135mr1598301wmd.94.1590395660196;
        Mon, 25 May 2020 01:34:20 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id p4sm17583856wrq.31.2020.05.25.01.34.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 May 2020 01:34:19 -0700 (PDT)
Subject: Re: [PATCH] bridge: mrp: Fix out-of-bounds read in br_mrp_parse
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        roopa@cumulusnetworks.com, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com
References: <20200525095541.46673-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a44f412e-dbde-93e9-be72-78515fa5b9d4@cumulusnetworks.com>
Date:   Mon, 25 May 2020 11:34:17 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200525095541.46673-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/05/2020 12:55, Horatiu Vultur wrote:
> The issue was reported by syzbot. When the function br_mrp_parse was
> called with a valid net_bridge_port, the net_bridge was an invalid
> pointer. Therefore the check br->stp_enabled could pass/fail
> depending where it was pointing in memory.
> The fix consists of setting the net_bridge pointer if the port is a
> valid pointer.
> 
> Reported-by: syzbot+9c6f0f1f8e32223df9a4@syzkaller.appspotmail.com
> Fixes: 6536993371fa ("bridge: mrp: Integrate MRP into the bridge")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  net/bridge/br_mrp_netlink.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/net/bridge/br_mrp_netlink.c b/net/bridge/br_mrp_netlink.c
> index 397e7f710772a..4a08a99519b04 100644
> --- a/net/bridge/br_mrp_netlink.c
> +++ b/net/bridge/br_mrp_netlink.c
> @@ -27,6 +27,12 @@ int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
>  	struct nlattr *tb[IFLA_BRIDGE_MRP_MAX + 1];
>  	int err;
>  
> +	/* When this function is called for a port then the br pointer is
> +	 * invalid, therefor set the br to point correctly
> +	 */
> +	if (p)
> +		br = p->br;
> +
>  	if (br->stp_enabled != BR_NO_STP) {
>  		NL_SET_ERR_MSG_MOD(extack, "MRP can't be enabled if STP is already enabled");
>  		return -EINVAL;
> 

You should tag the fix for net-next when it's intended for it.

Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
