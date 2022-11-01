Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D316142C2
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbiKABXv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:23:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiKABXu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58066165A5
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:23:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0BA3614E1
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 01:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12046C433C1;
        Tue,  1 Nov 2022 01:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667265829;
        bh=LdDofckJwI6xNbcR9Mk2k4lNylfHYzPE/rh1J48piLU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Rbyjgdah99llbOJ2xb2EHriDyyu5mpUEuDDRNbW8HxVf9E+rHfVjsonqXKsS/ai1L
         sgXnMK9td5SP6Ii5JV20371czUxRmCk1wOwGHeETZC82ihrz4Ue8pRDuXs8v+dTMHK
         kA1PtfU5heWlq7h7J+yE8pBRbZS9bXL9m4n/m3TgSS4NUX84ktYM/cIoK3zMuLdJWU
         pFdqmYffDLRHf6C6QWHAjwssStG4Lh62L3TBZ/jUCnniqd1ypGpyPg1S6CgPA2c2Qn
         72eZmKNfuAa9MR+fUWsi/Mch1ilQITcXNVll3kCAMTX/F2l9qK0TQmz54QAQ6774/6
         vN8x/aXIIMrdA==
Date:   Mon, 31 Oct 2022 18:23:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net-next] ethtool: Fail number of channels change when
 it conflicts with rxnfc
Message-ID: <20221031182348.3e8ddb4e@kernel.org>
In-Reply-To: <20221031100016.6028-1-gal@nvidia.com>
References: <20221031100016.6028-1-gal@nvidia.com>
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

On Mon, 31 Oct 2022 12:00:16 +0200 Gal Pressman wrote:
> Similar to what we do with the hash indirection table [1], when network
> flow classification rules are forwarding traffic to channels greater
> than the requested number of channels, fail the operation.
> Without this, traffic could be directed to channels which no longer
> exist (dropped) after changing number of channels.
> 
> [1] commit d4ab4286276f ("ethtool: correctly ensure {GS}CHANNELS doesn't conflict with GS{RXFH}")

Have you made sure there are no magic encodings of queue numbers this
would break? I seem to recall some vendors used magic queue values to
redirect to VFs before TC and switchdev. If that's the case we'd need
to locate the drivers that do that and flag them so we can enforce this
only going forward?
