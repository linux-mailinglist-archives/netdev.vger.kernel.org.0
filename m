Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 110EC4D407B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233028AbiCJE7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbiCJE7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:59:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B79F9338A3
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 56293CE2232
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0DA3C340E8;
        Thu, 10 Mar 2022 04:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646888285;
        bh=jgIS+EljXJRscxO29vFRzpXOofm5H8l02hSTT3+y434=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=LD77G36HMTwNiVGafavRvElX5Pi39Rl3dwjubpfCJ5OzenCHMoMm9FUqUWC4be213
         57lk+4gnh/CKA1GM8HJ4//xpY77uBZv030iab1nLxF0xcsAyn7g/Pv/cLRBUmZ0AE4
         HYoBRAd0lOmUlotdd9vCvQXy3w/bfSPnd8CW3E2m6/L8WhCXQi9RTlKM5gENoVk+qZ
         p9q31lq2P60QoJQBLy6ySUhk8QE+4o1JwA6fO72HevcLvNpLcJjHDBvnZSqoZS8poH
         ARBC9VR37ADTvm9rf7xLXoLdSGfurPd1yfKGJQBWd2bX0ME7CC1z7BE1ArRxR/6HcP
         AHN+JD2UQSQFQ==
Message-ID: <b16dde16-aa31-10c6-7f54-1e37904aee5d@kernel.org>
Date:   Wed, 9 Mar 2022 21:58:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH v5 2/4] vdpa: Allow for printing negotiated features of a
 device
Content-Language: en-US
To:     Eli Cohen <elic@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com
Cc:     mst@redhat.com, lulu@redhat.com, parav@nvidia.com
References: <20220309164609.7233-1-elic@nvidia.com>
 <20220309164609.7233-3-elic@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220309164609.7233-3-elic@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/9/22 9:46 AM, Eli Cohen wrote:
> +static void print_features(struct vdpa *vdpa, uint64_t features, bool mgmtdevf,
> +			   uint16_t dev_id)
> +{
> +	const char * const *feature_strs = NULL;
> +	const char *s;
> +	int i;
> +
> +	if (dev_id < ARRAY_SIZE(dev_to_feature_str))
> +		feature_strs = dev_to_feature_str[dev_id];
> +
> +	if (mgmtdevf)
> +		pr_out_array_start(vdpa, "dev_features");
> +	else
> +		pr_out_array_start(vdpa, "negotiated_features");
> +
> +	for (i = 0; i < 64; i++) {

make that 64 a macro so the magic number has a description. e.g.,

#define BITS_PER_U64 (sizeof(u64) * 8)




