Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B3E40E83A
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349916AbhIPRoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 13:44:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355827AbhIPRmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C93660EE9;
        Thu, 16 Sep 2021 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631812354;
        bh=rUp0AYw0+aYLGFQ+cIAh74/QQI3oJR2+BzOUg83Fjcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=jbjB5iNNoTrNjHrEmBNMiKJTorOFLwo4Tp+V/6fNPH/CItGdY01tm+VaXlVFpWAn7
         lEHo01kntaYxgaHTOibufKp2HncGWyP2zTKjtUcHgI2I+D1WvWapdyLft8JH0v9Iek
         4UQ05T73q89nEKkA40oFZbqnRmDhHtO1tP5LMR4X5r/rTEOa/mS9c2kLPfL07Vl8nR
         SjENd4w9VIggalYj3IDojfzpq+VoC35zQ3vBoBELhcKKhpR+9yLognlzC3mUHBNI3F
         zd5aAuptvfR6oaoObZ2z43rQjmV5L4IrEvA0FiYfeMSfhv246gZm3BJL9pzZKstvkp
         vlvygPYgXgK4w==
Date:   Thu, 16 Sep 2021 12:12:32 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, bhelgaas@google.com,
        davem@davemloft.net, kuba@kernel.org, anthony.wong@canonical.com,
        netdev@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH net-next v5 3/3] r8169: Implement dynamic ASPM
 mechanism
Message-ID: <20210916171232.GA1624808@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210916154417.664323-4-kai.heng.feng@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 11:44:17PM +0800, Kai-Heng Feng wrote:
> r8169 NICs on some platforms have abysmal speed when ASPM is enabled.
> Same issue can be observed with older vendor drivers.
> 
> The issue is however solved by the latest vendor driver. There's a new
> mechanism, which disables r8169's internal ASPM when the NIC traffic has
> more than 10 packets, and vice versa. 

Obviously this is a *rate*, not an absolute number.  I think you mean
something like "10 packets in 1000ms".

> The possible reason for this is
> likely because the buffer on the chip is too small for its ASPM exit
> latency.
> 
> Realtek confirmed that all their PCIe LAN NICs, r8106, r8168 and r8125
> use dynamic ASPM under Windows. So implement the same mechanism here to
> resolve the issue.
> 
> Also introduce a lock to prevent race on accessing config registers.

Can you please include the bugzilla link where you attached lspci
data?  I think it's this:

  https://bugzilla.kernel.org/show_bug.cgi?id=214307

> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
