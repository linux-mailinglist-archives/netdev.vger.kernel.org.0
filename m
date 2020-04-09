Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02C801A3A89
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgDITcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbgDITcV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:32:21 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69F4820757;
        Thu,  9 Apr 2020 19:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586460741;
        bh=2eHWQ/4goNgPuFGvtFabW7ncIzGtyqDsPe64tABuLfQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cNtxuLtIYGSMwtXWmzjBWIk0WUJ8Z7/MRAVbsF2tkTfYtlTOcqlsKK9/O64V3XkhC
         3yDXpHXx3WCBI/p59yn3wR2qqQk27rI74cfj2raq9RIH9t6LBSX3Aco7jV1BM7ZYjF
         o1VfDHy6ZpWrQeDDXYjn4bt0OMRWgYzvcUCm9P40=
Date:   Thu, 9 Apr 2020 12:32:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
Cc:     takafumi.kubota1012@sslab.ics.keio.ac.jp, davem@davemloft.net,
        oss-drivers@netronome.com (open list:NETRONOME ETHERNET DRIVERS),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] nfp: Fix memory leak in nfp_resource_acquire()
Message-ID: <20200409123203.1b5f6534@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200409174113.28635-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
References: <20200409150210.15488-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
        <20200409174113.28635-1-keitasuzuki.park@sslab.ics.keio.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Apr 2020 17:41:11 +0000 Keita Suzuki wrote:
> This patch fixes a memory leak in nfp_resource_acquire(). res->mutex is
> alllocated in nfp_resource_try_acquire(). However, when
> msleep_interruptible() or time_is_before_eq_jiffies() fails, it falls
> into err_fails path where res is freed, but res->mutex is not.
> 
> Fix this by changing call to free to nfp_resource_release().

I don't see a leak here. Maybe you could rephrase the description to
make things clearer?

AFAICS nfp_resource_try_acquire() calls nfp_cpp_mutex_free(res->mutex)
if it's about to return an error. We can only hit msleep or time check
if it returned an error.
