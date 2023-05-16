Return-Path: <netdev+bounces-3096-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F367E7056FF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 21:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DFA781C20BE1
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9A042910D;
	Tue, 16 May 2023 19:23:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE012910B
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 19:23:13 +0000 (UTC)
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4857682
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 12:23:10 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1684264988; bh=1p1Bnkvkp8DLKar/WrJYGPKNedFi9A3XCKlu91C48ZE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=sesW/jX8hHUuwQAahPgOyO0h3icjc3LXC+NVuLXWNe3JSgCd4R3ZJPsPK/lAXTOSw
	 tvftalRe+UBvQu8FWLP8VaJPICGJ4E/C5V1O0mS9ALK4LSLk2cDQNEOTE/2KV3gngT
	 1zSXkUgFunhJoYxhIqIl8/LMuJub2XWX8GFTjM3OqcyyHWp8GPK6h5DVWl0dCI/aXu
	 aDbKZJy8ozMmssxNHGnPzEu0jiKM3BOHzkIpEbCAt6Wzq4eHiLDccEaBTXySnorWMf
	 PU13BGzehBUsxDM4xvGmuwWTPiyb1cDE03/3SPrEWK+C36HG/QVPC0/68WCCV9zhEi
	 0sEIxiWJQ/ULw==
To: Thorsten Glaser <t.glaser@tarent.de>, Stephen Hemminger
 <stephen@networkplumber.org>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
 <20230427132126.48b0ed6a@kernel.org>
 <20230427163715.285e709f@hermes.local>
 <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de>
Date: Tue, 16 May 2023 21:23:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <877ct8cc83.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thorsten Glaser <t.glaser@tarent.de> writes:

> On Thu, 27 Apr 2023, Stephen Hemminger wrote:
>
>>On Thu, 27 Apr 2023 13:21:26 -0700
>>Jakub Kicinski <kuba@kernel.org> wrote:
>
>>> Doesn't ring a bell, what's your setup?
>
> Intel NUC with Debian bullseye on it and a custom qdisc that
> limits and delays outgoing traffic, therefore occasionally
> returning NULL from .dequeue even if the qdisc is not empty.
>
> iperf3 sending from the same NUC to a device on the network
> behind that qdisc where the corresponding iperf server runs.
>
>>It might be BQL trying to limit outstanding packets locally.
>
> Possibly?

Sounds like it's TSQ kicking in? The objective of that is to provide the
maximum backpressure against the application socket buffer, precisely so
the application can better react to congestion. Turning that off isn't
going to help your E2E latency, quite the contrary. Pushing stuff into a
qdisc so it can be ECN-marked is also nonsensical for locally generated
traffic; you don't need the ECN roundtrip, you can just directly tell
the local TCP sender to slow down (which is exactly what TSQ does).

-Toke

