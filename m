Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508926AFCD0
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 03:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCHCSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 21:18:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCHCSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 21:18:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73711A4025;
        Tue,  7 Mar 2023 18:18:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F034CB81B7F;
        Wed,  8 Mar 2023 02:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CB4C433EF;
        Wed,  8 Mar 2023 02:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678241910;
        bh=6wxy5EF2hBtBjFhi7JtdgkXz1Y7l+1DAMshVMsoLgPs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N6S4g0ysQN9ZWEuw7Xa0WDp8Q2x1gUjkBMs0lfYYYezImpxMK+J5WwX2aHfrIqIi+
         srNRIZ6HD5mpCjUFQjyYkNBWkxG74Ssn9Su1Qm8wfSBo/rOeZibjgzStKAEIXBn4S9
         4Wh1GC5rrwF2Y/oeE/pnS2Ll2CEULp/6Zf06d8aMoP/wEXEv7E70LRljAMuin7IPPB
         pKu9bhciDtE3BlpkXxeFMk++18Oo8ngyvOqJMqzY6SUuYUgSYHX/DRVzeVc5R3V2rx
         pbCGHwtGtz5g0v3wEdDgSJ4jKIIgGE8gyYUc/oXZmnayEFYwtQHm0sIHZmtFBQBRXv
         wNwbefQkjDQyw==
Date:   Tue, 7 Mar 2023 18:18:29 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org,
        Tirthendu Sarkar <tirthendu.sarkar@intel.com>,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org,
        Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: Re: [PATCH net-next 2/8] i40e: change Rx buffer size for legacy-rx
 to support XDP multi-buffer
Message-ID: <20230307181829.5dcec646@kernel.org>
In-Reply-To: <20230306210822.3381942-3-anthony.l.nguyen@intel.com>
References: <20230306210822.3381942-1-anthony.l.nguyen@intel.com>
        <20230306210822.3381942-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  6 Mar 2023 13:08:16 -0800 Tony Nguyen wrote:
> In the legacy-rx mode, driver can only configure up to 2k sized Rx buffers
> and with the current configuration of 2k sized Rx buffers there is no way
> to do tailroom reservation for skb_shared_info. Hence size of Rx buffers
> is now lowered to 1664 (2k - sizeof(skb_shared_info)). Also, driver can

skb_shared_info is not fixed size, the number of fragments can 
be changed in the future. What will happen to the driver and
this assumption, then?

> only chain up to 5 Rx buffers and this means max MTU supported for
> legacy-rx is now 8320.
