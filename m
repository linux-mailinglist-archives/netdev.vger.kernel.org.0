Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2F53D0262
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 21:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbhGTTP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 15:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234155AbhGTTPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 15:15:14 -0400
Received: from mail-oo1-xc32.google.com (mail-oo1-xc32.google.com [IPv6:2607:f8b0:4864:20::c32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31254C061574;
        Tue, 20 Jul 2021 12:55:51 -0700 (PDT)
Received: by mail-oo1-xc32.google.com with SMTP id 128-20020a4a11860000b029024b19a4d98eso57387ooc.5;
        Tue, 20 Jul 2021 12:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3DB/7Fj/IaeliSZQDKbkmJzUxTFFzlMVmYcVBpZWbhU=;
        b=LEaiS9PHyFQpsX2JEjse16bR9k9zqQgsvlBghDEfnunfk71V6XfJ9K7g81nbS0ybyF
         h/CXOTRNrNbG0bmMcJmemczBkds3sepHYADQXW217jsDy+MeI/QFEDX30vg2CJ2HFFuG
         ppFZ1MQ1QUwvAHfcHB1HgHlk/AD9WT+ylWFsjHk6AFY7MK8SRjykzoXyVNg4AggFUpVo
         JPlWMKWMTPemdwyqNbMUDoSkDRPbnZNqZE50TjPRQsXROnSz0kR+uFvpknsdvKCAp0Jj
         GSA5GuQDAwlq52gl3FqlVS8sKbQ0kwhtuGGjfLMetQnxeSe7MXXY1IB9nrImlgSZrqz0
         +tuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3DB/7Fj/IaeliSZQDKbkmJzUxTFFzlMVmYcVBpZWbhU=;
        b=gcLhbcQgQ819rgI+vQRwk5YONF8nrJXpOBjTjuU0UrUIfXMZIswOGKXwEwqthBTa1v
         uCT7zgFKXmCIzYUPJ+rNiWK7kWC0w7C7lI4sCF6mZ04CRejXMhOQHlsYvTORuMDVJiba
         KvrAKlmkM7io3opKcsS9h58AsSRvhM7yys9SDfRNw3GUdwpnwkIFl01hy0kz2GsFr6j/
         lLySIfg3V9mdRXx2L+o3K9MXW9++HdVtpQpclL0QuK/Lj5jnD94xv0z3vQi9bPAgSCVx
         q7tFuQg5HB/C10gCb8bTEYIAODkfy9XuaYhM98paUHsyqq/pqGEKQ3YFWbHGIBpzT+xP
         59/w==
X-Gm-Message-State: AOAM530Hr1HNLYmlF/0gHybDsOk1drMaGPBzLBmtD/kKwUFnaNSDq0Rz
        fz/DDolWdO1lkYk7sYwAaPU=
X-Google-Smtp-Source: ABdhPJyXEW3wwaugbKcaIjOp2U4MVZk16fbngBvrCqAurDhDtcvommFwlpcKVDuCCps5RxFCSbsETQ==
X-Received: by 2002:a4a:2242:: with SMTP id z2mr21967622ooe.90.1626810950218;
        Tue, 20 Jul 2021 12:55:50 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id z3sm4315971otp.32.2021.07.20.12.55.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jul 2021 12:55:49 -0700 (PDT)
Subject: Re: [PATCH] net/ipv6: Convert from atomic_t to refcount_t on
 ip6_flowlabel->users
To:     Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org
Cc:     yuanxzhang@fudan.edu.cn, Xin Tan <tanxin.ctf@gmail.com>
References: <1626683707-64470-1-git-send-email-xiyuyang19@fudan.edu.cn>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f7d3dee7-5c35-a780-93df-ba0cdb7a2215@gmail.com>
Date:   Tue, 20 Jul 2021 13:55:47 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1626683707-64470-1-git-send-email-xiyuyang19@fudan.edu.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/21 2:35 AM, Xiyu Yang wrote:
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> ---
>  include/net/ipv6.h       |  5 +++--
>  net/ipv6/ip6_flowlabel.c | 18 +++++++++---------
>  2 files changed, 12 insertions(+), 11 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


