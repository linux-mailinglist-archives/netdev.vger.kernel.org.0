Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB35F5E5EBC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 11:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiIVJi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 05:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbiIVJi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 05:38:27 -0400
Received: from kylie.crudebyte.com (kylie.crudebyte.com [5.189.157.229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C99D4336
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 02:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=crudebyte.com; s=kylie; h=Content-Type:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        Content-ID:Content-Description;
        bh=7/tUR8Twi9O5B7cIIo+vV2uW+fGk3+Mw/gvhBQ3/U1U=; b=EsvNZA9CO8vydLl2jUH5NHjWrr
        suqd1xw9apHI4ciQQP2ynoNZ2I4idoh5HZaimNJl8FKyahAxF/ygbnvSF/zT8Kf+G2ilPEQrttgU5
        yp5zJccKZPyE1YnJruD+rzre2qZ1+V0yVhvltViUuFhiB28Lk0/Xz6fg01+BVbcdNYHZD7kfDvlhH
        GDh1Nmadcd/cImJRmHEcHi+POa917fEDCN8aoDWZrf4Z5IRKFGUiyVYJkD1i2ipgjg+QUoh4tpoCI
        uXTlr3GSkslRSENtkLOCbWs+AFBeuxPq+mNYx7wtZ9oPcYwj09HG+XWGR7la5QfM92ZuQexwYAavA
        f+jh4WfzfxD3tKx+ZPfCFICQY9bJrbuXBFi7PI1cwepn4c75y+tFcegGP66PP1SuAY5tcvto4/TPf
        YBJ3aoPbOBfLHL+ynZzvmGRyhTml6MX+wHQlDambWjjaIhc9R2HmKmM0PLjuwJB3hd2GhwF+ingcC
        kptTD3hfIYvg+tInzqZwRAN5oHnlTro5bHWrId80tbYtUtj/MzTe2k0WbFx5Qlss7CHlQ+hRdATdV
        u9LFsXUYCnkbDnR8+y2AzkRsRlnH0G+ZziLRAfS5Fe8hU6DTAjXvOq+QFxL4gg7piyU5yhpLFEj8O
        yjhAa/SvOy6LlP7SSZwwTwR1E6vod51WdXouPhtEU=;
From:   Christian Schoenebeck <linux_oss@crudebyte.com>
To:     asmadeus@codewreck.org, Li Zhong <floridsleeves@gmail.com>
Cc:     netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, lucho@ionkov.net, ericvh@gmail.com
Subject: Re: [PATCH net-next v1] net/9p/trans_fd: check the return value of parse_opts
Date:   Thu, 22 Sep 2022 11:38:20 +0200
Message-ID: <2328558.MEb0jBPE05@silver>
In-Reply-To: <CAMEuxRo-QctyufOmAxZdoNrPE57KFd0MLa-kQftmhpHQfkWkJQ@mail.gmail.com>
References: <20220921210921.1654735-1-floridsleeves@gmail.com>
 <YyuA13q/B236lZ6U@codewreck.org>
 <CAMEuxRo-QctyufOmAxZdoNrPE57KFd0MLa-kQftmhpHQfkWkJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Donnerstag, 22. September 2022 00:12:38 CEST Li Zhong wrote:
> On Wed, Sep 21, 2022 at 2:23 PM <asmadeus@codewreck.org> wrote:
> > Li Zhong wrote on Wed, Sep 21, 2022 at 02:09:21PM -0700:
> > > parse_opts() could fail when there is error parsing mount options into
> > > p9_fd_opts structure due to allocation failure. In that case opts will
> > > contain invalid data.
> > 
> > In practice opts->rfd/wfd is set to ~0 before the failure modes so they
> > will contain exactly what we want them to contain: something that'll
> > fail the check below.
> > 
> > It is however cleared like this so I'll queue this patch in 9p tree when
> > I have a moment, but I'll clarify the commit message to say this is
> > NO-OP : please feel free to send a v2 if you want to put your own words
> > in there; otherwise it'll be something like below:
> > ----
> > net/9p: clarify trans_fd parse_opt failure handling
> > 
> > This parse_opts will set invalid opts.rfd/wfd in case of failure which
> > we already check, but it is not clear for readers that parse_opts error
> > are handled in p9_fd_create: clarify this by explicitly checking the
> > return value.
> > ----
> 
> Thanks for the patient reply! I agree that the check on
> opts.rfd/wft against ~0 will prevent error even if it fails
> memory allocation. But currently the error log is
> 'insufficient options', which is kind of misleading and the
> error code returned is -ENOPROTOOPT instead of -ENOMEM, which
> I guess would be better if we distinguish between them.

Avoiding those confusions for users makes sense to me, but then please also 
mention that in the commit log, because it is also useful to know the actual 
motivation of a patch.

Best regards,
Christian Schoenebeck


