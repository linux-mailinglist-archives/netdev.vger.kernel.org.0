Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A0A66630D
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:51:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbjAKSvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:51:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235844AbjAKSvc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:51:32 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A482835930
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=qbIUuOMsrc7n8pdQLosyUgvZmNYC52zBEK3GRqCUtDQ=; b=LOhvjU8w7/RLw7uJt02IPXR8Jc
        g443fTza/ScEvElQRHf2YCApmNTxkohIAke0kHtmC2do8RTkwQGktbZmmsVypL5MXl9gzAbe5TJ31
        OyTMT6xPRihtnL1b41OwR0GEpnDaIJj/5nJLpU/KJT6xpwGX/+0blYmAGbRpxXG7RE6Y=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFgC7-00012f-4G; Wed, 11 Jan 2023 19:51:27 +0100
Message-ID: <d4cb9d4d-42f6-22ee-1eef-f7be645eb5f3@engleder-embedded.com>
Date:   Wed, 11 Jan 2023 19:51:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 05/10] tsnep: Add XDP TX support
Content-Language: en-US
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-6-gerhard@engleder-embedded.com>
 <f8b1b2afcdaef61c4adb8972e18cb40ad5a4787c.camel@gmail.com>
 <5b719373-beb0-ce8b-7789-b24c01a28eff@engleder-embedded.com>
 <CAKgT0UfFK+eE3MwU3ux1FRjQqpOyh2tNhADKKwsGcxK__t6a8g@mail.gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <CAKgT0UfFK+eE3MwU3ux1FRjQqpOyh2tNhADKKwsGcxK__t6a8g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.23 23:38, Alexander Duyck wrote:
> On Tue, Jan 10, 2023 at 1:07 PM Gerhard Engleder
> <gerhard@engleder-embedded.com> wrote:
>>
>> On 10.01.23 17:56, Alexander H Duyck wrote:
>>> nOn Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>>>> Implement ndo_xdp_xmit() for XDP TX support. Support for fragmented XDP
>>>> frames is included.
>>>>
>>>> Also some const, braces and logic clean ups are done in normal TX path
>>>> to keep both TX paths in sync.
>>>>
>>>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>

<...>

>>>> -static int tsnep_tx_map(struct sk_buff *skb, struct tsnep_tx *tx, int count)
>>>> +static int tsnep_tx_map(const struct sk_buff *skb, struct tsnep_tx *tx,
>>>> +                    int count)
>>>>    {
>>>
>>> This change to const doesn't add anything since this is a static
>>> function. You could probably just skip making this change since the
>>> function will likely be inlined anyway.
>>
>> const was requested for tsnep_xdp_tx_map() during last review round so I
>> added it also here to keep both function similar.
> 
> As a general rule it doesn't add anything to make an argument to a
> static function const unless the callers are also making it a const.
> Otherwise what you end up doing is just adding useless modifiers that
> will be thrown away to the code as the compiler can already take care
> of whatever optimizations it can get out of it.

For me removing const is totally ok. I will remove it as I see no value
for static functions too. Let's see what the next reviewer says ;-)

<...>

>>>> +static int tsnep_xdp_tx_map(const struct xdp_frame *xdpf, struct tsnep_tx *tx,
>>>> +                        const struct skb_shared_info *shinfo, int count,
>>>> +                        enum tsnep_tx_type type)
>>>
>>> Again the const here isn't adding any value since this is a static
>>> function and will likely be inlined into the function below which calls
>>> it.
>>
>> const was requested here during last review round so I added it. It may
>> add some value by detecting some problems at compile time.
> 
> I suppose, but really adding a const attribute here doesn't add much
> here unless you are also going to enforce it at higher levels such as
> the xmit_frame_ring function itself. Also keep in mind that all the
> const would protect is the xdp frame structure itself. It does nothing
> to keep us from modifying the data in the pages and such.

Of course.

Gerhard
