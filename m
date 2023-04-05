Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D31F36D84A2
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDERN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDERN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:13:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77DF9B
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:13:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44B1562717
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707B5C433D2;
        Wed,  5 Apr 2023 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680714804;
        bh=kqPU+NxLwR9iPL0AA56pkCOM1TGIUWCfxlFMr2xjhDk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pZ9Ta/EMct70BtN4b9+bubPW9rQLwXv9Zb8b0RLHYH3S1X5qKZ6UpPq0J+54NBg58
         Uf7Tr2TdnybFA5N91GVuePtBCIGsz+qLsJ+QoNXkEw8cnz5ufw/iqO/tAIa5IJ42aH
         y9sXqEZsyEsxMKexQHM1/qGkYY0OjdslJhE6ihI3rOAagAHKIGzTmpasv1ku+cc0hL
         xkcmVAJXZ+OYIJgdDEpEqmh7HDqgHJwfQYpprqOM0Ie3ad0e0ihn8r6G1+GbsOSRSW
         CNdu+gev8QySZtZemAQfA23W8X7Umu26SR8y0QhKpHN9nAY9ofwNhg3/MFS7L0YrL7
         WeyF0T1FNnglA==
Date:   Wed, 5 Apr 2023 10:13:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan
 code path
Message-ID: <20230405101323.067a5542@kernel.org>
In-Reply-To: <20230405170322.epknfkxdupctg6um@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
        <20230405094210.32c013a7@kernel.org>
        <20230405170322.epknfkxdupctg6um@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 5 Apr 2023 20:03:22 +0300 Vladimir Oltean wrote:
> The goal would be for macvlan and bonding to use the same generic_hwtstamp_get_lower()?
> How would the generic helper get to bond_option_active_slave_get_rcu(),
> vlan_dev_priv(dev)->real_dev, macvlan_dev_real_dev(dev)?
> 
> Perhaps a generic_hwtstamp_get_lower() that takes the lower as argument,
> and 3 small wrappers in vlan, macvlan, bonding which identify that lower?

The bonding situation is probably more complex, I haven't looked,
but for *vlans we can just get the lower from netdev linkage, no?
Sure the drivers have their own pointers for convenience and with
their own lifetime rules but under rtnl lock lower/upper should work...
