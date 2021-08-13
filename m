Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173CB3EBBB7
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 19:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231891AbhHMRzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 13:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:43466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229944AbhHMRzf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 13:55:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D881260EFE;
        Fri, 13 Aug 2021 17:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628877304;
        bh=eSU+ma0haKb2aIUsp/HJIzNk6roGALnzB8QN2POuuW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Gp+R5/O+YZNgwjbJwcKEdlL4jwnjD1zMNc8tMlFvsCMSX8NyyUq+JCoeW2TsoFgaN
         ZMvghvB7cZCk3pbB6K48ULDORiwWADVJImvMjrtI3L3D2pqdNywn6/C6nXiFP8WAbc
         4GXoRdQztGp3Qv8OXd+0lagSa4ByrukVJhVc+4pP0zSnl8CiBsCtykiHMYhBTpq+pJ
         bLaLPvX6PsZTlqaE22jVWQSFLxezv88+85qhjsv2GzSnxIUl77MvZ1nAbmuylwEdUY
         kVeuryam7fQBw7pMaQTXLSIVAny278VEaSxm+M/iND0UiLpY6M4kHs7V9ifYyl3PjR
         Y+tICLIRN5Jqw==
Date:   Fri, 13 Aug 2021 10:55:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yufeng Mo <moyufeng@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <shenjian15@huawei.com>, <lipeng321@huawei.com>,
        <yisen.zhuang@huawei.com>, <linyunsheng@huawei.com>,
        <huangguangbin2@huawei.com>, <chenhao288@hisilicon.com>,
        <salil.mehta@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: Re: [RFC V3 net-next 1/4] ethtool: add two coalesce attributes for
 CQE mode
Message-ID: <20210813105503.600ad1cd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1628819129-23332-2-git-send-email-moyufeng@huawei.com>
References: <1628819129-23332-1-git-send-email-moyufeng@huawei.com>
        <1628819129-23332-2-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Aug 2021 09:45:26 +0800 Yufeng Mo wrote:
> Currently, there many drivers who support CQE mode configuration,
> some configure it as a fixed when initialized, some provide an
> interface to change it by ethtool private flags. In order make it
> more generic, add two new 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
> 'ETHTOOL_A_COALESCE_USE_CQE_RX' coalesce attributes, then these
> parameters can be accessed by ethtool netlink coalesce uAPI.
> 
> Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
> Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>

The series LGTM. When I was asking for documentation earlier I meant 
a paragraph explaining the difference between the two modes. Here is 
an example based on my current understanding, I could very well be
wrong but you see what kind of explanation I'm after? If this is more
or less correct please feel free to use it and modify as you see fit.

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c86628e6a235..fc7ac5938aac 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -939,12 +939,25 @@ Gets coalescing parameters like ``ETHTOOL_GCOALESCE`` ioctl request.
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
 corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
 they are declared as supported by driver).
 
+Timer reset mode (``ETHTOOL_A_COALESCE_USE_CQE_TX`` and
+``ETHTOOL_A_COALESCE_USE_CQE_RX``) control the interaction between packet
+arrival and the various time based delay parameters. By default timers are
+expected to limit the max delay between any packet arrival/departure
+and a corresponding interrupt. In this mode timer should be started by packet
+arrival (sometimes delivery of previous interrupt) and reset when interrupt
+is delivered.
+Setting the appropriate attribute to 1 will enable ``CQE`` mode, where
+each packet event resets the timer. In this mode timer is used to force
+the interrupt if queue goes idle, while busy queues depend on the packet
+limit to trigger interrupts.
 
 COALESCE_SET
 ============
@@ -977,6 +990,8 @@ Sets coalescing parameters like ``ETHTOOL_SCOALESCE`` ioctl request.
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
