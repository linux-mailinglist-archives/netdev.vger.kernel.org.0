Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C03325ED3FF
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 06:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiI1Eq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 00:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiI1Eq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 00:46:58 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C9FAB7EE6
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 21:46:54 -0700 (PDT)
Message-ID: <6afbe4af-ada1-68df-4561-ca4fb45debaf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1664340412;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=onTMWXEy7dAQemdEphebkpDlPzJ4/+jHmwbyzmlRv/U=;
        b=wzv7G9NH4xRRMOH+D/bZxR/9qq/0y6CiEaWerWvNUIDOVp31DtfB+fzpE2bOjRgnzpklQk
        p/drEpzkMzIQEZohCmV+u2jMhWZCvFKOHH93C3EUbZfUPUULoTr9j3Pki3725hZq+St/ZX
        0WHjjNmYc71PSn8iWIXG7VRpQLgqFX4=
Date:   Tue, 27 Sep 2022 21:46:40 -0700
MIME-Version: 1.0
Subject: Re: [PATCH net-next] net: Fix incorrect address comparison when
 searching for a bind2 bucket
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        kernel-team <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Joanne Koong <joannelkoong@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Martin KaFai Lau <martin.lau@kernel.org>
References: <20220927002544.3381205-1-kafai@fb.com>
 <CANn89iLdDbkFWWPh8tPp71-PNf-FY=DqODhqqQ+iUN+o2=GwYw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <CANn89iLdDbkFWWPh8tPp71-PNf-FY=DqODhqqQ+iUN+o2=GwYw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/27/22 8:49 PM, Eric Dumazet wrote:
> On Mon, Sep 26, 2022 at 5:25 PM Martin KaFai Lau <kafai@fb.com> wrote:
>>
>> From: Martin KaFai Lau <martin.lau@kernel.org>
>>
>> The v6_rcv_saddr and rcv_saddr are inside a union in the
>> 'struct inet_bind2_bucket'.  When searching a bucket by following the
>> bhash2 hashtable chain, eg. inet_bind2_bucket_match, it is only using
>> the sk->sk_family and there is no way to check if the inet_bind2_bucket
>> has a v6 or v4 address in the union.  This leads to an uninit-value
>> KMSAN report in [0] and also potentially incorrect matches.
> 
> I do not see the KMSAN report, is it missing from this changelog ?

My bad. Forgot to paste the link in the commit message.  It is here:

https://lore.kernel.org/netdev/CAG_fn=Ud3zSW7AZWXc+asfMhZVL5ETnvuY44Pmyv4NPv-ijN-A@mail.gmail.com/

