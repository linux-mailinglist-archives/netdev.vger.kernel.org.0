Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D75F6423EC
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 08:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbiLEH7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 02:59:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231819AbiLEH7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 02:59:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BD941144B;
        Sun,  4 Dec 2022 23:59:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED8860FA1;
        Mon,  5 Dec 2022 07:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF277C433C1;
        Mon,  5 Dec 2022 07:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670227147;
        bh=A/HNLNucTgPNacp68QdzI0RTg4NuTQugxg0nvBA0coE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JeDvaHhnklF+bJzbxCEoxbj9pq4nQRC3l4ik90CtTLny8hJhtHMXxgEGuzqf5oQmS
         lEfZn4xHNIAC8ffDXtTJoOyPv82zqt9Hkweumkc/vgtoutmOKm/U1aJklZwc9LTten
         Io6UEcMXLMkQ+p9yLDoXi4f27exFA8CzQLWiGSmDbHq5HP7zwRoRiOLRshzXGvkXnP
         5o5hUFWWb9mxyVWy8sqbEySH02D7DsbUrATjTfMVqJcVGJ2oRBclNU9pSMPZT9JQBi
         mbq42I2VjUAQl09mMBZPTrge38MX6TN5wXOFPEDh8izfrmKk3AQYgedQqqpxQRzsWb
         PD87jzcZhbl+w==
Date:   Mon, 5 Dec 2022 09:59:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ziyang Xuan (William)" <william.xuanziyang@huawei.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] octeontx2-pf: Fix potential memory leak in
 otx2_init_tc()
Message-ID: <Y42kxuydRXM2kO+1@unreal>
References: <20221202110430.1472991-1-william.xuanziyang@huawei.com>
 <Y4yYzlzPKix6VloH@unreal>
 <206c4fdc-bba2-32e3-8e44-82cad81e0436@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <206c4fdc-bba2-32e3-8e44-82cad81e0436@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:31:02AM +0800, Ziyang Xuan (William) wrote:
> > On Fri, Dec 02, 2022 at 07:04:30PM +0800, Ziyang Xuan wrote:
> >> In otx2_init_tc(), if rhashtable_init() failed, it does not free
> >> tc->tc_entries_bitmap which is allocated in otx2_tc_alloc_ent_bitmap().
> >>
> >> Fixes: 2e2a8126ffac ("octeontx2-pf: Unify flow management variables")
> >> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> >> ---
> >> v2:
> >>   - Remove patch 2 which is not a problem, see the following link:
> >>     https://www.spinics.net/lists/netdev/msg864159.html
> >> ---
> >>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 ++++++-
> >>  1 file changed, 6 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >> index e64318c110fd..6a01ab1a6e6f 100644
> >> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
> >> @@ -1134,7 +1134,12 @@ int otx2_init_tc(struct otx2_nic *nic)
> >>  		return err;
> >>  
> >>  	tc->flow_ht_params = tc_flow_ht_params;
> >> -	return rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
> >> +	err = rhashtable_init(&tc->flow_table, &tc->flow_ht_params);
> >> +	if (err) {
> >> +		kfree(tc->tc_entries_bitmap);
> >> +		tc->tc_entries_bitmap = NULL;
> > 
> > Why do you set NULL here? All callers of otx2_init_tc() unwind error
> > properly.
> 
> See the implementation of otx2_tc_alloc_ent_bitmap() as following:
> 
> int otx2_tc_alloc_ent_bitmap(struct otx2_nic *nic)
> {
> 	struct otx2_tc_info *tc = &nic->tc_info;
> 
> 	if (!nic->flow_cfg->max_flows)
> 		return 0;
> 
> 	/* Max flows changed, free the existing bitmap */
> 	kfree(tc->tc_entries_bitmap);

It is worthless call for probe() calls as tc->tc_entries_bitmap is always NULL
at this point for them.

The kfree(tc->tc_entries_bitmap); needs to be moved into otx2_dl_mcam_count_set()
as it is the one place which can change bitmap.

But ok, it is probably too much to request.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
