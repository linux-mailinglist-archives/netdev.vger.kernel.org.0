Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB9B55C99F
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238002AbiF0Sq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 14:46:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236776AbiF0Sq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 14:46:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456B3D53;
        Mon, 27 Jun 2022 11:46:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC82D615CA;
        Mon, 27 Jun 2022 18:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C350C3411D;
        Mon, 27 Jun 2022 18:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656355614;
        bh=EMtnD6IhXdZsJ6k5EKvw8L4xI5spiH3wNrPgTWqvPBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G8yaykvxux3jX6J47i1jLyS3R1wup4fawFmLJfYT6b20QaiQhrHb0hvK7eo61ZxUk
         LEj18MXR2WnP5fNXLRayJWMfX9St91oiIKEgIQpKhQl/AhjJ5PZMU7meItW8i+KqMf
         OltbtOyvKwVROCzZxgmHfmIXS5sPvzO9fDof/2Ge5OPr/LXdrB09Z03iiuGPBeehIZ
         k5+OPcmq2+jrvSJq++yFpZFM7f6x/vkfgUaJnJqLFB2kd4wqusyRJUZPTnl8+0aaOc
         q1BLXk6vw5hhQqKKjFPAux3tth8Tgf0FCdIZzTJzCYfluCDQfmLxyY2+9J1ai3Ri5y
         6KcrUG3fQTsCg==
Date:   Mon, 27 Jun 2022 11:46:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Colin Foster <colin.foster@in-advantage.com>,
        Richie Pearn <richard.pearn@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/4] net: dsa: felix: drop oversized frames
 with tc-taprio instead of hanging the port
Message-ID: <20220627114644.6c2c163b@kernel.org>
In-Reply-To: <20220626120505.2369600-5-vladimir.oltean@nxp.com>
References: <20220626120505.2369600-1-vladimir.oltean@nxp.com>
        <20220626120505.2369600-5-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Jun 2022 15:05:05 +0300 Vladimir Oltean wrote:
> When a frame is dropped due to a queue system oversize condition, the
> counter that increments is the generic "drop_tail" in ethtool -S, even
> if this isn't a tail drop as the rest (i.e. the controlling watermarks
> don't count these frames, as can be seen in "devlink sb occupancy show
> pci/0000:00:00.5 sb 0"). So the hardware counter is unspecific
> regarding the drop reason.

I had mixed feelings about the stats, as I usually do, but I don't
recall if I sent that email. Are you at least counting the drop_tail
into one of the standard tx error / drop stats so admins will notice?
