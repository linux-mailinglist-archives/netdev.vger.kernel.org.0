Return-Path: <netdev+bounces-3125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5804A705A6D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 00:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 376B61C20B57
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E106927205;
	Tue, 16 May 2023 22:11:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D152F101C0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 22:11:09 +0000 (UTC)
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D212696
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:11:03 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1684275062; bh=j/sVPryezJW3c6Le9f1PtOGfzVGL0n1YdEprsvP6p48=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ftucROv1Rt/1W9dLsc5AHoieI/0+gZVGl4gwgdSlif/sWw6BKkbxFy4BdgejOUe3j
	 syrEhxxL8o6VVh+2ly9TZM8VcEWZFjvODalhpkxH7zptUO8s+0lLWARoc1NcmjZKSF
	 5+SFC2XgqtJoBbiUbXn5CiEEOXCU1FrUzKNTSCKhv7XeYRgtJ3xwKPSe043ygi1qrd
	 rCu+77huBtfzZ7782eKQ2VwiLqPTHfFWT8gyyFzZq9xwMfXmKcDLoByyzZDMwCkSrT
	 glEfA+dhvNyKwQFRx8ZVfp36Tq2xUvp39THFSpAnPSVdKFk1NF+HN23TTiwnhRNNxk
	 6WD2sqfv3FBfQ==
To: Thorsten Glaser <t.glaser@tarent.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org, Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
 <20230427132126.48b0ed6a@kernel.org>
 <20230427163715.285e709f@hermes.local>
 <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk>
 <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de>
Date: Wed, 17 May 2023 00:11:02 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87y1loapvt.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thorsten Glaser <t.glaser@tarent.de> writes:

> On Tue, 16 May 2023, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>>Pushing stuff into a
>>qdisc so it can be ECN-marked is also nonsensical for locally generated
>>traffic; you don't need the ECN roundtrip, you can just directly tell
>>the local TCP sender to slow down (which is exactly what TSQ does).
>
> Yes, but the point of this exercise is to develop algorithms which
> react to ECN marking; in production, the RAN BTS will do the marking
> so the sender will not be at the place where congestion happens, so
> adding that kind of insight is not needed.
>
> Some people have asked for the ability to make Linux behave as if
> the sender was remote to ease the test setup (i.e. require one less
> machine), nothing more.

Well, if it's a custom qdisc you could just call skb_orphan() on the
skbs when enqueueing them?

-Toke

