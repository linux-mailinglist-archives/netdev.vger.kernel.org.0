Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D427528767
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 16:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244666AbiEPOrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 10:47:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244670AbiEPOrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 10:47:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E0573A5F0;
        Mon, 16 May 2022 07:47:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C0586077B;
        Mon, 16 May 2022 14:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594BBC385AA;
        Mon, 16 May 2022 14:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652712465;
        bh=Tpt8DedwEkOnxWbxtjaHnRXxuWJlxdVeWklSQpueJ+Y=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=vL7kTfTulQ9Kg33T1n6CpC/XII9/bSAExdr6mjNTu/OGRhHJO2b1kekKuu04ME0V/
         9LNziCPLPhSMyke8L5dYRjucx7VhxRC34v4uaY7bKYwO12/GdvLyZQUeWv+cxiLmd9
         g12bQ11koU/rE09ZYHlJVFgThQxgXW9mDQRCkEcg4jOF4ixuC980QzkSiH7RMkUzSr
         6Pd7Ua/+6thWk20QH8qE2XvUg2fETAgz1oeCk++skQGT2GQAh5+V5udrRPpVQFr+8l
         ZalKFMA8j9v9xbPbXF5OMihEjGZSXEXJSHvGsVCSAUe3ehxKlKrtF4OJ/suYYvD8h7
         dZN3b9pcruUIA==
Message-ID: <c0660a42-eb82-1834-6b24-04c122af2311@kernel.org>
Date:   Mon, 16 May 2022 08:47:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next v3 00/10] UDP/IPv6 refactoring
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
References: <cover.1652368648.git.asml.silence@gmail.com>
 <b9025eb4d8a1efefbcd04013cbe8e55e98ef66e1.camel@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <b9025eb4d8a1efefbcd04013cbe8e55e98ef66e1.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/22 7:48 AM, Paolo Abeni wrote:
> Hello,
> 
> On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
>> Refactor UDP/IPv6 and especially udpv6_sendmsg() paths. The end result looks
>> cleaner than it was before and the series also removes a bunch of instructions
>> and other overhead from the hot path positively affecting performance.
>>
>> Testing over dummy netdev with 16 byte packets yields 2240481 tx/s,
>> comparing to 2203417 tx/s previously, which is around +1.6%
> 
> I personally feel that some patches in this series have a relevant
> chance of introducing functional regressions and e.g. syzbot will not
> help to catch them. That risk is IMHO relevant considered that the
> performance gain here looks quite limited.
> 
> There are a few individual changes that IMHO looks like nice cleanup
> e.g. patch 5, 6, 8, 9 and possibly even patch 1.
> 
> I suggest to reduce the patchset scope to them.
> 

I agree with that sentiment. The set also needs testcases that captures
the various permutations.
