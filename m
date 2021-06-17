Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94E13AB749
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 17:18:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhFQPUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 11:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233219AbhFQPUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 11:20:52 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22EA7C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:18:45 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w127so6885006oig.12
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 08:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gGVcnUG5XLAb0mSQ5G3MlJlcF+TMI9ZFlS1+8Z7a6Ec=;
        b=vLfrdJP5aKQXD+ENDuM3OBJKtP/0dGTf2AcNB+3CkJ+2gnrLjoC5C7np4n+wkW8J5g
         uMf/rVCOQqBHibtFg7orAci4Dzkr0MJzyaN86BCJDBRPZYKC3YQYw5gGv+21c+ldXnF3
         +2YTcvyV3jo73yuwpNv5/ZthVVqP2m9OZMqQPT+7vvXCr/j1nCUb/lBdlqfMKOK+6dVk
         o+BmLKWzh72B7jzI9EH6/H7rQUsgdFCpAelxS1pt9Yk/xXrNcab+dLynUpFLhdnod6R9
         AdGDdEi++Zbf62zVxHmtI4Mwt977QKW1AqRsolcmZTSlTgo3/2msonD1IXLxdXTB+DwC
         1jTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gGVcnUG5XLAb0mSQ5G3MlJlcF+TMI9ZFlS1+8Z7a6Ec=;
        b=hu7pbvI9Epu0f+e6Bpuo+g6Cb6UfuUFpTlQAqoH9EJZhd7hFJ/z+5wQOlEh37kOcRn
         MlMUkB7CCdRVen7HcG+rXX0fr57aQnMskbwjUmwtZqyjdt3U/ls2XjBEjNS//FlnMA40
         OzzSeZmrNkGL0fmMV0Bd84w/bYnRwsbRta+5bOkcZt4YOH2dmTxEW19uOnhgxtfVfWIt
         n1qt5CDZQtoHvx97iAUQ3LKJFSPUBuMbR6m8vTYbQ1yKC900LZijmH/m/EYTegq4IlOe
         HSbYkxLWyYPAb7IhDh9mkbRC8a4DZjFYnAF10WwA5Kb2lx3iU3GzCAfal1mUwknkcJz5
         0A5Q==
X-Gm-Message-State: AOAM533ySRWPg0wsnIHhlK7rZ1DOSHobMkb3l62WtBGeN+Lc6sjvq27o
        njedXDjDZM9vk2cCw6+pwDg=
X-Google-Smtp-Source: ABdhPJzrAy2u5WRM3TC+B49hzKvpLlaDKhJkts2o1WK8mYXUSJcdbMzOveXFJ443/9cqAuCo/W9xVw==
X-Received: by 2002:aca:618a:: with SMTP id v132mr10978434oib.144.1623943124501;
        Thu, 17 Jun 2021 08:18:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.44])
        by smtp.googlemail.com with ESMTPSA id f2sm1197029ooj.22.2021.06.17.08.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 08:18:44 -0700 (PDT)
Subject: Re: [PATCH net] icmp: don't send out ICMP messages with a source
 address of 0.0.0.0
From:   David Ahern <dsahern@gmail.com>
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Juliusz Chroboczek <jch@irif.fr>
References: <20210615110709.541499-1-toke@redhat.com>
 <e4dc611e-2509-2e16-324b-87c574b708dc@gmail.com>
Message-ID: <be61a82e-1a21-d302-dcdc-8409130e8fb7@gmail.com>
Date:   Thu, 17 Jun 2021 09:18:42 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e4dc611e-2509-2e16-324b-87c574b708dc@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/21 9:06 AM, David Ahern wrote:
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> This should be the one that allows IPv6 nexthops with IPv4 routes.
> 
> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
> 

on further thought, this is the receiving / transit path and not the
sending node, so my change to allow v6 gw with v4 routes is not relevant.
