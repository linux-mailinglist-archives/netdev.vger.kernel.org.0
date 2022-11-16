Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2058962CB48
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 21:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiKPUnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 15:43:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbiKPUnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 15:43:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD41D5A;
        Wed, 16 Nov 2022 12:43:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D87BB81EB5;
        Wed, 16 Nov 2022 20:42:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B00CC433C1;
        Wed, 16 Nov 2022 20:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668631378;
        bh=2PSaNIlC/i6/awrIB1H4PHloF4KJB1K+tUqNH2kcX+A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yy5A5AFWR6yHlYe6iMP14PABCTzTHsnNYQMiYiDWM+vkG02/S9KzqdLnR75rI32B+
         CXtvj97rBDdQjs7Y4naiwFkPpJxSFFboIRdSBsewFFidvJN9U9GugT0eSgsX7qrw4e
         NcgSnwGdDxICrGMrEGs5dnEXmQI2wCLUKyQv+15rOgEEUHOuQXxTTUkAdmyAiLv/op
         B9lVofNeS2v/pBtaDxvlci766xO/x/zDo2f2umLCLHJCU2IQaC6pcBechR/T3sjt9w
         +o+wJEmHO/chrwZ54k6NH76eU9AYFrgJ5s3waAWVeWtxk0AFucIdAzWvWbZj7/3Yzr
         a0SlNku7Tte9w==
Date:   Wed, 16 Nov 2022 12:42:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        haoluo@google.com, jolsa@kernel.org,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 03/11] bpf: Support inlined/unrolled kfuncs for
 xdp metadata
Message-ID: <20221116124256.04a75fba@kernel.org>
In-Reply-To: <20221115030210.3159213-4-sdf@google.com>
References: <20221115030210.3159213-1-sdf@google.com>
        <20221115030210.3159213-4-sdf@google.com>
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

On Mon, 14 Nov 2022 19:02:02 -0800 Stanislav Fomichev wrote:
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 117e830cabb0..a2227f4f4a0b 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9258,6 +9258,13 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
>  			return -EOPNOTSUPP;
>  		}
>  
> +		if (new_prog &&
> +		    new_prog->aux->xdp_kfunc_ndo &&
> +		    new_prog->aux->xdp_kfunc_ndo != dev->netdev_ops) {
> +			NL_SET_ERR_MSG(extack, "Cannot attach to a different target device");
> +			return -EINVAL;
> +		}

This chunk can go up into the large

	if (new_prog) {
		...

list of checks?

nit: aux->xdp_kfunc_ndo sounds like you're storing the kfunc NDO,
     not all ndos. Throw in an 's' at the end, or some such?
