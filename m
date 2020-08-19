Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC4724A3AB
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 18:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgHSQAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 12:00:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:45702 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbgHSQAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 12:00:11 -0400
IronPort-SDR: 8IJefxkLuFF6i2S3B7jbodNZj7NArrfMNh3MjJoxhGTkl0XQpakV5dh6Onzehoqe0Z5laSo5Qf
 TVEuqw2SmaVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="156209370"
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="156209370"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 09:00:07 -0700
IronPort-SDR: gc8+3LP9tr8GZVgWgBr/nyC5KEgh/6JlfNvTRq42QwQH1aPYebG2VxYnrNABXOo2/mGgMdLCH9
 gmoC+hbilR4g==
X-IronPort-AV: E=Sophos;i="5.76,331,1592895600"; 
   d="scan'208";a="334719777"
Received: from jbrandeb-mobl3.amr.corp.intel.com (HELO localhost) ([10.212.220.26])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 09:00:05 -0700
Date:   Wed, 19 Aug 2020 09:00:02 -0700
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
To:     <sundeep.lkml@gmail.com>
Cc:     <davem@davemloft.net>, <kuba@kernel.org>,
        <richardcochran@gmail.com>, <netdev@vger.kernel.org>,
        <sgoutham@marvell.com>, Aleksey Makarov <amakarov@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: Re: [PATCH v6 net-next 2/3] octeontx2-af: Add support for Marvell
 PTP coprocessor
Message-ID: <20200819090002.00005f4a@intel.com>
In-Reply-To: <1597770557-26617-3-git-send-email-sundeep.lkml@gmail.com>
References: <1597770557-26617-1-git-send-email-sundeep.lkml@gmail.com>
        <1597770557-26617-3-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: Claws Mail 3.12.0 (GTK+ 2.24.28; i686-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sundeep.lkml@gmail.com wrote:

> From: Aleksey Makarov <amakarov@marvell.com>
> 
> This patch adds driver for Precision Time
> Protocol Clock and Timestamping block found on
> Octeontx2 platform. The driver does initial
> configuration and exposes a function to adjust
> PTP hardware clock.

Please explain in the commit message why you have two methods of
handling the clocks PCI space, as without that it seems like some of
the code is either un-necessary or not clear why it's there.

> 
> Co-developed-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Aleksey Makarov <amakarov@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  17 ++
>  drivers/net/ethernet/marvell/octeontx2/af/ptp.c    | 248 +++++++++++++++++++++
>  drivers/net/ethernet/marvell/octeontx2/af/ptp.h    |  22 ++
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |  29 ++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
>  6 files changed, 318 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.c
>  create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/ptp.h
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> index 1b25948..0bc2410 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
> @@ -8,4 +8,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += octeontx2_af.o
>  
>  octeontx2_mbox-y := mbox.o
>  octeontx2_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
> -		  rvu_reg.o rvu_npc.o rvu_debugfs.o
> +		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> index c89b098..4aaef0a 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
> @@ -127,6 +127,7 @@ M(ATTACH_RESOURCES,	0x002, attach_resources, rsrc_attach, msg_rsp)	\
>  M(DETACH_RESOURCES,	0x003, detach_resources, rsrc_detach, msg_rsp)	\
>  M(MSIX_OFFSET,		0x005, msix_offset, msg_req, msix_offset_rsp)	\
>  M(VF_FLR,		0x006, vf_flr, msg_req, msg_rsp)		\
> +M(PTP_OP,		0x007, ptp_op, ptp_req, ptp_rsp)		\
>  M(GET_HW_CAP,		0x008, get_hw_cap, msg_req, get_hw_cap_rsp)	\
>  /* CGX mbox IDs (range 0x200 - 0x3FF) */				\
>  M(CGX_START_RXTX,	0x200, cgx_start_rxtx, msg_req, msg_rsp)	\
> @@ -862,4 +863,20 @@ struct npc_get_kex_cfg_rsp {
>  	u8 mkex_pfl_name[MKEX_NAME_LEN];
>  };
>  
> +enum ptp_op {
> +	PTP_OP_ADJFINE = 0,
> +	PTP_OP_GET_CLOCK = 1,
> +};
> +
> +struct ptp_req {
> +	struct mbox_msghdr hdr;
> +	u8 op;
> +	s64 scaled_ppm;
> +};
> +
> +struct ptp_rsp {
> +	struct mbox_msghdr hdr;
> +	u64 clk;
> +};
> +
>  #endif /* MBOX_H */
> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/ptp.c b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> new file mode 100644
> index 0000000..e9e131d
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/ptp.c
> @@ -0,0 +1,248 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Marvell PTP driver */

Your file is missing Copyrights, is that your intent?

I didn't have any comments for the rest of the patch, except that there
is a lack of comments and communication of intent of the code. I can
see what it does, but think of the point of view of a kernel consumer
getting this code in the future and wanting to extend it or debug it,
and the code being able to talk to "future you" who has no idea why the
code was there or what it was trying to do.

<snip>
