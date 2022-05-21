Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A346152F747
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 03:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243528AbiEUBLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 21:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234338AbiEUBLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 21:11:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A556FAC;
        Fri, 20 May 2022 18:11:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7161B82ED9;
        Sat, 21 May 2022 01:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D58C385A9;
        Sat, 21 May 2022 01:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653095479;
        bh=JfJ5nzgjUspGgrQmnLENeCnxb/d5toBDvpU/7IxIUqs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nZkX+mTKy53efkPmCFScn92diCgCKwnvNSqcLCafmKyfMQg1iNJ4+0bGFGEcHpb33
         OK/VzUBTmBaYSEOK1JA9FvTM+jLzHJhvJT0TlP6V9td3LJWy4P2TaLsNHlqXFsk8e6
         xGfYJ7rYHFbKjRaKqsxIOALcJ0t4WyJZAzmdv6fVsc2wKQulOxxqEtUGSiOiE25uJ5
         mNgU1GPAg/DrzFwjfeefSJi5ZLNsdme3nc5gvPS7GSAHDiBw3t/tsBQriMZYAXW4xN
         yqjnROWJEbIZcbQk63fYOEWcA7mG+NKBZfObgktG4yY71vYZizN8IjUUzCd5BxtBmc
         +Npj/NKpe5p7g==
Date:   Fri, 20 May 2022 18:11:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] rxrpc: Fix locking issue
Message-ID: <20220520181118.47ca2bdc@kernel.org>
In-Reply-To: <165306517397.34989.14593967592142268589.stgit@warthog.procyon.org.uk>
References: <165306515409.34989.4713077338482294594.stgit@warthog.procyon.org.uk>
        <165306517397.34989.14593967592142268589.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 May 2022 17:46:13 +0100 David Howells wrote:
> +struct list_head *seq_list_start_rcu(struct list_head *head, loff_t pos)
> +{
> +	struct list_head *lh;
> +
> +	list_for_each_rcu(lh, head)
> +		if (pos-- == 0)
> +			return lh;
> +
> +	return NULL;
> +}
> +EXPORT_SYMBOL(seq_list_start_rcu);
> +
> +struct list_head *seq_list_start_head_rcu(struct list_head *head, loff_t pos)
> +{
> +	if (!pos)
> +		return head;
> +
> +	return seq_list_start_rcu(head, pos - 1);
> +}
> +EXPORT_SYMBOL(seq_list_start_head_rcu);
> +
> +struct list_head *seq_list_next_rcu(void *v, struct list_head *head,
> +				    loff_t *ppos)
> +{
> +	struct list_head *lh;
> +
> +	lh = rcu_dereference(((struct list_head *)v)->next);

Can we use list_next_rcu() here maybe ? to avoid the sparse warning?

> +	++*ppos;
> +	return lh == head ? NULL : lh;
> +}
> +EXPORT_SYMBOL(seq_list_next_rcu);
