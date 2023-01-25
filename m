Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1FD67A88E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 03:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbjAYCCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 21:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjAYCCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 21:02:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50CF14608D;
        Tue, 24 Jan 2023 18:02:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 180A9B816C8;
        Wed, 25 Jan 2023 02:02:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2D5C433D2;
        Wed, 25 Jan 2023 02:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674612156;
        bh=OysG/teDdyaCuEtt+t5sTo0GgqmL5Qu72TTEXNjjvp4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZtXMHQsZDIicItw3DUPv+GNfzTyp1QuwcUuIC/uARBGZDFB1oImgevjjhD0uzfgGK
         2rlqcWfbcOh07YvylSV24CInEz1dHNCDyGr9afJDCzsfYZ+HEluvW/i6AbgO7jxwI4
         fjngshfqLfvvQWOAmTR7BbaZuFeRZRuu3TCa8YIX84QJH7eA/gLxrEakaeNLbOKUqE
         KtERtqYJlPee+GLOtfDJOV9+EioBCLg0FNM5AiTMlvMQI1dfT0c2bGL2Ye0oN5mG8h
         kubU2CVgi24DbqnLljdzsshv7rGORYhypOVhEOq0g0LYGHrCGeEW14jacyuWTzGj4P
         k6jACE6eMTjJA==
Date:   Tue, 24 Jan 2023 18:02:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@kernel.org>
Cc:     Shawn Bohrer <sbohrer@cloudflare.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, makita.toshiaki@lab.ntt.co.jp
Subject: Re: KASAN veth use after free in XDP_REDIRECT
Message-ID: <20230124180230.23ff309e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <87357znztf.fsf@toke.dk>
References: <Y9BfknDG0LXmruDu@JNXK7M3>
        <87357znztf.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Jan 2023 02:54:52 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> However, because the skb->head in this case was allocated from a slab
> allocator, taking a page refcount is not enough to prevent it from being
> freed.
>=20
> I'm not sure how best to fix this. I guess we could try to detect this
> case in the veth driver and copy the data, like we do for skb_share()
> etc. However, I'm not sure how to actually detect this case...

sbk->head_frag ?
