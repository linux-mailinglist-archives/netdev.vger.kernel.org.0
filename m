Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0035861FBC4
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbiKGRpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:45:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232132AbiKGRpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:45:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430AA22297
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 09:45:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA37FB81608
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 17:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C71C433C1;
        Mon,  7 Nov 2022 17:45:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667843120;
        bh=cL0Cmn1wMSgyZwA7z18q8ng4pj7xfO231EleFGDrTNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cKLweVQxAximlaYYUdVyVnlFYThWpbJvwt/OhHpsbx0ZhBjl+pqGe2N05tE5v4gzH
         FEIC13zcYsdlm/CSLM/RCPBYrbq+CEj7lePrRvbyt1bXIDq93WRKQ49ZEYsgsN2eKI
         pZfRawMG4B3K3I41fnUDcXRApzmmojsuoX/V/n8Io0K+3aYyMXQ1JwGgN6RKIDl2T1
         H3oIaOpCLds4DQbsa8aGZ8TTm65XPqyb1cBTgIF/GSRuP/uKm5hDQmtN5vDvLb1Rg3
         HaWmEdKsh2IJCixttrZZ4yUtiyAfFFYy1P/CkxTVoaHOAfBSgH59G+4P0QH/ipCX8t
         Xh8taIO0hAnng==
Date:   Mon, 7 Nov 2022 19:45:15 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     "Ruhl, Michael J" <michael.j.ruhl@intel.com>
Cc:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one
 was allocated
Message-ID: <Y2lEK4CMdCyEMBLf@unreal>
References: <20221104205414.2354973-1-anthony.l.nguyen@intel.com>
 <20221104205414.2354973-6-anthony.l.nguyen@intel.com>
 <Y2itqqGQm6uZ/2Wf@unreal>
 <DM5PR11MB1324FDF4D4399A6A99727B5EC13C9@DM5PR11MB1324.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM5PR11MB1324FDF4D4399A6A99727B5EC13C9@DM5PR11MB1324.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 01:55:58PM +0000, Ruhl, Michael J wrote:
> >-----Original Message-----
> >From: Leon Romanovsky <leon@kernel.org>
> >Sent: Monday, November 7, 2022 2:03 AM
> >To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> >Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> >edumazet@google.com; Kees Cook <keescook@chromium.org>;
> >netdev@vger.kernel.org; Brandeburg, Jesse <jesse.brandeburg@intel.com>;
> >intel-wired-lan@lists.osuosl.org; Ruhl, Michael J <michael.j.ruhl@intel.com>;
> >Keller, Jacob E <jacob.e.keller@intel.com>; G, GurucharanX
> ><gurucharanx.g@intel.com>
> >Subject: Re: [PATCH net-next 5/6] igb: Do not free q_vector unless new one
> >was allocated
> >
> >On Fri, Nov 04, 2022 at 01:54:13PM -0700, Tony Nguyen wrote:
> >> From: Kees Cook <keescook@chromium.org>
> >>
> >> Avoid potential use-after-free condition under memory pressure. If the
> >> kzalloc() fails, q_vector will be freed but left in the original
> >> adapter->q_vector[v_idx] array position.
> >>
> >> Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
> >> Cc: Tony Nguyen <anthony.l.nguyen@intel.com>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Eric Dumazet <edumazet@google.com>
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Cc: Paolo Abeni <pabeni@redhat.com>
> >> Cc: intel-wired-lan@lists.osuosl.org
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
> >> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
> >> Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker
> >at Intel)
> >
> >You should use first and last names here.
> >
> >> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> >> ---
> >>  drivers/net/ethernet/intel/igb/igb_main.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/net/ethernet/intel/igb/igb_main.c
> >b/drivers/net/ethernet/intel/igb/igb_main.c
> >> index d6c1c2e66f26..c2bb658198bf 100644
> >> --- a/drivers/net/ethernet/intel/igb/igb_main.c
> >> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> >> @@ -1202,8 +1202,12 @@ static int igb_alloc_q_vector(struct igb_adapter
> >*adapter,
> >>  	if (!q_vector) {
> >>  		q_vector = kzalloc(size, GFP_KERNEL);
> >>  	} else if (size > ksize(q_vector)) {
> >> -		kfree_rcu(q_vector, rcu);
> >> -		q_vector = kzalloc(size, GFP_KERNEL);
> >> +		struct igb_q_vector *new_q_vector;
> >> +
> >> +		new_q_vector = kzalloc(size, GFP_KERNEL);
> >> +		if (new_q_vector)
> >> +			kfree_rcu(q_vector, rcu);
> >> +		q_vector = new_q_vector;
> >
> >I wonder if this is correct.
> >1. if new_q_vector is NULL, you will overwrite q_vector without releasing it.
> >2. kfree_rcu() doesn't immediately release memory, but after grace
> >period, but here you are overwriting the pointer which is not release
> >yet.
> 
> The actual pointer is: adapter->q_vector[v_idx]
> 
> q_vector is just a convenience pointer.
> 
> If the allocation succeeds, the q_vector[v_idx] will be replaced (later in the code).
> 
> If the allocation fails, this is not being freed.  The original code freed the adapter
> pointer but didn't not remove the pointer.
> 
> If q_vector is NULL,  (i.e. the allocation failed), the function exits, but the original
> pointer is left in place.
> 
> I think this logic is correct.
> 
> The error path leaves the original allocation in place.  If this is incorrect behavior,
> a different change would be:
> 
> 	q_vector = adapter->q_vector[v_idx];
> 	adapter->q_vector[v_idx] = NULL;
> 	... the original code...
> 
> But I am not sure if that is what is desired?

I understand the issue what you are trying to solve, I just don't
understand your RCU code. I would expect calls to rcu_dereference()
in order to get q_vector and rcu_assign_pointer() to clear
adapter->q_vector[v_idx], but igb has none.

Thanks
