Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8B91D54B1
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 17:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgEOPam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 11:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726872AbgEOPal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 11:30:41 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC654C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:30:40 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z4so1573643wmi.2
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 08:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xuRRU92rTe4aDQPNGUpo4dz0c4PMM1SC+F01ir7ncmM=;
        b=JEo72LJnT1uVTqG+XBv6CA8qdRa4g7JKgJPSXk//Qn5Tuz6lekivqEl62Mzv0BpS/G
         qps8WybHEVoT5cbmg/ua1TMLt2hEH8y8asFKbkqPNKzWDQqYmNpV4qDCXWot5FqnH1NI
         wfBFAi4lBOdu7ptw1jqokwQq9UcNxNyiKaS+4JCdspsO1c+idC/BILGMWmRGPpyn6eFJ
         Z7+ywKlifQZcsxyUw7mMvk8ER7SPNOwO2lPaCEGjK+8u3o6SS2F/H+6hdqT4AzDGJfeJ
         WsEF2zgBLUJWeKGY48IiyNGLKRJqvV3Q11sLO80UKViueLqd1+YyOwDYBBQBJcoxcBFm
         nEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xuRRU92rTe4aDQPNGUpo4dz0c4PMM1SC+F01ir7ncmM=;
        b=BbQ2DaxuJ6pg3pw3nO2JIN+48taScEq88EShvej3F23+PfLabvXkIqvBrFRhAdW4ER
         j/DJPK/u/l+zZ02F/Ueil5ODq5dQGW0+uZ4eamrO+wQWCZyM8v1YUDJw//ujSiGmrlS/
         oV1hAOTwduIJxncfydB/FMEBgC1PWD+vLKqv9PGWpGDM4o+c65roj75qTPyfcwwxXmoQ
         dbPs2zakDDPG1NMxJNV+iIsE7OeW31l422ky09LqitKuCuL8WvfkAj05pNl0YuJGHZyC
         95vSUzcuGNjGlpCV8lX6m62R3OoAz43jLoLuo3ws/8sD2W1vv7GstJYXqM20zJAg7oKK
         mNRw==
X-Gm-Message-State: AOAM532Ec8CZoBxdFpz+BZYWQlKU1DsXiZsSAvG/iPhRovKvW3FY4ntM
        EEXR9e+wls9zxXnXFeqHmxtWCQ==
X-Google-Smtp-Source: ABdhPJzlZYUXgoh7+LFBsiIN7o4kcXi1fjddpXFvclu3dYMYjaYuKrhLK3oj/fai1Xn9Fb8HSsmt1g==
X-Received: by 2002:a1c:29c4:: with SMTP id p187mr4595039wmp.73.1589556639531;
        Fri, 15 May 2020 08:30:39 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([213.211.144.192])
        by smtp.gmail.com with ESMTPSA id m3sm4084674wrn.96.2020.05.15.08.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 08:30:38 -0700 (PDT)
Subject: Re: [PATCH net-next] mptcp: Use 32-bit DATA_ACK when possible
To:     Christoph Paasch <cpaasch@apple.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     mptcp@lists.01.org, Paolo Abeni <pabeni@redhat.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
References: <20200514155303.14360-1-cpaasch@apple.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <445922ee-af86-131a-559f-5fa1b4ebbad5@tessares.net>
Date:   Fri, 15 May 2020 17:30:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514155303.14360-1-cpaasch@apple.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/05/2020 17:53, Christoph Paasch wrote:
> RFC8684 allows to send 32-bit DATA_ACKs as long as the peer is not
> sending 64-bit data-sequence numbers. The 64-bit DSN is only there for
> extreme scenarios when a very high throughput subflow is combined with a
> long-RTT subflow such that the high-throughput subflow wraps around the
> 32-bit sequence number space within an RTT of the high-RTT subflow.
> 
> It is thus a rare scenario and we should try to use the 32-bit DATA_ACK
> instead as long as possible. It allows to reduce the TCP-option overhead
> by 4 bytes, thus makes space for an additional SACK-block. It also makes
> tcpdumps much easier to read when the DSN and DATA_ACK are both either
> 32 or 64-bit.
> 
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

LGTM, thanks Christoph!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>
