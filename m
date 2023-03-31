Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479ED6D27DC
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjCaSav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjCaSau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:30:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6134A2221D;
        Fri, 31 Mar 2023 11:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1AE08B83178;
        Fri, 31 Mar 2023 18:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A72C433D2;
        Fri, 31 Mar 2023 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680287446;
        bh=yiKVgmHM0bWev10LVy6qn01mg+VkLpkCvgdqpFKKk8M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EQWYeoi9FIA/JvwStwW2OEPObuXLPkPJByp8bLZmEfg//4T2Pjy3okD3ochxN0Ujg
         QwgVKbKKLeALfGLnDjyYXmvXyzM4LnR6PAYHvQ6IM9nvbZbtsswc8AIJ7J3Lg12kBl
         6oj+M99flwF3oSud/T6mjJwTFk6jh476py4ylYj8agyu98LmIFY/DoIaTaSeFwSTGJ
         a+4b1A2zAsjpFQvtqGr3qqhX3xP1NcGW60heJ7uFClLT/jVj+JcJJcKq+lm3L/KD5s
         s49dWKdGWnsdiM66TK6yqzeuLsaBfm1AUZ2K9CJCDIOhZZue+jyW/XVUCXlVLO6qdR
         OvRcNKqK2YOLw==
Date:   Sat, 1 Apr 2023 00:00:39 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Sricharan Ramabadhran <quic_srichara@quicinc.com>
Cc:     manivannan.sadhasivam@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <20230331183039.GC6352@thinkpad>
References: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
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

Sender's Signed-off-by should come last. With that fixed,

Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>

- Mani

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
