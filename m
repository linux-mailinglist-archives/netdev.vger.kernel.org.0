Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A8E178517
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 22:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbgCCVxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 16:53:05 -0500
Received: from correo.us.es ([193.147.175.20]:57892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgCCVxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 16:53:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 991896CB62
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 22:52:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 88F2DDA3A4
        for <netdev@vger.kernel.org>; Tue,  3 Mar 2020 22:52:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7E7E9DA736; Tue,  3 Mar 2020 22:52:49 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 70A42DA736;
        Tue,  3 Mar 2020 22:52:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Mar 2020 22:52:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 51F4A42EE38E;
        Tue,  3 Mar 2020 22:52:47 +0100 (CET)
Date:   Tue, 3 Mar 2020 22:53:00 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v5 0/4] netfilter: flowtable: add indr-block
 offload
Message-ID: <20200303215300.qzo4ankxq5ktaba4@salvia>
References: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 24, 2020 at 01:22:51PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This patch provide tunnel offload based on route lwtunnel. 
> The first two patches support indr callback setup
> Then add tunnel match and action offload.
> 
> This version modify the second patch: make the dev can bind with different 
> flowtable and check the NF_FLOWTABLE_HW_OFFLOAD flags in 
> nf_flow_table_indr_block_cb_cmd. 

I found some time to look at this indirect block infrastructure that
you have added to net/core/flow_offload.c

This is _complex_ code, I don't understand why it is so complex.
Frontend calls walks into the driver through callback, then, it gets
back to the front-end code again through another callback to come
back... this is hard to follow.

Then, we still have problem with the existing approach that you
propose, since there is 1:N mapping between the indirect block and the
net_device.

Probably not a requirement in your case, but the same net_device might
be used in several flowtables. Your patch is flawed there and I don't
see an easy way to fix this.

I know there is no way to use ->ndo_setup_tc for tunnel devices, but
you could have just make it work making it look consistent to the
->ndo_setup_tc logic.

I'm inclined to apply this patch though, in the hope that this all can
be revisited later to get it in line with the ->ndo_setup_tc approach.
However, probably I'm hoping for too much.

Thank you.
