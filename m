Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9A556F8C
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 02:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376402AbiFWAib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 20:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376443AbiFWAi0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 20:38:26 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4F65A2ED61;
        Wed, 22 Jun 2022 17:38:25 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 067F610E7966;
        Thu, 23 Jun 2022 10:38:23 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o4ArW-009u4M-PC; Thu, 23 Jun 2022 10:38:22 +1000
Date:   Thu, 23 Jun 2022 10:38:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org, tgraf@suug.ch,
        jlayton@redhat.com
Subject: Re: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Message-ID: <20220623003822.GF1098723@dread.disaster.area>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62b3b600
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=7-415B0cAAAA:8 a=48opyrbEDHdIh8SDB-IA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:15:56AM -0400, Chuck Lever wrote:
> Enable the filecache hash table to start small, then grow with the
> workload. Smaller server deployments benefit because there should
> be lower memory utilization. Larger server deployments should see
> improved scaling with the number of open files.
> 
> I know this is a big and messy patch, but there's no good way to
> rip out and replace a data structure like this.
> 
> Suggested-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Pretty sure I mentioned converting to rhashtable as well when we
were talking about the pointer-chasing overhead of list and tree
based indexing of large caches.  :)

> +
> +/*
> + * Atomically insert a new nfsd_file item into nfsd_file_rhash_tbl.
> + *
> + * Return values:
> + *   %NULL: @new was inserted successfully
> + *   %A valid pointer: @new was not inserted, a matching item is returned
> + *   %ERR_PTR: an unexpected error occurred during insertion
> + */
> +static struct nfsd_file *nfsd_file_insert(struct nfsd_file *new)
> +{
> +	struct nfsd_file_lookup_key key = {
> +		.type	= NFSD_FILE_KEY_FULL,
> +		.inode	= new->nf_inode,
> +		.need	= new->nf_flags,
> +		.net	= new->nf_net,
> +		.cred	= current_cred(),
> +	};
> +	struct nfsd_file *nf;
> +
> +	nf = rhashtable_lookup_get_insert_key(&nfsd_file_rhash_tbl,
> +					      &key, &new->nf_rhash,
> +					      nfsd_file_rhash_params);
> +	if (!nf)
> +		return nf;

The insert can return an error (e.g. -ENOMEM) so need to check
IS_ERR(nf) here as well.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
