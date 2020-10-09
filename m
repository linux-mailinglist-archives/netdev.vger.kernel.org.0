Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B48288DBE
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389616AbgJIQGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389144AbgJIQGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 12:06:32 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80208C0613D2;
        Fri,  9 Oct 2020 09:06:32 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dt13so13821469ejb.12;
        Fri, 09 Oct 2020 09:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mxO+I5LNxrcOwcYvX0IJyyJi/v9s48ckxPqo00HL+Xw=;
        b=XV+ZUq/hdjuq/ARetFqqjacQh/2BcONSA8rW35fw/sBgoXDcprcPgR6H8drf3Ey1Pb
         L+GksaUV5G7fhGeMBHTWbmOgZA5sI+gfr08BN2LCuIOvK0Vu1Gs/Z2AxWW+1OA9Pg0+h
         Q1ETKnshvjGqaUoBTGakzrxvMgWTxwYut+4KYvQlolNriey5VTfQAUwAX2Y6LAo309Js
         BN3WNNY5bYSedSO9dTY9IpWZJK3dAwBB/+dABgWpa0QDEG6owkzILh0unCZCRgjYn/lA
         RG2VnG/E+jnlD+FDd2JE30Ijeh3qIRRXHVnQuP2K4pfMfTmY89uzPfFo2k9/JRbMNtKU
         iZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mxO+I5LNxrcOwcYvX0IJyyJi/v9s48ckxPqo00HL+Xw=;
        b=qXhnZYS6+2Ixz27xAdNUlfZo7Y8l4GJ2AgpKSgwn8KU+anqndoRY2zwFA9HmFiXkhn
         8xkHTji28nYmqgsDnIQQulf65AR7iLIiw8sVS9WHcn2TvvBmOZLwGh+/bfmbsIk/LQMQ
         CZU9e7eCX8ruMUYYd2dbaCIiAEB9GTnFFPt9KjWL1D9Dt3oHLM7AQRViYgN6kg5KN6lf
         yxM3lyADGlnCwM8ywE+i3b9L6v4BGC0C9ehpeRoMWRUr2uRRyjo6OsY7fe2Fhk45PEFQ
         OjaJWIMmocRPuQq7skj37Pt6gQja4AJY1sZfJ0IuK8UBIbuShcEXJThu2mB7sNvvObV/
         SQtw==
X-Gm-Message-State: AOAM530W8ciyHTLg3xyAJmdmXrsclzRCXqWqBVw6rbyaVGBaINkfYZSQ
        LQXshyLpO8DibhfesyJqGpw=
X-Google-Smtp-Source: ABdhPJxnHXb6Br4QFjWPiyYOdwrFHi55f9ys4UhdL9yDCqWn2sQjviznQIoMH6qg+zFGiiJhaHuRNQ==
X-Received: by 2002:a17:906:f0d8:: with SMTP id dk24mr14840855ejb.492.1602259591162;
        Fri, 09 Oct 2020 09:06:31 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:e538:757:aee0:c25f? (p200300ea8f006a00e5380757aee0c25f.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:e538:757:aee0:c25f])
        by smtp.googlemail.com with ESMTPSA id v14sm867268edy.68.2020.10.09.09.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 09:06:30 -0700 (PDT)
Subject: Re: [PATCH] net: stmmac: Don't call _irqoff() with hardirqs enabled
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Keeping <john@metanate.com>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
References: <20201008162749.860521-1-john@metanate.com>
 <8036d473-68bd-7ee7-e2e9-677ff4060bd3@gmail.com>
 <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <725ba7ca-0818-074b-c380-15abaa5d037b@gmail.com>
Date:   Fri, 9 Oct 2020 18:06:25 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20201009085805.65f9877a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.10.2020 17:58, Jakub Kicinski wrote:
> On Fri, 9 Oct 2020 16:54:06 +0200 Heiner Kallweit wrote:
>> I'm thinking about a __napi_schedule version that disables hard irq's
>> conditionally, based on variable force_irqthreads, exported by the irq
>> subsystem. This would allow to behave correctly with threadirqs set,
>> whilst not loosing the _irqoff benefit with threadirqs unset.
>> Let me come up with a proposal.
> 
> I think you'd need to make napi_schedule_irqoff() behave like that,
> right?  Are there any uses of napi_schedule_irqoff() that are disabling
> irqs and not just running from an irq handler?
> 
Right, the best approach depends on the answer to the latter question.
I didn't check this yet, therefore I described the least intrusive approach.
