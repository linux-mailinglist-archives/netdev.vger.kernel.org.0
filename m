Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3667574109
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 03:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiGNBvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 21:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiGNBvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 21:51:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC28D22B0D;
        Wed, 13 Jul 2022 18:51:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72A2BB82271;
        Thu, 14 Jul 2022 01:51:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590A8C34114;
        Thu, 14 Jul 2022 01:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657763497;
        bh=0qMj0x0SQTnalXXoIQ5VjxSG4gmMO5xUDW3XMbVKXFI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t1vwiSNIjV+Xq6lHu8mYhpX1wXq+/A4mcsq3q+Fj8tfQFUpNe2iTEkLGAoGkMMMFO
         TD8BaDa/6mR8rXQrRh+JSvgitKbqI01IKMYtqvSmCXb34Vfqdh/Nfd+P5h7JOiBp0R
         qnsXWSkCQG8DvytjtjYgMjzAp1XuKP1ine1rbc27k5YvZxnRR9lPYmi0MpGJT+vsVP
         r5VWtMBnWhqmzsiUkWRm1SMI4WPTAWBxZNu7rnCLpADyj3m3rCCqQ6saxtuyR/xjTz
         y1KY2tqqnNEqi1kyaSAY6WR0XNGlo5bk7pY9/ZU7hH3B1XHvRHZ7T7GmH3Iynm2FK5
         XbD7XDxkx+Eag==
Date:   Wed, 13 Jul 2022 18:51:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever <chuck.lever@oracle.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] net: Add distinct sk_psock field
Message-ID: <20220713185136.0e3c4fb2@kernel.org>
In-Reply-To: <165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev>
References: <165772238175.1757.4978340330606055982.stgit@oracle-102.nfsv4.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 10:26:21 -0400 Chuck Lever wrote:
> The sk_psock facility populates the sk_user_data field with the
> address of an extra bit of metadata. User space sockets never
> populate the sk_user_data field, so this has worked out fine.
> 
> However, kernel socket consumers such as the RPC client and server
> do populate the sk_user_data field. The sk_psock() function cannot
> tell that the content of sk_user_data does not point to psock
> metadata, so it will happily return a pointer to something else,
> cast to a struct sk_psock.
> 
> Thus kernel socket consumers and psock currently cannot co-exist.
> 
> We could educate sk_psock() to return NULL if sk_user_data does
> not point to a struct sk_psock. However, a more general solution
> that enables full co-existence psock and other uses of sk_user_data
> might be more interesting.
> 
> Move the struct sk_psock address to its own pointer field so that
> the contents of the sk_user_data field is preserved.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Thanks for posting separately. We already have the (somewhat
nondescript) SK_USER_DATA_BPF, can we use another bit for psock?
Or add a u8 user_data type and have TCP ULP reject if the type is
anything but psock. I'm not sure why psock is special to deserve 
its own pointer.
