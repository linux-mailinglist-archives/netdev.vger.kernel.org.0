Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0D4E57C889
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 12:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbiGUKE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 06:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233046AbiGUKE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 06:04:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5885649B5C;
        Thu, 21 Jul 2022 03:04:54 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id bu1so1503189wrb.9;
        Thu, 21 Jul 2022 03:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=gDu/hT+VQwJWrUSGV6A14r2fpQqdJ2GdOdrqIPA0bxY=;
        b=NFCkY3ik4eRaELWJyT4sNJvuDd7HWyDz84JGuPoSn96suLGeo8myt51/Ps2no+g8I5
         5MnoGLblHNwYeyw8HM/fWK+Rkxid3mD9iS7CiV5knT/0jPO28yK/GRllzDgz5UKMyU8N
         ePysAimtcCLxCwyDSgzSPZKJszaoTAsKT+LTVLYv8XSaOgWYgfw73eSpd3b60S4tArRL
         2tDpbnwPC8vS/ot1exS273UVhxKbUV+xsO2W0YrRF3kdPjF3M286qDdQutsG43fqn1pc
         sHMz664/I54fNHTuDmsgpulm+gl00jhZ+2JsaAR756ArWQLomBQEj3fWDBFbwQi9BJsf
         mA/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=gDu/hT+VQwJWrUSGV6A14r2fpQqdJ2GdOdrqIPA0bxY=;
        b=qTDKVU9y6Gar6P+VetMOrvZ6ZwDeV1Z4s9bfpD+GTMRsk2xvTJVJwSx/E5FLfSBPU3
         aoCV44D5T6kxoy8zD7hQwxDPlu+i0+JL/KiZ97E8neYsj4Vhi20/dWo1RJrAwuaN5Ywc
         eKc12yiDbukMS4s/zvn/xomydOxkEraSrnOoYA2zKhf1KDLPK5iv7lSB8/NKMZKwFfLM
         iik9sP2rJifWPNqtv9D542bMm4++AK80hLvQIvqKTUOYCl7pRbR18KEo0S/dGcW7UaKu
         9x2N3iuRQimJCNW8mf24oWyQzsL2dGStdrd8d8mOkHQWXtFkWE70SowzUATUovAzlHXh
         vngA==
X-Gm-Message-State: AJIora/WnkLD0DoJD0lyzwaBLKXsgQ1DUOfLhKYrQkrWDoiUQ187cENs
        62P8ES1rXxA83y/hA9UIDFY=
X-Google-Smtp-Source: AGRyM1uUbDulSeS4rnCwd85OyAGNoKS35j1myvr3UaAAUGIVopoRWhc+VkZbvKy6k6WzGbftNtmO6g==
X-Received: by 2002:adf:fbc3:0:b0:21e:3c88:2aa1 with SMTP id d3-20020adffbc3000000b0021e3c882aa1mr9813714wrs.84.1658397892637;
        Thu, 21 Jul 2022 03:04:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::22ef? ([2620:10d:c093:600::1:b610])
        by smtp.gmail.com with ESMTPSA id b4-20020a05600c150400b003a2fb1224d9sm1267027wmg.19.2022.07.21.03.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jul 2022 03:04:52 -0700 (PDT)
Message-ID: <7eea5714-29a7-c6e6-5f36-3c7754806c8d@gmail.com>
Date:   Thu, 21 Jul 2022 11:03:47 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH net-next v5 01/27] ipv4: avoid partial copy for zc
To:     Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
        kernel-team@fb.com
References: <cover.1657643355.git.asml.silence@gmail.com>
 <0eb1cb5746e9ac938a7ba7848b33ccf680d30030.1657643355.git.asml.silence@gmail.com>
 <20220718185413.0f393c91@kernel.org>
 <CA+FuTSf0+cJ9_N_xrHmCGX_KoVCWcE0YQBdtgEkzGvcLMSv7Qw@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CA+FuTSf0+cJ9_N_xrHmCGX_KoVCWcE0YQBdtgEkzGvcLMSv7Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/22 10:35, Willem de Bruijn wrote:
> On Tue, Jul 19, 2022 at 3:54 AM Jakub Kicinski <kuba@kernel.org> wrote:
>>
>> On Tue, 12 Jul 2022 21:52:25 +0100 Pavel Begunkov wrote:
>>> Even when zerocopy transmission is requested and possible,
>>> __ip_append_data() will still copy a small chunk of data just because it
>>> allocated some extra linear space (e.g. 148 bytes). It wastes CPU cycles
>>> on copy and iter manipulations and also misalignes potentially aligned
>>> data. Avoid such coies. And as a bonus we can allocate smaller skb.
>>
>> s/coies/copies/ can fix when applying
>>
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   net/ipv4/ip_output.c | 8 ++++++--
>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
>>> index 00b4bf26fd93..581d1e233260 100644
>>> --- a/net/ipv4/ip_output.c
>>> +++ b/net/ipv4/ip_output.c
>>> @@ -969,7 +969,6 @@ static int __ip_append_data(struct sock *sk,
>>>        struct inet_sock *inet = inet_sk(sk);
>>>        struct ubuf_info *uarg = NULL;
>>>        struct sk_buff *skb;
>>> -
>>>        struct ip_options *opt = cork->opt;
>>>        int hh_len;
>>>        int exthdrlen;
>>> @@ -977,6 +976,7 @@ static int __ip_append_data(struct sock *sk,
>>>        int copy;
>>>        int err;
>>>        int offset = 0;
>>> +     bool zc = false;
>>>        unsigned int maxfraglen, fragheaderlen, maxnonfragsize;
>>>        int csummode = CHECKSUM_NONE;
>>>        struct rtable *rt = (struct rtable *)cork->dst;
>>> @@ -1025,6 +1025,7 @@ static int __ip_append_data(struct sock *sk,
>>>                if (rt->dst.dev->features & NETIF_F_SG &&
>>>                    csummode == CHECKSUM_PARTIAL) {
>>>                        paged = true;
>>> +                     zc = true;
>>>                } else {
>>>                        uarg->zerocopy = 0;
>>>                        skb_zcopy_set(skb, uarg, &extra_uref);
>>> @@ -1091,9 +1092,12 @@ static int __ip_append_data(struct sock *sk,
>>>                                 (fraglen + alloc_extra < SKB_MAX_ALLOC ||
>>>                                  !(rt->dst.dev->features & NETIF_F_SG)))
>>>                                alloclen = fraglen;
>>> -                     else {
>>> +                     else if (!zc) {
>>>                                alloclen = min_t(int, fraglen, MAX_HEADER);
>>
>> Willem, I think this came in with your GSO work, is there a reason we
>> use MAX_HEADER here? I thought MAX_HEADER is for headers (i.e. more or
>> less to be reserved) not for the min amount of data to be included.
>>
>> I wanna make sure we're not missing something about GSO here.
>>
>> Otherwise I don't think we need the extra branch but that can
>> be a follow up.

I brought it up before but left it for later as I don't know workloads
and there might be perf implications. I'll send a follow up.

> The change was introduced for UDP GSO, to avoid copying most payload
> on software segmentation:
> 
> "
> commit 15e36f5b8e982debe43e425d2e12d34e022d51e9
> Author: Willem de Bruijn <willemb@google.com>
> Date:   Thu Apr 26 13:42:19 2018 -0400
> 
>      udp: paged allocation with gso
> 
>      When sending large datagrams that are later segmented, store data in
>      page frags to avoid copying from linear in skb_segment.
> "
> 
> and in code
> 
> -                       else
> -                               alloclen = datalen + fragheaderlen;
> +                       else if (!paged)
> +                               alloclen = fraglen;
> +                       else {
> +                               alloclen = min_t(int, fraglen, MAX_HEADER);
> +                               pagedlen = fraglen - alloclen;
> +                       }
> 
> 
> MAX_HEADER was a short-hand for the exact header length. "alloclen =
> fragheaderlen + transhdrlen;" is probably a better choice indeed.

Great, thanks for taking a look!

> 
> Whether with branch or without, the same change needs to be made to
> __ip6_append_data, just as in the referenced commit. Let's keep the
> stacks in sync.

__ip6_append_data() is changed as well but in the following patch.
I had doubts whether it's preferable to keep ipv4 and ipv6 changes
separately.

> This is tricky code. If in doubt, run the msg_zerocopy and udp_gso
> tests from tools/testing/selftests/net, ideally with KASAN.

-- 
Pavel Begunkov
