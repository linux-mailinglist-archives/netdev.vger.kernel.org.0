Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0B851742A
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 18:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbiEBQZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 12:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiEBQZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 12:25:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1C6764C
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 09:21:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3797B81898
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 16:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5767DC385A4;
        Mon,  2 May 2022 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651508495;
        bh=U6GDTXbuqBebJbd+lkj2uWiA1dIME9lLyxhLrBtzwGY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OphhGjEah5uEwvvaXbruhD8EgAtW1znMEO+NQlkV8WAU9wUytGjKlbpB/di3avDm6
         CwJdCbAeCpET2Qec10pQucPShaVx4RcRh46WzPU6W6asS7XwbLy962Kr3AZCOVdAuq
         1vtMZZaf2DNfWTyJvGr61zjv1OSrQdxElXli28eBSsN17U4Q5ZfWpxtu6pWjrRlwkz
         7Tlnn2Fq16fX7kZeaDwkcsrntFPoIw/YqeLyWB4Fzz20rTrnJQ8IkwMNJDapcgTKq0
         kkzZZVSSq1aEmX+EIDeDBXKddJ56jEIpaYWp2WGc+AndpsJcMhzmpWn6wRrVJEnGpc
         F9v2JkUTZPPzA==
Date:   Mon, 2 May 2022 09:21:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eli Cohen <elic@nvidia.com>
Cc:     virtualization <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: utilizing multi queues of a net device
Message-ID: <20220502092134.160f43b3@kernel.org>
In-Reply-To: <DM8PR12MB5400B7E41EB88FF4C9E0F87AABC19@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <DM8PR12MB5400B7E41EB88FF4C9E0F87AABC19@DM8PR12MB5400.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 May 2022 04:29:09 +0000 Eli Cohen wrote:
> Hi all,
> 
> I am experimenting with virtio net device running on a host. The net device has
> multiple queues and I am trying to measure the throughput while utilizing all
> the queues simultaneously. I am running iperf3 like this:
> 
> taskset 0x1 iperf3 -c 7.7.7.24 -p 20000 & \
> taskset 0x2 iperf3 -c 7.7.7.24 -p 20001 & \
> ...
> taskset 0x80 iperf3 -c 7.7.7.24 -p 20007
> 
> Server instances with matching ports exist.
> 
> I was expecting traffic to be distributed over the available send queues but
> the vast majority goes to a single queue. I do see a few packets going to other
> queues.
> 
> Here's what tc qdisc shows:
> 
> tc qdisc show dev eth1
> qdisc mq 0: root
> qdisc fq_codel 0: parent :8 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :7 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :6 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :5 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :4 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :3 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :2 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> qdisc fq_codel 0: parent :1 limit 10240p flows 1024 quantum 1514 target 5ms interval 100ms memory_limit 32Mb ecn drop_batch 64
> 
> Any idea?

Make sure XPS is configured correctly. Looks like virtio_net cooked 
a less-than-prevalent-for-networking way of distributing CPUs.
