Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC318C5B2
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 04:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCTDYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 23:24:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46282 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCTDYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 23:24:23 -0400
Received: from localhost (c-73-193-106-77.hsd1.wa.comcast.net [73.193.106.77])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B05EE158EC765;
        Thu, 19 Mar 2020 20:24:22 -0700 (PDT)
Date:   Thu, 19 Mar 2020 20:24:12 -0700 (PDT)
Message-Id: <20200319.202412.154737138482561630.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net] mlxsw: pci: Only issue reset when system is ready
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200319112539.1030494-1-idosch@idosch.org>
References: <20200319112539.1030494-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 20:24:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Thu, 19 Mar 2020 13:25:39 +0200

> From: Ido Schimmel <idosch@mellanox.com>
> 
> During initialization the driver issues a software reset command and
> then waits for the system status to change back to "ready" state.
> 
> However, before issuing the reset command the driver does not check that
> the system is actually in "ready" state. On Spectrum-{1,2} systems this
> was always the case as the hardware initialization time is very short.
> On Spectrum-3 systems this is no longer the case. This results in the
> software reset command timing-out and the driver failing to load:
> 
> [ 6.347591] mlxsw_spectrum3 0000:06:00.0: Cmd exec timed-out (opcode=40(ACCESS_REG),opcode_mod=0,in_mod=0)
> [ 6.358382] mlxsw_spectrum3 0000:06:00.0: Reg cmd access failed (reg_id=9023(mrsr),type=write)
> [ 6.368028] mlxsw_spectrum3 0000:06:00.0: cannot register bus device
> [ 6.375274] mlxsw_spectrum3: probe of 0000:06:00.0 failed with error -110
> 
> Fix this by waiting for the system to become ready both before issuing
> the reset command and afterwards. In case of failure, print the last
> system status to aid in debugging.
> 
> Fixes: da382875c616 ("mlxsw: spectrum: Extend to support Spectrum-3 ASIC")
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Applied and queued up for -stable.
