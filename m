Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6400A4F0DD2
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 05:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377042AbiDDD5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 23:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377040AbiDDD5C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 23:57:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8840236171;
        Sun,  3 Apr 2022 20:55:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4ECF6093C;
        Mon,  4 Apr 2022 03:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D54FC2BBE4;
        Mon,  4 Apr 2022 03:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649044505;
        bh=U+4uxSeSXYJxHJfmZr8zZBPJDPda8VUWre3DX0xrbIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U0Wv8CIyD6+3VFPbhS8EO38J4TbeBaKA3muGBg84i8AzIMtlWQVGcPG3wHEUr/lU/
         MHsrhOPuuOoOcIrrhhoh4lRNblW0ksNRWfz+GQRolkjcfXxqgMtu1yVUqmtlbEjuTF
         5K/tzYGcbwk1cH6VFPlT9I4oqUj9cLqkk5tzoYzGxF1InXVUdywaOFW7cf7jQ6q/tc
         QEiiGyQn4S3AqOGIoaHCn3vfviFOh6/0rB1M7cfEZlhshEUKu23c1y1+rXlUk/bQ+g
         sPdHWm0t3p3BF6SR2B5hB5ivww+fOJRAj2GTni1ZAPZ8MQVFm18JRi4zP0YBvHhAam
         aNzgI1b2R2cPw==
Date:   Sun, 3 Apr 2022 20:55:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mike Rapoport <rppt@kernel.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH] taprio: replace usage of found with dedicated list
 iterator variable
Message-ID: <20220403205502.1b34415d@kernel.org>
In-Reply-To: <6118F17F-6E0B-4FDA-A7C4-E1C487E9DB8F@gmail.com>
References: <20220324072607.63594-1-jakobkoschel@gmail.com>
        <87fsmz3uc6.fsf@intel.com>
        <A19238DC-24F8-4BD9-A6FA-C8019596F4A6@gmail.com>
        <877d8a3sww.fsf@intel.com>
        <6118F17F-6E0B-4FDA-A7C4-E1C487E9DB8F@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 3 Apr 2022 13:53:06 +0200 Jakob Koschel wrote:
> I have all the net-next patches bundled in one series now ready to repost.
> Just wanted to verify that's the intended format since it grew a bit larger
> then what was posted so far.
> 
> It's 46 patches changing 51 files across all those files:

Thanks for asking, we have a limit of 15 patches per series to avoid
overloading reviewers. But the patches will likely get merged rather
quickly so it won't be a long wait before you can send another series.

That said:

>  drivers/connector/cn_queue.c                            | 13 ++++++-------
>  drivers/net/dsa/mv88e6xxx/chip.c                        | 21 ++++++++++-----------
>  drivers/net/dsa/sja1105/sja1105_vl.c                    | 14 +++++++++-----

yup, that's net-next

>  drivers/net/ethernet/intel/i40e/i40e_ethtool.c          |  3 ++-
>  drivers/net/ethernet/intel/i40e/i40e_main.c             | 24 ++++++++++++++----------
>  drivers/net/ethernet/mellanox/mlx4/alloc.c              | 29 +++++++++++++++++++----------
>  drivers/net/ethernet/mellanox/mlx4/mcg.c                | 17 ++++++++---------
>  drivers/net/ethernet/mellanox/mlx5/core/eq.c            | 10 +++++++---
>  drivers/net/ethernet/mellanox/mlx5/core/fs_core.c       | 12 ++++++------
>  drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c   | 21 ++++++++++++---------
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c      |  7 +++++--
>  drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c       | 12 +++++++++---

i40e and mlx5 patches you may or may not want to post separately 
so that Intel and Mellanox can take them via their trees.

>  drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c | 25 ++++++++++++-------------
>  drivers/net/ethernet/qlogic/qed/qed_dev.c               | 11 ++++++-----
>  drivers/net/ethernet/qlogic/qed/qed_iwarp.c             | 26 ++++++++++++--------------
>  drivers/net/ethernet/qlogic/qed/qed_spq.c               |  6 +++---
>  drivers/net/ethernet/qlogic/qede/qede_filter.c          | 11 +++++++----
>  drivers/net/ethernet/qlogic/qede/qede_rdma.c            | 11 +++++------
>  drivers/net/ethernet/sfc/rx_common.c                    |  6 ++++--
>  drivers/net/ethernet/ti/netcp_core.c                    | 24 ++++++++++++++++--------
>  drivers/net/ethernet/toshiba/ps3_gelic_wireless.c       | 30 +++++++++++++++---------------
>  drivers/net/ipvlan/ipvlan_main.c                        |  7 +++++--
>  drivers/net/rionet.c                                    | 14 +++++++-------
>  drivers/net/team/team.c                                 | 20 +++++++++++++-------

yup, that's all net-next

>  drivers/net/wireless/ath/ath10k/mac.c                   | 19 ++++++++++---------
>  drivers/net/wireless/ath/ath11k/dp_rx.c                 | 15 +++++++--------
>  drivers/net/wireless/ath/ath11k/wmi.c                   | 11 +++++------
>  drivers/net/wireless/ath/ath6kl/htc_mbox.c              |  2 +-
>  drivers/net/wireless/intel/ipw2x00/libipw_rx.c          | 14 ++++++++------

Wireless goes to Kalle and Johannes.

>  drivers/rapidio/devices/rio_mport_cdev.c                | 42 ++++++++++++++++++++----------------------
>  drivers/rapidio/devices/tsi721.c                        | 13 ++++++-------
>  drivers/rapidio/rio.c                                   | 14 +++++++-------
>  drivers/rapidio/rio_cm.c                                | 81 ++++++++++++++++++++++++++++++++++++

That's not networking.

>  net/9p/trans_virtio.c                                   | 15 +++++++--------
>  net/9p/trans_xen.c                                      | 10 ++++++----

Also not really networking, those go thru other people's trees.

>  net/core/devlink.c                                      | 22 +++++++++++++++-------
>  net/core/gro.c                                          | 12 ++++++++----
>  net/dsa/dsa.c                                           | 11 +++++------

yup, net-next

>  net/ieee802154/core.c                                   |  7 +++++--

individual posting for Stefan to take via his tree

>  net/ipv4/udp_tunnel_nic.c                               | 10 ++++++----

yup

>  net/mac80211/offchannel.c                               | 28 ++++++++++++++--------------
>  net/mac80211/util.c                                     |  7 +++++--

This is wireless, so Johannes & Kalle.

>  net/sched/sch_cbs.c                                     | 11 +++++------
>  net/sched/sch_taprio.c                                  | 11 +++++------
>  net/smc/smc_ism.c                                       | 14 +++++++-------
>  net/tipc/group.c                                        | 12 ++++++++----
>  net/tipc/monitor.c                                      | 21 ++++++++++++++-------
>  net/tipc/name_table.c                                   | 11 +++++++----
>  net/tipc/socket.c                                       | 11 +++++++----

yup

>  net/wireless/core.c                                     |  7 +++++--

wireless

>  net/xfrm/xfrm_ipcomp.c                                  | 11 +++++++----

IPsec, so Steffen and Herbert, separate posting.

>  51 files changed, 452 insertions(+), 364 deletions(-)

So 21-ish patches for net-next if you group changes for a same driver
/ project into one patch. Two series 10+ patches each?

> Please let me know if I should split it up or if there are certain files that might not fit.
> Otherwise I'll post them beginning of next week.

