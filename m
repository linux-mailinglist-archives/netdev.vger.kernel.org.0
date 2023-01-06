Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E14C36609B4
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:56:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjAFW4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229547AbjAFWz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:55:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEC320F
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 14:55:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A5E7B81DD6
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 22:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244AC433F1;
        Fri,  6 Jan 2023 22:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673045755;
        bh=Co+hdlFzg6kMwfEil7GilArE6EOHx3LtdALLvnxOQes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H0PuSzVSfd4avzxghHUVARCgA7AIDC2xcdxIHD75rosRo+7P4zWiZlyhJ1+Bya/uk
         NQ/UTJgCDZXj2oVyl3tsOZKPR3ijmoPe8MtnBRFmoWTFBv+OJ3F+aomEo01DesY1pv
         k7wQKDN/Id5qeea1IcL3qPloL73BnC+i43r3BjWnjxjBRKN6JHRoK2hpciFpOT7cn2
         SW6txFIrXs0RxhxDDLSic18meDe+U91GCjqCKxP+GAfFoWVvxAYxpe94HQQ1Ismx7P
         SaMO2RzcjfbN5SWh4WnuSjWyrSLb9ZJ/cDsZ6L/DGBEczNbOlj0yZlI2L3Ang+RA5l
         WfXq4gpwhuhIA==
Date:   Fri, 6 Jan 2023 14:55:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kyle Zeng <zengyhkyle@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: net: ipv6: raw: fixes null pointer deference in
 rawv6_push_pending_frames
Message-ID: <20230106145553.6dd014f1@kernel.org>
In-Reply-To: <Y7iQeGb2xzkf0iR7@westworld>
References: <Y7iQeGb2xzkf0iR7@westworld>
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

On Fri, 6 Jan 2023 14:19:52 -0700 Kyle Zeng wrote:
> It is posible that the skb_queue_walkloop does not assign csum_skb to a real skb.

Not immediately obvious to me how that could happen given prior checks
in this function.
