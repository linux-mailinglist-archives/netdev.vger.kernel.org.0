Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF74193B11
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 09:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgCZIfQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 04:35:16 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37279 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCZIfQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 04:35:16 -0400
Received: by mail-wm1-f65.google.com with SMTP id d1so5982721wmb.2
        for <netdev@vger.kernel.org>; Thu, 26 Mar 2020 01:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bI4PwyB0GYThhgebDOBG4cILlHiz85jxUGtjjZmQKUY=;
        b=rjdbvefKBu3n+d/8ukrtYKmsELBssmih8toAhrnHmIkmZySHvILtsEmcWHebwN/vuC
         iDIEGZOYPgkmBWarbSIYoi2wHHAMFP0Eop2WHzXBAbl1Bk23PUulgyUol6Re6B2pR6mu
         PNfRostScnStAiRcdKFOACibjBFSMartqO0TkZs/KfTaJ0d6Q3Zu4YA9ZVSM/s6EivnI
         VcDBPAHORMUeg+GHOwGfjgGVFb4CdJjAd/H43qxF/Wq/YX3QVf0A03azXPEwf3lV8HZK
         DG7zV4Y8KUjYRngtqnQn1ORidHswUdmG+90WfSjG/TJVHKybFCfLRWwh++6ink2RCpFi
         lnpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bI4PwyB0GYThhgebDOBG4cILlHiz85jxUGtjjZmQKUY=;
        b=FowL1VdZvdHPGDLozkYvOItkHW+usoC2okddD3wSnhYfjdKxiQ11cfwpWmcObptCig
         SwDGptIvZ89UtienW2vuR0iMhzzLlo++1pFAtPEZF8ltUbrhENna/rf3r6YzRo1iXkDL
         LYyoWzSOYs+sMBjfDlSrpZd/WGNCXm4ZYG7taUOcXkoyLqer6ZLmCR3sIMJ7Sl9phIaT
         SK/YH3v3/sxXaCsc3Ro7rt86cTnvIRBgVikapPU/DhffsCrv9m3GKWfD/Bxx60PeJbKb
         mworJuugziuvdTPzje6UKETdvoY9QE6pZPqVU6n34iFLxF/G1E3+fRmiJqd3/LhHgZwy
         QC2g==
X-Gm-Message-State: ANhLgQ0Hb1GiEKSNxNes7OnnArls1WYz8NxWeVgZ9qjHo01r4YdQbOsi
        Lq/MrlKu114CejV8Hhafzw0prQ==
X-Google-Smtp-Source: ADFU+vv4SEwCogZ1T21RNfRIVys1C/rvqPtFx2H3zAV+Re23xRWHQL1HKokRf8GuwKkoJzo1YmPd1A==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr1996527wme.185.1585211713059;
        Thu, 26 Mar 2020 01:35:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c7sm2640598wrn.49.2020.03.26.01.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2020 01:35:12 -0700 (PDT)
Date:   Thu, 26 Mar 2020 09:35:11 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [net-next v2 08/11] devlink: track snapshot id usage count using
 an xarray
Message-ID: <20200326083511.GL11304@nanopsycho.orion>
References: <20200326035157.2211090-1-jacob.e.keller@intel.com>
 <20200326035157.2211090-9-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326035157.2211090-9-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 26, 2020 at 04:51:54AM CET, jacob.e.keller@intel.com wrote:
>Each snapshot created for a devlink region must have an id. These ids
>are supposed to be unique per "event" that caused the snapshot to be
>created. Drivers call devlink_region_snapshot_id_get to obtain a new id
>to use for a new event trigger. The id values are tracked per devlink,
>so that the same id number can be used if a triggering event creates
>multiple snapshots on different regions.
>
>There is no mechanism for snapshot ids to ever be reused. Introduce an
>xarray to store the count of how many snapshots are using a given id,
>replacing the snapshot_id field previously used for picking the next id.
>
>The devlink_region_snapshot_id_get() function will use xa_alloc to
>insert an initial value of 1 value at an available slot between 0 and
>U32_MAX.
>
>The new __devlink_snapshot_id_increment() and
>__devlink_snapshot_id_decrement() functions will be used to track how
>many snapshots currently use an id.
>
>Drivers must now call devlink_snapshot_id_put() in order to release
>their reference of the snapshot id after adding region snapshots.
>
>By tracking the total number of snapshots using a given id, it is
>possible for the decrement() function to erase the id from the xarray
>when it is not in use.
>
>With this method, a snapshot id can become reused again once all
>snapshots that referred to it have been deleted via
>DEVLINK_CMD_REGION_DEL, and the driver has finished adding snapshots.
>
>This work also paves the way to introduce a mechanism for userspace to
>request a snapshot.
>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

This looks good to me. 2 small nits below.
With or without changing them:
Reviewed-by: Jiri Pirko <jiri@mellanox.com>


>---
> drivers/net/ethernet/mellanox/mlx4/crdump.c |   3 +
> drivers/net/netdevsim/dev.c                 |   5 +-
> include/net/devlink.h                       |   4 +-
> net/core/devlink.c                          | 130 +++++++++++++++++++-
> 4 files changed, 134 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>index 792951f6df0d..2700628f1689 100644
>--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
>+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
>@@ -203,6 +203,9 @@ int mlx4_crdump_collect(struct mlx4_dev *dev)
> 	mlx4_crdump_collect_crspace(dev, cr_space, id);
> 	mlx4_crdump_collect_fw_health(dev, cr_space, id);
> 
>+	/* Release reference on the snapshot id */
>+	devlink_region_snapshot_id_put(devlink, id);
>+
> 	crdump_disable_crspace_access(dev, cr_space);
> 
> 	iounmap(cr_space);
>diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>index b851fe63a75d..53ec891659eb 100644
>--- a/drivers/net/netdevsim/dev.c
>+++ b/drivers/net/netdevsim/dev.c
>@@ -44,6 +44,7 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> 					    size_t count, loff_t *ppos)
> {
> 	struct nsim_dev *nsim_dev = file->private_data;
>+	struct devlink *devlink = priv_to_devlink(nsim_dev);

DaveM seems to frown upon breaking the reverse christmas tree like this.

Don't assign devlink here and do it later on instead to avoid the tree
breakage.


> 	void *dummy_data;
> 	int err;
> 	u32 id;
>@@ -54,13 +55,15 @@ static ssize_t nsim_dev_take_snapshot_write(struct file *file,
> 
> 	get_random_bytes(dummy_data, NSIM_DEV_DUMMY_REGION_SIZE);
> 
>-	err = devlink_region_snapshot_id_get(priv_to_devlink(nsim_dev), &id);
>+	err = devlink_region_snapshot_id_get(devlink, &id);
> 	if (err)
> 		pr_err("Failed to get snapshot id\n");
> 		return err;
> 	}
> 	err = devlink_region_snapshot_create(nsim_dev->dummy_region,
> 					     dummy_data, id);
>+	/* release the snapshot id regardless of errors */

I don't think this comment is necessary. Up to you.


>+	devlink_region_snapshot_id_put(devlink, id);
> 	if (err) {
> 		pr_err("Failed to create region snapshot\n");
> 		kfree(dummy_data);

[...]
