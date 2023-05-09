Return-Path: <netdev+bounces-1169-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB8476FC76D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A1DF31C20B5C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6631D182B6;
	Tue,  9 May 2023 13:05:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580728BE3
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:05:53 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77B310F6;
	Tue,  9 May 2023 06:05:51 -0700 (PDT)
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1683637550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=66CwgAKwlAwu0o+HSirJnximEw9Bjlm23mz/HWPXU1s=;
	b=hbxyUDBnvdDjCwEe2fKEwFmkPPF3xy/eLmej2wKSXWr0d9f7bb+QqZDpCdayQQQuLelVkk
	TBajaFgXIRDO/ZagO/eatcnJ1gv/rjzhEDcs0VzmdsJ6YgoRM4296eoJYO7YsDmsXx9LuR
	Vzv/C/PAuDiXr/eriryMsopQnD1Jl6wbF6dd3jY2eGg7b1vqKV7US33B3IWgxbQruXg9cg
	FDP77qfEu0rsvW0T6gNk5AgPFmtZ9Z/i84jmz57RQnVO7Y6qgf49rjv3CnkyKDZWKNGmr2
	hu8dgyS3LbSNbPk0ZZbojg5UckR7EHhnzl3agppxpE88rRnekkpV/3voJ3aeOQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1683637550;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=66CwgAKwlAwu0o+HSirJnximEw9Bjlm23mz/HWPXU1s=;
	b=rrH6jhUO5K6/+9ljImq/xGhfEnagn6yN0AbNdNjZ4urlUv98qTkpEpavwlAhkSMUwyWfNs
	C3Dq88rRNZXyxcAw==
To: Jason Xing <kerneljasonxing@gmail.com>, paulmck@kernel.org,
 peterz@infradead.org, bigeasy@linutronix.de, frederic@kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: Re: [PATCH] softirq: let the userside tune the SOFTIRQ_NOW_MASK
 with sysctl
In-Reply-To: <20230410023041.49857-1-kerneljasonxing@gmail.com>
References: <20230410023041.49857-1-kerneljasonxing@gmail.com>
Date: Tue, 09 May 2023 15:05:50 +0200
Message-ID: <87y1lxzmc1.ffs@tglx>
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

On Mon, Apr 10 2023 at 10:30, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
>
> Currently we have two exceptions which could avoid ksoftirqd when
> invoking softirqs: HI_SOFTIRQ and TASKLET_SOFTIRQ. They were introduced
> in the commit 3c53776e29f8 ("Mark HI and TASKLET softirq synchronous")
> which says if we don't mask them, it will cause excessive latencies in
> some cases.

As we are ripping this out, I'll ignore this patch.

