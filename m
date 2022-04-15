Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 154AE502DEC
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355957AbiDOQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355962AbiDOQq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:46:56 -0400
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net (zg8tmty1ljiyny4xntqumjca.icoremail.net [165.227.154.27])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id 88440E1
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:44:20 -0700 (PDT)
Received: from XMCDN1207038 (unknown [58.23.249.10])
        by app1 (Coremail) with SMTP id xjNnewCnMjDhoFliQh0TAA--.2S2;
        Sat, 16 Apr 2022 00:44:17 +0800 (CST)
From:   "Pengcheng Yang" <yangpc@wangsu.com>
To:     "'Neal Cardwell'" <ncardwell@google.com>
Cc:     "'Eric Dumazet'" <edumazet@google.com>,
        "'Yuchung Cheng'" <ycheng@google.com>, <netdev@vger.kernel.org>
References: <1649847244-5738-1-git-send-email-yangpc@wangsu.com> <CADVnQymBgfzsyqdnm81bGiA6j=Kb96Ekz0XcYiUR2p-+tLbO6g@mail.gmail.com>
In-Reply-To: <CADVnQymBgfzsyqdnm81bGiA6j=Kb96Ekz0XcYiUR2p-+tLbO6g@mail.gmail.com>
Subject: Re: [PATCH net-next] tcp: ensure to use the most recently sent skb when filling the rate sample
Date:   Sat, 16 Apr 2022 00:44:16 +0800
Message-ID: <000001d850e8$0c5743f0$2505cbd0$@wangsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQHdjvL7l/qY7xKyGX593ZRM3WmB3wGpFfo3rNljNNA=
Content-Language: zh-cn
X-CM-TRANSID: xjNnewCnMjDhoFliQh0TAA--.2S2
X-Coremail-Antispam: 1UD129KBjvJXoW7CryrGw4fur1ftFWfZF1fWFg_yoW8ur43pF
        W5Ka1q9r1kAFW8trsFvw4UZF4rCw4fAr15Wr1vkr1jkwn8X3yjqF4kKw47G3WrWrs7GF4I
        qan0g3s8Xas8ZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkCb7Iv0xC_KF4lb4IE77IF4wAFc2x0x2IEx4CE42xK8VAvwI8I
        cIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2
        AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v2
        6r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv6xkF7I0E14
        v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xf
        McIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7
        v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lc2xSY4AK67AK6r1l42xK82IYc2Ij64vIr41l42xK
        82IY6x8ErcxFaVAv8VW5Jr1UJr1UMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
        AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCI
        c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
        AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
        Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUI_OzUU
        UUU
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 15, 2022 at 12:12 AM Neal Cardwell <ncardwell@google.com> wrote:
> 
> On Wed, Apr 13, 2022 at 6:54 AM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > If an ACK (s)acks multiple skbs, we favor the information
> > from the most recently sent skb by choosing the skb with
> > the highest prior_delivered count.
> > But prior_delivered may be equal, because tp->delivered only
> > changes when receiving, which requires further comparison of
> > skb timestamp.
> >
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
> 
> Thank you for posting this patch! I agree there is a bug there, and
> your patch is an improvement. However, I think this patch is not a
> complete solution, since it does not handle the case where there are
> multiple skbs with the tcp_skb_timestamp_us() (which can happen if a
> outgoing buffered TSO/GSO skb is later split into multiple skbs with
> the same timestamp).
> 
My initial thought was that this case would not affect the correctness of rate_sample,
since the timestamp of these skbs are the same.
So I am confused whether we have to find the *real* most recently (with the highest seq) skb
(at the cost of a little extra cost)?

> RACK has to deal with the same question "which skb was sent first?",
> and already has a solution in tcp_rack_sent_after(). I suggest we
> share code between RACK and tcp_rate_skb_delivered() to make this
> check. This might involve making a copy of tcp_rack_sent_after() in
> include/net/tcp.h, naming the .h copy to tcp_skb_sent_after(), and
> reworking this logic to save and use the sequence number and timestamp
> so that it can use the new tcp_skb_sent_after() helper. After this fix
> propagates to net-next we could later then change RACK to use the new
> tcp_skb_sent_after() function, so we have a single helper used in two
> places.
> 

Ok. I will send the V2 later according to your suggestion. Thanks neal.

> If you want to post a version of this patch that uses some approach
> like that, IMHO that would be welcome. If you do not have cycles, I am
> happy to post one when I get a moment.
> 
> thanks,
> neal

