Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 429391DD99A
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 23:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729492AbgEUVkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 17:40:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726814AbgEUVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 17:40:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92028204EA;
        Thu, 21 May 2020 21:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590097232;
        bh=t46pfvTSAm5NG9ILV3VJpV4OLaQgfc8v6AxGya4hvRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NTz5FR66WQ5HiVZIMZT1HUZ2jCnQSWTaiQK1H1VFvaWLnUfvrRSEvg9dZ60G4bjn/
         XaORpAJlhI/zp+NXBVnJPr54VrmIjxIwQYsveOT6gNaF3AuqRVDeZGr4nLel3AR0EX
         BGCl/IFsUQ+IWzaIoLltVOOSUefKbm5zStqANKTM=
Date:   Thu, 21 May 2020 14:40:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        secdev@chelsio.com
Subject: Re: [PATCH net-next] net/tls: fix race condition causing kernel
 panic
Message-ID: <20200521144030.201a4f22@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c7a03544-89ec-696c-fa71-4a46e99d1e66@chelsio.com>
References: <20200519074327.32433-1-vinay.yadav@chelsio.com>
        <20200519.121641.1552016505379076766.davem@davemloft.net>
        <99faf485-2f28-0a45-7442-abaaee8744aa@chelsio.com>
        <20200520125844.20312413@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0a5d0864-2830-6bc8-05e8-232d10c0f333@chelsio.com>
        <20200521115623.134eeb83@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c7a03544-89ec-696c-fa71-4a46e99d1e66@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 May 2020 02:02:10 +0530 Vinay Kumar Yadav wrote:
> When writer reads pending == 0,
> that means completion is already called complete().
> its okay writer to  initialize completion. When writer reads pending == 1,
> that means writer is going to wait for completion.
> 
> This way, writer is not going to proceed to encrypt next record on CPU0 without complete().

I assume by writer you mean the CPU queuing up the records.

The writer does not wait between records, just before returning to user
space. The writer can queue multiple records then wait.

