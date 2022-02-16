Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D13B4B7D24
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 03:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245752AbiBPCCH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 21:02:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238125AbiBPCCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 21:02:06 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2E67CDC2
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 18:01:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9CAD8CE248F
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 02:01:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB88C340EB;
        Wed, 16 Feb 2022 02:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644976911;
        bh=WXF1ao/URZgfYljtTdciiE1b/Pn+MCwlinQcHNN0t+k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BYsYVJQ0J5Ke91r5n+nmKgn5PWfF3CjaJRwr+eEXVvctYZOtNQcz93HxwJQ15mdbH
         sQhQ6ewgwS/t/iRu9J7fg0D0FsaRJBxjrWtp0zqeqfTokE3hKAOsHNjNiANIH6okq6
         Ow6P6/sUWqiovQLnmBZz0GkCtG1QHMXjdyXQtZLZLPcoaLMk/LDbCUy7bYziuaGYcS
         RWYYWIgDqRqSHjzFK+tVVuM7Gs7NgsI2oYhZGTBpPeZf5bcK8xLEP2RlRk5+t+v2f2
         vwR+IzOT4kOd8VbSndcZNd6v6Ip9D+DMeKiIe978FNaaBKvqQN9Dk8co6IpL4ZTCUs
         npIQnSSRN23Xg==
Date:   Tue, 15 Feb 2022 18:01:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     netdev@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Tao Liu <xliutaox@google.com>,
        John Fraker <jfraker@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2] gve: enhance no queue page list detection
Message-ID: <20220215180150.690cb60e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220215051751.260866-1-haiyue.wang@intel.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
        <20220215051751.260866-1-haiyue.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Feb 2022 13:17:49 +0800 Haiyue Wang wrote:
> The commit
> a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`")
> introduces three queue format type, only GVE_GQI_QPL_FORMAT queue has
> page list. So it should use the queue page list number to detect the
> zero size queue page list. Correct the design logic.
> 
> Using the 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero
> sized memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
> 
> The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
> address, so the driver can run successfully. Also the code still checks
> the queue page list number firstly, then accesses the allocated memory,
> so zero number queue page list allocation will not lead to access fault.
> 
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>

Applied, thanks!
