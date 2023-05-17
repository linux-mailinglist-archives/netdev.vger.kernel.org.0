Return-Path: <netdev+bounces-3267-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B215D7064CE
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:00:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 626161C20282
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:00:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FCB156D6;
	Wed, 17 May 2023 10:00:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ABD65258
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:00:29 +0000 (UTC)
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253B840E5
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 03:00:28 -0700 (PDT)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
	t=1684317626; bh=lTk912XRiXGjGOOjLyWtrKUkbrMOLvVOdAXmaxFCD8w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=O8ldOKP2ZMqv+SxKT5fst5Ajip1M2Dm012eRYe8V7/hm6gamNKVlG8Gr4EBA5zxSH
	 RIHgWnPQxcN4/u8Tglp/opcs8SoVVNB8PzXCxtKGucM+DXyd//w8cUNoQkeLf+wMuO
	 k0skGMIjeMZcaiUtgLqXo09r/u/qG1n6taz+stfRp5laoHfkj4ThlGb2M/ugjQjWKk
	 gjqxGbNVUYy7aM4pw1eQD6rlJtFaDye3lm0fnqgpAbz2RZPYw+HN50QWswANKRudNI
	 YYjKSAwoRTnXLRbvWnbM0eoFV3luneKyNR2OlY/2REaEASD46iCBYfRTuYb4YYYEGK
	 J7DOiF5UBKl/Q==
To: Thorsten Glaser <t.glaser@tarent.de>
Cc: Stephen Hemminger <stephen@networkplumber.org>, Jakub Kicinski
 <kuba@kernel.org>, netdev@vger.kernel.org, Haye.Haehne@telekom.de
Subject: Re: knob to disable locally-originating qdisc optimisation?
In-Reply-To: <92a90-421-da6-f85d-133727f3730@tarent.de>
References: <8a8c3e3b-b866-d723-552-c27bb33788f3@tarent.de>
 <20230427132126.48b0ed6a@kernel.org>
 <20230427163715.285e709f@hermes.local>
 <998e27d4-8a-2fd-7495-a8448a5427f9@tarent.de> <877ct8cc83.fsf@toke.dk>
 <b88ee99e-92da-ac90-a726-a79db80f6b4@tarent.de> <87y1loapvt.fsf@toke.dk>
 <92a90-421-da6-f85d-133727f3730@tarent.de>
Date: Wed, 17 May 2023 12:00:26 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87v8grb7lx.fsf@toke.dk>
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

> On Wed, 17 May 2023, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>
>>Well, if it's a custom qdisc you could just call skb_orphan() on the
>>skbs when enqueueing them?
>
> What does that even do? (Yes, I found the comment in skbuff.h that
> passes for documentation. It isn=E2=80=99t comprehensible to an aspiring
> qdisc writer though.)

It detaches the skb from the socket it came from; so from the TCP stack
PoV it will look like the packet left the machine, which should
short-circuit the backpressure thing...

-Toke

