Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD6C66DD09
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:59:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbjAQL7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236908AbjAQL7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:59:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281F636FDD;
        Tue, 17 Jan 2023 03:59:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BEF4612CE;
        Tue, 17 Jan 2023 11:59:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 851B8C433EF;
        Tue, 17 Jan 2023 11:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673956749;
        bh=C4DWw1lnsfHjJvgG7EN7/MBLwzOtKiOqkpCYuIalGOc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CyEJUdpmNRp0vCg9aUxD6eG2NOon+Jg4hJ1Lxm49Daa37qaahNpu1+wK/c6EB1LZq
         r7a6oulLUJ3AhNnHB4x1yQ6L0miJkjQ8W6kW7j2jE2H+gjJcugdZu8QcnzE/HbZ4v1
         HACJ5TUyBlN/IAZ0qHng1uVw9vSqWCZxAZXcbgkhwAwBrQncAzymslz5BL8QvKbcVv
         L+6DODA8TSGQnnK4oV9fioc7Ib8dAt6CfJYz5a1p7sT25RphdnZiB/jIT9wJIK8QMd
         moqGrsy8AWobu8dPl20BmSVBSU0UicFXjLLq+ItmOdmoK05h4GUGy1RQTVkSvHltlg
         s18hH9FMn0v8g==
Date:   Tue, 17 Jan 2023 13:59:05 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Israel Rukshin <israelr@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-trace-kernel@vger.kernel.org" 
        <linux-trace-kernel@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 12/13] nvme: Add crypto profile at nvme
 controller
Message-ID: <Y8aNiUWu9AufXkou@unreal>
References: <cover.1673873422.git.leon@kernel.org>
 <efc8dc5952baa096a14db1761f84a5ab2e76654a.1673873422.git.leon@kernel.org>
 <52fef455-fd7a-225f-c03f-b214907ce03b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52fef455-fd7a-225f-c03f-b214907ce03b@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 12:31:22AM +0000, Chaitanya Kulkarni wrote:
> > diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> > index 51a9880db6ce..f09e4e0216b3 100644
> > --- a/drivers/nvme/host/core.c
> > +++ b/drivers/nvme/host/core.c
> > @@ -1928,6 +1928,9 @@ static void nvme_update_disk_info(struct gendisk *disk,
> >   			capacity = 0;
> >   	}
> >   
> > +	if (ctrl->crypto_enable)
> > +		blk_crypto_register(&ctrl->crypto_profile, disk->queue);
> > +
> >   	set_capacity_and_notify(disk, capacity);
> >   
> >   	nvme_config_discard(disk, ns);
> > diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
> > index 424c8a467a0c..591380f53744 100644
> > --- a/drivers/nvme/host/nvme.h
> > +++ b/drivers/nvme/host/nvme.h
> > @@ -16,6 +16,7 @@
> >   #include <linux/rcupdate.h>
> >   #include <linux/wait.h>
> >   #include <linux/t10-pi.h>
> > +#include <linux/blk-crypto-profile.h>
> >   
> >   #include <trace/events/block.h>
> >   
> > @@ -374,6 +375,9 @@ struct nvme_ctrl {
> >   
> >   	enum nvme_ctrl_type cntrltype;
> >   	enum nvme_dctype dctype;
> > +
> > +	bool crypto_enable;
> 
> why not decalre crypto_profile a pointer, allocate that at init
> controller and NULL check against that pointer instead of using
> an extra variable crypto_enable ?

The embedded struct allows us to rely on container_of() macro.

   377 static int nvme_rdma_crypto_keyslot_program(struct blk_crypto_profile *profile,
   378                                             const struct blk_crypto_key *key,
   379                                             unsigned int slot)
   380 {
   381         struct nvme_ctrl *nctrl =
   382                 container_of(profile, struct nvme_ctrl, crypto_profile);

> 
> e.g. :-
> 
> 	if (ctrl->crypto_profile)
> 		blk_crypto_register(ctrl->crypto_profile, disk->queue);
> 
> > +	struct blk_crypto_profile crypto_profile;
> 
> you are increasing the size of struct nvme_ctrl unconditionally,
> why not guard above with CONFIG_BLK_INLINE_ENCRYPTION ?

We can do it.

Thanks

> 
> -ck
> 
