Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0076BA669
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 05:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCOE7t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 00:59:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjCOE7s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 00:59:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7FA35CED9;
        Tue, 14 Mar 2023 21:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64C5761AE3;
        Wed, 15 Mar 2023 04:59:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A94C433EF;
        Wed, 15 Mar 2023 04:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678856386;
        bh=2pS798YwA1H4VHVlUQN3c1Y8J8BQyYm7+6uuboqzQ4I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X67iAZsTrJGlqZJtWVMGiMM9lo7Nd+JJpqZIHrykIMOgMzLjpo/OW6R2H7K0x0Guj
         1TpNhovaRR9rJpCLKDFPL4k7qeXdQbMjrJSA+aBvxngZbv7EagqxLiYvRQag7K3F+V
         faD115TO/+NrpVDM2PumBEsqxaygrscFpQhCL4g6jp2EADIUx+eFHuPQUSnuu2qeSL
         KEqC16PmclELIiNI5f2HWPbPM950nZbpJDfvC0neyR+6hrLIMUmRZ6gTK13//k/Jh8
         wa2amS/lhL4pQnY7yX21Rwm6SevcSxEJSwUvEk3nX9YpJxzNfzKZnAoege/EUlId6c
         O8dumw7AH+kKw==
Date:   Tue, 14 Mar 2023 21:59:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v1 2/5] connector/cn_proc: Add filtering to fix some
 bugs
Message-ID: <20230314215945.3336aeb3@kernel.org>
In-Reply-To: <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230310221547.3656194-1-anjali.k.kulkarni@oracle.com>
        <20230310221547.3656194-3-anjali.k.kulkarni@oracle.com>
        <20230313172441.480c9ec7@kernel.org>
        <BY5PR10MB41295AF42563F023651E109FC4BE9@BY5PR10MB4129.namprd10.prod.outlook.com>
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

On Tue, 14 Mar 2023 02:32:13 +0000 Anjali Kulkarni wrote:
> This is clearly a layering violation, right?
> Please don't add "if (family_x)" to the core netlink code.
>
> ANJALI> Yes, it is, but there does not seem a very clean way to do it
> ANJALI> otherwise and I saw a check for protocol NETLINK_GENERIC just
> ANJALI> below it, so used it for connector as well. There is no
> ANJALI> release or free callback in the netlink_sock. Is it ok to add
> ANJALI> it? There was another bug (for which I have not yet sent a
> ANJALI> patch) in which, we need to decrement
> ANJALI> proc_event_num_listeners, when client exits without calling
> ANJALI> IGNORE, else that count again gets out of status of actual no
> ANJALI> of listeners.   
> The other option is to add a flag in netlink_sock, something like
> NETLINK_F_SK_USER_DATA_FREE, which will free the sk_user_data, if
> this flag is set. But it does not solve the above scenario.

Please fix your email setup, it's really hard to read your replies.

There is an unbind callback, and a notifier. Can neither of those 
be made to work? ->sk_user_data is not a great choice of a field,
either, does any other netlink family use it this way?
Adding a new field for family use to struct netlink_sock may be better.
