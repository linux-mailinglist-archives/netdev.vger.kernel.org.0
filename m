Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20C565F4D3E
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 03:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiJEBAA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 21:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJEA75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 20:59:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFC6DFD1;
        Tue,  4 Oct 2022 17:59:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D59C4B81BC0;
        Wed,  5 Oct 2022 00:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14C9C433C1;
        Wed,  5 Oct 2022 00:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664931593;
        bh=weXEoa4zuD6c+WpyuzGGQenyv9+MCN+1y8tcJharYS8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iF2dUj+JWaJuxy8Zqp39w37CM6lFKa7jPhRpdq7JFq3MsmK9T0aSbDQdFalCpr5NQ
         4AJmNa7cHT3L9pOByg9k9YwHArxsHmz00ejPc5+LLDAyv+bX1hTP+3F8zpGuP5bLVC
         5bZfWoJmXwD1MiqTzgDqQPg5WnS7P+eYgdMTP24FO/t1ERssK+pk4UE+zGdnxHtWWO
         C4edyTXWIgbea1dKZeMQAW4EE3dNEwWo8MGt+4k1gmE5QGNSKWCLtTIFtLE0y+i4Nq
         IuuyoLXPZQYTIGNErO6bKMbrs28I+4ovz8b8GYOuDG9cs1UhCEc40IY6trIZXV33oA
         VoQoBJ3emj73g==
Date:   Tue, 4 Oct 2022 17:59:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin KaFai Lau <martin.lau@linux.dev>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>,
        brouer@redhat.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
        xdp-hints@xdp-project.net, larysa.zaremba@intel.com,
        memxor@gmail.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        mtahhan@redhat.com,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        dave@dtucker.co.uk, Magnus Karlsson <magnus.karlsson@intel.com>,
        bjorn@kernel.org
Subject: Re: [PATCH RFCv2 bpf-next 00/18] XDP-hints: XDP gaining access to
 HW offload hints via BTF
Message-ID: <20221004175952.6e4aade7@kernel.org>
In-Reply-To: <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
References: <166256538687.1434226.15760041133601409770.stgit@firesoul>
        <Yzt2YhbCBe8fYHWQ@google.com>
        <35fcfb25-583a-e923-6eee-e8bbcc19db17@redhat.com>
        <CAKH8qBuYVk7QwVOSYrhMNnaKFKGd7M9bopDyNp6-SnN6hSeTDQ@mail.gmail.com>
        <5ccff6fa-0d50-c436-b891-ab797fe7e3c4@linux.dev>
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

On Tue, 4 Oct 2022 17:25:51 -0700 Martin KaFai Lau wrote:
> A intentionally wild question, what does it take for the driver to return the 
> hints.  Is the rx_desc and rx_queue enough?  When the xdp prog is calling a 
> kfunc/bpf-helper, like 'hwtstamp = bpf_xdp_get_hwtstamp()', can the driver 
> replace it with some inline bpf code (like how the inline code is generated for 
> the map_lookup helper).  The xdp prog can then store the hwstamp in the meta 
> area in any layout it wants.

Since you mentioned it... FWIW that was always my preference rather than
the BTF magic :)  The jited image would have to be per-driver like we
do for BPF offload but that's easy to do from the technical
perspective (I doubt many deployments bind the same prog to multiple
HW devices)..
