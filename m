Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DFB36DCE2
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 18:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240552AbhD1QWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 12:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239890AbhD1QWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 12:22:48 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7328EC061573
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:22:03 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id h7so4569447plt.1
        for <netdev@vger.kernel.org>; Wed, 28 Apr 2021 09:22:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KzznKmVuHtGGRCO5hu+ZUwDMMVUV1hqn+D+/YZd4kWg=;
        b=nE6t2Cfa662tB7EO3f/orIdVi7HNMZkjmr6cnmQE8WiSeXMYvaxprUzfSJcTJ4nohJ
         HTX9SAg2GPiY2Aq8Q9bLzl4slK13+GCVJqOxk1AnvqN8ufXQiwnxhsO61R3jLPNOZHB3
         +zbJzjUPEwSw9LPryA7UVe6GuTOScLkBldEgsM6Ycy7LWsXb7fOLz4O73JiBle56KVci
         iG1PWuK7MVd+AkFruQVPG7eVahKNSOxq3pTKKbfP1Z1kuKtPRlaZqJl9yy4LuKDqfV5A
         cBS9iQu7pZrKSQgu0vTEjXGMbdQMwYkdmW+WK9O41fWqg/MVsTio6UFxRNJS+dhAZzR/
         0NaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KzznKmVuHtGGRCO5hu+ZUwDMMVUV1hqn+D+/YZd4kWg=;
        b=FDpqqetR6yHd+CQNsyPsjAcEA/gHM4oAKv/ZR+1KnJu4LoT3DBI5uAXc/so7meWV8D
         ejLrqHTwxh2OjcFIhAKa+uwe0yxKgYIEWFgZ8U4mNDF03TDPG94rt7eNe/0Ge5WFVV1j
         FSxBAntoZIhsoKm8RFuDs7zW4IUY9JaUyvPJ0EWmpW6sln/DT4QnxlnEG9NN7RSvL1hf
         YROhcC4PSCRsti4v410i04SiwMkuowaP7m0uA8jWIeiaNAMzocd3ORUIAeMJ1c9An2wk
         N72bBpue8UBFn+/SUb21m/73hZeXkoK+lr69WOmXnLcpq8IX4qSk+h3akk8wmpoXwZTx
         9o8A==
X-Gm-Message-State: AOAM5312P9LdrDGeFH0qng9TOP2srlKrV+5Zi7G6hdKYoYMIZ+EbU5Ri
        wYGaxMoF2FS+6ZB0KuF2qnU=
X-Google-Smtp-Source: ABdhPJxyaGdCYYXB8Png2aKpq9aoemvSxHVirKM2tndquNEP0ItaYg21d3SLajLQz/QigN7h2zHYfw==
X-Received: by 2002:a17:902:edc4:b029:eb:159f:32b7 with SMTP id q4-20020a170902edc4b02900eb159f32b7mr30591831plk.11.1619626922957;
        Wed, 28 Apr 2021 09:22:02 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 128sm171333pfy.194.2021.04.28.09.22.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Apr 2021 09:22:02 -0700 (PDT)
Subject: Re: [PATCH V3 net] net: stmmac: fix MAC WoL unwork if PHY doesn't
 support WoL
To:     Andrew Lunn <andrew@lunn.ch>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        Jisheng.Zhang@synaptics.com, netdev@vger.kernel.org,
        linux-imx@nxp.com
References: <20210428074107.2378-1-qiangqing.zhang@nxp.com>
 <YIlUdprPfqa5d2ez@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ab8152e4-c462-def4-c2e8-0ec2bec5d638@gmail.com>
Date:   Wed, 28 Apr 2021 09:22:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <YIlUdprPfqa5d2ez@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 5:26 AM, Andrew Lunn wrote:
>>  static int stmmac_set_wol(struct net_device *dev, struct ethtool_wolinfo *wol)
>>  {
>>  	struct stmmac_priv *priv = netdev_priv(dev);
>> -	u32 support = WAKE_MAGIC | WAKE_UCAST;
>> +	struct ethtool_wolinfo wol_phy = { .cmd = ETHTOOL_GWOL };
>> +	u32 support = WAKE_MAGIC | WAKE_UCAST | WAKE_MAGICSECURE | WAKE_BCAST;
> 
> Reverse christmass tree please.
> 
>>  
>> -	if (!device_can_wakeup(priv->device))
>> -		return -EOPNOTSUPP;
>> +	if (wol->wolopts & ~support)
>> +		return -EINVAL;
> 
> Maybe -EOPNOTSUPP would be better.
> 
>>  
>> -	if (!priv->plat->pmt) {
>> +	/* First check if can WoL from PHY */
>> +	phylink_ethtool_get_wol(priv->phylink, &wol_phy);
> 
> This could return an error. In which case, you probably should not
> trust wol_phy.
> 
>> +	if (wol->wolopts & wol_phy.supported) {
> 
> This returns true if the PHY supports one or more of the requested WoL
> sources.
> 
>>  		int ret = phylink_ethtool_set_wol(priv->phylink, wol);
> 
> and here you request the PHY to enable all the requested WoL
> sources. If it only supports a subset, it is likely to return
> -EOPNOTSUPP, or -EINVAL, and do nothing. So here you only want to
> enable those sources the PHY actually supports. And let the MAC
> implement the rest.

And when your resubmit, I do not believe that unwork is a word, you
could provide the following subject:

net: stmmac: Fix MAC WoL not working if PHY does not support WoL

or something like that.

Thanks!
-- 
Florian
