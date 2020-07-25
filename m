Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2810F22D367
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:56:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:56:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgGYA4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 20:56:13 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13C7A20674;
        Sat, 25 Jul 2020 00:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595638573;
        bh=mgG3SAbFmw/jSEX0DL/1lz7sofkUHvtlYADqrHHDwt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bf3u2KXTGo8ObsKDeKNIB91NbY8ZgrXlfEJZPz8UVBbpRNApd1nsak2hDa8r5nF5t
         s5a8jI8WZ7+IJIwJ7Zh/QN4qhDqrhMRm12uRng8CGy0hIRlHMmfGDlHfVa46VVAg3m
         imhmcQgu+DH2vET8TPAqTTk2QLwkHE/1z4+MTvy0=
Date:   Fri, 24 Jul 2020 17:56:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next 4/4] ionic: separate interrupt for Tx and Rx
Message-ID: <20200724175611.7b514bb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200725002326.41407-5-snelson@pensando.io>
References: <20200725002326.41407-1-snelson@pensando.io>
        <20200725002326.41407-5-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 17:23:26 -0700 Shannon Nelson wrote:
> Add the capability to split the Tx queues onto their own
> interrupts with their own napi contexts.  This gives the
> opportunity for more direct control of Tx interrupt
> handling, such as CPU affinity and interrupt coalescing,
> useful for some traffic loads.
> 
> To enable, use the ethtool private flag:
> 	ethtool --set-priv-flag enp20s0 split-q-intr on
> To restore defaults
> 	ethtool --set-priv-flag enp20s0 split-q-intr off
> 
> When enabled, the number of queues is cut in half in order
> to reuse the interrupts that have already been allocated to
> the device.  When disabled, the queue count is restored.
> 
> Signed-off-by: Shannon Nelson <snelson@pensando.io>

Splitting queues into tx-only and rx-only is done like this:

ethtool -L enp20s0 rx N tx N combined 0

And then back to combined:

ethtool -L enp20s0 rx 0 tx 0 combined N

No need for a private flag here.
