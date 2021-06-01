Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5B9397B44
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 22:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhFAUat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 16:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234513AbhFAUat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 16:30:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61FE2613BD;
        Tue,  1 Jun 2021 20:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622579347;
        bh=a72SxP51iSyJq6C8I1haykDDm62+9fxxrEZd8LzCYak=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EnJpLVUjhypX88aSo1dVTd2zSZFLmlVfssVsHtgzC9gjhlh28NudF7adMmIHIp8WC
         c7Qe2+IWXp0THkCIowVXyJvnZTHHtVrGLS8K535KBXe89JQsS5NVyVXSUCYWB15Rqg
         GpBZpgL1Az6P44mulTM6MSVJ+XE0b2PXV3uRq10VY/8i6cSxru6AYXRXmmDp28AaC9
         7upGw7PEeOHc7No5ry/zpKlww6ffjB7lmdvbPZk+lIFFEp3jRc5p8s7FKebKWq8rFb
         PO+9kVoNK833OC5aJ2TkuTGTr/SUKOCJaAeEUrSb6Yxite99CXwaX1Ea8e+uQ3zKFB
         swMZHLQwmKzJw==
Date:   Tue, 1 Jun 2021 13:29:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     Huazhong Tan <tanhuazhong@huawei.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V2 net-next 0/3] ethtool: extend coalesce uAPI
Message-ID: <20210601132905.1de262f6@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210601111436.00001c69@intel.com>
References: <1622258536-55776-1-git-send-email-tanhuazhong@huawei.com>
        <20210601111436.00001c69@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Jun 2021 11:14:36 -0700 Jesse Brandeburg wrote:
> > 3. ethool(netlink with cqe mode) + kernel with cqe mode:
> > estuary:/$ ethtool -c eth0
> > Coalesce parameters for eth0:
> > Adaptive RX: on  TX: on
> > stats-block-usecs: n/a
> > sample-interval: n/a
> > pkt-rate-low: n/a
> > pkt-rate-high: n/a
> > 
> > rx-usecs: 20
> > rx-frames: 0
> > rx-usecs-irq: n/a
> > rx-frames-irq: n/a
> > 
> > tx-usecs: 20
> > tx-frames: 0
> > tx-usecs-irq: n/a
> > tx-frames-irq: n/a
> > 
> > rx-usecs-low: n/a
> > rx-frame-low: n/a
> > tx-usecs-low: n/a
> > tx-frame-low: n/a
> > 
> > rx-usecs-high: 0
> > rx-frame-high: n/a
> > tx-usecs-high: 0
> > tx-frame-high: n/a
> > 
> > CQE mode RX: off  TX: off  
> 
> BTW, thanks for working on something like this.
> I hope it's not just me, but I don't like the display of the new CQE
> line, at the very least, it's not consistent with what is there already
> in the output of this command, and at worst, it surprises the user and
> makes it hard to parse for any scripting tools.

Tools should parse JSON output ;)

> Can I suggest something like:
> 
> rx-cqe: off
> tx-cqe: off
> rx-eqe: off
> tx-eqe: off
> 
> Then, if hardware is in EQE mode it is clear that it's supported and
> ON/OFF, as well as for CQE mode.

This is how "Adaptive" is displayed, maybe we should move the line up
so that it's closer to its inspiration?

Having cqe/eqe both listed when only one can be "on" may not be 100%
intuitive either (assuming my understanding that this feature is just
about restarting the timer on new packet arrival is correct).
