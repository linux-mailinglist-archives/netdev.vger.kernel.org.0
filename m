Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 380B6625006
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 03:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiKKCMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 21:12:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiKKCMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 21:12:44 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A12CC5E3D8
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 18:12:43 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 01629C009; Fri, 11 Nov 2022 03:12:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668132766; bh=1Y4dEB1qb4220Gr3PWRUeHdgik0Tcm49s6ZwF3lvl+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aUCOg3KUgI3Vf14pKcKbnhLpUCKLeiWf1Xy6NC+RuEBrlAEQYuielX6ksMbN1NMOZ
         H400MoJi9ygXrCfT1x7GE/D0Tta8u/M+tJoUjhmVxMdIfubJnLoLwIQ+WraseIrgJO
         p3SEDCH4SMB5CGmvUsbtDvtepO78TcZzavwTHOIHKxsu/HokQroRE3XjgiKYIDzULp
         hZu9OVU8i60D4Oo3m+wNUnkNrTizT1LaEiptn9SE9ryHQiD4UojCp4PwzGxN4LR4Y8
         nVKtWkaouM+Bp6UzpuIDqBhWYWOGNcO+nyR+eiNyyxWHyxHt85nfqRUlooQb+csGFG
         GL0sdNaSlVrNg==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 11D80C009;
        Fri, 11 Nov 2022 03:12:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1668132765; bh=1Y4dEB1qb4220Gr3PWRUeHdgik0Tcm49s6ZwF3lvl+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0C35RTyzaUS0y9kuU5KslEIRYZXJoSUKB7WD2fxs/ik69Lw2YpbqqwDTd5P+tBnkf
         Ndti+YPTGmXRksTDm12F34xuR8fQPbMrk/3ZtfKeoqL+IOLS4xoEWE5KYQM10skOfY
         Bakjuv1YzqKIxylwbiY4SvMGHsqaT73s78qI+GNpfkMMOb+6tceCrC4EXNA1WQcQ80
         xx+VvOoYa2I9QTFhoc0iya4Ln3RQU2mNEtJd1Rt36CqhKwdLbITvdRVzvVtAuQ9KQ+
         rN90PDJlKuV637+uR6reyWhittd3h6nyjy0Utvs86dlIHw7klDUA43NvefxBP9xtJS
         QeyTfuZ80/0kA==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id ac7bc1ba;
        Fri, 11 Nov 2022 02:12:34 +0000 (UTC)
Date:   Fri, 11 Nov 2022 11:12:18 +0900
From:   asmadeus@codewreck.org
To:     shaozhengchao <shaozhengchao@huawei.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] net/9p: fix issue of list_del corruption in
 p9_fd_cancel()
Message-ID: <Y22vgvsTUj1F8Gog@codewreck.org>
References: <20221110122606.383352-1-shaozhengchao@huawei.com>
 <Y2zz24jRIo9DdWw7@codewreck.org>
 <61814668-2717-d140-5a01-f6a46e05de09@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <61814668-2717-d140-5a01-f6a46e05de09@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shaozhengchao wrote on Fri, Nov 11, 2022 at 09:23:12AM +0800:
> > Please tell me if you want to send a v2 with your words, or I'll just
> > pick this up with my suggestion and submit to Linus in a week-ish after
> > testing. No point in waiting a full cycle for this.
>
> 	Thank you for your review. Your suggestion looks good to me, and
> please add your suggestion. :)

I've done quick checks with a tcp server and pushed it for next.

I'll try to remember to send it to Linus mid next-week.
-- 
Dominique
