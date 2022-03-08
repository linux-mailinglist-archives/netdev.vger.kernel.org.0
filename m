Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7A74D1FEC
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349451AbiCHSTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:19:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234608AbiCHSTT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:19:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE2A02EF;
        Tue,  8 Mar 2022 10:18:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794236157C;
        Tue,  8 Mar 2022 18:18:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7CBC340EB;
        Tue,  8 Mar 2022 18:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646763500;
        bh=hfliW31AVRSU5p6jjAxSw1HcKyAHEKOmAwFZjydld00=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BhEHsqr3EDTXwEIBwWtIIb/LdCdEwCx9P3HaPD+EkCBnAmRPkzSpaFvJGs84nFuZW
         f4reBJEEPm8T4qO7GUn1rTm5pX0t1NW/dZPlVc4s4BZHn8gYAfkLT43xAJSm7fDVaL
         tVFk4gqmjoMOZwpdDdHb/dSIwlSYXMmemtDirUm4gJaeFnjhgT0aQKSPNcdcvWMF0I
         UzCgdZoI/5/224f43RrsVcOPRbzBPan/peHqSnTCCm/qzMaaVh2fN3rHX+ucCV4Bcb
         rBZbbrcmq6IhOaD8B8F8ciFQJlJ8Yb6guJixW21bJJCSCE9uuIewLYPPuAEGCXk9hY
         aUySQg3RkP+0A==
Message-ID: <66463e26-8564-9f58-ce41-9a2843891d1a@kernel.org>
Date:   Tue, 8 Mar 2022 11:18:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] net: ipv6: fix invalid alloclen in __ip6_append_data
Content-Language: en-US
To:     Tadeusz Struk <tadeusz.struk@linaro.org>,
        David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
References: <20220308000146.534935-1-tadeusz.struk@linaro.org>
 <14626165dad64bbaabed58ba7d59e523@AcuMS.aculab.com>
 <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <6155b68c-161b-0745-b303-f7e037b56e28@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 8:43 AM, Tadeusz Struk wrote:
> Hi David,
> On 3/7/22 18:58, David Laight wrote:
>>> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
>>> index 4788f6b37053..622345af323e 100644
>>> --- a/net/ipv6/ip6_output.c
>>> +++ b/net/ipv6/ip6_output.c
>>> @@ -1629,6 +1629,13 @@ static int __ip6_append_data(struct sock *sk,
>>>                   err = -EINVAL;
>>>                   goto error;
>>>               }
>>> +            if (unlikely(alloclen < fraglen)) {
>>> +                if (printk_ratelimit())
>>> +                    pr_warn("%s: wrong alloclen: %d, fraglen: %d",
>>> +                        __func__, alloclen, fraglen);
>>> +                alloclen = fraglen;
>>> +            }
>>> +
>> Except that is a valid case, see a few lines higher:
>>
>>                 alloclen = min_t(int, fraglen, MAX_HEADER);
>>                 pagedlen = fraglen - alloclen;
>>
>> You need to report the input values that cause the problem later on.
> 
> OK, but in this case it falls into the first if block:
> https://elixir.bootlin.com/linux/v5.17-rc7/source/net/ipv6/ip6_output.c#L1606
> 
> where alloclen is assigned the value of mtu.
> The values in this case are just before the alloc_skb() are:
> 
> alloclen = 1480
> alloc_extra = 136
> datalen = 64095
> fragheaderlen = 1480
> fraglen = 65575
> transhdrlen = 0
> mtu = 1480
> 

Does this solve the problem (whitespace damaged on paste, but it is just
a code move and removing fraglen getting set twice):

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e69fac576970..59f036241f1b 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1589,6 +1589,15 @@ static int __ip6_append_data(struct sock *sk,

                        if (datalen > (cork->length <= mtu &&
!(cork->flags & IPCORK_ALLFRAG) ? mtu : maxfraglen) - fragheaderlen)
                                datalen = maxfraglen - fragheaderlen -
rt->dst.trailer_len;
+
+                       if (datalen != length + fraggap) {
+                               /*
+                                * this is not the last fragment, the
trailer
+                                * space is regarded as data space.
+                                */
+                               datalen += rt->dst.trailer_len;
+                       }
+
                        fraglen = datalen + fragheaderlen;
                        pagedlen = 0;

@@ -1615,16 +1624,6 @@ static int __ip6_append_data(struct sock *sk,
                        }
                        alloclen += alloc_extra;

-                       if (datalen != length + fraggap) {
-                               /*
-                                * this is not the last fragment, the
trailer
-                                * space is regarded as data space.
-                                */
-                               datalen += rt->dst.trailer_len;
-                       }
-
-                       fraglen = datalen + fragheaderlen;
-
                        copy = datalen - transhdrlen - fraggap - pagedlen;
                        if (copy < 0) {
                                err = -EINVAL;
