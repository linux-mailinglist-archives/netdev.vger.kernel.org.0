Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD071E31FC
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391800AbgEZWEq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:04:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:48600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389342AbgEZWEp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:04:45 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D54EA208C3;
        Tue, 26 May 2020 22:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590530685;
        bh=I6LuDl7PERKIzz9wssQupDkKyc2WprxlNdUQ4yAugWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YCpJUUkKSX5P5GTnz+jto2WaLeUsKEx3emaBSqGJBqcsAvHbVCL/yllzmE4x47CUo
         +B+QQsZ4HyNs3u+u5SL90xMbNff8vCBAHl3a22nX+gRUHfV5J5h/v0L3Lab46kQUBt
         v168HvW0+WYapq+y3YQe6sNYvPe3ToI5BqVwnWQk=
Date:   Tue, 26 May 2020 15:04:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/3] bnxt_en: Fix accumulation of
 bp->net_stats_prev.
Message-ID: <20200526150443.7a91ce77@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1590442879-18961-2-git-send-email-michael.chan@broadcom.com>
References: <1590442879-18961-1-git-send-email-michael.chan@broadcom.com>
        <1590442879-18961-2-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 May 2020 17:41:17 -0400 Michael Chan wrote:
> We have logic to maintain network counters across resets by storing
> the counters in bp->net_stats_prev before reset.  But not all resets
> will clear the counters.  Certain resets that don't need to change
> the number of rings do not clear the counters.  The current logic
> accumulates the counters before all resets, causing big jumps in
> the counters after some resets, such as ethtool -G.
> 
> Fix it by only accumulating the counters during reset if the irq_re_init
> parameter is set.  The parameter signifies that all rings and interrupts
> will be reset and that means that the counters will also be reset.
> 
> Reported-by: Vijayendra Suman <vijayendra.suman@oracle.com>
> Fixes: b8875ca356f1 ("bnxt_en: Save ring statistics before reset.")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>

Hi Michael! 

Could you explain why accumulating counters causes a jump?
