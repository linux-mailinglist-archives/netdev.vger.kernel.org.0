Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF814D599E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:35:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346307AbiCKEfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343736AbiCKEfV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:35:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0FDC0869
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:34:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD3BD618A0
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C1AC340EE;
        Fri, 11 Mar 2022 04:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973258;
        bh=LiylftN3e+0xnGnmNyW8cOp29QHmPXMuMQ3Adkf0iT0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qeNMJW9NbGKKublWMLftelc5d8EbvX9BUNZtCp5frTNm2/N5KUjUEZF62GQx/eui+
         diaTTy09QavHGCxTgGajyVSDol9K7cAHkU/fFdzOXM25rAKY5hPxTUaIeyT9uxwIuS
         JqVXTBjUqYlYo8HnT/mP1Q6rNzSBPISr+8iJqhAGedkbP0aq78Uo6hFHME8NEY9vdy
         T+star8pODwJq1pLDm8lW1mvHe69mftq82YdRyR/Vw94xqAFhDybJxBrLlcuk/Q57H
         7MXi6jAfomCeA4r1d2nFi803RnMEy55v75Hko3T6PW2Wq7HDnHGi3YwyN/MCuCH2Jp
         VC0U7vGwXBp9Q==
Date:   Thu, 10 Mar 2022 20:34:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Kiran Patil <kiran.patil@intel.com>,
        netdev@vger.kernel.org, sudheer.mogilappagari@intel.com,
        sridhar.samudrala@intel.com, amritha.nambiar@intel.com,
        jiri@nvidia.com, leonro@nvidia.com,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net-next 2/2] ice: Add inline flow director support for
 channels
Message-ID: <20220310203416.3b725bd2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
References: <20220310231235.2721368-1-anthony.l.nguyen@intel.com>
        <20220310231235.2721368-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 15:12:35 -0800 Tony Nguyen wrote:
> Inline flow director can be configured for each TC via devlink
> params based interface.
> 
> /* Create 4 TCs */
> tc qdisc add dev enp175s0f0 root mqprio num_tc 4 map 0 1 2 3 \
>              queues 2@0 8@2 8@10 8@18 hw 1 mode channel
> 
> /* Enable inline flow director for TC1 and TC2 */
> devlink dev param set pci/0000:af:00.0 \
>         name tc_inline_fd value 6 cmode runtime
> 
> /* Dump inline flow director setting */
> devlink dev param show  pci/0000:af:00.0 name tc_inline_fd
> pci/0000:af:00.0:
>   name tc2_inline_fd type driver-specific
>     values:
>       cmode runtime value 6

Why is this in devlink and not ethtool?

All devlink params must be clearly documented.
