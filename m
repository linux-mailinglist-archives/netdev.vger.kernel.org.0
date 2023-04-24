Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC6C6ED599
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232806AbjDXTyU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232801AbjDXTyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:54:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5E6561B8
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 12:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53B2060FF6
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 19:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD3BC433D2;
        Mon, 24 Apr 2023 19:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682366038;
        bh=7miy+fHkNDdRz63bKGdSyJJYn9JzJDvpNkcZfd0+eOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q+DERBlbL7zkEJf9yk9c8ztUXs11PVdhirg0TkszzSlucgUzqbd+W6QNfaZZfgIOX
         fjDIR6BPAy0dmjtzZ1kaHYX4EW7oD3E/5OIQ0Qjm8Py70VO3dZwJ8VJDKeFzqwzfna
         JhFms75a/LZztM2xGHsHm+oCODIL3P7m/7PaPt7lbyxCs+epSFX+BD5BfabOBt+7lh
         u4Dkm4GIdWDEVaEEwYtnuFOOxT6n1ug4cTb2W0SRM3e2P7eaBeU0IUYTX1fKA1itU9
         rypehFejSyL88z/+scePkUPkgXzkgJbKp9/nwEyefx22X4B4kZxtQ0hkWseY2RPLtB
         7pvIXfL3qzMbw==
Date:   Mon, 24 Apr 2023 12:53:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Feiyang Chen <chris.chenfeiyang@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Help needed: supporting new device with unique register
 bitfields
Message-ID: <20230424125357.55b50cba@kernel.org>
In-Reply-To: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
References: <CACWXhKnjyA8S56idVhSFgH1FLo-qBbpxU_ZBpdnrbvv9_kEY7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Apr 2023 16:19:11 +0800 Feiyang Chen wrote:
> We are hoping to add support for a new device which shares almost
> identical logic with dwmac1000 (dwmac_lib.c, dwmac1000_core.c, and
> dwmac1000_dma.c), but with significant differences in the register
> bitfields (dwmac_dma.h and dwmac1000.h).
> 
> We are seeking guidance on the best approach to support this new
> device. Any advice on how to proceed would be greatly appreciated.
> 
> Thank you for your time and expertise.

There's no recipe on how to support devices with different register
layout :(  You'll need to find the right balance of (1) indirect calls,
(2) if conditions and (3) static description data that's right for you.

Static description data (e.g. putting register addresses in a struct
and using the members of that struct rather than #defines) is probably
the best but the least flexible.

Adding the stmmac maintainers.
