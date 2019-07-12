Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B407467258
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 17:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfGLP34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 11:29:56 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:57008 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726602AbfGLP3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 11:29:55 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us2.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D528E8007F;
        Fri, 12 Jul 2019 15:29:53 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 12 Jul
 2019 08:29:50 -0700
Subject: Re: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Andreas Steinmetz <ast@domdv.de>
References: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
 <62ad16f6-c33a-407e-2f55-9be382b7ec52@solarflare.com>
 <20190710224724.GA28254@bistromath.localdomain>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <8166b82f-8430-1441-32e7-540c1829754e@solarflare.com>
Date:   Fri, 12 Jul 2019 16:29:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190710224724.GA28254@bistromath.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24752.005
X-TM-AS-Result: No-1.938900-4.000000-10
X-TMASE-MatchedRID: oTBA/+sdKaZq0U6EhO9EE/ZvT2zYoYOwC/ExpXrHizwjE50lK5mkcr5B
        EqXwSs2U/SwzVfmaVyi3UjDQwv33/51hFxH/AojTiJwEp8weVXwA+JHhu0IR5lB3AZ+9IiUHB8b
        SKPQiB8D4DNV0STkz8jEtvhjEb953oayr11+eKrmt0sUUpHt26QstW3p1HyQN31GU/N5W5BBjCg
        n4e64coos5xsJNI/ndm2lhSbqhqibwWrPthczFTczSKGx9g8xhfS0Ip2eEHnzWRN8STJpl3PoLR
        4+zsDTt+GYUedkXNWrsobwFcvEgluSAYS9sRv/BmkffCWyYNOS2OL0ktwPTmFEACJ4CqAAp/6Um
        1O6eCIXWsezgxn1i9oL+6MVA+fBiRIDtcsZe84GHzGTHoCwyHhlNKSp2rPkW5wiX7RWZGYs2CWD
        RVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.938900-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24752.005
X-MDID: 1562945394-5jCPy2r2QDg0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/07/2019 23:47, Sabrina Dubroca wrote:
> 2019-07-10, 16:07:43 +0100, Edward Cree wrote:
>> On 10/07/2019 14:52, Sabrina Dubroca wrote:
>>> -static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
>>> +static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
>>>  				    struct packet_type **ppt_prev)
>>>  {
>>>  	struct packet_type *ptype, *pt_prev;
>>>  	rx_handler_func_t *rx_handler;
>>> +	struct sk_buff *skb = *pskb;
>> Would it not be simpler just to change all users of skb to *pskb?
>> Then you avoid having to keep doing "*pskb = skb;" whenever skb changes
>>  (with concomitant risk of bugs if one gets missed).
> Yes, that would be less risky. I wrote a version of the patch that did
> exactly that, but found it really too ugly (both the patch and the
> resulting code).
If you've still got that version (or can dig it out of your reflog), can
 you post it so we can see just how ugly it turns out?

>  We have more than 50 occurences of skb, including
> things like:
>
>     atomic_long_inc(&skb->dev->rx_dropped);
Ooh, yes, I can see why that ends up looking funny...

Here's a thought, how about switching round the return-vs-pass-by-pointer
 and writing:

static struct sk_buff *__netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
                                                struct packet_type **ppt_prev, int *ret)
?
(Although, you might want to rename 'ret' in that case.)

Does that make things any less ugly?
-Ed

