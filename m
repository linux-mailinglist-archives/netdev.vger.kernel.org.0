Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA6BE3379DA
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCKQrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:47:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:58850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229641AbhCKQq4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 11:46:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9EA464FA7;
        Thu, 11 Mar 2021 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615481216;
        bh=4K8HXtxCIe511n97OwlEiYmXkazGyXPyrCkj+nL8eLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MIl6nejvYaqTtbIXvoEiOlzMlJdZvlK0wvSB0V2lOz/C8jhnD1DBrAEdJbDwDHylX
         grXPYX3jmpZ27ndAhrNgTIzkviI1qkh1syDIf/+NUuzt43pVOrdT2yFsNWQeTJCbbl
         WpBcA0grAO46oPiL7Oofctdt8YjDNmHJyyiyaeSz0z6fidRH07CEBnuGhRZVcBDgm0
         8kyQt0/npYlV6cW37R+OcDrQL4yqP+SRqEsPNIGVYTda6cTCOaoeOitPeC0VnepkZP
         G3QpSjrJyvLeVsjT3f+B2okBwAlVelcoiYV3NKe4NoQjLIylqZZ1uC5OKx/NQ02otG
         ituTa7Jg/rbaQ==
Date:   Thu, 11 Mar 2021 08:46:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     f242ed68-d31b-527d-562f-c5a35123861a@intel.com,
        netdev@vger.kernel.org, saeedm@nvidia.com,
        andrew.gospodarek@broadcom.com, jacob.e.keller@intel.com,
        guglielmo.morandin@broadcom.com, eugenem@fb.com,
        eranbe@mellanox.com
Subject: Re: [RFC net-next v2 1/3] devlink: move health state to uAPI
Message-ID: <20210311084654.4dcfdb2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210311074734.GN4652@nanopsycho.orion>
References: <20210311032613.1533100-1-kuba@kernel.org>
        <20210311074734.GN4652@nanopsycho.orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Mar 2021 08:47:34 +0100 Jiri Pirko wrote:
> Thu, Mar 11, 2021 at 04:26:11AM CET, kuba@kernel.org wrote:
> >Move the health states into uAPI, so applications can use them.
> >
> >Note that we need to change the name of the enum because
> >user space is likely already defining the same values.
> >E.g. iproute2 does.
> >
> >Use this opportunity to shorten the names.
> >
> >Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >---
> > .../net/ethernet/broadcom/bnxt/bnxt_devlink.c  |  4 ++--
> > .../ethernet/mellanox/mlx5/core/en/health.c    |  4 ++--
> > include/net/devlink.h                          |  7 +------
> > include/uapi/linux/devlink.h                   | 12 ++++++++++++
> > net/core/devlink.c                             | 18 +++++++++---------
> > 5 files changed, 26 insertions(+), 19 deletions(-)
> >
> >diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >index 64381be935a8..cafc98ab4b5e 100644
> >--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
> >@@ -252,9 +252,9 @@ void bnxt_dl_health_status_update(struct bnxt *bp, bool healthy)
> > 	u8 state;
> > 
> > 	if (healthy)
> >-		state = DEVLINK_HEALTH_REPORTER_STATE_HEALTHY;
> >+		state = DL_HEALTH_STATE_HEALTHY;
> > 	else
> >-		state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
> >+		state = DL_HEALTH_STATE_ERROR;  
> 
> I don't like the inconsistencies in the uapi (DL/DEVLINK). Can't we
> stick with "DEVLINK" prefix for all, which is what we got so far?

Sure, but you have seen the previous discussion about the length of
devlink names, right? I'm not the only one who thinks this is a counter
productive rule.
