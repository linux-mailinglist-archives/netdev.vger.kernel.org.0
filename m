Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD5F6D193A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCaICn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbjCaICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:02:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA00EB63;
        Fri, 31 Mar 2023 01:02:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B15AB82C92;
        Fri, 31 Mar 2023 08:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F3FAC4339B;
        Fri, 31 Mar 2023 08:02:36 +0000 (UTC)
Date:   Fri, 31 Mar 2023 13:32:16 +0530
From:   Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
To:     Sricharan Ramabadhran <quic_srichara@quicinc.com>
Cc:     mani@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <20230331080216.GA6352@thinkpad>
References: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 01:18:57PM +0530, Sricharan Ramabadhran wrote:
> On the remote side, when QRTR socket is removed, af_qrtr will call
> qrtr_port_remove() which broadcasts the DEL_CLIENT packet to all neighbours
> including local NS. NS upon receiving the DEL_CLIENT packet, will remove
> the lookups associated with the node:port and broadcasts the DEL_SERVER
> packet.
> 
> But on the host side, due to the arrival of the DEL_CLIENT packet, the NS
> would've already deleted the server belonging to that port. So when the
> remote's NS again broadcasts the DEL_SERVER for that port, it throws below
> error message on the host:
> 
> "failed while handling packet from 2:-2"
> 
> So fix this error by not broadcasting the DEL_SERVER packet when the
> DEL_CLIENT packet gets processed."
> 
> Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
> Signed-off-by: Sricharan Ramabadhran <quic_srichara@quicinc.com>
> Signed-off-by: Ram Kumar Dharuman <quic_ramd@quicinc.com>
> ---
> [v2] Fixed comments from Manivannan and Jakub Kicinski
> Note: Functionally tested on 5.4 and compile tested on 6.3 TOT
> 
>  net/qrtr/ns.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
> index 722936f..0f25a38 100644
> --- a/net/qrtr/ns.c
> +++ b/net/qrtr/ns.c
> @@ -274,7 +274,7 @@ static struct qrtr_server *server_add(unsigned int service,
>  	return NULL;
>  }
>  
> -static int server_del(struct qrtr_node *node, unsigned int port)
> +static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
>  {
>  	struct qrtr_lookup *lookup;
>  	struct qrtr_server *srv;
> @@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
>  	radix_tree_delete(&node->servers, port);
>  
>  	/* Broadcast the removal of local servers */
> -	if (srv->node == qrtr_ns.local_node)
> +	if (srv->node == qrtr_ns.local_node && bcast)
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
> @@ -459,10 +459,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
>  		kfree(lookup);
>  	}
>  
> -	/* Remove the server belonging to this port */
> +	/* Remove the server belonging to this port but don't broadcast

This is still not as per the multi line comment style perferred in kernel.
Please read: https://www.kernel.org/doc/html/latest/process/coding-style.html#commenting

- Mani

> +	 * DEL_SERVER. Neighbours would've already removed the server belonging
> +	 * to this port due to the DEL_CLIENT broadcast from qrtr_port_remove().
> +	 */
>  	node = node_get(node_id);
>  	if (node)
> -		server_del(node, port);
> +		server_del(node, port, false);
>  
>  	/* Advertise the removal of this client to all local servers */
>  	local_node = node_get(qrtr_ns.local_node);
> @@ -567,7 +570,7 @@ static int ctrl_cmd_del_server(struct sockaddr_qrtr *from,
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
