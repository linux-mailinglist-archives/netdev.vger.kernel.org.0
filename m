Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65291CB230
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgEHOpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgEHOpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:45:44 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 315D1C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:45:44 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so461919pgv.8
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 07:45:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4clM0Q8O+7pmoB5zAA7eFAur4qm/vIg5dcMcMsB7r10=;
        b=sZPBr/Bi2H2qvt7pibK6pwJphoMFEdrgGYFQ4K9f556RIK3NU7OaEAB4Utm8bsmY/l
         vQD+QuejRUdeoFZpeiIG75lyXDiBytFGb40wAvVYUBnExyvzBAHXOPMPt1fZEj11KZ+s
         rs3+V0IBbYsyjwAiVLxDSLMzdxvSv61BCjB8xrqCDzPXUtI19aO5ETtWaeA1ON9x1q3l
         XUmL5afIwvJPFng4pmuRZgyujj6VbrYrFqeRSqqKucLR5vWd3Sx2nAZIvqSkcUCq2fE0
         igkeVt4lrVxmkc7DqoG6aIktD5fUzC5aeRzC+02p8mcqwbLavytHLRATErTIiJKaolPE
         tqlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4clM0Q8O+7pmoB5zAA7eFAur4qm/vIg5dcMcMsB7r10=;
        b=SjkYLs7uFCIZiDq62lg8oh4BwZJ1jf5QpbeSlB3WkeEJVLYA8T5BJ27CWAqQyvr0L3
         zuwOQIZtpvuOYpfdJPQ6IEEB8C60EgtWCpsQVHrL6fnuKrfhzLN2B9g7Tj/6sasxWyiE
         V7B+os5D0mH0/NnKPBqjd0O6LWc6aGFwGqXSk7UcN8H58K8d/OKhSNbrUBfHULvNbWgN
         HnvEaDOR9DY3EbDzTuFZo2BcWVgwk9zjeZYsF5aSXafz3TXT/jHMLyy9gDvKcu4EscPm
         lKLScH2yGhR08Uhy2S/Un4zdq9ZRUX8yGy+yLvcgLeGSUoPMzObr4Ji73eHE98oFXO6P
         zJIg==
X-Gm-Message-State: AGi0PuayGz0XSRB31oAuADpVmLlo6+0PxB5pyQiQpZ8bti4S9wKZFy1b
        yzp/MLCwBKmWSH3kyg2rkWQ=
X-Google-Smtp-Source: APiQypItumUqEzq9FCF3P9+fdRAbH4xbqRyVzdKUeD27wuAIMCVK4FQSlwJ/ze5wjydE24+AaIf5HA==
X-Received: by 2002:a62:38cc:: with SMTP id f195mr3153612pfa.85.1588949143757;
        Fri, 08 May 2020 07:45:43 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id c28sm1866341pfp.200.2020.05.08.07.45.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2020 07:45:42 -0700 (PDT)
Subject: Re: [PATCH v3] net: tcp: fix rx timestamp behavior for tcp_recvmsg
To:     Kelly Littlepage <kelly@onechronos.com>,
        willemdebruijn.kernel@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, iris@onechronos.com,
        kuba@kernel.org, kuznet@ms2.inr.ac.ru, maloney@google.com,
        netdev@vger.kernel.org, soheil@google.com, yoshfuji@linux-ipv6.org
References: <CA+FuTSfCfK049956d6HJ-jP5QX5rBcMCXm+2qQfQcEb7GSgvsg@mail.gmail.com>
 <20200508142309.11292-1-kelly@onechronos.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ec871922-bf92-32cf-c004-846974eed947@gmail.com>
Date:   Fri, 8 May 2020 07:45:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200508142309.11292-1-kelly@onechronos.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/20 7:23 AM, Kelly Littlepage wrote:
> The stated intent of the original commit is to is to "return the timestamp
> corresponding to the highest sequence number data returned." The current
> implementation returns the timestamp for the last byte of the last fully
> read skb, which is not necessarily the last byte in the recv buffer. This
> patch converts behavior to the original definition, and to the behavior of
> the previous draft versions of commit 98aaa913b4ed ("tcp: Extend
> SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg") which also match this
> behavior.
> 
> Fixes: 98aaa913b4ed ("tcp: Extend SOF_TIMESTAMPING_RX_SOFTWARE to TCP recvmsg")
> Co-developed-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Iris Liu <iris@onechronos.com>
> Signed-off-by: Kelly Littlepage <kelly@onechronos.com>
> ---
> Reverted to the original subject line


SGTM, thanks.

Signed-off-by: Eric Dumazet <edumazet@google.com>


