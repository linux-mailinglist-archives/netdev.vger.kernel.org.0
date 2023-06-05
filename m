Return-Path: <netdev+bounces-8137-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 597AC722E1C
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:00:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C40681C20BD2
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BBD7A22606;
	Mon,  5 Jun 2023 18:00:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA75AD2E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74DCCC433EF;
	Mon,  5 Jun 2023 18:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685988041;
	bh=lZb4iIlfbn3a0MKKXDqoE1jvt5CsqzMShPWBWD/Z20Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=aHkJjnqwuuw6HO1w62WdfmosaFKYQVpMO5Ipx+adjKCTalQnmQUi1MWlkwFiAbNi9
	 usFYsN6LSDtxKVUcVZLEypm1thDhvAIbbZ7vsbmlhyltggHJJ36pjZk/Cs2dkUiMbZ
	 pLNk5p5aFLUedLhBP0OASBDE09IKP5XWRwXDqgq5hvNA6Byf8BUDwgKBaZYeeycISQ
	 N0dg8iYVZYLcQbvE7RWC5/oU2EZ+x1OC+Nn7CLvw5vJ9whXZpWxCIKWLQqOONc7ROd
	 3rYA3HUooYVR3Z6GmtcbWvrVohI14o1jpo5hbjIy1ux8dXt4c50fc0iodz9CR7EN8v
	 B6p2ipB1w9mpQ==
Date: Mon, 5 Jun 2023 11:00:40 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stefan Roesch <shr@devkernel.io>
Cc: io-uring@vger.kernel.org, kernel-team@fb.com, axboe@kernel.dk,
 ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, olivier@trillion01.com
Subject: Re: [PATCH v13 1/7] net: split off __napi_busy_poll from
 napi_busy_poll
Message-ID: <20230605110040.3713a1fb@kernel.org>
In-Reply-To: <qvqwedmpyf3i.fsf@devbig1114.prn1.facebook.com>
References: <20230518211751.3492982-1-shr@devkernel.io>
	<20230518211751.3492982-2-shr@devkernel.io>
	<20230531102644.7f171d48@kernel.org>
	<qvqwedmpyf3i.fsf@devbig1114.prn1.facebook.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 05 Jun 2023 10:47:40 -0700 Stefan Roesch wrote:
> > Can you refactor this further? I think the only state that's kept
> > across "restarts" is the start_time right? So this version is
> > effectively a loop around what ends up being napi_busy_loop_rcu(), no?  
> 
> I'm not sure I understand this correctly. Do you want the start time to
> be a parameter of the function napi_busy_poll_rcu?

The RCU and non-RCU version of this function end up looking very
similar, what I'm asking is to share more code.

