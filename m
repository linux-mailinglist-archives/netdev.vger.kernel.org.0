Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD5260774B
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:50:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiJUMuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiJUMt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:49:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C15B4C60B;
        Fri, 21 Oct 2022 05:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=SBlrOXEl53uPsnkVaf/IGUcx24gwhqnhn+mmhEkJ8lg=; b=zG1k86MsTdumWLer3d14WoHL/s
        Z1sLUQULqVXVynf/eSRSPBUC8FMa5SNYugk17z6hb3g8pxllYc38MVQZVBnTZlZ8nPguLurffovdg
        kC2fynx6Z6gpwju8ujQp2o4OrLvvI5ylP7NnNaLjucx3K7OiZfTExI/an4dn3JulVM7FlWhUcvEqK
        uHpkeeoSuAyaio9sDh1+wWj4FYnuKcqI79Shik8Z+dHFWDbU13eA1lvu+OVl2XzCfJOTveLjKe1mN
        FfFpN2+cCZ/CDUveSh8eDzP06Kfe8LwLvltcaZL/RRD58SFHHObLgQrQaCRkDQh+7lXCC+jDK8giY
        KKnown+Ja0icWiDsvsLaJ52Hz/iJhe6yOJ0ie7Eofhcmh2jl0HBSv19cSuD/MkvARClwsCvHwQznS
        eV6gZUSrhFgbxnm1XVhm2TtBn/PiZjEQU8Uvi9qays5feceUwRvbETN0+HdIqc5UvpQBnsRqhRMCH
        P17ohQR53IRyyD20nIi79ZIi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1olrT8-0059si-Vm; Fri, 21 Oct 2022 12:49:47 +0000
Message-ID: <45e4c1c5-273f-413c-972f-e90d0201be24@samba.org>
Date:   Fri, 21 Oct 2022 14:49:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1666346426.git.asml.silence@gmail.com>
 <d4d6f627-46cc-8176-6d52-c93219db8c2f@samba.org>
 <114a0ef7-325d-61c7-dc47-3ecd575fd2bf@gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH for-6.1 0/3] fail io_uring zc with sockets not supporting
 it
In-Reply-To: <114a0ef7-325d-61c7-dc47-3ecd575fd2bf@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.10.22 um 12:42 schrieb Pavel Begunkov:
> On 10/21/22 11:27, Stefan Metzmacher wrote:
>> Hi Pavel,
>>
>>> Some sockets don't care about msghdr::ubuf_info and would execute the
>>> request by copying data. Such fallback behaviour was always a pain in
>>> my experience, so we'd rather want to fail such requests and have a more
>>> robust api in the future.
>>>
>>> Mark struct socket that support it with a new SOCK_SUPPORT_ZC flag.
>>> I'm not entirely sure it's the best place for the flag but at least
>>> we don't have to do a bunch of extra dereferences in the hot path.
>>
>> I'd give the flag another name that indicates msg_ubuf and
> 
> Could be renamed, e.g. SOCK_SUPPORT_MSGHDR_UBUF 

That's good or SOCK_SUPPORT_ZC_MSGHDR_UBUF.

>> have a 2nd flag that can indicate support for SO_ZEROCOPY in sk_setsockopt()
> 
> There is absolutely no reason to introduce a second flag here, it has
> nothing to do with SO_ZEROCOPY.

I meant as a separate change to replace the hard coded logic in
sk_setsockopt()... But I don't care much about it, it's unlikely
that I ever want to use SO_ZEROCOPY...

metze


