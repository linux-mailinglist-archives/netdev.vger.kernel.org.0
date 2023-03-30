Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C336CFB78
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 08:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbjC3GZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 02:25:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjC3GZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 02:25:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92752720;
        Wed, 29 Mar 2023 23:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 445FDB825F0;
        Thu, 30 Mar 2023 06:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8807C433EF;
        Thu, 30 Mar 2023 06:24:55 +0000 (UTC)
Date:   Thu, 30 Mar 2023 11:54:45 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Sricharan R <quic_srichara@quicinc.com>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <20230330062445.GB9876@thinkpad>
References: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1680095250-21032-1-git-send-email-quic_srichara@quicinc.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 06:37:30PM +0530, Sricharan R wrote:
> When the qrtr socket is released, qrtr_port_remove gets called, which
> broadcasts a DEL_CLIENT. After this DEL_SERVER is also additionally
> broadcasted, which becomes NOP, but triggers the below error msg.
> 
> "failed while handling packet from 2:-2", since remote node already
> acted upon on receiving the DEL_CLIENT, once again when it receives
> the DEL_SERVER, it returns -ENOENT.
> 
> Fixing it by not sending a 'DEL_SERVER' to remote when a 'DEL_CLIENT'
> was sent for that port.
> 

Can you share the qrtr trace when this happens to help me understand the flow?

- Mani

> Signed-off-by: Ram Kumar D <quic_ramd@quicinc.com>
> Signed-off-by: Sricharan R <quic_srichara@quicinc.com>
> ---
> Note: Functionally tested on 5.4 kernel and compile tested on 6.3 TOT
> 
>  net/qrtr/ns.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 722936f..6fbb195 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -274,7 +274,7 @@ static struct qrtr_server *server_add(unsigned int service,
>  	return NULL;
>  }
>  
> -static int server_del(struct qrtr_node *node, unsigned int port)
> +static int server_del(struct qrtr_node *node, unsigned int port, bool del_server)
>  {
>  	struct qrtr_lookup *lookup;
>  	struct qrtr_server *srv;
> @@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
>  	radix_tree_delete(&node->servers, port);
>  
>  	/* Broadcast the removal of local servers */
> -	if (srv->node == qrtr_ns.local_node)
> +	if (srv->node == qrtr_ns.local_node && del_server)
>  		service_announce_del(&qrtr_ns.bcast_sq, srv);
>  
>  	/* Announce the service's disappearance to observers */
> @@ -373,7 +373,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
>  		}
>  		slot = radix_tree_iter_resume(slot, &iter);
>  		rcu_read_unlock();
> -		server_del(node, srv->port);
> +		server_del(node, srv->port, true);
>  		rcu_read_lock();
>  	}
>  	rcu_read_unlock();
> @@ -459,10 +459,14 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
>  		kfree(lookup);
>  	}
>  
> -	/* Remove the server belonging to this port */
> +	/* Remove the server belonging to this port
> +	 * Given that DEL_CLIENT is already broadcasted
> +	 * by port_remove, no need to send DEL_SERVER for
> +	 * the same port to remote
> +	 */
>  	node = node_get(node_id);
>  	if (node)
> -		server_del(node, port);
> +		server_del(node, port, false);
>  
>  	/* Advertise the removal of this client to all local servers */
>  	local_node = node_get(qrtr_ns.local_node);
> @@ -567,7 +571,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
>  	if (!node)
>  		return -ENOENT;
>  
> -	return server_del(node, port);
> +	return server_del(node, port, true);
>  }
>  
>  static int ctrl_cmd_new_lookup(struct sockaddr_qrtr *from,
> -- 
> 2.7.4
> 

-- 
மணிவண்ணன் சதாசிவம்
