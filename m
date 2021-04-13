Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7911035DCAC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 12:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244914AbhDMKpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 06:45:54 -0400
Received: from mail.netfilter.org ([217.70.188.207]:51650 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243111AbhDMKpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 06:45:52 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 95D8863E34;
        Tue, 13 Apr 2021 12:45:04 +0200 (CEST)
Date:   Tue, 13 Apr 2021 12:45:27 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Roi Dayan <roid@nvidia.com>
Cc:     netdev@vger.kernel.org, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v2 1/1] netfilter: flowtable: Add
 FLOW_OFFLOAD_XMIT_UNSPEC xmit type
Message-ID: <20210413104527.GA23193@salvia>
References: <20210413080605.2108422-1-roid@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210413080605.2108422-1-roid@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 11:06:05AM +0300, Roi Dayan wrote:
> It could be xmit type was not set and would default to FLOW_OFFLOAD_XMIT_NEIGH
> and in this type the gc expect to have a route info.
> Fix that by adding FLOW_OFFLOAD_XMIT_UNSPEC which defaults to 0.

Applied, thanks.

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 76573bae6664..39c02d1aeedf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -130,6 +130,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
                flow_tuple->dst_cache = dst;
                flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
                break;
+       default:
+               WARN_ON_ONCE(1);
+               break;
        }
        flow_tuple->xmit_type = route->tuple[dir].xmit_type;

I have included this chunk to make gcc happy.

net/netfilter/nf_flow_table_core.c: In function ‘flow_offload_fill_route’:
net/netfilter/nf_flow_table_core.c:116:2: warning: enumeration value ‘FLOW_OFFLOAD_XMIT_UNSPEC’ not handled in switch [-Wswitch]
  116 |  switch (route->tuple[dir].xmit_type) {
      |  ^~~~~~
