Return-Path: <netdev+bounces-11442-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD4573320F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 15:20:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 805651C20FD1
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:20:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85AB616416;
	Fri, 16 Jun 2023 13:20:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77EA6107A0
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 13:20:50 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4369E30C1;
	Fri, 16 Jun 2023 06:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=aJ4cg/zJxu+BjvOu6k2lyvWF8UcI5MJapnrQyLPCANI=; b=YU5tA+ggSlSTbJWGhMNiN84YvS
	bXhA/f3IZPaRbIgFOb5+ALG+nOPwlbmT21W1nLm9hm0xQmVF4m+th5LXdFaUpAktOWkZO72TQLovA
	ORrWOl36a9SenUO9YcIiLnELTfyiSpWEIxFjRhFNcscIJRC4J2ECEAtF+69D6Bg4GmOk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1qA9Nc-00GimK-73; Fri, 16 Jun 2023 15:20:44 +0200
Date: Fri, 16 Jun 2023 15:20:44 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Alice Ryhl <alice@ryhl.io>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	rust-for-linux@vger.kernel.org, aliceryhl@google.com,
	miguel.ojeda.sandonis@gmail.com,
	FUJITA Tomonori <fujita.tomonori@gmail.com>
Subject: Re: [PATCH 0/5] Rust abstractions for network device drivers
Message-ID: <762a7d75-2ed8-4f29-b8e5-c90305275c9e@lunn.ch>
References: <20230613045326.3938283-1-fujita.tomonori@gmail.com>
 <20230614230128.199724bd@kernel.org>
 <0d0eba7d-ac43-d944-d105-008978f4402e@ryhl.io>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d0eba7d-ac43-d944-d105-008978f4402e@ryhl.io>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> As for this being a single function rather than four functions, that's
> definitely a debatable decision. You would only do that if it makes sense to
> merge them together and if you would always assign all of them together. I
> don't know enough about these fields to say whether it makes sense here.

It can actually make sense to do them all together, because the source
of these is likely to be a per CPU data structure protected by a per
CPU sequence lock. You iterate over all CPUs, doing a transaction,
taking the sequence lock, copy the values, and then releasing the
lock. Taking and releases the lock per value is unnecessary expense.

      Andrew

