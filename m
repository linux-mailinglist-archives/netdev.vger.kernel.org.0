Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30EE46D8518
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 19:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233393AbjDERnO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 13:43:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjDERnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 13:43:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99907768E
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 10:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1761164023
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 17:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35138C433EF;
        Wed,  5 Apr 2023 17:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680716574;
        bh=wf/Ld499w9UMbwDzzcJyyKazKUTd3gZ2ojzKv4LMlAw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qhkF0DJ1U/d3ecci8ntkG/8s4CEJ5JpT+aWsRCX90aDygXzYpoh8RIe48PQCisRHI
         NlxHodTsk5WFCNlIHmAUh5LLKpnKIcV5NakZ+xQ8H8vOula2yU+Zf/wuw3HY/s9Hpa
         MCpMRTN8t9loCmc2hw6JMdl5PrCIJbl0qbFQDHyXQ6ydB8OeAHXbupGjEt3QJ4Cbpx
         PPdFfMn/iKYNgSMP9Z+37XJoGZLTsy+cth+GTYOMWX1AyBPj1UB/jhjns0vXhM5Ceg
         OM98LYbZjV6jX49psFwwl6B/78+v2N18ozb0/ubQXjMDAiYd4I3lF3vP/+7LVTFo0Q
         4QF5fQfWtfNGA==
Date:   Wed, 5 Apr 2023 10:42:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxim Georgiev <glipus@gmail.com>, kory.maincent@bootlin.com,
        netdev@vger.kernel.org, maxime.chevallier@bootlin.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com
Subject: Re: [RFC PATCH v3 3/5] Add ndo_hwtstamp_get/set support to vlan
 code path
Message-ID: <20230405104253.23a3f5de@kernel.org>
In-Reply-To: <20230405172840.onxjhr34l7jruofs@skbuf>
References: <20230405063323.36270-1-glipus@gmail.com>
        <20230405094210.32c013a7@kernel.org>
        <20230405170322.epknfkxdupctg6um@skbuf>
        <20230405101323.067a5542@kernel.org>
        <20230405172840.onxjhr34l7jruofs@skbuf>
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

On Wed, 5 Apr 2023 20:28:40 +0300 Vladimir Oltean wrote:
> So what do you suggest doing with bonding, then? Not use the generic
> helper at all?

It'd seem most natural to me to split the generic "descend" helper into
two functions, one which retrieves the lower and one which does the
appropriate calling dance (ndo vs ioctl, and DSA, which I guess is now
gone?). The latter could be used for the first descend as well I'd
presume. And it can be exported for the use of more complex drivers
like bonding which want to walk the lowers themselves.

> - it requires cfg.flags & HWTSTAMP_FLAG_BONDED_PHC_INDEX to be set in
>   SET requests
> 
> - it sets cfg.flags | HWTSTAMP_FLAG_BONDED_PHC_INDEX in GET responses

IIRC that was to indicate to user space that the real PHC may change
for this netdev so it needs to pay attention to netlink notifications.
Shouldn't apply to *vlans?

> Notably, something I would have expected it does but it doesn't do is it
> doesn't apply the same hwtstamping config to the lower interface that
> isn't active, when the switchover happens. Presumably user space does that.

Yes, user space must be involved anyway, because the entire clock will
change. IMHO implementing the pass thru for timestamping requests on
bonding is checkbox engineering, kernel can't make it work
transparently. But nobody else spoke up when it was proposed so...

> So it's not that much different.
