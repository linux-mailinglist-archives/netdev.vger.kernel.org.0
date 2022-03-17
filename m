Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 610F24DBD64
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356334AbiCQDL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 23:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348676AbiCQDL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 23:11:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7D7921263;
        Wed, 16 Mar 2022 20:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AB58B81E03;
        Thu, 17 Mar 2022 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9934C340E9;
        Thu, 17 Mar 2022 03:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647486610;
        bh=e/PPn60G5qEvsRXD5WUY9tg3EdpolMuM9Bv/C+K34rU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L4l3EOB59AQyDmd98y4qHgkslq0cCT3+K+qcuB1uA+tc8cRpjsqZfPnwNlrQTxQex
         VkvswGYJZ1Q0+ez9pNL3gHoW8SlZJw/wHfa56KrUPXkY4oA81jeRxgHhWg2BiJir0w
         eC7+qmQi0vnHKLYdDVfnFP9n34k0VkIUjTo5Jd26BuafH//wxOerghGXkbNFdrwSRI
         ohK492lryUn46z/K95UnCMKouyU6AxUDe8XmPoaD92hAObuvhdq5tMnGwNaJt9kbub
         PiSJndkfjEhQFWNcSwxuPahxGq0gQWzE1fJpmaPL9sYO2xjmvvrbn6+tlkKRIMjy1v
         YPa/1qXyDL6xw==
Date:   Wed, 16 Mar 2022 20:10:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, bigeasy@linutronix.de,
        atenart@kernel.org, imagedong@tencent.com, petrm@nvidia.com,
        arnd@arndb.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.chan@broadcom.com,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Rasesh Mody <rmody@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Chris Lee <christopher.lee@cspi.com>,
        Jon Mason <jdmason@kudzu.us>,
        Simon Horman <simon.horman@corigine.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Subject: Re: [PATCH net-next] net: set default rss queues num to physical
 cores / 2
Message-ID: <20220316201007.41aeb5f7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315091832.13873-1-ihuguet@redhat.com>
References: <20220315091832.13873-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 10:18:32 +0100 =C3=8D=C3=B1igo Huguet wrote:
> Network drivers can call to netif_get_num_default_rss_queues to get the
> default number of receive queues to use. Right now, this default number
> is min(8, num_online_cpus()).
>=20
> Instead, as suggested by Jakub, use the number of physical cores divided
> by 2 as a way to avoid wasting CPU resources and to avoid using both CPU
> threads, but still allowing to scale for high-end processors with many
> cores.
>=20
> As an exception, select 2 queues for processors with 2 cores, because
> otherwise it won't take any advantage of RSS despite being SMP capable.
>=20
> Tested: Processor Intel Xeon E5-2620 (2 sockets, 6 cores/socket, 2
> threads/core). NIC Broadcom NetXtreme II BCM57810 (10GBps). Ran some
> tests with `perf stat iperf3 -R`, with parallelisms of 1, 8 and 24,
> getting the following results:
> - Number of queues: 6 (instead of 8)
> - Network throughput: not affected
> - CPU usage: utilized 0.05-0.12 CPUs more than before (having 24 CPUs
>   this is only 0.2-0.5% higher)
> - Reduced the number of context switches by 7-50%, being more noticeable
>   when using a higher number of parallel threads.

Thanks for following up, Inigo!

Heads up for the maintainers of drivers which use
netif_get_num_default_rss_queues() today - please note the above -=20
the default number of Rx queues may change for you starting with=20
the 5.18 kernel.
