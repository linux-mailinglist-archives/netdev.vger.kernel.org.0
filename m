Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4131A6DFD6E
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 20:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229583AbjDLSZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 14:25:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjDLSZE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 14:25:04 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691ED40D7;
        Wed, 12 Apr 2023 11:25:02 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 010ED587752ED; Wed, 12 Apr 2023 20:24:59 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id F34D560C0978F;
        Wed, 12 Apr 2023 20:24:59 +0200 (CEST)
Date:   Wed, 12 Apr 2023 20:24:59 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
cc:     Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
In-Reply-To: <4fa60957-2718-cac2-4b01-12aaf48b76b4@tessares.net>
Message-ID: <4r3sqop-o651-6o1q-578-o4p519668073@vanv.qr>
References: <20230406092558.459491-1-pablo@netfilter.org> <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net> <20230412072104.61910016@kernel.org> <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net> <689os02o-r5o8-so9-rq11-p62223p87ns3@vanv.qr>
 <4fa60957-2718-cac2-4b01-12aaf48b76b4@tessares.net>
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


On Wednesday 2023-04-12 18:44, Matthieu Baerts wrote:
>
>> Makes me wonder why MPTCP got 262 instead of just 257.
>
>Just in case a uint8 is used somewhere, we fallback to TCP (6):
>
>  IPPROTO_MPTCP & 0xff = IPPROTO_TCP
>
>Instead of IPPROTO_ICMP (1).
>
>We did that to be on the safe side, not knowing all the different
>userspace implementations :)

Silent failure? That's terrible.

	int IPPROTO_MPTCP = 257;
	socket(AF_INET, SOCK_STREAM, (uint8_t)IPPROTO_MPTCP);

on the other hand would immediately fail with EPROTONOSUPP
and make hidden uint8 truncation readily visible.
