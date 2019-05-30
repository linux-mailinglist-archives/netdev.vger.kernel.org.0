Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD61E2F87B
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 10:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbfE3I1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 04:27:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:34114 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725440AbfE3I1Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 May 2019 04:27:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82429AD7B;
        Thu, 30 May 2019 08:27:23 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B5F9EE0326; Thu, 30 May 2019 10:27:22 +0200 (CEST)
Date:   Thu, 30 May 2019 10:27:22 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>, vivien.didelot@gmail.com,
        linux-kernel@vger.kernel.org, kernel@savoirfairelinux.com,
        linville@redhat.com, f.fainelli@gmail.com
Subject: Re: [PATCH net-next] ethtool: copy reglen to userspace
Message-ID: <20190530082722.GB27401@unicorn.suse.cz>
References: <20190528205848.21208-1-vivien.didelot@gmail.com>
 <20190529.221744.1136074795446305909.davem@davemloft.net>
 <20190530064848.GA27401@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530064848.GA27401@unicorn.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 08:48:48AM +0200, Michal Kubecek wrote:
> On Wed, May 29, 2019 at 10:17:44PM -0700, David Miller wrote:
> > From: Vivien Didelot <vivien.didelot@gmail.com>
> > Date: Tue, 28 May 2019 16:58:48 -0400
> > 
> > > ethtool_get_regs() allocates a buffer of size reglen obtained from
> > > ops->get_regs_len(), thus only this value must be used when copying
> > > the buffer back to userspace. Also no need to check regbuf twice.
> > > 
> > > Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
> > 
> > Hmmm, can't regs.len be modified by the driver potentially?
> 
> The driver certainly shouldn't raise it as that could result in kernel
> writing past the buffer provided by userspace. (I'll check some drivers
> to see if they truncate the dump or return an error if regs.len from
> userspace is insufficient.) And lowering it would be also wrong as that
> would mean dump would be shorter than what ops->get_regs_len() returned.

I looked around a bit. First of all, the driver cannot actually return
error as ethtool_ops::get_regs() returns void. Most drivers do not touch
regs->len and only fill data and possibly regs->version which is fine.

There are few drivers which modify regs->len:

  s2io_ethtool_gdrvinfo()	neterion/s2io
  vxge_ethtool_gregs()		neterion/vxge
  ixgb_get_regs()		intel/ixgb
  emac_get_regs_len()		qualcomm/emac
  ql_get_regs()			qlogic/qlge
  axienet_ethtools_get_regs()	xilinx/axienet

All of these set regs->len to the same value as ->get_regs_len() returns
(ixgb does it in rather fragile way). This means that if userspace
passes insufficient buffer size, current code would write pass that
buffer; but proposed patch would make things worse as with it, kernel
would always write past the userspace buffer in such case.

Note: ieee80211_get_regs() in net/mac80211/ethtool.c also sets regs->len
but it always sets it to 0 which is also what ->get_regs_len() returns
so that it does not actually modify the value.

I believe this should be handled by ethtool_get_regs(), either by
returning an error or by only copying data up to original regs.len
passed by userspace. The former seems more correct but broken userspace
software would suddenly start to fail where it "used to work". The
latter would be closer to current behaviour but it would mean that
broken userspace software might nerver notice there is something wrong.

Michal Kubecek
