Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6A357C1F2
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 03:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiGUBsg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 21:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230304AbiGUBse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 21:48:34 -0400
Received: from mail-m973.mail.163.com (mail-m973.mail.163.com [123.126.97.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 974FB15A14;
        Wed, 20 Jul 2022 18:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=S/t2O
        7Mawm4B2IlPVurMnVZ+xhJpp4xe7u8hL0rAK3o=; b=noi8b5T6XqlJScoaBtp1i
        jgtUEZf3/nUTXoqsbO5XHKNUyFgWWBpidrbG0I9kjHDDTWrryVaf/aOAw1zGNUJ5
        Q9NYXWpMbpbXiZvqlcXbZY+yhHDALQRRt+VYBNiLOBNaMdPDJQORJu/Q7+bbEuIy
        vHGXzF59NB2UT94hQmpm6g=
Received: from localhost.localdomain (unknown [112.95.163.118])
        by smtp3 (Coremail) with SMTP id G9xpCgA33pcqsNhisaGGQQ--.113S2;
        Thu, 21 Jul 2022 09:47:40 +0800 (CST)
From:   LemmyHuang <hlm3280@163.com>
To:     ncardwell@google.com
Cc:     davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        hlm3280@163.com, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, soheil@google.com,
        weiwan@google.com, ycheng@google.com
Subject: Re: [PATCH net-next v2] tcp: fix condition for increasing pingpong count
Date:   Thu, 21 Jul 2022 09:47:21 +0800
Message-Id: <20220721014721.17919-1-hlm3280@163.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <CADVnQynXC=sEiYOcbSJBv2SML8gzooK_xitXt5uOqybTxj-VtQ@mail.gmail.com>
References: <CADVnQynXC=sEiYOcbSJBv2SML8gzooK_xitXt5uOqybTxj-VtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: G9xpCgA33pcqsNhisaGGQQ--.113S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxXrWfAr18KryDXrWkuw15Arb_yoW5GF4UpF
        W8Kr4rCa18Zr10krsIg3WDXry7Ww4FvryxWa18Aw4I934DWr13KFyv9F4ruFyj9F48Kr45
        Xa4qqw42gryUZ37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pi5xhJUUUUU=
X-Originating-IP: [112.95.163.118]
X-CM-SenderInfo: pkopjjiyq6il2tof0z/1tbiSB1F+V+Fe-uqTAAAsV
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At 2022-07-21 02:49:35, "Neal Cardwell" <ncardwell@google.com> wrote:
> On Wed, Jul 20, 2022 at 3:25 AM LemmyHuang <hlm3280@163.com> wrote:
>>
>> When CONFIG_HZ defaults to 1000Hz and the network transmission time is
>> less than 1ms, lsndtime and lrcvtime are likely to be equal, which will
>> lead to hundreds of interactions before entering pingpong mode.
>>
>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
>> Signed-off-by: LemmyHuang <hlm3280@163.com>
>> ---
>> v2:
>>   * Use !after() wrapping the values. (Jakub Kicinski)
>>
>> v1: https://lore.kernel.org/netdev/20220719130136.11907-1-hlm3280@163.com/
>> ---
>>  net/ipv4/tcp_output.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
>> index 858a15cc2..c1c95dc40 100644
>> --- a/net/ipv4/tcp_output.c
>> +++ b/net/ipv4/tcp_output.c
>> @@ -172,7 +172,7 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
>>          * and it is a reply for ato after last received packet,
>>          * increase pingpong count.
>>          */
>> -       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
>> +       if (!after(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
>>             (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
>>                 inet_csk_inc_pingpong_cnt(sk);
>>
>> --
>
> Thanks for pointing out this problem!
> 
> AFAICT this patch would result in incorrect behavior.
> 
> With this patch, we could have cases where tp->lsndtime ==
> icsk->icsk_ack.lrcvtime and (u32)(now - icsk->icsk_ack.lrcvtime) <
> icsk->icsk_ack.ato and yet we do not really have a ping-pong exchange.
> 
> For example, with this patch we could have:
> 
> T1: jiffies=J1; host B receives RPC request from host A
> T2: jiffies=J1; host B sends first RPC response data packet to host A;
>       -> calls inet_csk_inc_pingpong_cnt()
> T3: jiffies=J1; host B sends second RPC response data packet to host A;
>       -> calls inet_csk_inc_pingpong_cnt()
> 
> In this scenario there is only one ping-pong exchange but the code
> calls inet_csk_inc_pingpong_cnt() twice.
> 
> So I'm hoping we can come up with a better fix.
> 
> A simpler approach might be to simplify the model and go back to
> having a single ping-pong interaction cause delayed ACKs to be enabled
> on a connection endpoint. Our team has been seeing good results for a
> while with the simpler approach. What do folks think?
> 
> 
> neal

It seems better to go back.

Look at this revert patch:
https://lore.kernel.org/netdev/20220720233156.295074-1-weiwan@google.com/

