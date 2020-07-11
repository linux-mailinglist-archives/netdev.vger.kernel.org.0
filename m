Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E200521C5A2
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 20:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbgGKSOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 14:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:58920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728507AbgGKSOY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 11 Jul 2020 14:14:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BE4E20748;
        Sat, 11 Jul 2020 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594491263;
        bh=C4F2CENFbh78oJsEaEEuAKtaOqXY1fqsIkGderiL3Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=akfY3X5EhzfmC0E1n9ECTfWogwsLEhG7SAoDP3E8firF3xjDxVbAsTbbUKxJu9Lvs
         I0KFT38VtkyZUGxBHA7LC3eQl27KDE+O80Bk0s8+ip6z2tB1kfBG9VQHXlZ5crK/7k
         Zaqie4utNg+faVOiZR3x/yyWl8sSnttuHNQcVcZk=
Date:   Sat, 11 Jul 2020 11:14:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yahui Chen <goodluckwillcomesoon@gmail.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        steven.zou@intel.com
Subject: Re: [PATCH] xsk: ixgbe: solve the soft interrupt 100% CPU usage
 when xdp rx traffic congestion
Message-ID: <20200711111421.0db76fa9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1594462239-19596-1-git-send-email-goodluckwillcomesoon@gmail.com>
References: <1594462239-19596-1-git-send-email-goodluckwillcomesoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Jul 2020 18:10:38 +0800 Yahui Chen wrote:
> 2. If the wakeup mechanism is used, that is, use the
> `XDP_UMEM_USES_NEED_WAKEUP` flag. This method takes advantage of the
> interrupt delay function of ixgbe skillfully, thus solving the problem
> that the si CPU is always 100%. However, it will cause other problems.
> The port-level flow control will be triggered on 82599, and the pause
> frame will be sent to the upstream sender. This will affect the other
> packet receiving queues of the network card, resulting in the packet
> receiving rate of all queues dropping to 10Kpps.

To me the current behavior sounds correct.. if you don't want pause
frames to be generated you have to disable them completely. The point 
of pause frames is to prevent drops.
