Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F00DCA2B
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502254AbfJRQBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:01:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37439 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502040AbfJRQBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:01:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id p1so3619178pgi.4;
        Fri, 18 Oct 2019 09:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gThyljWtDBKOhSiy6iEb52Z+/qQRS5Kp4hVB8LMGJq4=;
        b=A7/Tv/gOM+6HhintRWJJOEvZ/AdKsn7I2l/DAJ7OUeCkHrTr3E9HDo7LAZGy5a9vh7
         4WwtE1fCXfmc8BQ0axVIpFBHOC+31NPSn6fNdcXBuskW0pwH0z8qEHttIaNCsD9a/WT9
         CSWwteONKad90EyYOWLAZsMTcCSEs49m/y1SMk+tx74WXQrgJhCNZ3HfmXk/OtduEm5a
         qQ3itoPk54BDfX0j6mcM0EBih+R0ZJ3jfvuPOEs1X0w1p/oQbWS5sycEcXEEJZ0NVqCw
         KIW4YlYVRMoRzxXn6IQGQ6fKpjLslhSDGqrPTmsd2Npm9i4tTIfCLf1MpL79wCKrTDuf
         fISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gThyljWtDBKOhSiy6iEb52Z+/qQRS5Kp4hVB8LMGJq4=;
        b=NacGupnvayD8iKu6C+KuqOCkEt57A5ZFZbdQgOTv3NldD8bD0d7meF+PrXsltJqSlG
         UJU96Nla2/cNyAmj4kBeYywrGyT6wTwxsCjpCUmRU+qXwHITI/QDk0maBB2MxYv1hc1s
         2OX96Gr0hc0ZzhPxWcfyAz3mbBv959VW6TEeTOUU14zC+ABsX3Id60Pka/3bSZkB3+7/
         Fz0vav/QYBuw+YmUrdBeeo8XyOK7GBKfLaIRgcfM9+DTtizNLmJaJqAdUTL0QKyS/ZCn
         ipcm/pLlC+OsZjffZHX5yRhc4Kon9385vyyjhNeLhn6/FuITK4yqMDXT1Y0FQLrrkhhP
         S6cw==
X-Gm-Message-State: APjAAAV0oW4JYIpYX2xr59iAFIv5XNrCmS7o82PMYsokytd17zvZfssj
        QEXrSE30XKOOKKSLxccAtxE=
X-Google-Smtp-Source: APXvYqxdw4v17EuDhxFWcokH7nzzl0sqYrWyTpIrsUMe5Zs8hAQW6pbS2VQO0dMBPOdl7QCf5KPWZw==
X-Received: by 2002:a17:90a:e98d:: with SMTP id v13mr12063806pjy.64.1571414489913;
        Fri, 18 Oct 2019 09:01:29 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id x12sm6458744pfm.130.2019.10.18.09.01.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2019 09:01:28 -0700 (PDT)
Subject: Re: [PATCH] net: stmmac: Fix the problem of tso_xmit
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     yuqi jin <jinyuqi@huawei.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
References: <1571309950-43543-1-git-send-email-zhangshaokun@hisilicon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <0b6b3394-f9f0-2804-0665-fe914ad2cdea@gmail.com>
Date:   Fri, 18 Oct 2019 09:01:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571309950-43543-1-git-send-email-zhangshaokun@hisilicon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/17/19 3:59 AM, Shaokun Zhang wrote:
> From: yuqi jin <jinyuqi@huawei.com>
> 
> When the address width of DMA is greater than 32, the packet header occupies
> a BD descriptor. The starting address of the data should be added to the
> header length.
> 
> Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
> Cc: Alexandre Torgue <alexandre.torgue@st.com>
> Cc: Jose Abreu <joabreu@synopsys.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Signed-off-by: yuqi jin <jinyuqi@huawei.com>
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> ---

Please add a Fixes: tag,
thanks.

