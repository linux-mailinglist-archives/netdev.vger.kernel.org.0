Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74154813E9
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 10:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfHEIFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 04:05:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42401 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfHEIFu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 04:05:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id x1so33487611wrr.9;
        Mon, 05 Aug 2019 01:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ToJnko+ALzDVdJBIaKKGvkFZghSxFZh/q3t7aezmRt8=;
        b=Rn+i+wApNOubMkKXVGQiNN7q1RPqWbnfbZiPhpGCCv/a4DBezn2FQmJ3xLNMBQrRRQ
         AieVM3+jNGpaONTi6W7i01MQlCC8n2t1kZDzj3EpAhcZN/zrD595QyiePdOC2ZaYaN77
         dsBP3zVKY6c8X6alPMR3bdPBsImT5jzG8a5FUqL5q/Oiel4qAGvHcXgI9cYxUdSBp4ml
         jhpqTq6Ut0l+RkqWWifaRss14qiR97zg/PwTbNAwr/F4zVusWpDo97rah6grSZErbjvn
         q28DHk3vCaCeslbfFLkJmewfOPrJTV8hqIaQgncEkMeEZS+uiBXO0UEUmm74MlSIS6AL
         FDEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ToJnko+ALzDVdJBIaKKGvkFZghSxFZh/q3t7aezmRt8=;
        b=pSqgeSsdNNFoTDFN9eaHwdU3CyOEOgx0vjZ2VGpQBLIxWKTi2iyhJTJ99epEu4rdrO
         pX3pWKlAVi7v+OG7v1ttVJLbVY2xsQBskghee2zkuo7UxZt5bhIxLAslAspkYXZIInvB
         P1W67VKDsKQvSSuPYVmfLN4TnsJKW6xvsOUCs9YVjs+/4GNR8OPP4tv8tw7wld5NluOL
         zVxkW6rNdNFyyv1rLVqCvRPAnJoas9DLgyfnDMhb1uDNoolsJambEm4su5oQ9xuNhf+V
         TxEASGjJV6QgENMc8gwSD35FPAi91A7Nf1umH3yG5CJe85wXvN5Wd3z/ALFxCgLpcnFA
         RbCQ==
X-Gm-Message-State: APjAAAWPQYzLrSedFJ815dxOySzhAVToI/hmPIbdQ1D4dG7xFU/Xjbwj
        fiVjXj6HxeXV3lMZ+JVlcaRJGJgr
X-Google-Smtp-Source: APXvYqzoyoyBAZU/BfHJM4ehX0Vfb2NCIS43nHkEzh0T5VEB/PXkGj57KdGo5PCP7qT7GtFUf6zLnQ==
X-Received: by 2002:a5d:50d1:: with SMTP id f17mr28873767wrt.124.1564992348457;
        Mon, 05 Aug 2019 01:05:48 -0700 (PDT)
Received: from [192.168.8.147] (120.162.185.81.rev.sfr.net. [81.185.162.120])
        by smtp.gmail.com with ESMTPSA id 32sm75623972wrh.76.2019.08.05.01.05.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 01:05:47 -0700 (PDT)
Subject: Re: [PATCH v3] net: sched: Fix a possible null-pointer dereference in
 dequeue_func()
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20190729082433.28981-1-baijiaju1990@gmail.com>
 <CAM_iQpU0L6hgzg1N9Ay=72Ee-2Ni-ovPJX8SyJaRDv7dbhZs_Q@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7c260c52-5f73-2efb-1477-cfcca0971a59@gmail.com>
Date:   Mon, 5 Aug 2019 10:05:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpU0L6hgzg1N9Ay=72Ee-2Ni-ovPJX8SyJaRDv7dbhZs_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/29/19 7:23 PM, Cong Wang wrote:
> On Mon, Jul 29, 2019 at 1:24 AM Jia-Ju Bai <baijiaju1990@gmail.com> wrote:
>>
>> In dequeue_func(), there is an if statement on line 74 to check whether
>> skb is NULL:
>>     if (skb)
>>
>> When skb is NULL, it is used on line 77:
>>     prefetch(&skb->end);
>>
>> Thus, a possible null-pointer dereference may occur.
>>
>> To fix this bug, skb->end is used when skb is not NULL.
>>
>> This bug is found by a static analysis tool STCheck written by us.
> 
> It doesn't dereference the pointer, it simply calculates the address
> and passes it to gcc builtin prefetch. Both are fine when it is NULL,
> as prefetching a NULL address should be okay for kernel.
> 
> So your changelog is misleading and it doesn't fix any bug,
> although it does very slightly make the code better.
> 

Original code was intentional.

A prefetch() need to be done as early as possible.

At the time of commit 76e3cc126bb223013a6b9a0e2a51238d1ef2e409
this was pretty clear :

+static struct sk_buff *dequeue(struct codel_vars *vars, struct Qdisc *sch)
+{
+	struct sk_buff *skb = __skb_dequeue(&sch->q);
+
+	prefetch(&skb->end); /* we'll need skb_shinfo() */
+	return skb;
+}


Really static analysis should learn about prefetch(X) being legal for _any_ value of X
