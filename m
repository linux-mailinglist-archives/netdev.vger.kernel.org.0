Return-Path: <netdev+bounces-11440-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA667331F8
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B888928178C
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:14:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58AFB154B8;
	Fri, 16 Jun 2023 13:14:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3CD1113
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:14:34 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B63273F;
	Fri, 16 Jun 2023 06:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=ivCjS5IGfmiD4w4NiMhSejZnj+H+Z4zA2nobydVreB4=; b=eTy7dst5qqgQ5q7WjiIBmA/PWT
	OFaVERWt2pjHODQGyDdNsS6JpqKg7mmfAbk6bWxSh0TSVaMYQ9DkUf27zKLJrlmsuJXQgqtK52aSu
	nzi6gtZxMCo64FyDipb2TMjPpVIZxuQlxoEvOHJTLCXq9HSgnw1g2yo3/sgwnxl6fyvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qA9Ha-00Gikv-KH; Fri, 16 Jun 2023 15:14:30 +0200
Date: Fri, 16 Jun 2023 15:14:30 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: FUJITA Tomonori <fujita.tomonori@gmail.com>
Cc: kuba@kernel.org, netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
	aliceryhl@google.com, miguel.ojeda.sandonis@gmail.com
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <f28d6403-d042-4ffb-9872-044388d0f9d9@lunn.ch>
References: <20230614230128.199724bd@kernel.org>
 <8e9e2908-c0da-49ec-86ef-b20fb3bd71c3@lunn.ch>
 <20230615190252.4e010230@kernel.org>
 <20230616.220220.1985070935510060172.ubuntu@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616.220220.1985070935510060172.ubuntu@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> I use kfree_skb_reason() because dev_kfree_skb() is a macro so it
> can't be called directly from Rust. But I should have used
> dev_kfree_skb() with a helper function.

I think this is something you need to get addressed at a language
level very soon. Lots of netdev API calls will be to macros. The API
to manipulate skbs is pretty much always used on the hot path, so i
expect that it will have a large number of macros. It is unclear to me
how well it will scale if you need to warp them all?

~/linux/include/linux$ grep inline skbuff.h  | wc
    349    2487   23010

Do you really want to write 300+ wrappers?

   Andrew

