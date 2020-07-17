Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22CFA224328
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 20:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbgGQSb6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 14:31:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:46986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726322AbgGQSb6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 14:31:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7E7E20759;
        Fri, 17 Jul 2020 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595010717;
        bh=YHFPycUTgsDF1UJGgyC7LWsiRop+4nEUMYmTmNXt6f0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uY9z5GFL5wr9rt4JseHttadmmmHwUKrbMZC7HgrilpDBbLcfMJ2gEvc+V/2fDE5eb
         F5GgYkSlQGORe/913kjxedtpgOCqZlw2b6Kyim2kaNlGn/FNl35LVOk8YiJE7P9a+M
         pgiizxg6DiK9ve2OxtLVmUGdWpfoYYOSFGSWrsWA=
Date:   Fri, 17 Jul 2020 11:31:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Alexander Lobakin <alobakin@marvell.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kalderon <mkalderon@marvell.com>,
        Ariel Elior <aelior@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        <QLogic-Storage-Upstream@cavium.com>, <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 10/13] qed: add support for new port
 modes
Message-ID: <20200717113155.1a9234b3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <27939848-7e83-2897-36f9-44f47d1bfb9c@marvell.com>
References: <20200716115446.994-1-alobakin@marvell.com>
        <20200716115446.994-11-alobakin@marvell.com>
        <20200716181853.502dd619@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <27939848-7e83-2897-36f9-44f47d1bfb9c@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Jul 2020 13:49:33 +0300 Igor Russkikh wrote:
> > ----------------------------------------------------------------------
> > On Thu, 16 Jul 2020 14:54:43 +0300 Alexander Lobakin wrote:  
> >> These ports ship on new boards revisions and are supported by newer
> >> firmware versions.
> >>
> >> Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
> >> Signed-off-by: Igor Russkikh <irusskikh@marvell.com>  
> > 
> > What is the driver actually doing with them, tho?
> > 
> > Looks like you translate some firmware specific field to a driver
> > specific field, but I can't figure out what part of the code cares
> > about hw_info.port_mode  
> 
> Hi Jakub,
> 
> You are right, this info is never used/reported.
> 
> Alexander is extending already existing non used field with new values from
> our latest hardware revisions.
> 
> I thought devlink info could be a good place to output such kind of information.
> 
> Thats basically a layout of *Physical* ports on device - quite useful info I
> think.
> 
> Important thing is these ports may not be directly mapped to PCI PFs. So
> reading `ethtool eth*` may not explain you the real device capabilities.
> 
> Do you think it makes sense adding such info to `devlink info` then?

Devlink port has information about physical port, which don't have to
map 1:1 to netdevs. It also has lanes and port splitting which you may
want to report.


For now please make sure to not include any dead code in your
submissions (register defines etc. may be okay), perhaps try:

diff --git a/drivers/net/ethernet/qlogic/qed/qed_dev.c b/drivers/net/ethernet/qlogic/qed/qed_dev.c
index d929556247a5..4bad836d0f74 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_dev.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_dev.c
@@ -4026,6 +4026,21 @@ static int qed_hw_get_nvm_info(struct qed_hwfn *p_hwfn, struct qed_ptt *p_ptt)
 	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_4X25G:
 		p_hwfn->hw_info.port_mode = QED_PORT_MODE_DE_4X25G;
 		break;
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_4X50G_R1:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_2X100G_R2:
+	case NVM_CFG1_GLOB_NETWORK_PORT_MODE_AHP_1X100G_R4:
+		/* TODO: set port_mode when it's actually used */
+		break;
 	default:
 		DP_NOTICE(p_hwfn, "Unknown port mode in 0x%08x\n", core_cfg);
 		break;

And see if it will pass the muster.

Dead code makes it harder to review the patches.
