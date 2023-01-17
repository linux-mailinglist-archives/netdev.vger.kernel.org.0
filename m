Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95A166E852
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 22:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjAQVWH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 16:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjAQVRu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 16:17:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3E94994C;
        Tue, 17 Jan 2023 11:40:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA50DB81331;
        Tue, 17 Jan 2023 19:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E837C433D2;
        Tue, 17 Jan 2023 19:40:01 +0000 (UTC)
Date:   Tue, 17 Jan 2023 14:40:00 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Israel Rukshin <israelr@nvidia.com>,
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
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 06/13] RDMA/core: Introduce MR type for crypto
 operations
Message-ID: <20230117144000.6efc56b2@gandalf.local.home>
In-Reply-To: <5b8fadc00c0fcc0c0ba3a5dcc9e7b9012c6b5859.1673873422.git.leon@kernel.org>
References: <cover.1673873422.git.leon@kernel.org>
        <5b8fadc00c0fcc0c0ba3a5dcc9e7b9012c6b5859.1673873422.git.leon@kernel.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Jan 2023 15:05:53 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> index 17642aa54437..b6a3d82b89ca 100644
> --- a/include/trace/events/rdma_core.h
> +++ b/include/trace/events/rdma_core.h
> @@ -371,6 +371,39 @@ TRACE_EVENT(mr_integ_alloc,
>  		__entry->max_num_meta_sg, __entry->rc)
>  );
>  
> +TRACE_EVENT(mr_crypto_alloc,
> +	TP_PROTO(
> +		const struct ib_pd *pd,
> +		u32 max_num_sg,
> +		const struct ib_mr *mr
> +	),
> +
> +	TP_ARGS(pd, max_num_sg, mr),
> +
> +	TP_STRUCT__entry(
> +		__field(u32, pd_id)
> +		__field(u32, mr_id)
> +		__field(u32, max_num_sg)
> +		__field(int, rc)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pd_id = pd->res.id;
> +		if (IS_ERR(mr)) {
> +			__entry->mr_id = 0;
> +			__entry->rc = PTR_ERR(mr);
> +		} else {
> +			__entry->mr_id = mr->res.id;
> +			__entry->rc = 0;
> +		}
> +		__entry->max_num_sg = max_num_sg;
> +	),
> +
> +	TP_printk("pd.id=%u mr.id=%u max_num_sg=%u rc=%d",
> +		__entry->pd_id, __entry->mr_id, __entry->max_num_sg,
> +		__entry->rc)
> +);
> +

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

>  TRACE_EVENT(mr_dereg,
>  	TP_PROTO(
>  		const struct ib_mr *mr

