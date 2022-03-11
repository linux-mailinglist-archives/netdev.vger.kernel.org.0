Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784A54D65C3
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350149AbiCKQHj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:07:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350152AbiCKQHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:07:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8981C1D0D65
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 08:06:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 213DAB82B3D
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 16:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A7DC340E9;
        Fri, 11 Mar 2022 16:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647014792;
        bh=ASm7DJCJntNGfXf/heomcscu2yhNS2eRuuPPOxsaq/A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLx8VW81jI+j2D2jckUQHrDaJfkZd7NN9yUaVL9ZxrHhOe9cR7ptrnG4T/NEeB/rr
         pQVQqCFjZw2YVZbsI2tiMiVNgFNomJSPNTcLuKqQG5rv/ECrWZd8SnfdoGiZDIfBHb
         FOwsZb3lNuzvlaae+qf5vMmsXCLbkdb9WJH6rQB7+l9gJBe1kz1bfbz6tHP2rv7As7
         dHrgMb3cyGYY1SeL5fFib/qtBsrzWmpZ63VT2tpQMs9m5GmXXQuvSiAiGAKOJnbQAS
         NKMTsNT+LnzX6AYA+ipIUzJRH6mgT3HuSWcBR/Awl3vdBAcIK1qe4i1VV8rFz4YxJC
         ys/vPYiQh3Tog==
Date:   Fri, 11 Mar 2022 08:06:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 1/3] netdevsim: Introduce support for L3
 offload xstats
Message-ID: <20220311080631.7e679bea@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87y21g96de.fsf@nvidia.com>
References: <cover.1646928340.git.petrm@nvidia.com>
        <288b325ace94f327b3d3149e2ee61c3d43cf6870.1646928340.git.petrm@nvidia.com>
        <20220310211301.477e323c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <87y21g96de.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Mar 2022 10:18:39 +0100 Petr Machata wrote:
> How about this?
> 
> struct nsim_dev_hwstats_fops {
> 	const struct file_operations fops;
> 	enum nsim_dev_hwstats_do action;
> 	enum netdev_offload_xstats_type type;
> };

Yeah, sure that also works. Using fops is relatively common, 
I thought, so:

+static ssize_t
+nsim_dev_hwstats_do_write(struct file *file,
+			  const char __user *data,
+			  size_t count, loff_t *ppos)
+{
+	struct nsim_dev_hwstats *hwstats = file->private_data;
+	struct list_head *hwsdev_list;
+	int ifindex;
+	int err;
+
+	err = kstrtoint_from_user(data, count, 0, &ifindex);
+	if (err)
+		return err;
+
+	hwsdev_list = nsim_dev_hwstats_get_list_head(hwstats, hwsfops->type);
+	if (WARN_ON(!hwsdev_list))
+		return -EINVAL;
+
+	switch (debugfs_real_fops(file)) {
+	case &nsim_dev_hwstats_l3_disable_fops:
+		err = nsim_dev_hwstats_disable_ifindex(hwstats, ifindex,
+						       NSIM_DEV_HWSTATS_DO_DISABLE,
+						       hwsdev_list);
+		break;

etc. would be the shortest version.

I'm okay with your version if you prefer, but the above works, right?
Or am I missing something?
