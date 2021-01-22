Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE3F2FF9DF
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbhAVBTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:19:34 -0500
Received: from correo.us.es ([193.147.175.20]:35624 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbhAVBTU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:19:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D136F1022A2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 02:17:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3BF8DA78F
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 02:17:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B92DEDA730; Fri, 22 Jan 2021 02:17:43 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WELCOMELIST,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D9E1DA73F;
        Fri, 22 Jan 2021 02:17:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 22 Jan 2021 02:17:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B6C442EF9E1;
        Fri, 22 Jan 2021 02:17:41 +0100 (CET)
Date:   Fri, 22 Jan 2021 02:18:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Oz Shlomo <ozsh@nvidia.com>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Roi Dayan <roid@nvidia.com>, Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paul Blakey <paulb@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next 08/15] net/mlx5e: CT: Preparation for offloading
 +trk+new ct rules
Message-ID: <20210122011834.GA25356@salvia>
References: <20210108053054.660499-9-saeed@kernel.org>
 <20210108214812.GB3678@horizon.localdomain>
 <c11867d2-6fda-d77c-6b52-f4093c751379@nvidia.com>
 <218258b2-3a86-2d87-dfc6-8b3c1e274b26@nvidia.com>
 <20210111235116.GA2595@horizon.localdomain>
 <f25eee28-4c4a-9036-8c3d-d84b15a8b5e7@nvidia.com>
 <20210114130238.GA2676@horizon.localdomain>
 <d1b5b862-8c30-efb6-1a2f-4f9f0d49ef15@nvidia.com>
 <20210114215052.GB2676@horizon.localdomain>
 <009bd8cf-df39-5346-b892-4e68a042c4b4@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <009bd8cf-df39-5346-b892-4e68a042c4b4@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Oz,

On Wed, Jan 20, 2021 at 06:09:48PM +0200, Oz Shlomo wrote:
> On 1/14/2021 11:50 PM, Marcelo Ricardo Leitner wrote:
> > 
> > Thoughts?
> > 
> 
> I wonder if we should develop a generic mechanism to optimize CT software
> for a use case that is faulty by design.
> This has limited value for software as it would only reduce the conntrack
> table size (packet classification is still required).
> However, this feature may have a big impact on hardware offload.
> Normally hardware offload relies on software to handle new connections.
> Causing all new connections to be processed by software.
> With this patch the hardware may autonomously set the +new connection state
> for the relevant connections.

Could you fix this issue with unidirectional flows by checking for
IPS_CONFIRMED status bit? The idea is to hardware offload the entry
after the first packet goes through software successfully. Then, there
is no need to wait for the established state that requires to see
traffic in both directions.
