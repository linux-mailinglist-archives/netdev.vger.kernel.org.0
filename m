Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AD16DE5D0
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 22:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbjDKUhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjDKUhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 16:37:06 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01978272A
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 13:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=4b5OCSiO3lc5iQWAWv0u3VQ7k4U5b+p5/4g7bGqJLHc=; b=VRJvx4FK8m5TlgV16mLO1hxwUb
        WJcbPeK//Tk+hE5OekmeuN+n0cOQ3UAn699j7SaLKFHzqAh7kzjDrpeTOwQu5dngFSE8d1oM73BMU
        yO8LngV17l1RVSCq1pYf9rVquaYHH2eNfcgHirXJ6L6vwTVaG1wMveEhbtiuXzgFRVtU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmKjT-00A1lG-0h; Tue, 11 Apr 2023 22:36:51 +0200
Date:   Tue, 11 Apr 2023 22:36:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH v2 net-next 2/7] net: ethtool: attach an IDR of
 custom RSS contexts to a netdevice
Message-ID: <ecaae93a-d41d-4c3d-8e52-2800baa7080d@lunn.ch>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16030cc69a6726cda461290a3d6bed9c48db7562.1681236653.git.ecree.xilinx@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  /**
>   * struct ethtool_netdev_state - per-netdevice state for ethtool features
> + * @rss_ctx_max_id:	maximum (exclusive) supported RSS context ID
> + * @rss_ctx:		IDR storing custom RSS context state
>   * @wol_enabled:	Wake-on-LAN is enabled
>   */
>  struct ethtool_netdev_state {
> +	u32			rss_ctx_max_id;
> +	struct idr		rss_ctx;
>  	unsigned		wol_enabled:1;
>  };

A nitpick. On 64 bit systems, you have a hole between rss_ctx_max_id
and rss_ctx. If you swap those around, and change wol_enabled to also
be a u32 bitfield, the compiler can probably do without the hole.

   Andrew
