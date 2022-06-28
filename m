Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E335655EF09
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 22:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiF1UN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 16:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiF1UNn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 16:13:43 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D878E3CFF7;
        Tue, 28 Jun 2022 13:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rYwxNegCMlm2Id7OalQvY0kkmq2kUGQgEhzGLW81nyA=; b=Rd/meJi9pyM33xqBvPb52ogYx5
        +QEXnHqLcKyDM5oz/wgW4Hw6mogY2/IsBSVZtluBYRmRBpAJ8fvEkmF2MXEpbOMoUZKx/FX8V+nfP
        fryxy98+UAYkhPF4HRcdFm1Ufkgl73Ve9rbWUZuQNOPspQBTxvkjE3rhCYbOTrIv24OAWcQp+y/DZ
        /A+c5NBwpzGy2uumpa79qRdosUqohYVQWbsS5j5Lx8n+9Nd1rb+djSciXOQoEy1F6zGcHsVw/r06/
        LoLeWUF7W54o20f3W8iM0Zbh6TNm2P/HetjvvDRVws6O8yuBFl8IbL0jXxxYdh6MHvtOfMjAuVGPC
        Qkbrb7jQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1o6HTO-005jkE-Th;
        Tue, 28 Jun 2022 20:06:10 +0000
Date:   Tue, 28 Jun 2022 21:06:10 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
Subject: Re: [RFC net-next v3 05/29] net: bvec specific path in
 zerocopy_sg_from_iter
Message-ID: <YrtfMr+waxp37ru9@ZenIV>
References: <cover.1653992701.git.asml.silence@gmail.com>
 <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5143111391e771dc97237e2a5e6a74223ef8f15f.1653992701.git.asml.silence@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 28, 2022 at 07:56:27PM +0100, Pavel Begunkov wrote:
> Add an bvec specialised and optimised path in zerocopy_sg_from_iter.
> It'll be used later for {get,put}_page() optimisations.

If you need a variant that would not grab page references for ITER_BVEC
(and presumably other non-userland ones), the natural thing to do would
be to provide just such a primitive, wouldn't it?

The fun question here is by which paths ITER_BVEC can be passed to that
function and which all of them are currently guaranteed to hold the
underlying pages pinned...

And AFAICS you quietly assume that only ITER_BVEC ones will ever have that
"managed" flag of your set.  Or am I misreading the next patch in the
series?
