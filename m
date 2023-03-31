Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA88A6D27D8
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 20:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbjCaS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbjCaS3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 14:29:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F32522E91;
        Fri, 31 Mar 2023 11:29:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 198E6B83178;
        Fri, 31 Mar 2023 18:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F405C433D2;
        Fri, 31 Mar 2023 18:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680287377;
        bh=VLiJYbbgaqDt3zgZhKIrkeJlT8nzzl7lxkh40spkePs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ft+VxX5m72VgnD+w68Y6gDR4gRDdUgawFkMEVPOQaTuH2622mAz8s7k6pn/2Sa36Y
         WRC5cb83JijOh4sJehOAPP1Ate5sh4bDAB8T5DA8UZ52YXs2vtaWDhDfY8qyqpzupt
         hkcL9tIuKi03F4ECw65QeJDXipD/gohFtWTS734JAth4W+afeS2z2Ais1lGD9pajqX
         rtXmE8b0qLPokHxrrTkLSgAQ1v/0yKU8Z6yiP8r0Z3/aOdRKECPGmzohDfh6JN8xQS
         E7szFFRlqyYO1PBWuQbEA3Uo3x3F70U2zARlDRbhZEny03mhAsyZDhgVncVm93CYRa
         Et/vV+sdmeLrQ==
Date:   Fri, 31 Mar 2023 23:59:31 +0530
From:   Manivannan Sadhasivam <mani@kernel.org>
To:     Sricharan Ramabadhran <quic_srichara@quicinc.com>
Cc:     Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: qrtr: Do not do DEL_SERVER broadcast after
 DEL_CLIENT
Message-ID: <20230331182931.GB6352@thinkpad>
References: <1680248937-16617-1-git-send-email-quic_srichara@quicinc.com>
 <20230331080216.GA6352@thinkpad>
 <4792f5c8-2902-2e46-b663-22cffe450556@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4792f5c8-2902-2e46-b663-22cffe450556@quicinc.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 31, 2023 at 02:02:04PM +0530, Sricharan Ramabadhran wrote:
> <..>
> 
> > > -static int server_del(struct qrtr_node *node, unsigned int port)
> > > +static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
> > >   {
> > >   	struct qrtr_lookup *lookup;
> > >   	struct qrtr_server *srv;
> > > @@ -287,7 +287,7 @@ static int server_del(struct qrtr_node *node, unsigned int port)
> > >   	radix_tree_delete(&node->servers, port);
> > >   	/* Broadcast the removal of local servers */
> > > -	if (srv->node == qrtr_ns.local_node)
> > > +	if (srv->node == qrtr_ns.local_node && bcast)
> > >   		service_announce_del(&qrtr_ns.bcast_sq, srv);
> > >   	/* Announce the service's disappearance to observers */
> > > @@ -373,7 +373,7 @@ static int ctrl_cmd_bye(struct sockaddr_qrtr *from)
> > >   		}
> > >   		slot = radix_tree_iter_resume(slot, &iter);
> > >   		rcu_read_unlock();
> > > -		server_del(node, srv->port);
> > > +		server_del(node, srv->port, true);
> > >   		rcu_read_lock();
> > >   	}
> > >   	rcu_read_unlock();
> > > @@ -459,10 +459,13 @@ static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,
> > >   		kfree(lookup);
> > >   	}
> > > -	/* Remove the server belonging to this port */
> > > +	/* Remove the server belonging to this port but don't broadcast
> > 
> > This is still not as per the multi line comment style perferred in kernel.
> > Please read: https://www.kernel.org/doc/html/latest/process/coding-style.html#commenting
> > 
> 
>  Ho, i had it like first style and checkpatch cribbed. Then changed it
>  as per the second style for net/ format. You mean we should stick to
>  1 st style ?
> 

Oops, sorry I forgot the fact that the networking code uses a different style.
Ignore my above comment.

- Mani

> Regards,
>  Sricharan

-- 
மணிவண்ணன் சதாசிவம்
