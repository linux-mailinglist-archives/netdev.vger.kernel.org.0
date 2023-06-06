Return-Path: <netdev+bounces-8520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C92EB724725
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:01:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6950C28105B
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:01:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55EAF209B9;
	Tue,  6 Jun 2023 15:01:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B8BD37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:01:08 +0000 (UTC)
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68894E62
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:00:46 -0700 (PDT)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4QbDDJ2MJRz9smk;
	Tue,  6 Jun 2023 17:00:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
	s=MBO0001; t=1686063616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sef/JkWGtflQgQTl8i95JCIleZsU2tsuifsaxZBG1jI=;
	b=Hb5xPOtg8xGHfZaQxmFSZfirNcPdehe3oHElnryjlyuOqQ5nLVR+epSCHukhdTN8Mz5xVw
	FHxB4Vk1HI73JgQ5/Jb2Cgp9UVJNGVYWWY2zotIE/FrUYwf3AfiyFLqpZ7K9q+Pe0q3Ynm
	+TWkIphxOU1LtIIzTPz3z4D9MzthDUbZeUMfzHD/ZCwo4wjJWIhQxqQLcuX+6QQ6ssmo83
	yRcamu06Gbg6VmyCO4WtH2Lm2lCqpu8ydnOE7trbD+EKmjcAiSGOj5V7W+IonDsNdJQiax
	3Q3KewONEQY7w1Eu49q1MmX2zGrNqTv2zUydb8rzXHkg5CTSwrLuma9n6fH71Q==
References: <20230510-dcb-rewr-v3-0-60a766f72e61@microchip.com>
 <20230510-dcb-rewr-v3-5-60a766f72e61@microchip.com>
From: Petr Machata <me@pmachata.org>
To: Daniel Machon <daniel.machon@microchip.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org,
 petrm@nvidia.com, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH iproute2-next v3 05/12] dcb: app: modify
 dcb_app_print_filtered() for dcb-rewr reuse
Date: Tue, 06 Jun 2023 16:08:46 +0200
In-reply-to: <20230510-dcb-rewr-v3-5-60a766f72e61@microchip.com>
Message-ID: <87o7ls63gh.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 4QbDDJ2MJRz9smk
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Daniel Machon <daniel.machon@microchip.com> writes:

> Where dcb-app requires protocol to be the printed key, dcb-rewr requires
> it to be the priority. Adapt existing dcb-app print functions for this.
>
> dcb_app_print_filtered() has been modified, to take two callbacks; one
> for printing the entire string (pid and prio), and one for the pid type
> (dec, hex, dscp, pcp). This saves us for making one dedicated function
> for each pid type for both app and rewr.
>
> Also, printing the colon is now expected to be handled by the
> print_pid_prio() callback.
>
> Signed-off-by: Daniel Machon <daniel.machon@microchip.com>

Reviewed-by: Petr Machata <me@pmachata.org>

