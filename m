Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4480056C670
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:39:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiGIDjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:39:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGIDjM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:39:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 097FC820D9;
        Fri,  8 Jul 2022 20:39:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FCABB82A4F;
        Sat,  9 Jul 2022 03:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EAC2C341C0;
        Sat,  9 Jul 2022 03:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657337948;
        bh=XWVQ/Q6W3I3bvxKqfJpupU4xGnWGQM+x9j/rteGJzrc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=slEcjB1j+8CrEvsCLvwTmy1AWPlIYyAtooUq5uQJOQCy1YHCeJn8aZZLu1R7fUiO+
         bM1bkhRj2Y/6WVuHI8W9CyFLEZyaAtvvwQeLmLg4iAhMoAmtTvuPeShmSe2vnn5Eui
         c4wqF17CZvDgNeMiuX5Ri4OEUN9UCLcjRGltONtRFqNO1+a+2KfAXzbJSyw6rMe+El
         jaRA5o5eWAghYX7FbkIDMNO05rfoaDPXi7B6ipRexDp8qLAc1eaNLxWnOj+mtx5f3S
         nmN2v6+q+7SwC51vY4yjZB2g6AoEu/gRB6f9IGXYkzYZm/lENRSDffYDseiUVcVy0C
         qdIV3Yp9lEbXg==
Date:   Fri, 8 Jul 2022 20:39:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, lkp@intel.com,
        Yevhen Orlov <yevhen.orlov@plvision.eu>
Subject: Re: [PATCH V4 net-next 4/4] net: marvell: prestera: implement
 software MDB entries allocation
Message-ID: <20220708203907.253df7a9@kernel.org>
In-Reply-To: <20220708174324.18862-5-oleksandr.mazur@plvision.eu>
References: <20220708174324.18862-1-oleksandr.mazur@plvision.eu>
        <20220708174324.18862-5-oleksandr.mazur@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Jul 2022 20:43:24 +0300 Oleksandr Mazur wrote:
> +static int
> +prestera_mdb_port_addr_obj_add(const struct switchdev_obj_port_mdb *mdb);
> +static int
> +prestera_mdb_port_addr_obj_del(struct prestera_port *port,
> +			       const struct switchdev_obj_port_mdb *mdb);
> +
> +static void
> +prestera_mdb_flush_bridge_port(struct prestera_bridge_port *br_port);
> +static int
> +prestera_mdb_port_add(struct prestera_mdb_entry *br_mdb,
> +		      struct net_device *orig_dev,
> +		      const unsigned char addr[ETH_ALEN], u16 vid);
> +
> +static void
> +prestera_br_mdb_entry_put(struct prestera_br_mdb_entry *br_mdb_entry);
> +static int prestera_br_mdb_mc_enable_sync(struct prestera_bridge *br_dev);
> +static int prestera_br_mdb_sync(struct prestera_bridge *br_dev);
> +static int prestera_br_mdb_port_add(struct prestera_br_mdb_entry *br_mdb,
> +				    struct prestera_bridge_port *br_port);
> +static void
> +prestera_mdb_port_del(struct prestera_mdb_entry *mdb,
> +		      struct net_device *orig_dev);

No forward declarations in the kernel, unless the there is a circular
dependency. You should be able to just order the functions correctly.

> +	list_for_each_entry(br_mdb, &br_dev->br_mdb_entry_list,
> +			    br_mdb_entry_node)
> +		if ((err = prestera_mdb_enable_set(br_mdb, enable)))
> +			return err;

Like checkpatch says, no assignments in the if statements.
