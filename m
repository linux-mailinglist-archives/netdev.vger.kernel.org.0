Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0287D32D903
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 18:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbhCDRwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 12:52:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231229AbhCDRvw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 12:51:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997EC64F1E;
        Thu,  4 Mar 2021 17:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614880271;
        bh=aG75SNcfXkRVidGzRiRyF0zW0p/PnZG1I901bm6c3Bo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZoyzgQiylwjtzR58LxNbMpTye4LyecI24fkluMuDUSUOOf92kYYhohGXWnsOl3f2T
         lj/CAfKAkioD/D8Ql75IFYkIB49PchItuQ2UPaVhMINE/xwMKGtmMqXOfGpS0rapUc
         AeoTB+eemUj03cUS2Bs4q4dTaToDjgl7j3r0E8l/AJ6WVL2LQdcu9rV1kg5o8soyhN
         i2gN6oyBT7xuZCateFCqPYQaXdLHbH8n5Ea7PDgn2zMsp2JQcmMNt4uEOeNjM6Qga3
         xhK/3jhX2GPzf6OjovXGv7OTdbwveyRcJOMOmy5EPNSd53HtwQ6MCvPbThlAe3Tzjg
         aX/Dw7cu0Epbw==
Date:   Thu, 4 Mar 2021 09:51:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zbynek Michl <zbynek.michl@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [regression] Kernel panic on resume from sleep
Message-ID: <20210304095110.7830dce4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com>
References: <CAJH0kmzrf4MpubB1RdcP9mu1baLM0YcN-MXKY41ouFHxD8ndNg@mail.gmail.com>
        <20210302174451.59341082@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAJH0kmyTgLp4rJGL1EYo4hQ_qcd3t3JQS-s-e9FY8ERTPrmwqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 4 Mar 2021 13:50:01 +0100 Zbynek Michl wrote:
> Looks good so far, but need to wait some more time as the issue was irregular.
> 
> Do you have any explanation why the calls disorder caused the panic
> just occasionally?

Depends if kernel attempts to try to send a packet before __alx_open()
finishes. You can probably make it more likely by running trafgen, iperf
or such while suspending and resuming?

> Also, the same (wrong) order I can see in the 3.16 kernel code, but it
> has worked fine with this kernel in all cases. So what is different in
> 5.10?

At some point in between those versions the driver got modified to
allocate and free the NAPI structures dynamically.

I didn't look too closely to find out if things indeed worked 100%
correctly before, but now they will reliably crash on a NULL pointer
dereference if transmission comes before open is done.
