Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D45123F22C
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 19:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHGRtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 13:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgHGRsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 13:48:50 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD1DC061757
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 10:48:50 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id c16so2905776ejx.12
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 10:48:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tessares-net.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xdiL67MKwU7CBlH+XKS8Qs8DSkpecumejorrBEcWsWU=;
        b=Jl1vW5e3WpgGcHg6AZlRAFgYiQjlvKy/jbQOEAIn1xfq2vR28AtknfclmeRCaj34Qa
         vcNBELJNxp1/3VUiLTHg/9bC88PZqw81ahsTWtd1fqfM4K5GITG42n5tPmaqPAZrIR89
         lSgqRsjj9T7i9vxwFCEHfezbAV7OWCUBgCnpkuHFe5ciL/VxReSOsjXqB5FfDd58GCRE
         gL0JXpztWOpUQXW3kJFLeiKJaZQXcLMeveGip2/7xa1zKk7HPu2HcbU9zXkkMoJcdGn8
         fD2OqfWmR+hQfG4PZZrVq/w9Bhhk2dMqXkr4VSujtkBiUeNYOHiwmnZfyif3rSCkP0FQ
         qqqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xdiL67MKwU7CBlH+XKS8Qs8DSkpecumejorrBEcWsWU=;
        b=TZREdACzQRwXOXltUwnBCOpFle4JSuWO8zC46BXTU0xhWLBSVcZsX51yps39yrUq8J
         uys90ywr0qBPTcmUJX3l6hRSi6R+lp/8+lYi3qn193QXGKYzGYORxcpgZH/vyDQIGTnU
         8IGC5yGLysu742+eWKxGYFi1WySfWpTmqGBUSqHwVcSYrNgAKoG6lSZp9RGFIcKfYe5U
         z66Zb7IOHTQoIfwCdhfjaWJqY9rgbG+UtFJpXlBTiXrE9AIIF0WLpSp9q5BiXwKqmXxB
         YhfJVYgvulfBuSAna7VoDVJesX8Fo87TVgPDcQrMUm0+XsY6M9vsDj0hCHqmL18JU/8O
         aK6g==
X-Gm-Message-State: AOAM533vthLvXQJY8SZ57kg0JpHtPXn5KHfCw5wO7TSUzX3v5qufkGfc
        VPJfaLEHvChb0g+aeD6HtNb28Q==
X-Google-Smtp-Source: ABdhPJwoSICf5UuLXgpUoZh2nf1/Ti5KJMSBMLQY6JO7GB9KdfxtIXWDeWvjASjfG8pXTZyfOLlGhA==
X-Received: by 2002:a17:906:3c10:: with SMTP id h16mr10307024ejg.233.1596822529134;
        Fri, 07 Aug 2020 10:48:49 -0700 (PDT)
Received: from tsr-lap-08.nix.tessares.net ([213.211.153.203])
        by smtp.gmail.com with ESMTPSA id y7sm6368043ejd.73.2020.08.07.10.48.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 10:48:48 -0700 (PDT)
Subject: Re: [PATCH net] mptcp: fix warn at shutdown time for unaccepted msk
 sockets
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
References: <2458c1210f1a164c615e3aa3b9613b085a6c8326.1596819537.git.pabeni@redhat.com>
From:   Matthieu Baerts <matthieu.baerts@tessares.net>
Message-ID: <56686a4e-bc24-b247-1a57-260db329c651@tessares.net>
Date:   Fri, 7 Aug 2020 19:48:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <2458c1210f1a164c615e3aa3b9613b085a6c8326.1596819537.git.pabeni@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo,

On 07/08/2020 19:03, Paolo Abeni wrote:
> With commit b93df08ccda3 ("mptcp: explicitly track the fully
> established status"), the status of unaccepted mptcp closed in
> mptcp_sock_destruct() changes from TCP_SYN_RECV to TCP_ESTABLISHED.
> 
> As a result mptcp_sock_destruct() does not perform the proper
> cleanup and inet_sock_destruct() will later emit a warn.
> 
> Address the issue updating the condition tested in mptcp_sock_destruct().
> Also update the related comment.

Thank you for this new patch!

Reviewed-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Cheers,
Matt
-- 
Tessares | Belgium | Hybrid Access Solutions
www.tessares.net
