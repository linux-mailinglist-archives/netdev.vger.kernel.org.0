Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01FCD5FE8F4
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 08:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJNGfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 02:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiJNGfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 02:35:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F4E6DBBDC;
        Thu, 13 Oct 2022 23:35:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE07EB820BD;
        Fri, 14 Oct 2022 06:35:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB879C433C1;
        Fri, 14 Oct 2022 06:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665729326;
        bh=e3wwQAoebYtvsfnsW4jkNP8PEXtfKqTwzYXsuG6zc5w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=POKMJe3GDXf8Voj9kf6KSccZT9+i9Sekw2OuRVDLGFBzCHgQSfkV2qrbrn6oeN/GJ
         Jb7M7ihH3ERcROsb9WQntp9o34pznxVvgwJZOLnAObUqs+xkTY2tErULUki2f1DeNk
         wWkJcLLDVJC3jJHTa522YsDNdMGTULxJDS1mLjgtjLNaxrQTw1BVJqvPMYxWXNZumC
         cFkWZpBthnymCtnY3439dyRWo3kLqYyaniDCh+G+SRqxGM72CjugIXTY31dEt/jAgh
         +Gyl+U8PHSHhDuG/W9k1exDsW53B4OjUp6TsCaX4NwhduQ/y6asaq3Uv++E8pAJK7L
         X+8FRBbAU8jEA==
Date:   Fri, 14 Oct 2022 09:35:22 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net/sock: Introduce trace_sk_data_ready()
Message-ID: <Y0kDKpuJHPC36kal@unreal>
References: <20221012232121.27374-1-yepeilin.cs@gmail.com>
 <20221014000058.30060-1-yepeilin.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014000058.30060-1-yepeilin.cs@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 05:00:58PM -0700, Peilin Ye wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   ksoftirqd/0-16  [000] ..s..  99.784482: sk_data_ready: family=10 protocol=58 func=sock_def_readable
>   ksoftirqd/0-16  [000] ..s..  99.784819: sk_data_ready: family=10 protocol=58 func=sock_def_readable
> <...>
> 
> Suggested-by: Cong Wang <cong.wang@bytedance.com>
> Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>

Please don't reply-to new patches and always send them as new threads
with links to previous versions in changelog.

> ---
> change since v4:
>   - Add back tracepoint in iscsi_target_sk_data_ready()
> 
> changes since v3:
>   - Avoid using __func__ everywhere (Leon Romanovsky)
>   - Delete tracepoint in iscsi_target_sk_data_ready()
> 
> change since v2:
>   - Fix modpost error for modules (kernel test robot)
> 
> changes since v1:
>   - Move tracepoint into ->sk_data_ready() callback implementations
>     (Eric Dumazet)
>   - Fix W=1 warning (Jakub Kicinski)
> 
>  drivers/infiniband/hw/erdma/erdma_cm.c   |  3 +++
>  drivers/infiniband/sw/siw/siw_cm.c       |  5 +++++
>  drivers/infiniband/sw/siw/siw_qp.c       |  3 +++
>  drivers/nvme/host/tcp.c                  |  3 +++
>  drivers/nvme/target/tcp.c                |  5 +++++
>  drivers/scsi/iscsi_tcp.c                 |  3 +++
>  drivers/soc/qcom/qmi_interface.c         |  3 +++
>  drivers/target/iscsi/iscsi_target_nego.c |  2 ++
>  drivers/xen/pvcalls-back.c               |  5 +++++
>  fs/dlm/lowcomms.c                        |  5 +++++
>  fs/ocfs2/cluster/tcp.c                   |  5 +++++
>  include/trace/events/sock.h              | 24 ++++++++++++++++++++++++
>  net/ceph/messenger.c                     |  4 ++++
>  net/core/net-traces.c                    |  2 ++
>  net/core/skmsg.c                         |  3 +++
>  net/core/sock.c                          |  2 ++
>  net/kcm/kcmsock.c                        |  3 +++
>  net/mptcp/subflow.c                      |  3 +++
>  net/qrtr/ns.c                            |  3 +++
>  net/rds/tcp_listen.c                     |  2 ++
>  net/rds/tcp_recv.c                       |  2 ++
>  net/sctp/socket.c                        |  3 +++
>  net/smc/smc_rx.c                         |  3 +++
>  net/sunrpc/svcsock.c                     |  5 +++++
>  net/sunrpc/xprtsock.c                    |  3 +++
>  net/tipc/socket.c                        |  3 +++
>  net/tipc/topsrv.c                        |  5 +++++
>  net/tls/tls_sw.c                         |  3 +++
>  net/xfrm/espintcp.c                      |  3 +++
>  29 files changed, 118 insertions(+)
> 
> diff --git a/drivers/infiniband/hw/erdma/erdma_cm.c b/drivers/infiniband/hw/erdma/erdma_cm.c
> index f13f16479eca..084da6698080 100644
> --- a/drivers/infiniband/hw/erdma/erdma_cm.c
> +++ b/drivers/infiniband/hw/erdma/erdma_cm.c
> @@ -16,6 +16,7 @@
>  #include <linux/types.h>
>  #include <linux/workqueue.h>
>  #include <net/addrconf.h>
> +#include <trace/events/sock.h>
>  
>  #include <rdma/ib_user_verbs.h>
>  #include <rdma/ib_verbs.h>
> @@ -933,6 +934,8 @@ static void erdma_cm_llp_data_ready(struct sock *sk)
>  {
>  	struct erdma_cep *cep;
>  
> +	trace_sk_data_ready(sk);
> +
>  	read_lock(&sk->sk_callback_lock);

I see this pattern in all places and don't know if it is correct or not,
but you are calling to trace_sk_data_ready() at the beginning of
function and do it without taking sk_callback_lock.

Thanks
