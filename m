Return-Path: <netdev+bounces-9920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E56272B2E1
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 18:43:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECC441C2099C
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 16:43:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5E7EC2C2;
	Sun, 11 Jun 2023 16:43:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8625523E
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 16:43:48 +0000 (UTC)
Received: from knopi.disroot.org (knopi.disroot.org [178.21.23.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAEE19B
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 09:43:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id BA6F5408BC;
	Sun, 11 Jun 2023 18:43:45 +0200 (CEST)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from knopi.disroot.org ([127.0.0.1])
	by localhost (disroot.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W_fOXZt3hWNu; Sun, 11 Jun 2023 18:43:44 +0200 (CEST)
Date: Sun, 11 Jun 2023 18:43:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1686501824; bh=4foN/Ph9EUVfqM4rsCwst9YfKYXZQhK8HKOFBrSRPJw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QGxUxfFnym93IpdQptMESBECBXkol54vX8DTda/dspMBR0d/1gjBWSqZWZwp3BU8S
	 onRjCXz3vYcLfmKyPisxNqkG9gnwjq80JNZcG83pYTo4f6pM2j+NymtRNAe3SEp+05
	 0N/dT4DcuX8Zjxj70lXXgoxhJS8/uuX6fcWWwVo3yyTNixWnFqC22hQElavkGuMmI6
	 0Dv6U+OOjpmTZ8mmz5Sf6aIGn39/TBUCRmsy9T3VOBuBoeHU5AJlMLR16NTTytErsH
	 BU1QijpRlJdK0iaqYjK9YQ/5YSV92a7UlQhc7OOZYnNMmzXM8iMgZEZpv2snZa1Eht
	 p3zvDm77zdgDw==
From: Marco Giorgi <giorgi.marco.96@disroot.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: netdev@vger.kernel.org, u.kleine-koenig@pengutronix.de,
 davem@davemloft.net, michael@walle.cc, kuba@kernel.org
Subject: Re: [PATCH RFC net 2/2] nfc: nxp-nci: Fix i2c read on ThinkPad
 hardware
Message-ID: <20230611184342.551cc040@T590-Marco>
In-Reply-To: <84508d22-2dcd-c49f-2424-37a717a49e1b@linaro.org>
References: <20230607170009.9458-1-giorgi.marco.96@disroot.org>
 <20230607170009.9458-3-giorgi.marco.96@disroot.org>
 <84508d22-2dcd-c49f-2424-37a717a49e1b@linaro.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Krzysztof,

On Wed, 7 Jun 2023 19:46:35 +0200
Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org> wrote:

> On 07/06/2023 19:00, Marco Giorgi wrote:
> > Read IRQ GPIO value and exit from IRQ if the device is not ready.
> 
> Why? What problem are you solving?
> 
> Why IRQ GPIO - whatever it is - means device is not ready for I2C
> transfer?

It seems that the I2C IRQ gets triggered also when the IRQ GPIO is not
active (low value).

This patch queries the IRQ GPIO before issuing the I2C read.
If the GPIO is low, the IRQ returns with IRQ_HANDLED.

I don't know why the IRQ is triggered even when the GPIO is low, I'm
still looking into it.

I've submitted this patch in the hope to get feedback from other people
to understand what's going on.

> 
> > 
> > Signed-off-by: Marco Giorgi <giorgi.marco.96@disroot.org>
> > ---
> >  drivers/nfc/nxp-nci/i2c.c | 13 +++++++++++++
> >  1 file changed, 13 insertions(+)
> 
> Best regards,
> Krzysztof
> 

Thanks,
Marco.

