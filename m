Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFF564958BF
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 05:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbiAUEGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 23:06:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiAUEGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 23:06:15 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C022C061574;
        Thu, 20 Jan 2022 20:06:15 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 192so4295642pfz.3;
        Thu, 20 Jan 2022 20:06:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=user-agent:date:subject:from:to:cc:message-id:thread-topic
         :references:in-reply-to:mime-version:content-transfer-encoding;
        bh=8+X6EhAbzBhA2wQmYG1k4Og2aMdttrSV1A0aWDvQLhI=;
        b=JVEFPAffj9UhWIsMNUTKT8sKFatG3vC/bQtYcujpKlUHNRpDdpnTh1C7rFjfO0hEsV
         eBuvgTr9oDbe0Iqk+f58SVjyeoU/TjHwwo0RaZ5EolviAgvRL2sPIsPoWEXmcgCLsn5K
         9bvT8+4jUrJAIMM9l8ouu8NENjypeIraySAOE/NQo7l9XxdQ5XEz7NT0rO18GOjTolvf
         KZU0gSj8vNAa7+TDj6fI7nJRyYEJLbRCoAoaiE81fXw+Bl2NDMwi+GHHG+eMq6vX7KMT
         y73ZnXw70JyjUFEuYPrCaEcUmw7carb5uPQOQ2rAQ9xHzA5arHH1nb4MODWV274gj9AE
         GPdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:user-agent:date:subject:from:to:cc:message-id
         :thread-topic:references:in-reply-to:mime-version
         :content-transfer-encoding;
        bh=8+X6EhAbzBhA2wQmYG1k4Og2aMdttrSV1A0aWDvQLhI=;
        b=se6ZbRHX/Ep/viWkil4GbrXjoou2AkDx8JLzZxDVkxW+1EF9Sr5rzm3QDQ1LKL/p8E
         4VB+86AgSZJLlFs+d1t1pizoYWjZNQHn1iKNUAw2Zim8y08apPyQM0Gvz31d8rQsE7DA
         V2etQNrcIDe492utdN/sbkYwigdDH6CpumZqp0OfbtxlppTvclwI36UF2UWAVQyIQkOn
         MIcq2RNGVK3F4GC7S0tNRiaSO6dokQI2cvnFeIzlxv9eyxwPJhCtbRnFCFrtXi04d0+k
         N25ugbLy62XAdBrzUDEP9E8l7ZnH0lB0VpvV/3Tw17XkTnDqkMlBL8/XrDrY0jBjtGZs
         ywCQ==
X-Gm-Message-State: AOAM5311hq2wmnI0Ed436EwQnsobkMFgTp8hmj1TXfeFqrYHLmtgpBEa
        O+AlsPmVIqWTNjx+uRF3LhQ=
X-Google-Smtp-Source: ABdhPJxSlODE6zepSGl7wjrdReYE/DDryhJgFya9M2r0IDHO0lFm62e4/IYRrsN2zE5sXarunjG4aw==
X-Received: by 2002:a63:211a:: with SMTP id h26mr1608979pgh.239.1642737974681;
        Thu, 20 Jan 2022 20:06:14 -0800 (PST)
Received: from [30.135.82.253] (ec2-34-221-172-227.us-west-2.compute.amazonaws.com. [34.221.172.227])
        by smtp.gmail.com with ESMTPSA id ml16sm3554097pjb.10.2022.01.20.20.06.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jan 2022 20:06:14 -0800 (PST)
User-Agent: Microsoft-MacOutlook/16.57.22011101
Date:   Fri, 21 Jan 2022 12:06:06 +0800
Subject: Re: [PATCH] ipv4: fix lock leaks
From:   Ryan Cai <ycaibb@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kafai@fb.com>,
        <songliubraving@fb.com>, <yhs@fb.com>, <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
Message-ID: <BDEF9CF1-016A-48F2-A4F3-8B39CC219B4F@gmail.com>
Thread-Topic: [PATCH] ipv4: fix lock leaks
References: <20220121031108.4813-1-ycaibb@gmail.com>
 <20220120194733.6a8b13e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220120194733.6a8b13e6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Mime-version: 1.0
Content-type: text/plain;
        charset="UTF-8"
Content-transfer-encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for reporting this false positive. Would be more careful next time. T=
hank you for your checking.

Best,
Ryan

=EF=BB=BFOn 21/1/2022, 11:47 AM, "Jakub Kicinski" <kuba@kernel.org> wrote:

    On Fri, 21 Jan 2022 11:11:08 +0800 ycaibb wrote:
    >  			if (seq_sk_match(seq, sk))
    > +				spin_unlock_bh(lock);
    >  				return sk;

    Heh, also you're missing brackets so this is patently buggy.


