Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB4446BFFBE
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 08:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbjCSHUd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 03:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjCSHUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 03:20:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D24C132DB
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 00:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3940B808D6
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 07:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E712C4339B;
        Sun, 19 Mar 2023 07:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679210428;
        bh=BsNZaoEvaA0Os2X6oB3rext0p49t1Xg1RW15m4OqS6s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IRHF7kUBZgAw3WfPkq5oz5s/QMhv6Pc6Rj+eYAlMbqYO/gAIs2J+8oSGF0mWvJeQV
         gzDkdZWClq4raJPMV5doXUvp3rwxlbNKCZjGCYZHf13OcOTKLhpCZ7SLilhHxM2Nm8
         zhwOozfb/PyncG50Uz8enAsqlHcu/S6LHGR1J3BbIITn1YyrV2uI3Bwk1Mt4msXRZ9
         41flRW6aC6Rfh2Bcq5zPEkPClJkydsvF+IpH+oaSNu66Z3yo/4/GHqrtv/NAhuz+RO
         MFCKI4ooX7kEcbHb/K3fasuv7j4+NC1BJ5BFJ0FBxeB0ZPgGfMGfD117XNVGiUnayH
         H9VGRpA1+7eAQ==
Date:   Sun, 19 Mar 2023 09:20:23 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ahmed Zaki <ahmed.zaki@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org,
        Michal Kubiak <michal.kubiak@intel.com>,
        Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net 3/3] iavf: do not track VLAN 0 filters
Message-ID: <20230319072023.GY36557@unreal>
References: <20230314174423.1048526-1-anthony.l.nguyen@intel.com>
 <20230314174423.1048526-4-anthony.l.nguyen@intel.com>
 <20230315084856.GN36557@unreal>
 <bf4ce937-8528-69f1-7ba5-ef9772ce42aa@intel.com>
 <20230316135924.4ece7127@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316135924.4ece7127@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 01:59:24PM -0700, Jakub Kicinski wrote:
> On Thu, 16 Mar 2023 07:15:32 -0600 Ahmed Zaki wrote:
> > > I would expect similar check in iavf_vlan_rx_kill_vid(),
> >
> > Thanks for review. Next version will include the check in 
> > iavf_vlan_rx_kill_vid()
> 
> FWIW it is okay to ask more clarifying questions / push back
> a little. I had a quick look and calling iavf_vlan_rx_kill_vid()
> with vid of 0 does not seem harmful. Or any vid that was not added
> earlier. So it's down to personal preference. 

I would agree with you if they would bail immediately in case no vid is
found, however it is not the case. They continue to perform function
execution in any case, which is harmless now, but prone to errors in the
future.

Thanks
