Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D06581A13
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 21:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239738AbiGZTF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 15:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238984AbiGZTFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 15:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16F9655F
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 12:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6CBE36152D
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 19:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73BFCC433C1;
        Tue, 26 Jul 2022 19:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658862353;
        bh=VwyU2NU2e2g9UgdbZKau8yDupQZ+eKHou94Ybe1gZsA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SNeIU+VCsj0D2vUrN0IsTNy28SlADuyH3+226Wu5kdA80WlEeENigrZsu8B17IoBe
         GBeU/lZl02KaN3tiR8qb05MIT/rhjBnC8OsG5HuL2PV8uvAi0nCBeOsvzZviX4lCk5
         frybke3sTt8iNPRMj4oPNH3Da7ZWelDxQFKhpHWGKJDtNfia70lyG2RFQF9zP5+Csk
         YVYJI7zjLOhMfYrBTlntwC8JBeoMmxzgsCu4ITMZzxJjeLM+z5jSGv0H7CFGNEea5+
         E9G2HdJp17uWiABgK4kOa68BEPe8/jwCa71ch8NkOaMDxj8Qy0YbQKO6wIQzh52x9p
         5BDSBcBohKNFg==
Message-ID: <668b7bc0-6ff5-638f-6693-b7c7666f8f45@kernel.org>
Date:   Tue, 26 Jul 2022 13:05:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH net] tcp: md5: fix IPv4-mapped support
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Brian Vazquez <brianvv@google.com>,
        Dmitry Safonov <dima@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>
References: <20220726115743.2759832-1-edumazet@google.com>
 <7c1b68b2-a00d-88a0-45a7-a276fdf4539c@kernel.org>
 <CANn89iKojuwLNCm0ZGeH+E-HjPmobLHt66_O9EhTtm00hXcwSQ@mail.gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <CANn89iKojuwLNCm0ZGeH+E-HjPmobLHt66_O9EhTtm00hXcwSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/26/22 11:57 AM, Eric Dumazet wrote:
> Although fcnal-test.sh uses ~45 minutes currently :/
> Maybe we should make it multi netns and multi threaded to speed up things.
> 
> And/or replace various "sleep 1" with more appropriate sync to make
> this faster and not flaky in case of system load.

There are currently 700+ permutations (800+ if Mike's vrf patch is only
fcnal-test). That's why the script takes a `-t TEST` argument - to only
run a subset.

nettest now has the capability for 1 command to run both client and
server in different namespaces. I have a branch that did the conversion
of fcnal-test.sh; validating the output to ensure no degradation in test
results (not just pass / fail but tests "fail" (negative tests) for the
right reason) took more time than I had. In the end it did not shorten
the test time by any significant margin so lost the motivation to wade
through the output on the before and after.
