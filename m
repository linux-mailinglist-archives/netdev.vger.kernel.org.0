Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3044EB7C4
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 03:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241617AbiC3B1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 21:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241608AbiC3B1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 21:27:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C6236F4B9
        for <netdev@vger.kernel.org>; Tue, 29 Mar 2022 18:25:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BE0E611FA
        for <netdev@vger.kernel.org>; Wed, 30 Mar 2022 01:25:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B893C2BBE4;
        Wed, 30 Mar 2022 01:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648603531;
        bh=cXvdY/SYO/ZmYwoAH5Flo1faP6z9dnemA8nh/aB+GGA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qvKY/3+dyI5y7WkuE2L5Cdk2ish5uDZl9XRLFp0TjkKStwZF/Xm9LisUNaWiedZEr
         LMkTShBCkSRzyMYrbdL9AjR2tk3IIxBIfj1mDkrNBkaCwfjdbFgjEKAZ+U8Cg/oE9L
         dUR+sns5aY3tnAGvhGqYaniAgvjLXCDou8K67D+1v4+p2fc6cQlpx+2fDPksgFnvG8
         dCiKtmO19Z4g7jeK8iotBY5lIXon/251iJxjuTKQRNGwgGY/N7Jdtfm50GzXGb3ZIQ
         aprdf8PgBB20Bt0eDkeQqI6SsZ0gtm99NsxbD1b2klfNvS7WKCmqGeyjNyfzOS59Nw
         cQ/SQZFxV2AxA==
Date:   Tue, 29 Mar 2022 18:25:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Faltesek <mfaltesek@chromium.org>
Cc:     netdev@vger.kernel.org, krzk@kernel.org,
        christophe.ricard@gmail.com, jordy@pwning.systems,
        sameo@linux.intel.com, wklin@google.com, groeck@google.com,
        surenb@google.com, mfaltesek@google.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH] nfc: st21nfca: Refactor EVT_TRANSACTION
Message-ID: <20220329182529.0e482ade@kernel.org>
In-Reply-To: <20220329175431.3175472-1-mfaltesek@google.com>
References: <20220329175431.3175472-1-mfaltesek@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Mar 2022 12:54:31 -0500 Martin Faltesek wrote:
> EVT_TRANSACTION has four different bugs:
> 
> 1. First conditional has logical AND but should be OR. It should
>    always check if it isn't NFC_EVT_TRANSACTION_AID_TAG, then
>    bail.
> 
> 2. Potential under allocating memory:devm_kzalloc (skb->len - 2)
>    when the aid_len specified in the packet is less than the fixed
>    NFC_MAX_AID_LENGTH in struct nfc_evt_transaction. In addition,
>    aid_len is u32 in the data structure, and u8 in the packet,
>    under counting 3 more bytes.
> 
> 3. Memory leaks after kzalloc when returning error.
> 
> 4. The final conditional check is also incorrect, for the same reasons
>    explained in #2.

Any time you're tempted to write a list in your commit message the
chances are you should split the change into multiple patches.
