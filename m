Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24FE56D4B42
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 16:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232681AbjDCO7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 10:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbjDCO7v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 10:59:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BA3CDEC
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 07:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E56161F59
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 14:59:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885FBC433EF;
        Mon,  3 Apr 2023 14:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680533988;
        bh=iHxQ6TDni0DnO0ZD0cAtbe8dQJZb9kwWdQ0/MxSR+0k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fSr1Cq8zdGVk3tXS9FlFWGl6+w7/vu1+ZS71orOg2F5IaV8brAss157RL1duL94Po
         EtdZfuofj/suPv1Do/vje1jWFKrZ+T2aNHt12ohA71s5DBC1iC8W/ZDUQcSO7FZGEl
         E4QVesBinTNggRF4yYvmDjR15itjhvKmMYI1NMfTEBo3PCFJx64yIv97EtarU9P/Vj
         gmWk9hTwBH8npUeeebFBZCpvhDaRdjcci3N8JXCTREK+uwcneTUSkX+7I4+8HdnXZy
         3y0/3nHR7vinrU5dx+si+5wgy9XWniygtDmHwqv6C27c5x4Znr8Ge9VPDkyHCzcJYL
         M94T7nzr4WijA==
Date:   Mon, 3 Apr 2023 07:59:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sagi Grimberg <sagi@grimberg.me>
Cc:     Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
        Boris Pismenny <borisp@nvidia.com>, john.fastabend@gmail.com,
        Paolo Abeni <pabeni@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        linux-nvme@lists.infradead.org,
        Chuck Lever <chuck.lever@oracle.com>,
        kernel-tls-handshake@lists.linux.dev,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 10/18] nvme-tcp: fixup send workflow for kTLS
Message-ID: <20230403075946.26ad71ee@kernel.org>
In-Reply-To: <44fe87ba-e873-fa05-d294-d29d5e6dd4b5@grimberg.me>
References: <20230329135938.46905-1-hare@suse.de>
        <20230329135938.46905-11-hare@suse.de>
        <634385cc-35af-eca0-edcb-1196a95d1dfa@grimberg.me>
        <20230330224920.3a47fec9@kernel.org>
        <7f057726-8777-2fd3-a207-b3cd96076cb9@suse.de>
        <44fe87ba-e873-fa05-d294-d29d5e6dd4b5@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Apr 2023 15:20:13 +0300 Sagi Grimberg wrote:
> >> Some of the flags are call specific, others may be internal to the
> >> networking stack (e.g. the DECRYPTED flag). Old protocols didn't do
> >> any validation because people coded more haphazardly in the 90s.
> >> This lack of validation is a major source of technical debt :(  
> > 
> > A-ha. So what is the plan?
> > Should the stack validate flags?
> > And should the rules for validating be the same for all protocols?  
> 
> MSG_SENDPAGE_NOTLAST is not an internal flag, I thought it was
> essentially similar semantics to MSG_MORE but for sendpage. It'd
> be great if this can be allowed in tls (again, at the very least
> don't fail but continue as if it wasn't passed).

.. but.. MSG_SENDPAGE_NOTLAST is supported in TLS, isn't it?
Why are we talking about it?
