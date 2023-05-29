Return-Path: <netdev+bounces-6069-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EAF0714A58
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C2A971C209B0
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 13:30:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D64B7476;
	Mon, 29 May 2023 13:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5E83D60
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 13:30:21 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 018A78E;
	Mon, 29 May 2023 06:30:20 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1134)
	id 5751420FC3CB; Mon, 29 May 2023 06:30:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5751420FC3CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1685367019;
	bh=amiG+ksiMGgI5MFtUbInBQGpOXH7qxIfeuXBndczxPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KaTKPLtMqPZGOYejB3wz6za6u3crwFeJdhRNEojd1HqHnz5c6957L//Laxk/xZtPW
	 dfezVkQymG7XXhRvFZ5uILjgXRavZ9w4/EUz4eLXR6mIOYPijiKR1ZabZIpaMC9YCo
	 mcEpQo2RJ7X48+KskjIAhUvUKQKG/yau1pzd0Ny4=
Date: Mon, 29 May 2023 06:30:19 -0700
From: Shradha Gupta <shradhagupta@linux.microsoft.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH v3] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <20230529133019.GB21447@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1685080949-18316-1-git-send-email-shradhagupta@linux.microsoft.com>
 <92bc6f3e-4463-e0fe-5cab-54c6c5eecd3f@wanadoo.fr>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92bc6f3e-4463-e0fe-5cab-54c6c5eecd3f@wanadoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-19.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for the comment Christophe.
On Mon, May 29, 2023 at 02:49:15PM +0200, Christophe JAILLET wrote:
> Le 26/05/2023 ?? 08:02, Shradha Gupta a ??crit??:
> >Allocate the size of rx indirection table dynamically in netvsc
> >from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> >query instead of using a constant value of ITAB_NUM.
> >
> >Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> >Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> >Testcases:
> >1. ethtool -x eth0 output
> >2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
> >3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV
> >
> >---
> 
> [...]
> 
> >@@ -1596,11 +1608,18 @@ void rndis_filter_device_remove(struct hv_device *dev,
> >  				struct netvsc_device *net_dev)
> >  {
> >  	struct rndis_device *rndis_dev = net_dev->extension;
> >+	struct net_device *net = hv_get_drvdata(dev);
> >+	struct net_device_context *ndc = netdev_priv(net);
> >  	/* Halt and release the rndis device */
> >  	rndis_filter_halt_device(net_dev, rndis_dev);
> >  	netvsc_device_remove(dev);
> >+
> >+	ndc->rx_table_sz = 0;
> >+	kfree(ndc->rx_table);
> >+	ndc->rx_table = NULL;
> >+
> 
> Nit: useless empty NL
This is to prevent any potential double free, or accessing freed memory, etc.
As requested by Haiyang in v2 patch
> 
> >  }
> >  int rndis_filter_open(struct netvsc_device *nvdev)

