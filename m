Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DBC558BA1
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 01:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230339AbiFWXQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 19:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbiFWXQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 19:16:11 -0400
X-Greylist: delayed 1158 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Jun 2022 16:16:09 PDT
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D4D9609D7;
        Thu, 23 Jun 2022 16:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jAmxycjq9xNzu1qXe+8nYLfvbtKoFnsayWMYTgRJyIE=; b=er1GTyttDatX/emTmxgI3+Jwyl
        I65TXxkXoS6Ch0n9TaPmLx9z3it0VaYDx0UeIBX5tGGeJiDW6Fe4bKrr/PtOfRnFBr5lkPM5QP8Qp
        cP/RKdwaq3iiL2HAxypFjv8GFdaa11jPaSEKHPVxVK0z+trE1bCcW7Gk5yWQbaoOi7NcldPhQg8QK
        nhuPx/fUnw3dNG1oSrsZ7UkNzJ/FN+2PVfymfPDif9w4G0M7XE6Cb8TEmNG+xb5o5nn4i8yVCcyRW
        6KsWP6bH+GF7ISRbIMwqMBbicr3pHxTmY0PTXm0PmH+K/kAM1AG5FWV1lJ4q8PZwYX7UEuBxTSlgS
        /j3+p5Ig==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1o4Vkh-003hCY-Ax;
        Thu, 23 Jun 2022 22:56:43 +0000
Date:   Thu, 23 Jun 2022 23:56:43 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        david@fromorbit.com, tgraf@suug.ch, jlayton@redhat.com
Subject: Re: [PATCH RFC 28/30] NFSD: Set up an rhashtable for the filecache
Message-ID: <YrTvq2ED+Xugqpyi@ZenIV>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165590735022.75778.7652622979487182880.stgit@manet.1015granger.net>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 22, 2022 at 10:15:50AM -0400, Chuck Lever wrote:

> +static u32 nfsd_file_obj_hashfn(const void *data, u32 len, u32 seed)
> +{
> +	const struct nfsd_file *nf = data;
> +
> +	return jhash2((const u32 *)&nf->nf_inode,
> +		      sizeof_field(struct nfsd_file, nf_inode) / sizeof(u32),
> +		      seed);

Out of curiosity - what are you using to allocate those?  Because if
it's a slab, then middle bits of address (i.e. lower bits of
(unsigned long)data / L1_CACHE_BYTES) would better be random enough...
