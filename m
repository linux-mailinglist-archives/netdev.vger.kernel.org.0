Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737E9680DD0
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 13:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbjA3MgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 07:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235273AbjA3MgQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 07:36:16 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C636135;
        Mon, 30 Jan 2023 04:36:14 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0544868D0A; Mon, 30 Jan 2023 13:36:11 +0100 (CET)
Date:   Mon, 30 Jan 2023 13:36:10 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Israel Rukshin <israelr@nvidia.com>
Cc:     Sagi Grimberg <sagi@grimberg.me>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Message-ID: <20230130123610.GB19948@lst.de>
References: <cover.1673873422.git.leon@kernel.org> <6f9da88c-f01e-156b-eb19-0b275c46c6b5@grimberg.me> <e37fe712-4e0e-229a-a07e-52a0d486819c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e37fe712-4e0e-229a-a07e-52a0d486819c@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 02:57:18PM +0200, Israel Rukshin wrote:
>> - what happens with multipathing? when if not all devices are
>> capable. SW fallback?
> SW fallback happens every time the device doesn't support the specific 
> crypto request (which include data-unit-size, mode and dun_bytes).
> So with multipathing, one path uses the HW crypto offload and the other one 
> uses the SW fallback.

That's a big no-go.  The blk-crypto-fallback code is just a toy example
and not actually safe to use in prodution.  Most importantly it just
kmallocs a bio clone and pages for it without any mempool that guarantees
forward progress.
