Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 408A425A6D8
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgIBHc5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgIBHcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 03:32:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 536C5C061244;
        Wed,  2 Sep 2020 00:32:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so4098230wrt.3;
        Wed, 02 Sep 2020 00:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fu3rhVbErwAPlE8HPpQ0/XopyDhWlhtlly/dcplP9TY=;
        b=asYSOntcpTHbiaWRo5xy57HdA7Q4MiRosi3KKd0vtdcHs+yGUqusZnzNGmOqfZ8UVf
         6kXz4tuOY+SGEyqddBhVB4MTxerGCGnYNQ4pbeUgOB4tH8z4AkWrJLXk0X0EN5ZZhVRo
         4FDBQOgCK53ePYGEpP9fkEcsJgQz09Qhhe0ICcbGr2BTa6+7lkVvbqfSI85YfPloxlPB
         MnbtLSAaY/14jtW1WzmLFfFA1FC/5T3E3nJX59YQXHQJx5YDx9edz8T/m6e2T1eW9LGJ
         ESkRcp6s9ttPE3lesTIMVIQhbRD2noNFyNERbpTZjSiMDnGIc6oz8waJE994SiJRS67p
         LyYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fu3rhVbErwAPlE8HPpQ0/XopyDhWlhtlly/dcplP9TY=;
        b=oZEy4LJqdaWDk7JPEzzZ3ZVhPKkucOgaxWcZr5xfNqVi7b60zJO+HElz2Y7dLDGTTl
         TZ5xF0zuHoDqlMfnhkhvjiBheTWS4I8Q0E6F+9pIZ9B5ZCc3qOSxMYC2MnHWaa4fR0rL
         jOcBaJdtS1TRSdWingl8cxW4Zux9vqYRkvAqx8BXfv1zLP2ZKT6EUzVRSBrqVMDtvG4w
         HLO+VoplBlToRcWsgHVi7r4ERfqsd2ikkOguTh5v3xsrdv5fOSG0bynasyztFYibKcfI
         r+rdR0IFSGJ9MWDvpD+LMh5V3Eicl3B45DDWnMmhUCPZ2MOb0lutb52CYB5/T922sOKu
         fmeA==
X-Gm-Message-State: AOAM531bJQJxYaeYI1UYWJfLVWiwrjCX1Om+Bi6f/Rww3KSaT8UTRTKG
        ERJ1eydHHAb2Rjc+Wx+LVDsg0EkuHEU=
X-Google-Smtp-Source: ABdhPJyDz94/oQIHXyFLv2/XsyDNLzEbN5UnuHyknZu35SS+jOuC0ccqA4JyJdQA1JXBl/6NlmYMaQ==
X-Received: by 2002:adf:91c2:: with SMTP id 60mr1633124wri.292.1599031970119;
        Wed, 02 Sep 2020 00:32:50 -0700 (PDT)
Received: from [192.168.8.147] ([37.170.201.185])
        by smtp.gmail.com with ESMTPSA id n124sm5126104wmn.29.2020.09.02.00.32.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 00:32:49 -0700 (PDT)
Subject: Re: [PATCH net-next] net: sch_generic: aviod concurrent reset and
 enqueue op for lockless qdisc
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@huawei.com
References: <1598921718-79505-1-git-send-email-linyunsheng@huawei.com>
 <CAM_iQpVtb3Cks-LacZ865=C8r-_8ek1cy=n3SxELYGxvNgkPtw@mail.gmail.com>
 <511bcb5c-b089-ab4e-4424-a83c6e718bfa@huawei.com>
 <CAM_iQpW1c1TOKWLxm4uGvCUzK0mKKeDg1Y+3dGAC04pZXeCXcw@mail.gmail.com>
 <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <1f7208e6-8667-e542-88dd-bd80a6c59fd2@gmail.com>
Date:   Wed, 2 Sep 2020 09:32:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <f81b534a-5845-ae7d-b103-434232c0f5ff@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/20 11:34 PM, Yunsheng Lin wrote:

> 
> I am not familiar with TCQ_F_CAN_BYPASS.
> From my understanding, the problem is that there is no order between
> qdisc enqueuing and qdisc reset.

Thw qdisc_reset() should be done after rcu grace period, when there is guarantee no enqueue is in progress.

qdisc_destroy() already has a qdisc_reset() call, I am not sure why qdisc_deactivate() is also calling qdisc_reset()


