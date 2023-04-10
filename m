Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78086DC7D8
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 16:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjDJOa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 10:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjDJOay (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 10:30:54 -0400
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6448D4C3C;
        Mon, 10 Apr 2023 07:30:50 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=guwen@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VfoSju._1681137045;
Received: from 30.221.131.183(mailfrom:guwen@linux.alibaba.com fp:SMTPD_---0VfoSju._1681137045)
          by smtp.aliyun-inc.com;
          Mon, 10 Apr 2023 22:30:46 +0800
Message-ID: <9f7eeb63-52a0-f83a-2e03-cf97ee419573@linux.alibaba.com>
Date:   Mon, 10 Apr 2023 22:30:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.8.0
Subject: Re: [RFC PATCH net-next v4 0/9] net/smc: Introduce SMC-D-based OS
 internal communication acceleration
To:     Niklas Schnelle <schnelle@linux.ibm.com>, kgraul@linux.ibm.com,
        wenjia@linux.ibm.com, jaka@linux.ibm.com, wintera@linux.ibm.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1679887699-54797-1-git-send-email-guwen@linux.alibaba.com>
 <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
From:   Wen Gu <guwen@linux.alibaba.com>
In-Reply-To: <6156aaad710bc7350cbae6cb821289c8a37f44bb.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-11.2 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Niklas,

On 2023/4/6 01:04, Niklas Schnelle wrote:

> 
> Let me just spell out some details here to make sure we're all on the
> same page.
> 
> You're assuming that GIDs are generated randomly at cryptographic
> quality. In the code I can see that you use get_random_bytes() which as
> its comment explains supplies the same quality randomness as
> /dev/urandom so on modern kernels that should provide cryptographic
> quality randomness and be fine. Might be something to keep in mind for
> backports though.
> 
> The fixed CHID of 0xFFFF makes sure this system identity confusion can
> only occur between SMC-D loopback (and possibly virtio-ism?) never with
> ISM based SMC-D or SMC-R as these never use this CHID value. Correct?

Yes, CHID of 0xFFFF used for SMC-D loopback ensures the GID collision
won't involve ISM based SMC-D or SMC-R.

> 
> Now for the collision scenario above. As I understand it the
> probability of the case where fallback does *not* occur is equivalent
> to a 128 bit hash collision. Basically the random 64 bit GID_A
> concatenated with the 64 bit DMB Token_A needs to just happen to match
> the concatenation of the random 64 bit GID_B with DMB Token_B.

Yes, almost like this.

A very little correction: Token_A happens to match a DMB token in B's
kernel (not necessary Token_B) and Token_B happens to match a DMB token
in A's kernel (not necessary Token_A).

  With
> that interpretation we can consult Wikipedia[0] for a nice table of how
> many random GID+DMB Token choices are needed for a certain collision
> probability. For 128 bits at least 8.2×10^11 tries would be needed just
> to reach a 10^-15 collision probability. Considering the collision does
> not only need to exist between two systems but these also need to try
> to communicate with each other and happen to use the colliding DMBs for
> things to get into the broken fallback case I think from a theoretical
> point of view this sounds like neglible risk to me.
> 
Thanks for the reference data.

> That said I'm more worried about the fallback to TCP being broken due
> to a code bug once the GIDs do match which is already extremely
> unlikely and thus not naturally tested in the wild. Do we have a plan
> how to keep testing that fallback scenario somehow. Maybe with a
> selftest or something?
> 

IIUC, you are worried about the code implementation of fallback when GID
collides but DMB token check works? If so, I think we can provide a way
to set loopback device's GID manually, so that we can inject GID collision
fault to test the code.

> If we can solve the testing part then I'm personally in favor of this
> approach of going with cryptograhically random GID and DMB token. It's
> simple and doesn't depend on external factors and doesn't need a
> protocol extension except for possibly reserving CHID 0xFFFF.
> 
> One more question though, what about the SEID why does that have to be
> fixed and at least partially match what ISM devices use? I think I'm
> missing some SMC protocol/design detail here. I'm guessing this would
> require a protocol change?

SEID related topic will be replied in the next e-mail.
> 
> Thanks,
> Niklas
> 
> [0] https://en.wikipedia.org/wiki/Birthday_attack
> 

Thanks!
Wen Gu
