Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24D1A4B625E
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233430AbiBOFVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:21:49 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiBOFVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:21:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 425E5B16FB;
        Mon, 14 Feb 2022 21:21:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 83D5761344;
        Tue, 15 Feb 2022 05:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E653C340EC;
        Tue, 15 Feb 2022 05:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644902498;
        bh=3nzvm8Hc8Cv/PkPBIFnoenokPVnbAaYpeZRKUO1j+Cw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AHihTNrQSEwcvWy/ozFlHVc3V6afQQptSgaWjDFNoXlcmPh7CwaCJSMvqoVhlB4ia
         lXA4U8xrREUFApqobbRVglI9C/liraORGJTQ6XUWxR+vjKI7Hs+vpD3Lg8CFgiIvKo
         Cm9ngkmi9hBizl8WmpPxzOzLzeQ7ApyMKZ+G31TxZONWn0TDxeiWBo9cXtppxXcrab
         q7NchcpBZU/7aSSvso6XURBj5wPJOT5Xc1evcuyiL66GkWSXB38H9hcDM5FVzBHJ3O
         x/F4QmUaEgJQTrGw++PBTWGqq+3OI+GNKhCpUcBGYK/PnPd3ZHxhid+c1ZECwkkvJ+
         Mt5c1lxamtJoA==
Date:   Mon, 14 Feb 2022 21:21:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyue Wang <haiyue.wang@intel.com>
Cc:     netdev@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        David Awogbemila <awogbemila@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Bailey Forrest <bcf@google.com>, Tao Liu <xliutaox@google.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        John Fraker <jfraker@google.com>,
        Yangchun Fu <yangchun@google.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v1] gve: fix zero size queue page list allocation
Message-ID: <20220214212136.71e5b4c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214024134.223939-1-haiyue.wang@intel.com>
References: <20220214024134.223939-1-haiyue.wang@intel.com>
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

On Mon, 14 Feb 2022 10:41:29 +0800 Haiyue Wang wrote:
> According to the two functions 'gve_num_tx/rx_qpls', only the queue with
> GVE_GQI_QPL_FORMAT format has queue page list.
> 
> The 'queue_format == GVE_GQI_RDA_FORMAT' may lead to request zero sized
> memory allocation, like if the queue format is GVE_DQO_RDA_FORMAT.
> 
> The kernel memory subsystem will return ZERO_SIZE_PTR, which is not NULL
> address, so the driver can run successfully. Also the code still checks
> the queue page list number firstly, then accesses the allocated memory,
> so zero number queue page list allocation will not lead to access fault.
> 
> Use the queue page list number to detect no QPLs, it can avoid zero size
> queue page list memory allocation.

There's no bug here, strictly speaking, the driver will function
correctly? In that case please repost without the Fixes tag and
with [PATCH net-next] in the subject.

> Fixes: a5886ef4f4bf ("gve: Introduce per netdev `enum gve_queue_format`")
> Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
