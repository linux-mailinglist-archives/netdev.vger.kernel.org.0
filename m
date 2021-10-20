Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB06435009
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 18:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbhJTQWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 12:22:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbhJTQWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 12:22:49 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789C6C06161C
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:20:34 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n11so16511109plf.4
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 09:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Xey79KpfqeWxBW+xgCxbv/6IvTJlep/tkf85c07KSO4=;
        b=ca0709WzkerJcSJ9uqqnbVkExUM4w6s4X9pyoADjph4wfB9jBz4cTrCIzh0lqDBPg+
         SjWjycDo7hjIz1Si3XjMXU13aF3dkdVKh6QfylfvO5HYeDx4v4r1itec0maNROiZOZK2
         w4fKNjsEN+rPZSMMQPpC8uzvDy0w2t09LVrBEYUK3rg5TS/3+UjUTCDp9Z/xS8cfCai5
         1KSTZYtfD46HITIBDCrlywW09ThmOMnhxENdd9nLvhfpzRmnNhCOYAXKMTdDcGMuSYok
         UbAkNmCsDzSCFe487OpDefdeGP8Ef+ycjw02f0PK00Prx9abqoc5S8HdsVrtwJk8x33/
         fA3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xey79KpfqeWxBW+xgCxbv/6IvTJlep/tkf85c07KSO4=;
        b=A0ZV0egiUtjCSE+g9zf/kwDDola4lsccUJtta264AEalfIAZu5wESVMRMt2BbOOCx8
         JCdWhKd1+v7JQAs6taCeQGQp8WP0KJFZ9yUGmbNMPJgN0/uPquD71f4z2krnLgCupA9o
         dB3acfRH0KIvi7xg3wB/ILVqoxJsWjgMnNyxbOWPNO5O2qQtTpSBvX1MbAE7aV6Az95A
         sPpNrD6TI3J1O+5BtlEAKq/QSAVFryL7/ENAzuYPv5AtdXiFxyOZMecFPNFoY+MQX/J1
         lfNBugRYjDdwlg93meBahvUFuTMhZkn16w2f29r8eYN3KFAzEQxMfY0FlpyOsuCySk9d
         wBnQ==
X-Gm-Message-State: AOAM5337jSf9P51iRcEC6CYHenVvaZorMPf7/UeB6Y9Llj51HAuLvWky
        JTo1DuIDcQPcf9fpnP7Uj/A=
X-Google-Smtp-Source: ABdhPJwhucc6XeybvlrzXAhTjNqcO7aamTwNdJnjFtQ/5hUJCLM8Nx5XrsYbYWhhp87QYAF0/PB36A==
X-Received: by 2002:a17:90b:1bd2:: with SMTP id oa18mr8518261pjb.164.1634746833973;
        Wed, 20 Oct 2021 09:20:33 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w185sm2926127pfb.38.2021.10.20.09.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Oct 2021 09:20:33 -0700 (PDT)
Subject: Re: [PATCH net-next v2] fq_codel: generalise ce_threshold marking for
 subset of traffic
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com
References: <20211019174709.69081-1-toke@redhat.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <9cec30c9-ede1-82aa-9eca-ca76bcb206d5@gmail.com>
Date:   Wed, 20 Oct 2021 09:20:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211019174709.69081-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/19/21 10:47 AM, Toke Høiland-Jørgensen wrote:
> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
> so it can be applied to a subset of the traffic, using the ECT(1) bit of
> the ECN field as the classifier. However, hard-coding ECT(1) as the only
> classifier for this feature seems limiting, so let's expand it to be more
> general.
> 
> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is applied
> to the whole diffserv/ECN field in the IP header. This makes it possible to
> classify packets by any value in either the ECN field or the diffserv
> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
> INET_ECN_MASK corresponds to the functionality before this patch, and a
> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
> match against a diffserv code point:
> 
>  # apply ce_threshold to ECT(1) traffic
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x1/0x3
> 
>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_selector 0x50/0xfc
> 
> Regardless of the selector chosen, the normal rules for ECN-marking of
> packets still apply, i.e., the flow must still declare itself ECN-capable
> by setting one of the bits in the ECN field to get marked at all.
> 
> v2:
> - Add tc usage examples to patch description
> 
> Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 marking")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

BTW, the Fixes: tag seems not really needed, your patch is a followup/generalization.


