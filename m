Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038885524F0
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 22:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbiFTUEc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 16:04:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236360AbiFTUEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 16:04:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4ED03A2
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 13:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 616D4B8125A
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 20:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8685C3411B;
        Mon, 20 Jun 2022 20:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655755468;
        bh=D7Ij3TJ1yxo4Qe4jLDUx44Zk7z9ulKk999KynpPDxYI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KB8p3fp1/ADspNpDuCo+1XrkgFExb3xK43JVWeJVahOPdBjPaKTB9OoGFyCUc2VHC
         EzOP+0cY+QV2RIe3xqvNPuZMlFOJWqjHoBCJCMZZjeRslEh5N9hmaJK/jPUF5Roi/V
         r+RiKkmZBncLvTysqIOBUgv2c4LWmv2EuKGltePvXWr7yCzj/13NA7B+JAMXDIH6G7
         h/R5Mzwa61WTCSXrSfe5YBve900+mCxAHAj4Ot9GoLhk/nETo45XN1WL9G1ky7rPJ5
         /sFx0kXB6zYpp89TdeTvCK0zfKuW7xFUXot3KBtCZ4M2A5VCgiFuSXUWMush/6brer
         ipHnjmktZmd1g==
Date:   Mon, 20 Jun 2022 13:04:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dima Chumak <dchumak@nvidia.com>
Cc:     Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/5] devlink rate police limiter
Message-ID: <20220620130426.00818cbf@kernel.org>
In-Reply-To: <20220620152647.2498927-1-dchumak@nvidia.com>
References: <20220620152647.2498927-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Jun 2022 18:26:42 +0300 Dima Chumak wrote:
> Currently, kernel provides a way to limit tx rate of a VF via devlink
> rate function of a port. The underlying mechanism is a shaper applied to
> all traffic passing through the target VF or a group of VFs. By its
> essence, a shaper naturally works with outbound traffic, and in
> practice, it's rarely seen to be implemented for inbound traffic.
> Nevertheless, there is a user request to have a mechanism for limiting
> inbound traffic as well. It is usually done by using some form of
> traffic policing, dropping excess packets over the configured limit that
> set by a user. Thus, introducing another limiting mechanism to the port
> function can help close this gap.
> 
> This series introduces devlink attrs, along with their ops, to manage
> rate policing of a single port as well as a port group. It is based on
> the existing notion of leaf and node rate objects, and extends their
> attributes to support both RX and TX limiting, for a number of packets
> per second and/or a number of bytes per second. Additionally, there is a
> second set of parameters for specifying the size of buffering performed,
> called "burst", that controls the allowed level of spikes in traffic
> before it starts getting dropped.
> 
> A new sub-type of a devlink_rate object is introduced, called
> "limit_type". It can be either "shaping", the default, or "police".
> A single leaf or a node object can be switched from one limit type to
> another, but it cannot do both types of rate limiting simultaneously.
> A node and a leaf object that have parent-child relationship must have
> the same limit type. In other words, it's only possible to group rate
> objects of the same limit type as their group's limit_type.

TC already has the police action. Your previous patches were accepted
because there was no exact match for shaping / admission. Now you're 
"extending" that API to duplicate existing TC APIs. Infuriating. 
