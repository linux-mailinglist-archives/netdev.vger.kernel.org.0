Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E471A12C0E5
	for <lists+netdev@lfdr.de>; Sun, 29 Dec 2019 07:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbfL2GLs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 01:11:48 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37768 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725800AbfL2GLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 01:11:48 -0500
Received: by mail-wr1-f68.google.com with SMTP id w15so17366634wru.4
        for <netdev@vger.kernel.org>; Sat, 28 Dec 2019 22:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H527xRoqjyOCFlxCai05j/VhCTC/YKxI360gHrrQM+A=;
        b=C7ZtEBcrdVUqciG1d0UP9n2V9UtnERSeavu7rnJIRDi/ISMwOgfQhDBCzoFs/lL8MG
         HYVB4fdhbUqK9nZ09iapaYMc4+F80aepZFkTOG3+ITEg1Kx4KyGGrPGwRMisxP/KYfG2
         LEYSBACtjx6rt6uU30sAUYT4aqIqdzWSO2H0M8J/BkVbS/y69xS1N3lVi8SRGcDqk0Xk
         EnzeHELnYSP3+xVj2L+Z7NOiYC/tfIs0W+kT5T+VCW/nPcvL+Ca+1XUXrvoukzCNz11U
         4X9A9fSgSvrX6KNwf0/30HA792nAV0yC31oh9wvNW3H+U69GwYC7acuTfkD8zO5sjJAU
         TX4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H527xRoqjyOCFlxCai05j/VhCTC/YKxI360gHrrQM+A=;
        b=XLkeS0qR+5b+3oUiLazwElgszJH07SlpNzPKIQFB8dx4zuay7XhhgnGZRkUQyvWlyg
         A5ViqV9PAMEDErhyLSUJpAR78ShJw4mqLgAbQq8xOfQnA8ZJSEXVvsGlHFh1bryEZdlJ
         ZvdUgJ+rKRBmwKBlUcz1bKs6WJMHpWbsit9HGy9IFj1Uu2zATFHr1y4QFuFkvvC4Misz
         0bDKx0mMBPqtBr5U2yJoaK4E/H8P7mBHTADrjlJEsczkidkNnWHQL8wxQQiTJOj3lUSd
         7jE2m02vyy2bKdkxIkQp57JYrvcHBkqoEGfAYDAb0Ro08k/b6tNDXfelhOnmHW4eXzel
         dlHw==
X-Gm-Message-State: APjAAAU6rJibSwdK/nSzflwpp7sJTJ5/7jSWFzfPfi9u7UL345tvrjMk
        H62WNHRr81v0wY9ulZKk0Io=
X-Google-Smtp-Source: APXvYqzBwXkL8164KKznP209MjWamvUHZr0P4/xLN0WbcEipr+lupCj2x2fgg/kkYaAFahxPvntWCg==
X-Received: by 2002:a5d:66c3:: with SMTP id k3mr55370501wrw.370.1577599906363;
        Sat, 28 Dec 2019 22:11:46 -0800 (PST)
Received: from [192.168.8.147] (96.172.185.81.rev.sfr.net. [81.185.172.96])
        by smtp.gmail.com with ESMTPSA id z187sm16530490wme.16.2019.12.28.22.11.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Dec 2019 22:11:45 -0800 (PST)
Subject: Re: [PATCH] tcp: Fix highest_sack and highest_sack_seq
To:     Cambda Zhu <cambda@linux.alibaba.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Yuchung Cheng <ycheng@google.com>,
        netdev <netdev@vger.kernel.org>,
        Dust Li <dust.li@linux.alibaba.com>
References: <20191227085237.7295-1-cambda@linux.alibaba.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b3ee6906-85d6-c430-c5fb-10c191ffe99f@gmail.com>
Date:   Sat, 28 Dec 2019 22:11:43 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191227085237.7295-1-cambda@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/27/19 12:52 AM, Cambda Zhu wrote:
> From commit 50895b9de1d3 ("tcp: highest_sack fix"), the logic about
> setting tp->highest_sack to the head of the send queue was removed.
> Of course the logic is error prone, but it is logical. Before we
> remove the pointer to the highest sack skb and use the seq instead,
> we need to set tp->highest_sack to NULL when there is no skb after
> the last sack, and then replace NULL with the real skb when new skb
> inserted into the rtx queue, because the NULL means the highest sack
> seq is tp->snd_nxt. If tp->highest_sack is NULL and new data sent,
> the next ACK with sack option will increase tp->reordering unexpectedly.
> 
> This patch sets tp->highest_sack to the tail of the rtx queue if
> it's NULL and new data is sent. The patch keeps the rule that the
> highest_sack can only be maintained by sack processing, except for
> this only case.
> 
> Fixes: 50895b9de1d3 ("tcp: highest_sack fix")
> Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>

Signed-off-by: Eric Dumazet <edumazet@google.com>

Sadly I could not come to an alternative solution.

Thanks !

