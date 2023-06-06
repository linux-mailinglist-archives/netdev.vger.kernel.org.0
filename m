Return-Path: <netdev+bounces-8482-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DF77724409
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:13:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B289A1C21031
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D76C15ACE;
	Tue,  6 Jun 2023 13:11:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CD837B60
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 13:11:18 +0000 (UTC)
X-Greylist: delayed 13263 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Jun 2023 06:11:11 PDT
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEFA119A4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 06:11:11 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4Qb9pN0d91z9snX;
	Tue,  6 Jun 2023 15:11:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686057068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1vXCUfXt+v/tyiznv1i4ek/hjJEHKieI6ggcNC2M+3E=;
	b=NbDSYAIDQUP2KhOy002zZrCYV/D3b325qiRJ2PKeC199lH4XmV9JRBNxMB7302XZdYKnlp
	pbA2k9kd91/JOocFn6FuulrP81WcbO4M3u4vj7Bk8VyINbyXGU5N0F9KucdecHmUjxTee3
	lluwYD5R1R20tlzsXthroZPNqpF7yqxouwhrmWOhwHwTG9EmL1GkorNOM/sgfRkbAKKDCz
	e+TcAOUvBEKVLHTnfrzMeebWOxYzlYLxt3VKCoBIM85Zz2tZyZi9Jw92fAEuLGJg6UrSoO
	r3AfPP/mtT4RRK8AbiLCTFjk2AtESJV1icyoNhL8wwP41WklGVod482Zi+2+Sw==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-6-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 06/12] dcb: app: modify
 dcb_app_table_remove_replaced() for dcb-rewr reuse
Date: Tue, 06 Jun 2023 15:10:51 +0200
In-reply-to: <20230510-dcb-rewr-v3-6-60a766f72e61@microchip.com>
Message-ID: <875y807n2u.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> When doing a replace command, entries are checked against selector and
> protocol. Rewrite requires the check to be against selector and
> priority.
>
> Adapt the existing dcb_app_table_remove_replace function for this, by
> using callback functions for selector, pid and prio checks.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

