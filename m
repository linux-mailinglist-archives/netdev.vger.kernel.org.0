Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F601671222
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 04:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229604AbjARDvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 22:51:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjARDvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 22:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3915E539A7
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 19:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3BD7B81B05
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 03:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12548C433EF;
        Wed, 18 Jan 2023 03:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674013870;
        bh=pfgXM8I1ScoEeFiQjcDX2YcO+9fQ9tngQ0O7YQIKdl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZO3alKJCCqyBi34TD4TP05B6qoB8awlhk5GoB5M/eFxmvodM4wqnA+tOzUvB9NcwS
         gruxEHIwEQIuo8Ov9CvOrRyY12Pey22E8f/sMkdpfhkkTMqoKHJx6WBRmZVZYNgVLI
         ty5Cqj4i4wdiVK+jvjCRduE225eWcNA9jlIkZAsNC+LYTh1XOT0LlDpJAzwlwuLbzm
         BxHuWvSJUtJVhDTawrVvd4EEHHDceANRxEyVNFJ1Qbs+6N01SuryjlxS2/dUG1YfJm
         N/rahMkkNyd6DtTkV7Uj8GIRpc3fwUpu/tfbp9uyVk2IMZ+QdxXZjQ49dek5VY5N0u
         AWqstmD5LVLsQ==
Date:   Tue, 17 Jan 2023 19:51:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: Re: [PATCH net-next v2 2/6] net/sched: flower: Move filter handle
 initialization earlier
Message-ID: <20230117195109.0b4a4135@kernel.org>
In-Reply-To: <20230117083344.4056-3-paulb@nvidia.com>
References: <20230117083344.4056-1-paulb@nvidia.com>
        <20230117083344.4056-3-paulb@nvidia.com>
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

On Tue, 17 Jan 2023 10:33:40 +0200 Paul Blakey wrote:
> +	if (!fold) {
> +		spin_lock(&tp->lock);
> +		if (!handle) {
> +			handle = 1;
> +			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
> +					    INT_MAX, GFP_ATOMIC);
> +			if (err)
> +				goto errout;

sparse says you should release the spin lock

> +		} else {
> +			err = idr_alloc_u32(&head->handle_idr, fnew, &handle,
> +					    handle, GFP_ATOMIC);
> +
> +			/* Filter with specified handle was concurrently
> +			 * inserted after initial check in cls_api. This is not
> +			 * necessarily an error if NLM_F_EXCL is not set in
> +			 * message flags. Returning EAGAIN will cause cls_api to
> +			 * try to update concurrently inserted rule.
> +			 */
> +			if (err == -ENOSPC)
> +				err = -EAGAIN;
> +		}
> +		spin_unlock(&tp->lock);
> +
> +		if (err)
> +			goto errout;
> +	}
> +	fnew->handle = handle;
> +
> +	err = tcf_exts_init(&fnew->exts, net, TCA_FLOWER_ACT, 0);
> +	if (err < 0)
> +		goto errout_idr;
