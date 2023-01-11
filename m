Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EAA1665041
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 01:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235189AbjAKAMo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 19:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234554AbjAKAMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 19:12:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B2B1B9D0
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 16:12:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8ED561987
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 00:12:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E06C433EF;
        Wed, 11 Jan 2023 00:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673395959;
        bh=SZTDjo7+wFgET+qskTnfSu1H4Hnw0wCxKpdPryIAbkk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gXX2sHvG7Y75VrQo50JXEPQXjY3R4jZKfWGy3TOzhOh3AC44ubiX/kaPUXbnCVpRS
         jrNyX3XbAijC/bEviCgl/fZrEnGFdFYCo9IW9fI4Q1/xXQM5ZbFm76Tx1exmtSe8nB
         pe3x7pCKQSpauP5/w0TFAn2EAiCs7dpqbxMGKnuM4XjjEY2Q+MXHlnZPKcioDLsHx9
         pbnUVjVhTTSDD53awooz8n2TticiGNB6XJQdoHB34DCvgD+GUUebNqDztI6pPOhmmi
         aT89afT/fT8Cz4R/+TqzJjNpdbfT8LtD8upgTNCypAD+UlA+xc7Xjl+FCGA5yD7OgA
         riMNyUSZJiMRw==
Date:   Tue, 10 Jan 2023 16:12:37 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
Message-ID: <20230110161237.2a40ccc8@kernel.org>
In-Reply-To: <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
        <20230109191523.12070-11-gerhard@engleder-embedded.com>
        <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
        <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
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

On Tue, 10 Jan 2023 22:38:04 +0100 Gerhard Engleder wrote:
> > As I called out earlier the __TSNEP_DOWN is just !IFF_UP so you don't
> > need that bit.
> > 
> > The fact that netif_carrier_off is here also points out the fact that
> > the code in the Tx path isn't needed regarding __TSNEP_DOWN and you can
> > probably just check netif_carrier_ok if you need the check.  
> 
> tsnep_netdev_close() is called directly during bpf prog setup (see
> tsnep_xdp_setup_prog() in this commit). If the following
> tsnep_netdev_open() call fails, then this flag signals that the device
> is already down and nothing needs to be cleaned up if
> tsnep_netdev_close() is called later (because IFF_UP is still set).

TBH we've been pushing pretty hard for a while now to stop people
from implementing the:

	close()
	change config
	open()

sort of reconfiguration. I did that myself when I was a was
implementing my first Ethernet driver and DaveM nacked the change.
Must have been a decade ago.

Imagine you're working on a remote box via SSH and the box is under
transient memory pressure. Allocations fail, we don't want the machine
to fall off the network :(
