Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A06A0BB843
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 17:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732362AbfIWPo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 11:44:56 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38474 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfIWPoz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 11:44:55 -0400
Received: by mail-pl1-f196.google.com with SMTP id w10so6676113plq.5
        for <netdev@vger.kernel.org>; Mon, 23 Sep 2019 08:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6WQvZ96QMHa45rm4YUC3oe55G/TNndnRARtZftwP4nc=;
        b=qUvfK7tPx1/Gl2Dg1Ise18Y1EL2u8rZFT1EZALHKJTFGbH/xYs3LMeSzR2qPimPf9r
         Dq5DHHcKR7kaV72EWmFV5Rpv5ah1sSwQLsvf07HNy3+1BnudJi4p1NHZhOavEhyeyUqY
         YO7Fn5nKkIoaF4zb6vDXyZA1AZhl3e9Whp8XPqXAcxuet8zpw/Snz6mZHwLzVOJOcKiN
         CgIn9BY0+CmWlEfq0+9Po7ZTiN8ePeTAlWbxSDaWk0lEs4G98McIcLH5dpKqa8yuY5Pj
         2ac3NztaSot5Oe56iyM5nizatcFgG8klTM8+vScju/QkuinGZE6Rl0rzv7NtyLk4AfPD
         ling==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6WQvZ96QMHa45rm4YUC3oe55G/TNndnRARtZftwP4nc=;
        b=L/Ocmif3tJvd+zCsmkRaNakrqfswrZ+H9whyGA5X2OIoRNBOTpci5CmXT3uvvNhXFG
         D2x9PQM0NiISJNK6fFm3ewz/WEnwif1Lk+64albYrbEH95ICRJX2SE4325sLawGAA6FW
         vAMuyLNFUzle4pPvoGX04GV2WCJFhBWrh3JpDeyK74v+zXRrBBEkE3amfYQNhYbTIjcz
         ZCuQs4trBXpX0sWS+8vvIa9HgQwr/+rl/Jtg7SJHeQmWmPGAXX4axAMHusZFczv/8ku3
         rdw+0u8vNSE/Wp6tb69a8yxkprSNvlNt0/nu/ZKIeKAxfDMPLkcLeZDJd+Et1uue0HAc
         M6ZQ==
X-Gm-Message-State: APjAAAWfIyp1MhF9nItroNC94Os3vNLnG2esHm4Qkgh4QUGJIhhT5VVO
        7xLyNGYVkTUTs/bOn3/qhSA=
X-Google-Smtp-Source: APXvYqyciiMyWk3xtXn+VeQgvVutMkSmCTtHWd3h7Wn/QIarRg5+qc+ykwhySkVAdrjsrEsw5fuWRg==
X-Received: by 2002:a17:902:690c:: with SMTP id j12mr390687plk.83.1569253494685;
        Mon, 23 Sep 2019 08:44:54 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id a8sm22503866pfa.182.2019.09.23.08.44.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 08:44:53 -0700 (PDT)
Subject: Re: [PATCH net] net: sched: fix possible crash in
 tcf_action_destroy()
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
References: <20190918195704.218413-1-edumazet@google.com>
 <CAM_iQpVyJDeScQDL6vHNAN9gu5a3c0forQ2Ko7eQihawRO_Sdw@mail.gmail.com>
 <20190921190800.3f19fe23@cakuba.netronome.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <4e2ff069-e1f5-492f-14eb-5348e2cab907@gmail.com>
Date:   Mon, 23 Sep 2019 08:44:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190921190800.3f19fe23@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/21/19 7:08 PM, Jakub Kicinski wrote:
> On Wed, 18 Sep 2019 14:37:21 -0700, Cong Wang wrote:
>> On Wed, Sep 18, 2019 at 12:57 PM 'Eric Dumazet' via syzkaller
>> <syzkaller@googlegroups.com> wrote:
>>>
>>> If the allocation done in tcf_exts_init() failed,
>>> we end up with a NULL pointer in exts->actions.  
>> ...
>>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>>> index efd3cfb80a2ad775dc8ab3c4900bd73d52c7aaad..9aef93300f1c11791acbb9262dfe77996872eafe 100644
>>> --- a/net/sched/cls_api.c
>>> +++ b/net/sched/cls_api.c
>>> @@ -3027,8 +3027,10 @@ static int tc_dump_chain(struct sk_buff *skb, struct netlink_callback *cb)
>>>  void tcf_exts_destroy(struct tcf_exts *exts)
>>>  {
>>>  #ifdef CONFIG_NET_CLS_ACT
>>> -       tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
>>> -       kfree(exts->actions);
>>> +       if (exts->actions) {  
>>
>> I think it is _slightly_ better to check exts->nr_actions!=0 here,
>> as it would help exts->actions!=NULL&& exts->nr_actions==0
>> cases too.
>>
>> What do you think?
> 
> Alternatively, since tcf_exts_destroy() now takes NULL, and so
> obviously does kfree() - perhaps tcf_action_destroy() should 
> return early if actions are NULL?
> 

I do not have any preference really, this is slow path and was trying to
fix a crash.

tcf_action_destroy() makes me nervous, since it seems to be able to break its loop
in case __tcf_idr_release() returns an error. This means that some actions will
never be release.
