Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F8619F60
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbiKDSAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:00:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiKDR77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 13:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A0A45A16
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 10:59:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79CF4B82EFF
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 17:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABADC433C1;
        Fri,  4 Nov 2022 17:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667584796;
        bh=q5TKB1CM8Jc0B8Zxl83Fxzre7gqt/p60B+6q28/l8hY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nWBuwabCdZtGb53K5xdYbO3q3YO6VJ7ScX0bKvGEgGwWUsmvDuwGcj7GzB3XW+dUx
         7451tXNaXBdCpLr+XFuxLvyicwENhyW+EX9cMy4/dxn4ngm6Gg/zMY2l7FlR2lQU9q
         Dgb9PJjj4VPHGTty/In3t+nSKuLJpzHFoGame44qgIVNH5wv3XinudRElSE7VZygC8
         lKBa/k+e2i/LLqk0UaZVfpG8MZASjY+JOHpMu92DJ5C3txydJjExLc9dj7qTn/LgsZ
         AHo0kUQUo4ANVOw9jh5KnnK1sgU4HBD2u6qBW0lqHrSySnWJ+p3iLBQcNUdTyxWau4
         CXCL+6BFUkdqQ==
Date:   Fri, 4 Nov 2022 10:59:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
Subject: Re: [PATCH v2 net] ibmveth: Reduce maximum tx queues to 8
Message-ID: <20221104105955.2c3c74a7@kernel.org>
In-Reply-To: <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
References: <20221102183837.157966-1-nnac123@linux.ibm.com>
        <20221103205945.40aacd90@kernel.org>
        <4f84f10b-9a79-17f6-7e2e-f65f0d2934cb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Nov 2022 09:06:02 -0500 Nick Child wrote:
> On 11/3/22 22:59, Jakub Kicinski wrote:
> > On Wed,  2 Nov 2022 13:38:37 -0500 Nick Child wrote:  
> >> Previously, the maximum number of transmit queues allowed was 16. Due to
> >> resource concerns, limit to 8 queues instead.
> >>
> >> Since the driver is virtualized away from the physical NIC, the purpose
> >> of multiple queues is purely to allow for parallel calls to the
> >> hypervisor. Therefore, there is no noticeable effect on performance by
> >> reducing queue count to 8.  
> > 
> > I'm not sure if that's the point Dave was making but we should be
> > influencing the default, not the MAX. Why limit the MAX?  
> 
> The MAX is always allocated in the drivers probe function. In the 
> drivers open and ethtool-set-channels functions we set 
> real_num_tx_queues. So the number of allocated queues is always MAX
> but the number of queues actually in use may differ and can be set by 
> the user.
> I hope this explains. Otherwise, please let me know.

Perhaps I don't understand the worry. Is allowing 16 queues a problem
because it limits how many instances the hypervisor can support?
Or is the concern coming from your recent work on BQL and having many
queues exacerbating buffer bloat?
