Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85D934DCA70
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbiCQPue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236111AbiCQPud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:50:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9667E16C0BE;
        Thu, 17 Mar 2022 08:49:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 205EF60A6E;
        Thu, 17 Mar 2022 15:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418D1C340E9;
        Thu, 17 Mar 2022 15:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647532155;
        bh=39WOdItQPncrBfBOVg70lSymz1ZRnCZdrAsfpCgeCSo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CgimuLip+qZZ7z0z9107pVgTWr4QJGehQ6vG71jD1abdpG7RRj9tPxx7M/SJaEiXa
         7X/XoTA2wetDwNHTmpnClTJ+RQrAagUlbtcTOX0JBrAKBBOssXTSivDLjwrv7tH7UQ
         vz9EiVmtXKmd8L4a4RMqX0KTfLy4zUjb/+8ODJ5xbC370uOxISjy2TVvGl7ExVjCFt
         WHbqYEDiiCyi53C02Klqk9MNlzlSY22X51Rz9Wv79lS0NoHtR9u3mAQNGug/N8cMSL
         2ycqCdWnNANonsqyn5thFH4iSkYl3KY8jD9qMfjJtCC935SneU3iMfFKNVM9w8c5es
         5tJPc741pY2hQ==
Message-ID: <be15a412-5abb-7175-57dc-04418885f439@kernel.org>
Date:   Thu, 17 Mar 2022 09:49:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "menglong8.dong@gmail.com" <menglong8.dong@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "xeb@mail.ru" <xeb@mail.ru>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "talalahmad@google.com" <talalahmad@google.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "flyingpeng@tencent.com" <flyingpeng@tencent.com>,
        "mengensun@tencent.com" <mengensun@tencent.com>,
        "dongli.zhang@oracle.com" <dongli.zhang@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "benbjiang@tencent.com" <benbjiang@tencent.com>
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com>
 <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org>
 <20220316210534.06b6cfe0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <f787c35b-0984-ecaf-ad97-c7580fcdbbad@kernel.org>
 <b08e2dc3e0694068a1a9d698475f8992@AcuMS.aculab.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <b08e2dc3e0694068a1a9d698475f8992@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/22 8:53 AM, David Laight wrote:
> From: David Ahern
>> Sent: 17 March 2022 14:49
>>
>> On 3/16/22 10:05 PM, Jakub Kicinski wrote:
>>> On Wed, 16 Mar 2022 21:35:47 -0600 David Ahern wrote:
>>>> On 3/16/22 9:18 PM, Jakub Kicinski wrote:
>>>>>
>>>>> I guess this set raises the follow up question to Dave if adding
>>>>> drop reasons to places with MIB exception stats means improving
>>>>> the granularity or one MIB stat == one reason?
>>>>
>>>> There are a few examples where multiple MIB stats are bumped on a drop,
>>>> but the reason code should always be set based on first failure. Did you
>>>> mean something else with your question?
>>>
>>> I meant whether we want to differentiate between TYPE, and BROADCAST or
>>> whatever other possible invalid protocol cases we can get here or just
>>> dump them all into a single protocol error code.
>>
>> I think a single one is a good starting point.
> 
> I remember looking at (I think) the packet drop stats a while back.
> Two machines on the same LAN were reporting rather different values.
> Basically 0 v quite a few.
> 
> It turned out that passing the packets to dhcp was deemed enough
> to stop them being reported as 'dropped'.
> And I think that version of dhcp fed every packed into its BPF? filter.
> (I never did decide whether that caused every skb to be duplicated.)
> 

I believe it depends on the type of socket. Packet sockets - e.g.,
running lldpd or tcpdump - do cause every packet to be cloned and kills
performance.

