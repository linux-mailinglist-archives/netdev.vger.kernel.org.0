Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8921667A90E
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 04:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233737AbjAYDET (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 22:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjAYDES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 22:04:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995994997B;
        Tue, 24 Jan 2023 19:04:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 314876142A;
        Wed, 25 Jan 2023 03:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF67C433EF;
        Wed, 25 Jan 2023 03:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674615856;
        bh=igb7WvcKpQrOtnqtJvRzOxWVfsF2h9ytI87BrJP72u0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=edG7OtEkuRhj+tdiK6wNdvOLW1ITIcoRL5lkytM56LUKIvt2S3oji69jHqp33vWlV
         L6pYQvXKmM4Eq9DRLYNP4u/RrAZwPaIUjvKzJxWmSmx2zO2OXXva+RGN8zRh2rP5gd
         3ZIREptSnUm6op6zbx+Bw2E+HlG07MrOl0ejjf2b4mDO50ZctKZeJ7pXH08ij9OfDa
         Fo0w4eToY+yG2X+5zR6h2kZP1axqh5gIGV0havovqqqKLO1Y4mzVL++YZtVSS+JJ9x
         p78+AY1rwemWwAyR8vUyiWc59rWXPulzWHBHB7puwr0OtvJZwCvWMy+XNmHLSO58vp
         JtpyxuAsG2BWg==
Date:   Tue, 24 Jan 2023 19:04:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        hawk@kernel.org, pabeni@redhat.com, edumazet@google.com,
        toke@redhat.com, memxor@gmail.com, alardam@gmail.com,
        saeedm@nvidia.com, anthony.l.nguyen@intel.com, gospo@broadcom.com,
        vladimir.oltean@nxp.com, nbd@nbd.name, john@phrozen.org,
        leon@kernel.org, simon.horman@corigine.com, aelior@marvell.com,
        christophe.jaillet@wanadoo.fr, ecree.xilinx@gmail.com,
        mst@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        maciej.fijalkowski@intel.com, intel-wired-lan@lists.osuosl.org,
        lorenzo.bianconi@redhat.com, martin.lau@linux.dev
Subject: Re: [PATCH v2 bpf-next 2/8] drivers: net: turn on XDP features
Message-ID: <20230124190414.2dab95a2@kernel.org>
In-Reply-To: <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
References: <cover.1674606193.git.lorenzo@kernel.org>
        <c1171111f8af76da11331277b1e4a930c10f3c30.1674606197.git.lorenzo@kernel.org>
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

On Wed, 25 Jan 2023 01:33:22 +0100 Lorenzo Bianconi wrote:
> A summary of the flags being set for various drivers is given below.
> Note that XDP_F_REDIRECT_TARGET and XDP_F_FRAG_TARGET are features
> that can be turned off and on at runtime. This means that these flags
> may be set and unset under RTNL lock protection by the driver. Hence,
> READ_ONCE must be used by code loading the flag value.
> 
> Also, these flags are not used for synchronization against the availability
> of XDP resources on a device. It is merely a hint, and hence the read
> may race with the actual teardown of XDP resources on the device. This
> may change in the future, e.g. operations taking a reference on the XDP
> resources of the driver, and in turn inhibiting turning off this flag.
> However, for now, it can only be used as a hint to check whether device
> supports becoming a redirection target.

Acked-by: Jakub Kicinski <kuba@kernel.org>
