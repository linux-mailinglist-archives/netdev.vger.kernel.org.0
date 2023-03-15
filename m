Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9F56BAB70
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCOJCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbjCOJCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:02:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541D273ADF
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:01:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C068B81DAB
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 09:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D67C4339B;
        Wed, 15 Mar 2023 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678870916;
        bh=1DhMS93JxiqZ9s26g7VBcskN8lkbQw7BiGV6SrMjpu4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Obq8wpNR2wB7fWIkCtDrlTjtXXaAwT54DSWosxK6UzqYoqx5fkVwXVDahEvw67WCV
         128/I1GT6qs2ouvbE3vTm/6ltHnytBHgDAGxhoU2VXcBckfX1CZSzwqDoUp2HOxtEU
         BhF2hxwHtMXwYXRBKhwCpODoFpef+vIyzknCTkjHzeTr72dYD8h9SqwTfQbV8dCpt8
         LwkbEbziEgPU17uPQKaYL9KA6y6PENmJfzSaRH4Ve/q6rahefk+AhutzPBxtO7YkMs
         a4mQzgZRbSeMmMeBcOWTH2zK5+ZKAkeImdyeV37zV8+SqzMY9dBr25IkjFPD5U20nq
         BI25cmzXGZr4g==
Date:   Wed, 15 Mar 2023 11:01:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/14][pull request] ice: refactor mailbox
 overflow detection
Message-ID: <20230315090152.GS36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
 <20230314135758.GK36557@unreal>
 <c58fe076-3425-394f-b7da-c6df6ac45d98@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c58fe076-3425-394f-b7da-c6df6ac45d98@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 02:26:10PM -0700, Jacob Keller wrote:
> 
> 
> On 3/14/2023 6:57 AM, Leon Romanovsky wrote:
> > On Mon, Mar 13, 2023 at 11:21:09AM -0700, Tony Nguyen wrote:
> >> Jake Keller says:
> >>
> >> The primary motivation of this series is to cleanup and refactor the mailbox
> >> overflow detection logic such that it will work with Scalable IOV. In
> >> addition a few other minor cleanups are done while I was working on the
> >> code in the area.
> >>
> >> First, the mailbox overflow functions in ice_vf_mbx.c are refactored to
> >> store the data per-VF as an embedded structure in struct ice_vf, rather than
> >> stored separately as a fixed-size array which only works with Single Root
> >> IOV. This reduces the overall memory footprint when only a handful of VFs
> >> are used.
> >>
> >> The overflow detection functions are also cleaned up to reduce the need for
> >> multiple separate calls to determine when to report a VF as potentially
> >> malicious.
> >>
> >> Finally, the ice_is_malicious_vf function is cleaned up and moved into
> >> ice_virtchnl.c since it is not Single Root IOV specific, and thus does not
> >> belong in ice_sriov.c
> >>
> >> I could probably have done this in fewer patches, but I split pieces out to
> >> hopefully aid in reviewing the overall sequence of changes. This does cause
> >> some additional thrash as it results in intermediate versions of the
> >> refactor, but I think its worth it for making each step easier to
> >> understand.
> >>
> >> The following are changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:
> >>   qede: remove linux/version.h and linux/compiler.h
> >> and are available in the git repository at:
> >>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
> >>
> >> Jacob Keller (14):
> >>   ice: re-order ice_mbx_reset_snapshot function
> >>   ice: convert ice_mbx_clear_malvf to void and use WARN
> >>   ice: track malicious VFs in new ice_mbx_vf_info structure
> >>   ice: move VF overflow message count into struct ice_mbx_vf_info
> >>   ice: remove ice_mbx_deinit_snapshot
> >>   ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
> >>   ice: initialize mailbox snapshot earlier in PF init
> >>   ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
> >>   ice: always report VF overflowing mailbox even without PF VSI
> >>   ice: remove unnecessary &array[0] and just use array
> >>   ice: pass mbxdata to ice_is_malicious_vf()
> >>   ice: print message if ice_mbx_vf_state_handler returns an error
> >>   ice: move ice_is_malicious_vf() to ice_virtchnl.c
> >>   ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()
> > 
> > Everything looks legit except your anti-spamming logic which IMHO
> > shouldn't happen in first place.
> > 
> 
> Without the checks there's no warning to the system administrator that a
> VM may have been misconfigured or modified to spam messages. If this
> occurs, the VM can overload the PF's mailbox queue and prevent other VFs
> from using the queue normally, and thus performing a denial of service.
> 
> My understanding (I was not involved in the original implementation or
> discussions) is that there is no hardware mechanism to prevent such
> overflow in this device. This is an oversight in the design which was
> not caught until it was too late to make such a change.
> 
> The original checks were added in 0891c89674e8 ("ice: warn about
> potentially malicious VFs"), but it seems that commit message did not
> provide much detail :(

Thanks for the explanation.

> 
> -Jake
> 
> > Thanks,
> > Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
