Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530466DFAFA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 18:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbjDLQOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 12:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjDLQOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 12:14:39 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1509618A;
        Wed, 12 Apr 2023 09:14:27 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 1BB4558773FFF; Wed, 12 Apr 2023 18:14:25 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 19FA360D5E706;
        Wed, 12 Apr 2023 18:14:25 +0200 (CEST)
Date:   Wed, 12 Apr 2023 18:14:25 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
In-Reply-To: <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
Message-ID: <689os02o-r5o8-so9-rq11-p62223p87ns3@vanv.qr>
References: <20230406092558.459491-1-pablo@netfilter.org> <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net> <20230412072104.61910016@kernel.org> <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wednesday 2023-04-12 17:22, Matthieu Baerts wrote:
>>> But I don't know how to
>>> make sure this will not have any impact on MPTCP on the userspace side,
>>> e.g. somewhere before calling the socket syscall, a check could be done
>>> to restrict the protocol number to IPPROTO_MAX and then breaking MPTCP
>>> support.
>> 
>> Then again any code which stores the ipproto in an unsigned char will 
>> be broken. A perfect solution is unlikely to exist.

IPPROTO_MPTCP (262) is new, anything using MPTCP is practically new code
for the purposes of discussion, and when MPTCP support is added to some
application, you simply *have to* update any potential uint8 check.

>I wonder if the root cause is not the fact we mix the usage of the
>protocol parameter from the socket syscall (int/s32) and the protocol
>field from the IP header (u8).
>
>To me, the enum is linked to the socket syscall, not the IP header. In
>this case, it would make sense to have a dedicated "MAX" macro for the
>IP header, no?

IPPROTO_MAX (256) was the sensible maximum value [array size]
for both the IP header *and* the socket interface.

Then the socket interface was extended, so IPPROTO_MAX, at the very
least, keeps the meanings it can keep, which is for the one for the
IP header.
Makes me wonder why MPTCP got 262 instead of just 257.

