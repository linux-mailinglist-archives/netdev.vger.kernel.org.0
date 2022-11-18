Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 837A062F340
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241606AbiKRLGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241478AbiKRLGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:06:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B8E97A80;
        Fri, 18 Nov 2022 03:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4705BB82302;
        Fri, 18 Nov 2022 11:05:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD98FC433D6;
        Fri, 18 Nov 2022 11:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668769542;
        bh=SQE37IdYnZXtLDuTKHoXu2mopWX7N9kLALMt1Oc3qj8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ntYcOXYFouoOVgIUK3a8QDLkw7aa5rNER+b+I/6AFGVGO+oXKObaYJ647Ocmpcjo3
         ikqCINcK1gp8fFnqTq/bs9kgeZAWm3/ixsfhhiVy9tHB5T3DX7dME9O9JYkhVJHEA0
         e9ayLALLzH8pb1NJM5VFy+D/sh5FBzIF6TK4FJPpdXWPdxTxzOjT9xiXOaAQo6cN2i
         j6szvmuqmQUr/GNAZLvsa7PzhlbQskWUqATri9l+ug8yyqNV6QTlAfvSZa4mv9jqE5
         tnUklwagIcuQa6Z8PjIL3k4QRZSp7tSSKyRzOXlp1K6PjYn8zuckZytRGkiZ+Kx5wo
         EPmpztA8dog8A==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7554C7A71CE; Fri, 18 Nov 2022 12:05:39 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Heng Qi <henqqi@linux.alibaba.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>, bpf@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] veth: a couple of fixes
In-Reply-To: <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
References: <cover.1668727939.git.pabeni@redhat.com>
 <edc73e5d5cdb06460aea9931a6c644daa409da48.camel@redhat.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 18 Nov 2022 12:05:39 +0100
Message-ID: <87pmdky130.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paolo Abeni <pabeni@redhat.com> writes:

> On Fri, 2022-11-18 at 00:33 +0100, Paolo Abeni wrote:
>> Recent changes in the veth driver caused a few regressions
>> this series addresses a couple of them, causing oops.
>> 
>> Paolo Abeni (2):
>>   veth: fix uninitialized napi disable
>>   veth: fix double napi enable
>> 
>>  drivers/net/veth.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> @Xuan Zhuo: another option would be reverting 2e0de6366ac1 ("veth:
> Avoid drop packets when xdp_redirect performs") and its follow-up
> 5e5dc33d5dac ("bpf: veth driver panics when xdp prog attached before
> veth_open").
>
> That option would be possibly safer, because I feel there are other
> issues with 2e0de6366ac1, and would offer the opportunity to refactor
> its logic a bit: the napi enable/disable condition is quite complex and
> not used consistently mixing and alternating the gro/xdp/peer xdp check
> with the napi ptr dereference.
>
> Ideally it would be better to have an helper alike
> napi_should_be_enabled(), use it everywhere, and pair the new code with
> some selftests, extending the existing ones.
>
> WDYT?

FWIW, the original commit 2e0de6366ac1 was merged very quickly without
much review; so I'm not terribly surprised it breaks. I would personally
be OK with just reverting it...

-Toke
