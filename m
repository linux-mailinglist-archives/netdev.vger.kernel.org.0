Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76826D5405
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 23:54:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233658AbjDCVyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 17:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbjDCVyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 17:54:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963D42738
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:54:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2E08D62C6E
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 21:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465C6C433EF;
        Mon,  3 Apr 2023 21:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680558847;
        bh=iuJp0V9PV5EHxAewc4u3nDOED76hOCu/FCmXffBGqcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NNEizE6vH5PY5Ctigm/tCdKBmxJ5eSjxhbMZhZXgQ+x8PA0t2k1YRncF+31vd1/qC
         hbSJhdrjt/COtqVT22JjoT4D5DhYA0linXxXzvCu57mUxx2gRoL/OhpeIPKCPZBk1E
         7vlBGqKp/q6fmZdUv7mqL+IheH91Szd3WFA+I7ZfsmAHNwVbAY/EmVOqc74vlpenuN
         QRMoOwsDPMxjoRVteel/opOe5xBBus5wE8/jnLFrLaUJuA64Hq6Ic2kT2OsU6tV7lB
         IgfK0dmO15Q2b2ACsDtH/ArBZbw3aQYrRKMkzQymznw30iaHqQnNffRYv1IhG/nHc7
         5oimsfQ+xQeyQ==
Date:   Mon, 3 Apr 2023 14:54:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <edward.cree@amd.com>
Cc:     <linux-net-drivers@amd.com>, <davem@davemloft.net>,
        <pabeni@redhat.com>, <edumazet@google.com>,
        Edward Cree <ecree.xilinx@gmail.com>, <netdev@vger.kernel.org>,
        <habetsm.xilinx@gmail.com>, <sudheer.mogilappagari@intel.com>
Subject: Re: [RFC PATCH net-next 3/6] net: ethtool: let the core choose RSS
 context IDs
Message-ID: <20230403145406.5c62a874@kernel.org>
In-Reply-To: <00a28ff573df347ba0762004bc8c7aa8dfcf31f6.1680538846.git.ecree.xilinx@gmail.com>
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
        <00a28ff573df347ba0762004bc8c7aa8dfcf31f6.1680538846.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 17:33:00 +0100 edward.cree@amd.com wrote:
>  	int	(*set_rxfh_context)(struct net_device *, const u32 *indir,
>  				    const u8 *key, const u8 hfunc,
> -				    u32 *rss_context, bool delete);
> +				    u32 rss_context, bool delete);

Would it be easier to pass struct ethtool_rxfh_context instead of
doing it field by field?  Otherwise Intel will need to add more
arguments and touch all drivers. Or are you thinking that they should
use a separate callback for the "RR RSS" or whatever their thing is?

And maybe separate op for create / change / delete?

And an extack on top... :)
