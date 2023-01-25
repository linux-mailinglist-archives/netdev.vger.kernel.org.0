Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39D8F67A7F7
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 01:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233577AbjAYAsj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 19:48:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbjAYAsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 19:48:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AE7C470AA
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 16:48:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3BD1FB8171A
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 00:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5034BC433EF;
        Wed, 25 Jan 2023 00:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674607713;
        bh=mLFEBZaGmezPHDQnhCXeMObIXHIn8N7g45Ezgy/q1YU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uzLUVUoW1zacvjiq97JGlvkkTkO2L4bDlO5a/PXc7s+DfjJJVAStrZp7uqha1X+ud
         XMvbzx5JnBL1zJQ5w/fewbt3I1TzwWQ18ma6hxkZFgaEW0EX12lU6wfi1RUKxcT7Ms
         EYq/RfG2WB2tXgyz/QJ5CVTzPbDndmzmLFaUFofTlQRIndFX9pYpKmi3efyx5hjBJf
         JKnrm3H2Rp+5DsBf/OAMfbv3qlELOPZD1GPIfKW/yIZXQ416PfWINUg5KjcpGKH6w+
         qQcVvK+qP7MGjtm0EdR+4XkQr+qw++Zk4+fT0/P5Az6F1Isx111D7TkvtaJQdzdPPz
         sa2EOFMMBnWbg==
Date:   Tue, 24 Jan 2023 16:48:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Bar Shapira <bar.shapira.work@gmail.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Message-ID: <20230124164832.71674574@kernel.org>
In-Reply-To: <Y9AuU4zSQ0++RV7z@hoboy.vegasvil.org>
References: <87r0vpcch0.fsf@nvidia.com>
        <3312dd93-398d-f891-1170-5d471b3d7482@intel.com>
        <20230120160609.19160723@kernel.org>
        <87ilgyw9ya.fsf@nvidia.com>
        <Y83vgvTBnCYCzp49@hoboy.vegasvil.org>
        <878rhuj78u.fsf@nvidia.com>
        <Y8336MEkd6R/XU7x@hoboy.vegasvil.org>
        <87y1pt6qgc.fsf@nvidia.com>
        <Y88L6EPtgvW4tSA+@hoboy.vegasvil.org>
        <8fceff1b-180d-b089-8259-cd4caf46e7d2@gmail.com>
        <Y9AuU4zSQ0++RV7z@hoboy.vegasvil.org>
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

On Tue, 24 Jan 2023 11:15:31 -0800 Richard Cochran wrote:
> On Tue, Jan 24, 2023 at 12:33:05PM +0200, Bar Shapira wrote:
> > I guess this expectation should be part of the documentation too, right? Are
> > there more expectations when calling adjphase?  
> 
> I'll gladly ack improvements to the documentation. I myself won't
> spend time on that, because it will only get ignored, even when it is
> super clear.  Like ptp_clock_register(), for example.

IMHO it is a responsibility of maintainers to try to teach, even if not
everyone turns out to be a diligent listener/reader. I've looked for
information about this callback at least twice in the last 6 months.

nVidia folks, could you please improve the doc, in that case? 
I think you also owe me the docs for your "debug" configuration 
of hairpin queues in debugfs.
