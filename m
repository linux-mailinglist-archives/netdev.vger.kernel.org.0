Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1386B970F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbjCNN7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231145AbjCNN7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:59:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B66AA21A2
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:58:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B4DB8188B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 13:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C24DC433EF;
        Tue, 14 Mar 2023 13:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678802283;
        bh=jzugv9MgZwvosFFWM55+/jcF18K7V4TD3yjibmL+Sz8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ahOzlCUIepzjgDxQradjHnhd6n8MHGfI8ItHYVR+jCKD3bjQTjnW121+qV0Vrh/Ce
         jsICzXmGzstQerDj3G0pSYZyP2ljri7fKFtXsWrMhfndX+YJXeubI8qXZ8TNnDoDIs
         tgxfT6L4Aorx3Yi8lAtoh6SbVeAvfnph6bvAomn+dS9jKNYsxRenO8h0wWq0cJf0Z9
         SYhnrgLqkjkjvWK8MgxEzFoq4gboELk0Q/6OAyBeGgMhIUU2S3m513xlpdneo85b9B
         8bsPHosv7j8mo8asDdZxXpU2uOFyM53c9Mz66nPlrMo9yPcZ2ZpN2VrHbmQFsoQLBJ
         4swbX9YNu6WFQ==
Date:   Tue, 14 Mar 2023 15:57:58 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 00/14][pull request] ice: refactor mailbox
 overflow detection
Message-ID: <20230314135758.GK36557@unreal>
References: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230313182123.483057-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 11:21:09AM -0700, Tony Nguyen wrote:
> Jake Keller says:
> 
> The primary motivation of this series is to cleanup and refactor the mailbox
> overflow detection logic such that it will work with Scalable IOV. In
> addition a few other minor cleanups are done while I was working on the
> code in the area.
> 
> First, the mailbox overflow functions in ice_vf_mbx.c are refactored to
> store the data per-VF as an embedded structure in struct ice_vf, rather than
> stored separately as a fixed-size array which only works with Single Root
> IOV. This reduces the overall memory footprint when only a handful of VFs
> are used.
> 
> The overflow detection functions are also cleaned up to reduce the need for
> multiple separate calls to determine when to report a VF as potentially
> malicious.
> 
> Finally, the ice_is_malicious_vf function is cleaned up and moved into
> ice_virtchnl.c since it is not Single Root IOV specific, and thus does not
> belong in ice_sriov.c
> 
> I could probably have done this in fewer patches, but I split pieces out to
> hopefully aid in reviewing the overall sequence of changes. This does cause
> some additional thrash as it results in intermediate versions of the
> refactor, but I think its worth it for making each step easier to
> understand.
> 
> The following are changes since commit 95b744508d4d5135ae2a096ff3f0ee882bcc52b3:
>   qede: remove linux/version.h and linux/compiler.h
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 100GbE
> 
> Jacob Keller (14):
>   ice: re-order ice_mbx_reset_snapshot function
>   ice: convert ice_mbx_clear_malvf to void and use WARN
>   ice: track malicious VFs in new ice_mbx_vf_info structure
>   ice: move VF overflow message count into struct ice_mbx_vf_info
>   ice: remove ice_mbx_deinit_snapshot
>   ice: merge ice_mbx_report_malvf with ice_mbx_vf_state_handler
>   ice: initialize mailbox snapshot earlier in PF init
>   ice: declare ice_vc_process_vf_msg in ice_virtchnl.h
>   ice: always report VF overflowing mailbox even without PF VSI
>   ice: remove unnecessary &array[0] and just use array
>   ice: pass mbxdata to ice_is_malicious_vf()
>   ice: print message if ice_mbx_vf_state_handler returns an error
>   ice: move ice_is_malicious_vf() to ice_virtchnl.c
>   ice: call ice_is_malicious_vf() from ice_vc_process_vf_msg()

Everything looks legit except your anti-spamming logic which IMHO
shouldn't happen in first place.

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
