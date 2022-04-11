Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E62134FC6CD
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 23:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349602AbiDKVh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 17:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240775AbiDKVh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 17:37:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4978D32ECE
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 14:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00EEEB818C6
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 21:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BAF3C385A3;
        Mon, 11 Apr 2022 21:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649712909;
        bh=uzR0CfSeFc1uxi4hWTAJ9S7h44rksyP8EXFSTLFItig=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Z/gDK6zxT/FGrti/KC8BzNEPu8XW9C50vyFvwyxn+MDcWmEJkKS93H1kbajaHXBcH
         WqIdTJvtymyykeNd5+6PrTq3L+K1Qm3wvYQnZ1QTH7l7upjteH8xsRtThjtfRVoTFS
         o5xjjYh3okAj+U4qvrbVdDytxX+M3b8WmaYFIolHRScQd08abmS9gFuM6l4lwXaZ67
         sI9dOLEddxsbhAoUaGBsPLGk+wQKvgXFbiOCMmaoplWays0b1jjgPocXi7S+SczkYk
         YMg1wfeeNTith10QE1lxF7NoKCehORLiYB+tX2eteqEtbg746lluEskw6TiF3C5k4t
         4xjTj9HjbD1Fw==
Date:   Mon, 11 Apr 2022 14:35:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        idosch@idosch.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering
 support
Message-ID: <20220411143508.0592f60e@kernel.org>
In-Reply-To: <d47fe5e3-2820-196d-b375-2bf98cd784d3@blackwall.org>
References: <20220411172934.1813604-1-razor@blackwall.org>
        <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
        <c46ac324-34a2-ca0c-7c8c-35dc9c1aa0ab@blackwall.org>
        <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
        <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
        <20220411124910.772dc7a0@kernel.org>
        <3c25f674-d90b-7028-e591-e2248919cca9@blackwall.org>
        <20220411134857.3cf12d36@kernel.org>
        <d47fe5e3-2820-196d-b375-2bf98cd784d3@blackwall.org>
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

On Tue, 12 Apr 2022 00:17:14 +0300 Nikolay Aleksandrov wrote:
> > Yup, basically the policy is defined in the core, so the types are
> > known. We can extract the fields from the message there, even if 
> > the exact meaning of the fields gets established in the callback.
> 
> That sounds nice, but there are a few catches, f.e. some ndo_fdb implementations
> check if attributes were set, i.e. they can also interpret 0, so it will require
> additional state (either special value, bitfield or some other way of telling them
> it was actually present but 0).
> Anyway I think that is orthogonal to adding the flush support, it's a nice cleanup but can
> be done separately because it will have to be done for all ndo_fdb callbacks and I
> suspect the change will grow considerably.
> OTOH the flush implementation via delneigh doesn't require a new ndo_fdb call way,
> would you mind if I finish that up without the struct conversion?

Not terribly, go ahead.
