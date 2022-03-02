Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A7E54C9B4A
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239122AbiCBCm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232563AbiCBCm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:42:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96CE537BD4;
        Tue,  1 Mar 2022 18:42:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 500D0B81ECD;
        Wed,  2 Mar 2022 02:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57770C340EE;
        Wed,  2 Mar 2022 02:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646188932;
        bh=HcTWjMbQWeF4eeEa/7jn5IJ2sJEKxX1/E8sp1fvu/Dw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hUqf+YrH9x/8jiL8TOFScEbkoMlgZnpUnUwRNueUnsA9sMLt4WPZVLQkV2kSnAbbD
         WZ6EnMnfo3p7QmqqQ0FX8vW+eGGRMMK5KiaLi46haG9BZA5Raxnxkr3X0Scg0pPcqA
         /APjs7oyjC+80LsxBaVDKrpLoL8OqSFqvwT8yAfaVOeMMNycovP0khiYqweocUL26U
         TSa4YSb4A1PtjA5rWDd+zqkJKy4CPPMbvU/9NqU7KO0OtO0TiAAZnUmWJTk4hZLbii
         WsLVBM7BF1muL84mq75K3bs3Xw9fvoYI/QqSt6q1KYIxnILomsb1v83bknE+70MVc3
         cfQifqB9L4ihA==
Date:   Tue, 1 Mar 2022 18:42:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, dsahern@gmail.com,
        edumazet@google.com
Subject: Re: [PATCH net-next v4 2/4] net: tap: track dropped skb via
 kfree_skb_reason()
Message-ID: <20220301184209.1f11b350@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220226084929.6417-3-dongli.zhang@oracle.com>
References: <20220226084929.6417-1-dongli.zhang@oracle.com>
        <20220226084929.6417-3-dongli.zhang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 26 Feb 2022 00:49:27 -0800 Dongli Zhang wrote:
> +	SKB_DROP_REASON_SKB_CSUM,	/* sk_buff checksum error */

Can we spell it out a little more? It sounds like the checksum was
incorrect. Will it be clear that computing the checksum failed, rather
than checksum validation failed?

> +	SKB_DROP_REASON_SKB_COPY_DATA,	/* failed to copy data from or to
> +					 * sk_buff
> +					 */

Here should we specify that it's copying from user space?

> +	SKB_DROP_REASON_SKB_GSO_SEG,	/* gso segmentation error */
> +	SKB_DROP_REASON_DEV_HDR,	/* there is something wrong with
> +					 * device driver specific header
> +					 */

How about:
device driver specific header / metadata was invalid

to broaden the scope also to devices which don't transfer the metadata
in form of a header?

> +	SKB_DROP_REASON_FULL_RING,	/* ring buffer is full */
