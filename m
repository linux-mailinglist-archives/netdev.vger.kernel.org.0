Return-Path: <netdev+bounces-5335-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 308C2710D95
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:49:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9D182814E9
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:49:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25D9D107B9;
	Thu, 25 May 2023 13:49:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1695210797
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:49:49 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E1B186
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 06:49:47 -0700 (PDT)
Date: Thu, 25 May 2023 15:49:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1685022585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZZL81C9ggn2hEh4qTlo6cP8O6ke9kUEPJ3PAd8cMY=;
	b=yXm6ITCORKPakRM+2l/G8DDAUvhGFhZl6bJSlh6zCayt8B9XM5Z5fWnvF2JNSMcBwPLI5n
	dmo2CMhuQAfyrgUfuAC6nH2QHKK62GJj5sWjM1xTW7tSY5F9HmhV+EiZBAaeuw3HefQBkq
	SWJQ6mQH0OtokMdP1bsNBmVU1LwdOTZxlAayHz3vs0crcokEB1Th4I2qCU4DVxNH3UQbKY
	M/Pb2+dXCl272q/HsdSI61xOu0I7zyFfr8f+QhnaVAt4I9r8zH2Y3Z6HoZ4YW3L6CKf2wD
	CiPOiFOu5oUw0cRwCGVELk632douapcNA4I3Hf5Olsuw/kFoCPttWgjMw+Mwhg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1685022585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pDZZL81C9ggn2hEh4qTlo6cP8O6ke9kUEPJ3PAd8cMY=;
	b=IEDl24TjX07HKIqozzUrbGl1Sx2Lrw5pFvLxYTDjI6p007yZOo4GpaZqMw02ZUc2x43hc/
	yrK4YI255KNPPfDw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: Kurt Kanzenbach <kurt@linutronix.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	juri.lelli@redhat.com
Subject: Re: [PATCH net-next] net/core: Enable socket busy polling on -RT
Message-ID: <20230525134943.ifOi8qCa@linutronix.de>
References: <20230523111518.21512-1-kurt@linutronix.de>
 <9e128547a586f1ee122879c616941340455c2f51.camel@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9e128547a586f1ee122879c616941340455c2f51.camel@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023-05-25 13:16:46 [+0200], Paolo Abeni wrote:
> Hi,
Hi Paolo,

> > Suggested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> > Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> 
> The patch looks reasonable to me, but it would be great to hear a
> second opinion from someone from RT side.

I suggested and reviewed this and crafted parts of the commit message
before Kurt sent it. Is this enough or do you look for someone in
particular?

> CC: Juri
> 
> 
> Thanks!
> 
> Paolo

Sebastian

