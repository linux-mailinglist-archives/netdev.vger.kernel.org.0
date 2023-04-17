Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A416E5066
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDQSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbjDQSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D68438F;
        Mon, 17 Apr 2023 11:50:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46BCA620BE;
        Mon, 17 Apr 2023 18:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9596C433EF;
        Mon, 17 Apr 2023 18:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681757405;
        bh=/SYyLnfM82MmE33YFZCDJXYlbvQSEgvgV14fp98uexE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oXrHVDg2ba3fKunDg88Fyb82QGklmMqoMwObeUyGwXoO78uAk+srLuf2KLzqZ6ZJm
         JBPV/Y2NYMQTNLEZcQc6bJHDCSqLDfKfrtyxk2ihTQLkvg4hFTOpU4gbJAIDh1UJxE
         IiRli5a/Q/hCmFRpE8ERVr45SZEPX5gmLI7XQDGNig7c7f2dkmJz62cEijFOiA01qy
         kPEvx7f6D6kNXjovR8vmKYvaMRojpp5rxn0848rZPzQHzVin+4N+lcWm3tl7PnIsAf
         HKLjvktaoQsne9EW3vECUV/W7qfPfBGEHfm8zXyMiOkvdpbV7z3QW2ScC8b7tCjM7G
         CNMJUt50vFSKw==
Date:   Mon, 17 Apr 2023 11:50:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Bezdeka, Florian" <florian.bezdeka@siemens.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        "Joseph, Jithu" <jithu.joseph@intel.com>,
        Andre Guedes <andre.guedes@intel.com>,
        "Brouer, Jesper" <brouer@redhat.com>,
        "Stanislav Fomichev" <sdf@google.com>,
        "Keller, Jacob E" <jacob.e.keller@intel.com>,
        David Laight <David.Laight@ACULAB.COM>,
        "xdp-hints@xdp-project.net" <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net v3 1/1] igc: read before write to SRRCTL register
Message-ID: <20230417115003.0d2ac372@kernel.org>
In-Reply-To: <SJ1PR11MB618095F79E53B077E922F900B89C9@SJ1PR11MB6180.namprd11.prod.outlook.com>
References: <20230414154902.2950535-1-yoong.siang.song@intel.com>
        <ffa2551d-ca04-3fe9-944a-0383e1d079e3@siemens.com>
        <PH0PR11MB58306BDB63286338EABAF61AD89F9@PH0PR11MB5830.namprd11.prod.outlook.com>
        <SJ1PR11MB618095F79E53B077E922F900B89C9@SJ1PR11MB6180.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Apr 2023 02:53:13 +0000 Zulkifli, Muhammad Husaini wrote:
> Are you observing similar issue like below?
> ptp4l: timed out while polling for tx timestamp
> ptp4l: increasing tx_timestamp_timeout may correct this issue
> 
> If yes, only TXSTAMPO register is used for both PTP and non-PTP packets in 
> the current driver code. There is a possibility that the time stamp 
> for a PTP packet will be lost when there is a lot of traffic when multiple 
> applications request for hardware transmission timestamps. 
> Few months back, I submitted a patch series to enable the DMA 
> Timestamp for non-ptp packet which can resolve the above issue.
> https://lore.kernel.org/netdev/20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com/T/
> Will continuing back the activity soon.

FWIW the work on selecting the source of the timestamp is progressing
slowly:

https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@bootlin.com/
