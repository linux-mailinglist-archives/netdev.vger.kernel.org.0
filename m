Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FCD05BFEFE
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 15:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiIUNex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 09:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiIUNew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 09:34:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F88522BEB
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 06:34:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF5B06240F
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 13:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AA0C433D6;
        Wed, 21 Sep 2022 13:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663767290;
        bh=fhiCjTHOQelxos68YalQ6VdXnhh74fTAe5lsAOK4i2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fHExkSZYpm1WU8RwsJAmrTEMSLdtxl6EOUJvf5biEBbpVe8DNKbANiQFUcJvN7Q/g
         jxOREIuEAwG29fZrTI3YRZehjmEy6f0dW+T4mhrxcDiL+4Ek7gNnIW7vvWBDIuaB1t
         BzAn+pyZi1/JtS2pQYntfrbKhTbt1nqQ0iaHBi6IaCP5oogX3haWGhtnNy3RHoSmIB
         DzpvcqT9702V+3sPSruEwLEcMkdQbRp4ohmdkKYPlVAk9C7MXmyc7x/WLhga7KrjKY
         NB6H6JJrTIhhbh8ETmTn3tL11n5i4a+BwFF+HzqqGVa3xig9lg6HheHExv+H9v6Rum
         oq2DniMJA9WDA==
Date:   Wed, 21 Sep 2022 06:34:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Diana Wang <na.wang@corigine.com>,
        Peng Zhang <peng.zhang@corigine.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Gal Pressman <gal@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: driver uABI review list? (was: Re: [PATCH/RFC net-next 0/3] nfp:
 support VF multi-queues configuration)
Message-ID: <20220921063448.5b0dd32b@kernel.org>
In-Reply-To: <20220920151419.76050-1-simon.horman@corigine.com>
References: <20220920151419.76050-1-simon.horman@corigine.com>
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

On Tue, 20 Sep 2022 16:14:16 +0100 Simon Horman wrote:
> this short series adds the max_vf_queue generic devlink device parameter,
> the intention of this is to allow configuration of the number of queues
> associated with VFs, and facilitates having VFs with different queue
> counts.
> 
> The series also adds support for multi-queue VFs to the nfp driver
> and support for the max_vf_queue feature described above.

I think a similar API was discussed in the past by... Broadcom?
IIRC they wanted more flexibility, i.e. being able to set the
guaranteed and max allowed queue count.

Overall this seems like a typical resource division problem so 
we should try to use the devlink resource API or similar. More 
complex policies like guaranteed+max are going to be a pain over
params.


I wanted to ask a more general question, however. I see that you
haven't CCed even the major (for some def.) vendors' maintainers.

Would it be helpful for participation if we had a separate mailing 
list for discussing driver uAPI introduction which would hopefully 
be lower traffic? Or perhaps we can require a subject tag ([PATCH
net-next uapi] ?) so that people can set up email filters?

The cost is obviously yet another process thing to remember, and 
while this is nothing that lore+lei can't already do based on file 
path filters - I doubt y'all care enough to set that up for
yourselves... :)
