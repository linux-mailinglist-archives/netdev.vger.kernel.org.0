Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB1B67150E
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjARHcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229837AbjARHa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:30:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8725CFFC;
        Tue, 17 Jan 2023 22:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4353B616D0;
        Wed, 18 Jan 2023 06:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3876C433D2;
        Wed, 18 Jan 2023 06:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674024466;
        bh=+e8Tu1yzNoIuZRv3cfV5EujT7Y0Ki8eK75d8fyjGjYU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=up1oXAKUJlDbL/vu1dR4uq8tknJjJA23u+OsMvEiOFOxbAVe+XYnvnejYPlUGbgDo
         lyEe1ps9KO6JDBm4ID1AsIgfS2qHN/ICu64ZJQ5+oY3hEmnohorCfK4BCb4qFCFrjX
         FjJwR91gNSiiwXNqo5HSvTS4Q3ZP6pVTv8xTy7oBt4rZdxU4nR1dgnvnJQ8V50TRQH
         m3ajM+v+eAcHBgs/CxO7qx6Xs+6d8Be90kZ809xg6cvUXLVKCrBoFUx/Kh+dQ1bxCn
         UPMPI6OL3LbjH/9q8wLMCa9nwbOXoqN35WN+81n52gI/+QQCatBVN06vsdwRFLsEj1
         2zEWpihkxf+Nw==
Date:   Tue, 17 Jan 2023 22:47:44 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Bryan Tan <bryantan@vmware.com>,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        Israel Rukshin <israelr@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@fb.com>,
        Keith Busch <kbusch@kernel.org>, linux-kernel@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Vishnu Dasa <vdasa@vmware.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH rdma-next 00/13] Add RDMA inline crypto support
Message-ID: <Y8eWEPZahIFAfnoI@sol.localdomain>
References: <cover.1673873422.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1673873422.git.leon@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Leon,

On Mon, Jan 16, 2023 at 03:05:47PM +0200, Leon Romanovsky wrote:
> >From Israel,
> 
> The purpose of this patchset is to add support for inline
> encryption/decryption of the data at storage protocols like nvmf over
> RDMA (at a similar way like integrity is used via unique mkey).
> 
> This patchset adds support for plaintext keys. The patches were tested
> on BF-3 HW with fscrypt tool to test this feature, which showed reduce
> in CPU utilization when comparing at 64k or more IO size. The CPU utilization
> was improved by more than 50% comparing to the SW only solution at this case.
> 
> How to configure fscrypt to enable plaintext keys:
>  # mkfs.ext4 -O encrypt /dev/nvme0n1
>  # mount /dev/nvme0n1 /mnt/crypto -o inlinecrypt
>  # head -c 64 /dev/urandom > /tmp/master_key
>  # fscryptctl add_key /mnt/crypto/ < /tmp/master_key
>  # mkdir /mnt/crypto/test1
>  # fscryptctl set_policy 152c41b2ea39fa3d90ea06448456e7fb /mnt/crypto/test1
>    ** “152c41b2ea39fa3d90ea06448456e7fb” is the output of the
>       “fscryptctl add_key” command.
>  # echo foo > /mnt/crypto/test1/foo
> 
> Notes:
>  - At plaintext mode only, the user set a master key and the fscrypt
>    driver derived from it the DEK and the key identifier.
>  - 152c41b2ea39fa3d90ea06448456e7fb is the derived key identifier
>  - Only on the first IO, nvme-rdma gets a callback to load the derived DEK. 
> 
> There is no special configuration to support crypto at nvme modules.
> 
> Thanks

Very interesting work!  Can you Cc me on future versions?

I'm glad to see that this hardware allows all 16 IV bytes to be specified.

Does it also handle programming and evicting keys efficiently?

Also, just checking: have you tested that the ciphertext that this inline
encryption hardware produces is correct?  That's always super important to test.
There are xfstests that test for it, e.g. generic/582.  Another way to test it
is to just manually test whether encrypted files that were created when the
filesystem was mounted with '-o inlinecrypt' show the same contents when the
filesystem is *not* mounted with '-o inlinecrypt' (or vice versa).

- Eric
