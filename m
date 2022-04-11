Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 476194FC7F3
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 01:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiDKXGT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 19:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiDKXGS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 19:06:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EE0E3E
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 16:04:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B71F0B81996
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 23:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432FAC385A3;
        Mon, 11 Apr 2022 23:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649718239;
        bh=1zZ/sCx59Z9T/RI6aLTGewKRcoeFMl0lBMQdD/tZeFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WRs0zPwz6o3hPE9brPkPgJKhOJ08AQEMaDISbOYmvqYQ2uCURJ9abCdB7WlBx1KMH
         f/AMgVJC6rudqomo0+H5Hq6btSOxez3Fo9AcUjPdVX0rkfHMXKq0jGv9TbeJjcKGiC
         EDWzPPk/TN60o3VgrRmqI1zJXBI1+EkOzWSpsY4LMoj3wQweCUXF68RAqjr/05YLSY
         137WI9V7r9oqOlZcz78qYr2RhuquDuw/CUaE5Dhm5IvMkKklWFa47DDrTREFsKO/PE
         pZxKm7uW/j/8FlY/1mhiYNVtQCeGKKPIobFZpo1qxI1CEYqdAuY+1wfiUQHKzSvHCr
         kh2wToR1JBm9g==
Date:   Mon, 11 Apr 2022 17:03:56 -0600
From:   David Ahern <dsahern@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org,
        idosch@idosch.org, kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next v2 0/8] net: bridge: add flush filtering support
Message-ID: <20220411230356.GB8838@u2004-local>
References: <20220411172934.1813604-1-razor@blackwall.org>
 <0d08b6ce-53bb-bffa-4f04-ede9bfc8ab63@nvidia.com>
 <c46ac324-34a2-ca0c-7c8c-35dc9c1aa0ab@blackwall.org>
 <92f578b7-347e-22c7-be83-cae4dce101f6@blackwall.org>
 <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ca093c4f-d99c-d885-16cb-240b0ce4d8d8@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 12:22:24PM -0700, Roopa Prabhu wrote:
> all great points. My only reason to explore RTM_DELNEIGH is to see if we can
> find a recipe to support similar bulk deletes of other objects handled via
> rtm msgs in the future. Plus, it allows you to maintain symmetry between
> flush requests and object delete notification msg types.
> 
> Lets see if there are other opinions.

I guess I should have read the entire thread. :-) (still getting used to
the new lei + mutt workflow). This was my thought - bulk delete is going
to be a common need, and it is really just a mass delete. The GET
message types are used for dumps and some allow attributes on the
request as a means of coarse grain filtering. I think we should try
something similar here for the flush case.
