Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 114946DF842
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 16:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjDLOVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 10:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbjDLOVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 10:21:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B73C183;
        Wed, 12 Apr 2023 07:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8680162D35;
        Wed, 12 Apr 2023 14:21:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F405C433EF;
        Wed, 12 Apr 2023 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681309266;
        bh=DGwlZCQnX6IQH3zbvzpsOUHQGIBkcXAudyQubPdkCQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uESD5MLp+L+WhdSY0d1Xpe0Gti0Dr06N3TRHU30e/qm+TjewnOY1O2G/DHPci7AEW
         qxKYjKpwncRZlPIAZdSKjxJQyWsM65QYd7lRskhaulzw7fVObS7ckiwtmLDjD8bpWx
         O5/yAsl57VBn7jz+E1kWs0u1hohlveYcVfM4Gugoz/Co44H71bjprpWr6UKQbd5/sO
         GuYlQjDB/wU4QPm6EehmD2vq+YHxrUKBDFeCIT4G0/gJmm0zLym15mz62kO4MPgO8h
         6iBXJa30mL9LALKzXCQ+yxsPXI/Ii2TS8YWgcCvY17afXVd3qk1XAQL0WsKFhPceFZ
         FiAw/IdP7EVqQ==
Date:   Wed, 12 Apr 2023 07:21:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Message-ID: <20230412072104.61910016@kernel.org>
In-Reply-To: <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
References: <20230406092558.459491-1-pablo@netfilter.org>
        <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 6 Apr 2023 12:45:25 +0200 Matthieu Baerts wrote:
> The modification in the kernel looks good to me. But I don't know how to
> make sure this will not have any impact on MPTCP on the userspace side,
> e.g. somewhere before calling the socket syscall, a check could be done
> to restrict the protocol number to IPPROTO_MAX and then breaking MPTCP
> support.

Then again any code which stores the ipproto in an unsigned char will 
be broken. A perfect solution is unlikely to exist.

> Is it not safer to expose something new to userspace, something
> dedicated to what can be visible on the wire?
> 
> Or recommend userspace programs to limit to lower than IPPROTO_RAW
> because this number is marked as "reserved" by the IANA anyway [1]?
> 
> Or define something new linked to UINT8_MAX because the layer 4 protocol
> field in IP headers is limited to 8 bits?
> This limit is not supposed to be directly linked to the one of the enum
> you modified. I think we could even say it works "by accident" because
> "IPPROTO_RAW" is 255. But OK "IPPROTO_RAW" is there from the "beginning"
> [2] :)

I'm not an expert but Pablo's patch seems reasonable to me TBH.
Maybe I'm missing some extra MPTCP specific context?
