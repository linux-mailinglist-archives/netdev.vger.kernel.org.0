Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F693645A52
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 14:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiLGNCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 08:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiLGNCq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 08:02:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800F116498;
        Wed,  7 Dec 2022 05:02:45 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id x22so13755081ejs.11;
        Wed, 07 Dec 2022 05:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fZf8Ip8KDjMA4XH3s9oD0RHIMIP28yiN4IeA3BSkBys=;
        b=qbuHTBWM9ebTxZTC40eXpJqNbiYRpqkNwBpxK1qfZhxoCnVTv3uY2C2rt95ao9+f9c
         D7D/6kCh50WZnHVG+StwEIUmd4BffC+lPwCZGhte7WH4p5+4JQ7qMyWdFIvoMGX9tGA5
         n5f92wwA9pocp0UIMwlzNexXQozK+xycBvaqazhGhSVq+EMpl1GXcRrBJWUaFdIpZ/j3
         E/Mbgr6ckGDE9ZNKX37OHzzyQWaMadtzQeUrLDsMEx3UaxGHtDZXGjN90uAXMX5ti/R3
         hSa2vW/mxgXauanzPc/jLI9SoNjRmbh5peCpqOw1V9Y0O6wtch/O7gXv+2i/LWCFD8eg
         xVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fZf8Ip8KDjMA4XH3s9oD0RHIMIP28yiN4IeA3BSkBys=;
        b=kpvryqibTnVTEQZzaUK3shC2J5vM8Un2AajTG/O+mvgnPsCwRnXdBUV5ESM8cuA6ie
         eNib3jIj7kou4CNYVyrygC6eWfXUOwOj3ZqPg5HHu0ym0t16HrVL0EN3PbM666cGmRr7
         PM/OJTs66IfIbPRrq210lay+c7+EdwpxE/h5TrgBEC0fi0GXnUL1lr/0TKRYsJiXFHm9
         ySmAUBF3RSFLM00D5jojdsu1R1bKXuLGTKuDjoMCOVUdIk8+2kxr4TeZnupulmq+v5pf
         eyNYclx2ttk45+/grFwpkNceT7sO07cu1hjORNvwUTakXPGsUNrUHHhpzjdzMHeEKjHG
         BoBg==
X-Gm-Message-State: ANoB5pnFgq4Ujrk3iU6FMMLdoyt5iZk2ECUHMJvML4pYEAuox5QFLacK
        gPxgRc/Nh4gB/kVweA0O3L4HY7/995GAKw==
X-Google-Smtp-Source: AA0mqf6/yFShyR8oIl+NhzrlP0lxrNuNVPamhMuER9NJefO1n1bE5++74DyReyB9/b2pgVQMjKNxIQ==
X-Received: by 2002:a17:906:94e:b0:7ba:4617:3f17 with SMTP id j14-20020a170906094e00b007ba46173f17mr54627840ejd.226.1670418163916;
        Wed, 07 Dec 2022 05:02:43 -0800 (PST)
Received: from skbuf ([188.26.184.215])
        by smtp.gmail.com with ESMTPSA id k3-20020a17090632c300b007aece68483csm8424367ejk.193.2022.12.07.05.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 05:02:43 -0800 (PST)
Date:   Wed, 7 Dec 2022 15:02:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Dan Carpenter <error27@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] lib: packing: fix shift wrapping in bit_reverse()
Message-ID: <20221207130240.aoojta5n5enec72y@skbuf>
References: <Y5B3sAcS6qKSt+lS@kili>
 <Y5B3sAcS6qKSt+lS@kili>
 <20221207121936.bajyi5igz2kum4v3@skbuf>
 <Y5CFMIGsZmB1TRni@kadam>
 <20221207122254.otq7biekqz2nzhgl@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221207122254.otq7biekqz2nzhgl@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 07, 2022 at 02:22:54PM +0200, Vladimir Oltean wrote:
> Wait a second, I deliberately wrote the code without conditionals.
> Let me look at the code disassembly before and after the patch and see
> what they look like.

Before (make lib/packing.lst on arm64):

	for (i = 0; i < width; i++) {
  1c:	310004ec 	adds	w12, w7, #0x1
  20:	540001c0 	b.eq	58 <adjust_for_msb_right_quirk+0x58>  // b.none
  24:	52800004 	mov	w4, #0x0                   	// #0
		bit = (val & (1 << i)) != 0;
  28:	5280002b 	mov	w11, #0x1                   	// #1
  2c:	d503201f 	nop
  30:	1ac42166 	lsl	w6, w11, w4
		new_val |= (bit << (width - i - 1));
  34:	4b0400e9 	sub	w9, w7, w4
		bit = (val & (1 << i)) != 0;
  38:	93407cc6 	sxtw	x6, w6		/* We don't want sign extension */
  3c:	ea0a00df 	tst	x6, x10
  40:	1a9f07e6 	cset	w6, ne  // ne = any
	for (i = 0; i < width; i++) {
  44:	6b07009f 	cmp	w4, w7
  48:	11000484 	add	w4, w4, #0x1
		new_val |= (bit << (width - i - 1));
  4c:	1ac920c6 	lsl	w6, w6, w9
  50:	aa060108 	orr	x8, x8, x6
	for (i = 0; i < width; i++) {
  54:	54fffee1 	b.ne	30 <adjust_for_msb_right_quirk+0x30>  // b.any


Then this modified code:

static u64 bit_reverse(u64 val, unsigned int width)
{
	u64 new_val = 0;
	unsigned int i;

	for (i = 0; i < width; i++)
		if (val & BIT_ULL(i))
			new_val |= BIT_ULL(width - i - 1);

	return new_val;
}

compiles to this:

	for (i = 0; i < width; i++) {
  1c:	310004eb 	adds	w11, w7, #0x1
  20:	540001c0 	b.eq	58 <adjust_for_msb_right_quirk+0x58>  // b.none
  24:	52800005 	mov	w5, #0x0                   	// #0
			new_val |= BIT_ULL(width - i - 1);
  28:	d280002a 	mov	x10, #0x1                   	// #1
  2c:	14000002 	b	34 <adjust_for_msb_right_quirk+0x34>	/* this is an unconditional jump to "sub w4, w7, w5", skipping the assignment to w5 */
  30:	2a0803e5 	mov	w5, w8			/* this is only hit by the backwards jump b.ne 30 at the end */
  34:	4b0500e4 	sub	w4, w7, w5
		if (val & BIT_ULL(i))
  38:	9ac52528 	lsr	x8, x9, x5
			new_val |= BIT_ULL(width - i - 1);
  3c:	f240011f 	tst	x8, #0x1
	for (i = 0; i < width; i++) {
  40:	110004a8 	add	w8, w5, #0x1
			new_val |= BIT_ULL(width - i - 1);
  44:	9ac42144 	lsl	x4, x10, x4
  48:	aa0400c4 	orr	x4, x6, x4
  4c:	9a861086 	csel	x6, x4, x6, ne  // ne = any
	for (i = 0; i < width; i++) {
  50:	6b0700bf 	cmp	w5, w7
  54:	54fffee1 	b.ne	30 <adjust_for_msb_right_quirk+0x30>  // b.any

which indeed has no branch in the main loop (between 0x30 and 0x54),
because as I explained, the "b 34" doesn't count - it's not in the loop.

Additionally, this rewritten code which is considerably more obscure in C:

static u64 bit_reverse(u64 val, unsigned int width)
{
	u64 new_val = 0;
	unsigned int i;

	for (i = 0; i < width; i++)
		new_val |= !!(val & BIT_ULL(i)) ?
			   BIT_ULL(width - i - 1) : 0;

	return new_val;
}

compiles to the exact same assembly code as the variant with "if":

	for (i = 0; i < width; i++)
  1c:	310004eb 	adds	w11, w7, #0x1
  20:	540001c0 	b.eq	58 <adjust_for_msb_right_quirk+0x58>  // b.none
  24:	52800005 	mov	w5, #0x0                   	// #0
		new_val |= !!(val & BIT_ULL(i)) ?
  28:	d280002a 	mov	x10, #0x1                   	// #1
  2c:	14000002 	b	34 <adjust_for_msb_right_quirk+0x34>
  30:	2a0803e5 	mov	w5, w8
  34:	4b0500e4 	sub	w4, w7, w5
  38:	9ac52528 	lsr	x8, x9, x5
  3c:	f240011f 	tst	x8, #0x1
	for (i = 0; i < width; i++)
  40:	110004a8 	add	w8, w5, #0x1
		new_val |= !!(val & BIT_ULL(i)) ?
  44:	9ac42144 	lsl	x4, x10, x4
  48:	aa0400c4 	orr	x4, x6, x4
  4c:	9a861086 	csel	x6, x4, x6, ne  // ne = any
	for (i = 0; i < width; i++)
  50:	6b0700bf 	cmp	w5, w7
  54:	54fffee1 	b.ne	30 <adjust_for_msb_right_quirk+0x30>  // b.any

So this is good with the "if".
