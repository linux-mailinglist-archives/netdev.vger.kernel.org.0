Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F606DDE1B
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 16:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjDKOgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 10:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbjDKOgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 10:36:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4544A212F;
        Tue, 11 Apr 2023 07:36:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D870F6275F;
        Tue, 11 Apr 2023 14:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91048C433D2;
        Tue, 11 Apr 2023 14:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681223812;
        bh=1ZaELguZrMUDSqBDbQ/nvMKkVutqjjhoMJMSmLlmpsA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aDIrm0PeTzZNwH3+9XkPMGnN+vFyIBQ749a4wLpDyrbSohvM13uVlyYBuQCYKnZ8I
         LwefzyfXPov/RWnBEn42BIsbVf84vw7NzHXmgOze6aPFwuTm8PiMmBwnBGl9009o93
         IWqAyya49c34lkaD8vEkpd7MXndFMPoawLE+w/vO5DRgnSuLJ3aEyOkl5bgIlIev9J
         egD6kT3fs1v2YFbNX+AfIsAHgwuF5PnluxB2c7dsgXT+kTnItwqWVVzDnJjKuXhgwe
         4M2fwDBRYBjh+6ZE5N+/7B8+V9zisEiSx3+9dnarB50RECC2/tMuC1TEnvmnffJOPk
         v7eW/jMo6AMXg==
Message-ID: <75e3c434-eb8b-66e5-5768-ca0f906979a1@kernel.org>
Date:   Tue, 11 Apr 2023 08:36:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.1
Subject: Re: [PATCH 0/5] add initial io_uring_cmd support for sockets
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>
Cc:     Willem de Bruijn <willemb@google.com>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, asml.silence@gmail.com,
        axboe@kernel.dk, leit@fb.com, edumazet@google.com,
        pabeni@redhat.com, davem@davemloft.net, dccp@vger.kernel.org,
        mptcp@lists.linux.dev, linux-kernel@vger.kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <CA+FuTSeKpOJVqcneCoh_4x4OuK1iE0Tr6f3rSNrQiR-OUgjWow@mail.gmail.com>
 <ZC7seVq7St6UnKjl@gmail.com>
 <CA+FuTSf9LEhzjBey_Nm_-vN0ZjvtBSQkcDWS+5uBnLmr8Qh5uA@mail.gmail.com>
 <e576f6fe-d1f3-93cd-cb94-c0ae115299d8@kernel.org>
 <ZDVLyi1PahE0sfci@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <ZDVLyi1PahE0sfci@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/23 6:00 AM, Breno Leitao wrote:
> I am not sure if avoiding io_uring details in network code is possible.
> 
> The "struct proto"->uring_cmd callback implementation (tcp_uring_cmd()
> in the TCP case) could be somewhere else, such as in the io_uring/
> directory, but, I think it might be cleaner if these implementations are
> closer to function assignment (in the network subsystem).
> 
> And this function (tcp_uring_cmd() for instance) is the one that I am
> planning to map io_uring CMDs to ioctls. Such as SOCKET_URING_OP_SIOCINQ
> -> SIOCINQ.
> 
> Please let me know if you have any other idea in mind.

I am not convinced that this io_uring_cmd is needed. This is one
in-kernel subsystem calling into another, and there are APIs for that.
All of this set is ioctl based and as Willem noted a little refactoring
separates the get_user/put_user out so that in-kernel can call can be
made with existing ops.
